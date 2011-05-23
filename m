Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46483 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1EWJDR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 05:03:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 1/2] MT9P031: Add support for Aptina mt9p031 sensor.
Date: Mon, 23 May 2011 11:03:26 +0200
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org
References: <1305899272-31839-1-git-send-email-javier.martin@vista-silicon.com> <Pine.LNX.4.64.1105211334260.25424@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105211334260.25424@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231103.26775.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi and Javier,

On Saturday 21 May 2011 17:29:18 Guennadi Liakhovetski wrote:
> On Fri, 20 May 2011, Javier Martin wrote:

[snip]

> > diff --git a/drivers/media/video/mt9p031.c
> > b/drivers/media/video/mt9p031.c new file mode 100644
> > index 0000000..e406b64
> > --- /dev/null
> > +++ b/drivers/media/video/mt9p031.c

[snip]

> > +#define MT9P031_ROW_START			0x01
> 
> Don't mix spaces and TABs between "#define" and the macro - just use one
> space everywhere.
> 
> > +#define		MT9P031_ROW_START_SKIP		54

That should be MT9P031_ROW_START_DEF. You should define MT9P031_ROW_START_MIN 
and MT9P031_ROW_START_MAX as well, you will need them. Same for column start, 
window height and window width.

> > +#define MT9P031_COLUMN_START			0x02
> > +#define		MT9P031_COLUMN_START_SKIP	16
> > +#define MT9P031_WINDOW_HEIGHT			0x03
> > +#define MT9P031_WINDOW_WIDTH			0x04
> > +#define MT9P031_H_BLANKING			0x05
> > +#define		MT9P031_H_BLANKING_VALUE	0
> > +#define MT9P031_V_BLANKING			0x06
> > +#define		MT9P031_V_BLANKING_VALUE	25
> > +#define MT9P031_OUTPUT_CONTROL			0x07
> > +#define		MT9P031_OUTPUT_CONTROL_CEN	2
> > +#define		MT9P031_OUTPUT_CONTROL_SYN	1
> > +#define MT9P031_SHUTTER_WIDTH_UPPER		0x08
> > +#define MT9P031_SHUTTER_WIDTH			0x09
> > +#define MT9P031_PIXEL_CLOCK_CONTROL		0x0a
> > +#define MT9P031_FRAME_RESTART			0x0b
> > +#define MT9P031_SHUTTER_DELAY			0x0c
> > +#define MT9P031_RST				0x0d
> > +#define		MT9P031_RST_ENABLE		1
> > +#define		MT9P031_RST_DISABLE		0
> > +#define MT9P031_READ_MODE_1			0x1e
> > +#define MT9P031_READ_MODE_2			0x20
> > +#define		MT9P031_READ_MODE_2_ROW_MIR	0x8000
> > +#define		MT9P031_READ_MODE_2_COL_MIR	0x4000
> > +#define MT9P031_ROW_ADDRESS_MODE		0x22
> > +#define MT9P031_COLUMN_ADDRESS_MODE		0x23
> > +#define MT9P031_GLOBAL_GAIN			0x35
> > +
> > +#define MT9P031_MAX_HEIGHT			1944
> > +#define MT9P031_MAX_WIDTH			2592
> > +#define MT9P031_MIN_HEIGHT			2
> > +#define MT9P031_MIN_WIDTH			18

You can get rid of those 4 #define's and use MT9P031_WINDOW_(HEIGHT|
WIDTH)_(MIN|MAX) instead.

> > +struct mt9p031 {
> > +	struct v4l2_subdev subdev;
> > +	struct media_pad pad;
> > +	struct v4l2_rect rect;	/* Sensor window */
> > +	struct v4l2_mbus_framefmt format;
> > +	struct mt9p031_platform_data *pdata;
> > +	struct mutex power_lock;
> 
> Don't locks _always_ have to be documented? And this one: you only protect
> set_power() with it, Laurent, is this correct?

You're right, locks have to always be documented, either inline or in a 
comment block above the structure. A small comment such as /* Protects 
power_count */ is enough.

> > +	int power_count;
> > +	u16 xskip;
> > +	u16 yskip;
> > +	u16 output_control;
> > +	struct regulator *reg_1v8;
> > +	struct regulator *reg_2v8;
> > +};

[snip]

> > +static int mt9p031_reset(struct i2c_client *client)
> > +{
> > +	struct mt9p031 *mt9p031 = to_mt9p031(client);
> > +	int ret;
> > +
> > +	/* Disable chip output, synchronous option update */
> > +	ret = reg_write(client, MT9P031_RST, MT9P031_RST_ENABLE);
> > +	if (ret < 0)
> > +		return -EIO;
> > +	ret = reg_write(client, MT9P031_RST, MT9P031_RST_DISABLE);
> > +	if (ret < 0)
> > +		return -EIO;
> > +	ret = mt9p031_set_output_control(mt9p031, MT9P031_OUTPUT_CONTROL_CEN,
> > 0); +	if (ret < 0)
> > +		return -EIO;
> > +	return 0;
> 
> I think, a sequence like
> 
> 	ret = fn();
> 	if (!ret)
> 		ret = fn();
> 	if (!ret)
> 		ret = fn();
> 	return ret;
> 
> is a better way to achieve the same.

I disagree with you on that :-) I find code sequences that return as soon as 
an error occurs, using the main code path for the error-free case, easier to 
read. It can be a matter of personal taste though.

This being said, the function can end with

	return mt9p031_set_output_control(mt9p031, MT9P031_OUTPUT_CONTROL_CEN, 0);

instead of

	ret = mt9p031_set_output_control(mt9p031, MT9P031_OUTPUT_CONTROL_CEN, 0);
	if (ret < 0)
		return -EIO;
	return 0;
 
> > +}
> > +
> > +static int mt9p031_power_on(struct mt9p031 *mt9p031)
> > +{
> > +	int ret;
> > +
> > +	/* turn on VDD_IO */
> > +	ret = regulator_enable(mt9p031->reg_2v8);
> > +	if (ret) {
> > +		pr_err("Failed to enable 2.8v regulator: %d\n", ret);
> 
> dev_err()
> 
> > +		return ret;
> > +	}
> > +	if (mt9p031->pdata->set_xclk)
> > +		mt9p031->pdata->set_xclk(&mt9p031->subdev, 54000000);

Can you make 54000000 a #define at the beginning of the file ?

You should soft-reset the chip here by calling mt9p031_reset().

> > +
> > +	return 0;
> > +}

[snip]

> > +static u16 mt9p031_skip_for_crop(s32 source, s32 *target, s32 max_skip)
> > +{
> > +	unsigned int skip;
> > +
> > +	if (source - source / 4 < *target) {
> > +		*target = source;
> > +		return 1;
> > +	}
> > +
> > +	skip = DIV_ROUND_CLOSEST(source, *target);
> > +	if (skip > max_skip)
> > +		skip = max_skip;
> > +	*target = 2 * DIV_ROUND_UP(source, 2 * skip);
> > +
> > +	return skip;
> > +}
> > +
> > +static int mt9p031_set_params(struct i2c_client *client,
> > +			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
> > +{
> > +	struct mt9p031 *mt9p031 = to_mt9p031(client);
> > +	int ret;
> > +	u16 xbin, ybin;
> > +	const u16 hblank = MT9P031_H_BLANKING_VALUE,
> > +		vblank = MT9P031_V_BLANKING_VALUE;
> > +	/*
> > +	 * TODO: Attention! When implementing horizontal flipping, adjust
> > +	 * alignment according to R2 "Column Start" description in the
> > datasheet +	 */
> > +	if (xskip & 1) {
> > +		xbin = 1;
> > +		rect->left &= ~3;
> > +	} else if (xskip & 2) {
> > +		xbin = 2;
> > +		rect->left &= ~7;
> > +	} else {
> > +		xbin = 4;
> > +		rect->left &= ~15;
> > +	}

Please don't modify the rectangle here. It needs to have been properly 
validated and/or modified before mt9p031_set_params() is called. This function 
should *only* apply parameters to the chip (possibly computing some of them on 
the fly). It must not modify any parameter.

> > +
> > +	ybin = min(yskip, (u16)4);
> > +
> > +	rect->top &= ~1;
> > +
> > +	/* Disable register update, reconfigure atomically */
> > +	ret = mt9p031_set_output_control(mt9p031, 0,
> > MT9P031_OUTPUT_CONTROL_SYN); +	if (ret < 0)
> > +		return ret;
> > +
> > +	dev_dbg(&client->dev, "skip %u:%u, rect %ux%u@%u:%u\n",
> > +		xskip, yskip, rect->width, rect->height, rect->left, rect->top);
> > +
> > +	/* Blanking and start values - default... */
> > +	ret = reg_write(client, MT9P031_H_BLANKING, hblank);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = reg_write(client, MT9P031_V_BLANKING, vblank);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = reg_write(client, MT9P031_COLUMN_ADDRESS_MODE,
> > +				((xbin - 1) << 4) | (xskip - 1));
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = reg_write(client, MT9P031_ROW_ADDRESS_MODE,
> > +				((ybin - 1) << 4) | (yskip - 1));
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	dev_dbg(&client->dev, "new physical left %u, top %u\n",
> > +		rect->left, rect->top);
> > +
> > +	ret = reg_write(client, MT9P031_COLUMN_START,
> > +				rect->left + MT9P031_COLUMN_START_SKIP);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = reg_write(client, MT9P031_ROW_START,
> > +				rect->top + MT9P031_ROW_START_SKIP);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = reg_write(client, MT9P031_WINDOW_WIDTH,
> > +				rect->width - 1);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = reg_write(client, MT9P031_WINDOW_HEIGHT,
> > +				rect->height - 1);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* Re-enable register update, commit all changes */
> > +	ret = mt9p031_set_output_control(mt9p031, MT9P031_OUTPUT_CONTROL_SYN,
> > 0); +	if (ret < 0)
> > +		return ret;
> > +
> 
> Ditto with "ret = fn();"
> 
> > +	mt9p031->xskip = xskip;
> > +	mt9p031->yskip = yskip;
> > +	return ret;
> > +}
> > +
> > +static int mt9p031_set_crop(struct v4l2_subdev *sd,
> > +				struct v4l2_subdev_fh *fh,
> > +				struct v4l2_subdev_crop *crop)
> > +{
> > +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> > +	struct v4l2_mbus_framefmt *f;
> > +	struct v4l2_rect *c;
> > +	struct v4l2_rect rect;
> > +	u16 xskip, yskip;
> > +	s32 width, height;
> > +
> > +	pr_info("%s(%ux%u@%u:%u : %u)\n", __func__,
> > +			crop->rect.width, crop->rect.height,
> > +			crop->rect.left, crop->rect.top, crop->which);
> 
> dev_dbg()
> 
> > +
> > +	/*
> > +	 * Clamp the crop rectangle boundaries and align them to a multiple of
> > 2 +	 * pixels.
> > +	 */
> > +	rect.width = ALIGN(clamp(crop->rect.width,
> > +				 MT9P031_MIN_WIDTH, MT9P031_MAX_WIDTH), 2);
> > +	rect.height = ALIGN(clamp(crop->rect.height,
> > +				  MT9P031_MIN_HEIGHT, MT9P031_MAX_HEIGHT), 2);
> > +	rect.left = ALIGN(clamp(crop->rect.left,
> > +				0, MT9P031_MAX_WIDTH - rect.width), 2);
> > +	rect.top = ALIGN(clamp(crop->rect.top,
> > +			       0, MT9P031_MAX_HEIGHT - rect.height), 2);
> > +
> > +	c = mt9p031_get_pad_crop(mt9p031, fh, crop->pad, crop->which);
> > +
> > +	if (rect.width != c->width || rect.height != c->height) {
> > +		/*
> > +		 * Reset the output image size if the crop rectangle size has
> > +		 * been modified.
> > +		 */
> > +		f = mt9p031_get_pad_format(mt9p031, fh, crop->pad,
> > +						    crop->which);
> > +		width = f->width;
> > +		height = f->height;
> > +
> > +		xskip = mt9p031_skip_for_crop(rect.width, &width, 7);
> > +		yskip = mt9p031_skip_for_crop(rect.height, &height, 8);
> > +	} else {
> > +		xskip = mt9p031->xskip;
> > +		yskip = mt9p031->yskip;
> > +		f = NULL;
> > +	}
> 
> Hm, looks like something is missing here: you dropped
> 
> 	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> 		ret = mt9p031_set_params(client, &rect, xskip, yskip);
> 		if (ret < 0)
> 			return ret;
> 	}
> 
> from my version, without which no cropping is actually taking place. Or
> have you also switched to the convention of only configuring the hardware
> on set_stream(1)?

I think it's fine to configure formats at set_stream(1) time only, but crop 
rectangles should be settable when the stream is running. Their size can't 
change though. The mt9v032 driver doesn't support that, I need to fix it to 
provide a (hopefully) clean example of how to implement his.

> > +	if (f) {
> > +		f->width = width;
> > +		f->height = height;
> > +	}
> > +
> > +	*c = rect;
> > +	crop->rect = rect;
> > +
> > +	mt9p031->xskip = xskip;
> > +	mt9p031->yskip = yskip;
> > +	mt9p031->rect = *c;
> > +	return 0;
> > +}

[snip]

> > +static u16 mt9p031_skip_for_scale(s32 *source, s32 target,
> > +					s32 max_skip, s32 max)
> > +{
> > +	unsigned int skip;
> > +
> > +	if (*source - *source / 4 < target) {
> > +		*source = target;
> > +		return 1;
> > +	}
> > +
> > +	skip = min(max, *source + target / 2) / target;
> > +	if (skip > max_skip)
> > +		skip = max_skip;
> > +	*source = target * skip;
> > +
> > +	return skip;
> > +}
> > +
> > +static int mt9p031_fmt_validate(struct v4l2_subdev *sd,
> > +				struct v4l2_subdev_format *fmt)
> > +{
> > +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> > +	struct v4l2_mbus_framefmt *format = &fmt->format;
> > +
> > +	if (format->code != mt9p031->format.code || fmt->pad)
> > +		return -EINVAL;

There's no need to check pad->fmt, it has already been validated by 
subdev_do_ioctl().

You should also not return an error when the code is invalid. As the MT9P031 
only supports one code, you can just hardcode it

	format->code = V4L2_MBUS_FMT_SGRBG12_1X12;

> > +
> > +	format->colorspace = V4L2_COLORSPACE_SRGB;
> > +	format->width = clamp_t(int, ALIGN(format->width, 2), 2,
> > +						MT9P031_MAX_WIDTH);
> > +	format->height = clamp_t(int, ALIGN(format->height, 2), 2,
> > +						MT9P031_MAX_HEIGHT);
> > +	format->field = V4L2_FIELD_NONE;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mt9p031_set_format(struct v4l2_subdev *sd,
> > +				struct v4l2_subdev_fh *fh,
> > +				struct v4l2_subdev_format *fmt)
> > +{
> > +	struct v4l2_subdev_format sdf = *fmt;
> > +	struct v4l2_mbus_framefmt *f, *format = &sdf.format;

Do you really need to make a copy of the requested format and work on it here 
? Can't you instead take the only fmt members that are configurable (width and 
height), clamp/mangle them, copy them to the mt9p031_get_pad_format() return 
pointer, and copy back the whole format structure to userspace ? Have a look 
at the mt9v032_set_format() function, I think it's easier to understand than 
what mt9p031_set_format() does.

> > +	struct v4l2_rect *c, rect;
> > +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> > +	u16 xskip, yskip;
> > +	int ret;
> > +
> > +	ret = mt9p031_fmt_validate(sd, &sdf);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	f = mt9p031_get_pad_format(mt9p031, fh, fmt->pad, fmt->which);
> > +
> > +	if (f->width == format->width && f->height == format->height)
> > +		return 0;

If width and height match, the other fields won't be copied back to userspace.

Please consider copying the mt9v032_set_format() code, unless you think it's 
not applicable for the mt9p031.

> > +
> > +
> 
> One empty line is usually enough, especially inside a function.
> 
> > +	c = mt9p031_get_pad_crop(mt9p031, fh, fmt->pad, fmt->which);
> > +
> > +	rect.width = c->width;
> > +	rect.height = c->height;
> > +
> > +	xskip = mt9p031_skip_for_scale(&rect.width, format->width, 7,
> > +				       MT9P031_MAX_WIDTH);
> > +	if (rect.width + c->left > MT9P031_MAX_WIDTH)
> > +		rect.left = (MT9P031_MAX_WIDTH - rect.width) / 2;
> > +	else
> > +		rect.left = c->left;
> > +	yskip = mt9p031_skip_for_scale(&rect.height, format->height, 8,
> > +				       MT9P031_MAX_HEIGHT);
> > +	if (rect.height + c->top > MT9P031_MAX_HEIGHT)
> > +		rect.top = (MT9P031_MAX_HEIGHT - rect.height) / 2;
> > +	else
> > +		rect.top = c->top;
> > +
> > +
> > +	pr_info("%s(%ux%u : %u)\n", __func__,
> > +		format->width, format->height, fmt->which);
> 
> dev_dbg()
> 
> > +	if (c)
> > +		*c = rect;
> > +
> > +	*f = *format;
> > +	fmt->format = *format;
> > +
> > +	mt9p031->xskip = xskip;
> > +	mt9p031->yskip = yskip;
> > +	mt9p031->rect = *c;
> > +	return 0;
> > +}
> > +
> > +static int mt9p031_s_stream(struct v4l2_subdev *sd, int enable)
> > +{
> > +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> > +	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
> > +	struct v4l2_rect rect = mt9p031->rect;
> > +	u16 xskip = mt9p031->xskip;
> > +	u16 yskip = mt9p031->yskip;
> > +	int ret;
> > +
> > +	if (enable) {
> > +		ret = mt9p031_set_params(client, &rect, xskip, yskip);

mt9p031_set_params() is only called here. Why don't you pass it the mt9p031 
pointer instead of the client pointer, and have it access the rectangle, xskip 
and yskip members directly ?

> > +		if (ret < 0)
> > +			return ret;
> > +		/* Switch to master "normal" mode */
> > +		ret = mt9p031_set_output_control(mt9p031, 0,
> > MT9P031_OUTPUT_CONTROL_CEN);
> > +	} else {
> > +		/* Stop sensor readout */
> > +		ret = mt9p031_set_output_control(mt9p031, MT9P031_OUTPUT_CONTROL_CEN,
> > 0);
> > +	}
> > +	if (ret < 0)
> > +		return -EIO;
> > +
> > +	return 0;

Just replace those 4 lines by return ret; or, even better, return the result 
of the above mt9p031_set_output_control() calls directly.

> > +}
> > +
> > +/*
> > + * Interface active, can use i2c. If it fails, it can indeed mean, that
> > + * this wasn't our capture interface, so, we wait for the right one

I'm not sure to see where/how you wait for the right one :-)

> > + */
> > +static int mt9p031_video_probe(struct i2c_client *client)
> > +{
> > +	s32 data;
> > +	int ret;
> > +
> > +	/* Read out the chip version register */
> > +	data = reg_read(client, MT9P031_CHIP_VERSION);
> > +	if (data != MT9P031_CHIP_VERSION_VALUE) {
> > +		dev_err(&client->dev,
> > +			"No MT9P031 chip detected, register read %x\n", data);
> > +		return -ENODEV;
> > +	}
> > +
> > +	dev_info(&client->dev, "Detected a MT9P031 chip ID %x\n", data);
> > +
> > +	ret = mt9p031_reset(client);
> > +	if (ret < 0)
> > +		dev_err(&client->dev, "Failed to initialise the camera\n");

If you move the soft-reset operation to mt9p031_power_on(), you don't need to 
call it here.

> > +	return ret;
> > +}

[snip]

> > +static int mt9p031_registered(struct v4l2_subdev *sd)
> > +{
> > +	struct mt9p031 *mt9p031 = container_of(sd, struct mt9p031, subdev);
> > +	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
> > +	int ret;
> > +
> > +	ret = mt9p031_set_power(&mt9p031->subdev, 1);
> > +	if (ret) {
> > +		pr_err("Failed to power on device: %d\n", ret);
> 
> dev_err()
> 
> > +		goto pwron;

I would rename the goto labels to start with err_ or error_.

> > +	}
> > +	if (mt9p031->pdata->reset)
> > +		mt9p031->pdata->reset(&mt9p031->subdev, 1);
> > +	msleep(50);
> > +	if (mt9p031->pdata->reset)
> > +		mt9p031->pdata->reset(&mt9p031->subdev, 0);
> > +	msleep(50);

If there's no reset operation you don't need to msleep(), so something like

	if (mt9p031->pdata->reset) {
		mt9p031->pdata->reset(&mt9p031->subdev, 1);
		msleep(50);
		mt9p031->pdata->reset(&mt9p031->subdev, 0);
		msleep(50);
	}

is better. Where does the 50ms value come from ? It sounds quite long to me.

> > +
> > +	ret = mt9p031_video_probe(client);
> > +	if (ret)
> > +		goto evprobe;
> > +
> > +	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +	ret = media_entity_init(&mt9p031->subdev.entity, 1, &mt9p031->pad, 0);
> > +	if (ret)
> > +		goto evprobe;
> > +
> > +	mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +	mt9p031_set_power(&mt9p031->subdev, 0);
> > +
> > +	return 0;
> > +evprobe:
> > +	mt9p031_set_power(&mt9p031->subdev, 0);
> > +pwron:
> > +	return ret;
> > +}
> > +
> > +static int mt9p031_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> > *fh) +{
> > +	struct mt9p031 *mt9p031;
> > +	mt9p031 = container_of(sd, struct mt9p031, subdev);
> > +
> > +	return mt9p031_set_power(sd, 1);
> 
> Is open() called only for the first open, or for each one? If for each,
> you'll want to reference count yourself. Besides, isn't
> core_ops::s_power() called anyway, maybe you don't need these open() /
> close() at all?

It's called for each open. mt9p031_set_power() includes reference counting, so 
this should be safe.

core_ops::s_power() isn't called on open().

Javier, you should also initialize the crop and format settings in 
v4l2_subdev_fh to default values. Please see the mt9v032 driver.

> > +}

[snip]

> > +static int mt9p031_probe(struct i2c_client *client,
> > +			 const struct i2c_device_id *did)
> > +{
> > +	struct mt9p031 *mt9p031;
> > +	struct mt9p031_platform_data *pdata = client->dev.platform_data;
> > +	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> > +	int ret;
> > +
> > +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> > +		dev_warn(&adapter->dev,
> > +			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> > +		return -EIO;
> > +	}
> > +
> > +	mt9p031 = kzalloc(sizeof(struct mt9p031), GFP_KERNEL);
> > +	if (!mt9p031)
> > +		return -ENOMEM;
> > +
> > +	mutex_init(&mt9p031->power_lock);
> > +	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
> > +	mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;
> > +
> > +	mt9p031->pdata		= pdata;
> > +	mt9p031->rect.left	= 0;
> > +	mt9p031->rect.top	= 0;
> 
> No need - kzalloc() has nullified it for you.

According to the datasheet, the Row Start and Column Start default values are 
54 and 16. You should use them instead of 0 (and add #define's for them at the 
beginning of the file). You should expose the real sensor coordinates through 
the crop operations, don't try to add/subtract offsets internally in the 
driver.

> > +	mt9p031->rect.width	= MT9P031_MAX_WIDTH;
> > +	mt9p031->rect.height	= MT9P031_MAX_HEIGHT;
> > +
> > +	mt9p031->format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
> > +
> > +	mt9p031->format.width = MT9P031_MAX_WIDTH;
> > +	mt9p031->format.height = MT9P031_MAX_HEIGHT;
> > +	mt9p031->format.field = V4L2_FIELD_NONE;
> > +	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
> > +
> > +	mt9p031->xskip = 1;
> > +	mt9p031->yskip = 1;
> > +
> > +	mt9p031->reg_1v8 = regulator_get(NULL, "cam_1v8");
> > +	if (IS_ERR(mt9p031->reg_1v8)) {
> > +		ret = PTR_ERR(mt9p031->reg_1v8);
> > +		pr_err("Failed 1.8v regulator: %d\n", ret);
> 
> dev_err()
> 
> > +		goto e1v8;
> > +	}

The driver can be used with boards where either or both of the 1.8V and 2.8V 
supplies are always on, thus not connected to any regulator. I'm not sure how 
that's usually handled, if board code should define an "always-on" power 
supply, or if the driver shouldn't fail when no regulator is present. In any 
case, this must be handled.

> > +
> > +	mt9p031->reg_2v8 = regulator_get(NULL, "cam_2v8");
> > +	if (IS_ERR(mt9p031->reg_2v8)) {
> > +		ret = PTR_ERR(mt9p031->reg_2v8);
> > +		pr_err("Failed 2.8v regulator: %d\n", ret);
> 
> ditto
> 
> > +		goto e2v8;
> > +	}
> > +	/* turn on core */
> > +	ret = regulator_enable(mt9p031->reg_1v8);
> > +	if (ret) {
> > +		pr_err("Failed to enable 1.8v regulator: %d\n", ret);
> 
> ditto
> 
> > +		goto e1v8en;
> > +	}
> > +	return 0;

Why do you leave core power on at the end of probe() ? You should only turn it 
on when needed.

> > +e1v8en:
> > +	regulator_put(mt9p031->reg_2v8);
> > +e2v8:
> > +	regulator_put(mt9p031->reg_1v8);
> > +e1v8:
> > +	kfree(mt9p031);
> > +	return ret;
> > +}

-- 
Regards,

Laurent Pinchart
