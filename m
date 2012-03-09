Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43234 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909Ab2CIUU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 15:20:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v4 5/5] v4l: Add driver for Micron MT9M032 camera sensor
Date: Fri, 09 Mar 2012 21:20:47 +0100
Message-ID: <24208361.kjqmef2Tq0@avalon>
In-Reply-To: <4F5A56D0.50803@iki.fi>
References: <1331305285-10781-1-git-send-email-laurent.pinchart@ideasonboard.com> <1331305285-10781-6-git-send-email-laurent.pinchart@ideasonboard.com> <4F5A56D0.50803@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 09 March 2012 21:15:28 Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the patch. Just a few minor comments below.

Thanks for the review.

> Laurent Pinchart wrote:
> ...
> 
> > +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> > +{
> > +	static const struct aptina_pll_limits limits = {
> > +		.ext_clock_min = 8000000,
> > +		.ext_clock_max = 16500000,
> > +		.int_clock_min = 2000000,
> > +		.int_clock_max = 24000000,
> > +		.out_clock_min = 322000000,
> > +		.out_clock_max = 693000000,
> > +		.pix_clock_max = 99000000,
> > +		.n_min = 1,
> > +		.n_max = 64,
> > +		.m_min = 16,
> > +		.m_max = 255,
> > +		.p1_min = 1,
> > +		.p1_max = 128,
> > +	};
> > +
> > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > +	struct mt9m032_platform_data *pdata = sensor->pdata;
> > +	struct aptina_pll pll;
> > +	int ret;
> > +
> > +	pll.ext_clock = pdata->ext_clock;
> > +	pll.pix_clock = pdata->pix_clock;
> > +
> > +	ret = aptina_pll_calculate(&client->dev, &limits, &pll);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	sensor->pix_clock = pll.pix_clock;
> 
> I wouldn't expect aptina_pll_calculate() to change the supplied pixel
> clock. I'd consider it a bug if it does that. So you could use the pixel
> clock from platform data equally well.

But does it make a difference ? :-) Taking the value from pll.pix_clock seems 
more logical to me.

> > +	ret = mt9m032_write(client, MT9M032_PLL_CONFIG1,
> > +			    (pll.m << MT9M032_PLL_CONFIG1_MUL_SHIFT)
> > +			    | (pll.p1 - 1));
> > +	if (!ret)
> > +		ret = mt9m032_write(client, MT9P031_PLL_CONFIG2, pll.n - 1);
> > +	if (!ret)
> > +		ret = mt9m032_write(client, MT9P031_PLL_CONTROL,
> > +				    MT9P031_PLL_CONTROL_PWRON |
> > +				    MT9P031_PLL_CONTROL_USEPLL);
> > +	if (!ret)		/* more reserved, Continuous, Master Mode */
> > +		ret = mt9m032_write(client, MT9M032_READ_MODE1, 0x8006);
> > +	if (!ret)		/* Set 14-bit mode, select 7 divider */
> > +		ret = mt9m032_write(client, MT9M032_FORMATTER1, 0x111e);
> > +
> > +	return ret;
> > +}
> 
> ...
> 
> > +static int mt9m032_set_pad_format(struct v4l2_subdev *subdev,
> > +				  struct v4l2_subdev_fh *fh,
> > +				  struct v4l2_subdev_format *fmt)
> > +{
> > +	struct mt9m032 *sensor = to_mt9m032(subdev);
> > +	int ret;
> > +
> > +	mutex_lock(&sensor->lock);
> > +
> > +	if (sensor->streaming && fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> > +		ret = -EBUSY;
> > +		goto done;
> > +	}
> > +
> > +	/* Scaling is not supported, the format is thus fixed. */
> > +	ret = mt9m032_get_pad_format(subdev, fh, fmt);
> > +
> > +done:
> > +	mutex_lock(&sensor->lock);
> > +	return ret;
> > +}
> > +
> > +static int mt9m032_get_crop(struct v4l2_subdev *subdev,
> > +			    struct v4l2_subdev_fh *fh,
> > +			    struct v4l2_subdev_crop *crop)
> > +{
> > +	struct mt9m032 *sensor = to_mt9m032(subdev);
> > +
> > +	mutex_lock(&sensor->lock);
> > +	crop->rect = *__mt9m032_get_pad_crop(sensor, fh, crop->which);
> > +	mutex_unlock(&sensor->lock);
> > +
> > +	return 0;
> > +}
> 
> Shouldn't these two be renamed --- you've got "pad" in set/get fmt names
> as well.

Done.

> > +static int mt9m032_set_crop(struct v4l2_subdev *subdev,
> > +			    struct v4l2_subdev_fh *fh,
> > +			    struct v4l2_subdev_crop *crop)
> > +{
> > +	struct mt9m032 *sensor = to_mt9m032(subdev);
> > +	struct v4l2_mbus_framefmt *format;
> > +	struct v4l2_rect *__crop;
> > +	struct v4l2_rect rect;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&sensor->lock);
> > +
> > +	if (sensor->streaming && crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> > +		ret = -EBUSY;
> > +		goto done;
> > +	}
> > +
> > +	/* Clamp the crop rectangle boundaries and align them to a multiple 
of 2
> > +	 * pixels to ensure a GRBG Bayer pattern.
> > +	 */
> > +	rect.left = clamp(ALIGN(crop->rect.left, 2), 
MT9M032_COLUMN_START_MIN,
> > +			  MT9M032_COLUMN_START_MAX);
> > +	rect.top = clamp(ALIGN(crop->rect.top, 2), MT9M032_ROW_START_MIN,
> > +			 MT9M032_ROW_START_MAX);
> > +	rect.width = clamp(ALIGN(crop->rect.width, 2), 
MT9M032_COLUMN_SIZE_MIN,
> > +			   MT9M032_COLUMN_SIZE_MAX);
> > +	rect.height = clamp(ALIGN(crop->rect.height, 2), 
MT9M032_ROW_SIZE_MIN,
> > +			    MT9M032_ROW_SIZE_MAX);
> > +
> > +	rect.width = min(rect.width, MT9M032_PIXEL_ARRAY_WIDTH - rect.left);
> > +	rect.height = min(rect.height, MT9M032_PIXEL_ARRAY_HEIGHT - 
rect.top);
> > +
> > +	__crop = __mt9m032_get_pad_crop(sensor, fh, crop->which);
> > +
> > +	if (rect.width != __crop->width || rect.height != __crop->height) {
> > +		/* Reset the output image size if the crop rectangle size has
> > +		 * been modified.
> > +		 */
> > +		format = __mt9m032_get_pad_format(sensor, fh, crop->which);
> > +		format->width = rect.width;
> > +		format->height = rect.height;
> > +	}
> > +
> > +	*__crop = rect;
> > +	crop->rect = rect;
> > +
> > +	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> > +		ret = mt9m032_update_geom_timing(sensor);
> > +
> > +done:
> > +	mutex_unlock(&sensor->lock);
> > +	return ret;
> > +}
> 
> ...
> 
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
> > +	if (sensor == NULL)
> > +		return -ENOMEM;
> > +
> > +	mutex_init(&sensor->lock);
> > +
> > +	sensor->pdata = client->dev.platform_data;
> > +
> > +	v4l2_i2c_subdev_init(&sensor->subdev, client, &mt9m032_ops);
> > +	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +
> > +	chip_version = mt9m032_read(client, MT9M032_CHIP_VERSION);
> > +	if (chip_version != MT9M032_CHIP_VERSION_VALUE) {
> > +		dev_err(&client->dev, "MT9M032 not detected, wrong version "
> > +			"0x%04x\n", chip_version);
> > +		ret = -ENODEV;
> > +		goto free_sensor;
> > +	}
> > +
> > +	dev_info(&client->dev, "MT9M032 detected at address 0x%02x\n",
> > +		 client->addr);
> > +
> > +	sensor->frame_interval.numerator = 1;
> > +	sensor->frame_interval.denominator = 30;
> > +
> > +	sensor->crop.left = 416;
> > +	sensor->crop.top = 360;
> > +	sensor->crop.width = 640;
> > +	sensor->crop.height = 480;
> 
> How was the situation with this? Shouldn't the default be no cropping?

Oops. I need to sleep as well.

Fixed.

> > +	sensor->format.width = sensor->crop.width;
> > +	sensor->format.height = sensor->crop.height;
> > +	sensor->format.code = V4L2_MBUS_FMT_Y8_1X8;
> > +	sensor->format.field = V4L2_FIELD_NONE;
> > +	sensor->format.colorspace = V4L2_COLORSPACE_SRGB;
> > +
> > +	v4l2_ctrl_handler_init(&sensor->ctrls, 4);
> > +
> > +	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> > +			  V4L2_CID_GAIN, 0, 127, 1, 64);
> > +
> > +	sensor->hflip = v4l2_ctrl_new_std(&sensor->ctrls,
> > +					  &mt9m032_ctrl_ops,
> > +					  V4L2_CID_HFLIP, 0, 1, 1, 0);
> > +	sensor->vflip = v4l2_ctrl_new_std(&sensor->ctrls,
> > +					  &mt9m032_ctrl_ops,
> > +					  V4L2_CID_VFLIP, 0, 1, 1, 0);
> > +
> > +	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> > +			  V4L2_CID_EXPOSURE, MT9M032_SHUTTER_WIDTH_MIN,
> > +			  MT9M032_SHUTTER_WIDTH_MAX, 1,
> > +			  MT9M032_SHUTTER_WIDTH_DEF);
> > +
> > +	if (sensor->ctrls.error) {
> > +		ret = sensor->ctrls.error;
> > +		dev_err(&client->dev, "control initialization error %d\n", ret);
> > +		goto free_ctrl;
> > +	}
> > +
> > +	v4l2_ctrl_cluster(2, &sensor->hflip);
> > +
> > +	sensor->subdev.ctrl_handler = &sensor->ctrls;
> > +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +	ret = media_entity_init(&sensor->subdev.entity, 1, &sensor->pad, 0);
> > +	if (ret < 0)
> > +		goto free_ctrl;
> > +
> > +	ret = mt9m032_write(client, MT9M032_RESET, 1);	/* reset on */
> > +	if (ret < 0)
> > +		goto free_ctrl;
> 
> I think you should do media_entity_cleanup() if this or anything past
> this fails.

Good point. Fixed.

> > +	mt9m032_write(client, MT9M032_RESET, 0);	/* reset off */
> > +	if (ret < 0)
> > +		goto free_ctrl;
> > +
> > +	ret = mt9m032_setup_pll(sensor);
> > +	if (ret < 0)
> > +		goto free_ctrl;
> > +	usleep_range(10000, 11000);
> > +
> > +	v4l2_ctrl_handler_setup(&sensor->ctrls);
> > +
> > +	/* SIZE */
> > +	ret = mt9m032_update_geom_timing(sensor);
> > +	if (ret < 0)
> > +		goto free_ctrl;
> > +
> > +	ret = mt9m032_write(client, 0x41, 0x0000);	/* reserved !!! */
> > +	if (ret < 0)
> > +		goto free_ctrl;
> > +	ret = mt9m032_write(client, 0x42, 0x0003);	/* reserved !!! */
> > +	if (ret < 0)
> > +		goto free_ctrl;
> > +	ret = mt9m032_write(client, 0x43, 0x0003);	/* reserved !!! */
> > +	if (ret < 0)
> > +		goto free_ctrl;
> > +	ret = mt9m032_write(client, 0x7f, 0x0000);	/* reserved !!! */
> > +	if (ret < 0)
> > +		goto free_ctrl;
> > +	if (sensor->pdata->invert_pixclock) {
> > +		ret = mt9m032_write(client, MT9M032_PIX_CLK_CTRL,
> > +				    MT9M032_PIX_CLK_CTRL_INV_PIXCLK);
> > +		if (ret < 0)
> > +			goto free_ctrl;
> > +	}
> > +
> > +	ret = mt9m032_write(client, MT9M032_RESTART, 1); /* Restart on */
> > +	if (ret < 0)
> > +		goto free_ctrl;
> > +	msleep(100);
> > +	ret = mt9m032_write(client, MT9M032_RESTART, 0); /* Restart off */
> > +	if (ret < 0)
> > +		goto free_ctrl;
> > +	msleep(100);
> > +	ret = update_formatter2(sensor, false);
> > +	if (ret < 0)
> > +		goto free_ctrl;
> > +
> > +	return ret;
> > +
> > +free_ctrl:
> > +	v4l2_ctrl_handler_free(&sensor->ctrls);
> > +
> > +free_sensor:
> > +	mutex_destroy(&sensor->lock);
> > +	kfree(sensor);
> > +	return ret;
> > +}
> > +
> > +static int mt9m032_remove(struct i2c_client *client)
> > +{
> > +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> > +	struct mt9m032 *sensor = to_mt9m032(subdev);
> > +
> > +	v4l2_device_unregister_subdev(&sensor->subdev);
> > +	v4l2_ctrl_handler_free(&sensor->ctrls);
> > +	media_entity_cleanup(&sensor->subdev.entity);
> > +	mutex_destroy(&sensor->lock);
> > +	kfree(sensor);
> > +	return 0;
> > +}

-- 
Regards,

Laurent Pinchart

