use starknet::ContractAddress;

#[starknet::interface]
pub trait IERC20MintableBurnable<TContractState> {
    fn set_writer(ref self: TContractState, writer: ContractAddress, authorized: bool);
    fn mint_to(ref self: TContractState, recipient: ContractAddress, amount: u256);
    fn burn(ref self: TContractState, amount: u256);
    fn burn_from(ref self: TContractState, account: ContractAddress, amount: u256);
}


#[starknet::interface]
pub trait IERC20<TContractState> {
    fn name(self: @TContractState) -> ByteArray;
    fn symbol(self: @TContractState) -> ByteArray;
    fn decimals(self: @TContractState) -> u8;
    fn total_supply(self: @TContractState) -> u256;
    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn mint_to(ref self: TContractState, recipient: ContractAddress, amount: u256);
    fn burn(ref self: TContractState, amount: u256);
    fn burn_from(ref self: TContractState, account: ContractAddress, amount: u256);
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
    fn transfer_from(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;
    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
    fn set_writer(ref self: TContractState, writer: ContractAddress, authorized: bool);
}
