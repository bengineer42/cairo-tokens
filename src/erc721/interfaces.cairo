use starknet::ContractAddress;

#[starknet::interface]
pub trait IERC721MintableBurnable<TContractState> {
    fn set_writer(ref self: TContractState, writer: ContractAddress, authorized: bool);
    fn mint(ref self: TContractState, to: ContractAddress, token_id: u256);
    fn burn_from(ref self: TContractState, from: ContractAddress, token_id: u256);
}
