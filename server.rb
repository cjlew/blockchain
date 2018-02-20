require './blockchain'
require 'sinatra'
require 'json'
require 'securerandom'


blockchain = Blockchain.new

node_identifier = SecureRandom.uuid.gsub('-', '')

get '/mine' do
  # We run the proof of work algorithm to get the next proof...
  last_block = blockchain.last_block
  last_proof = last_block[:proof]
  proof = blockchain.proof_of_work(last_proof)

  # We must receive a reward for finding the proof.
  # The sender is "0" to signify that this node has mined a new coin.
  blockchain.new_transaction("0", node_identifier, 1)

  # Forge the new Block by adding it to the chain
  previous_hash = blockchain.hash(last_block)
  block = blockchain.new_block(proof, previous_hash)

  response = {
        message: "New Block Forged",
        index: block[:index],
        transactions: block[:transactions],
        proof: block[:proof],
        previous_hash: block[:previous_hash]
    }

  status 200
  body response.to_json
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
        :chain => blockchain.chain,
        :length => blockchain.chain.size
    }

    status 200
    body response.to_json
end
