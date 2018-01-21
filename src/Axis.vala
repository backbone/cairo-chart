namespace CairoChart {
	// If one of axis:title or axis:range.min/range.max are different
	// then draw separate axis for each/all series
	// or specify series name near the axis
	public class Axis {
		public Range range = new Range();
		Chart chart;
		public Text title;
		public enum Type {
			NUMBERS = 0,
			DATE_TIME
		}
		public enum ScaleType {
			LINEAR = 0,		// default
			// LOGARITHMIC, // TODO
			// etc
		}
		public Type type;
		public ScaleType scale_type;
		public enum Position {
			LOW = 0,
			HIGH = 1,
			BOTH = 2
		}
		public Position position = Position.LOW;

		string _format = "%.2Lf";
		string _date_format = "%Y.%m.%d";
		string _time_format = "%H:%M:%S";
		int _dsec_signs = 2; // 2 signs = centiseconds
		public string format {
			get { return _format; }
			set {
				// TODO: check format
				_format = value;
			}
			default = "%.2Lf";
		}
		public string date_format {
			get { return _date_format; }
			set {
				// TODO: check format
				_date_format = value;
			}
			default = "%Y.%m.%d";
		}
		public string time_format {
			get { return _time_format; }
			set {
				// TODO: check format
				_time_format = value;
			}
			default = "%H:%M:%S";
		}
		public int dsec_signs {
			get { return _dsec_signs; }
			set {
				// TODO: check format
				_dsec_signs = value;
			}
			default = 2;
		}
		public Font font_style = Font ();
		public Color color = Color ();
		public LineStyle line_style = LineStyle ();
		public double font_spacing = 5;

		public virtual Axis copy () {
			var axis = new Axis (chart);
			axis._date_format = this._date_format;
			axis._dsec_signs = this._dsec_signs;
			axis._format = this._format;
			axis._time_format = this._time_format;
			axis.color = this.color;
			axis.font_spacing = this.font_spacing;
			axis.font_style = this.font_style;
			axis.line_style = this.line_style;
			axis.range.max = this.range.max;
			axis.range.min = this.range.min;
			axis.position = this.position;
			axis.scale_type = this.scale_type;
			axis.title = this.title.copy();
			axis.type = this.type;
			axis.nrecords = this.nrecords;
			return axis;
		}

		public Axis (Chart chart) {
			this.chart = chart;
			title = new Text (chart, "");
		}

		public int nrecords = 128;

		public virtual void format_date_time (Float128 x, out string date, out string time) {
			date = time = "";
			var dt = new DateTime.from_unix_utc((int64)x);
			date = dt.format(date_format);
			var dsec_str =
				("%."+(dsec_signs.to_string())+"Lf").printf((LongDouble)(x - (int64)x)).offset(1);
			time = dt.format(time_format) + dsec_str;
		}

		public virtual void calc_rec_sizes (Chart chart, out double max_rec_width, out double max_rec_height, bool horizontal = true) {
			max_rec_width = max_rec_height = 0;
			for (var i = 0; i < nrecords; ++i) {
				Float128 x = (int64)(range.zmin + range.zrange / nrecords * i) + 1.0/3.0;
				switch (type) {
				case Axis.Type.NUMBERS:
					var text = new Text (chart, format.printf((LongDouble)x) + (horizontal ? "_" : ""), font_style);
					var sz = text.size;
					max_rec_width = double.max (max_rec_width, sz.width);
					max_rec_height = double.max (max_rec_height, sz.height);
					break;
				case Axis.Type.DATE_TIME:
					string date, time;
					format_date_time(x, out date, out time);

					var h = 0.0;
					if (date_format != "") {
						var text = new Text (chart, date + (horizontal ? "_" : ""), font_style);
						var sz = text.size;
						max_rec_width = double.max (max_rec_width, sz.width);
						h = sz.height;
					}
					if (time_format != "") {
						var text = new Text (chart, time + (horizontal ? "_" : ""), font_style);
						var sz = text.size;
						max_rec_width = double.max (max_rec_width, sz.width);
						h += sz.height;
					}
					max_rec_height = double.max (max_rec_height, h);
					break;
				}
			}
		}

		public virtual void unzoom () {
			range.unzoom();
		}
	}
}
