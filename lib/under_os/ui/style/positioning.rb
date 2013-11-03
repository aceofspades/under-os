#
# This module contains things like positions and sizes of the elements
#
module UnderOs::UI
  class Style
    module Positioning
      def width
        @view.frame.size.width
      end

      def width=(width)
        @view.frame = [[left, top], [convert_size(width, :x), height]]
      end

      def height
        @view.frame.size.height
      end

      def height=(height)
        @view.frame = [[left, top], [width, convert_size(height, :y)]]
      end

      def top
        @view.frame.origin.y
      end

      def top=(top)
        @view.frame = [[left, convert_size(top, :y)], [width, height]]
      end

      def left
        @view.frame.origin.x
      end

      def left=(left)
        @view.frame = [[convert_size(left, :x), top], [width, height]]
      end

      def right
        parent_size.x - left
      end

      def right=(right)
        @view.frame = [[parent_size[:x] - convert_size(right, :x) - width, top], [width, height]]
      end

      def bottom
        parent_size.y - top
      end

      def bottom=(bottom)
        @view.frame = [[left, parent_size[:y] - convert_size(bottom, :y) - height], [width, height]]
      end

      def contentWidth
        @view.contentSize.width rescue 0
      end

      def contentWidth=(value)
        return unless @view.is_a?(UIScrollView)

        if value == 'auto'
          value = 0
          @view.subviews.each do |view|
            x = view.origin.x + view.size.width
            value = x if x > value
          end
        end

        @view.contentSize = CGSizeMake(value, contentHeight)
      end

      def contentHeight
        @view.contentSize.height rescue 0
      end

      def contentHeight=(value)
        return unless @view.is_a?(UIScrollView)

        if value == 'auto'
          value = 0
          @view.subviews.each do |view|
            y = view.origin.y + view.size.height
            value = y if y > value
          end
        end

        @view.contentSize = CGSizeMake(contentWidth, value)
      end

      def zIndex
        @view.layer.zPosition
      end

      def zIndex=(number)
        @view.layer.zPosition = number
      end

    private

      def convert_size(size, dim)
        if size.is_a?(String)
          if size.ends_with?('%')
            size = size.slice(0, size.size-1).to_f
            size = parent_size[dim] / 100.0 * size
          end
        end

        size
      end

      def parent_size
        parent = view.superview
        parent = parent.superview ? parent.frame : UIScreen.mainScreen.bounds

        {x: parent.size.width, y: parent.size.height}
      end
    end
  end
end
