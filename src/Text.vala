namespace CairoChart {

	/**
	 * ``CairoChart`` Text.
	 */
	public class Text {

		protected unowned Chart chart;
		protected string _text;
		protected Font _font;
		protected Cairo.TextExtents? _ext;

		/**
		 * ``Text`` string.
		 */
		public virtual string text {
			get {
				return _text;
			}
			set {
				_text = value;
				_ext = null;
			}
		}

		/**
		 * ``Text`` font style.
		 */
		public virtual Font font {
			get {
				return _font;
			}
			set {
				_font = value;
				_font.notify.connect((s, p) => {
					_ext = null;
				});
				_ext = null;
			}
		}

		/**
		 * ``Text`` color.
		 */
		public Color color = Color();

		/**
		 * Cairo ``Text`` extents.
		 */
		protected virtual Cairo.TextExtents ext {
			get {
				if (_ext == null) {
					chart.ctx.select_font_face (font.family, font.slant, font.weight);
					chart.ctx.set_font_size (font.size);
					chart.ctx.text_extents (text, out _ext);
				}
				return _ext;
			}
			protected set {
			}
		}

		/**
		 * ``Text`` width.
		 */
		public virtual double width {
			get {
				switch (font.orient) {
				case Gtk.Orientation.HORIZONTAL: return ext.width + ext.x_bearing;
				case Gtk.Orientation.VERTICAL: return ext.height;
				default: return 0;
				}
			}
			protected set {
			}
		}

		/**
		 * ``Text`` height.
		 */
		public virtual double height {
			get {
				switch (font.orient) {
				case Gtk.Orientation.HORIZONTAL: return ext.height; // + ext.x_bearing ?
				case Gtk.Orientation.VERTICAL: return ext.width;    // +- ext.y_bearing ?
				default: return 0;
				}
			}
			protected set {
			}
		}

		/**
		 * Constructs a new ``Text``.
		 * @param chart ``Chart`` instance.
		 * @param text ``Text`` string.
		 * @param font ``Text`` font style.
		 * @param color ``Text`` color.
		 */
		public Text (Chart chart,
		             string text = "",
		             Font font = new Font(),
		             Color color = Color()
		) {
			this.chart = chart;
			this.text = text;
			this.font = font;
			this.color = color;
		}

		/**
		 * Gets a copy of the ``Text``.
		 */
		public virtual Text copy () {
			var text = new Text (chart);
			text.chart = this.chart;
			text.text = this.text;
			text.font = this.font.copy();
			text._ext = this._ext;
			text.color = this.color;
			return text;
		}

		/**
		 * Show ``Text``.
		 */
		public virtual void show () {
			if (text == "") return;
			chart.ctx.select_font_face(font.family,
			                           font.slant,
			                           font.weight);
			chart.ctx.set_font_size(font.size);
			if (font.orient == Gtk.Orientation.VERTICAL) {
				chart.ctx.rotate(- GLib.Math.PI / 2);
				chart.ctx.show_text(text);
				chart.ctx.rotate(GLib.Math.PI / 2);
			} else {
				chart.ctx.show_text(text);
			}
		}
	}
}
