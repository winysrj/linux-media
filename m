Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32932 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1IZVuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 17:50:04 -0400
Received: by fxe4 with SMTP id 4so6490001fxe.19
        for <linux-media@vger.kernel.org>; Mon, 26 Sep 2011 14:50:02 -0700 (PDT)
Message-ID: <4E80F384.2040602@gmail.com>
Date: Mon, 26 Sep 2011 23:49:56 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Subject: Re: [PATCH v2 2/2] v4l: Add v4l2 subdev driver for S5K6AAFX sensor
References: <1316627107-18709-1-git-send-email-s.nawrocki@samsung.com> <1316627107-18709-3-git-send-email-s.nawrocki@samsung.com> <201109261521.21989.hverkuil@xs4all.nl>
In-Reply-To: <201109261521.21989.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

thanks for the comments. It's good to see you back, this mailing list
had been much more quiet when you've been away for a while;)
I hope everything got well for you.

On 09/26/2011 03:21 PM, Hans Verkuil wrote:
> On Wednesday, September 21, 2011 19:45:07 Sylwester Nawrocki wrote:
>> This driver exposes preview mode operation of the S5K6AAFX sensor with
>> embedded SoC ISP. It uses one of the five user predefined configuration
>> register sets. There is yet no support for capture (snapshot) operation.
>> Following controls are supported:
>> manual/auto exposure and gain, power line frequency (anti-flicker),
>> saturation, sharpness, brightness, contrast, white balance temperature,
>> color effects, horizontal/vertical image flip, frame interval.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
...
>> +/*
>> + * V4L2 subdev core and video operations
>> + */
>> +static int s5k6aa_set_power(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>> +	int ret = 0;
>> +
>> +	mutex_lock(&s5k6aa->lock);
>> +
>> +	if (!on == s5k6aa->power) {
>> +		if (on) {
>> +			ret = __s5k6aa_power_enable(s5k6aa);
>> +			if (!ret)
>> +				ret = s5k6aa_initialize_isp(sd);
>> +		} else {
>> +			ret = __s5k6aa_power_disable(s5k6aa);
>> +		}
>> +	}
>> +	if (!ret&&  !WARN_ON(s5k6aa->power<  0))
>> +		s5k6aa->power += on ? 1 : -1;
>> +	mutex_unlock(&s5k6aa->lock);
>> +
>> +	if (!ret&&  on&&  s5k6aa->power == 1)
>> +		return v4l2_ctrl_handler_setup(sd->ctrl_handler);
>> +
>> +	return ret;
>> +}
>> +
>> +static int __s5k6aa_stream(struct s5k6aa *s5k6aa, int enable)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&s5k6aa->sd);
>> +	int ret;
>> +
>> +	ret = s5k6aa_write(client, REG_G_ENABLE_PREV, enable);
>> +	if (!ret)
>> +		ret = s5k6aa_write(client, REG_G_ENABLE_PREV_CHG, 1);
>> +	if (!ret)
>> +		ret = s5k6aa_write(client, REG_G_NEW_CFG_SYNC, 1);
>> +	if (!ret)
>> +		s5k6aa->streaming = enable;
>> +
>> +	return ret;
>> +}
>> +
>> +static int s5k6aa_s_stream(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>> +	int ret = 0;
>> +
>> +	mutex_lock(&s5k6aa->lock);
> 
> Stupid question perhaps, but why do you need a lock? Usually these calls are
> serialized by the bridge driver. Most subdevs don't use a lock, unless they
> start some thread of their own.

I wish I could get rid of the lock, but it seems necessary as long as the device
can be accessed through two device nodes: /dev/video? and /dev/v4l-subdev?.

It holds mostly for s_ctrl, which can be called on the subdev node, the other
subdev ops generally don't attempt to access I2C.

So this lock is also an I2C interface mutex ensuring correct configuration 
registers read/write sequences. Especially nothing should be allowed to interfere
with the ISP initialization routine, which is executed through s_power op at
the time of /dev/video? open().

Yes, adding device node to subdevs made things slightly more complicated :)

I wonder how other subdevs resolve the serialization without a lock.

> 
>> +
>> +	if (!s5k6aa->streaming == !on) {
>> +		mutex_unlock(&s5k6aa->lock);
>> +		return 0;
>> +	}
>> +	if (s5k6aa->apply_new_cfg)
>> +		ret = s5k6aa_set_preview_preset(s5k6aa, s5k6aa->preset);
>> +	if (!ret)
>> +		ret = __s5k6aa_stream(s5k6aa, !!on);
>> +
>> +	mutex_unlock(&s5k6aa->lock);
>> +	return ret;
>> +}
>> +
>> +static int s5k6aa_g_frame_interval(struct v4l2_subdev *sd,
>> +				   struct v4l2_subdev_frame_interval *fi)
>> +{
>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>> +
>> +	memset(fi->reserved, 0, sizeof(fi->reserved));
>> +
>> +	mutex_lock(&s5k6aa->lock);
>> +	fi->interval = s5k6aa->fiv->interval;
>> +	mutex_unlock(&s5k6aa->lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int __s5k6aa_set_frame_interval(struct s5k6aa *s5k6aa,
>> +				       struct v4l2_subdev_frame_interval *fi)
>> +{
>> +	struct v4l2_frmsize_discrete *out_win =&s5k6aa->preset->out_size;
>> +	const struct s5k6aa_interval *fiv =&s5k6aa_intervals[0];
>> +	unsigned int err, min_err = UINT_MAX;
>> +	unsigned int i, fr_time;
>> +
>> +	if (fi->interval.denominator == 0)
>> +		return -EINVAL;
>> +
>> +	memset(fi->reserved, 0, sizeof(fi->reserved));
>> +	fr_time = fi->interval.numerator * 10000 / fi->interval.denominator;
>> +
>> +	for (i = 0; i<  ARRAY_SIZE(s5k6aa_intervals); i++) {
>> +		const struct s5k6aa_interval *iv =&s5k6aa_intervals[i];
>> +
>> +		if (out_win->width>  iv->size.width ||
>> +		    out_win->height>  iv->size.height)
>> +			continue;
>> +
>> +		err = abs(iv->reg_fr_time - fr_time);
>> +		if (err<  min_err) {
>> +			fiv = iv;
>> +			min_err = err;
>> +		}
>> +	}
>> +	s5k6aa->fiv = fiv;
>> +
>> +	v4l2_dbg(1, debug,&s5k6aa->sd, "Changed frame interval to %d us\n",
>> +		 fiv->reg_fr_time * 100);
>> +	return 0;
>> +}
>> +
>> +static int s5k6aa_s_frame_interval(struct v4l2_subdev *sd,
>> +				   struct v4l2_subdev_frame_interval *fi)
>> +{
>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>> +	int ret;
>> +
>> +	v4l2_dbg(1, debug, sd, "Setting %d/%d frame interval\n",
>> +		 fi->interval.numerator, fi->interval.denominator);
>> +
>> +	mutex_lock(&s5k6aa->lock);
>> +	ret = __s5k6aa_set_frame_interval(s5k6aa, fi);
>> +	s5k6aa->apply_new_cfg = 1;
>> +
>> +	mutex_unlock(&s5k6aa->lock);
>> +	return ret;
>> +}
>> +
...
>> +static const struct v4l2_subdev_pad_ops s5k6aa_pad_ops = {
>> +	.enum_mbus_code		= s5k6aa_enum_mbus_code,
>> +	.enum_frame_size	= s5k6aa_enum_frame_size,
>> +	.enum_frame_interval	= s5k6aa_enum_frame_interval,
>> +	.get_fmt		= s5k6aa_get_fmt,
>> +	.set_fmt		= s5k6aa_set_fmt,
>> +};
>> +
>> +/*
>> + * V4L2 subdev control operations
>> + */
>> +static int s5k6aa_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
>> +	struct i2c_client *c = v4l2_get_subdevdata(sd);
>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>> +	int pid, err = 0;
>> +
>> +	v4l2_dbg(1, debug, sd, "%s: ctrl: 0x%x, value: %d\n",
>> +		 __func__, ctrl->id, ctrl->val);
>> +
>> +	mutex_lock(&s5k6aa->lock);
>> +	/*
>> +	 * If the device is not powered up by the host driver do
>> +	 * not apply any controls to H/W at this time. Instead
>> +	 * the controls will be restored right after power-up.
>> +	 */
>> +	if (s5k6aa->power == 0)
>> +		goto unlock;
>> +	pid = s5k6aa->preset->index;
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_BRIGHTNESS:
>> +		err = s5k6aa_write(c, REG_USER_BRIGHTNESS, ctrl->val);
>> +		break;
>> +
>> +	case V4L2_CID_COLORFX:
>> +		err = s5k6aa_set_colorfx(s5k6aa, ctrl->val);
>> +		break;
>> +
>> +	case V4L2_CID_CONTRAST:
>> +		err = s5k6aa_write(c, REG_USER_CONTRAST, ctrl->val);
>> +		break;
>> +
>> +	case V4L2_CID_EXPOSURE_AUTO:
>> +		err = s5k6aa_set_auto_exposure(s5k6aa, ctrl->val);
>> +		break;
>> +
>> +	case V4L2_CID_HFLIP:
>> +		err = s5k6aa_set_mirror(s5k6aa, ctrl->val);
>> +		break;
>> +
>> +	case V4L2_CID_POWER_LINE_FREQUENCY:
>> +		err = s5k6aa_set_anti_flicker(s5k6aa, ctrl->val);
>> +		break;
>> +
>> +	case V4L2_CID_SATURATION:
>> +		err = s5k6aa_write(c, REG_USER_SATURATION, ctrl->val);
>> +		break;
>> +
>> +	case V4L2_CID_SHARPNESS:
>> +		err = s5k6aa_write(c, REG_USER_SHARPBLUR, ctrl->val);
>> +		break;
>> +
>> +	case V4L2_CID_WHITE_BALANCE_TEMPERATURE:
>> +		err = s5k6aa_write(c, REG_P_COLORTEMP(pid), ctrl->val);
>> +		break;
>> +	}
>> +	/* This should be really called once per all controls update
>> +	   rather than per each control. */
>> +	if (!err)
>> +		err = s5k6aa_sync_preview_preset(c, 0);
>> +unlock:
>> +	mutex_unlock(&s5k6aa->lock);
>> +	return err;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops s5k6aa_ctrl_ops = {
>> +	.s_ctrl	= s5k6aa_s_ctrl,
>> +};
>> +
>> +static int s5k6aa_log_status(struct v4l2_subdev *sd)
>> +{
>> +	v4l2_ctrl_handler_log_status(sd->ctrl_handler, sd->name);
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_subdev_video_ops s5k6aa_video_ops = {
>> +	.g_frame_interval = s5k6aa_g_frame_interval,
>> +	.s_frame_interval = s5k6aa_s_frame_interval,
>> +	.s_stream = s5k6aa_s_stream,
>> +};
>> +
>> +/*
>> + * V4L2 subdev internal operations
>> + */
>> +static int s5k6aa_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
>> +
>> +	s5k6aa_get_preset_fmt(to_s5k6aa(sd)->preset, mf);
>> +	return 0;
>> +}
>> +
>> +int s5k6aa_check_fw_revision(struct s5k6aa *s5k6aa)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&s5k6aa->sd);
>> +	u16 api_ver = 0, fw_rev = 0;
>> +
>> +	int ret = s5k6aa_set_ahb_address(client);
>> +
>> +	if (!ret)
>> +		ret = s5k6aa_read(client, REG_FW_APIVER,&api_ver);
>> +	if (!ret)
>> +		ret = s5k6aa_read(client, REG_FW_REVISION,&fw_rev);
>> +	if (ret) {
>> +		v4l2_err(&s5k6aa->sd, "FW revision check failed!\n");
>> +		return ret;
>> +	}
>> +
>> +	v4l2_info(&s5k6aa->sd, "FW API ver.: 0x%X, FW rev.: 0x%X\n",
>> +		  api_ver, fw_rev);
>> +
>> +	return api_ver == S5K6AAFX_FW_APIVER ? 0 : -ENODEV;
>> +}
>> +
>> +static int s5k6aa_registered(struct v4l2_subdev *sd)
>> +{
>> +	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
>> +	int ret;
>> +
>> +	mutex_lock(&s5k6aa->lock);
>> +	ret = __s5k6aa_power_enable(s5k6aa);
>> +	if (!ret) {
>> +		msleep(100);
>> +		ret = s5k6aa_check_fw_revision(s5k6aa);
>> +		__s5k6aa_power_disable(s5k6aa);
>> +	}
>> +	mutex_unlock(&s5k6aa->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct v4l2_subdev_internal_ops s5k6aa_subdev_internal_ops = {
>> +	.registered	= s5k6aa_registered,
>> +	.open		= s5k6aa_open,
>> +};
>> +
>> +static const struct v4l2_subdev_core_ops s5k6aa_core_ops = {
>> +	.s_power	= s5k6aa_set_power,
>> +	.g_ctrl		= v4l2_subdev_g_ctrl,
>> +	.s_ctrl		= v4l2_subdev_s_ctrl,
>> +	.queryctrl	= v4l2_subdev_queryctrl,
>> +	.querymenu	= v4l2_subdev_querymenu,
>> +	.g_ext_ctrls	= v4l2_subdev_g_ext_ctrls,
>> +	.try_ext_ctrls	= v4l2_subdev_try_ext_ctrls,
>> +	.s_ext_ctrls	= v4l2_subdev_s_ext_ctrls,
> 
> Don't add these control ops. They are only needed if this subdev driver is
> used by bridge drivers that are not yet converted to the control framework.
> That's not the case, so just remove these ops here.

Great! thanks for the hint. I've just added this to the list of changes for v3.

> 
>> +	.log_status	= s5k6aa_log_status,

Do we plan to support this op directly on subdev nodes ? Or should it be only
accessible through bridge drivers ?
I was just wondering if we should add VIDIOC_LOG_STATUS to subdev_do_ioctl().

>> +};
>> +
>> +static const struct v4l2_subdev_ops s5k6aa_subdev_ops = {
>> +	.core		=&s5k6aa_core_ops,
>> +	.pad		=&s5k6aa_pad_ops,
>> +	.video		=&s5k6aa_video_ops,
>> +};
>> +
>> +static int s5k6aa_initialize_ctrls(struct s5k6aa *s5k6aa)
>> +{
>> +	const struct v4l2_ctrl_ops *ops =&s5k6aa_ctrl_ops;
>> +	struct s5k6aa_ctrls *ctrls =&s5k6aa->ctrls;
>> +	struct v4l2_ctrl_handler *hdl =&ctrls->handler;
>> +
>> +	int ret = v4l2_ctrl_handler_init(hdl, 12);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ctrls->hflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
>> +	ctrls->vflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
>> +	v4l2_ctrl_cluster(2,&ctrls->hflip);
>> +
>> +	ctrls->auto_exp = v4l2_ctrl_new_std_menu(hdl, ops,
>> +				V4L2_CID_EXPOSURE_AUTO,
>> +				V4L2_EXPOSURE_MANUAL, 0, V4L2_EXPOSURE_AUTO);
>> +	/* Exposure time: x 1 us */
>> +	ctrls->exposure = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_EXPOSURE,
>> +					    0, 6000000U, 1, 100000U);
>> +	/* Total gain: 256<=>  1x */
>> +	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
>> +					0, 256, 1, 256);
>> +	v4l2_ctrl_auto_cluster(3,&ctrls->auto_exp, 0, false);
> 
> Auto-cluster support. Lovely! :-)

Yes, there is one more I work on - auto white balance / RGB gains one.
But I left this for the next step. Can't really invest much time for these
things currently.

> 
>> +	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_POWER_LINE_FREQUENCY,
>> +			       V4L2_CID_POWER_LINE_FREQUENCY_AUTO, 0,
>> +			       V4L2_CID_POWER_LINE_FREQUENCY_AUTO);
>> +
>> +	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_COLORFX,
>> +			       V4L2_COLORFX_SKY_BLUE, ~0x6f, V4L2_COLORFX_NONE);
>> +
>> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_WHITE_BALANCE_TEMPERATURE,
>> +			  0, 256, 1, 0);
>> +
>> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION, -127, 127, 1, 0);
>> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BRIGHTNESS, -127, 127, 1, 0);
>> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST, -127, 127, 1, 0);
>> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SHARPNESS, -127, 127, 1, 0);
>> +
>> +	if (hdl->error) {
>> +		ret = hdl->error;
>> +		v4l2_ctrl_handler_free(hdl);
>> +		return ret;
>> +	}
>> +
>> +	s5k6aa->sd.ctrl_handler = hdl;
>> +	return 0;
>> +}
>> +

--
Regards,
Sylwester
