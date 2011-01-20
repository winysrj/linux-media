Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:61684 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab1ATW4K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 17:56:10 -0500
Date: Thu, 20 Jan 2011 23:56:07 +0100
From: martin@neutronstar.dyndns.org
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] v4l: Add driver for Micron MT9M032 camera sensor
Message-ID: <20110120225607.GD13173@neutronstar.dyndns.org>
References: <1295389122-30325-1-git-send-email-martin@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295389122-30325-1-git-send-email-martin@neutronstar.dyndns.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

>> +
>> +#define MT9M032_CHIP_VERSION		0x00
>> +#define MT9M032_ROW_START		0x01
>> +#define MT9M032_COLUMN_START		0x02
>> +#define MT9M032_ROW_SIZE		0x03
>> +#define MT9M032_COLUMN_SIZE		0x04
>> +#define MT9M032_HBLANK			0x05
>> +#define MT9M032_VBLANK			0x06
>> +#define MT9M032_SHUTTER_WIDTH_HIGH	0x08
>> +#define MT9M032_SHUTTER_WIDTH_LOW	0x09
>> +#define MT9M032_PIX_CLK_CTRL		0x0A
>
> Kernel code usually uses lowercase hex constants.
ok.

>> +static unsigned long mt9m032_row_time(struct mt9m032 *sensor, int width)
>> +{
>> +	int effective_width;
>> +	u64 ns;
>> +	effective_width = width + 716; /* emperical value */
> 
> Where does it come from ?

Like the comment says, it's just what the hardware seems to do from
measureing framerates. Sadly i couldn't find anything exact anywhere...


>> +	ns = 1000000000ll * effective_width;
>> +	do_div(ns, sensor->pix_clock);
> 
> Do you have high enough clock frequencies that you would loose precision by 
> dividing 1e9 by the clock first, and the multiplying it by the row length ? If 
> so I would use div_u64().

Thanks for the hint to use div_u64, that's a bit nicer.
To be honest, this is in a slow path, it uses SI units and with div_64
reads reasonably well and is what i want to express. I don't see to do
something clever here just to save a few cycles and have it harder to
reason about...


[...]

>> +
>> +	row_time = mt9m032_row_time(sensor, crop->width);
>> +	do_div(ns, row_time);
>> +
>> +	additional_blanking_rows = ns - crop->height;
>> +
>> +	/* enforce minimal 1.6ms blanking time. */
>> +	min_blank = 1600000 / row_time;
>> +	if (additional_blanking_rows < min_blank)
>> +		additional_blanking_rows = min_blank;
> 
> You can use the min() macro.

I'm pretty sure it's the max() one, but yes.

>> +	dev_dbg(to_dev(sensor),
>> +		"%s: V-blank %i\n", __func__, additional_blanking_rows);
>> +	if (additional_blanking_rows > 0x7ff) {
>> +		/* hardware limits 11 bit values */
>> +		dev_warn(to_dev(sensor),
>> +			"mt9m032: frame rate too low.\n");
>> +		additional_blanking_rows = 0x7ff;
>> +	}
> 
> Or rather the clamp() macro.

I think the error reporting reads more natual when doing the upper bound in
the if.

>> +	return mt9m032_write_reg(client, MT9M032_VBLANK,
>> additional_blanking_rows);
>> +}
>> +
>> +static int mt9m032_update_geom_timing(struct mt9m032 *sensor,
>> +				 const struct v4l2_rect *crop)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
>> +	int ret;
>> +
>> +	if (!crop)
>> +		crop = &sensor->crop;
> 
> I'd rather have the caller do this instead of magically working around a NULL 
> argument.

Yes, on a second look at the current code you're right.

>> +	ret = mt9m032_write_reg(client, MT9M032_COLUMN_SIZE, crop->width - 1);
>> +	if (!ret)
>> +		mt9m032_write_reg(client, MT9M032_ROW_SIZE, crop->height - 1);
> 
> Aren't you missing a ret = here (and below) ?

Ouch.


>> +static int update_formatter2(struct mt9m032 *sensor, bool streaming)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
>> +
>> +	u16 reg_val =   0x1000   /* Dout enable */
>> +		      | 0x0070;  /* parts reserved! */
>> +				 /* possibly for changing to 14-bit mode */
>> +
>> +	if (streaming)
>> +		reg_val |= 0x2000;   /* pixclock enable */
> 
> Please define constants at the beginning of the file (with the register 
> addresses) instead of using magic numbers.

I'm using defines for all register numbers where i know the function
reasonably well and explicit comments or variable names for all the bits i
set in these registers. (And each register is only set in one function)

I think that should be quite decent. Sadly from the material i
have i have a lot of just undocumented pokeing at reserved bits to keep.
For these cases i marked it in the code somehow are reserved and didn't do
any defines for the register names because they would be useless.

Do you think this is acceptable? Or do i need to have a define for each
known bit position the driver sets? What would i do with the undocumented
bits?



>> +#define OFFSET_UNCHANGED	0xFFFFFFFF
>> +static int mt9m032_set_pad_geom(struct mt9m032 *sensor,
>> +				struct v4l2_subdev_fh *fh,
>> +				u32 which, u32 pad,
>> +				s32 top, s32 left, s32 width, s32 height)
>> +{
>> +	struct v4l2_mbus_framefmt tmp_format;
>> +	struct v4l2_rect tmp_crop;
>> +	struct v4l2_mbus_framefmt *format;
>> +	struct v4l2_rect *crop;
>> +
>> +	if (pad != 0)
>> +		return -EINVAL;
>> +
>> +	format = __mt9m032_get_pad_format(sensor, fh, which);
>> +	crop = __mt9m032_get_pad_crop(sensor, fh, which);
>> +	if (!format || !crop)
>> +		return -EINVAL;
>> +	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
>> +		tmp_crop = *crop;
>> +		tmp_format = *format;
>> +		format = &tmp_format;
>> +		crop = &tmp_crop;
>> +	}
>> +
>> +	if (top != OFFSET_UNCHANGED)
>> +		crop->top = top & ~0x1;
>> +	if (left != OFFSET_UNCHANGED)
>> +		crop->left = left;
>> +	crop->height = height;
>> +	crop->width = width & ~1;
>> +
>> +	format->height = crop->height;
>> +	format->width = crop->width;
> 
> This looks very weird to me. If your sensor doesn't include a scaler, it 
> should support a single fixed format. Crop will then be used to select the 
> crop rectangle. You're mixing the two for no obvious reason.
> 

I think i have to have both size and crop writable. So i wrote the code to
just have format width/height and crop width/height to be equal at all
times. So actually almost all code for crop setting and format are shared.

As you wrote in your recent mail this api isn't really intuitive and i'm
not really sure what's the right thing to do thus i just copied the
semantics from an existing driver with similar capable hardware.

This code works nicely and media-ctl needs to be able to set the size so
that's the most logical i could come up with... 

>> +	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
>> +		int ret = mt9m032_update_geom_timing(sensor, crop);
>> +		if (!ret) {
>> +			sensor->crop = tmp_crop;
>> +			sensor->format = tmp_format;
>> +		}
>> +		return ret;
>> +	} else {
>> +		return 0;
>> +	}
>> +}
>> +


>> +static int mt9m032_set_pad_format(struct v4l2_subdev *subdev,
>> +				  struct v4l2_subdev_fh *fh,
>> +				  struct v4l2_subdev_format *fmt)
>> +{
>> +	struct mt9m032 *sensor = to_mt9m032(subdev);
>> +	int ret;
>> +
>> +	if (sensor->streaming)
>> +		return -EBUSY;
>> +	if (fmt->format.code != V4L2_MBUS_FMT_Y8_1X8)
>> +		return -EINVAL;
> 
> Don't return -EINVAL, force the code to V4L2_MBUS_FMT_Y8_1X8 instead.
> 

ok, then i'll handle it like colorspace and field.


>> +static int mt9m032_set_gain(struct mt9m032 *sensor, s32 val)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
>> +	int digital_gain_val;	/* in 1/8th (0..127) */
>> +	int analog_mul;		/* 0 or 1 */
>> +	int analog_gain_val;	/* in 1/16th. (0..63) */
>> +	u16 reg_val;
>> +
>> +	digital_gain_val = 51; /* from setup example */
> 
> So the digital gain isn't configurable ?

Right. That's all that was needed and i couldn't come up with a simple and
nice way to map from one scalar to both digital and analog gain in a nice
way. 

>> +	ret = mt9m032_write_reg(client, MT9M032_PLL_CONFIG1, reg_pll1);
>> +	if (!ret)
>> +		ret = mt9m032_write_reg(client, 0x10, 0x53); /* Select PLL as clock
> 
> No magic numbers please.

Undocumented magical values is all that i have here. I just know these
values have to go there and are the comment text... Nothing hidden i have
access too.

>> +static int mt9m032_get_chip_ident(struct v4l2_subdev *subdev,
>> +		       struct v4l2_dbg_chip_ident *chip)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +
>> +	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_MT9M032, 0);
>> +}
> 
> Is g_chip_ident needed ?

Some comments in the headers said i should implement this...

>> +static int mt9m032_set_config(struct v4l2_subdev *subdev, int irq, void
>> *pdata) +{
>> +	struct mt9m032 *sensor = to_mt9m032(subdev);
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +
>> +	int res, ret;
>> +
>> +	if (!pdata)
>> +		return -ENODEV;
>> +
>> +	sensor->pdata = pdata;
>> +
>> +	ret = mt9m032_write_reg(client, MT9M032_RESET, 1);	/* reset on */
>> +	if (!ret)
>> +		mt9m032_write_reg(client, MT9M032_RESET, 0);	/* reset off */
> 
> Does the chip need a minimum reset duration ?

Not that i know of.

>> +	if (!ret) {
>> +		ret = mt9m032_setup_pll(sensor);
>> +		msleep(10);
>> +	}
>> +	/* Sensor Gain */
>> +	if (!ret)
>> +		ret = mt9m032_set_gain(sensor, sensor->gain->cur.val);
>> +
>> +	   /* Shutter Width */
>> +	if (!ret)
>> +		ret = mt9m032_set_exposure(sensor, sensor->exposure->cur.val);
>> +
>> +	/* SIZE */
>> +	if (!ret)
>> +		ret = mt9m032_update_geom_timing(sensor, NULL);
> 
> Do you really need to override the default reset values ?

Well, maybe it's not strictly needed, but this way we're sure the cached
values and the hardware are in sync.

>> +	if (!ret)
>> +		ret = update_read_mode2(sensor, sensor->vflip->cur.val,
>> sensor->hflip->cur.val); +
>> +	if (!ret)
>> +		ret = mt9m032_write_reg(client, 0x41, 0x0000);	/* reserved !!! */
>> +	if (!ret)
>> +		ret = mt9m032_write_reg(client, 0x42, 0x0003);	/* reserved !!! */
>> +	if (!ret)
>> +		ret = mt9m032_write_reg(client, 0x43, 0x0003);	/* reserved !!! */
>> +	if (!ret)
>> +		ret = mt9m032_write_reg(client, 0x7F, 0x0000);	/* reserved !!! */
> 
> Reserved for what ? No magic numbers here either.

That's all i have. Just that i have to poke these values in. Not even a
clue what they are :/

>> +static int mt9m032_set_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct mt9m032 *sensor = container_of(ctrl->handler, struct mt9m032,
>> ctrls); +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_GAIN:
>> +		return mt9m032_set_gain(sensor, ctrl->val);
>
>As your gain control has two analog stages and a digital stage, 
>mt9m032_set_gain() will sometimes round the gain value. ctrl->val should be 
>updated accordingly.

Ok. i added a try_ctrl to round down the values if >= 63


regards,
 - Martin Hostettler
