namespace CairoChart {

	/**
	 * ``Font`` style.
	 */
	[Compact]
	public class Font : Object {

		/**
		 * A font family name, encoded in UTF-8.
		 */
		public virtual string family { get; set; }

		/**
		 * The new font size, in user space units.
		 */
		public virtual double size { get; set; }

		/**
		 * The slant for the font.
		 */
		public virtual Cairo.FontSlant slant { get; set; }

		/**
		 * The weight for the font.
		 */
		public virtual Cairo.FontWeight weight { get; set; }

		/**
		 * Font/Text orientation.
		 */
		public virtual Gtk.Orientation orient { get; set; }

		/**
		 * Constructs a new ``Font``.
		 * @param family a font family name, encoded in UTF-8.
		 * @param size the new font size, in user space units.
		 * @param slant the slant for the font.
		 * @param weight the weight for the font.
		 * @param orient font/text orientation.
		 */
		public Font (string family = "Sans",
		             double size = 10,
		             Cairo.FontSlant slant = Cairo.FontSlant.NORMAL,
		             Cairo.FontWeight weight = Cairo.FontWeight.NORMAL,
		             Gtk.Orientation orient = Gtk.Orientation.HORIZONTAL
		) {
			this.family = family;
			this.size = size;
			this.slant = slant;
			this.weight = weight;
			this.orient = orient;
		}

		/**
		 * Gets a copy of the ``Font``.
		 */
		public virtual Font copy () {
			return new Font(family, size, slant, weight, orient);
		}
	}
}
