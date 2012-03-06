Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38874 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2CFQHl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 11:07:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 5/5] v4l: Add driver for Micron MT9M032 camera sensor
Date: Tue, 06 Mar 2012 17:08:01 +0100
Message-ID: <3590523.ZOyvX5TbID@avalon>
In-Reply-To: <20120306150403.GG1075@valkosipuli.localdomain>
References: <1331035786-8938-1-git-send-email-laurent.pinchart@ideasonboard.com> <1331035786-8938-6-git-send-email-laurent.pinchart@ideasonboard.com> <20120306150403.GG1075@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On Tuesday 06 March 2012 17:04:04 Sakari Ailus wrote:
> On Tue, Mar 06, 2012 at 01:09:46PM +0100, Laurent Pinchart wrote:
> > From: Martin Hostettler <martin@neutronstar.dyndns.org>
> > 
> > The MT9M032 is a parallel 1.6MP sensor from Micron controlled through I2C.
> > 
> > The driver creates a V4L2 subdevice. It currently supports cropping, gain,
> > exposure and v/h flipping controls in monochrome mode with an
> > external pixel clock.
> > 
> > Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>

[snip]

> > diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
> > new file mode 100644
> > index 0000000..8c69099
> > --- /dev/null
> > +++ b/drivers/media/video/mt9m032.c

[snip]

> > +struct mt9m032 {
> > +	struct v4l2_subdev subdev;
> > +	struct media_pad pad;
> > +	struct mt9m032_platform_data *pdata;
> > +
> > +	struct v4l2_ctrl_handler ctrls;
> > +	struct {
> > +		struct v4l2_ctrl *hflip;
> > +		struct v4l2_ctrl *vflip;
> > +	};
> > +
> > +	bool streaming;
> > +
> > +	int pix_clock;
> 
> unsigned?

No comment ;-) I'll fix this.

> > +	struct v4l2_mbus_framefmt format;
> > +	struct v4l2_rect crop;
> > +	struct v4l2_fract frame_interval;
> > +};

[snip]

> > +static unsigned long mt9m032_row_time(struct mt9m032 *sensor, int width)
> > +{
> > +	int effective_width;
> 
> unsigned, this & width?

...

> > +	u64 ns;
> > +
> > +	effective_width = width + 716; /* emperical value */
> > +	ns = div_u64(((u64)1000000000) * effective_width, sensor->pix_clock);
> > +	dev_dbg(to_dev(sensor),	"MT9M032 line time: %llu ns\n", ns);
> 
> The sensor is using rows internally for exposure as is SMIA++ sensor. Should
> we use a different control or the same?
> 
> Some sensors also provide additional fine exposure control, which is in
> pixels. It doesn't make sense to change the fine exposure time except in
> very special situations, i.e. normally it's 0.

I would prefer keeping the same control for now. We have enough new features 
to introduce already :-)

> > +	return ns;
> > +}
> > +
> > +static int mt9m032_update_timing(struct mt9m032 *sensor,
> > +				 struct v4l2_fract *interval)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > +	struct v4l2_rect *crop = &sensor->crop;
> > +	unsigned long row_time;
> > +	unsigned int min_vblank;
> > +	unsigned int vblank;
> > +
> > +	if (!interval)
> > +		interval = &sensor->frame_interval;
> > +
> > +	row_time = mt9m032_row_time(sensor, crop->width);
> > +
> > +	vblank = div_u64(1000000000ULL * interval->numerator,
> > +			 ((u64)interval->denominator) * row_time)
> > +	       - crop->height;
> > +
> > +	if (vblank > MT9M032_MAX_BLANKING_ROWS) {
> > +		/* hardware limits to 11 bit values */
> > +		interval->denominator = 1000;
> > +		interval->numerator =
> > +			div_u64((crop->height + MT9M032_MAX_BLANKING_ROWS) *
> > +				(u64)row_time * interval->denominator,
> > +				1000000000ULL);
> > +		vblank = div_u64(1000000000ULL * interval->numerator,
> > +				 ((u64)interval->denominator) * row_time)
> > +		       - crop->height;
> > +	}
> > +	/* enforce minimal 1.6ms blanking time. */
> > +	min_vblank = 1600000 / row_time;
> > +	vblank = clamp_t(unsigned int, vblank, min_vblank,
> > +			 MT9M032_MAX_BLANKING_ROWS);
> > +
> > +	return mt9m032_write(client, MT9M032_VBLANK, vblank);
> > +}
> 
> You'd get rid of these calculations with the new sensor control interface.
> 
> I'm fine with you starting to support that later on but that would change
> the user space API for this driver. Is that an issue?

I don't see that as an issue.

> We still need the generic library so the applications still can use these
> drivers as in the past.

[snip]

> > +static int mt9m032_set_pad_format(struct v4l2_subdev *subdev,
> > +				  struct v4l2_subdev_fh *fh,
> > +				  struct v4l2_subdev_format *fmt)
> > +{
> > +	struct mt9m032 *sensor = to_mt9m032(subdev);
> > +
> > +	if (sensor->streaming)
> > +		return -EBUSY;
> 
> Setting try formats should succeed while streaming, shouldn't it?

Yes. I'll fix that.

> > +	/* Scaling is not supported, the format is thus fixed. */
> > +	return mt9m032_get_pad_format(subdev, fh, fmt);
> > +}

[snip]

> > +static int mt9m032_set_crop(struct v4l2_subdev *subdev,
> > +			    struct v4l2_subdev_fh *fh,
> > +			    struct v4l2_subdev_crop *crop)
> > +{
> > +	struct mt9m032 *sensor = to_mt9m032(subdev);
> > +	struct v4l2_mbus_framefmt *format;
> > +	struct v4l2_rect *__crop;
> > +	struct v4l2_rect rect;
> > +
> > +	if (sensor->streaming)
> > +		return -EBUSY;
> 
> Same for crop.

Will fix too.

> Selection API support would be nice here.

Sure, once that gets in mainline :-)

> > +	rect.top = clamp(crop->rect.top, 0,
> > +			 MT9M032_HEIGHT - MT9M032_MINIMALSIZE) & ~1;
> > +	rect.left = clamp(crop->rect.left, 0,
> > +			  MT9M032_WIDTH - MT9M032_MINIMALSIZE);
> > +	rect.height = clamp(crop->rect.height, MT9M032_MINIMALSIZE,
> > +			    MT9M032_HEIGHT - rect.top);
> > +	rect.width = clamp(crop->rect.width, MT9M032_MINIMALSIZE,
> > +			   MT9M032_WIDTH - rect.left) & ~1;
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
> > +	if (crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> > +		return 0;
> > +
> > +	return mt9m032_update_geom_timing(sensor);
> > +}

[snip]

> > +static int mt9m032_set_exposure(struct mt9m032 *sensor, s32 val)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > +	int shutter_width;
> > +	u16 high_val, low_val;
> > +	int ret;
> 
> What's the unit of the exposure control? I'd use lines but I think this
> driver uses something else.

The driver seems to use microseconds. I'm thinking about switching that to 
lines. What's your opinion ?

> > +	/* shutter width is in row times */
> > +	shutter_width = (val * 1000)
> > +		      / mt9m032_row_time(sensor, sensor->crop.width);
> > +
> > +	high_val = (shutter_width >> 16) & 0xf;
> > +	low_val = shutter_width & 0xffff;
> > +
> > +	ret = mt9m032_write(client, MT9M032_SHUTTER_WIDTH_HIGH, high_val);
> > +	if (!ret)
> > +		ret = mt9m032_write(client, MT9M032_SHUTTER_WIDTH_LOW,
> > +					low_val);
> > +
> > +	return ret;
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
> > +	if (sensor == NULL)
> > +		return -ENOMEM;
> > +
> > +	sensor->pdata = client->dev.platform_data;
> > +
> > +	v4l2_i2c_subdev_init(&sensor->subdev, client, &mt9m032_ops);
> > +	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +
> > +	/*
> > +	 * This driver was developed with a camera module with seperate 
external
> > +	 * pix clock. For setups which use the clock from the camera 
interface
> > +	 * the code will need to be extended with the appropriate platform
> > +	 * callback to setup the clock.
> > +	 */
> 
> Does this comment have something to do with the code below?

I'll remove that.

> > +	chip_version = mt9m032_read(client, MT9M032_CHIP_VERSION);
> > +	if (chip_version != MT9M032_CHIP_VERSION_VALUE) {
> > +		dev_err(&client->dev, "MT9M032 not detected, wrong version "
> > +			"0x%04x\n", chip_version);
> > +		ret = -ENODEV;
> > +		goto free_sensor;
> > +	}
> > +
> > +	dev_info(&client->dev, "MT9P031 detected at address 0x%02x\n",
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
> Why such a default setup?

I have no idea :-) I'll change the default to the whole pixel array.

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
> > +	v4l2_ctrl_cluster(2, &sensor->hflip);
> > +
> > +	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
> > +			  V4L2_CID_EXPOSURE, 0, 8000, 1, 1700);    /* 1.7ms */
> > +
> > +	if (sensor->ctrls.error) {
> > +		ret = sensor->ctrls.error;
> > +		dev_err(&client->dev, "control initialization error %d\n", ret);
> > +		goto free_ctrl;
> > +	}
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
> > +	kfree(sensor);
> > +	return ret;
> > +}

[snip]

> > diff --git a/include/media/mt9m032.h b/include/media/mt9m032.h
> > new file mode 100644
> > index 0000000..804e0a5
> > --- /dev/null
> > +++ b/include/media/mt9m032.h

[snip]

> > +struct mt9m032_platform_data {
> > +	u32 ext_clock;
> > +	u32 pix_clock;
> > +	int invert_pixclock;
> 
> unsigned?

bool ?

> > +
> > +};
> > +#endif /* MT9M032_H */

-- 
Regards,

Laurent Pinchart

