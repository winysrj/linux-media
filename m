Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46471 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab2B0Pik (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 10:38:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 32/33] smiapp: Add driver.
Date: Mon, 27 Feb 2012 16:38:49 +0100
Message-ID: <2925645.UTNbXqr535@avalon>
In-Reply-To: <1329703032-31314-32-git-send-email-sakari.ailus@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-32-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 20 February 2012 03:57:11 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> 
> Add driver for SMIA++/SMIA image sensors. The driver exposes the sensor as
> three subdevs, pixel array, binner and scaler --- in case the device has a
> scaler.
> 
> Currently it relies on the board code for external clock handling. There is
> no fast way out of this dependency before the ISP drivers (omap3isp) among
> others will be able to export that clock through the clock framework
> instead.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

[snip]

> diff --git a/drivers/media/video/smiapp/Kconfig
> b/drivers/media/video/smiapp/Kconfig new file mode 100644
> index 0000000..3f98e8e
> --- /dev/null
> +++ b/drivers/media/video/smiapp/Kconfig
> @@ -0,0 +1,12 @@
> +config VIDEO_SMIAPP
> +	tristate "SMIA++/SMIA sensor support"
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER

VIDEO_V4L2_SUBDEV_API depends on MEDIA_CONTROLLER, you don't have to set the
dependency explicitly.

> +	---help---
> +	  This is a generic driver for SMIA++/SMIA camera modules.
> +
> +config VIDEO_SMIAPP_DEBUG
> +	bool "Enable debugging for the generic SMIA++/SMIA driver"
> +	depends on VIDEO_SMIAPP
> +	---help---
> +	  Enable debugging output in the generic SMIA++/SMIA driver. If you
> +	  are developing the driver you might want to enable this.

[snip]

> diff --git a/drivers/media/video/smiapp/smiapp-core.c
> b/drivers/media/video/smiapp/smiapp-core.c new file mode 100644
> index 0000000..9fd08a1
> --- /dev/null
> +++ b/drivers/media/video/smiapp/smiapp-core.c

[snip]

> +#define SMIAPP_ALIGN_DIM(dim, flags)	      \
> +	(flags & V4L2_SUBDEV_SEL_FLAG_SIZE_GE \
> +	 ? ALIGN(dim, 2)		      \
> +	 : dim & ~1)

Please enclose dim in parenthesis in the macro definition.

> +
> +/*
> + * smiapp_module_idents - supported camera modules
> + */
> +static const struct smiapp_module_ident smiapp_module_idents[] = {
> +	SMIAPP_IDENT_LQ(0x10, 0x4141, -1, "jt8ev1", &smiapp_jt8ev1_quirk),
> +	SMIAPP_IDENT_LQ(0x10, 0x4241, -1, "imx125es", &smiapp_imx125es_quirk),
> +	SMIAPP_IDENT_L(0x01, 0x022b, -1, "vs6555"),
> +	SMIAPP_IDENT_L(0x0c, 0x208a, -1, "tcm8330md"),
> +	SMIAPP_IDENT_L(0x01, 0x022e, -1, "vw6558"),
> +	SMIAPP_IDENT_LQ(0x0c, 0x2134, -1, "tcm8500md", &smiapp_tcm8500md_quirk),
> +	SMIAPP_IDENT_L(0x07, 0x7698, -1, "ovm7698"),
> +	SMIAPP_IDENT_L(0x0b, 0x4242, -1, "smiapp-003"),
> +	SMIAPP_IDENT_LQ(0x0c, 0x560f, -1, "jt8ew9", &smiapp_jt8ew9_quirk),
> +	SMIAPP_IDENT_L(0x0c, 0x213e, -1, "et8en2"),
> +	SMIAPP_IDENT_L(0x0c, 0x2184, -1, "tcm8580md"),
> +};

What about sorting those either by ID or name ?

> +
> +/*
> + *
> + * Dynamic Capability Identification
> + *
> + */
> +
> +static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	u32 fmt_model_type, fmt_model_subtype, ncol_desc, nrow_desc;
> +	int i;
> +	int rval;
> +	int line_count = 0;
> +	int embedded_start = -1, embedded_end = -1;
> +	int image_start = 0;
> +
> +	rval = smia_i2c_read_reg(client,
> +				 SMIAPP_REG_U8_FRAME_FORMAT_MODEL_TYPE,
> +				 &fmt_model_type);
> +	if (rval)
> +		return rval;
> +
> +	rval = smia_i2c_read_reg(client,
> +				 SMIAPP_REG_U8_FRAME_FORMAT_MODEL_SUBTYPE,
> +				 &fmt_model_subtype);
> +	if (rval)
> +		return rval;
> +
> +	ncol_desc = (fmt_model_subtype
> +		     & SMIAPP_FRAME_FORMAT_MODEL_SUBTYPE_NCOLS_MASK)
> +		>> SMIAPP_FRAME_FORMAT_MODEL_SUBTYPE_NCOLS_SHIFT;
> +	nrow_desc = (fmt_model_subtype
> +		     & SMIAPP_FRAME_FORMAT_MODEL_SUBTYPE_NROWS_MASK);

No need for parenthesis.

> +
> +	dev_dbg(&client->dev, "format_model_type %s\n",
> +		fmt_model_type == SMIAPP_FRAME_FORMAT_MODEL_TYPE_2BYTE
> +		? "2 byte" :
> +		fmt_model_type == SMIAPP_FRAME_FORMAT_MODEL_TYPE_4BYTE
> +		? "4 byte" : "is simply bad");

Simply ? :-)

> +
> +	for (i = 0; i < ncol_desc + nrow_desc; i++) {
> +		u32 desc;
> +		u32 pixelcode;
> +		u32 pixels;
> +		char *which;
> +		char *what;
> +
> +		if (fmt_model_type == SMIAPP_FRAME_FORMAT_MODEL_TYPE_2BYTE) {
> +			rval = smia_i2c_read_reg(
> +				client,
> +				SMIAPP_REG_U16_FRAME_FORMAT_DESCRIPTOR_2(i),
> +				&desc);
> +			if (rval)
> +				return rval;
> +
> +			pixelcode =
> +				(desc
> +				 & SMIAPP_FRAME_FORMAT_DESC_2_PIXELCODE_MASK)
> +				>> SMIAPP_FRAME_FORMAT_DESC_2_PIXELCODE_SHIFT;
> +			pixels = desc & SMIAPP_FRAME_FORMAT_DESC_2_PIXELS_MASK;
> +		} else if (fmt_model_type
> +			   == SMIAPP_FRAME_FORMAT_MODEL_TYPE_4BYTE) {
> +			rval = smia_i2c_read_reg(
> +				client,
> +				SMIAPP_REG_U32_FRAME_FORMAT_DESCRIPTOR_4(i),
> +				&desc);
> +			if (rval)
> +				return rval;
> +
> +			pixelcode =
> +				(desc
> +				 & SMIAPP_FRAME_FORMAT_DESC_4_PIXELCODE_MASK)
> +				>> SMIAPP_FRAME_FORMAT_DESC_4_PIXELCODE_SHIFT;
> +			pixels = desc & SMIAPP_FRAME_FORMAT_DESC_4_PIXELS_MASK;
> +		} else {
> +			dev_dbg(&client->dev,
> +				"invalid frame format model type %d\n",
> +				fmt_model_type);
> +			return -EINVAL;
> +		}
> +
> +		if (i < ncol_desc)
> +			which = "columns";
> +		else
> +			which = "rows";
> +
> +		switch (pixelcode) {
> +		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_EMBEDDED:
> +			what = "embedded";
> +			break;
> +		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_DUMMY:
> +			what = "dummy";
> +			break;
> +		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_BLACK:
> +			what = "black";
> +			break;
> +		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_DARK:
> +			what = "dark";
> +			break;
> +		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_VISIBLE:
> +			what = "visible";
> +			break;
> +		default:
> +			what = "invalid";
> +			dev_dbg(&client->dev, "pixelcode %d\n", pixelcode);
> +			break;
> +		}
> +
> +		dev_dbg(&client->dev, "%s pixels: %d %s\n",
> +			what, pixels, which);
> +
> +		if (i < ncol_desc)
> +			continue;
> +
> +		/* Handle row descriptors */
> +		if (pixelcode
> +		    == SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_EMBEDDED) {
> +			embedded_start = line_count;
> +		} else {
> +			if (pixelcode
> +			    == SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_VISIBLE
> +			    || pixels
> +			    >= sensor->limits[
> +				    SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES] / 2) {

I'm not a huge fan of lines larger than 80 columns, but it would make sense
here. This is hard to read. An option would be to shorten all the constants a
bit.

> +				image_start = line_count;
> +			}
> +			if (embedded_start != -1 && embedded_end == -1)
> +				embedded_end = line_count;
> +		}
> +		line_count += pixels;
> +	}
> +
> +	if (embedded_start == -1 || embedded_end == -1)
> +		embedded_start = embedded_end = 0;

One assignment per line please.

> +
> +	dev_dbg(&client->dev, "embedded data from lines %d to %d\n",
> +		embedded_start, embedded_end);
> +	dev_dbg(&client->dev, "image data starts at line %d\n", image_start);
> +
> +	return 0;
> +}
> +
> +/*
> + *
> + * V4L2 Controls handling
> + *
> + */
> +
> +static void __smiapp_update_exposure_limits(struct smiapp_sensor *sensor)
> +{
> +	struct v4l2_ctrl *ctrl = sensor->exposure;
> +	int max;
> +
> +	max = sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].height
> +		+ sensor->vblank->val -
> +		sensor->limits[SMIAPP_LIMIT_COARSE_INTEGRATION_TIME_MAX_MARGIN];

Just for reference, I would have found

	max = sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].height
	    + sensor->vblank->val
	    - sensor->limits[SMIAPP_LIMIT_COARSE_INTEGRATION_TIME_MAX_MARGIN];

to be more readable, but it's obviously your call.

> +
> +	ctrl->maximum = max;
> +	if (ctrl->default_value > max)
> +		ctrl->default_value = max;
> +	if (ctrl->val > max)
> +		ctrl->val = max;
> +	if (ctrl->cur.val > max)
> +		ctrl->cur.val = max;
> +}
> +
> +/*
> + * Order matters.
> + *
> + * 1. Bits-per-pixel, descending.
> + * 2. Bits-per-pixel compressed, descending.
> + * 3. Pixel order, same as in pixel_order_str. Formats for all four pixel
> + *    orders must be defined.
> + */
> +static const struct smiapp_csi_data_format smiapp_csi_data_formats[] = {
> +	{ V4L2_MBUS_FMT_SGRBG12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_GRBG, },
> +	{ V4L2_MBUS_FMT_SRGGB12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_RGGB, },
> +	{ V4L2_MBUS_FMT_SBGGR12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_BGGR, },
> +	{ V4L2_MBUS_FMT_SGBRG12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_GBRG, },
> +	{ V4L2_MBUS_FMT_SGRBG10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_GRBG, },
> +	{ V4L2_MBUS_FMT_SRGGB10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_RGGB, },
> +	{ V4L2_MBUS_FMT_SBGGR10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_BGGR, },
> +	{ V4L2_MBUS_FMT_SGBRG10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_GBRG, },
> +	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_GRBG, },
> +	{ V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_RGGB, },
> +	{ V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_BGGR, },
> +	{ V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_GBRG, },
> +};
> +
> +const char *pixel_order_str[] = { "GRBG", "RGGB", "BGGR", "GBRG" };
> +
> +#define to_csi_format_idx(fmt) (((unsigned long)(fmt)			\
> +				 - (unsigned long)smiapp_csi_data_formats) \
> +				/ sizeof(*smiapp_csi_data_formats))
> +
> +static void smiapp_update_mbus_formats(struct smiapp_sensor *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	int csi_format_idx = to_csi_format_idx(sensor->csi_format) & ~3;
> +	int internal_csi_format_idx =
> +		to_csi_format_idx(sensor->internal_csi_format) & ~3;
> +	int flip = 0;
> +	int pixel_order;

Here again shortening names a bit might help.

> +
> +	if (sensor->hflip) {
> +		if (sensor->hflip->val)
> +			flip |= SMIAPP_IMAGE_ORIENTATION_HFLIP;
> +
> +		if (sensor->vflip->val)
> +			flip |= SMIAPP_IMAGE_ORIENTATION_VFLIP;
> +	}
> +
> +	flip ^= sensor->hvflip_inv_mask;
> +
> +	pixel_order = sensor->default_pixel_order ^ flip;
> +
> +	sensor->mbus_frame_fmts =
> +		sensor->default_mbus_frame_fmts << pixel_order;
> +	sensor->csi_format =
> +		&smiapp_csi_data_formats[csi_format_idx + pixel_order];
> +	sensor->internal_csi_format =
> +		&smiapp_csi_data_formats[internal_csi_format_idx
> +					 + pixel_order];
> +
> +	BUG_ON(max(internal_csi_format_idx, csi_format_idx) + pixel_order
> +	       >= ARRAY_SIZE(smiapp_csi_data_formats));
> +	BUG_ON(min(internal_csi_format_idx, csi_format_idx) < 0);
> +
> +	dev_dbg(&client->dev, "flip %d; new pixel order %s\n",
> +		flip, pixel_order_str[pixel_order]);
> +}
> +
> +static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct smiapp_sensor *sensor =
> +		container_of(ctrl->handler, struct smiapp_subdev, ctrl_handler)
> +			->sensor;
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	u32 orient;
> +	int exposure;
> +	int rval = 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_ANALOGUE_GAIN:
> +		return smia_i2c_write_reg(
> +			client,
> +			SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_GLOBAL, ctrl->val);
> +
> +	case V4L2_CID_EXPOSURE:
> +		return smia_i2c_write_reg(
> +			client,
> +			SMIAPP_REG_U16_COARSE_INTEGRATION_TIME, ctrl->val);
> +
> +	case V4L2_CID_HFLIP:
> +	case V4L2_CID_VFLIP:
> +		orient = 0;

You can move this line after the streaming check.

> +
> +		if (sensor->streaming)
> +			return -EBUSY;
> +
> +		if (sensor->hflip->val)
> +			orient |= SMIAPP_IMAGE_ORIENTATION_HFLIP;
> +
> +		if (sensor->vflip->val)
> +			orient |= SMIAPP_IMAGE_ORIENTATION_VFLIP;
> +
> +		orient ^= sensor->hvflip_inv_mask;
> +		rval = smia_i2c_write_reg(client,
> +					  SMIAPP_REG_U8_IMAGE_ORIENTATION,
> +					  orient);
> +		if (rval < 0)
> +			return rval;
> +
> +		smiapp_update_mbus_formats(sensor);
> +
> +		return 0;
> +
> +	case V4L2_CID_VBLANK:
> +		exposure = sensor->exposure->val;
> +
> +		__smiapp_update_exposure_limits(sensor);
> +
> +		if (exposure > sensor->exposure->maximum) {
> +			sensor->exposure->val =
> +				sensor->exposure->maximum;
> +			rval = smiapp_set_ctrl(
> +				sensor->exposure);

Shouldn't you call the V4L2 control API here instead ? Otherwise no control
change event will be generated for the exposure time. Will this work as
expected if the user sets the exposure time in the same VIDIOC_S_EXT_CTRLS
call ?

> +		}
> +
> +		if (rval < 0)
> +			return rval;

If you moved this check inside the if you wouldn't have to initialize rval to
0 above.

> +
> +		return smia_i2c_write_reg(
> +			client, SMIAPP_REG_U16_FRAME_LENGTH_LINES,
> +			sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].height
> +			+ ctrl->val);
> +
> +	case V4L2_CID_HBLANK:
> +		return smia_i2c_write_reg(
> +			client, SMIAPP_REG_U16_LINE_LENGTH_PCK,
> +			sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].width
> +			+ ctrl->val);
> +
> +	case V4L2_CID_LINK_FREQ:
> +		if (sensor->streaming)
> +			return -EBUSY;
> +
> +		return smiapp_pll_update(sensor);
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static const struct v4l2_ctrl_ops smiapp_ctrl_ops = {
> +	.s_ctrl = smiapp_set_ctrl,
> +};
> +
> +static int smiapp_init_controls(struct smiapp_sensor *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	struct v4l2_ctrl_config cfg;
> +	int rval;
> +
> +	rval = v4l2_ctrl_handler_init(&sensor->pixel_array->ctrl_handler, 7);
> +	if (rval)
> +		return rval;
> +	sensor->pixel_array->ctrl_handler.lock = &sensor->mutex;
> +
> +	sensor->analog_gain = v4l2_ctrl_new_std(
> +		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
> +		V4L2_CID_ANALOGUE_GAIN,
> +		sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MIN],
> +		sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MAX],
> +		max_t(int,
> +		      sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_STEP], 1),

Won't max() work ? You might have to use 1U though.

> +		sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MIN]);
> +
> +	sensor->exposure = v4l2_ctrl_new_std(
> +		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
> +		V4L2_CID_EXPOSURE,
> +		sensor->limits[SMIAPP_LIMIT_COARSE_INTEGRATION_TIME_MIN],
> +		sensor->limits[SMIAPP_LIMIT_COARSE_INTEGRATION_TIME_MIN], 1,
> +		sensor->limits[SMIAPP_LIMIT_COARSE_INTEGRATION_TIME_MIN]);

Maybe a short comment explaining where this (and other controls below) will be
updated would help future readers to figure out why maximum == minimum.

> +
> +	sensor->hflip = v4l2_ctrl_new_std(
> +		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
> +		V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	sensor->vflip = v4l2_ctrl_new_std(
> +		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
> +		V4L2_CID_VFLIP, 0, 1, 1, 0);
> +
> +	sensor->vblank = v4l2_ctrl_new_std(
> +		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
> +		V4L2_CID_VBLANK, 0, 1, 1, 0);
> +
> +	if (sensor->vblank)
> +		sensor->vblank->flags |= V4L2_CTRL_FLAG_UPDATE;
> +
> +	sensor->hblank = v4l2_ctrl_new_std(
> +		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
> +		V4L2_CID_HBLANK, 0, 1, 1, 0);
> +
> +	if (sensor->hblank)
> +		sensor->hblank->flags |= V4L2_CTRL_FLAG_UPDATE;
> +
> +	sensor->pixel_rate_parray = v4l2_ctrl_new_std(
> +		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
> +		V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
> +
> +	if (sensor->pixel_array->ctrl_handler.error) {
> +		dev_err(&client->dev,
> +			"pixel array controls initialization failed (%d)\n",
> +			sensor->pixel_array->ctrl_handler.error);

Shouldn't you call v4l2_ctrl_handler_free() here ?

> +		return sensor->pixel_array->ctrl_handler.error;
> +	}
> +
> +	sensor->pixel_array->sd.ctrl_handler =
> +		&sensor->pixel_array->ctrl_handler;
> +
> +	v4l2_ctrl_cluster(2, &sensor->hflip);

Shouldn't you move this before the control handler check ?

> +
> +	rval = v4l2_ctrl_handler_init(&sensor->binner->ctrl_handler, 0);
> +	if (rval)
> +		return rval;

The pixel array control handler won't be freed if this fails. Same for the
other error cases below.

> +	sensor->binner->ctrl_handler.lock = &sensor->mutex;

Just curious, what's the point in having an empty control handler ? Same
question for the scaler. Is it because sensor->src will end up pointing to
either the binner or scaler ? Maybe you could then just initialize
sensor->src->ctrl_handler then.

> +
> +	if (sensor->scaler) {
> +		rval = v4l2_ctrl_handler_init(&sensor->scaler->ctrl_handler, 0);
> +		if (rval)
> +			return rval;
> +		sensor->scaler->ctrl_handler.lock = &sensor->mutex;
> +	}
> +
> +	memset(&cfg, 0, sizeof(cfg));
> +
> +	cfg.ops = &smiapp_ctrl_ops;
> +	cfg.id = V4L2_CID_LINK_FREQ;
> +	cfg.type = V4L2_CTRL_TYPE_INTEGER_MENU;
> +	while (sensor->platform_data->op_sys_clock[cfg.max])
> +		cfg.max++;
> +	cfg.max--;

Maybe

	while (sensor->platform_data->op_sys_clock[cfg.max+1])
		cfg.max++;

? Not sure if the compiler will optimize that better though.

> +	cfg.qmenu_int = sensor->platform_data->op_sys_clock;
> +
> +	sensor->link_freq = v4l2_ctrl_new_custom(
> +		&sensor->src->ctrl_handler, &cfg, NULL);
> +
> +	sensor->pixel_rate_csi = v4l2_ctrl_new_std(
> +		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
> +		V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
> +
> +	if (sensor->src->ctrl_handler.error) {
> +		dev_err(&client->dev,
> +			"src controls initialization failed (%d)\n",
> +			sensor->src->ctrl_handler.error);
> +		return sensor->src->ctrl_handler.error;
> +	}
> +
> +	sensor->src->sd.ctrl_handler =
> +		&sensor->src->ctrl_handler;
> +
> +	return 0;
> +}
> +
> +static void smiapp_free_controls(struct smiapp_sensor *sensor)
> +{
> +	int i;

unsigned ?

> +
> +	for (i = 0; i < sensor->sds_used; i++)
> +		v4l2_ctrl_handler_free(&sensor->sds[i].ctrl_handler);
> +}
> +
> +static int smiapp_get_limits(struct smiapp_sensor *sensor, int const
> *limit, +			     int n)

unsigned int n ?

> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	int i, val;

unsigned int i;
u32 val;

?

> +	int rval;
> +
> +	for (i = 0; i < n; i++) {
> +		rval = smia_i2c_read_reg(
> +			client, smiapp_reg_limits[limit[i]].addr, &val);
> +		if (rval) {
> +			dev_dbg(&client->dev, "error reading register %4.4x\n",
> +				(u16)smiapp_reg_limits[limit[i]].addr);

What about moving the error message to smia_i2c_read_reg ?

> +			return rval;
> +		}
> +		sensor->limits[limit[i]] = val;
> +		dev_dbg(&client->dev, "0x%8.8x \"%s\" = %d, 0x%x\n",
> +			smiapp_reg_limits[limit[i]].addr,
> +			smiapp_reg_limits[limit[i]].what, val, val);
> +	}
> +
> +	return 0;
> +}
> +
> +static int smiapp_get_all_limits(struct smiapp_sensor *sensor)
> +{
> +	int rval, i;

unsigned int i; ?

> +
> +	for (i = 0; i < SMIAPP_LIMIT_LAST; i++) {
> +		rval = smiapp_get_limits(sensor, &i, 1);
> +		if (rval < 0)
> +			return rval;
> +	}
> +
> +	if (sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN] == 0)
> +		smiapp_replace_limit(sensor, SMIAPP_LIMIT_SCALER_N_MIN, 16);
> +
> +	return 0;
> +}
> +
> +static int smiapp_get_limits_binning(struct smiapp_sensor *sensor)
> +{
> +	static u32 const limits[] = {
> +		SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES_BIN,
> +		SMIAPP_LIMIT_MAX_FRAME_LENGTH_LINES_BIN,
> +		SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_BIN,
> +		SMIAPP_LIMIT_MAX_LINE_LENGTH_PCK_BIN,
> +		SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK_BIN,
> +		SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MIN_BIN,
> +		SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MAX_MARGIN_BIN,
> +	};
> +	static u32 const limits_replace[] = {
> +		SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES,
> +		SMIAPP_LIMIT_MAX_FRAME_LENGTH_LINES,
> +		SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK,
> +		SMIAPP_LIMIT_MAX_LINE_LENGTH_PCK,
> +		SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK,
> +		SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MIN,
> +		SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MAX_MARGIN,
> +	};
> +
> +	if (sensor->limits[SMIAPP_LIMIT_BINNING_CAPABILITY] ==
> +	    SMIAPP_BINNING_CAPABILITY_NO) {
> +		int i;

unsigned int i; (and in the other functions below) ?

> +
> +		for (i = 0; i < ARRAY_SIZE(limits); i++)
> +			sensor->limits[limits[i]] =
> +				sensor->limits[limits_replace[i]];
> +
> +		return 0;
> +	}
> +
> +	return smiapp_get_limits(sensor, limits, ARRAY_SIZE(limits));
> +}
> +
> +static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	unsigned int type, n;
> +	int i, rval, pixel_order;
> +
> +	rval = smia_i2c_read_reg(
> +		client, SMIAPP_REG_U8_DATA_FORMAT_MODEL_TYPE, &type);
> +	if (rval)
> +		return rval;
> +
> +	dev_dbg(&client->dev, "data_format_model_type %d\n", type);
> +
> +	rval = smia_i2c_read_reg(client, SMIAPP_REG_U8_PIXEL_ORDER,
> +				 &pixel_order);
> +	if (rval)
> +		return rval;
> +
> +	if (pixel_order >= ARRAY_SIZE(pixel_order_str)) {
> +		dev_dbg(&client->dev, "bad pixel order %d\n", pixel_order);
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(&client->dev, "pixel order %d (%s)\n", pixel_order,
> +		pixel_order_str[pixel_order]);
> +
> +	switch (type) {
> +	case SMIAPP_DATA_FORMAT_MODEL_TYPE_NORMAL:
> +		n = SMIAPP_DATA_FORMAT_MODEL_TYPE_NORMAL_N;
> +		break;
> +	case SMIAPP_DATA_FORMAT_MODEL_TYPE_EXTENDED:
> +		n = SMIAPP_DATA_FORMAT_MODEL_TYPE_EXTENDED_N;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	sensor->default_pixel_order = pixel_order;
> +	sensor->mbus_frame_fmts = 0;
> +
> +	for (i = 0; i < n; i++) {
> +		int fmt, j;

j can be unsigned as well, this isn't restricted to i :-)

> +
> +		rval = smia_i2c_read_reg(
> +			client,
> +			SMIAPP_REG_U16_DATA_FORMAT_DESCRIPTOR(i), &fmt);
> +		if (rval)
> +			return rval;
> +
> +		dev_dbg(&client->dev, "bpp %d, compressed %d\n",
> +			fmt >> 8, (u8)fmt);
> +
> +		for (j = 0; j < ARRAY_SIZE(smiapp_csi_data_formats); j++) {
> +			const struct smiapp_csi_data_format *f =
> +				&smiapp_csi_data_formats[j];
> +
> +			if (f->pixel_order != SMIAPP_PIXEL_ORDER_GRBG)
> +				continue;
> +
> +			if (f->width != fmt >> 8 || f->compressed != (u8)fmt)
> +				continue;
> +
> +			dev_dbg(&client->dev, "jolly good! %d\n", j);
> +
> +			sensor->default_mbus_frame_fmts |= 1 << j;
> +			if (!sensor->csi_format) {
> +				sensor->csi_format = f;
> +				sensor->internal_csi_format = f;
> +			}
> +		}
> +	}
> +
> +	if (!sensor->csi_format) {
> +		dev_err(&client->dev, "no supported mbus code found\n");
> +		return -EINVAL;
> +	}
> +
> +	smiapp_update_mbus_formats(sensor);
> +
> +	return 0;
> +}
> +
> +static void smiapp_update_blanking(struct smiapp_sensor *sensor)
> +{
> +	struct v4l2_ctrl *vblank = sensor->vblank, *hblank = sensor->hblank;

Two lines please.

> +
> +	vblank->minimum =
> +		max_t(int,
> +		      sensor->limits[SMIAPP_LIMIT_MIN_FRAME_BLANKING_LINES],
> +		      sensor->limits[SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES_BIN] -
> +		      sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].height);
> +	vblank->maximum =
> +		sensor->limits[SMIAPP_LIMIT_MAX_FRAME_LENGTH_LINES_BIN] -
> +		sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].height;
> +
> +	vblank->val = clamp_t(int, vblank->val,
> +			      vblank->minimum, vblank->maximum);
> +	vblank->default_value = vblank->minimum;
> +	vblank->val = vblank->val;
> +	vblank->cur.val = vblank->val;
> +
> +	hblank->minimum =
> +		max_t(int,
> +		      sensor->limits[SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_BIN] -
> +		      sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].width,
> +		      sensor->limits[SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK_BIN]);
> +	hblank->maximum =
> +		sensor->limits[SMIAPP_LIMIT_MAX_LINE_LENGTH_PCK_BIN] -
> +		sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].width;
> +
> +	hblank->val = clamp_t(int, hblank->val,
> +			      hblank->minimum, hblank->maximum);
> +	hblank->default_value = hblank->minimum;
> +	hblank->val = hblank->val;
> +	hblank->cur.val = hblank->val;
> +
> +	__smiapp_update_exposure_limits(sensor);
> +}
> +
> +static int smiapp_update_mode(struct smiapp_sensor *sensor)
> +{

This function isn't protected by the sensor mutex when called from s_power,
but it changes controls. The other call paths seem OK, but you might want to
double-check them.

> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	int binning_mode;
> +	int rval;
> +
> +	dev_dbg(&client->dev, "frame size: %dx%d\n",
> +		sensor->src->crop[SMIAPP_PAD_SOURCE].width,
> +		sensor->src->crop[SMIAPP_PAD_SOURCE].height);
> +	dev_dbg(&client->dev, "csi format width: %d\n",
> +		sensor->csi_format->width);
> +
> +	/* Binning has to be set up here; it affects limits */
> +	if (sensor->binning_horizontal == 1 &&
> +	    sensor->binning_vertical == 1) {
> +		binning_mode = 0;
> +	} else {
> +		u8 binning_type =
> +			(sensor->binning_horizontal << 4)
> +			| sensor->binning_vertical;
> +
> +		rval = smia_i2c_write_reg(
> +			client, SMIAPP_REG_U8_BINNING_TYPE, binning_type);
> +		if (rval < 0)
> +			return rval;
> +
> +		binning_mode = 1;
> +	}
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U8_BINNING_MODE, binning_mode);
> +	if (rval < 0)
> +		return rval;
> +
> +	/* Get updated limits due to binning */
> +	rval = smiapp_get_limits_binning(sensor);
> +	if (rval < 0)
> +		return rval;
> +
> +	rval = smiapp_pll_update(sensor);
> +	if (rval < 0)
> +		return rval;
> +
> +	/* Output from pixel array, including blanking */
> +	smiapp_update_blanking(sensor);
> +
> +	dev_dbg(&client->dev, "vblank\t\t%d\n", sensor->vblank->val);
> +	dev_dbg(&client->dev, "hblank\t\t%d\n", sensor->hblank->val);
> +
> +	dev_dbg(&client->dev, "real timeperframe\t100/%d\n",
> +		sensor->pll.vt_pix_clk_freq_hz /
> +		((sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].width
> +		  + sensor->hblank->val) *
> +		 (sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].height
> +		  + sensor->vblank->val) / 100));
> +
> +	return 0;
> +}
> +
> +/*
> + *
> + * SMIA++ NVM handling
> + *
> + */
> +static int smiapp_read_nvm(struct smiapp_sensor *sensor,
> +			   unsigned char *nvm)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	u32 i, s, p, np, v;
> +	int rval;
> +
> +	np = sensor->nvm_size / SMIAPP_NVM_PAGE_SIZE;

DIV_ROUND_UP() ? Or is sensor->nvm_size guaranteed to be a multiple of
SMIAPP_NVM_PAGE_SIZE ?

> +	for (p = 0; p < np; p++) {
> +		rval = smia_i2c_write_reg(
> +			client,
> +			SMIAPP_REG_U8_DATA_TRANSFER_IF_1_PAGE_SELECT, p);
> +		if (rval)
> +			goto out;
> +
> +		rval = smia_i2c_write_reg(client,
> +					  SMIAPP_REG_U8_DATA_TRANSFER_IF_1_CTRL,
> +					  SMIAPP_DATA_TRANSFER_IF_1_CTRL_EN |
> +					  SMIAPP_DATA_TRANSFER_IF_1_CTRL_RD_EN);
> +		if (rval)
> +			goto out;
> +
> +		i = 1000;
> +		do {
> +			rval = smia_i2c_read_reg(client,
> +				SMIAPP_REG_U8_DATA_TRANSFER_IF_1_STATUS, &s);
> +
> +			if (rval)
> +				goto out;
> +
> +			if (s & SMIAPP_DATA_TRANSFER_IF_1_STATUS_RD_READY)
> +				break;
> +
> +			if (--i == 0)
> +				goto out;
> +
> +		} while (1);

I'd use a for loop on i. BTW, isn't 1000 a bit high ?

> +
> +		for (i = 0; i < SMIAPP_NVM_PAGE_SIZE; i++) {
> +			rval = smia_i2c_read_reg(client,
> +				SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_0 + i,
> +				&v);
> +			if (rval)
> +				goto out;
> +
> +			*nvm++ = v;
> +		}
> +	}
> +
> +out:
> +	rval |= smia_i2c_write_reg(client,
> +				   SMIAPP_REG_U8_DATA_TRANSFER_IF_1_CTRL, 0);

Could this be optimized away by the compiler, as the return value of this
function is only checked against 0 ?

> +	return rval;
> +}
> +
> +/*
> + *
> + * SMIA++ CCI address control
> + *
> + */
> +static int smiapp_change_cci_addr(struct smiapp_sensor *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	int rval;
> +	u32 val;
> +
> +	client->addr = sensor->platform_data->i2c_addr_dfl;
> +
> +	rval = smia_i2c_write_reg(client,
> +				  SMIAPP_REG_U8_CCI_ADDRESS_CONTROL,
> +				  sensor->platform_data->i2c_addr_alt << 1);
> +	if (rval) {
> +		client->addr = sensor->platform_data->i2c_addr_alt;

Why do you set the client address to the alternate one if the call failed ?

> +		return rval;
> +	}
> +
> +	client->addr = sensor->platform_data->i2c_addr_alt;
> +
> +	/* verify addr change went ok */
> +	rval = smia_i2c_read_reg(client,
> +				 SMIAPP_REG_U8_CCI_ADDRESS_CONTROL, &val);
> +	if (rval)
> +		return rval;
> +
> +	if (val != sensor->platform_data->i2c_addr_alt << 1)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +/*
> + *
> + * SMIA++ Mode Control
> + *
> + */
> +static int smiapp_setup_flash_strobe(struct smiapp_sensor *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	struct smiapp_flash_strobe_parms *strobe_setup;
> +	unsigned int ext_freq = sensor->platform_data->ext_clk;
> +	int rval;
> +	u32 tmp;
> +	u32 strobe_adjustment;
> +	u32 strobe_width_high_rs;
> +
> +	strobe_setup = sensor->platform_data->strobe_setup;
> +
> +	/*
> +	 * How to calculate registers related to strobe length. Please
> +	 * do not change, or if you do at least know what you're
> +	 * doing. :-)

You could reindent the text here up to 80 columns, that would shorten the
comment a bit.

> +	 *
> +	 * Sakari Ailus <sakari.ailus@maxwell.research.nokia.com> 2010-10-25
> +	 *
> +	 * flash_strobe_length [us] / 10^6 = (tFlash_strobe_width_ctrl
> +	 *	/ EXTCLK freq [Hz]) * flash_strobe_adjustment
> +	 *
> +	 * tFlash_strobe_width_ctrl E N, [1 - 0xffff]
> +	 * flash_strobe_adjustment E N, [1 - 0xff]
> +	 *
> +	 * The formula above is written as below to keep it on one
> +	 * line:
> +	 *
> +	 * l / 10^6 = w / e * a
> +	 *
> +	 * Let's mark w * a by x:
> +	 *
> +	 * x = w * a
> +	 *
> +	 * Thus, we get:
> +	 *
> +	 * x = l * e / 10^6
> +	 *
> +	 * The strobe width must be at least as long as requested,
> +	 * thus rounding upwards is needed.
> +	 *
> +	 * x = (l * e + 10^6 - 1) / 10^6
> +	 * -----------------------------
> +	 *
> +	 * Maximum possible accuracy is wanted at all times. Thus keep
> +	 * a as small as possible.
> +	 *
> +	 * Calculate a, assuming maximum w, with rounding upwards:
> +	 *
> +	 * a = (x + (2^16 - 1) - 1) / (2^16 - 1)
> +	 * -------------------------------------
> +	 *
> +	 * Thus, we also get w, with that a, with rounding upwards:
> +	 *
> +	 * w = (x + a - 1) / a
> +	 * -------------------
> +	 *
> +	 * To get limits:
> +	 *
> +	 * x E [1, (2^16 - 1) * (2^8 - 1)]
> +	 *
> +	 * Substituting maximum x to the original formula (with rounding),
> +	 * the maximum l is thus
> +	 *
> +	 * (2^16 - 1) * (2^8 - 1) * 10^6 = l * e + 10^6 - 1
> +	 *
> +	 * l = (10^6 * (2^16 - 1) * (2^8 - 1) - 10^6 + 1) / e
> +	 * --------------------------------------------------
> +	 *
> +	 * flash_strobe_length must be clamped between 1 and
> +	 * (10^6 * (2^16 - 1) * (2^8 - 1) - 10^6 + 1) / EXTCLK freq.
> +	 *
> +	 * Then,
> +	 *
> +	 * flash_strobe_adjustment = ((flash_strobe_length *
> +	 *	EXTCLK freq + 10^6 - 1) / 10^6 + (2^16 - 1) - 1) / (2^16 - 1)
> +	 *
> +	 * tFlash_strobe_width_ctrl = ((flash_strobe_length *
> +	 *	EXTCLK freq + 10^6 - 1) / 10^6 +
> +	 *	flash_strobe_adjustment - 1) / flash_strobe_adjustment
> +	 */
> +	tmp = div_u64(1000000ULL * ((1 << 16) - 1) * ((1 << 8) - 1) -
> +		      1000000 + 1, ext_freq);
> +	strobe_setup->strobe_width_high_us =
> +		clamp_t(u32, strobe_setup->strobe_width_high_us, 1, tmp);
> +
> +	tmp = div_u64(((u64)strobe_setup->strobe_width_high_us * (u64)ext_freq +
> +			1000000 - 1), 1000000ULL);
> +	strobe_adjustment = (tmp + (1 << 16) - 1 - 1) / ((1 << 16) - 1);
> +	strobe_width_high_rs = (tmp + strobe_adjustment - 1) /
> +				strobe_adjustment;
> +
> +	rval = smia_i2c_write_reg(client,
> +				  SMIAPP_REG_U8_FLASH_MODE_RS,
> +				  strobe_setup->mode);
> +	if (rval < 0)
> +		goto out;
> +
> +	rval = smia_i2c_write_reg(client,
> +				  SMIAPP_REG_U8_FLASH_STROBE_ADJUSTMENT,
> +				  strobe_adjustment);
> +	if (rval < 0)
> +		goto out;
> +
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U16_TFLASH_STROBE_WIDTH_HIGH_RS_CTRL,
> +		strobe_width_high_rs);
> +	if (rval < 0)
> +		goto out;
> +
> +	rval = smia_i2c_write_reg(client,
> +				  SMIAPP_REG_U16_TFLASH_STROBE_DELAY_RS_CTRL,
> +				  strobe_setup->strobe_delay);
> +	if (rval < 0)
> +		goto out;
> +
> +	rval = smia_i2c_write_reg(client,
> +				  SMIAPP_REG_U16_FLASH_STROBE_START_POINT,
> +				  strobe_setup->stobe_start_point);
> +	if (rval < 0)
> +		goto out;
> +
> +	rval = smia_i2c_write_reg(client,
> +				  SMIAPP_REG_U8_FLASH_TRIGGER_RS,
> +				  strobe_setup->trigger);
> +
> +out:
> +	sensor->platform_data->strobe_setup->trigger = 0;
> +
> +	return rval;
> +}
> +
> +/*
> ---------------------------------------------------------------------------
> -- + * Power management
> + */
> +
> +static int smiapp_power_on(struct smiapp_sensor *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	int sleep;
> +	int rval;
> +
> +	rval = regulator_enable(sensor->vana);
> +	if (rval) {
> +		dev_err(&client->dev, "failed to enable vana regulator\n");
> +		return rval;
> +	}
> +	usleep_range(1000, 1000);

That's a very tight range :-)

> +
> +	rval = sensor->platform_data->set_xclk(&sensor->src->sd,
> +					sensor->platform_data->ext_clk);
> +	if (rval < 0) {
> +		dev_dbg(&client->dev, "failed to set xclk\n");
> +		goto out_xclk_fail;
> +	}
> +	usleep_range(1000, 1000);
> +
> +	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
> +		gpio_set_value(sensor->platform_data->xshutdown, 1);
> +
> +	sleep = SMIAPP_RESET_DELAY(sensor->platform_data->ext_clk);
> +	usleep_range(sleep, sleep);
> +
> +	/*
> +	 * Failures to respond to the address change command have been noticed.
> +	 * Those failures seem to be caused by the sensor requiring a longer
> +	 * boot time than advertised. An additional 10ms delay seems to work
> +	 * around the issue, but the SMIA++ I2C write retry hack makes the delay
> +	 * unnecessary. The failures need to be investigated to find a proper
> +	 * fix, and a delay will likely need to be added here if the I2C write
> +	 * retry hack is reverted before the root cause of the boot time issue
> +	 * is found.
> +	 */
> +
> +	if (sensor->platform_data->i2c_addr_alt) {
> +		rval = smiapp_change_cci_addr(sensor);
> +		if (rval) {
> +			dev_err(&client->dev, "cci address change error\n");
> +			goto out_cci_addr_fail;
> +		}
> +	}
> +
> +	rval = smia_i2c_write_reg(client, SMIAPP_REG_U8_SOFTWARE_RESET,
> +				  SMIAPP_SOFTWARE_RESET);
> +	if (rval < 0) {
> +		dev_err(&client->dev, "software reset failed\n");
> +		goto out_cci_addr_fail;
> +	}
> +
> +	if (sensor->platform_data->i2c_addr_alt) {
> +		rval = smiapp_change_cci_addr(sensor);
> +		if (rval) {
> +			dev_err(&client->dev, "cci address change error\n");
> +			goto out_cci_addr_fail;
> +		}
> +	}
> +
> +	rval = smia_i2c_write_reg(client,
> +				  SMIAPP_REG_U16_COMPRESSION_MODE,
> +				  SMIAPP_COMPRESSION_MODE_SIMPLE_PREDICTOR);
> +	if (rval) {
> +		dev_err(&client->dev, "compression mode set failed\n");
> +		goto out_cci_addr_fail;
> +	}
> +
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U16_EXTCLK_FREQUENCY_MHZ,
> +		sensor->platform_data->ext_clk / (1000000 / (1 << 8)));
> +	if (rval) {
> +		dev_err(&client->dev, "extclk frequency set failed\n");
> +		goto out_cci_addr_fail;
> +	}
> +
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U8_CSI_LANE_MODE,
> +		sensor->platform_data->lanes - 1);
> +	if (rval) {
> +		dev_err(&client->dev, "csi lane mode set failed\n");
> +		goto out_cci_addr_fail;
> +	}
> +
> +	rval = smia_i2c_write_reg(client, SMIAPP_REG_U8_FAST_STANDBY_CTRL,
> +				  SMIAPP_FAST_STANDBY_CTRL_IMMEDIATE);
> +	if (rval) {
> +		dev_err(&client->dev, "fast standby set failed\n");
> +		goto out_cci_addr_fail;
> +	}
> +
> +	/* DPHY control done by sensor based on requested link rate */
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U8_DPHY_CTRL, SMIAPP_DPHY_CTRL_UI);
> +	if (rval < 0) {
> +		dev_err(&client->dev, "set dphy_ctrl_ui failed\n");
> +		goto out_cci_addr_fail;
> +	}
> +
> +	rval = smia_i2c_write_reg(client, SMIAPP_REG_U8_CSI_SIGNALLING_MODE,
> +				  sensor->platform_data->csi_signalling_mode);
> +	if (rval) {
> +		dev_err(&client->dev, "csi signalling mode set failed\n");
> +		goto out_cci_addr_fail;
> +	}
> +
> +	/* DPHY control done by sensor based on requested link rate */
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U8_DPHY_CTRL, SMIAPP_DPHY_CTRL_UI);
> +	if (rval < 0)
> +		return rval;

Is there a need to the SMIAPP_REG_U8_DPHY_CTRL register twice to the same
value ?

> +
> +	rval = smiapp_call_quirk(sensor, post_poweron);
> +	if (rval) {
> +		dev_err(&client->dev, "post_poweron quirks failed\n");
> +		goto out_cci_addr_fail;
> +	}
> +
> +	return 0;
> +
> +out_cci_addr_fail:
> +	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
> +		gpio_set_value(sensor->platform_data->xshutdown, 0);
> +	sensor->platform_data->set_xclk(&sensor->src->sd, 0);
> +
> +out_xclk_fail:
> +	regulator_disable(sensor->vana);
> +	return rval;
> +}
> +
> +static void smiapp_power_off(struct smiapp_sensor *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +
> +	/*
> +	 * Currently power/clock to lens are enable/disabled separately
> +	 * but they are essentially the same signals. So if the sensor is
> +	 * powered off while the lens is powered on the sensor does not
> +	 * really see a power off and next time the cci address change
> +	 * will fail. So do a soft reset explicitly here.
> +	 */
> +	if (sensor->platform_data->i2c_addr_alt)
> +		smia_i2c_write_reg(client,
> +				   SMIAPP_REG_U8_SOFTWARE_RESET,
> +				   SMIAPP_SOFTWARE_RESET);
> +
> +	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
> +		gpio_set_value(sensor->platform_data->xshutdown, 0);
> +	sensor->platform_data->set_xclk(&sensor->src->sd, 0);
> +	usleep_range(5000, 5000);
> +	regulator_disable(sensor->vana);
> +	sensor->streaming = 0;
> +}
> +
> +static int smiapp_set_power(struct v4l2_subdev *subdev, int on)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	int ret;
> +
> +	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
> +	 * update the power state.
> +	 */
> +	if (sensor->power_count == !on) {
> +		if (on) {
> +			ret = smiapp_power_on(sensor);
> +			if (ret < 0)
> +				return ret;
> +			ret = smiapp_update_mode(sensor);
> +			if (ret < 0)
> +				return ret;
> +		} else {
> +			smiapp_power_off(sensor);
> +		}
> +	}
> +
> +	/* Update the power count. */
> +	sensor->power_count += on ? 1 : -1;
> +	WARN_ON(sensor->power_count < 0);
> +
> +	return 0;
> +}
> +
> +/*
> ---------------------------------------------------------------------------
> -- + * Video stream management
> + */
> +
> +static int smiapp_start_streaming(struct smiapp_sensor *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	int rval;
> +
> +	mutex_lock(&sensor->mutex);
> +
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U16_CSI_DATA_FORMAT,
> +		(sensor->csi_format->width << 8) |
> +		sensor->csi_format->compressed);
> +	if (rval)
> +		goto out;
> +
> +	rval = smiapp_pll_configure(sensor);
> +	if (rval)
> +		goto out;
> +
> +	/* Analog crop start coordinates */
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U16_X_ADDR_START,
> +		sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].left);
> +	if (rval < 0)
> +		goto out;
> +
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U16_Y_ADDR_START,
> +		sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].top);
> +	if (rval < 0)
> +		goto out;
> +
> +	/* Analog crop end coordinates */
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U16_X_ADDR_END,
> +		sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].left
> +		+ sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].width - 1);
> +	if (rval < 0)
> +		goto out;
> +
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U16_Y_ADDR_END,
> +		sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].top
> +		+ sensor->pixel_array->crop[SMIAPP_PAD_SOURCE].height - 1);
> +	if (rval < 0)
> +		goto out;
> +
> +	/*
> +	 * Output from pixel array, including blanking, is set using
> +	 * controls below. No need to set here.
> +	 */
> +
> +	/* Digital crop */
> +	if (sensor->limits[SMIAPP_LIMIT_DIGITAL_CROP_CAPABILITY]
> +	    == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP) {
> +		rval = smia_i2c_write_reg(
> +			client, SMIAPP_REG_U16_DIGITAL_CROP_X_OFFSET,
> +			sensor->scaler->crop[SMIAPP_PAD_SINK].left);
> +		if (rval < 0)
> +			goto out;
> +
> +		rval = smia_i2c_write_reg(
> +			client, SMIAPP_REG_U16_DIGITAL_CROP_Y_OFFSET,
> +			sensor->scaler->crop[SMIAPP_PAD_SINK].top);
> +		if (rval < 0)
> +			goto out;
> +
> +		rval = smia_i2c_write_reg(
> +			client, SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_WIDTH,
> +			sensor->scaler->crop[SMIAPP_PAD_SINK].width);
> +		if (rval < 0)
> +			goto out;
> +
> +		rval = smia_i2c_write_reg(
> +			client, SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_HEIGHT,
> +			sensor->scaler->crop[SMIAPP_PAD_SINK].height);
> +		if (rval < 0)
> +			goto out;
> +	}
> +
> +	/* Scaling */
> +	if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
> +	    != SMIAPP_SCALING_CAPABILITY_NONE) {
> +		rval = smia_i2c_write_reg(
> +			client, SMIAPP_REG_U16_SCALING_MODE,
> +			sensor->scaling_mode);
> +		if (rval < 0)
> +			goto out;
> +
> +		if (sensor->scale_m
> +		    != sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN]) {
> +			rval = smia_i2c_write_reg(
> +				client, SMIAPP_REG_U16_SCALE_M,
> +				sensor->scale_m);
> +			if (rval < 0)
> +				goto out;
> +		}

I could be wrong, but it seems to me like the scaling M factor won't be 
updated
properly if you first enable/disable streaming with a non-default M factor,
reconfigure the sensor to use the default value, and then start streaming
again.

> +	}
> +
> +	/* Output size from sensor */
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U16_X_OUTPUT_SIZE,
> +		sensor->src->crop[SMIAPP_PAD_SOURCE].width);
> +	if (rval < 0)
> +		goto out;
> +	rval = smia_i2c_write_reg(
> +		client, SMIAPP_REG_U16_Y_OUTPUT_SIZE,
> +		sensor->src->crop[SMIAPP_PAD_SOURCE].height);
> +	if (rval < 0)
> +		goto out;
> +
> +	if ((sensor->flash_capability &
> +	     (SMIAPP_FLASH_MODE_CAPABILITY_SINGLE_STROBE |
> +	      SMIAPP_FLASH_MODE_CAPABILITY_MULTIPLE_STROBE)) &&
> +	    sensor->platform_data->strobe_setup != NULL &&
> +	    sensor->platform_data->strobe_setup->trigger != 0) {
> +		rval = smiapp_setup_flash_strobe(sensor);
> +		if (rval)
> +			goto out;
> +	}
> +
> +	rval = smiapp_call_quirk(sensor, pre_streamon);
> +	if (rval) {
> +		dev_err(&client->dev, "pre_streamon quirks failed\n");
> +		goto out;
> +	}
> +
> +	rval = smia_i2c_write_reg(client, SMIAPP_REG_U8_MODE_SELECT,
> +				  SMIAPP_MODE_SELECT_STREAMING);
> +
> +out:
> +	mutex_unlock(&sensor->mutex);
> +
> +	return rval;
> +}
> +
> +static int smiapp_stop_streaming(struct smiapp_sensor *sensor)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
> +	int rval;
> +
> +	mutex_lock(&sensor->mutex);
> +	rval = smia_i2c_write_reg(client, SMIAPP_REG_U8_MODE_SELECT,
> +		SMIAPP_MODE_SELECT_SOFTWARE_STANDBY);
> +	if (rval)
> +		goto out;
> +
> +	rval = smiapp_call_quirk(sensor, post_streamoff);
> +	if (rval)
> +		dev_err(&client->dev, "post_streamoff quirks failed\n");
> +
> +out:
> +	mutex_unlock(&sensor->mutex);
> +	return rval;
> +}
> +
> +/*
> ---------------------------------------------------------------------------
> -- + * V4L2 subdev video operations
> + */
> +
> +static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	int rval;
> +
> +	if (sensor->streaming == enable)
> +		return 0;
> +
> +	if (enable) {
> +		sensor->streaming = 1;
> +		rval = smiapp_start_streaming(sensor);
> +		if (rval < 0)
> +			sensor->streaming = 0;

Is there a reason not to just set sensor->streaming after calling
smiapp_start_streaming() ?

> +	} else {
> +		rval = smiapp_stop_streaming(sensor);
> +		sensor->streaming = 0;
> +	}
> +
> +	return rval;
> +}
> +
> +static int smiapp_enum_mbus_code(struct v4l2_subdev *subdev,
> +				 struct v4l2_subdev_fh *fh,
> +				 struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	int i, idx = -1;
> +	int rval = -EINVAL;
> +
> +	mutex_lock(&sensor->mutex);
> +
> +	dev_err(&client->dev, "subdev %s, pad %d, index %d\n",
> +		subdev->name, code->pad, code->index);
> +
> +	if (subdev != &sensor->src->sd
> +	    || code->pad != SMIAPP_PAD_SOURCE) {
> +		if (code->index)
> +			goto out;
> +
> +		code->code = sensor->internal_csi_format->code;
> +		rval = 0;
> +		goto out;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(smiapp_csi_data_formats); i++) {
> +		if (sensor->mbus_frame_fmts & (1 << i))
> +			idx++;
> +
> +		if (idx == code->index) {
> +			code->code = smiapp_csi_data_formats[i].code;
> +			dev_err(&client->dev, "found index %d, i %d, code %x\n",
> +				code->index, i, code->code);
> +			rval = 0;
> +			goto out;

break; would do :-)

> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&sensor->mutex);
> +
> +	return rval;
> +}
> +
> +static int __smiapp_get_format(struct v4l2_subdev *subdev,
> +			     struct v4l2_subdev_fh *fh,
> +			     struct v4l2_subdev_format *fmt)
> +{
> +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		fmt->format = *v4l2_subdev_get_try_format(fh, fmt->pad);
> +	} else {
> +		struct v4l2_rect *r;
> +
> +		if (fmt->pad == SMIAPP_PAD_SOURCE)
> +			r = &ssd->crop[SMIAPP_PAD_SOURCE];
> +		else
> +			r = &ssd->sink_fmt;
> +
> +		fmt->format.width = r->width;
> +		fmt->format.height = r->height;
> +		if (subdev == &sensor->src->sd
> +		    && fmt->pad == SMIAPP_PAD_SOURCE)
> +			fmt->format.code = sensor->csi_format->code;
> +		else
> +			fmt->format.code = sensor->internal_csi_format->code;
> +	}
> +
> +	return 0;
> +}
> +
> +static int smiapp_get_format(struct v4l2_subdev *subdev,
> +			     struct v4l2_subdev_fh *fh,
> +			     struct v4l2_subdev_format *fmt)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	int rval;
> +
> +	mutex_lock(&sensor->mutex);
> +	rval = __smiapp_get_format(subdev, fh, fmt);
> +	mutex_unlock(&sensor->mutex);
> +
> +	return rval;
> +}
> +
> +static void smiapp_get_crop_compose(struct v4l2_subdev *subdev,
> +				    struct v4l2_subdev_fh *fh,
> +				    struct v4l2_rect **crops,
> +				    struct v4l2_rect **comps, int which)
> +{
> +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> +	int i;
> +
> +	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		for (i = 0; i < subdev->entity.num_pads; i++)
> +			if (crops)
> +				crops[i] = &ssd->crop[i];

You could move the if outside the for.

> +		if (comps)
> +			*comps = &ssd->compose;
> +	} else {
> +		for (i = 0; i < subdev->entity.num_pads; i++)
> +			if (crops) {
> +				crops[i] = v4l2_subdev_get_try_crop(fh, i);
> +				BUG_ON(!crops[i]);
> +			}

Same here.

> +		if (comps) {
> +			*comps = v4l2_subdev_get_try_compose(fh,
> +							     SMIAPP_PAD_SINK);
> +			BUG_ON(!*comps);
> +		}
> +	}
> +}
> +
> +/* Changes require propagation only on sink pad. */
> +static void smiapp_propagate(struct v4l2_subdev *subdev,
> +			     struct v4l2_subdev_fh *fh, int which,
> +			     int target)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> +	struct v4l2_rect *comp, *crops[SMIAPP_PADS];
> +
> +	smiapp_get_crop_compose(subdev, fh, crops, &comp, which);
> +
> +	switch (target) {
> +	case V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE:
> +		comp->width = crops[SMIAPP_PAD_SINK]->width;
> +		comp->height = crops[SMIAPP_PAD_SINK]->height;
> +		if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +			if (ssd == sensor->scaler) {
> +				sensor->scale_m =
> +					sensor->limits[
> +						SMIAPP_LIMIT_SCALER_N_MIN];
> +				sensor->scaling_mode =
> +					SMIAPP_SCALING_MODE_NONE;
> +			} else if (ssd == sensor->binner) {
> +				sensor->binning_horizontal = 1;
> +				sensor->binning_vertical = 1;
> +			}
> +		}
> +		/* Fall through */
> +	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE:
> +		*crops[SMIAPP_PAD_SOURCE] = *comp;
> +		break;
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static int smiapp_set_format(struct v4l2_subdev *subdev,
> +			     struct v4l2_subdev_fh *fh,
> +			     struct v4l2_subdev_format *fmt)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> +	struct v4l2_rect *crops[SMIAPP_PADS];
> +	int i = 0;

There's no need to initialize i to 0.

> +
> +	mutex_lock(&sensor->mutex);
> +
> +	smiapp_get_crop_compose(subdev, fh, crops, NULL, fmt->which);
> +
> +	if (subdev == &sensor->src->sd && fmt->pad == SMIAPP_PAD_SOURCE) {
> +		for (i = 0; i < ARRAY_SIZE(smiapp_csi_data_formats); i++) {
> +			if (sensor->mbus_frame_fmts & (1 << i) &&
> +			    smiapp_csi_data_formats[i].code
> +			    == fmt->format.code) {
> +				if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +					sensor->csi_format =
> +						&smiapp_csi_data_formats[i];
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (fmt->pad == SMIAPP_PAD_SOURCE) {
> +		int rval;
> +
> +		rval = __smiapp_get_format(subdev, fh, fmt);
> +
> +		mutex_unlock(&sensor->mutex);
> +		return rval;
> +	}
> +
> +	fmt->format.code = sensor->csi_format->code;

sensor->csi_format is the active format. You seem to always return the active
format code. That will break setting the try format.

> +
> +	fmt->format.width &= ~1;
> +	fmt->format.height &= ~1;
> +
> +	if (fmt->format.width < sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE])
> +		fmt->format.width =
> +			sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE];
> +	if (fmt->format.height
> +	    < sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE])
> +		fmt->format.height =
> +			sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE];

Isn't there a maximum size as well ?

> +
> +	crops[SMIAPP_PAD_SINK]->left = crops[SMIAPP_PAD_SINK]->top = 0;

One assignment per line please.

> +	crops[SMIAPP_PAD_SINK]->width = fmt->format.width;
> +	crops[SMIAPP_PAD_SINK]->height = fmt->format.height;
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		ssd->sink_fmt = *crops[SMIAPP_PAD_SINK];
> +	smiapp_propagate(subdev, fh, fmt->which,
> +			 V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE);
> +
> +	mutex_unlock(&sensor->mutex);
> +
> +	return 0;
> +}
> +
> +#define SCALING_GOODNESS		100000
> +#define SCALING_GOODNESS_EXTREME	100000000
> +static int scaling_goodness(struct v4l2_subdev *subdev, int w, int ask_w,
> +			    int h, int ask_h, u32 flags)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +	int val = 0;
> +
> +	w &= ~1;
> +	ask_w &= ~1;
> +	h &= ~1;
> +	ask_h &= ~1;
> +
> +	if (flags & V4L2_SUBDEV_SEL_FLAG_SIZE_GE) {
> +		if (w < ask_w)
> +			val -= SCALING_GOODNESS;
> +		if (h < ask_h)
> +			val -= SCALING_GOODNESS;
> +	}
> +
> +	if (flags & V4L2_SUBDEV_SEL_FLAG_SIZE_LE) {
> +		if (w > ask_w)
> +			val -= SCALING_GOODNESS;
> +		if (h > ask_h)
> +			val -= SCALING_GOODNESS;
> +	}
> +
> +	val -= abs(w - ask_w);
> +	val -= abs(h - ask_h);
> +
> +	if (w < sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE])
> +		val -= SCALING_GOODNESS_EXTREME;
> +
> +	dev_dbg(&client->dev, "w %d ask_w %d h %d ask_h %d goodness %d\n",
> +		w, ask_h, h, ask_h, val);
> +
> +	return val;
> +}
> +
> +/* We're only called on source pads. This function sets scaling. */
> +static int smiapp_set_compose(struct v4l2_subdev *subdev,
> +			      struct v4l2_subdev_fh *fh,
> +			      struct v4l2_subdev_selection *sel)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> +	struct v4l2_rect *comp, *crops[SMIAPP_PADS];
> +
> +	smiapp_get_crop_compose(subdev, fh, crops, &comp, sel->which);
> +
> +	sel->r.top = 0;
> +	sel->r.left = 0;
> +
> +	if (ssd == sensor->binner) {

Wouldn't per-subdev operation handlers be more readable ?

> +		int i;
> +		int binh = 1, binv = 1;
> +		int best = scaling_goodness(
> +			subdev,
> +			crops[SMIAPP_PAD_SINK]->width,
> +			sel->r.width,
> +			crops[SMIAPP_PAD_SINK]->height,
> +			sel->r.height, sel->flags);
> +
> +		for (i = 0; i < sensor->nbinning_subtypes; i++) {
> +			int this = scaling_goodness(
> +				subdev,
> +				crops[SMIAPP_PAD_SINK]->width
> +				/ sensor->binning_subtypes[i].horizontal,
> +				sel->r.width,
> +				crops[SMIAPP_PAD_SINK]->height
> +				/ sensor->binning_subtypes[i].vertical,
> +				sel->r.height, sel->flags);
> +
> +			if (this > best) {
> +				binh = sensor->binning_subtypes[i].horizontal;
> +				binv = sensor->binning_subtypes[i].vertical;
> +				best = this;
> +
> +				if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +					sensor->binning_vertical = binv;
> +					sensor->binning_horizontal = binh;
> +				}

If the initial best value turns out the be the best one, binning_vertical and
binning_horizontal will never be updated. Moving the if() outside the for loop
would solve this.

> +			}
> +		}
> +
> +		sel->r.width =
> +			(crops[SMIAPP_PAD_SINK]->width / binh) & ~1;
> +		sel->r.height =
> +			(crops[SMIAPP_PAD_SINK]->height / binv) & ~1;
> +
> +	} else {
> +		u32 min, max, a, b, max_m;
> +		u32 scale_m = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
> +		int mode = SMIAPP_SCALING_MODE_HORIZONTAL;
> +		u32 try[4];
> +		u32 ntry = 0;
> +		int i;
> +		int best = INT_MIN;
> +
> +		sel->r.width = min_t(unsigned int, sel->r.width,
> +				     crops[SMIAPP_PAD_SINK]->width);
> +		sel->r.height = min_t(unsigned int, sel->r.height,
> +				      crops[SMIAPP_PAD_SINK]->height);
> +
> +		a = crops[SMIAPP_PAD_SINK]->width
> +			* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN]
> +			/ sel->r.width;
> +		b = crops[SMIAPP_PAD_SINK]->height
> +			* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN]
> +			/ sel->r.height;
> +		max_m = crops[SMIAPP_PAD_SINK]->width
> +			* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN]
> +			/ sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE];
> +
> +		a = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
> +			max(a, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
> +		b = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
> +			max(b, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
> +		max_m = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
> +			    max(max_m,
> +				sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
> +
> +		dev_dbg(&client->dev, "scaling: a %d b %d max_m %d\n",
> +			a, b, max_m);
> +
> +		min = min(max_m, min(a, b));
> +		max = min(max_m, max(a, b));
> +
> +		try[ntry] = min;
> +		ntry++;
> +		if (min != max) {
> +			try[ntry] = max;
> +			ntry++;
> +		}
> +		if (max != max_m) {
> +			try[ntry] = min + 1;
> +			ntry++;
> +			if (min != max) {
> +				try[ntry] = max + 1;
> +				ntry++;
> +			}
> +		}

Please add a comment to explain how you compute the scaling values, the code
isn't self-explicit.

> +
> +		for (i = 0; i < ntry; i++) {
> +			int this = scaling_goodness(
> +				subdev,
> +				crops[SMIAPP_PAD_SINK]->width
> +				/ try[i]
> +				* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN],
> +				sel->r.width,
> +				crops[SMIAPP_PAD_SINK]->height,
> +				sel->r.height,
> +				sel->flags);
> +
> +			dev_dbg(&client->dev, "trying factor %d (%d)\n",
> +				try[i], i);
> +
> +			if (this > best) {
> +				scale_m = try[i];
> +				mode = SMIAPP_SCALING_MODE_HORIZONTAL;
> +				best = this;
> +			}
> +
> +			if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
> +			    == SMIAPP_SCALING_CAPABILITY_HORIZONTAL)
> +				continue;
> +
> +			this = scaling_goodness(
> +				subdev, crops[SMIAPP_PAD_SINK]->width
> +				/ try[i]
> +				* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN],
> +				sel->r.width,
> +				crops[SMIAPP_PAD_SINK]->height
> +				/ try[i]
> +				* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN],
> +				sel->r.height,
> +				sel->flags);
> +
> +			if (this > best) {
> +				scale_m = try[i];
> +				mode = SMIAPP_SCALING_MODE_BOTH;
> +				best = this;
> +			}
> +		}
> +
> +		sel->r.width =
> +			(crops[SMIAPP_PAD_SINK]->width
> +			 / scale_m
> +			 * sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN]) & ~1;
> +		if (mode == SMIAPP_SCALING_MODE_BOTH)
> +			sel->r.height =
> +				(crops[SMIAPP_PAD_SINK]->height
> +				 / scale_m
> +				 * sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN])
> +				& ~1;
> +		else
> +			sel->r.height = crops[SMIAPP_PAD_SINK]->height;
> +
> +		if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +			sensor->scale_m = scale_m;
> +			sensor->scaling_mode = mode;
> +		}
> +	}
> +
> +	*comp = sel->r;
> +	smiapp_propagate(subdev, fh, sel->which,
> +			 V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE);
> +
> +	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return smiapp_update_mode(sensor);
> +
> +	return 0;
> +}
> +
> +static int __smiapp_sel_supported(struct v4l2_subdev *subdev,
> +				  struct v4l2_subdev_selection *sel)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> +
> +	/* We only implement crop in three places. */
> +	switch (sel->target) {
> +	case V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE:
> +	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
> +		if (ssd == sensor->pixel_array
> +		    && sel->pad == SMIAPP_PAD_SOURCE)
> +			return 0;
> +		if (ssd == sensor->src
> +		    && sel->pad == SMIAPP_PAD_SOURCE)
> +			return 0;
> +		if (ssd == sensor->scaler
> +		    && sel->pad == SMIAPP_PAD_SINK
> +		    && sensor->limits[SMIAPP_LIMIT_DIGITAL_CROP_CAPABILITY]
> +		    == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP)
> +			return 0;
> +		return -EINVAL;
> +	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE:
> +	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
> +		if (sel->pad != SMIAPP_PAD_SINK)
> +			return -EINVAL;
> +		if (ssd == sensor->binner)
> +			return 0;
> +		if (ssd == sensor->scaler
> +		    && sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
> +		    != SMIAPP_SCALING_CAPABILITY_NONE)
> +			return 0;
> +		/* Fall through */
> +	default:
> +		return -EINVAL;
> +	}

What about returning 1 if the selection target is supported, and 0 if it isn't
?

> +}
> +
> +static int smiapp_set_crop(struct v4l2_subdev *subdev,
> +			   struct v4l2_subdev_fh *fh,
> +			   struct v4l2_subdev_selection *sel)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> +	struct v4l2_rect *src_size, *crops[SMIAPP_PADS];
> +	struct v4l2_rect _r;
> +
> +	smiapp_get_crop_compose(subdev, fh, crops, NULL, sel->which);
> +
> +	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		if (sel->pad == SMIAPP_PAD_SINK)
> +			src_size = &ssd->sink_fmt;
> +		else
> +			src_size = &ssd->compose;
> +	} else {
> +		if (sel->pad == SMIAPP_PAD_SINK) {
> +			_r.left = _r.top = 0;

One assignment per line please.

> +			_r.width = v4l2_subdev_get_try_format(fh, sel->pad)
> +				->width;
> +			_r.height = v4l2_subdev_get_try_format(fh, sel->pad)
> +				->height;
> +			src_size = &_r;
> +		} else {
> +			src_size =
> +				v4l2_subdev_get_try_compose(fh,
> +							    SMIAPP_PAD_SINK);

Why do you get the try compose rectangle when setting the crop rectangle ?

> +		}
> +	}

This looks a bit too complex to me (but it's just a feeling).

> +
> +	if (ssd == sensor->src && sel->pad == SMIAPP_PAD_SOURCE)
> +		sel->r.left = 0, sel->r.top = 0;

Please...

> +
> +	if (sel->r.width > src_size->width)
> +		sel->r.width = src_size->width;
> +	if (sel->r.height > src_size->height)
> +		sel->r.height = src_size->height;
> +
> +	if (sel->r.left + sel->r.width > src_size->width)
> +		sel->r.left =
> +			src_size->width - sel->r.width;
> +	if (sel->r.top + sel->r.height > src_size->height)
> +		sel->r.top =
> +			src_size->height - sel->r.height;
> +
> +	*crops[sel->pad] = sel->r;
> +
> +	if (sel->pad == SMIAPP_PAD_SINK)
> +		smiapp_propagate(subdev, fh, sel->which,
> +				 V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE);
> +
> +	return 0;
> +}
> +
> +static int __smiapp_get_selection(struct v4l2_subdev *subdev,
> +				  struct v4l2_subdev_fh *fh,
> +				  struct v4l2_subdev_selection *sel)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> +	struct v4l2_rect *comp, *crops[SMIAPP_PADS];
> +	struct v4l2_rect sink_fmt;
> +	int ret;
> +
> +	ret = __smiapp_sel_supported(subdev, sel);
> +	if (ret)
> +		return ret;
> +
> +	smiapp_get_crop_compose(subdev, fh, crops, &comp, sel->which);
> +
> +	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		sink_fmt = ssd->sink_fmt;
> +	} else if (ssd != sensor->pixel_array) {
> +		struct v4l2_mbus_framefmt *fmt =
> +			v4l2_subdev_get_try_format(fh, SMIAPP_PAD_SINK);
> +
> +		sink_fmt.left = sink_fmt.top = 0;
> +		sink_fmt.width = fmt->width;
> +		sink_fmt.height = fmt->height;
> +	} else {
> +		BUG();

So you support active selections on the pixel array subdev, but not try
selections ?

> +	}
> +
> +	switch (sel->target) {
> +	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
> +		if (ssd == sensor->pixel_array) {
> +			sel->r.width =
> +				sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
> +			sel->r.height =
> +				sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
> +		} else if (sel->pad == SMIAPP_PAD_SINK) {
> +			sel->r = sink_fmt;
> +		} else {
> +			sel->r = *comp;
> +		}
> +		break;
> +	case V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE:
> +	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
> +		sel->r = *crops[sel->pad];
> +		break;
> +	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE:
> +		sel->r = *comp;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int smiapp_get_selection(struct v4l2_subdev *subdev,
> +				struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_selection *sel)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	int rval;
> +
> +	mutex_lock(&sensor->mutex);
> +	rval = __smiapp_get_selection(subdev, fh, sel);
> +	mutex_unlock(&sensor->mutex);
> +
> +	return rval;
> +}
> +static int smiapp_set_selection(struct v4l2_subdev *subdev,
> +				struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_selection *sel)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	int ret;
> +
> +	ret = __smiapp_sel_supported(subdev, sel);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&sensor->mutex);
> +
> +	sel->r.left = max(0, sel->r.left & ~1);
> +	sel->r.top = max(0, sel->r.top & ~1);
> +	sel->r.width = max(0, SMIAPP_ALIGN_DIM(sel->r.width, sel->flags));
> +	sel->r.height = max(0, SMIAPP_ALIGN_DIM(sel->r.height, sel->flags));
> +
> +	sel->r.width = max_t(unsigned int,
> +			     sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE],
> +			     sel->r.width);
> +	sel->r.height = max_t(unsigned int,
> +			      sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE],
> +			      sel->r.height);
> +
> +	switch (sel->target) {
> +	case V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE:
> +		ret = smiapp_set_crop(subdev, fh, sel);
> +		break;
> +	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE:
> +		ret = smiapp_set_compose(subdev, fh, sel);
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	mutex_unlock(&sensor->mutex);
> +	return ret;
> +}
> +
> +static int smiapp_get_skip_frames(struct v4l2_subdev *subdev, u32 *frames)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +
> +	*frames = sensor->frame_skip;
> +	return 0;
> +}
> +
> +/*
> ---------------------------------------------------------------------------
> -- + * sysfs attributes
> + */
> +
> +static ssize_t
> +smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
> +		      char *buf)
> +{
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(to_i2c_client(dev));
> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	int nbytes;
> +
> +	if (!sensor->dev_init_done)
> +		return -EBUSY;
> +
> +	if (!sensor->nvm_size) {
> +		/* NVM not read yet - read it now */
> +		sensor->nvm_size = sensor->platform_data->nvm_size;
> +		if (smiapp_set_power(subdev, 1) < 0)
> +			return -ENODEV;
> +		if (smiapp_read_nvm(sensor, sensor->nvm)) {
> +			dev_err(&client->dev, "nvm read failed\n");
> +			return -ENODEV;
> +		}
> +		smiapp_set_power(subdev, 0);
> +	}
> +	/*
> +	 * NVM is still way below a PAGE_SIZE, so we can safely
> +	 * assume this for now.
> +	 */
> +	nbytes = min_t(unsigned int, sensor->nvm_size, PAGE_SIZE);
> +	memcpy(buf, sensor->nvm, nbytes);
> +
> +	return nbytes;
> +}
> +static DEVICE_ATTR(nvm, S_IRUGO, smiapp_sysfs_nvm_read, NULL);
> +
> +/*
> ---------------------------------------------------------------------------
> -- + * V4L2 subdev core operations
> + */
> +
> +static int smiapp_identify_module(struct v4l2_subdev *subdev)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +	int i, rval = 0;
> +	struct smiapp_module_info *minfo = &sensor->minfo;
> +
> +	minfo->name = SMIAPP_NAME;
> +
> +	/* Module info */
> +	rval = smia_i2c_read_reg(client,
> +				 SMIAPP_REG_U8_MANUFACTURER_ID,
> +				 &minfo->manufacturer_id);
> +	if (!rval)
> +		rval = smia_i2c_read_reg(client,
> +					 SMIAPP_REG_U16_MODEL_ID,
> +					 &minfo->model_id);
> +	if (!rval)
> +		rval |= smia_i2c_read_reg(client,
> +					  SMIAPP_REG_U8_REVISION_NUMBER_MAJOR,
> +					  &minfo->revision_number_major);

s/|=/=/

> +	if (!rval)
> +		rval |= smia_i2c_read_reg(client,
> +					  SMIAPP_REG_U8_REVISION_NUMBER_MINOR,
> +					  &minfo->revision_number_minor);
> +	if (!rval)
> +		rval |= smia_i2c_read_reg(client,
> +					  SMIAPP_REG_U8_MODULE_DATE_YEAR,
> +					  &minfo->module_year);
> +	if (!rval)
> +		rval |= smia_i2c_read_reg(client,
> +					  SMIAPP_REG_U8_MODULE_DATE_MONTH,
> +					  &minfo->module_month);
> +	if (!rval)
> +		rval |= smia_i2c_read_reg(client,
> +					  SMIAPP_REG_U8_MODULE_DATE_DAY,
> +					  &minfo->module_day);
> +
> +	/* Sensor info */
> +	if (!rval)
> +		rval |= smia_i2c_read_reg(client,
> +					  SMIAPP_REG_U8_SENSOR_MANUFACTURER_ID,
> +					  &minfo->sensor_manufacturer_id);
> +	if (!rval)
> +		rval |= smia_i2c_read_reg(client,
> +					  SMIAPP_REG_U16_SENSOR_MODEL_ID,
> +					  &minfo->sensor_model_id);
> +	if (!rval)
> +		rval = smia_i2c_read_reg(client,
> +					 SMIAPP_REG_U8_SENSOR_REVISION_NUMBER,
> +					 &minfo->sensor_revision_number);
> +	if (!rval)
> +		rval = smia_i2c_read_reg(client,
> +					 SMIAPP_REG_U8_SENSOR_FIRMWARE_VERSION,
> +					 &minfo->sensor_firmware_version);
> +
> +	/* SMIA */
> +	if (!rval)
> +		rval = smia_i2c_read_reg(client,
> +					 SMIAPP_REG_U8_SMIA_VERSION,
> +					 &minfo->smia_version);
> +	if (!rval)
> +		rval = smia_i2c_read_reg(client,
> +					 SMIAPP_REG_U8_SMIAPP_VERSION,
> +					 &minfo->smiapp_version);
> +
> +	if (rval) {
> +		dev_err(&client->dev, "sensor detection failed\n");
> +		return -ENODEV;
> +	}
> +
> +	dev_dbg(&client->dev, "module 0x%2.2x-0x%4.4x\n",

"module 0x%02x-0x%04x\n" (and similarly below) ?

> +		minfo->manufacturer_id, minfo->model_id);
> +
> +	dev_dbg(&client->dev,
> +		"module revision 0x%2.2x-0x%2.2x date %2.2d-%2.2d-%2.2d\n",
> +		minfo->revision_number_major, minfo->revision_number_minor,
> +		minfo->module_year, minfo->module_month, minfo->module_day);
> +
> +	dev_dbg(&client->dev, "sensor 0x%2.2x-0x%4.4x\n",
> +		minfo->sensor_manufacturer_id, minfo->sensor_model_id);
> +
> +	dev_dbg(&client->dev,
> +		"sensor revision 0x%2.2x firmware version 0x%2.2x\n",
> +		minfo->sensor_revision_number, minfo->sensor_firmware_version);
> +
> +	dev_dbg(&client->dev, "smia version %2.2d smiapp version %2.2d\n",
> +		minfo->smia_version, minfo->smiapp_version);
> +

Could you please add a short comment to explain why this is needed ?

> +	if (!minfo->manufacturer_id && !minfo->model_id) {
> +		minfo->manufacturer_id = minfo->sensor_manufacturer_id;
> +		minfo->model_id = minfo->sensor_model_id;
> +		minfo->revision_number_major = minfo->sensor_revision_number;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(smiapp_module_idents); i++) {
> +		if (smiapp_module_idents[i].manufacturer_id
> +		    != minfo->manufacturer_id)
> +			continue;
> +		if (smiapp_module_idents[i].model_id != minfo->model_id)
> +			continue;
> +		if (smiapp_module_idents[i].flags
> +		    & SMIAPP_MODULE_IDENT_FLAG_REV_LE) {
> +			if (smiapp_module_idents[i].revision_number_major
> +			    < minfo->revision_number_major)
> +				continue;
> +		} else {
> +			if (smiapp_module_idents[i].revision_number_major
> +			    != minfo->revision_number_major)
> +				continue;
> +		}
> +
> +		minfo->name = smiapp_module_idents[i].name;
> +		minfo->quirk = smiapp_module_idents[i].quirk;
> +		break;
> +	}
> +
> +	if (i >= ARRAY_SIZE(smiapp_module_idents))
> +		dev_warn(&client->dev, "no quirks for this module\n");

Maybe a message such as "unknown SMIA++ module - trying generic support" would
be better ? Many of the known modules have no quirks.

> +
> +	dev_dbg(&client->dev, "the sensor is called %s, ident %2.2x%4.4x%2.2x\n",
> +		minfo->name, minfo->manufacturer_id, minfo->model_id,
> +		minfo->revision_number_major);
> +
> +	strlcpy(subdev->name, sensor->minfo.name, sizeof(subdev->name));
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_ops smiapp_ops;
> +static const struct v4l2_subdev_internal_ops smiapp_internal_ops;
> +static const struct media_entity_operations smiapp_entity_ops;
> +
> +static int smiapp_registered(struct v4l2_subdev *subdev)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +	struct smiapp_subdev *last = NULL;
> +	int rval;
> +	u32 tmp, i;
> +
> +	sensor->vana = regulator_get(&client->dev, "VANA");
> +	if (IS_ERR(sensor->vana)) {
> +		dev_err(&client->dev, "could not get regulator for vana\n");
> +		return -ENODEV;
> +	}
> +
> +	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN) {
> +		if (gpio_request_one(sensor->platform_data->xshutdown, 0,
> +				     "SMIA++ xshutdown") != 0) {
> +			dev_err(&client->dev,
> +				"unable to acquire reset gpio %d\n",
> +				sensor->platform_data->xshutdown);
> +			rval = -ENODEV;
> +			goto out_gpio_request;
> +		}
> +	}
> +
> +	rval = smiapp_power_on(sensor);
> +	if (rval) {
> +		rval = -ENODEV;
> +		goto out_smiapp_power_on;
> +	}
> +
> +	rval = smiapp_identify_module(subdev);
> +	if (rval) {
> +		rval = -ENODEV;
> +		goto out_power_off;
> +	}
> +
> +	rval = smiapp_get_all_limits(sensor);
> +	if (rval) {
> +		rval = -ENODEV;
> +		goto out_power_off;
> +	}
> +
> +	/*
> +	 * Handle Sensor Module orientation on the board.
> +	 *
> +	 * The application of H-FLIP and V-FLIP on the sensor is modified by
> +	 * the sensor orientation on the board.
> +	 *
> +	 * For SMIAPP_BOARD_SENSOR_ORIENT_180 the default behaviour is to set
> +	 * both H-FLIP and V-FLIP for normal operation which also implies
> +	 * that a set/unset operation for user space HFLIP and VFLIP v4l2
> +	 * controls will need to be internally inverted.
> +	 *
> +	 * Rotation also changes the bayer pattern.
> +	 */
> +	if (sensor->platform_data->module_board_orient ==
> +	    SMIAPP_MODULE_BOARD_ORIENT_180)
> +		sensor->hvflip_inv_mask = SMIAPP_IMAGE_ORIENTATION_HFLIP |
> +					  SMIAPP_IMAGE_ORIENTATION_VFLIP;
> +
> +	rval = smiapp_get_mbus_formats(sensor);
> +	if (rval) {
> +		rval = -ENODEV;
> +		goto out_power_off;
> +	}
> +
> +	if (sensor->limits[SMIAPP_LIMIT_BINNING_CAPABILITY]) {
> +		int i;
> +		int val;
> +
> +		rval = smia_i2c_read_reg(client,
> +					 SMIAPP_REG_U8_BINNING_SUBTYPES, &val);
> +		if (rval < 0) {
> +			rval = -ENODEV;
> +			goto out_power_off;
> +		}
> +		sensor->nbinning_subtypes = min_t(u8, val,
> +						  SMIAPP_BINNING_SUBTYPES);
> +
> +		for (i = 0; i < sensor->nbinning_subtypes; i++) {
> +			rval = smia_i2c_read_reg(
> +				client, SMIAPP_REG_U8_BINNING_TYPE_n(i), &val);
> +			if (rval < 0) {
> +				rval = -ENODEV;
> +				goto out_power_off;
> +			}
> +			sensor->binning_subtypes[i] =
> +				*(struct smiapp_binning_subtype *)&val;
> +
> +			dev_dbg(&client->dev, "binning %xx%x\n",
> +				sensor->binning_subtypes[i].horizontal,
> +				sensor->binning_subtypes[i].vertical);
> +		}
> +	}
> +	sensor->binning_horizontal = 1;
> +	sensor->binning_vertical = 1;
> +
> +	/* SMIA++ NVM initialization - it will be read from the sensor
> +	 * when it is first requested by userspace.
> +	 */
> +	if (sensor->minfo.smiapp_version && sensor->platform_data->nvm_size) {
> +		sensor->nvm = kzalloc(sensor->platform_data->nvm_size,
> +				      GFP_KERNEL);
> +		if (sensor->nvm == NULL) {
> +			dev_err(&client->dev, "nvm buf allocation failed\n");
> +			rval = -ENOMEM;
> +			goto out_power_off;
> +		}
> +
> +		if (device_create_file(&client->dev, &dev_attr_nvm) != 0) {
> +			dev_err(&client->dev, "sysfs nvm entry failed\n");
> +			rval = -EBUSY;
> +			goto out_nvm_release1;
> +		}
> +	}
> +
> +	rval = smiapp_call_quirk(sensor, limits);
> +	if (rval) {
> +		dev_err(&client->dev, "limits quirks failed\n");
> +		goto out_nvm_release2;
> +	}
> +
> +	/* We consider this as profile 0 sensor if any of these are zero. */
> +	if (!sensor->limits[SMIAPP_LIMIT_MIN_OP_SYS_CLK_DIV] ||
> +	    !sensor->limits[SMIAPP_LIMIT_MAX_OP_SYS_CLK_DIV] ||
> +	    !sensor->limits[SMIAPP_LIMIT_MIN_OP_PIX_CLK_DIV] ||
> +	    !sensor->limits[SMIAPP_LIMIT_MAX_OP_PIX_CLK_DIV]) {
> +		sensor->minfo.smiapp_profile = SMIAPP_PROFILE_0;
> +	} else if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
> +		   != SMIAPP_SCALING_CAPABILITY_NONE) {
> +		if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
> +		    == SMIAPP_SCALING_CAPABILITY_HORIZONTAL)
> +			sensor->minfo.smiapp_profile = SMIAPP_PROFILE_1;
> +		else
> +			sensor->minfo.smiapp_profile = SMIAPP_PROFILE_2;
> +		sensor->scaler = &sensor->sds[sensor->sds_used];
> +		sensor->sds_used++;
> +	} else if (sensor->limits[SMIAPP_LIMIT_DIGITAL_CROP_CAPABILITY]
> +		   == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP) {
> +		sensor->scaler = &sensor->sds[sensor->sds_used];
> +		sensor->sds_used++;
> +	}
> +	sensor->binner = &sensor->sds[sensor->sds_used];
> +	sensor->sds_used++;
> +	sensor->pixel_array = &sensor->sds[sensor->sds_used];
> +	sensor->sds_used++;
> +
> +	sensor->scale_m = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
> +
> +	for (i = 0; i < SMIAPP_SUBDEVS; i++) {
> +		struct {
> +			struct smiapp_subdev *sds;
> +			char *name;
> +		} _t[] = {
> +			{ sensor->scaler, "scaler", },
> +			{ sensor->binner, "binner", },
> +			{ sensor->pixel_array, "pixel array", },
> +		}, *this = &_t[i];

What about moving _t outside of the loop (and renaming it to something more
explicit) ? There's no need to initialize it at each iteration.

> +		if (!this->sds)
> +			continue;
> +
> +		if (this->sds != sensor->src)
> +			v4l2_subdev_init(&this->sds->sd, &smiapp_ops);
> +
> +		this->sds->sensor = sensor;
> +
> +		if (this->sds == sensor->pixel_array) {
> +			if (this->sds == sensor->src)
> +				sensor->sds->sd.entity.num_pads = 1;

That's supposed to be initialized by media_entity_init(), why do you need to
set it explictly here ?

> +			this->sds->npads = 1;
> +		} else {
> +			this->sds->npads = 2;
> +		}
> +
> +		snprintf(this->sds->sd.name,
> +			 sizeof(this->sds->sd.name), "%s %s",
> +			 sensor->minfo.name, this->name);
> +
> +		this->sds->sink_fmt.width =
> +			sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
> +		this->sds->sink_fmt.height =
> +			sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
> +		this->sds->crop[SMIAPP_PAD_SINK].width =
> +			this->sds->sink_fmt.width;
> +		this->sds->crop[SMIAPP_PAD_SINK].height =
> +			this->sds->sink_fmt.height;
> +		this->sds->crop[SMIAPP_PAD_SOURCE] =
> +			this->sds->compose =
> +			this->sds->crop[SMIAPP_PAD_SINK];
> +
> +		this->sds->pads[1].flags = MEDIA_PAD_FL_SINK;
> +		this->sds->pads[0].flags = MEDIA_PAD_FL_SOURCE;

Pad 1 is the sink pad and pad 0 the source pad ? That's very unusual, couldn't
you make it the other way around ?

> +
> +		this->sds->sd.entity.ops = &smiapp_entity_ops;
> +
> +		if (last == NULL) {
> +			last = this->sds;
> +			continue;
> +		}
> +
> +		this->sds->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +		this->sds->sd.internal_ops = &smiapp_internal_ops;
> +		this->sds->sd.owner = NULL;
> +		v4l2_set_subdevdata(&this->sds->sd, client);
> +
> +		rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
> +						   &this->sds->sd);
> +		if (rval) {
> +			dev_err(&client->dev,
> +				"v4l2_device_register_subdev failed\n");
> +			goto out_nvm_release2;
> +		}
> +
> +		rval = media_entity_init(&this->sds->sd.entity,
> +					 this->sds->npads, this->sds->pads, 0);
> +		if (rval) {
> +			dev_err(&client->dev,
> +				"media_entity_init failed\n");
> +			goto out_nvm_release2;
> +		}

You should initialize the entity (and possibly create the link) before
registering the subdev.

> +
> +		rval = media_entity_create_link(&this->sds->sd.entity, 0,
> +						&last->sd.entity, 1,
> +						MEDIA_LNK_FL_ENABLED |
> +						MEDIA_LNK_FL_IMMUTABLE);
> +		if (rval) {
> +			dev_err(&client->dev,
> +				"media_entity_create_link failed\n");
> +			goto out_nvm_release2;
> +		}
> +
> +		last = this->sds;
> +	}
> +
> +	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
> +
> +	sensor->pixel_array->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +
> +	/* final steps */
> +	smiapp_read_frame_fmt(sensor);
> +	rval = smiapp_init_controls(sensor);
> +	if (rval < 0)
> +		goto out_nvm_release2;
> +
> +	rval = smiapp_update_mode(sensor);
> +	if (rval) {
> +		dev_err(&client->dev, "update mode failed\n");
> +		goto out_nvm_release2;
> +	}
> +
> +	sensor->streaming = false;
> +	sensor->dev_init_done = true;
> +
> +	/* check flash capability */
> +	rval = smia_i2c_read_reg(client,
> +				 SMIAPP_REG_U8_FLASH_MODE_CAPABILITY, &tmp);
> +	sensor->flash_capability = tmp;
> +	if (rval)
> +		goto out_nvm_release2;
> +
> +	smiapp_power_off(sensor);

Shouldn't you take the sensor mutex around the whole function ?

> +
> +	return 0;
> +
> +out_nvm_release2:
> +	device_remove_file(&client->dev, &dev_attr_nvm);
> +
> +out_nvm_release1:
> +	kfree(sensor->nvm);
> +	sensor->nvm = NULL;

You can move this under out_power_off, if sensor->nvm is already NULL kfree
will be a no-op.

> +
> +out_power_off:
> +	smiapp_power_off(sensor);
> +
> +out_smiapp_power_on:
> +	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
> +		gpio_free(sensor->platform_data->xshutdown);
> +
> +out_gpio_request:
> +	regulator_put(sensor->vana);
> +	sensor->vana = NULL;
> +	return rval;
> +}
> +
> +static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct smiapp_subdev *ssd = to_smiapp_subdev(sd);
> +	struct v4l2_subdev_selection sel;
> +	struct v4l2_rect *try_sel;
> +	int i;
> +	int rval;
> +
> +	mutex_lock(&ssd->sensor->power_mutex);
> +	mutex_lock(&ssd->sensor->mutex);
> +
> +	for (i = 0; i < ssd->npads; i++) {
> +		struct v4l2_subdev_format fmt;
> +		struct v4l2_mbus_framefmt *try_fmt;
> +
> +		fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +		fmt.pad = i;
> +		__smiapp_get_format(sd, fh, &fmt);
> +		try_fmt = v4l2_subdev_get_try_format(fh, i);
> +		*try_fmt = fmt.format;
> +
> +		sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +		sel.pad = i;
> +		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE;
> +		__smiapp_get_selection(sd, fh, &sel);
> +		try_sel = v4l2_subdev_get_try_crop(fh, i);
> +		*try_sel = sel.r;

Wouldn't it be better to use the default values instead of the active ones
here ?

> +	}
> +
> +	if (ssd != ssd->sensor->pixel_array) {
> +		sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +		sel.pad = SMIAPP_PAD_SINK;
> +		sel.target = V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE;
> +		__smiapp_get_selection(sd, fh, &sel);
> +		try_sel = v4l2_subdev_get_try_compose(fh, SMIAPP_PAD_SINK);
> +		*try_sel = sel.r;
> +	}
> +
> +	rval = smiapp_set_power(sd, 1);
> +
> +	mutex_unlock(&ssd->sensor->mutex);
> +
> +	if (rval < 0)
> +		goto out;
> +
> +	/* Was the sensor already powered on? */
> +	if (ssd->sensor->power_count > 1)

power_count is accessed in smiapp_set_power without taking the power_mutex
lock. Are two locks really needed ?

> +		goto out;
> +
> +	for (i = 0; i < ssd->sensor->sds_used; i++) {
> +		rval = v4l2_ctrl_handler_setup(
> +			&ssd->sensor->sds[i].ctrl_handler);
> +		if (rval)
> +			goto out;
> +	}

Doesn't this belong to the set power handler ?

> +
> +out:
> +	mutex_unlock(&ssd->sensor->power_mutex);
> +
> +	return rval;
> +}
> +
> +static int smiapp_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(sd);
> +	int rval;
> +
> +	mutex_lock(&sensor->power_mutex);
> +	mutex_lock(&sensor->mutex);
> +	rval = smiapp_set_power(sd, 0);
> +	mutex_unlock(&sensor->mutex);
> +	mutex_unlock(&sensor->power_mutex);
> +
> +	return rval;
> +}
> +
> +static const struct v4l2_subdev_video_ops smiapp_video_ops = {
> +	.s_stream = smiapp_set_stream,
> +};
> +
> +static const struct v4l2_subdev_core_ops smiapp_core_ops = {
> +	.s_power = smiapp_set_power,
> +};
> +
> +static const struct v4l2_subdev_pad_ops smiapp_pad_ops = {
> +	.enum_mbus_code = smiapp_enum_mbus_code,
> +	.get_fmt = smiapp_get_format,
> +	.set_fmt = smiapp_set_format,
> +	.get_selection = smiapp_get_selection,
> +	.set_selection = smiapp_set_selection,
> +	.link_validate = v4l2_subdev_link_validate_default,

This can be left NULL.

> +};
> +
> +static const struct v4l2_subdev_sensor_ops smiapp_sensor_ops = {
> +	.g_skip_frames = smiapp_get_skip_frames,
> +};
> +
> +static const struct v4l2_subdev_ops smiapp_ops = {
> +	.core = &smiapp_core_ops,
> +	.video = &smiapp_video_ops,
> +	.pad = &smiapp_pad_ops,
> +	.sensor = &smiapp_sensor_ops,
> +};
> +
> +static const struct media_entity_operations smiapp_entity_ops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +static const struct v4l2_subdev_internal_ops smiapp_internal_src_ops = {
> +	.registered = smiapp_registered,
> +	.open = smiapp_open,
> +	.close = smiapp_close,
> +};
> +
> +static const struct v4l2_subdev_internal_ops smiapp_internal_ops = {
> +	.open = smiapp_open,
> +	.close = smiapp_close,
> +};
> +
> +/*
> ---------------------------------------------------------------------------
> -- + * I2C Driver
> + */
> +
> +#ifdef CONFIG_PM
> +
> +static int smiapp_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	int ss;
> +
> +	BUG_ON(mutex_is_locked(&sensor->mutex));
> +
> +	if (sensor->power_count == 0)
> +		return 0;
> +
> +	if (sensor->streaming)
> +		smiapp_stop_streaming(sensor);
> +
> +	ss = sensor->streaming;
> +
> +	smiapp_power_off(sensor);
> +
> +	/* save state for resume */
> +	sensor->streaming = ss;
> +
> +	return 0;
> +}
> +
> +static int smiapp_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	int rval;
> +
> +	if (sensor->power_count == 0)
> +		return 0;
> +
> +	rval = smiapp_power_on(sensor);
> +	if (rval)
> +		return rval;
> +
> +	if (sensor->streaming)
> +		rval = smiapp_start_streaming(sensor);
> +
> +	return rval;
> +}
> +
> +#else
> +
> +#define smiapp_suspend	NULL
> +#define smiapp_resume	NULL
> +
> +#endif /* CONFIG_PM */
> +
> +static int smiapp_probe(struct i2c_client *client,
> +			const struct i2c_device_id *devid)
> +{
> +	struct smiapp_sensor *sensor;
> +	int rval;
> +
> +	if (client->dev.platform_data == NULL)
> +		return -ENODEV;
> +
> +	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
> +	if (sensor == NULL)
> +		return -ENOMEM;
> +
> +	sensor->platform_data = client->dev.platform_data;
> +	mutex_init(&sensor->mutex);
> +	mutex_init(&sensor->power_mutex);
> +	sensor->src = &sensor->sds[sensor->sds_used];
> +
> +	v4l2_i2c_subdev_init(&sensor->src->sd, client, &smiapp_ops);
> +	sensor->src->sd.internal_ops = &smiapp_internal_src_ops;
> +	sensor->src->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	sensor->src->sensor = sensor;
> +
> +	sensor->src->pads[0].flags = MEDIA_PAD_FL_SOURCE;
> +	rval = media_entity_init(&sensor->src->sd.entity, 2,
> +				 sensor->src->pads, 0);
> +	if (rval < 0)
> +		kfree(sensor);
> +
> +	return rval;
> +}
> +
> +static int __exit smiapp_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	int i;
> +
> +	if (sensor->power_count) {
> +		if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
> +			gpio_set_value(sensor->platform_data->xshutdown, 0);
> +		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
> +		sensor->power_count = 0;
> +	}
> +
> +	if (sensor->nvm) {
> +		device_remove_file(&client->dev, &dev_attr_nvm);
> +		kfree(sensor->nvm);
> +	}
> +
> +	for (i = 0; i < sensor->sds_used; i++) {
> +		media_entity_cleanup(&sensor->sds[i].sd.entity);
> +		v4l2_device_unregister_subdev(&sensor->sds[i].sd);
> +	}
> +	smiapp_free_controls(sensor);
> +	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
> +		gpio_free(sensor->platform_data->xshutdown);
> +	if (sensor->vana)
> +		regulator_put(sensor->vana);
> +
> +	kfree(sensor);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id smiapp_id_table[] = {
> +	{ SMIAPP_NAME, 0 },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(i2c, smiapp_id_table);
> +
> +static const struct dev_pm_ops smiapp_pm_ops = {
> +	.suspend	= smiapp_suspend,
> +	.resume		= smiapp_resume,
> +};
> +
> +static struct i2c_driver smiapp_i2c_driver = {
> +	.driver	= {
> +		.name = SMIAPP_NAME,
> +		.pm = &smiapp_pm_ops,
> +	},
> +	.probe	= smiapp_probe,
> +	.remove	= __exit_p(smiapp_remove),
> +	.id_table = smiapp_id_table,
> +};
> +
> +static int __init smiapp_init(void)
> +{
> +	int rval;
> +
> +	rval = i2c_add_driver(&smiapp_i2c_driver);
> +	if (rval)
> +		pr_err("Failed registering driver" SMIAPP_NAME "\n");
> +
> +	return rval;
> +}
> +
> +static void __exit smiapp_exit(void)
> +{
> +	i2c_del_driver(&smiapp_i2c_driver);
> +}
> +
> +module_init(smiapp_init);
> +module_exit(smiapp_exit);
> +
> +MODULE_AUTHOR("Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>");
> +MODULE_DESCRIPTION("Generic SMIA/SMIA++ camera module driver");
> +MODULE_LICENSE("GPL");

[snip]

> diff --git a/drivers/media/video/smiapp/smiapp-pll.c
> b/drivers/media/video/smiapp/smiapp-pll.c new file mode 100644
> index 0000000..5014730
> --- /dev/null
> +++ b/drivers/media/video/smiapp/smiapp-pll.c

[snip]

I'll send a patch on top of this one to split smiapp-pll to a separate module,
as the code is needed for at least one non-SMIA(++) Aptina sensor.

[snip]

> --git a/drivers/media/video/smiapp/smiapp-reg.h
> b/drivers/media/video/smiapp/smiapp-reg.h new file mode 100644
> index 0000000..126ca5b
> --- /dev/null
> +++ b/drivers/media/video/smiapp/smiapp-reg.h

[snip]

> +#define SMIAPP_SCALING_CAPABILITY_NONE			0
> +#define SMIAPP_SCALING_CAPABILITY_HORIZONTAL		1
> +#define SMIAPP_SCALING_CAPABILITY_BOTH			2 /* horizontal/both */

Do you mean horizontal/vertical ?

[snip]

> diff --git a/drivers/media/video/smiapp/smiapp-regs.c
> b/drivers/media/video/smiapp/smiapp-regs.c new file mode 100644
> index 0000000..9a2326a
> --- /dev/null
> +++ b/drivers/media/video/smiapp/smiapp-regs.c
> @@ -0,0 +1,230 @@
> +/*
> + * drivers/media/video/smiapp-regs.c
> + *
> + * Generic driver for SMIA/SMIA++ compliant camera modules
> + *
> + * Copyright (C) 2011--2012 Nokia Corporation
> + * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#include "smiapp-debug.h"
> +
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +
> +#include "smiapp-regs.h"
> +
> +static uint32_t float_to_u32_mul_1000000(struct i2c_client *client,
> +					 uint32_t phloat)

Now that's creative :-)

> +{
> +	int32_t exp;
> +	uint64_t man;
> +
> +	if (phloat >= 0x80000000) {
> +		dev_err(&client->dev, "this is a negative number\n");
> +		return 0;
> +	}
> +
> +	if (phloat == 0x7f800000)
> +		return ~0; /* Inf. */
> +
> +	if ((phloat & 0x7f800000) == 0x7f800000) {
> +		dev_err(&client->dev, "NaN or other special number\n");
> +		return 0;
> +	}
> +
> +	/* Valid cases begin here */
> +	if (phloat == 0)
> +		return 0; /* Valid zero */
> +
> +	if (phloat > 0x4f800000)
> +		return ~0; /* larger than 4294967295 */
> +
> +	/*
> +	 * Unbias exponent (note how phloat is now guaranteed to
> +	 * have 0 in the high bit)
> +	 */
> +	exp = ((int32_t)phloat >> 23) - 127;
> +
> +	/* Extract mantissa, add missing '1' bit and it's in MHz */
> +	man = ((phloat & 0x7fffff) | 0x800000) * 1000000ULL;
> +
> +	if (exp < 0)
> +		man >>= -exp;
> +	else
> +		man <<= exp;
> +
> +	man >>= 23; /* Remove mantissa bias */
> +
> +	return man & 0xffffffff;
> +}
> +
> +
> +/*
> + * Read a 8/16/32-bit i2c register.  The value is returned in 'val'.
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +int smia_i2c_read_reg(struct i2c_client *client, u32 reg, u32 *val)
> +{
> +	struct i2c_msg msg[1];

s/[1]// ?

> +	unsigned char data[4];
> +	unsigned int len = (u8)(reg >> 16);
> +	u16 offset = reg;
> +	int r;
> +
> +	if (!client->adapter)
> +		return -ENODEV;

Can this happen ?

> +	if (len != SMIA_REG_8BIT && len != SMIA_REG_16BIT
> +	    && len != SMIA_REG_32BIT)
> +		return -EINVAL;
> +
> +	msg->addr = client->addr;
> +	msg->flags = 0;
> +	msg->len = 2;
> +	msg->buf = data;
> +
> +	/* high byte goes out first */
> +	data[0] = (u8) (offset >> 8);
> +	data[1] = (u8) offset;
> +	r = i2c_transfer(client->adapter, msg, 1);
> +	if (r != 1) {
> +		if (r >= 0)
> +			r = -EBUSY;
> +		goto err;
> +	}
> +
> +	msg->len = len;
> +	msg->flags = I2C_M_RD;
> +	r = i2c_transfer(client->adapter, msg, 1);
> +	if (r != 1) {
> +		if (r >= 0)
> +			r = -EBUSY;
> +		goto err;
> +	}
> +
> +	*val = 0;
> +	/* high byte comes first */
> +	switch (len) {
> +	case SMIA_REG_32BIT:
> +		*val = (data[0] << 24) + (data[1] << 16) + (data[2] << 8) +
> +			data[3];
> +		break;
> +	case SMIA_REG_16BIT:
> +		*val = (data[0] << 8) + data[1];
> +		break;
> +	case SMIA_REG_8BIT:
> +		*val = data[0];
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	if (reg & SMIA_REG_FLAG_FLOAT)
> +		*val = float_to_u32_mul_1000000(client, *val);
> +
> +	return 0;
> +
> +err:
> +	dev_err(&client->dev, "read from offset 0x%x error %d\n", offset, r);
> +
> +	return r;
> +}
> +
> +static void smia_i2c_create_msg(struct i2c_client *client, u16 len, u16
> reg, +				u32 val, struct i2c_msg *msg,
> +				unsigned char *buf)
> +{
> +	msg->addr = client->addr;
> +	msg->flags = 0; /* Write */
> +	msg->len = 2 + len;
> +	msg->buf = buf;
> +
> +	/* high byte goes out first */
> +	buf[0] = (u8) (reg >> 8);
> +	buf[1] = (u8) (reg & 0xff);
> +
> +	switch (len) {
> +	case SMIA_REG_8BIT:
> +		buf[2] = val;
> +		break;
> +	case SMIA_REG_16BIT:
> +		buf[2] = val >> 8;
> +		buf[3] = val;
> +		break;
> +	case SMIA_REG_32BIT:
> +		buf[2] = val >> 24;
> +		buf[3] = val >> 16;
> +		buf[4] = val >> 8;
> +		buf[5] = val;
> +		break;
> +	default:
> +		BUG();
> +	}

As this function is reused anywhere else, I would inline ti inside 
smia_i2c_write_reg().

> +}
> +
> +/*
> + * Write to a 8/16-bit register.
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +int smia_i2c_write_reg(struct i2c_client *client, u32 reg, u32 val)
> +{
> +	struct i2c_msg msg[1];

s/[1]// ?

> +	unsigned char data[6];
> +	unsigned int retries = 5;
> +	unsigned int flags = reg >> 24;
> +	unsigned int len = (u8)(reg >> 16);
> +	u16 offset = reg;
> +	int r;
> +
> +	if (!client->adapter)
> +		return -ENODEV;

Can this happen ?

> +
> +	if ((len != SMIA_REG_8BIT && len != SMIA_REG_16BIT &&
> +	     len != SMIA_REG_32BIT) || flags)
> +		return -EINVAL;
> +
> +	smia_i2c_create_msg(client, len, offset, val, msg, data);
> +
> +	do {
> +		/*
> +		 * Due to unknown reason sensor stops responding. This
> +		 * loop is a temporaty solution until the root cause
> +		 * is found.
> +		 */
> +		r = i2c_transfer(client->adapter, msg, 1);
> +		if (r == 1)
> +			break;
> +
> +		usleep_range(2000, 2000);
> +	} while (retries--);

What about a for loop ?

> +
> +	if (r != 1) {
> +		dev_err(&client->dev,
> +			"wrote 0x%x to offset 0x%x error %d\n", val, offset, r);
> +	} else {
> +		if (r >= 0)
> +			r = -EBUSY;
> +		r = 0; /* on success i2c_transfer() return messages trasfered */

Was this added at the end of the patch just to see if I would review
everything ? :-)

> +	}
> +
> +	if (retries < 5)
> +		dev_err(&client->dev, "sensor i2c stall encountered. "
> +			"retries: %d\n", 5 - retries);

You can move this right after the loop and return an error.

> +
> +	return r;
> +}
> diff --git a/drivers/media/video/smiapp/smiapp-regs.h
> b/drivers/media/video/smiapp/smiapp-regs.h new file mode 100644
> index 0000000..20c4c25
> --- /dev/null
> +++ b/drivers/media/video/smiapp/smiapp-regs.h
> @@ -0,0 +1,46 @@
> +/*
> + * include/media/smiapp-regs.h
> + *
> + * Generic driver for SMIA/SMIA++ compliant camera modules
> + *
> + * Copyright (C) 2011--2012 Nokia Corporation
> + * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#ifndef SMIAPP_REGS_H
> +#define SMIAPP_REGS_H
> +
> +#include <linux/i2c.h>
> +#include <linux/types.h>
> +
> +/* Use upper 8 bits of the type field for flags */
> +#define SMIA_REG_FLAG_FLOAT		(1 << 24)
> +
> +#define SMIA_REG_8BIT			1
> +#define SMIA_REG_16BIT			2
> +#define SMIA_REG_32BIT			4
> +struct smia_reg {
> +	u16 type;
> +	u16 reg;			/* 16-bit offset */
> +	u32 val;			/* 8/16/32-bit value */
> +};
> +
> +int smia_i2c_read_reg(struct i2c_client *client, u32 reg, u32 *val);
> +int smia_i2c_write_reg(struct i2c_client *client, u32 reg, u32 val);

What about renaming those to smia_read() and smia_write() (or possible
smia_i2c_read() and smia_i2c_write()) ? It would help
shortening long code lines.

> +
> +#endif
> diff --git a/drivers/media/video/smiapp/smiapp.h
> b/drivers/media/video/smiapp/smiapp.h new file mode 100644
> index 0000000..df514dd
> --- /dev/null
> +++ b/drivers/media/video/smiapp/smiapp.h

[snip]

> +struct smiapp_module_ident {
> +	u8 manufacturer_id;
> +	u16 model_id;
> +	u8 revision_number_major;
> +
> +	u8 flags;
> +
> +	char *name;
> +	const struct smiapp_quirk *quirk;
> +} __packed;

Is there really a need to pack this ? You could just move
revision_number_major above model_id to save a couple of bytes and leave
packing out.

> +#define SMIAPP_IDENT_FQ(manufacturer, model, rev, fl, _name, _quirk)	\
> +	{ .manufacturer_id = manufacturer,				\
> +			.model_id = model,				\
> +			.revision_number_major = rev,			\
> +			.flags = fl,					\
> +			.name = _name,					\
> +			.quirk = _quirk, }

Any reason for the strange indentation ?

> +
> +#define SMIAPP_IDENT_LQ(manufacturer, model, rev, _name, _quirk)	\
> +	{ .manufacturer_id = manufacturer,				\
> +			.model_id = model,				\
> +			.revision_number_major = rev,			\
> +			.flags = SMIAPP_MODULE_IDENT_FLAG_REV_LE,	\
> +			.name = _name,					\
> +			.quirk = _quirk, }
> +
> +#define SMIAPP_IDENT_L(manufacturer, model, rev, _name)			\
> +	{ .manufacturer_id = manufacturer,				\
> +			.model_id = model,				\
> +			.revision_number_major = rev,			\
> +			.flags = SMIAPP_MODULE_IDENT_FLAG_REV_LE,	\
> +			.name = _name, }
> +
> +#define SMIAPP_IDENT_Q(manufacturer, model, rev, _name, _quirk)		\
> +	{ .manufacturer_id = manufacturer,				\
> +			.model_id = model,				\
> +			.revision_number_major = rev,			\
> +			.flags = 0,					\
> +			.name = _name,					\
> +			.quirk = _quirk, }
> +
> +#define SMIAPP_IDENT(manufacturer, model, rev, _name)			\
> +	{ .manufacturer_id = manufacturer,				\
> +			.model_id = model,				\
> +			.revision_number_major = rev,			\
> +			.flags = 0,					\
> +			.name = _name, }
> +

[snip]

> +/*
> + * struct smiapp_sensor - Main device structure
> + */
> +struct smiapp_sensor {
> +	/*
> +	 * "mutex" is used to serialise access to all fields here
> +	 * except v4l2_ctrls at the end of the struct. Should both
> +	 * "mutex" and the control handler locks be held
> +	 * simultaneously, the control handler lock must be acquired
> +	 * first. "mutex" is also used to serialise access to file
> +	 * handle specific information. The exception to this rule is
> +	 * the power_mutex below.
> +	 */

This comment is probably a bit outdated.

> +	struct mutex mutex;
> +	/*
> +	 * power_mutex is used to serialise opening and closing of
> +	 * file handles, including power management.
> +	 */
> +	struct mutex power_mutex;
> +	struct smiapp_subdev sds[SMIAPP_SUBDEVS];
> +	u32 sds_used;
> +	struct smiapp_subdev *src;
> +	struct smiapp_subdev *binner;
> +	struct smiapp_subdev *scaler;
> +	struct smiapp_subdev *pixel_array;
> +	struct smiapp_platform_data *platform_data;
> +	struct regulator *vana;
> +	u32 limits[SMIAPP_LIMIT_LAST];
> +	u8 nbinning_subtypes;
> +	struct smiapp_binning_subtype binning_subtypes[SMIAPP_BINNING_SUBTYPES];
> +	u32 mbus_frame_fmts;
> +	const struct smiapp_csi_data_format *csi_format;
> +	const struct smiapp_csi_data_format *internal_csi_format;
> +	u32 default_mbus_frame_fmts;
> +	int default_pixel_order;
> +
> +	u8 binning_horizontal;
> +	u8 binning_vertical;
> +
> +	u8 scale_m;
> +	u8 scaling_mode;
> +
> +	u8 hvflip_inv_mask; /* H/VFLIP inversion due to sensor orientation */
> +	u8 flash_capability;
> +	u8 frame_skip;
> +
> +	int power_count;
> +
> +	unsigned int streaming:1;
> +	unsigned int dev_init_done:1;
> +
> +	u8 *nvm;		/* nvm memory buffer */
> +	unsigned int nvm_size;	/* bytes */
> +
> +	struct smiapp_module_info minfo;
> +
> +	struct smiapp_pll pll;
> +
> +	/* Pixel array controls */
> +	struct v4l2_ctrl *analog_gain;
> +	struct v4l2_ctrl *exposure;
> +	struct v4l2_ctrl *hflip;
> +	struct v4l2_ctrl *vflip;
> +	struct v4l2_ctrl *vblank;
> +	struct v4l2_ctrl *hblank;
> +	struct v4l2_ctrl *pixel_rate_parray;
> +	/* src controls */
> +	struct v4l2_ctrl *link_freq;
> +	struct v4l2_ctrl *pixel_rate_csi;
> +};
> +
> +#define to_smiapp_subdev(_sd)				\
> +	container_of(_sd, struct smiapp_subdev, sd)
> +
> +#define to_smiapp_sensor(_sd)	\
> +	(to_smiapp_subdev(_sd)->sensor)
> +
> +int smiapp_pll_update(struct smiapp_sensor *sensor);
> +int smiapp_pll_configure(struct smiapp_sensor *sensor);
> +
> +#endif /* __SMIAPP_PRIV_H_ */

[snip]

-- 
Regards,

Laurent Pinchart

