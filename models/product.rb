class Product
  attr_accessor :id, :name, :description, :price

  def self.open_connection
    conn = PG.connect(dbname: "websitedb", user: "postgres", password: "S07792628167s")
  end

  def self.all
    conn = self.open_connection

    sql = "SELECT * FROM product ORDER BY product_id"

    results = conn.exec(sql)

    products = results.map do |data|
      self.hydrate data
  end

  return products
end

def self.hydrate product_data
    product = Product.new

    product.id = product_data["product_id"]
    product.name = product_data["name"]
    product.description = product_data["description"]
    product.price = product_data["price"]

    return product
  end

def self.find id
    conn = self.open_connection

    sql = "SELECT * FROM product WHERE product_id = #{id}"

    product = conn.exec(sql)

    return self.hydrate product[0]
  end

  def save
      conn = Product.open_connection

      if !self.id
        sql = "INSERT INTO product (name, description, price) VALUES ('#{self.name}', '#{self.description}', '#{self.price}')"
      else
        sql = "UPDATE product SET name='#{self.name}', description='#{self.description}', price='#{self.price}' WHERE product_id = #{self.id}"
      end
      conn.exec(sql)
    end

    def self.destroy id
    conn = self.open_connection

    sql = "DELETE FROM product WHERE product_id = #{id}"

    conn.exec(sql)

end

end
