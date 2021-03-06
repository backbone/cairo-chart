using Cairo;

namespace CairoChart {

	/**
	 * ``Chart`` series.
	 */
	public class Series {

		protected unowned Chart chart { get; protected set; default = null; }

		/**
		 * Title of the ``Chart``.
		 */
		public Text title;

		/**
		 * ``Series`` line style.
		 */
		public LineStyle line_style = LineStyle ();

		/**
		 * 128-bit (X;Y) points.
		 */
		public Point128[] points = {};

		/**
		 * ``Marker`` style.
		 */
		public Marker marker;

		/**
		 * Sort style.
		 */
		public enum Sort {
			/**
			 * Sort by X.
			 */
			BY_X = 0,

			/**
			 * Sort by Y.
			 */
			BY_Y = 1,

			/**
			 * Do not sort points on draw().
			 */
			UNSORTED
		}

		/**
		 * Sort style.
		 */
		public Sort sort = Sort.BY_X;

		/**
		 * X-axis.
		 */
		public Axis axis_x;

		/**
		 * Y-axis.
		 */
		public Axis axis_y;

		/**
		 * ``Series`` color (set only).
		 */
		public Color color {
			protected get { return Color(); }
			set {
				line_style.color = value;
				axis_x.color = value;
				axis_y.color = value;
				axis_x.grid_style.color.red = axis_y.grid_style.color.red = value.red;
				axis_x.grid_style.color.green = axis_y.grid_style.color.green = value.green;
				axis_x.grid_style.color.blue = axis_y.grid_style.color.blue = value.blue;
			}
		}

		/**
		 * Show the ``Series`` in zoomed area or not.
		 */
		public bool zoom_show = true;

		/**
		 * Constructs a new ``Series``.
		 * @param chart ``Chart`` instance.
		 */
		public Series (Chart chart) {
			this.chart = chart;
			title = new Text(chart);
			axis_x = new Axis(chart, this, true);
			axis_y = new Axis(chart, this, false);
			this.marker = new Marker(chart);
		}

		/**
		 * Gets a copy of the ``Series``.
		 */
		public virtual Series copy () {
			var series = new Series (chart);
			series.axis_x = this.axis_x.copy ();
			series.axis_y = this.axis_y.copy ();
			series.line_style = this.line_style;
			series.marker = this.marker;
			series.points = this.points;
			series.sort = this.sort;
			series.title = this.title.copy();
			series.zoom_show = this.zoom_show;
			return series;
		}

		/**
		 * Gets screen point by real ``Series`` (X;Y) value.
		 * @param p real ``Series`` (X;Y) value.
		 */
		public virtual Point scr_pnt (Point128 p) {
			return Point(axis_x.scr_pos(p.x), axis_y.scr_pos(p.y));
		}

		/**
		 * Gets real ``Series`` (X;Y) value by plot area screen point.
		 * @param p (X;Y) screen point.
		 */
		public virtual Point128 axis_pnt (Point p) {
			return Point128 (axis_x.axis_val(p.x), axis_y.axis_val(p.y));
		}

		/**
		 * Draws the ``Series``.
		 */
		public virtual void draw () {
			var points = Math.sort_points(this, sort);
			line_style.apply(chart);
			// draw series line
			for (int i = 1; i < points.length; ++i) {
				Point c, d;
				if (Math.cut_line (
				        Point(chart.plarea.x0, chart.plarea.y0),
				        Point(chart.plarea.x1, chart.plarea.y1),
				        scr_pnt(points[i-1]),
				        scr_pnt(points[i]),
				        out c, out d)
				) {
					chart.ctx.move_to (c.x, c.y);
					chart.ctx.line_to (d.x, d.y);
				}
			}
			chart.ctx.stroke();
			for (int i = 0; i < points.length; ++i) {
				var p = scr_pnt(points[i]);
				if (Math.point_in_rect (p, chart.plarea.x0, chart.plarea.x1,
				                           chart.plarea.y0, chart.plarea.y1))
					marker.draw_at_pos(p);
			}
		}

		/**
		 * Zooms out the ``Series``.
		 */
		public virtual void zoom_out () {
				zoom_show = true;
				axis_x.zoom_out();
				axis_y.zoom_out();
		}
	}
}
