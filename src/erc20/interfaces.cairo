use starknet::ContractAddress;

#[starknet::interface]
pub trait IERC20MintableBurnable<TContractState> {
    fn set_writer(ref self: TContractState, writer: ContractAddress, authorized: bool);
    fn mint(ref self: TContractState, recipient: ContractAddress, amount: u256);
    fn burn_from(ref self: TContractState, account: ContractAddress, amount: u256);
}
