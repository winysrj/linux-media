Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55080 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2CJMRu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 07:17:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v5 1/1] v4l: Add driver for Micron MT9M032 camera sensor
Date: Sat, 10 Mar 2012 13:17:58 +0100
Message-ID: <1859441.NBMQGniVTr@avalon>
In-Reply-To: <4F5A7667.4000709@gmail.com>
References: <1331305285-10781-6-git-send-email-laurent.pinchart@ideasonboard.com> <1331324481-9926-1-git-send-email-laurent.pinchart@ideasonboard.com> <4F5A7667.4000709@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 09 March 2012 22:30:15 Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> I have a few minor comments, if you don't mind. :)

Sure, thanks for the review.

> On 03/09/2012 09:21 PM, Laurent Pinchart wrote:
> > From: Martin Hostettler<martin@neutronstar.dyndns.org>
> > 
> > The MT9M032 is a parallel 1.6MP sensor from Micron controlled through I2C.
> > 
> > The driver creates a V4L2 subdevice. It currently supports cropping, gain,
> > exposure and v/h flipping controls in monochrome mode with an
> > external pixel clock.
> > 
> > Signed-off-by: Martin Hostettler<martin@neutronstar.dyndns.org>
> > [Lots of clean up, fixes and enhancements]
> > Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>

[snip]

> > diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
> > new file mode 100644
> > index 0000000..f2f6168
> > --- /dev/null
> > +++ b/drivers/media/video/mt9m032.c

[snip]

> > +/*
> > + * width and height include active boundary and black parts
> > + *
> > + * column    0-  15 active boundry
> > + * column   16-1455 image
> > + * column 1456-1471 active boundry
> > + * column 1472-1599 black
> > + *
> > + * row       0-  51 black
> > + * row      53-  59 active boundry
> > + * row      60-1139 image
> > + * row    1140-1147 active boundry
> 
> s/boundry/boundary

Fixed.

> > + * row    1148-1151 black
> > + */

[snip]

> > +static u32 mt9m032_row_time(struct mt9m032 *sensor, unsigned int width)
> > +{
> > +	unsigned int effective_width;
> > +	u32 ns;
> > +
> > +	effective_width = width + 716; /* emperical value */
> 
> s/emperical/empirical

Fixed.

> > +	ns = div_u64(1000000000ULL * effective_width, sensor->pix_clock);
> > +	dev_dbg(to_dev(sensor),	"MT9M032 line time: %u ns\n", ns);
> > +	return ns;
> > +}

[snip]

> > +/**
> > + * __mt9m032_get_pad_crop() - get crop rect
> > + * @sensor: pointer to the sensor struct
> > + * @fh: filehandle for getting the try crop rect from
> 
> s/filehandle/ file handle ?

Fixed.

> > + * @which: select try or active crop rect
> > + *
> > + * Returns a pointer the current active or fh relative try crop rect
> > + */
> > +static struct v4l2_rect *
> > +__mt9m032_get_pad_crop(struct mt9m032 *sensor, struct v4l2_subdev_fh *fh,
> > +		       enum v4l2_subdev_format_whence which)
> > +{
> > +	switch (which) {
> > +	case V4L2_SUBDEV_FORMAT_TRY:
> > +		return v4l2_subdev_get_try_crop(fh, 0);
> > +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> > +		return&sensor->crop;
> > +	default:
> > +		return NULL;
> > +	}
> > +}
> > +
> > +/**
> > + * __mt9m032_get_pad_format() - get format
> > + * @sensor: pointer to the sensor struct
> > + * @fh: filehandle for getting the try format from
> 
> s/filehandle/ file handle ?

Fixed.

> > + * @which: select try or active format
> > + *
> > + * Returns a pointer the current active or fh relative try format
> > + */
> > +static struct v4l2_mbus_framefmt *
> > +__mt9m032_get_pad_format(struct mt9m032 *sensor, struct v4l2_subdev_fh
> > *fh, +			 enum v4l2_subdev_format_whence which)
> > +{
> > +	switch (which) {
> > +	case V4L2_SUBDEV_FORMAT_TRY:
> > +		return v4l2_subdev_get_try_format(fh, 0);
> > +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> > +		return&sensor->format;
> > +	default:
> > +		return NULL;
> > +	}
> > +}

[snip]

> > +static int update_read_mode2(struct mt9m032 *sensor, bool vflip, bool
> > hflip) +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > +	int reg_val = (!!vflip)<<  MT9M032_READ_MODE2_VFLIP_SHIFT
> > +		    | (!!hflip)<<  MT9M032_READ_MODE2_HFLIP_SHIFT
> 
> You don't need !! here, since the type of hflip, vflip is already bool.
> The arguments will be converted to bool values when being passed to this
> function.

Fixed.

> > +		    | MT9M032_READ_MODE2_ROW_BLC
> > +		    | 0x0007;
> > +
> > +	return mt9m032_write(client, MT9M032_READ_MODE2, reg_val);
> > +}
> > +
> > +static int mt9m032_set_gain(struct mt9m032 *sensor, s32 val)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > +	int digital_gain_val;	/* in 1/8th (0..127) */
> > +	int analog_mul;		/* 0 or 1 */
> > +	int analog_gain_val;	/* in 1/16th. (0..63) */
> > +	u16 reg_val;
> > +
> > +	digital_gain_val = 51; /* from setup example */
> > +
> > +	if (val<  63) {
> > +		analog_mul = 0;
> > +		analog_gain_val = val;
> > +	} else {
> > +		analog_mul = 1;
> > +		analog_gain_val = val / 2;
> > +	}
> > +
> > +	/* a_gain = (1+analog_mul) + (analog_gain_val+1)/16 */
> 
> nit: I would use same whitespacing rules as for the line below.

Fixed.

> > +	/* overall_gain = a_gain * (1 + digital_gain_val / 8) */
> > +
> > +	reg_val = ((digital_gain_val&  MT9M032_GAIN_DIGITAL_MASK)
> > +		<<  MT9M032_GAIN_DIGITAL_SHIFT)
> > +		| ((analog_mul&  1)<<  MT9M032_GAIN_AMUL_SHIFT)
> > +		| (analog_gain_val&  MT9M032_GAIN_ANALOG_MASK);
> > +
> > +	return mt9m032_write(client, MT9M032_GAIN_ALL, reg_val);
> > +}

[snip]

> > +static int mt9m032_set_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct mt9m032 *sensor =
> > +		container_of(ctrl->handler, struct mt9m032, ctrls);
> > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > +	int ret;
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_GAIN:
> > +		return mt9m032_set_gain(sensor, ctrl->val);
> > +
> > +	case V4L2_CID_HFLIP:
> > +	case V4L2_CID_VFLIP:
>
> mt9m032_set_ctrl() will never be called with V4L2_CID_VFLIP control id,
> since the first control in the cluster is HFLIP.

I agree that V4L2_CID_VFLIP will never be seen here, but I find it more 
explicit to list all controls in the cluster. What do you think of something 
like the following ?

        case V4L2_CID_HFLIP:
        /* case V4L2_CID_VFLIP: -- In the same cluster */
 
> > +		return update_read_mode2(sensor, sensor->vflip->val,
> > +					 sensor->hflip->val);
> > +
> > +	case V4L2_CID_EXPOSURE:
> > +		ret = mt9m032_write(client, MT9M032_SHUTTER_WIDTH_HIGH,
> > +				    (ctrl->val>>  16)&  0xffff);
> > +		if (ret<  0)
> > +			return ret;
> > +
> > +		return mt9m032_write(client, MT9M032_SHUTTER_WIDTH_LOW,
> > +				     ctrl->val&  0xffff);
> > +
> 
> > +	default:
> This is an impossible case, isn't it ? The control framework won't call
> s_ctrl op for controls that were never registered to the control handler,
> AFAIK. So it should be safe to omit the "default" case. OTOH some rules say
> that it is a good practice to always have the "default" case with a switch
> statement.

I'll remove it.

> > +		return -EINVAL;
> > +	}
> > +}

[snip]

> > +static int mt9m032_probe(struct i2c_client *client,
> > +			 const struct i2c_device_id *devid)
> > +{
> > +	struct i2c_adapter *adapter = client->adapter;
> > +	struct mt9m032 *sensor;
> > +	int chip_version;
> > +	int ret;
> > +
> > +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> > +		dev_warn(&client->dev,
> > +			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> > +		return -EIO;
> > +	}
> > +
> > +	if (!client->dev.platform_data)
> > +		return -ENODEV;
> > +
> > +	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
> 
> Haven't you consider using devm_kzalloc() ?
> (http://www.kernel.org/doc/htmldocs/device-drivers/API-devm-kzalloc.html)
> It would slightly simplify the code, however it will use a couple of bytes
> of memory for the resource tracking.

I came across that recently and haven't made my mind up yet :-) I'll need to 
try it.

> > +	if (sensor == NULL)
> > +		return -ENOMEM;
> > +
> > +	mutex_init(&sensor->lock);
> > +
> > +	sensor->pdata = client->dev.platform_data;
> > +
> > +	v4l2_i2c_subdev_init(&sensor->subdev, client,&mt9m032_ops);
> > +	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +
> > +	chip_version = mt9m032_read(client, MT9M032_CHIP_VERSION);
> > +	if (chip_version != MT9M032_CHIP_VERSION_VALUE) {
> > +		dev_err(&client->dev, "MT9M032 not detected, wrong version "
> > +			"0x%04x\n", chip_version);
> > +		ret = -ENODEV;
> > +		goto error_sensor;
> > +	}
> > +
> > +	dev_info(&client->dev, "MT9M032 detected at address 0x%02x\n",
> > +		 client->addr);
> > +
> > +	sensor->frame_interval.numerator = 1;
> > +	sensor->frame_interval.denominator = 30;
> > +
> > +	sensor->crop.left = MT9M032_COLUMN_START_DEF;
> > +	sensor->crop.top = MT9M032_ROW_START_DEF;
> > +	sensor->crop.width = MT9M032_COLUMN_SIZE_DEF;
> > +	sensor->crop.height = MT9M032_ROW_SIZE_DEF;
> > +
> > +	sensor->format.width = sensor->crop.width;
> > +	sensor->format.height = sensor->crop.height;
> > +	sensor->format.code = V4L2_MBUS_FMT_Y8_1X8;
> > +	sensor->format.field = V4L2_FIELD_NONE;
> > +	sensor->format.colorspace = V4L2_COLORSPACE_SRGB;
> > +
> > +	v4l2_ctrl_handler_init(&sensor->ctrls, 4);
> > +
> > +	v4l2_ctrl_new_std(&sensor->ctrls,&mt9m032_ctrl_ops,
> > +			  V4L2_CID_GAIN, 0, 127, 1, 64);
> > +
> > +	sensor->hflip = v4l2_ctrl_new_std(&sensor->ctrls,
> > +					&mt9m032_ctrl_ops,
> > +					  V4L2_CID_HFLIP, 0, 1, 1, 0);
> > +	sensor->vflip = v4l2_ctrl_new_std(&sensor->ctrls,
> > +					&mt9m032_ctrl_ops,
> > +					  V4L2_CID_VFLIP, 0, 1, 1, 0);
> > +
> > +	v4l2_ctrl_new_std(&sensor->ctrls,&mt9m032_ctrl_ops,
> > +			  V4L2_CID_EXPOSURE, MT9M032_SHUTTER_WIDTH_MIN,
> > +			  MT9M032_SHUTTER_WIDTH_MAX, 1,
> > +			  MT9M032_SHUTTER_WIDTH_DEF);
> > +
> > +	if (sensor->ctrls.error) {
> > +		ret = sensor->ctrls.error;
> > +		dev_err(&client->dev, "control initialization error %d\n", ret);
> > +		goto error_ctrl;
> > +	}
> > +
> > +	v4l2_ctrl_cluster(2,&sensor->hflip);
> > +
> > +	sensor->subdev.ctrl_handler =&sensor->ctrls;
> > +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +	ret = media_entity_init(&sensor->subdev.entity, 1,&sensor->pad, 0);
> > +	if (ret<  0)
> > +		goto error_ctrl;
> > +
> > +	ret = mt9m032_write(client, MT9M032_RESET, 1);	/* reset on */
> > +	if (ret<  0)
> > +		goto error_entity;
> > +	mt9m032_write(client, MT9M032_RESET, 0);	/* reset off */
> > +	if (ret<  0)
> > +		goto error_entity;
> > +
> > +	ret = mt9m032_setup_pll(sensor);
> > +	if (ret<  0)
> > +		goto error_entity;
> > +	usleep_range(10000, 11000);
> > +
> > +	v4l2_ctrl_handler_setup(&sensor->ctrls);
> 
> I guess you ignore the return value delibrately ?

Not really. I'll add an error check.

> > +	/* SIZE */
> > +	ret = mt9m032_update_geom_timing(sensor);
> > +	if (ret<  0)
> > +		goto error_entity;
> > +
> > +	ret = mt9m032_write(client, 0x41, 0x0000);	/* reserved !!! */
> > +	if (ret<  0)
> > +		goto error_entity;
> > +	ret = mt9m032_write(client, 0x42, 0x0003);	/* reserved !!! */
> > +	if (ret<  0)
> > +		goto error_entity;
> > +	ret = mt9m032_write(client, 0x43, 0x0003);	/* reserved !!! */
> > +	if (ret<  0)
> > +		goto error_entity;
> > +	ret = mt9m032_write(client, 0x7f, 0x0000);	/* reserved !!! */
> > +	if (ret<  0)
> > +		goto error_entity;
> > +	if (sensor->pdata->invert_pixclock) {
> > +		ret = mt9m032_write(client, MT9M032_PIX_CLK_CTRL,
> > +				    MT9M032_PIX_CLK_CTRL_INV_PIXCLK);
> > +		if (ret<  0)
> > +			goto error_entity;
> > +	}
> > +
> > +	ret = mt9m032_write(client, MT9M032_RESTART, 1); /* Restart on */
> > +	if (ret<  0)
> > +		goto error_entity;
> > +	msleep(100);
> > +	ret = mt9m032_write(client, MT9M032_RESTART, 0); /* Restart off */
> > +	if (ret<  0)
> > +		goto error_entity;
> > +	msleep(100);
> > +	ret = update_formatter2(sensor, false);
> > +	if (ret<  0)
> > +		goto error_entity;
> > +
> > +	return ret;
> > +
> > +error_entity:
> > +	media_entity_cleanup(&sensor->subdev.entity);
> > +error_ctrl:
> > +	v4l2_ctrl_handler_free(&sensor->ctrls);
> > +error_sensor:
> > +	mutex_destroy(&sensor->lock);
> > +	kfree(sensor);
> > +	return ret;
> > +}

-- 
Regards,

Laurent Pinchart

