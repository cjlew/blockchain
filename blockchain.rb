require 'digest'
require 'json'
require 'uri'
require 'open-uri'
require 'set'

class Blockchain

  attr_accessor :chain, :nodes

  def initialize
    @chain = []
    @current_transactions = []

    @nodes = Set.new

    new_block(100, 1)
  end

  def new_block(proof, previous_hash = nil)
    # Creates a new Block and adds it to the chain
    block = {
      index: @chain.size + 1,
      timestamp: Time.now,
      transactions: @current_transactions,
      proof: proof,
      previous_hash: previous_hash || hash(last_block)
    }

    # Reset the current list of transactions
    @current_transactions = []

    @chain << block

    block
  end

  def new_transaction(sender, recipient, amount)
    # Adds a new transaction to the list of transactions
    @current_transactions << {
      sender: sender,
      recipient: recipient,
      amount: amount
    }

    last_block[:index] + 1

  end

  def hash(block)
    # Hashes a Block
    # We must make sure that the Dictionary is Ordered, or we'll have inconsistent hashes
      block_string = block.sort.to_h.to_json
      Digest::SHA256.hexdigest(block_string)
  end

  def last_block
    # Returns the last Block in the chain
    @chain[-1]
  end

end
