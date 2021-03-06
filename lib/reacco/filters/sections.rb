module Reacco
  module Filters
    module Sections
      # Wraps in sections.
      def section_wrap(html)
        headings = %w(h1 h2 h3 h4 h5)
        headings.each do |h|
          nodes = html.css(h)
          nodes.each do |alpha|
            # For those affected by --hgroup, don't bother.
            next  if alpha.ancestors.any? { |tag| tag.name == 'hgroup' }
            next  unless alpha.parent

            # Find the boundary, and get the nodes until that one.
            omega         = from_x_until(alpha, *headings[0..headings.index(alpha.name)])
            section_nodes = between(alpha, omega)

            # Create the <section>.
            section = Nokogiri::XML::Node.new('section', html)
            section['class'] = "#{alpha['class']} #{h} #{slugify alpha.content}"
            alpha.add_previous_sibling(section)
            section_nodes.each { |tag| section.add_child tag }
          end
        end

        html
      end

    private
      def from_x_until(alpha, *names)
        omega = nil
        n = alpha

        while true
          n = n.next_sibling
          break if n.nil?

          name = n.name
          if name == 'section'
            name = (h = n.at_css('h1, h2, h3, h4, h5, h6')) && h.name
          end
          break if !name || names.include?(name)
          omega = n
        end

        omega
      end

      def between(first, last)
        nodes   = Array.new
        started = false

        first.parent.children.each do |node|
          started = true  if node == first
          nodes << node  if started
          break  if node == last
        end

        nodes
      end
    end
  end
end
