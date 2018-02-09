require './blockchain'
require 'sinatra'
require 'json'
require './json_ext'
require 'securerandom'


blockchain = Blockchain.new

node_identifier = SecureRandom.uuid.gsub('-', '')

get '/mine' do
  return "We'll mine a new Block"
end

post '/transactions/new' do
  request_body = request.body.read
  values = JSON.parse(request_body)
  # Check that the required fields are in the POST'ed data
  required = ['sender', 'recipient', 'amount']

  if !required.all? { |s| values.key?(s) }
    status(400)
    body = { message: 'Error: Missing values' }.to_json
    return
  end

  index = blockchain.new_transaction(values['sender'], values['recipient'], values['amount'])

  response = { message: "Transaction will be added to Block #{index}" }

  status 201
  body response.to_json
end

get '/chain' do
  response = {
        chain: blockchain.chain,
        length: len(blockchain.chain),
    }
  status 200
  body response.to_json
end
