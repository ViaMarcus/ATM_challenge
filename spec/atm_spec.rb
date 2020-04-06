require './lib/atm.rb'
require 'date'
describe Atm do
    let(:account) {instance_double('Account', pin_code: '1234')}

    before do 
        #before test, add attr balance to account
        allow(account).to receive(:balance).and_return(100)
        #Also allow to set balance with method
        allow(account).to receive(:balance=)
    end

    it 'allow withdrawal if the account has enough balance' do
        #fix more later
        expected_output = { status: true, message: 'success', date: Date.today, amount: 45 }
        #check that happy path works
        expect(subject.withdraw(45,'1234',account)).to eq expected_output
    end

    it 'rejects withdrawal if account has insuffient funds' do
        expected_output = { status: false, message: 'insufficient funds', date: Date.today}
        expect(subject.withdraw(105, '1234', account)).to eq expected_output
    end

    it 'has €1000 on initialize' do
        expect(subject.funds).to eq 1000
    end
    it 'funds are reduced at withdraw' do
        subject.withdraw(50, '1234', account)
        expect(subject.funds).to eq 950
    end

    it 'reject withdraw if ATM has insufficient funds' do
        subject.funds = 50
        expected_output = { status: false, message: 'insufficient funds in ATM', date: Date.today }
        expect(subject.withdraw(100,'1234', account)).to eq expected_output
    end

    it 'reject withdraw when pin code is incorrect' do
        expected_output = { status: false, message: 'Wrong pin', date: Date.today }
        expect(subject.withdraw(50,'9999',account)).to eq expected_output
    end
end
