Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44728 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2CGLbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 06:31:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v3 5/5] v4l: Add driver for Micron MT9M032 camera sensor
Date: Wed, 07 Mar 2012 12:31:34 +0100
Message-ID: <2041187.ucBOt7zOjI@avalon>
In-Reply-To: <20120306231633.GO1075@valkosipuli.localdomain>
References: <1331051559-13841-1-git-send-email-laurent.pinchart@ideasonboard.com> <1331051559-13841-6-git-send-email-laurent.pinchart@ideasonboard.com> <20120306231633.GO1075@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 07 March 2012 01:16:33 Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the patch.
> 
> I have a few comments below. Just one fairly general question: locking.
> Shouldn't you serialise accesses to sensor registers and your data,
> possibly by using a mutex?

I guess I should, yes... :-) will fix.

> Laurent Pinchart wrote:
> > From: Martin Hostettler <martin@neutronstar.dyndns.org>
> > 
> > The MT9M032 is a parallel 1.6MP sensor from Micron controlled through I2C.
> > 
> > The driver creates a V4L2 subdevice. It currently supports cropping, gain,
> > exposure and v/h flipping controls in monochrome mode with an
> > external pixel clock.
> > 
> > Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> > [Lots of clean up, fixes and enhancements]
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[snip]

> > diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> > index d1304e1..8e037e9 100644
> > --- a/drivers/media/video/Makefile
> > +++ b/drivers/media/video/Makefile
> > @@ -82,6 +82,7 @@ obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
> > 
> >  obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
> >  obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
> > 
> > +obj-$(CONFIG_VIDEO_MT9M032)             += mt9m032.o
> 
> I would put this among the other subdev sensor drivers instead.

Good point.

> >  obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
> >  obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
> >  obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
> > 
> > diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
> > new file mode 100644
> > index 0000000..c3d69aa
> > --- /dev/null
> > +++ b/drivers/media/video/mt9m032.c

[snip]

> > +static u32 mt9m032_row_time(struct mt9m032 *sensor, unsigned int width)
> > +{
> > +	unsigned int effective_width;
> > +	u32 ns;
> > +
> > +	effective_width = width + 716; /* emperical value */
> 
> Why empirical value? This should be directly related to image width
> (before binning) and horizontal blanking.

Ask Martin :-)

I don't have access to the documentation nor the hardware, so I'd rather keep 
the value as-is for now.

> > +	ns = div_u64(1000000000ULL * effective_width, sensor->pix_clock);
> > +	dev_dbg(to_dev(sensor),	"MT9M032 line time: %u ns\n", ns);
> > +	return ns;
> > +}

[snip]

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
> 
> You could initialise these in the declaration.

Yes, but I would find that less readable :-)

> > +	ret = aptina_pll_calculate(&client->dev, &limits, &pll);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	sensor->pix_clock = pll.pix_clock;
> > +
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
> 
> I hope the datasheet is public. :-)
> 
> If there is one in a known URL it wouldn't hurt to refer to it, I think.

It's not public, and I don't have access to it (yet at least). I would have 
modified this otherwise.

> > +	return ret;
> > +}

[snip]

> > +/**
> > + * __mt9m032_get_pad_crop() - get crop rect
> > + * @sensor: pointer to the sensor struct
> > + * @fh: filehandle for getting the try crop rect from
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
> > +		return &sensor->crop;
> > +	default:
> > +		return NULL;
> 
> BUG()? Just a thought.

BUG() will result in a panic(), while NULL here will "just" trigger an oops 
(so the bug will be caught) and won't render the system unusable.

> > +	}
> > +}
> > +
> > +/**
> > + * __mt9m032_get_pad_format() - get format
> > + * @sensor: pointer to the sensor struct
> > + * @fh: filehandle for getting the try format from
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
> > +		return &sensor->format;
> > +	default:
> > +		return NULL;
> 
> Here as well?
> 
> > +	}
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
> > +	if (sensor->streaming && crop->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> > +		return -EBUSY;
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
> 
> I think you can do this unconditionally.

I could, but I hope to add binning/skipping support to this driver soon. The 
check will be needed then.
 
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

> > +static int mt9m032_set_frame_interval(struct v4l2_subdev *subdev,
> > +				      struct v4l2_subdev_frame_interval *fi)
> > +{
> > +	struct mt9m032 *sensor = to_mt9m032(subdev);
> > +	int ret;
> > +
> > +	if (sensor->streaming)
> > +		return -EBUSY;
> > +
> > +	memset(fi->reserved, 0, sizeof(fi->reserved));
> 
> I'm not quite sure these should be touched.

Why not ? Do you think this could cause a regression in the future when the 
fields won't be reserved anymore ?

> > +	ret = mt9m032_update_timing(sensor, &fi->interval);
> > +	if (!ret)
> > +		sensor->frame_interval = fi->interval;
> > +
> > +	return ret;
> > +}


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
> 
> The gain control only touches analogue gain. Shouldn't you use
> V4L2_CID_ANALOGUE_GAIN (or something alike) instead?

If there was such a control in mainline, sure ;-)

I plan to revisit controls in the various Aptina sensor drivers I maintain in 
the near future. Analog/digital gains will be on my to-do list.

> > +	case V4L2_CID_HFLIP:
> > +	case V4L2_CID_VFLIP:
> > +		return update_read_mode2(sensor, sensor->vflip->val,
> > +					 sensor->hflip->val);
> > +
> > +	case V4L2_CID_EXPOSURE:
> > +		ret = mt9m032_write(client, MT9M032_SHUTTER_WIDTH_HIGH,
> > +				    (ctrl->val >> 16) & 0xffff);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		return mt9m032_write(client, MT9M032_SHUTTER_WIDTH_LOW,
> > +				     ctrl->val & 0xffff);
> > +
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}

-- 
Regards,

Laurent Pinchart

