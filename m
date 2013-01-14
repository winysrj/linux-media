Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3434 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab3ANJpv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 04:45:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH RFC v1 2/2] V4L: Add driver for OV9650/52 image sensors
Date: Mon, 14 Jan 2013 10:45:44 +0100
Cc: linux-media@vger.kernel.org
References: <1357341023-3202-1-git-send-email-sylvester.nawrocki@gmail.com> <201301071438.30139.hverkuil@xs4all.nl> <50F33FDF.9080206@gmail.com>
In-Reply-To: <50F33FDF.9080206@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301141045.44403.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon January 14 2013 00:14:39 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> Thank you for the review!
> 
> On 01/07/2013 02:38 PM, Hans Verkuil wrote:
> >> +
> >> +/* V4L2 private controls */
> >> +
> >> +/* Auto exposure frame reference area */
> >> +#define V4L2_CID_EXPOSURE_REFERENCE_AREA (V4L2_CTRL_CLASS_CAMERA | 0x1001)
> >> +/* Maximum gain value */
> >> +#define V4L2_CID_GAIN_CEILING		 (V4L2_CTRL_CLASS_CAMERA | 0x1002)
> >
> > Private controls should be added to uapi/linux/v4l2-controls.h. By having
> > all controls in the same header it is easy to ensure that there are no
> > duplicate IDs in use.
> >
> > The name of the driver should be part of the control name, so something like:
> >
> > V4L2_CID_OV9650_EXP_REFERENCE_AREA
> > V4L2_CID_OV9650_GAIN_CEILING
> 
> Ok, to avoid overlapping with couple of existing camera class private 
> controls
> I have defined them as:
> 
> +/* OV965X image sensor driver private controls */
> +
> +/* Auto exposure frame reference area */
> +#define V4L2_CID_OV965X_EXPOSURE_REF_AREA      (V4L2_CTRL_CLASS_CAMERA 
> | 0x1010)
> +/* Automatic gain algorithm's gain limit */
> +#define V4L2_CID_OV965X_GAIN_CEILING           (V4L2_CTRL_CLASS_CAMERA 
> | 0x1011)
> 
> I've checked the datasheets and the gain ceiling control is supported by
> virtually every Omnivision sensor: OV2655, OV3640, OV5630, OV9650, OV9655,
> OV7690, with even identical range 2x...128x.
> 
> The _OV965X prefix for the control doesn't seem right then. Should I make
> it something (ugly) like V4L2_CID_OVXXXX_GAIN_CEILING ?

In that case it would make sense to make this a documented chipset control.
See e.g. the cx2341x and mfc51 MPEG controls:

http://hverkuil.home.xs4all.nl/spec/media.html#mpeg-controls

I'd drop the XXXX in that case.

> 
> And should ranges be reserved for each driver ?

Both, actually. Chipset specific controls get a range, and so do driver specific
controls.

> Or maybe only per 
> manufacturer?
> 
> If I get it right, there is room for 0xffff - 0x1000 = 61439 private 
> controls
> in each control class for all drivers.
> 
> According to the notes from the Kernel Summit 2012 Media Workshop
> (http://lwn.net/Articles/514527):
> 
> "New controls should not overlap.
> Having all driver-specific controls in a single header file would 
> probably be
> overkill.  We can instead reserve a range of CIDs for each driver, and 
> define
> the range base CID only in a common header file.
> Driver-specific CIDs themselves would be defined in driver-specific 
> headers."
> 
> Since there shouldn't generally be many private controls per driver it may
> make more sense to have all put in v4l2-controls.h.

I agree with that.

> 
> ...
> >> +static void ov965x_update_exposure_ctrl(struct ov965x *ov965x)
> >> +{
> >> +	struct v4l2_ctrl *ctrl = ov965x->ctrls.exposure;
> >> +	unsigned long fint, trow;
> >> +	int max;
> >> +	u8 clkrc;
> >> +
> >> +	mutex_lock(&ov965x->lock);
> >> +
> >> +	if (WARN_ON(!ctrl || !ov965x->frame_size)) {
> >> +		mutex_unlock(&ov965x->lock);
> >> +		return;
> >> +	}
> >> +	clkrc = DEF_CLKRC + ov965x->fiv->clkrc_div;
> >> +	/* Calculate internal clock frequency */
> >> +	fint = ov965x->mclk_frequency * ((clkrc>>  7) + 1) /
> >> +				((2 * ((clkrc&  0x3f) + 1)));
> >> +	/* and the row interval (in us). */
> >> +	trow = (2 * 1520 * 1000000UL) / fint;
> >> +	max = ov965x->frame_size->max_exp_lines * trow;
> >> +	ov965x->exp_row_interval = trow;
> >> +
> >> +	mutex_unlock(&ov965x->lock);
> >> +	v4l2_dbg(1, debug,&ov965x->sd, "clkrc: %#x, fi: %lu, tr: %lu, %d\n",
> >> +		 clkrc, fint, trow, max);
> >> +
> >> +	/* Update exposure time min/max to match current frame format. */
> >> +	v4l2_ctrl_lock(ctrl);
> >> +
> >> +	ctrl->minimum = (trow + 100) / 100;
> >> +	ctrl->maximum = (max - 100) / 100;
> >> +	if (ctrl->cur.val>  ctrl->maximum)
> >> +		ctrl->cur.val = ctrl->maximum;
> >> +	if (ctrl->cur.val<  ctrl->minimum)
> >> +		ctrl->cur.val = ctrl->minimum;
> >
> > You can't do this like that. To do this correctly you need to create a new
> > function in v4l2-ctrl.c that allows you to change the control attributes
> > minimum, maximum, step and default_value.
> >
> > That function can then call send_event() to tell external apps that these
> > attributes have changed. That also requires a new flag V4L2_EVENT_CTRL_CH_RANGE.
> >
> > v4l2_ctrl_modify_range() would probably be a good name for such a function.
> 
> Hh, extra work, great! ;)
> 
> So I've created v4l2_ctrl_modify_range() function, with this old patch as
> a reference: http://patchwork.linuxtv.org/patch/8654.
> 
> I'm going to add missing documentation and post it in few days.
> 
> >> +
> >> +	v4l2_ctrl_unlock(ctrl);
> >> +}
> >> +
> ...
> >> +static int ov965x_set_contrast(struct ov965x *ov965x, int value)
> >> +{
> >> +	/* TODO */
> >> +	return -EINVAL;
> >> +}
> >
> > Perhaps this should just be removed?
> 
> OK, let me remove it. If I find more time I'll implement it as a separate
> patch. I left it out for a moment since it requires quite a few register
> values to be rewritten from the datasheet. Not sure if there is any sane
> method to calculate those arrays dynamically in the driver.
> 
> >> +static int ov965x_set_gain(struct ov965x *ov965x, int auto_gain, bool init)
> >> +{
> >> +	struct i2c_client *client = ov965x->client;
> >> +	struct ov965x_ctrls *ctrls =&ov965x->ctrls;
> >> +	int ret = 0;
> >> +	u8 reg;
> >> +	/*
> >> +	 * For manual mode we need to disable AGC first, so
> >> +	 * gain value in REG_VREF, REG_GAIN is not overwritten.
> >> +	 */
> >> +	if (ctrls->auto_gain->is_new || init) {
> >> +		ret = ov965x_read(client, REG_COM8,&reg);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +		if (ctrls->auto_gain->val)
> >> +			reg |= COM8_AGC;
> >> +		else
> >> +			reg&= ~COM8_AGC;
> >> +		ret = ov965x_write(client, REG_COM8, reg);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +	}
> >> +
> >> +	if ((ctrls->gain->is_new || init)&&  !auto_gain) {
> >> +		unsigned int gain = ctrls->gain->val;
> >> +		unsigned int rgain;
> >> +		int m;
> >> +		/*
> >> +		 * Convert gain control value to the sensor's gain
> >> +		 * registers (VREF[7:6], GAIN[7:0]) format.
> >> +		 */
> >> +		for (m = 6; m>= 0; m--)
> >> +			if (gain>= (1<<  m) * 16)
> >> +				break;
> >> +		rgain = (gain - ((1<<  m) * 16)) / (1<<  m);
> >> +		rgain |= (((1<<  m) - 1)<<  4);
> >> +
> >> +		ret = ov965x_write(client, REG_GAIN, rgain&  0xff);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +		ret = ov965x_read(client, REG_VREF,&reg);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +		reg&= ~VREF_GAIN_MASK;
> >> +		reg |= (((rgain>>  8)&  0x3)<<  6);
> >> +		ret = ov965x_write(client, REG_VREF, reg);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +		/* Return updated control's value to userspace */
> >> +		ctrls->gain->val = (1<<  m) * (16 + (rgain&  0xf));
> >> +	}
> >> +
> >> +	if (ctrls->gain_ceiling->is_new || init) {
> >> +		u8 gc = ctrls->gain_ceiling->val;
> >> +		ret = ov965x_read(client, REG_COM9,&reg);
> >> +		if (!ret) {
> >> +			reg&= ~COM9_GAIN_CEIL_MASK;
> >> +			reg |= ((gc&  0x07)<<  4);
> >> +			ret = ov965x_write(client, REG_COM9, reg);
> >> +		}
> >> +	}
> >> +	if (auto_gain)
> >> +		ctrls->gain->flags |= CTRL_FLAG_READ_ONLY_VOLATILE;
> >> +	else
> >> +		ctrls->gain->flags&= ~CTRL_FLAG_READ_ONLY_VOLATILE;
> >> +
> >> +	return ret;
> >> +}
> ...
> >> +static int ov965x_set_exposure(struct ov965x *ov965x, int exp, bool init)
> >> +{
> >> +	struct i2c_client *client = ov965x->client;
> >> +	struct ov965x_ctrls *ctrls =&ov965x->ctrls;
> >> +	bool auto_exposure = (exp == V4L2_EXPOSURE_AUTO);
> >> +	int ret;
> >> +	u8 reg;
> >> +
> >> +	if (ctrls->auto_exp->is_new || init) {
> >> +		ret = ov965x_read(client, REG_COM8,&reg);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +		if (auto_exposure)
> >> +			reg |= (COM8_AEC | COM8_AGC);
> >> +		else
> >> +			reg&= ~(COM8_AEC | COM8_AGC);
> >> +		ret = ov965x_write(client, REG_COM8, reg);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +	}
> >> +
> >> +	if (!auto_exposure&&  (ctrls->exposure->is_new || init)) {
> >> +		unsigned int exposure = (ctrls->exposure->val * 100)
> >> +					 / ov965x->exp_row_interval;
> >> +		/*
> >> +		 * Manual exposure value
> >> +		 * [b15:b0] - AECHM (b15:b10), AECH (b9:b2), COM1 (b1:b0)
> >> +		 */
> >> +		ret = ov965x_write(client, REG_COM1, exposure&  0x3);
> >> +		if (!ret)
> >> +			ret = ov965x_write(client, REG_AECH,
> >> +					   (exposure>>  2)&  0xff);
> >> +		if (!ret)
> >> +			ret = ov965x_write(client, REG_AECHM,
> >> +					   (exposure>>  10)&  0x3f);
> >> +		/* Update the value to minimize rounding errors */
> >> +		ctrls->exposure->val = ((exposure * ov965x->exp_row_interval)
> >> +							+ 50) / 100;
> >> +		if (ret<  0)
> >> +			return ret;
> >> +	}
> >> +
> >> +	if (ctrls->ae_frame_area->is_new || init) {
> >> +		ret = ov965x_read(client, REG_COM11,&reg);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +		reg&= ~COM11_AEC_REF_MASK;
> >> +		reg |= ((ctrls->ae_frame_area->val&  0x3)<<  3);
> >> +		ret = ov965x_write(client, REG_COM11, reg);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +	}
> >> +
> >> +	if (auto_exposure)
> >> +		ctrls->exposure->flags |= CTRL_FLAG_READ_ONLY_VOLATILE;
> >> +	else
> >> +		ctrls->exposure->flags&= ~CTRL_FLAG_READ_ONLY_VOLATILE;
> >> +
> >> +	v4l2_ctrl_activate(ov965x->ctrls.brightness, !exp);
> >> +	return 0;
> >> +}
> ...
> >> +/*
> >> + * Configure sensor register to match default control values. We can't use
> >> + * v4l2_ctrl_handler_setup() here as s_ctrl() also takes ov965x->lock mutex.
> >
> > I don't think it is a good idea to do it like this. It's much better to call
> > v4l2_ctrl_handler_setup directly unless there are really good reasons for not
> > doing that.
> 
> My main concern was the initial registers write sequence. I've based on some
> reference settings which looked like there could be some write sequence
> dependencies, e.g. disabling some algorithm, setting some magic 
> "reserved" I2C
> registers and then enabling the algorithm. Anyway I've tested it with
> v4l2_ctrl_handler_setup() and nothing seems to be broken after that 
> modification.
> 
> > With regards to the locking: I think you might need two locks here: one that
> > protects struct ov965x and one that is used to serialize between calls from
> > a bridge driver and calls directly to the subdev file handle (although I am
> > not certain the latter lock is needed at all).
> 
> I think it is. Some parameters are distributed across multiple I2C 
> registers,
> and multiple parameters sometimes share same register. If there is no lock,
> I2C read/modify/write operations will just fail.
> 
> > In this case I think ov965x->lock shouldn't be held, and v4l2_ctrl_handler_setup
> > should be called.
> 
> I would rather have just one lock. There is an additional one in the 
> control
> framework that one must not be forgetting about, when analysing possible
> locking issues.
> 
> I just moved v4l2_ctrl_handler_setup() call to the s_stream() op, and do
> release ov965x->lock for the time of v4l2_ctrl_handler_setup() call. Not
> perfect but still seems better to me, than introducing an additional lock.
> 
> >> + * Also, explicit function calls allow to better specify the register write
> >> + * sequence.
> >> + */
> >> +static int __ov965x_restore_controls(struct ov965x *ov965x)
> >> +{
> >> +	struct ov965x_ctrls *ctrls =&ov965x->ctrls;
> >> +	int ret;
> >> +
> >> +	ret = ov965x_set_gain(ov965x, ctrls->auto_gain->val, true);
> >> +	if (!ret)
> >> +		ret = ov965x_set_brightness(ov965x, ctrls->brightness->val);
> >> +	if (!ret)
> >> +		ret = ov965x_set_exposure(ov965x, ctrls->auto_exp->val, true);
> >> +	if (!ret)
> >> +		ret = ov965x_set_sharpness(ov965x, ctrls->sharpness->val);
> >> +	if (!ret)
> >> +		ret = ov965x_set_saturation(ov965x, ctrls->saturation->val);
> >> +	if (!ret)
> >> +		ret = ov965x_set_white_balance(ov965x, ctrls->auto_wb->val);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int __g_volatile_ctrl(struct ov965x *ov965x, struct v4l2_ctrl *ctrl)
> >> +{
> >> +	struct i2c_client *client = ov965x->client;
> >> +	unsigned int exposure, gain, m;
> >> +	u8 reg0, reg1, reg2;
> >> +	int ret;
> >> +
> >> +	if (!ov965x->power)
> >> +		return -EAGAIN;
> >
> > How about 'return 0;'? If the power is off, then it seems reasonable to
> > just return the last gain/exposure value. Without power the autogain and
> > autoexposure hardware is turned off as well, so gain and exposure aren't
> > updated.
> 
> That's a good idea actually, thanks! With this modification there is no
> errors now, when querying controls with the sensor's power turned off.
> Not sure how I've missed this simple and best option..
> 
> > I mention this because EAGAIN suggests that you can just try it again a bit
> > later, but that won't help as long as the power isn't turned on.
> 
> It wasn't perfect, indeed.
> 
> >> +	switch (ctrl->id) {
> >> +	case V4L2_CID_AUTOGAIN:
> >> +		if (!ctrl->val)
> >> +			return 0;
> >> +		ret = ov965x_read(client, REG_GAIN,&reg0);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +		ret = ov965x_read(client, REG_VREF,&reg1);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +		gain = ((reg1>>  6)<<  8) | reg0;
> >> +		m = 0x01<<  fls(gain>>  4);
> >> +		ov965x->ctrls.gain->val = m * (16 + (gain&  0xf));
> >> +		break;
> >> +
> >> +	case V4L2_CID_EXPOSURE_AUTO:
> >> +		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
> >> +			return 0;
> >> +		ret = ov965x_read(client, REG_COM1,&reg0);
> >> +		if (!ret)
> >> +			ret = ov965x_read(client, REG_AECH,&reg1);
> >> +		if (!ret)
> >> +			ret = ov965x_read(client, REG_AECHM,&reg2);
> >> +		if (ret<  0)
> >> +			return ret;
> >> +		exposure = ((reg2&  0x3f)<<  10) | (reg1<<  2) |
> >> +						(reg0&  0x3);
> >> +		ov965x->ctrls.exposure->val = ((exposure *
> >> +				ov965x->exp_row_interval) + 50) / 100;
> >> +		break;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> ...
> >> +static int ov965x_initialize_controls(struct ov965x *ov965x)
> >> +{
> >> +	const struct v4l2_ctrl_ops *ops =&ov965x_ctrl_ops;
> >> +	struct ov965x_ctrls *ctrls =&ov965x->ctrls;
> >> +	struct v4l2_ctrl_handler *hdl =&ctrls->handler;
> >> +	int ret;
> >> +
> >> +	ret = v4l2_ctrl_handler_init(hdl, 13);
> >> +	if (ret<  0)
> >> +		return ret;
> >> +
> >> +	/* Auto/manual white balance */
> >> +	ctrls->auto_wb = v4l2_ctrl_new_std(hdl, ops,
> >> +				V4L2_CID_AUTO_WHITE_BALANCE,
> >> +				0, 1, 1, 1);
> >> +	ctrls->blue_balance = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BLUE_BALANCE,
> >> +						0, 0xff, 1, 0x80);
> >> +	ctrls->red_balance = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_RED_BALANCE,
> >> +						0, 0xff, 1, 0x80);
> >> +	/* Auto/manual exposure */
> >> +	ctrls->auto_exp = v4l2_ctrl_new_std_menu(hdl, ops,
> >> +				V4L2_CID_EXPOSURE_AUTO,
> >> +				V4L2_EXPOSURE_MANUAL, 0, V4L2_EXPOSURE_AUTO);
> >> +	/* Exposure time, in 100 us units. min/max is updated dynamically. */
> >> +	ctrls->exposure = v4l2_ctrl_new_std(hdl, ops,
> >> +				V4L2_CID_EXPOSURE_ABSOLUTE,
> >> +				2, 1500, 1, 500);
> >> +	/* Auto exposure reference frame area */
> >> +	ctrls->ae_frame_area = v4l2_ctrl_new_custom(hdl,
> >> +						&ov965x_ctrls[1], NULL);
> >> +	/* Auto/manual gain */
> >> +	ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTOGAIN,
> >> +						0, 1, 1, 1);
> >> +	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
> >> +						16, 64 * (16 + 15), 1, 64 * 16);
> >> +	ctrls->gain_ceiling = v4l2_ctrl_new_custom(hdl,&ov965x_ctrls[0], NULL);
> >> +
> >> +	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION,
> >> +						-2, 2, 1, 0);
> >> +	ctrls->brightness = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BRIGHTNESS,
> >> +						-3, 3, 1, 0);
> >> +	ctrls->contrast = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST,
> >> +						-2, 2, 1, 0);
> >> +	ctrls->sharpness = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SHARPNESS,
> >> +						0, 32, 1, 6);
> >> +
> >> +	ctrls->hflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
> >> +	ctrls->vflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
> >> +
> >> +	ctrls->light_freq = v4l2_ctrl_new_std_menu(hdl, ops,
> >> +				V4L2_CID_POWER_LINE_FREQUENCY,
> >> +				V4L2_CID_POWER_LINE_FREQUENCY_60HZ, ~0x7,
> >> +				V4L2_CID_POWER_LINE_FREQUENCY_50HZ);
> >> +
> >> +	v4l2_ctrl_new_std_menu_items(hdl, ops, V4L2_CID_TEST_PATTERN,
> >> +				ARRAY_SIZE(test_pattern_menu) - 1, 0, 0,
> >> +				test_pattern_menu);
> >> +	if (hdl->error) {
> >> +		ret = hdl->error;
> >> +		v4l2_ctrl_handler_free(hdl);
> >> +		return ret;
> >> +	}
> >> +
> >> +	ctrls->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
> >> +	ctrls->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
> >> +
> >> +	v4l2_ctrl_auto_cluster(3,&ctrls->auto_wb, 0, false);
> >> +	v4l2_ctrl_cluster(3,&ctrls->auto_exp);
> >> +	v4l2_ctrl_cluster(2,&ctrls->hflip);
> >> +	v4l2_ctrl_cluster(3,&ctrls->auto_gain);
> >
> > Why don't you use auto_cluster for gain and exposure? It should simplify your
> > code quite a bit.
> 
> I tried, but it didn't work in these use cases.
> 
> Note there are 3 controls in each cluster, e.g. auto/manual gain, 
> manual_gain,
> gain_ceiling (max auto gain limit). gain_ceiling is only valid for automatic
> gain, and the manual_gain value of course only for manual gain mode. With
> auto_cluster gain_ceiling would be deactivated when gain is set to auto 
> mode,

Does gain_ceiling have to be part of a cluster? Isn't it a standalone control?
It seems to be set independent of the other gain related controls.

Ditto for ae_frame_area AFAICT.

> which is not what I want. The situation with auto exposure is analogous.
> 
> > I also would expect to see a call to v4l2_ctrl_handler_setup() somewhere to
> > initialize the hardware. Not strictly necessary if the initial hardware state
> > is the same as that of the initial controls.
> 
> When the sensor is powered on there is a call to 
> __ov965x_restore_controls(),
> which ensures the state of registers is matching the controls values. The
> sensor is left in power off state by the probe() callback, so there is not
> much sense in doing lengthy I2C communication there, just to lose the device
> state when it is powered off.
> 
> Anyway I've reworked it to use v4l2_ctrl_handler_setup() and removed
> __ov965x_restore_controls() function, which was a bit ugly and I didn't like
> it either.
> 
> >> +
> >> +	ov965x->sd.ctrl_handler = hdl;
> >> +	return 0;
> >> +}
> >> +
> ...
> >> +/*
> >> + * V4L2 subdev internal operations
> >> + */
> >> +static int ov965x_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> >> +{
> >> +	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
> >> +
> >> +	ov965x_get_default_format(mf);
> >> +	v4l2_info(sd, "%s:%d\n", __func__, __LINE__);
> >
> > Shouldn't v4l2_dbg be better? Or don't print anything. Normal usage of a driver
> > should produce output to the kernel log.
> 
> Sure, I suppose you meant "should not"? I missed to remove this trace.
> It's dropped now.
> 
> >> +	return 0;
> >> +}
> >> +
> ...
> >> diff --git a/include/media/ov9650.h b/include/media/ov9650.h
> >> new file mode 100644
> >> index 0000000..ba548a4
> >> --- /dev/null
> >> +++ b/include/media/ov9650.h
> >> @@ -0,0 +1,20 @@
> >> +/*
> >> + * OV9650/OV9652 camera sensors driver
> >> + *
> >> + * Copyright (C) 2012 Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
> >
> > 2012 ->  2013 :-)
> 
> Thanks, updated. I must have left some imperfections for reviewers;)
> 
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + */
> >> +
> >> +#ifndef OV9650_H_
> >> +#define OV9650_H_
> >> +
> >> +struct ov9650_platform_data {
> >> +	unsigned long mclk_frequency;
> >> +	int gpio_pwdn;
> >> +	int gpio_reset;
> >
> > Some comments for these fields would be welcome.
> 
> Added, thanks for pointing out.

Regards,

	Hans
