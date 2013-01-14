Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:58222 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab3ANW0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 17:26:46 -0500
Received: by mail-ea0-f181.google.com with SMTP id k14so1857031eaa.26
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 14:26:44 -0800 (PST)
Message-ID: <50F48622.8060704@gmail.com>
Date: Mon, 14 Jan 2013 23:26:42 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC v1 2/2] V4L: Add driver for OV9650/52 image sensors
References: <1357341023-3202-1-git-send-email-sylvester.nawrocki@gmail.com> <201301071438.30139.hverkuil@xs4all.nl> <50F33FDF.9080206@gmail.com> <201301141045.44403.hverkuil@xs4all.nl>
In-Reply-To: <201301141045.44403.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/14/2013 10:45 AM, Hans Verkuil wrote:
> On Mon January 14 2013 00:14:39 Sylwester Nawrocki wrote:
...
>> I've checked the datasheets and the gain ceiling control is supported by
>> virtually every Omnivision sensor: OV2655, OV3640, OV5630, OV9650, OV9655,
>> OV7690, with even identical range 2x...128x.
>>
>> The _OV965X prefix for the control doesn't seem right then. Should I make
>> it something (ugly) like V4L2_CID_OVXXXX_GAIN_CEILING ?
>
> In that case it would make sense to make this a documented chipset control.
> See e.g. the cx2341x and mfc51 MPEG controls:
>
> http://hverkuil.home.xs4all.nl/spec/media.html#mpeg-controls
>
> I'd drop the XXXX in that case.

That makes sense. I'm not sure if I'll manage to complete all this in time
for v3.9. I guess it would be OK to postpone adding these 2 private 
controls
to the next kernel release ? In fact they are only "nice to have" ones.

>> And should ranges be reserved for each driver ?
>
> Both, actually. Chipset specific controls get a range, and so do driver specific
> controls.

OK. I will likely need to create such a control set for Exynos4412/Exynos5
camera ISP. There should be not many of them but I suspect we'll need some.

>> Or maybe only per
>> manufacturer?
...
>>>> +static int ov965x_set_gain(struct ov965x *ov965x, int auto_gain, bool init)
>>>> +{
>>>> +	struct i2c_client *client = ov965x->client;
>>>> +	struct ov965x_ctrls *ctrls =&ov965x->ctrls;
>>>> +	int ret = 0;
>>>> +	u8 reg;
>>>> +	/*
>>>> +	 * For manual mode we need to disable AGC first, so
>>>> +	 * gain value in REG_VREF, REG_GAIN is not overwritten.
>>>> +	 */
>>>> +	if (ctrls->auto_gain->is_new || init) {
>>>> +		ret = ov965x_read(client, REG_COM8,&reg);
>>>> +		if (ret<   0)
>>>> +			return ret;
>>>> +		if (ctrls->auto_gain->val)
>>>> +			reg |= COM8_AGC;
>>>> +		else
>>>> +			reg&= ~COM8_AGC;
>>>> +		ret = ov965x_write(client, REG_COM8, reg);
>>>> +		if (ret<   0)
>>>> +			return ret;
>>>> +	}
>>>> +
>>>> +	if ((ctrls->gain->is_new || init)&&   !auto_gain) {
>>>> +		unsigned int gain = ctrls->gain->val;
>>>> +		unsigned int rgain;
>>>> +		int m;
>>>> +		/*
>>>> +		 * Convert gain control value to the sensor's gain
>>>> +		 * registers (VREF[7:6], GAIN[7:0]) format.
>>>> +		 */
>>>> +		for (m = 6; m>= 0; m--)
>>>> +			if (gain>= (1<<   m) * 16)
>>>> +				break;
>>>> +		rgain = (gain - ((1<<   m) * 16)) / (1<<   m);
>>>> +		rgain |= (((1<<   m) - 1)<<   4);
>>>> +
>>>> +		ret = ov965x_write(client, REG_GAIN, rgain&   0xff);
>>>> +		if (ret<   0)
>>>> +			return ret;
>>>> +		ret = ov965x_read(client, REG_VREF,&reg);
>>>> +		if (ret<   0)
>>>> +			return ret;
>>>> +		reg&= ~VREF_GAIN_MASK;
>>>> +		reg |= (((rgain>>   8)&   0x3)<<   6);
>>>> +		ret = ov965x_write(client, REG_VREF, reg);
>>>> +		if (ret<   0)
>>>> +			return ret;
>>>> +		/* Return updated control's value to userspace */
>>>> +		ctrls->gain->val = (1<<   m) * (16 + (rgain&   0xf));
>>>> +	}
>>>> +
>>>> +	if (ctrls->gain_ceiling->is_new || init) {
>>>> +		u8 gc = ctrls->gain_ceiling->val;
>>>> +		ret = ov965x_read(client, REG_COM9,&reg);
>>>> +		if (!ret) {
>>>> +			reg&= ~COM9_GAIN_CEIL_MASK;
>>>> +			reg |= ((gc&   0x07)<<   4);
>>>> +			ret = ov965x_write(client, REG_COM9, reg);
>>>> +		}
>>>> +	}
>>>> +	if (auto_gain)
>>>> +		ctrls->gain->flags |= CTRL_FLAG_READ_ONLY_VOLATILE;
>>>> +	else
>>>> +		ctrls->gain->flags&= ~CTRL_FLAG_READ_ONLY_VOLATILE;
>>>> +
>>>> +	return ret;
>>>> +}
>> ...
>>>> +static int ov965x_set_exposure(struct ov965x *ov965x, int exp, bool init)
>>>> +{
>>>> +	struct i2c_client *client = ov965x->client;
>>>> +	struct ov965x_ctrls *ctrls =&ov965x->ctrls;
>>>> +	bool auto_exposure = (exp == V4L2_EXPOSURE_AUTO);
>>>> +	int ret;
>>>> +	u8 reg;
>>>> +
>>>> +	if (ctrls->auto_exp->is_new || init) {
>>>> +		ret = ov965x_read(client, REG_COM8,&reg);
>>>> +		if (ret<   0)
>>>> +			return ret;
>>>> +		if (auto_exposure)
>>>> +			reg |= (COM8_AEC | COM8_AGC);
>>>> +		else
>>>> +			reg&= ~(COM8_AEC | COM8_AGC);
>>>> +		ret = ov965x_write(client, REG_COM8, reg);
>>>> +		if (ret<   0)
>>>> +			return ret;
>>>> +	}
>>>> +
>>>> +	if (!auto_exposure&&   (ctrls->exposure->is_new || init)) {
>>>> +		unsigned int exposure = (ctrls->exposure->val * 100)
>>>> +					 / ov965x->exp_row_interval;
>>>> +		/*
>>>> +		 * Manual exposure value
>>>> +		 * [b15:b0] - AECHM (b15:b10), AECH (b9:b2), COM1 (b1:b0)
>>>> +		 */
>>>> +		ret = ov965x_write(client, REG_COM1, exposure&   0x3);
>>>> +		if (!ret)
>>>> +			ret = ov965x_write(client, REG_AECH,
>>>> +					   (exposure>>   2)&   0xff);
>>>> +		if (!ret)
>>>> +			ret = ov965x_write(client, REG_AECHM,
>>>> +					   (exposure>>   10)&   0x3f);
>>>> +		/* Update the value to minimize rounding errors */
>>>> +		ctrls->exposure->val = ((exposure * ov965x->exp_row_interval)
>>>> +							+ 50) / 100;
>>>> +		if (ret<   0)
>>>> +			return ret;
>>>> +	}
>>>> +
>>>> +	if (ctrls->ae_frame_area->is_new || init) {
>>>> +		ret = ov965x_read(client, REG_COM11,&reg);
>>>> +		if (ret<   0)
>>>> +			return ret;
>>>> +		reg&= ~COM11_AEC_REF_MASK;
>>>> +		reg |= ((ctrls->ae_frame_area->val&   0x3)<<   3);
>>>> +		ret = ov965x_write(client, REG_COM11, reg);
>>>> +		if (ret<   0)
>>>> +			return ret;
>>>> +	}
>>>> +
>>>> +	if (auto_exposure)
>>>> +		ctrls->exposure->flags |= CTRL_FLAG_READ_ONLY_VOLATILE;
>>>> +	else
>>>> +		ctrls->exposure->flags&= ~CTRL_FLAG_READ_ONLY_VOLATILE;
>>>> +
>>>> +	v4l2_ctrl_activate(ov965x->ctrls.brightness, !exp);
>>>> +	return 0;
>>>> +}
...
>>>> +static int ov965x_initialize_controls(struct ov965x *ov965x)
>>>> +{
>>>> +	const struct v4l2_ctrl_ops *ops =&ov965x_ctrl_ops;
>>>> +	struct ov965x_ctrls *ctrls =&ov965x->ctrls;
>>>> +	struct v4l2_ctrl_handler *hdl =&ctrls->handler;
>>>> +	int ret;
>>>> +
>>>> +	ret = v4l2_ctrl_handler_init(hdl, 13);
>>>> +	if (ret<   0)
>>>> +		return ret;
>>>> +
>>>> +	/* Auto/manual white balance */
>>>> +	ctrls->auto_wb = v4l2_ctrl_new_std(hdl, ops,
>>>> +				V4L2_CID_AUTO_WHITE_BALANCE,
>>>> +				0, 1, 1, 1);
>>>> +	ctrls->blue_balance = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BLUE_BALANCE,
>>>> +						0, 0xff, 1, 0x80);
>>>> +	ctrls->red_balance = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_RED_BALANCE,
>>>> +						0, 0xff, 1, 0x80);
>>>> +	/* Auto/manual exposure */
>>>> +	ctrls->auto_exp = v4l2_ctrl_new_std_menu(hdl, ops,
>>>> +				V4L2_CID_EXPOSURE_AUTO,
>>>> +				V4L2_EXPOSURE_MANUAL, 0, V4L2_EXPOSURE_AUTO);
>>>> +	/* Exposure time, in 100 us units. min/max is updated dynamically. */
>>>> +	ctrls->exposure = v4l2_ctrl_new_std(hdl, ops,
>>>> +				V4L2_CID_EXPOSURE_ABSOLUTE,
>>>> +				2, 1500, 1, 500);
>>>> +	/* Auto exposure reference frame area */
>>>> +	ctrls->ae_frame_area = v4l2_ctrl_new_custom(hdl,
>>>> +						&ov965x_ctrls[1], NULL);
>>>> +	/* Auto/manual gain */
>>>> +	ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTOGAIN,
>>>> +						0, 1, 1, 1);
>>>> +	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
>>>> +						16, 64 * (16 + 15), 1, 64 * 16);
>>>> +	ctrls->gain_ceiling = v4l2_ctrl_new_custom(hdl,&ov965x_ctrls[0], NULL);
>>>> +
>>>> +	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION,
>>>> +						-2, 2, 1, 0);
>>>> +	ctrls->brightness = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BRIGHTNESS,
>>>> +						-3, 3, 1, 0);
>>>> +	ctrls->contrast = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST,
>>>> +						-2, 2, 1, 0);
>>>> +	ctrls->sharpness = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SHARPNESS,
>>>> +						0, 32, 1, 6);
>>>> +
>>>> +	ctrls->hflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
>>>> +	ctrls->vflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
>>>> +
>>>> +	ctrls->light_freq = v4l2_ctrl_new_std_menu(hdl, ops,
>>>> +				V4L2_CID_POWER_LINE_FREQUENCY,
>>>> +				V4L2_CID_POWER_LINE_FREQUENCY_60HZ, ~0x7,
>>>> +				V4L2_CID_POWER_LINE_FREQUENCY_50HZ);
>>>> +
>>>> +	v4l2_ctrl_new_std_menu_items(hdl, ops, V4L2_CID_TEST_PATTERN,
>>>> +				ARRAY_SIZE(test_pattern_menu) - 1, 0, 0,
>>>> +				test_pattern_menu);
>>>> +	if (hdl->error) {
>>>> +		ret = hdl->error;
>>>> +		v4l2_ctrl_handler_free(hdl);
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	ctrls->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
>>>> +	ctrls->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
>>>> +
>>>> +	v4l2_ctrl_auto_cluster(3,&ctrls->auto_wb, 0, false);
>>>> +	v4l2_ctrl_cluster(3,&ctrls->auto_exp);
>>>> +	v4l2_ctrl_cluster(2,&ctrls->hflip);
>>>> +	v4l2_ctrl_cluster(3,&ctrls->auto_gain);
>>>
>>> Why don't you use auto_cluster for gain and exposure? It should simplify your
>>> code quite a bit.
>>
>> I tried, but it didn't work in these use cases.
>>
>> Note there are 3 controls in each cluster, e.g. auto/manual gain,
>> manual_gain,
>> gain_ceiling (max auto gain limit). gain_ceiling is only valid for automatic
>> gain, and the manual_gain value of course only for manual gain mode. With
>> auto_cluster gain_ceiling would be deactivated when gain is set to auto
>> mode,
>
> Does gain_ceiling have to be part of a cluster? Isn't it a standalone control?
> It seems to be set independent of the other gain related controls.

I thought it's cleaner that way. gain_ceiling is only effective with AGC 
enabled.
Now I see I missed to set relevant control flags, so user space is aware 
of that.

> Ditto for ae_frame_area AFAICT.

Yeah, similar situation here.


Thanks,
Sylwester
