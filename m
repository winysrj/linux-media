Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32452 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaCLKi7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 06:38:59 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2B00J5CK8YII00@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Mar 2014 06:38:58 -0400 (EDT)
Date: Wed, 12 Mar 2014 07:38:51 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 12/35] v4l2-ctrls: replace cur by a union
 v4l2_ctrl_ptr.
Message-id: <20140312073851.21f4e77a@samsung.com>
In-reply-to: <1392631070-41868-13-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
 <1392631070-41868-13-git-send-email-hverkuil@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 17 Feb 2014 10:57:27 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Instead of having to maintain the 'cur' union this patch replaces it by
> a v4l2_ctrl_ptr union to be consistent with the future configuration stores,
> which also use that union. The number of drivers that use 'cur' is fairly small,
> so it is easy enough to convert them all.
> 
> Unfortunately, the union for the new value cannot be dropped as easily
> since it is used pretty much everywhere.
> 
> As a consequence of these changes the v4l2_ctrl struct changes as well.
> 
> It was this:
> 
> 	union { };		 // anonymous union for the 'new' value
> 	union { } cur;		 // union for the 'cur' value
> 	union v4l2_ctrl_ptr new; // v4l2_ctrl_ptr to the new value (anonymous union)
> 	union v4l2_ctrl_ptr stores[]; // v4l2_ctrl_ptr to the cur union
> 
> where the stores array contains just one v4l2_ctrl_ptr union when it is
> allocated.
> 
> It changes to this:
> 
> 	union { };		 // anonymous union for the 'new' value
> 	union v4l2_ctrl_ptr *stores; // set to &cur
> 	union v4l2_ctrl_ptr new; // v4l2_ctrl_ptr to the new value (anonymous union)
> 	union v4l2_ctrl_ptr cur; // v4l2_ctrl_ptr for the cur value
> 
> The end result is the same: stores[0] is a pointer to the current value,
> stores[-1] is a pointer to the new value, and the 'cur' field is still
> there as well, except that the cur field is now a pointer union to the
> actual value, so cur.val is now *cur.p_s32.

Huh??? Do you want to use a negative value for the array index???

That sounds crazy. Also, I'm pretty sure that all static analyzers will 
complain about that.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/video4linux/v4l2-controls.txt   |  4 ++--
>  drivers/media/common/cx2341x.c                |  4 ++--
>  drivers/media/i2c/adp1653.c                   | 10 +++++-----
>  drivers/media/i2c/as3645a.c                   | 22 ++++++++++-----------
>  drivers/media/i2c/lm3560.c                    |  2 +-
>  drivers/media/i2c/m5mols/m5mols_controls.c    |  6 +++---
>  drivers/media/i2c/msp3400-driver.c            |  4 ++--
>  drivers/media/i2c/mt9p031.c                   |  4 ++--
>  drivers/media/i2c/mt9t001.c                   |  4 ++--
>  drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c     |  6 +++---
>  drivers/media/i2c/smiapp/smiapp-core.c        | 12 ++++++------
>  drivers/media/pci/cx18/cx18-av-core.c         |  2 +-
>  drivers/media/pci/cx18/cx18-driver.c          | 10 +++++-----
>  drivers/media/platform/exynos4-is/fimc-core.c |  6 +++---
>  drivers/media/platform/vivi.c                 | 28 +++++++++++++--------------
>  drivers/media/radio/radio-isa.c               |  2 +-
>  drivers/media/radio/radio-sf16fmr2.c          |  4 ++--
>  drivers/media/usb/gspca/conex.c               |  8 ++++----
>  drivers/media/usb/gspca/sn9c20x.c             |  4 ++--
>  drivers/media/usb/gspca/topro.c               |  4 ++--
>  drivers/media/v4l2-core/v4l2-ctrls.c          | 16 +++++++--------
>  include/media/v4l2-ctrls.h                    |  9 ++-------
>  22 files changed, 83 insertions(+), 88 deletions(-)
> 
> diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
> index 06cf3ac..1c353c2 100644
> --- a/Documentation/video4linux/v4l2-controls.txt
> +++ b/Documentation/video4linux/v4l2-controls.txt
> @@ -362,8 +362,8 @@ will result in a deadlock since these helpers lock the handler as well.
>  You can also take the handler lock yourself:
>  
>  	mutex_lock(&state->ctrl_handler.lock);
> -	printk(KERN_INFO "String value is '%s'\n", ctrl1->cur.string);
> -	printk(KERN_INFO "Integer value is '%s'\n", ctrl2->cur.val);
> +	pr_info("String value is '%s'\n", ctrl1->cur.p_char);
> +	pr_info("Integer value is '%d'\n", *ctrl2->cur.p_s32);
>  	mutex_unlock(&state->ctrl_handler.lock);
>  
>  
> diff --git a/drivers/media/common/cx2341x.c b/drivers/media/common/cx2341x.c
> index 103ef6b..909d334 100644
> --- a/drivers/media/common/cx2341x.c
> +++ b/drivers/media/common/cx2341x.c
> @@ -1261,10 +1261,10 @@ static int cx2341x_hdl_api(struct cx2341x_handler *hdl,
>  	return hdl->func(hdl->priv, cmd, args, 0, data);
>  }
>  
> -/* ctrl->handler->lock is held, so it is safe to access cur.val */
> +/* ctrl->handler->lock is held, so it is safe to access *cur.p_s32 */
>  static inline int cx2341x_neq(struct v4l2_ctrl *ctrl)
>  {
> -	return ctrl && ctrl->val != ctrl->cur.val;
> +	return ctrl && ctrl->val != *ctrl->cur.p_s32;
>  }
>  
>  static int cx2341x_try_ctrl(struct v4l2_ctrl *ctrl)
> diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
> index 873fe19..7d478dc 100644
> --- a/drivers/media/i2c/adp1653.c
> +++ b/drivers/media/i2c/adp1653.c
> @@ -158,16 +158,16 @@ static int adp1653_get_ctrl(struct v4l2_ctrl *ctrl)
>  	if (IS_ERR_VALUE(rval))
>  		return rval;
>  
> -	ctrl->cur.val = 0;
> +	*ctrl->cur.p_s32 = 0;
>  
>  	if (flash->fault & ADP1653_REG_FAULT_FLT_SCP)
> -		ctrl->cur.val |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
> +		*ctrl->cur.p_s32 |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
>  	if (flash->fault & ADP1653_REG_FAULT_FLT_OT)
> -		ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
> +		*ctrl->cur.p_s32 |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
>  	if (flash->fault & ADP1653_REG_FAULT_FLT_TMR)
> -		ctrl->cur.val |= V4L2_FLASH_FAULT_TIMEOUT;
> +		*ctrl->cur.p_s32 |= V4L2_FLASH_FAULT_TIMEOUT;
>  	if (flash->fault & ADP1653_REG_FAULT_FLT_OV)
> -		ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
> +		*ctrl->cur.p_s32 |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
>  
>  	flash->fault = 0;
>  
> diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
> index 301084b..4c6041c 100644
> --- a/drivers/media/i2c/as3645a.c
> +++ b/drivers/media/i2c/as3645a.c
> @@ -334,24 +334,24 @@ static int as3645a_get_ctrl(struct v4l2_ctrl *ctrl)
>  		if (value < 0)
>  			return value;
>  
> -		ctrl->cur.val = 0;
> +		*ctrl->cur.p_s32 = 0;
>  		if (value & AS_FAULT_INFO_SHORT_CIRCUIT)
> -			ctrl->cur.val |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
> +			*ctrl->cur.p_s32 |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
>  		if (value & AS_FAULT_INFO_OVER_TEMPERATURE)
> -			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
> +			*ctrl->cur.p_s32 |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
>  		if (value & AS_FAULT_INFO_TIMEOUT)
> -			ctrl->cur.val |= V4L2_FLASH_FAULT_TIMEOUT;
> +			*ctrl->cur.p_s32 |= V4L2_FLASH_FAULT_TIMEOUT;
>  		if (value & AS_FAULT_INFO_OVER_VOLTAGE)
> -			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
> +			*ctrl->cur.p_s32 |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
>  		if (value & AS_FAULT_INFO_INDUCTOR_PEAK_LIMIT)
> -			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_CURRENT;
> +			*ctrl->cur.p_s32 |= V4L2_FLASH_FAULT_OVER_CURRENT;
>  		if (value & AS_FAULT_INFO_INDICATOR_LED)
> -			ctrl->cur.val |= V4L2_FLASH_FAULT_INDICATOR;
> +			*ctrl->cur.p_s32 |= V4L2_FLASH_FAULT_INDICATOR;
>  		break;
>  
>  	case V4L2_CID_FLASH_STROBE_STATUS:
>  		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH) {
> -			ctrl->cur.val = 0;
> +			*ctrl->cur.p_s32 = 0;
>  			break;
>  		}
>  
> @@ -359,11 +359,11 @@ static int as3645a_get_ctrl(struct v4l2_ctrl *ctrl)
>  		if (value < 0)
>  			return value;
>  
> -		ctrl->cur.val = value;
> +		*ctrl->cur.p_s32 = value;
>  		break;
>  	}
>  
> -	dev_dbg(&client->dev, "G_CTRL %08x:%d\n", ctrl->id, ctrl->cur.val);
> +	dev_dbg(&client->dev, "G_CTRL %08x:%d\n", ctrl->id, *ctrl->cur.p_s32);
>  
>  	return 0;
>  }
> @@ -458,7 +458,7 @@ static int as3645a_set_ctrl(struct v4l2_ctrl *ctrl)
>  		if (ret < 0)
>  			return ret;
>  
> -		if ((ctrl->val == 0) == (ctrl->cur.val == 0))
> +		if ((ctrl->val == 0) == (*ctrl->cur.p_s32 == 0))
>  			break;
>  
>  		return as3645a_set_output(flash, false);
> diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
> index d98ca3a..edfe746 100644
> --- a/drivers/media/i2c/lm3560.c
> +++ b/drivers/media/i2c/lm3560.c
> @@ -188,7 +188,7 @@ static int lm3560_get_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
>  			fault |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
>  		if (reg_val & FAULT_TIMEOUT)
>  			fault |= V4L2_FLASH_FAULT_TIMEOUT;
> -		ctrl->cur.val = fault;
> +		*ctrl->cur.p_s32 = fault;
>  	}
>  
>  out:
> diff --git a/drivers/media/i2c/m5mols/m5mols_controls.c b/drivers/media/i2c/m5mols/m5mols_controls.c
> index a60931e..7851d1f 100644
> --- a/drivers/media/i2c/m5mols/m5mols_controls.c
> +++ b/drivers/media/i2c/m5mols/m5mols_controls.c
> @@ -191,7 +191,7 @@ static int m5mols_3a_lock(struct m5mols_info *info, struct v4l2_ctrl *ctrl)
>  	bool af_lock = ctrl->val & V4L2_LOCK_FOCUS;
>  	int ret = 0;
>  
> -	if ((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_EXPOSURE) {
> +	if ((ctrl->val ^ *ctrl->cur.p_s32) & V4L2_LOCK_EXPOSURE) {
>  		bool ae_lock = ctrl->val & V4L2_LOCK_EXPOSURE;
>  
>  		ret = m5mols_write(&info->sd, AE_LOCK, ae_lock ?
> @@ -200,7 +200,7 @@ static int m5mols_3a_lock(struct m5mols_info *info, struct v4l2_ctrl *ctrl)
>  			return ret;
>  	}
>  
> -	if (((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_WHITE_BALANCE)
> +	if (((ctrl->val ^ *ctrl->cur.p_s32) & V4L2_LOCK_WHITE_BALANCE)
>  	    && info->auto_wb->val) {
>  		bool awb_lock = ctrl->val & V4L2_LOCK_WHITE_BALANCE;
>  
> @@ -213,7 +213,7 @@ static int m5mols_3a_lock(struct m5mols_info *info, struct v4l2_ctrl *ctrl)
>  	if (!info->ver.af || !af_lock)
>  		return ret;
>  
> -	if ((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_FOCUS)
> +	if ((ctrl->val ^ *ctrl->cur.p_s32) & V4L2_LOCK_FOCUS)
>  		ret = m5mols_write(&info->sd, AF_EXECUTE, REG_AF_STOP);
>  
>  	return ret;
> diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
> index 8190fec..151016d 100644
> --- a/drivers/media/i2c/msp3400-driver.c
> +++ b/drivers/media/i2c/msp3400-driver.c
> @@ -411,8 +411,8 @@ void msp_update_volume(struct msp_state *state)
>  {
>  	/* Force an update of the volume/mute cluster */
>  	v4l2_ctrl_lock(state->volume);
> -	state->volume->val = state->volume->cur.val;
> -	state->muted->val = state->muted->cur.val;
> +	state->volume->val = *state->volume->cur.p_s32;
> +	state->muted->val = *state->muted->cur.p_s32;
>  	msp_s_ctrl(state->volume);
>  	v4l2_ctrl_unlock(state->volume);
>  }
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index e5ddf47..28c17e0 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -670,12 +670,12 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_TEST_PATTERN:
>  		if (!ctrl->val) {
>  			/* Restore the black level compensation settings. */
> -			if (mt9p031->blc_auto->cur.val != 0) {
> +			if (*mt9p031->blc_auto->cur.p_s32 != 0) {
>  				ret = mt9p031_s_ctrl(mt9p031->blc_auto);
>  				if (ret < 0)
>  					return ret;
>  			}
> -			if (mt9p031->blc_offset->cur.val != 0) {
> +			if (*mt9p031->blc_offset->cur.p_s32 != 0) {
>  				ret = mt9p031_s_ctrl(mt9p031->blc_offset);
>  				if (ret < 0)
>  					return ret;
> diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
> index d41c70e..6aca05b 100644
> --- a/drivers/media/i2c/mt9t001.c
> +++ b/drivers/media/i2c/mt9t001.c
> @@ -447,7 +447,7 @@ static int mt9t001_s_ctrl(struct v4l2_ctrl *ctrl)
>  		for (i = 0, count = 0; i < 4; ++i) {
>  			struct v4l2_ctrl *gain = mt9t001->gains[i];
>  
> -			if (gain->val != gain->cur.val)
> +			if (gain->val != *gain->cur.p_s32)
>  				count++;
>  		}
>  
> @@ -461,7 +461,7 @@ static int mt9t001_s_ctrl(struct v4l2_ctrl *ctrl)
>  		for (i = 0; i < 4; ++i) {
>  			struct v4l2_ctrl *gain = mt9t001->gains[i];
>  
> -			if (gain->val == gain->cur.val)
> +			if (gain->val == *gain->cur.p_s32)
>  				continue;
>  
>  			value = mt9t001_gain_value(&gain->val);
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c b/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
> index 8001cde..cb6da84 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
> @@ -195,14 +195,14 @@ static int s5c73m3_3a_lock(struct s5c73m3 *state, struct v4l2_ctrl *ctrl)
>  	bool af_lock = ctrl->val & V4L2_LOCK_FOCUS;
>  	int ret = 0;
>  
> -	if ((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_EXPOSURE) {
> +	if ((ctrl->val ^ *ctrl->cur.p_s32) & V4L2_LOCK_EXPOSURE) {
>  		ret = s5c73m3_isp_command(state, COMM_AE_CON,
>  				ae_lock ? COMM_AE_STOP : COMM_AE_START);
>  		if (ret)
>  			return ret;
>  	}
>  
> -	if (((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_WHITE_BALANCE)
> +	if (((ctrl->val ^ *ctrl->cur.p_s32) & V4L2_LOCK_WHITE_BALANCE)
>  	    && state->ctrls.auto_wb->val) {
>  		ret = s5c73m3_isp_command(state, COMM_AWB_CON,
>  			awb_lock ? COMM_AWB_STOP : COMM_AWB_START);
> @@ -210,7 +210,7 @@ static int s5c73m3_3a_lock(struct s5c73m3 *state, struct v4l2_ctrl *ctrl)
>  			return ret;
>  	}
>  
> -	if ((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_FOCUS)
> +	if ((ctrl->val ^ *ctrl->cur.p_s32) & V4L2_LOCK_FOCUS)
>  		ret = s5c73m3_af_run(state, ~af_lock);
>  
>  	return ret;
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 8741cae..d87c5e8 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -297,8 +297,8 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
>  	if (rval < 0)
>  		return rval;
>  
> -	sensor->pixel_rate_parray->cur.val64 = pll->vt_pix_clk_freq_hz;
> -	sensor->pixel_rate_csi->cur.val64 = pll->pixel_rate_csi;
> +	*sensor->pixel_rate_parray->cur.p_s64 = pll->vt_pix_clk_freq_hz;
> +	*sensor->pixel_rate_csi->cur.p_s64 = pll->pixel_rate_csi;
>  
>  	return 0;
>  }
> @@ -324,8 +324,8 @@ static void __smiapp_update_exposure_limits(struct smiapp_sensor *sensor)
>  		ctrl->default_value = max;
>  	if (ctrl->val > max)
>  		ctrl->val = max;
> -	if (ctrl->cur.val > max)
> -		ctrl->cur.val = max;
> +	if (*ctrl->cur.p_s32 > max)
> +		*ctrl->cur.p_s32 = max;
>  }
>  
>  /*
> @@ -796,7 +796,7 @@ static void smiapp_update_blanking(struct smiapp_sensor *sensor)
>  			      vblank->minimum, vblank->maximum);
>  	vblank->default_value = vblank->minimum;
>  	vblank->val = vblank->val;
> -	vblank->cur.val = vblank->val;
> +	*vblank->cur.p_s32 = vblank->val;
>  
>  	hblank->minimum =
>  		max_t(int,
> @@ -811,7 +811,7 @@ static void smiapp_update_blanking(struct smiapp_sensor *sensor)
>  			      hblank->minimum, hblank->maximum);
>  	hblank->default_value = hblank->minimum;
>  	hblank->val = hblank->val;
> -	hblank->cur.val = hblank->val;
> +	*hblank->cur.p_s32 = hblank->val;
>  
>  	__smiapp_update_exposure_limits(sensor);
>  }
> diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
> index c4890a4..d230a9b 100644
> --- a/drivers/media/pci/cx18/cx18-av-core.c
> +++ b/drivers/media/pci/cx18/cx18-av-core.c
> @@ -262,7 +262,7 @@ static void cx18_av_initialize(struct v4l2_subdev *sd)
>  		cx18_av_write(cx, 0x8d4, 20);
>  	}
>  	default_volume = (((228 - default_volume) >> 1) + 23) << 9;
> -	state->volume->cur.val = state->volume->default_value = default_volume;
> +	*state->volume->cur.p_s32 = state->volume->default_value = default_volume;
>  	v4l2_ctrl_handler_setup(&state->hdl);
>  }
>  
> diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
> index 716bdc5..e4d0740 100644
> --- a/drivers/media/pci/cx18/cx18-driver.c
> +++ b/drivers/media/pci/cx18/cx18-driver.c
> @@ -756,11 +756,11 @@ static int cx18_init_struct1(struct cx18 *cx)
>  		return ret;
>  	cx->v4l2_dev.ctrl_handler = &cx->cxhdl.hdl;
>  
> -	cx->temporal_strength = cx->cxhdl.video_temporal_filter->cur.val;
> -	cx->spatial_strength = cx->cxhdl.video_spatial_filter->cur.val;
> -	cx->filter_mode = cx->cxhdl.video_spatial_filter_mode->cur.val |
> -		(cx->cxhdl.video_temporal_filter_mode->cur.val << 1) |
> -		(cx->cxhdl.video_median_filter_type->cur.val << 2);
> +	cx->temporal_strength = *cx->cxhdl.video_temporal_filter->cur.p_s32;
> +	cx->spatial_strength = *cx->cxhdl.video_spatial_filter->cur.p_s32;
> +	cx->filter_mode = *cx->cxhdl.video_spatial_filter_mode->cur.p_s32 |
> +		(*cx->cxhdl.video_temporal_filter_mode->cur.p_s32 << 1) |
> +		(*cx->cxhdl.video_median_filter_type->cur.p_s32 << 2);
>  
>  	init_waitqueue_head(&cx->cap_w);
>  	init_waitqueue_head(&cx->mb_apu_waitq);
> diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
> index a7dfd07..d399699 100644
> --- a/drivers/media/platform/exynos4-is/fimc-core.c
> +++ b/drivers/media/platform/exynos4-is/fimc-core.c
> @@ -664,7 +664,7 @@ void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active)
>  		v4l2_ctrl_activate(ctrls->alpha, active && has_alpha);
>  
>  	if (active) {
> -		fimc_set_color_effect(ctx, ctrls->colorfx->cur.val);
> +		fimc_set_color_effect(ctx, *ctrls->colorfx->cur.p_s32);
>  		ctx->rotation = ctrls->rotate->val;
>  		ctx->hflip    = ctrls->hflip->val;
>  		ctx->vflip    = ctrls->vflip->val;
> @@ -689,8 +689,8 @@ void fimc_alpha_ctrl_update(struct fimc_ctx *ctx)
>  	v4l2_ctrl_lock(ctrl);
>  	ctrl->maximum = fimc_get_alpha_mask(ctx->d_frame.fmt);
>  
> -	if (ctrl->cur.val > ctrl->maximum)
> -		ctrl->cur.val = ctrl->maximum;
> +	if (*ctrl->cur.p_s32 > ctrl->maximum)
> +		*ctrl->cur.p_s32 = ctrl->maximum;
>  
>  	v4l2_ctrl_unlock(ctrl);
>  }
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index 3c92ce3..7b9e887 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -642,28 +642,28 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
>  	gain = v4l2_ctrl_g_ctrl(dev->gain);
>  	mutex_lock(dev->ctrl_handler.lock);
>  	snprintf(str, sizeof(str), " brightness %3d, contrast %3d, saturation %3d, hue %d ",
> -			dev->brightness->cur.val,
> -			dev->contrast->cur.val,
> -			dev->saturation->cur.val,
> -			dev->hue->cur.val);
> +			*dev->brightness->cur.p_s32,
> +			*dev->contrast->cur.p_s32,
> +			*dev->saturation->cur.p_s32,
> +			*dev->hue->cur.p_s32);
>  	gen_text(dev, vbuf, line++ * 16, 16, str);
>  	snprintf(str, sizeof(str), " autogain %d, gain %3d, volume %3d, alpha 0x%02x ",
> -			dev->autogain->cur.val, gain, dev->volume->cur.val,
> -			dev->alpha->cur.val);
> +			*dev->autogain->cur.p_s32, gain, *dev->volume->cur.p_s32,
> +			*dev->alpha->cur.p_s32);
>  	gen_text(dev, vbuf, line++ * 16, 16, str);
>  	snprintf(str, sizeof(str), " int32 %d, int64 %lld, bitmask %08x ",
> -			dev->int32->cur.val,
> -			dev->int64->cur.val64,
> -			dev->bitmask->cur.val);
> +			*dev->int32->cur.p_s32,
> +			*dev->int64->cur.p_s64,
> +			*dev->bitmask->cur.p_s32);
>  	gen_text(dev, vbuf, line++ * 16, 16, str);
>  	snprintf(str, sizeof(str), " boolean %d, menu %s, string \"%s\" ",
> -			dev->boolean->cur.val,
> -			dev->menu->qmenu[dev->menu->cur.val],
> -			dev->string->cur.string);
> +			*dev->boolean->cur.p_s32,
> +			dev->menu->qmenu[*dev->menu->cur.p_s32],
> +			dev->string->cur.p_char);
>  	gen_text(dev, vbuf, line++ * 16, 16, str);
>  	snprintf(str, sizeof(str), " integer_menu %lld, value %d ",
> -			dev->int_menu->qmenu_int[dev->int_menu->cur.val],
> -			dev->int_menu->cur.val);
> +			dev->int_menu->qmenu_int[*dev->int_menu->cur.p_s32],
> +			*dev->int_menu->cur.p_s32);
>  	gen_text(dev, vbuf, line++ * 16, 16, str);
>  	mutex_unlock(dev->ctrl_handler.lock);
>  	if (dev->button_pressed) {
> diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
> index 6ff3508..46d188d 100644
> --- a/drivers/media/radio/radio-isa.c
> +++ b/drivers/media/radio/radio-isa.c
> @@ -294,7 +294,7 @@ static int radio_isa_common_remove(struct radio_isa_card *isa,
>  {
>  	const struct radio_isa_ops *ops = isa->drv->ops;
>  
> -	ops->s_mute_volume(isa, true, isa->volume ? isa->volume->cur.val : 0);
> +	ops->s_mute_volume(isa, true, isa->volume ? *isa->volume->cur.p_s32 : 0);
>  	video_unregister_device(&isa->vdev);
>  	v4l2_ctrl_handler_free(&isa->hdl);
>  	v4l2_device_unregister(&isa->v4l2_dev);
> diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
> index 93d864e..e393130 100644
> --- a/drivers/media/radio/radio-sf16fmr2.c
> +++ b/drivers/media/radio/radio-sf16fmr2.c
> @@ -154,11 +154,11 @@ static int fmr2_s_ctrl(struct v4l2_ctrl *ctrl)
>  	switch (ctrl->id) {
>  	case V4L2_CID_AUDIO_VOLUME:
>  		volume = ctrl->val;
> -		balance = fmr2->balance->cur.val;
> +		balance = *fmr2->balance->cur.p_s32;
>  		break;
>  	case V4L2_CID_AUDIO_BALANCE:
>  		balance = ctrl->val;
> -		volume = fmr2->volume->cur.val;
> +		volume = *fmr2->volume->cur.p_s32;
>  		break;
>  	default:
>  		return -EINVAL;
> diff --git a/drivers/media/usb/gspca/conex.c b/drivers/media/usb/gspca/conex.c
> index 2e15c80..e8cfaf3 100644
> --- a/drivers/media/usb/gspca/conex.c
> +++ b/drivers/media/usb/gspca/conex.c
> @@ -887,14 +887,14 @@ static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
>  
>  	switch (ctrl->id) {
>  	case V4L2_CID_BRIGHTNESS:
> -		setbrightness(gspca_dev, ctrl->val, sd->sat->cur.val);
> +		setbrightness(gspca_dev, ctrl->val, *sd->sat->cur.p_s32);
>  		break;
>  	case V4L2_CID_CONTRAST:
> -		setcontrast(gspca_dev, ctrl->val, sd->sat->cur.val);
> +		setcontrast(gspca_dev, ctrl->val, *sd->sat->cur.p_s32);
>  		break;
>  	case V4L2_CID_SATURATION:
> -		setbrightness(gspca_dev, sd->brightness->cur.val, ctrl->val);
> -		setcontrast(gspca_dev, sd->contrast->cur.val, ctrl->val);
> +		setbrightness(gspca_dev, *sd->brightness->cur.p_s32, ctrl->val);
> +		setcontrast(gspca_dev, *sd->contrast->cur.p_s32, ctrl->val);
>  		break;
>  	}
>  	return gspca_dev->usb_err;
> diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
> index 2a38621..22d93c3 100644
> --- a/drivers/media/usb/gspca/sn9c20x.c
> +++ b/drivers/media/usb/gspca/sn9c20x.c
> @@ -2218,7 +2218,7 @@ static void transfer_check(struct gspca_dev *gspca_dev,
>  			/* Note: we are in interrupt context, so we can't
>  			   use v4l2_ctrl_g/s_ctrl here. Access the value
>  			   directly instead. */
> -			s32 curqual = sd->jpegqual->cur.val;
> +			s32 curqual = *sd->jpegqual->cur.p_s32;
>  			sd->nchg = 0;
>  			new_qual += curqual;
>  			if (new_qual < sd->jpegqual->minimum)
> @@ -2226,7 +2226,7 @@ static void transfer_check(struct gspca_dev *gspca_dev,
>  			else if (new_qual > sd->jpegqual->maximum)
>  				new_qual = sd->jpegqual->maximum;
>  			if (new_qual != curqual) {
> -				sd->jpegqual->cur.val = new_qual;
> +				*sd->jpegqual->cur.p_s32 = new_qual;
>  				queue_work(sd->work_thread, &sd->work);
>  			}
>  		}
> diff --git a/drivers/media/usb/gspca/topro.c b/drivers/media/usb/gspca/topro.c
> index 640c2fe..4abe03b 100644
> --- a/drivers/media/usb/gspca/topro.c
> +++ b/drivers/media/usb/gspca/topro.c
> @@ -3976,8 +3976,8 @@ static int sd_setgain(struct gspca_dev *gspca_dev)
>  	s32 val = gspca_dev->gain->val;
>  
>  	if (sd->sensor == SENSOR_CX0342) {
> -		s32 old = gspca_dev->gain->cur.val ?
> -					gspca_dev->gain->cur.val : 1;
> +		s32 old = *gspca_dev->gain->cur.p_s32 ?
> +					*gspca_dev->gain->cur.p_s32 : 1;
>  
>  		sd->blue->val = sd->blue->val * val / old;
>  		if (sd->blue->val > 4095)
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index a136cdc..084335a 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -47,7 +47,7 @@ struct v4l2_ctrl_helper {
>     mode. */
>  static bool is_cur_manual(const struct v4l2_ctrl *master)
>  {
> -	return master->is_auto && master->cur.val == master->manual_mode_value;
> +	return master->is_auto && *master->cur.p_s32 == master->manual_mode_value;
>  }
>  
>  /* Same as above, but this checks the against the new value instead of the
> @@ -1106,7 +1106,7 @@ static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 change
>  	if (ctrl->is_ptr)
>  		ev->u.ctrl.value64 = 0;
>  	else
> -		ev->u.ctrl.value64 = ctrl->cur.val64;
> +		ev->u.ctrl.value64 = *ctrl->cur.p_s64;
>  	ev->u.ctrl.minimum = ctrl->minimum;
>  	ev->u.ctrl.maximum = ctrl->maximum;
>  	if (ctrl->type == V4L2_CTRL_TYPE_MENU
> @@ -1777,13 +1777,13 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  		return NULL;
>  	}
>  
> -	sz_extra = sizeof(union v4l2_ctrl_ptr);
> +	sz_extra = elem_size;
>  	if (type == V4L2_CTRL_TYPE_BUTTON)
>  		flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
>  	else if (type == V4L2_CTRL_TYPE_CTRL_CLASS)
>  		flags |= V4L2_CTRL_FLAG_READ_ONLY;
>  	else if (type == V4L2_CTRL_TYPE_STRING || type >= V4L2_CTRL_COMPLEX_TYPES)
> -		sz_extra += 2 * elem_size;
> +		sz_extra += elem_size;
>  
>  	ctrl = kzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
>  	if (ctrl == NULL) {
> @@ -1816,7 +1816,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  	else if (type == V4L2_CTRL_TYPE_INTEGER_MENU)
>  		ctrl->qmenu_int = qmenu_int;
>  	ctrl->priv = priv;
> -	ctrl->cur.val = ctrl->val = def;
> +	ctrl->stores = &ctrl->cur;
>  	data = &ctrl->stores[1];
>  
>  	if (ctrl->is_ptr) {
> @@ -1824,7 +1824,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  		ctrl->stores[0].p = data + elem_size;
>  	} else {
>  		ctrl->new.p = &ctrl->val;
> -		ctrl->stores[0].p = &ctrl->cur.val;
> +		ctrl->stores[0].p = data;
>  	}
>  	for (s = -1; s <= 0; s++)
>  		ctrl->type_ops->init(ctrl, ctrl->stores[s]);
> @@ -3090,10 +3090,10 @@ int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
>  	ctrl->maximum = max;
>  	ctrl->step = step;
>  	ctrl->default_value = def;
> -	c.value = ctrl->cur.val;
> +	c.value = *ctrl->cur.p_s32;
>  	if (validate_new(ctrl, &c))
>  		c.value = def;
> -	if (c.value != ctrl->cur.val)
> +	if (c.value != *ctrl->cur.p_s32)
>  		ret = set_ctrl(NULL, ctrl, &c, V4L2_EVENT_CTRL_CH_RANGE);
>  	else
>  		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 9eeb9d9..4f66393 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -198,14 +198,9 @@ struct v4l2_ctrl {
>  		char *string;
>  		void *p;
>  	};
> -	union {
> -		s32 val;
> -		s64 val64;
> -		char *string;
> -		void *p;
> -	} cur;
> +	union v4l2_ctrl_ptr *stores;
>  	union v4l2_ctrl_ptr new;
> -	union v4l2_ctrl_ptr stores[];
> +	union v4l2_ctrl_ptr cur;
>  };
>  
>  /** struct v4l2_ctrl_ref - The control reference.


-- 

Regards,
Mauro
