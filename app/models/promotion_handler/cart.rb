module PromotionHandler
  # Decides which promotion should be activated given the current order context
  #
  # By activated it doesn't necessarily mean that the order will have a
  # discount for every activated promotion. It means that the discount will be
  # created and might eventually become eligible. The intention here is to
  # reduce overhead. e.g. a promotion that requires item A to be eligible
  # shouldn't be eligible unless item A is added to the order.
  #
  # It can be used as a wrapper for custom handlers as well. Different
  # applications might have completely different requirements to make
  # the promotions system accurate and performant. Here they can plug custom
  # handler to activate promos as they wish once an item is added to cart
  class Cart
    attr_reader :order_item, :order
    attr_accessor :error, :success

    def initialize(order, order_item=nil)
      @order, @order_item = order, order_item
    end

    def activate
      promotions.each do |promotion|
        if (order_item && promotion.eligible?(order_item)) || promotion.eligible?(order)
          promotion.activate(order_item: order_item, order: order)
        end
      end
    end

    private

    def promotions
      # AR cannot bind raw ASTs to prepared statements. There always must be a manager around.
      # Also Postgresql requires an aliased table for `SELECT * FROM (subexpression) AS alias`.
      # And Sqlite3 cannot work on outher parenthesis from `(left UNION right)`.
      # So this construct makes both happy.
      # select = Arel::SelectManager.new(
      #   Promotion,
      #   Promotion.arel_table.create_table_alias(
      #     order.promotions.active.union(Promotion.active.where(code: nil, path: nil)),
      #     Promotion.table_name
      #   ),
      # )
      # select.project(Arel.star)

      # Promotion.find_by_sql(
      #   select,
      #   order.promotions.bind_values
      # )

      @promotions ||= Promotion.active_for_vendor(order.vendor)
    end
  end
end
