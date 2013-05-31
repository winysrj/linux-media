Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41655 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3EaKiW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:38:22 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNN006M8S7TNF90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 11:38:20 +0100 (BST)
Message-id: <51A87D9A.3010104@samsung.com>
Date: Fri, 31 May 2013 12:38:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 02/21] sr030pc30: convert to the control framework.
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
 <1369994561-25236-3-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1369994561-25236-3-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/2013 12:02 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  drivers/media/i2c/sr030pc30.c |  276 +++++++++++++----------------------------
>  1 file changed, 88 insertions(+), 188 deletions(-)
> 
> diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
> index 4c5a9ee..ae94326 100644
> --- a/drivers/media/i2c/sr030pc30.c
> +++ b/drivers/media/i2c/sr030pc30.c
> @@ -23,6 +23,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-subdev.h>
>  #include <media/v4l2-mediabus.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/sr030pc30.h>
>  
>  static int debug;
> @@ -142,17 +143,24 @@ module_param(debug, int, 0644);
>  
>  struct sr030pc30_info {
>  	struct v4l2_subdev sd;
> +	struct v4l2_ctrl_handler hdl;
>  	const struct sr030pc30_platform_data *pdata;
>  	const struct sr030pc30_format *curr_fmt;
>  	const struct sr030pc30_frmsize *curr_win;
> -	unsigned int auto_wb:1;
> -	unsigned int auto_exp:1;
>  	unsigned int hflip:1;
>  	unsigned int vflip:1;
>  	unsigned int sleep:1;
> -	unsigned int exposure;
> -	u8 blue_balance;
> -	u8 red_balance;
> +	struct {
> +		/* auto whitebalance control cluster */
> +		struct v4l2_ctrl *awb;
> +		struct v4l2_ctrl *red;
> +		struct v4l2_ctrl *blue;
> +	};
> +	struct {
> +		/* auto exposure control cluster */
> +		struct v4l2_ctrl *autoexp;
> +		struct v4l2_ctrl *exp;
> +	};
>  	u8 i2c_reg_page;
>  };
>  
> @@ -173,52 +181,6 @@ struct i2c_regval {
>  	u16 val;
>  };
>  
> -static const struct v4l2_queryctrl sr030pc30_ctrl[] = {
> -	{
> -		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "Auto White Balance",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 1,
> -	}, {
> -		.id		= V4L2_CID_RED_BALANCE,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Red Balance",
> -		.minimum	= 0,
> -		.maximum	= 127,
> -		.step		= 1,
> -		.default_value	= 64,
> -		.flags		= 0,
> -	}, {
> -		.id		= V4L2_CID_BLUE_BALANCE,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Blue Balance",
> -		.minimum	= 0,
> -		.maximum	= 127,
> -		.step		= 1,
> -		.default_value	= 64,
> -	}, {
> -		.id		= V4L2_CID_EXPOSURE_AUTO,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Auto Exposure",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 1,
> -	}, {
> -		.id		= V4L2_CID_EXPOSURE,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Exposure",
> -		.minimum	= EXPOS_MIN_MS,
> -		.maximum	= EXPOS_MAX_MS,
> -		.step		= 1,
> -		.default_value	= 1,
> -	}, {
> -	}
> -};
> -
>  /* supported resolutions */
>  static const struct sr030pc30_frmsize sr030pc30_sizes[] = {
>  	{
> @@ -394,48 +356,6 @@ static int sr030pc30_pwr_ctrl(struct v4l2_subdev *sd,
>  	return ret;
>  }
>  
> -static inline int sr030pc30_enable_autoexposure(struct v4l2_subdev *sd, int on)
> -{
> -	struct sr030pc30_info *info = to_sr030pc30(sd);
> -	/* auto anti-flicker is also enabled here */
> -	int ret = cam_i2c_write(sd, AE_CTL1_REG, on ? 0xDC : 0x0C);
> -	if (!ret)
> -		info->auto_exp = on;
> -	return ret;
> -}
> -
> -static int sr030pc30_set_exposure(struct v4l2_subdev *sd, int value)
> -{
> -	struct sr030pc30_info *info = to_sr030pc30(sd);
> -
> -	unsigned long expos = value * info->pdata->clk_rate / (8 * 1000);
> -
> -	int ret = cam_i2c_write(sd, EXP_TIMEH_REG, expos >> 16 & 0xFF);
> -	if (!ret)
> -		ret = cam_i2c_write(sd, EXP_TIMEM_REG, expos >> 8 & 0xFF);
> -	if (!ret)
> -		ret = cam_i2c_write(sd, EXP_TIMEL_REG, expos & 0xFF);
> -	if (!ret) { /* Turn off AE */
> -		info->exposure = value;
> -		ret = sr030pc30_enable_autoexposure(sd, 0);
> -	}
> -	return ret;
> -}
> -
> -/* Automatic white balance control */
> -static int sr030pc30_enable_autowhitebalance(struct v4l2_subdev *sd, int on)
> -{
> -	struct sr030pc30_info *info = to_sr030pc30(sd);
> -
> -	int ret = cam_i2c_write(sd, AWB_CTL2_REG, on ? 0x2E : 0x2F);
> -	if (!ret)
> -		ret = cam_i2c_write(sd, AWB_CTL1_REG, on ? 0xFB : 0x7B);
> -	if (!ret)
> -		info->auto_wb = on;
> -
> -	return ret;
> -}
> -
>  static int sr030pc30_set_flip(struct v4l2_subdev *sd)
>  {
>  	struct sr030pc30_info *info = to_sr030pc30(sd);
> @@ -498,107 +418,56 @@ static int sr030pc30_try_frame_size(struct v4l2_mbus_framefmt *mf)
>  	return -EINVAL;
>  }
>  
> -static int sr030pc30_queryctrl(struct v4l2_subdev *sd,
> -			       struct v4l2_queryctrl *qc)
> -{
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(sr030pc30_ctrl); i++)
> -		if (qc->id == sr030pc30_ctrl[i].id) {
> -			*qc = sr030pc30_ctrl[i];
> -			v4l2_dbg(1, debug, sd, "%s id: %d\n",
> -				 __func__, qc->id);
> -			return 0;
> -		}
> -
> -	return -EINVAL;
> -}
> -
> -static inline int sr030pc30_set_bluebalance(struct v4l2_subdev *sd, int value)
> -{
> -	int ret = cam_i2c_write(sd, MWB_BGAIN_REG, value);
> -	if (!ret)
> -		to_sr030pc30(sd)->blue_balance = value;
> -	return ret;
> -}
> -
> -static inline int sr030pc30_set_redbalance(struct v4l2_subdev *sd, int value)
> -{
> -	int ret = cam_i2c_write(sd, MWB_RGAIN_REG, value);
> -	if (!ret)
> -		to_sr030pc30(sd)->red_balance = value;
> -	return ret;
> -}
> -
> -static int sr030pc30_s_ctrl(struct v4l2_subdev *sd,
> -			    struct v4l2_control *ctrl)
> +static int sr030pc30_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> -	int i, ret = 0;
> -
> -	for (i = 0; i < ARRAY_SIZE(sr030pc30_ctrl); i++)
> -		if (ctrl->id == sr030pc30_ctrl[i].id)
> -			break;
> -
> -	if (i == ARRAY_SIZE(sr030pc30_ctrl))
> -		return -EINVAL;
> -
> -	if (ctrl->value < sr030pc30_ctrl[i].minimum ||
> -		ctrl->value > sr030pc30_ctrl[i].maximum)
> -			return -ERANGE;
> +	struct sr030pc30_info *info =
> +		container_of(ctrl->handler, struct sr030pc30_info, hdl);
> +	struct v4l2_subdev *sd = &info->sd;
> +	int ret = 0;
>  
>  	v4l2_dbg(1, debug, sd, "%s: ctrl_id: %d, value: %d\n",
> -			 __func__, ctrl->id, ctrl->value);
> +			 __func__, ctrl->id, ctrl->val);
>  
>  	switch (ctrl->id) {
>  	case V4L2_CID_AUTO_WHITE_BALANCE:
> -		sr030pc30_enable_autowhitebalance(sd, ctrl->value);
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		ret = sr030pc30_set_bluebalance(sd, ctrl->value);
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		ret = sr030pc30_set_redbalance(sd, ctrl->value);
> -		break;
> -	case V4L2_CID_EXPOSURE_AUTO:
> -		sr030pc30_enable_autoexposure(sd,
> -			ctrl->value == V4L2_EXPOSURE_AUTO);
> -		break;
> -	case V4L2_CID_EXPOSURE:
> -		ret = sr030pc30_set_exposure(sd, ctrl->value);
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return ret;
> -}
> -
> -static int sr030pc30_g_ctrl(struct v4l2_subdev *sd,
> -			    struct v4l2_control *ctrl)
> -{
> -	struct sr030pc30_info *info = to_sr030pc30(sd);
> -
> -	v4l2_dbg(1, debug, sd, "%s: id: %d\n", __func__, ctrl->id);
> +		if (ctrl->is_new) {
> +			ret = cam_i2c_write(sd, AWB_CTL2_REG,
> +					ctrl->val ? 0x2E : 0x2F);
> +			if (!ret)
> +				ret = cam_i2c_write(sd, AWB_CTL1_REG,
> +						ctrl->val ? 0xFB : 0x7B);
> +		}
> +		if (!ret && info->blue->is_new)
> +			ret = cam_i2c_write(sd, MWB_BGAIN_REG, info->blue->val);
> +		if (!ret && info->red->is_new)
> +			ret = cam_i2c_write(sd, MWB_RGAIN_REG, info->red->val);
> +		return ret;
>  
> -	switch (ctrl->id) {
> -	case V4L2_CID_AUTO_WHITE_BALANCE:
> -		ctrl->value = info->auto_wb;
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		ctrl->value = info->blue_balance;
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		ctrl->value = info->red_balance;
> -		break;
>  	case V4L2_CID_EXPOSURE_AUTO:
> -		ctrl->value = info->auto_exp;
> -		break;
> -	case V4L2_CID_EXPOSURE:
> -		ctrl->value = info->exposure;
> -		break;
> +		/* auto anti-flicker is also enabled here */
> +		if (ctrl->is_new)
> +			ret = cam_i2c_write(sd, AE_CTL1_REG,
> +				ctrl->val == V4L2_EXPOSURE_AUTO ? 0xDC : 0x0C);
> +		if (info->exp->is_new) {
> +			unsigned long expos = info->exp->val;
> +
> +			expos = expos * info->pdata->clk_rate / (8 * 1000);
> +
> +			if (!ret)
> +				ret = cam_i2c_write(sd, EXP_TIMEH_REG,
> +						expos >> 16 & 0xFF);
> +			if (!ret)
> +				ret = cam_i2c_write(sd, EXP_TIMEM_REG,
> +						expos >> 8 & 0xFF);
> +			if (!ret)
> +				ret = cam_i2c_write(sd, EXP_TIMEL_REG,
> +						expos & 0xFF);
> +		}
> +		return ret;
>  	default:
>  		return -EINVAL;
>  	}
> +
>  	return 0;
>  }
>  
> @@ -752,11 +621,19 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
>  	return ret;
>  }
>  
> +static const struct v4l2_ctrl_ops sr030pc30_ctrl_ops = {
> +	.s_ctrl = sr030pc30_s_ctrl,
> +};
> +
>  static const struct v4l2_subdev_core_ops sr030pc30_core_ops = {
>  	.s_power	= sr030pc30_s_power,
> -	.queryctrl	= sr030pc30_queryctrl,
> -	.s_ctrl		= sr030pc30_s_ctrl,
> -	.g_ctrl		= sr030pc30_g_ctrl,
> +	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
> +	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
> +	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
> +	.g_ctrl = v4l2_subdev_g_ctrl,
> +	.s_ctrl = v4l2_subdev_s_ctrl,
> +	.queryctrl = v4l2_subdev_queryctrl,
> +	.querymenu = v4l2_subdev_querymenu,
>  };
>  
>  static const struct v4l2_subdev_video_ops sr030pc30_video_ops = {
> @@ -807,6 +684,7 @@ static int sr030pc30_probe(struct i2c_client *client,
>  {
>  	struct sr030pc30_info *info;
>  	struct v4l2_subdev *sd;
> +	struct v4l2_ctrl_handler *hdl;
>  	const struct sr030pc30_platform_data *pdata
>  		= client->dev.platform_data;
>  	int ret;
> @@ -830,10 +708,31 @@ static int sr030pc30_probe(struct i2c_client *client,
>  
>  	v4l2_i2c_subdev_init(sd, client, &sr030pc30_ops);
>  
> +	hdl = &info->hdl;
> +	v4l2_ctrl_handler_init(hdl, 6);
> +	info->awb = v4l2_ctrl_new_std(hdl, &sr030pc30_ctrl_ops,
> +			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
> +	info->red = v4l2_ctrl_new_std(hdl, &sr030pc30_ctrl_ops,
> +			V4L2_CID_RED_BALANCE, 0, 127, 1, 64);
> +	info->blue = v4l2_ctrl_new_std(hdl, &sr030pc30_ctrl_ops,
> +			V4L2_CID_BLUE_BALANCE, 0, 127, 1, 64);
> +	info->autoexp = v4l2_ctrl_new_std(hdl, &sr030pc30_ctrl_ops,
> +			V4L2_CID_EXPOSURE_AUTO, 0, 1, 1, 1);
> +	info->exp = v4l2_ctrl_new_std(hdl, &sr030pc30_ctrl_ops,
> +			V4L2_CID_EXPOSURE, EXPOS_MIN_MS, EXPOS_MAX_MS, 1, 30);
> +	sd->ctrl_handler = hdl;
> +	if (hdl->error) {
> +		int err = hdl->error;
> +
> +		v4l2_ctrl_handler_free(hdl);
> +		return err;
> +	}
> +	v4l2_ctrl_auto_cluster(3, &info->awb, 0, false);
> +	v4l2_ctrl_auto_cluster(2, &info->autoexp, V4L2_EXPOSURE_MANUAL, false);
> +	v4l2_ctrl_handler_setup(hdl);
> +
>  	info->i2c_reg_page	= -1;
>  	info->hflip		= 1;
> -	info->auto_exp		= 1;
> -	info->exposure		= 30;
>  
>  	return 0;
>  }
> @@ -843,6 +742,7 @@ static int sr030pc30_remove(struct i2c_client *client)
>  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>  
>  	v4l2_device_unregister_subdev(sd);
> +	v4l2_ctrl_handler_free(sd->ctrl_handler);
>  	return 0;
>  }

--
Thanks & Regards,
Sylwester
