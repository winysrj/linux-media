Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9316 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1I0IHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 04:07:52 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LS6003GO991WN00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Sep 2011 09:07:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LS600H0X990WP@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Sep 2011 09:07:49 +0100 (BST)
Date: Tue, 27 Sep 2011 10:07:48 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 2/2] v4l: Add v4l2 subdev driver for S5K6AAFX sensor
In-reply-to: <201109270914.05718.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <4E818454.1090609@samsung.com>
References: <1316627107-18709-1-git-send-email-s.nawrocki@samsung.com>
 <201109261521.21989.hverkuil@xs4all.nl> <4E80F384.2040602@gmail.com>
 <201109270914.05718.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/2011 09:14 AM, Hans Verkuil wrote:
> On Monday, September 26, 2011 23:49:56 Sylwester Nawrocki wrote:
>> Hi Hans,
>>
>> thanks for the comments. It's good to see you back, this mailing list
>> had been much more quiet when you've been away for a while;)
>> I hope everything got well for you.
>>
>> On 09/26/2011 03:21 PM, Hans Verkuil wrote:
>>> On Wednesday, September 21, 2011 19:45:07 Sylwester Nawrocki wrote:
>>>> This driver exposes preview mode operation of the S5K6AAFX sensor with
>>>> embedded SoC ISP. It uses one of the five user predefined configuration
>>>> register sets. There is yet no support for capture (snapshot) operation.
>>>> Following controls are supported:
>>>> manual/auto exposure and gain, power line frequency (anti-flicker),
>>>> saturation, sharpness, brightness, contrast, white balance temperature,
>>>> color effects, horizontal/vertical image flip, frame interval.
>>>>
>>>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>> ---
>> ...
>>>> +/*
>>>> + * V4L2 subdev core and video operations
>>>> + */
>>>> +static int s5k6aa_set_power(struct v4l2_subdev *sd, int on)
>>>> +{
>>>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>>>> +	int ret = 0;
>>>> +
>>>> +	mutex_lock(&s5k6aa->lock);
>>>> +
>>>> +	if (!on == s5k6aa->power) {
>>>> +		if (on) {
>>>> +			ret = __s5k6aa_power_enable(s5k6aa);
>>>> +			if (!ret)
>>>> +				ret = s5k6aa_initialize_isp(sd);
>>>> +		} else {
>>>> +			ret = __s5k6aa_power_disable(s5k6aa);
>>>> +		}
>>>> +	}
>>>> +	if (!ret&&  !WARN_ON(s5k6aa->power<  0))
>>>> +		s5k6aa->power += on ? 1 : -1;
>>>> +	mutex_unlock(&s5k6aa->lock);
>>>> +
>>>> +	if (!ret&&  on&&  s5k6aa->power == 1)
>>>> +		return v4l2_ctrl_handler_setup(sd->ctrl_handler);
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int __s5k6aa_stream(struct s5k6aa *s5k6aa, int enable)
>>>> +{
>>>> +	struct i2c_client *client = v4l2_get_subdevdata(&s5k6aa->sd);
>>>> +	int ret;
>>>> +
>>>> +	ret = s5k6aa_write(client, REG_G_ENABLE_PREV, enable);
>>>> +	if (!ret)
>>>> +		ret = s5k6aa_write(client, REG_G_ENABLE_PREV_CHG, 1);
>>>> +	if (!ret)
>>>> +		ret = s5k6aa_write(client, REG_G_NEW_CFG_SYNC, 1);
>>>> +	if (!ret)
>>>> +		s5k6aa->streaming = enable;
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int s5k6aa_s_stream(struct v4l2_subdev *sd, int on)
>>>> +{
>>>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>>>> +	int ret = 0;
>>>> +
>>>> +	mutex_lock(&s5k6aa->lock);
>>>
>>> Stupid question perhaps, but why do you need a lock? Usually these calls are
>>> serialized by the bridge driver. Most subdevs don't use a lock, unless they
>>> start some thread of their own.
>>
>> I wish I could get rid of the lock, but it seems necessary as long as the device
>> can be accessed through two device nodes: /dev/video? and /dev/v4l-subdev?.
> 
> Ah yes, that's true.
> 
>> It holds mostly for s_ctrl, which can be called on the subdev node, the other
>> subdev ops generally don't attempt to access I2C.
> 
> The control framework has its own locking, so s_ctrl is guaranteed to be serialized.

Yup, I was aware of that.

> So you don't need to lock there.

I still need the I2C mutex there, which is used to serialize the device I2C
interface access across various subdev ops, s_ctrl among others.

> 
>> So this lock is also an I2C interface mutex ensuring correct configuration 
>> registers read/write sequences. Especially nothing should be allowed to interfere
>> with the ISP initialization routine, which is executed through s_power op at
>> the time of /dev/video? open().
>>
>> Yes, adding device node to subdevs made things slightly more complicated :)
> 
> I need to look at this some more: see if we can support the core locking
> mechanism for subdev nodes as well.

I think it could be useful to have an option to use the core lock. However
I guess it's not easy to implement as the drivers are quite independent.
Maybe it could be added somewhere around v4l2_device_register_subdev_nodes().

> 
>> I wonder how other subdevs resolve the serialization without a lock.
> 
> They don't have their own device node :-)

Some of them have, IIRC.

> 
>>
>>>
>>>> +
>>>> +	if (!s5k6aa->streaming == !on) {
>>>> +		mutex_unlock(&s5k6aa->lock);
>>>> +		return 0;
>>>> +	}
>>>> +	if (s5k6aa->apply_new_cfg)
>>>> +		ret = s5k6aa_set_preview_preset(s5k6aa, s5k6aa->preset);
>>>> +	if (!ret)
>>>> +		ret = __s5k6aa_stream(s5k6aa, !!on);
>>>> +
>>>> +	mutex_unlock(&s5k6aa->lock);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int s5k6aa_g_frame_interval(struct v4l2_subdev *sd,
>>>> +				   struct v4l2_subdev_frame_interval *fi)
>>>> +{
>>>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>>>> +
>>>> +	memset(fi->reserved, 0, sizeof(fi->reserved));
>>>> +
>>>> +	mutex_lock(&s5k6aa->lock);
>>>> +	fi->interval = s5k6aa->fiv->interval;
>>>> +	mutex_unlock(&s5k6aa->lock);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int __s5k6aa_set_frame_interval(struct s5k6aa *s5k6aa,
>>>> +				       struct v4l2_subdev_frame_interval *fi)
>>>> +{
>>>> +	struct v4l2_frmsize_discrete *out_win =&s5k6aa->preset->out_size;
>>>> +	const struct s5k6aa_interval *fiv =&s5k6aa_intervals[0];
>>>> +	unsigned int err, min_err = UINT_MAX;
>>>> +	unsigned int i, fr_time;
>>>> +
>>>> +	if (fi->interval.denominator == 0)
>>>> +		return -EINVAL;
>>>> +
>>>> +	memset(fi->reserved, 0, sizeof(fi->reserved));
>>>> +	fr_time = fi->interval.numerator * 10000 / fi->interval.denominator;
>>>> +
>>>> +	for (i = 0; i<  ARRAY_SIZE(s5k6aa_intervals); i++) {
>>>> +		const struct s5k6aa_interval *iv =&s5k6aa_intervals[i];
>>>> +
>>>> +		if (out_win->width>  iv->size.width ||
>>>> +		    out_win->height>  iv->size.height)
>>>> +			continue;
>>>> +
>>>> +		err = abs(iv->reg_fr_time - fr_time);
>>>> +		if (err<  min_err) {
>>>> +			fiv = iv;
>>>> +			min_err = err;
>>>> +		}
>>>> +	}
>>>> +	s5k6aa->fiv = fiv;
>>>> +
>>>> +	v4l2_dbg(1, debug,&s5k6aa->sd, "Changed frame interval to %d us\n",
>>>> +		 fiv->reg_fr_time * 100);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int s5k6aa_s_frame_interval(struct v4l2_subdev *sd,
>>>> +				   struct v4l2_subdev_frame_interval *fi)
>>>> +{
>>>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>>>> +	int ret;
>>>> +
>>>> +	v4l2_dbg(1, debug, sd, "Setting %d/%d frame interval\n",
>>>> +		 fi->interval.numerator, fi->interval.denominator);
>>>> +
>>>> +	mutex_lock(&s5k6aa->lock);
>>>> +	ret = __s5k6aa_set_frame_interval(s5k6aa, fi);
>>>> +	s5k6aa->apply_new_cfg = 1;
>>>> +
>>>> +	mutex_unlock(&s5k6aa->lock);
>>>> +	return ret;
>>>> +}
>>>> +
>> ...
>>>> +static const struct v4l2_subdev_pad_ops s5k6aa_pad_ops = {
>>>> +	.enum_mbus_code		= s5k6aa_enum_mbus_code,
>>>> +	.enum_frame_size	= s5k6aa_enum_frame_size,
>>>> +	.enum_frame_interval	= s5k6aa_enum_frame_interval,
>>>> +	.get_fmt		= s5k6aa_get_fmt,
>>>> +	.set_fmt		= s5k6aa_set_fmt,
>>>> +};
>>>> +
>>>> +/*
>>>> + * V4L2 subdev control operations
>>>> + */
>>>> +static int s5k6aa_s_ctrl(struct v4l2_ctrl *ctrl)
>>>> +{
>>>> +	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
>>>> +	struct i2c_client *c = v4l2_get_subdevdata(sd);
>>>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>>>> +	int pid, err = 0;
>>>> +
>>>> +	v4l2_dbg(1, debug, sd, "%s: ctrl: 0x%x, value: %d\n",
>>>> +		 __func__, ctrl->id, ctrl->val);
>>>> +
>>>> +	mutex_lock(&s5k6aa->lock);
>>>> +	/*
>>>> +	 * If the device is not powered up by the host driver do
>>>> +	 * not apply any controls to H/W at this time. Instead
>>>> +	 * the controls will be restored right after power-up.
>>>> +	 */
>>>> +	if (s5k6aa->power == 0)
>>>> +		goto unlock;
>>>> +	pid = s5k6aa->preset->index;
>>>> +
>>>> +	switch (ctrl->id) {
>>>> +	case V4L2_CID_BRIGHTNESS:
>>>> +		err = s5k6aa_write(c, REG_USER_BRIGHTNESS, ctrl->val);
>>>> +		break;
>>>> +
>>>> +	case V4L2_CID_COLORFX:
>>>> +		err = s5k6aa_set_colorfx(s5k6aa, ctrl->val);
>>>> +		break;
>>>> +
>>>> +	case V4L2_CID_CONTRAST:
>>>> +		err = s5k6aa_write(c, REG_USER_CONTRAST, ctrl->val);
>>>> +		break;
>>>> +
>>>> +	case V4L2_CID_EXPOSURE_AUTO:
>>>> +		err = s5k6aa_set_auto_exposure(s5k6aa, ctrl->val);
>>>> +		break;
>>>> +
>>>> +	case V4L2_CID_HFLIP:
>>>> +		err = s5k6aa_set_mirror(s5k6aa, ctrl->val);
>>>> +		break;
>>>> +
>>>> +	case V4L2_CID_POWER_LINE_FREQUENCY:
>>>> +		err = s5k6aa_set_anti_flicker(s5k6aa, ctrl->val);
>>>> +		break;
>>>> +
>>>> +	case V4L2_CID_SATURATION:
>>>> +		err = s5k6aa_write(c, REG_USER_SATURATION, ctrl->val);
>>>> +		break;
>>>> +
>>>> +	case V4L2_CID_SHARPNESS:
>>>> +		err = s5k6aa_write(c, REG_USER_SHARPBLUR, ctrl->val);
>>>> +		break;
>>>> +
>>>> +	case V4L2_CID_WHITE_BALANCE_TEMPERATURE:
>>>> +		err = s5k6aa_write(c, REG_P_COLORTEMP(pid), ctrl->val);
>>>> +		break;
>>>> +	}
>>>> +	/* This should be really called once per all controls update
>>>> +	   rather than per each control. */
>>>> +	if (!err)
>>>> +		err = s5k6aa_sync_preview_preset(c, 0);
>>>> +unlock:
>>>> +	mutex_unlock(&s5k6aa->lock);
>>>> +	return err;
>>>> +}
>>>> +
>>>> +static const struct v4l2_ctrl_ops s5k6aa_ctrl_ops = {
>>>> +	.s_ctrl	= s5k6aa_s_ctrl,
>>>> +};
>>>> +
>>>> +static int s5k6aa_log_status(struct v4l2_subdev *sd)
>>>> +{
>>>> +	v4l2_ctrl_handler_log_status(sd->ctrl_handler, sd->name);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static const struct v4l2_subdev_video_ops s5k6aa_video_ops = {
>>>> +	.g_frame_interval = s5k6aa_g_frame_interval,
>>>> +	.s_frame_interval = s5k6aa_s_frame_interval,
>>>> +	.s_stream = s5k6aa_s_stream,
>>>> +};
>>>> +
>>>> +/*
>>>> + * V4L2 subdev internal operations
>>>> + */
>>>> +static int s5k6aa_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>>>> +{
>>>> +	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
>>>> +
>>>> +	s5k6aa_get_preset_fmt(to_s5k6aa(sd)->preset, mf);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +int s5k6aa_check_fw_revision(struct s5k6aa *s5k6aa)
>>>> +{
>>>> +	struct i2c_client *client = v4l2_get_subdevdata(&s5k6aa->sd);
>>>> +	u16 api_ver = 0, fw_rev = 0;
>>>> +
>>>> +	int ret = s5k6aa_set_ahb_address(client);
>>>> +
>>>> +	if (!ret)
>>>> +		ret = s5k6aa_read(client, REG_FW_APIVER,&api_ver);
>>>> +	if (!ret)
>>>> +		ret = s5k6aa_read(client, REG_FW_REVISION,&fw_rev);
>>>> +	if (ret) {
>>>> +		v4l2_err(&s5k6aa->sd, "FW revision check failed!\n");
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	v4l2_info(&s5k6aa->sd, "FW API ver.: 0x%X, FW rev.: 0x%X\n",
>>>> +		  api_ver, fw_rev);
>>>> +
>>>> +	return api_ver == S5K6AAFX_FW_APIVER ? 0 : -ENODEV;
>>>> +}
>>>> +
>>>> +static int s5k6aa_registered(struct v4l2_subdev *sd)
>>>> +{
>>>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>>>> +	int ret;
>>>> +
>>>> +	mutex_lock(&s5k6aa->lock);
>>>> +	ret = __s5k6aa_power_enable(s5k6aa);
>>>> +	if (!ret) {
>>>> +		msleep(100);
>>>> +		ret = s5k6aa_check_fw_revision(s5k6aa);
>>>> +		__s5k6aa_power_disable(s5k6aa);
>>>> +	}
>>>> +	mutex_unlock(&s5k6aa->lock);
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static const struct v4l2_subdev_internal_ops s5k6aa_subdev_internal_ops = {
>>>> +	.registered	= s5k6aa_registered,
>>>> +	.open		= s5k6aa_open,
>>>> +};
>>>> +
>>>> +static const struct v4l2_subdev_core_ops s5k6aa_core_ops = {
>>>> +	.s_power	= s5k6aa_set_power,
>>>> +	.g_ctrl		= v4l2_subdev_g_ctrl,
>>>> +	.s_ctrl		= v4l2_subdev_s_ctrl,
>>>> +	.queryctrl	= v4l2_subdev_queryctrl,
>>>> +	.querymenu	= v4l2_subdev_querymenu,
>>>> +	.g_ext_ctrls	= v4l2_subdev_g_ext_ctrls,
>>>> +	.try_ext_ctrls	= v4l2_subdev_try_ext_ctrls,
>>>> +	.s_ext_ctrls	= v4l2_subdev_s_ext_ctrls,
>>>
>>> Don't add these control ops. They are only needed if this subdev driver is
>>> used by bridge drivers that are not yet converted to the control framework.
>>> That's not the case, so just remove these ops here.
>>
>> Great! thanks for the hint. I've just added this to the list of changes for v3.
>>
>>>
>>>> +	.log_status	= s5k6aa_log_status,
>>
>> Do we plan to support this op directly on subdev nodes ? Or should it be only
>> accessible through bridge drivers ?
>> I was just wondering if we should add VIDIOC_LOG_STATUS to subdev_do_ioctl().
> 
> We should. Just one of those things that we didn't get around to.
> Can you add it?

Yeah, I could take care of it. I'll also check the Docbook, if we need any changes
there.

> 
> Regards,
> 
> 	Hans


Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
