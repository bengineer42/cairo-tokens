#[starknet::contract]
mod erc20_mintable_burnable {
    use openzeppelin_token::erc20::{ERC20Component, ERC20HooksEmptyImpl, interface::IERC20Metadata};
    use starknet::{
        ContractAddress, get_caller_address,
        storage::{StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map}
    };
    use tokens::erc20::interfaces::IERC20MintableBurnable;

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    // ERC20 Mixin
    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    impl ERC20CamelOnlyImpl = ERC20Component::ERC20CamelOnlyImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        owner: ContractAddress,
        writers: Map<ContractAddress, bool>,
        decimals: u8,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        decimals: u8,
        owner: ContractAddress
    ) {
        self.erc20.initializer(name, symbol);
        self.decimals.write(decimals);
        self.owner.write(owner);
    }

    #[abi(embed_v0)]
    impl ERC20MetadataImpl of IERC20Metadata<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            self.erc20.name()
        }

        fn symbol(self: @ContractState) -> ByteArray {
            self.erc20.symbol()
        }

        fn decimals(self: @ContractState) -> u8 {
            self.decimals.read()
        }
    }

    #[abi(embed_v0)]
    impl ERC20MintableBurnableImpl of IERC20MintableBurnable<ContractState> {
        fn set_writer(ref self: ContractState, writer: ContractAddress, authorized: bool) {
            assert(self.owner.read() == get_caller_address(), 'ERC20: unauthorized caller');
            self.writers.entry(writer).write(authorized);
        }
        fn mint_to(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            assert(self.writers.entry(get_caller_address()).read(), 'ERC20: unauthorized caller');
            self.erc20.mint(recipient, amount);
        }
        fn burn(ref self: ContractState, amount: u256) {
            self.erc20.burn(get_caller_address(), amount);
        }
        fn burn_from(ref self: ContractState, account: ContractAddress, amount: u256) {
            self.erc20._spend_allowance(get_caller_address(), account, amount);
            self.erc20.burn(account, amount);
        }
    }
}
