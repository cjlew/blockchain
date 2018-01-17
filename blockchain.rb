class Blockchain

  attr_accessor :chain, :nodes

  def initialize
    @chain = []
    @current_transactions = []
  end

  def new_block
    # Creates a new Block and adds it to the chain

  end

  def new_transaction
    # Adds a new transaction to the list of transactions

  end

  def hash(block)
    # Hashes a Block

  end

  def last_block
    # Returns the last Block in the chain
    
  end

end
