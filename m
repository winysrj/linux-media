Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58348 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1IZIXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 04:23:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: martin@neutronstar.dyndns.org
Subject: Re: [PATCH v2] v4l: Add driver for Micron MT9M032 camera sensor
Date: Mon, 26 Sep 2011 10:23:12 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1316251771-858-1-git-send-email-martin@neutronstar.dyndns.org> <201109190048.25335.laurent.pinchart@ideasonboard.com> <20110920204223.GF9244@neutronstar.dyndns.org>
In-Reply-To: <20110920204223.GF9244@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261023.13509.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Tuesday 20 September 2011 22:42:23 martin@neutronstar.dyndns.org wrote:
> On Mon, Sep 19, 2011 at 12:48:24AM +0200, Laurent Pinchart wrote:
> > On Saturday 17 September 2011 11:29:31 Martin Hostettler wrote:

[snip]

> > > +{
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > > +	s32 data = i2c_smbus_read_word_data(client, reg);
> > > +
> > > +	return data < 0 ? data : swab16(data);
> > 
> > You should use be16_to_cpu() here.
> 
> No, i2c_smbus_read_word_data already has cpu to smbus endianness conversion
> built in. The hardware just does want it the other way around.
> 
> At least that what i understand of drivers/i2c/i2c-core.c
> i2c_smbus_xfer_emulated
> 
>    1959         case I2C_SMBUS_WORD_DATA:
>    1960                 if (read_write == I2C_SMBUS_READ)
>    1961                         msg[1].len = 2;
>    1962                 else {
>    1963                         msg[0].len = 3;
>    1964                         msgbuf0[1] = data->word & 0xff;
>    1965                         msgbuf0[2] = data->word >> 8;
>    1966                 }
>    1967                 break;
> 
>    2063                 case I2C_SMBUS_WORD_DATA:
>    2064                 case I2C_SMBUS_PROC_CALL:
>    2065                         data->word = msgbuf1[0] | (msgbuf1[1] <<
> 8); 2066                         break;
> 
> So it does it's own internal endianess handling.

My bad. Someone I won't name made me switch from swab16() to be16_to_cpu() in 
a couple of other drivers, I think he will recognize himself :-) I'm at fault 
for blindly doing it though.

[snip]

> > > +static int mt9m032_update_timing(struct mt9m032 *sensor,
> > > +				 struct v4l2_fract *interval,
> > > +				 const struct v4l2_rect *crop)
> > > +{
> > > +	unsigned long row_time;
> > > +	int additional_blanking_rows;
> > > +	int min_blank;
> > 
> > Those can't be negative, what about using unsigned it ?
> 
> additional_blanking_rows can get negative during the calculation and then
> get clampted to min_blank. And having them both the signed keeps the
> cpu/compiler happy.

OK.

> > > +
> > > +	if (!interval)
> > > +		interval = &sensor->frame_interval;
> > 
> > This will have the side effect of possibly modifying the frame interval
> > stored in the mt9m032 structure. Is that on purpose ?
> 
> Yes, it adjusts the frame interval to a supported value for the given
> geometry.
> 
> > > +	if (!crop)
> > > +		crop = &sensor->crop;
> > 
> > If I'm not mistaken the function is always called with the crop parameter
> > set to either NULL or &sensor->crop. I think the parameter could be
> > removed.
> 
> No it's called with a temporary from mt9m032_set_crop via
> mt9m032_update_geom_timing.

Right, my bad.

What bothers me is that mt9m032_update_geom_timing() and 
mt9m032_update_timing() are used both to validate/modify the crop rectangle 
and the frame interval, and to apply the settings to the hardware. I think it 
would be cleaner if that was split in two parts.

> That codepath would overwrite the changes instantly after
> mt9m032_update_timing returns.
> 
> Now trying to handle any errors in that path might not be a useful thing to
> do. I guess the results when mt9m032_write_reg fails will ultimatly be
> near random anyway...

[snip]

> > > +		additional_blanking_rows = div_u64(((u64)1000000000) *
> > > interval->numerator,
> > > +	                              ((u64)interval->denominator) *
> > > row_time) +	                           - crop->height;
> > > +	}
> > > +	/* enforce minimal 1.6ms blanking time. */
> > > +	min_blank = 1600000 / row_time;
> > > +	additional_blanking_rows = clamp(additional_blanking_rows,
> > > +	                                 min_blank,
> > > MT9M032_MAX_BLANKING_ROWS); +
> > > +	return mt9m032_write_reg(sensor, MT9M032_VBLANK,
> > > additional_blanking_rows); +}
> > > +
> > > +static int mt9m032_update_geom_timing(struct mt9m032 *sensor,
> > > +				 const struct v4l2_rect *crop)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = mt9m032_write_reg(sensor, MT9M032_COLUMN_SIZE, crop->width -
> > > 1); +	if (!ret)
> > > +		ret = mt9m032_write_reg(sensor, MT9M032_ROW_SIZE, crop->height - 
1);
> > > +	/* offsets compensate for black border */
> > > +	if (!ret)
> > > +		ret = mt9m032_write_reg(sensor, MT9M032_COLUMN_START, crop->left 
+
> > > 16); +	if (!ret)
> > > +		ret = mt9m032_write_reg(sensor, MT9M032_ROW_START, crop->top + 
52);
> > 
> > I don't think the black rows/columns offsets should be added implicitly
> > by the driver. Wouldn't it be beter to make them explicit ?
> 
> Why? I consider them an implementation detail userspace shouldn't need to
> worry about...

Because userspace could be interesting in getting the black rows for instance.

> > > +	if (!ret)
> > > +		ret = mt9m032_update_timing(sensor, NULL, crop);
> > > +	return ret;
> > > +}
> > > +
> > > +static int update_formatter2(struct mt9m032 *sensor, bool streaming)
> > > +{
> > > +	u16 reg_val =   MT9M032_FORMATTER2_DOUT_EN
> > > +		      | 0x0070;  /* parts reserved! */
> > > +				 /* possibly for changing to 14-bit mode */
> > 
> > Does the sensor support 14-bit output ?
> 
> Something with PLL, *muble* *muble*
> 
> Basicly here i tried to resuce possible information from a comment on a
> sample bring-up code. Maybe it's just noise in the data sheet. Or maybe
> someone will someday understand it. Hard to say with those sample
> sequences full of access to undocumented bits with comments that don't
> really help.

OK.

> > > +
> > > +	if (streaming)
> > > +		reg_val |= MT9M032_FORMATTER2_PIXCLK_EN;   /* pixclock enable */
> > > +
> > > +	return mt9m032_write_reg(sensor, MT9M032_FORMATTER2, reg_val);
> > > +}

[snip]

> > > +static int mt9m032_enum_frame_size(struct v4l2_subdev *subdev,
> > > +				   struct v4l2_subdev_fh *fh,
> > > +				   struct v4l2_subdev_frame_size_enum *fse)
> > > +{
> > > +	if (fse->index != 0 || fse->code != V4L2_MBUS_FMT_Y8_1X8 || fse->pad
> > > != 0) +		return -EINVAL;
> > > +
> > > +	fse->min_width = 32;
> > > +	fse->max_width = 1440;
> > 
> > Shouldn't that be 1472 ?
> 
> This driver consistently hides black pixels from userspace. And the active
> image is 1440x1080 according to the datasheet.

In that case fse->max_height should be set to 1080.

> > > +	fse->min_height = 32;
> > > +	fse->max_height = 1096;
> > 
> > You don't support binning/skipping, so I think min width/height should be
> > equal to max width/height.
> 
> But it supports cropping, so the size of the data processed is variable,
> isn't it?

My understanding of the enum_frame_size subdev operation is that it shouldn't 
take cropping into account. I agree that the documentation isn't clear on that 
topic.

> > > +
> > > +	return 0;
> > > +}

[snip]

> > > +static int mt9m032_set_crop(struct v4l2_subdev *subdev, struct
> > > v4l2_subdev_fh *fh, +		     struct v4l2_subdev_crop *crop)
> > > +{
> > > +	struct mt9m032 *sensor = to_mt9m032(subdev);
> > > +	struct v4l2_mbus_framefmt tmp_format;
> > > +	struct v4l2_rect tmp_crop_rect;
> > > +	struct v4l2_mbus_framefmt *format;
> > > +	struct v4l2_rect *crop_rect;
> > > +
> > > +	if (sensor->streaming)
> > > +		return -EBUSY;
> > > +
> > > +	if (crop->pad != 0)
> > > +		return -EINVAL;
> > > +
> > > +	format = __mt9m032_get_pad_format(sensor, fh, crop->which);
> > > +	crop_rect = __mt9m032_get_pad_crop(sensor, fh, crop->which);
> > > +	if (!format || !crop_rect)
> > > +		return -EINVAL;
> > > +	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> > > +		tmp_crop_rect = *crop_rect;
> > > +		tmp_format = *format;
> > > +		format = &tmp_format;
> > > +		crop_rect = &tmp_crop_rect;
> > > +	}
> > > +
> > > +	crop_rect->top = crop->rect.top & ~0x1;
> > > +	crop_rect->left = crop->rect.left;
> > > +	crop_rect->height = crop->rect.height;
> > > +	crop_rect->width = crop->rect.width & ~1;
> > 
> > You should validate the crop rectangle here.
> 
> Yes, that can't harm, can it?
> 
> > > +	format->height = crop_rect->height;
> > > +	format->width = crop_rect->width;
> > > +
> > > +	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> > > +		int ret = mt9m032_update_geom_timing(sensor, crop_rect);
> > 
> > As the format can't be changed during streaming, what about moving this
> > to the s_stream handler ? You could then also remove the call from the
> > probe() function.
> 
> I'd rather not. The driver should change the minimal registers needed for
> each operation,

Both solutions are valid, I'm not going to push one over the other. The 
advantage of delaying all register writes until s_stream(1) time is that the 
sensor doesn't need to be powered until streaming is started. This might be 
revisited when someone will need power management in the driver.

> to keep the option to do things with the generic register set ioctls. (Not
> my idea, but worth to argue over)

Just out of curiosity, how do you see that being used ?

> > > +
> > > +		if (!ret) {
> > > +			sensor->crop = tmp_crop_rect;
> > > +			sensor->format = tmp_format;
> > > +		}
> > > +		return ret;
> > > +	}
> > > +
> > > +	return mt9m032_get_crop(subdev, fh, crop);
> > 
> > I don't think you need that.
> 
> I generally like the idea of having the setters return exactly what the
> getters return explicitly. Just a case of programmer doesn't trust
> himself.

If you can't be trusted here, can you be trusted for the rest of the driver 
:-) I prefer fixing bugs than hiding them.

> > > +}

[snip]

> > > +#ifdef CONFIG_VIDEO_ADV_DEBUG
> > > +static int mt9m032_g_register(struct v4l2_subdev *sd,
> > > +			      struct v4l2_dbg_register *reg)
> > > +{
> > > +	struct mt9m032 *sensor = to_mt9m032(sd);
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > > +	int val;
> > > +
> > > +	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
> > > +		return -EINVAL;
> > > +	if (reg->match.addr != client->addr)
> > > +		return -ENODEV;
> > 
> > Do you think those checks should be kept when using the MC API ?
> 
> I think they are useful enough to prevent accidentially poking the wrong
> hardware. Also it's always good to force userspace to initialize
> everything.

OK.

> > > +	val = mt9m032_read_reg(sensor, reg->reg);
> > > +	if (val < 0)
> > > +		return -EIO;
> > > +
> > > +	reg->size = 2;
> > > +	reg->val = (u64) val;
> > 
> > Is there a need for an explicit cast ?
> 
> prevents sign extension, iirc. val ist signed because mt9m032_read_reg
> multiplexes error codes in negative values.

But val is positive, as you return -EIO if it's negative.

> > > +
> > > +	return 0;
> > > +}

[snip]

> > > +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> > > +{
> > > +	struct mt9m032_platform_data* pdata = sensor->pdata;
> > > +	u16 reg_pll1;
> > > +	unsigned int pre_div;
> > > +	int res, ret;
> > > +
> > > +	/* TODO: also support other pre-div values */
> > > +	if (pdata->pll_pre_div != 6) {
> > > +		dev_warn(to_dev(sensor),
> > > +			"Unsupported PLL pre-divisor value %u, using default 6\n",
> > > +			pdata->pll_pre_div);
> > > +	}
> > > +	pre_div = 6;
> > 
> > The mt9p031 driver also needs to setup a PLL. I think it's time to
> > compute the PLL parameters at runtime instead of relying on board code.
> 
> Problem here is that i can't really understand the general case PLL setup
> from the datasheet. So it's hard to really do it fully dynamic.

Sakari, you've worked on PLL setup code, is there any advice you can give for 
this ?

-- 
Regards,

Laurent Pinchart
