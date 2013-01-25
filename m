Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:56731 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3AYQz1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 11:55:27 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so388286bkc.10
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 08:55:25 -0800 (PST)
Message-ID: <5102B924.7030800@googlemail.com>
Date: Fri, 25 Jan 2013 17:56:04 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 3/3] mt9v011: convert to the control framework.
References: <1359013876-12443-1-git-send-email-hverkuil@xs4all.nl> <8956523f0ef5757e85f7d7061575e7b227290c7b.1359013702.git.hans.verkuil@cisco.com>
In-Reply-To: <8956523f0ef5757e85f7d7061575e7b227290c7b.1359013702.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 24.01.2013 08:51, schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/mt9v011.c |  223 +++++++++++++------------------------------
>  1 file changed, 67 insertions(+), 156 deletions(-)
>
> diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
> index 6bf01ad..73b7688 100644
> --- a/drivers/media/i2c/mt9v011.c
> +++ b/drivers/media/i2c/mt9v011.c
> @@ -13,6 +13,7 @@
>  #include <asm/div64.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/mt9v011.h>
>  
>  MODULE_DESCRIPTION("Micron mt9v011 sensor driver");
> @@ -48,68 +49,9 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
>  #define MT9V011_VERSION			0x8232
>  #define MT9V011_REV_B_VERSION		0x8243
>  
> -/* supported controls */
> -static struct v4l2_queryctrl mt9v011_qctrl[] = {
> -	{
> -		.id = V4L2_CID_GAIN,
> -		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.name = "Gain",
> -		.minimum = 0,
> -		.maximum = (1 << 12) - 1 - 0x0020,
> -		.step = 1,
> -		.default_value = 0x0020,
> -		.flags = 0,
> -	}, {
> -		.id = V4L2_CID_EXPOSURE,
> -		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.name = "Exposure",
> -		.minimum = 0,
> -		.maximum = 2047,
> -		.step = 1,
> -		.default_value = 0x01fc,
> -		.flags = 0,
> -	}, {
> -		.id = V4L2_CID_RED_BALANCE,
> -		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.name = "Red Balance",
> -		.minimum = -1 << 9,
> -		.maximum = (1 << 9) - 1,
> -		.step = 1,
> -		.default_value = 0,
> -		.flags = 0,
> -	}, {
> -		.id = V4L2_CID_BLUE_BALANCE,
> -		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.name = "Blue Balance",
> -		.minimum = -1 << 9,
> -		.maximum = (1 << 9) - 1,
> -		.step = 1,
> -		.default_value = 0,
> -		.flags = 0,
> -	}, {
> -		.id      = V4L2_CID_HFLIP,
> -		.type    = V4L2_CTRL_TYPE_BOOLEAN,
> -		.name    = "Mirror",
> -		.minimum = 0,
> -		.maximum = 1,
> -		.step    = 1,
> -		.default_value = 0,
> -		.flags = 0,
> -	}, {
> -		.id      = V4L2_CID_VFLIP,
> -		.type    = V4L2_CTRL_TYPE_BOOLEAN,
> -		.name    = "Vflip",
> -		.minimum = 0,
> -		.maximum = 1,
> -		.step    = 1,
> -		.default_value = 0,
> -		.flags = 0,
> -	}, {
> -	}
> -};
> -
>  struct mt9v011 {
>  	struct v4l2_subdev sd;
> +	struct v4l2_ctrl_handler ctrls;
>  	unsigned width, height;
>  	unsigned xtal;
>  	unsigned hflip:1;
> @@ -381,99 +323,6 @@ static int mt9v011_reset(struct v4l2_subdev *sd, u32 val)
>  	set_read_mode(sd);
>  
>  	return 0;
> -};
> -
> -static int mt9v011_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> -{
> -	struct mt9v011 *core = to_mt9v011(sd);
> -
> -	v4l2_dbg(1, debug, sd, "g_ctrl called\n");
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_GAIN:
> -		ctrl->value = core->global_gain;
> -		return 0;
> -	case V4L2_CID_EXPOSURE:
> -		ctrl->value = core->exposure;
> -		return 0;
> -	case V4L2_CID_RED_BALANCE:
> -		ctrl->value = core->red_bal;
> -		return 0;
> -	case V4L2_CID_BLUE_BALANCE:
> -		ctrl->value = core->blue_bal;
> -		return 0;
> -	case V4L2_CID_HFLIP:
> -		ctrl->value = core->hflip ? 1 : 0;
> -		return 0;
> -	case V4L2_CID_VFLIP:
> -		ctrl->value = core->vflip ? 1 : 0;
> -		return 0;
> -	}
> -	return -EINVAL;
> -}
> -
> -static int mt9v011_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
> -{
> -	int i;
> -
> -	v4l2_dbg(1, debug, sd, "queryctrl called\n");
> -
> -	for (i = 0; i < ARRAY_SIZE(mt9v011_qctrl); i++)
> -		if (qc->id && qc->id == mt9v011_qctrl[i].id) {
> -			memcpy(qc, &(mt9v011_qctrl[i]),
> -			       sizeof(*qc));
> -			return 0;
> -		}
> -
> -	return -EINVAL;
> -}
> -
> -
> -static int mt9v011_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> -{
> -	struct mt9v011 *core = to_mt9v011(sd);
> -	u8 i, n;
> -	n = ARRAY_SIZE(mt9v011_qctrl);
> -
> -	for (i = 0; i < n; i++) {
> -		if (ctrl->id != mt9v011_qctrl[i].id)
> -			continue;
> -		if (ctrl->value < mt9v011_qctrl[i].minimum ||
> -		    ctrl->value > mt9v011_qctrl[i].maximum)
> -			return -ERANGE;
> -		v4l2_dbg(1, debug, sd, "s_ctrl: id=%d, value=%d\n",
> -					ctrl->id, ctrl->value);
> -		break;
> -	}
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_GAIN:
> -		core->global_gain = ctrl->value;
> -		break;
> -	case V4L2_CID_EXPOSURE:
> -		core->exposure = ctrl->value;
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		core->red_bal = ctrl->value;
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		core->blue_bal = ctrl->value;
> -		break;
> -	case V4L2_CID_HFLIP:
> -		core->hflip = ctrl->value;
> -		set_read_mode(sd);
> -		return 0;
> -	case V4L2_CID_VFLIP:
> -		core->vflip = ctrl->value;
> -		set_read_mode(sd);
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	set_balance(sd);
> -
> -	return 0;
>  }
>  
>  static int mt9v011_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
> @@ -599,10 +448,46 @@ static int mt9v011_g_chip_ident(struct v4l2_subdev *sd,
>  					  version);
>  }
>  
> -static const struct v4l2_subdev_core_ops mt9v011_core_ops = {
> -	.queryctrl = mt9v011_queryctrl,
> -	.g_ctrl = mt9v011_g_ctrl,
> +static int mt9v011_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct mt9v011 *core =
> +		container_of(ctrl->handler, struct mt9v011, ctrls);
> +	struct v4l2_subdev *sd = &core->sd;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_GAIN:
> +		core->global_gain = ctrl->val;
> +		break;
> +	case V4L2_CID_EXPOSURE:
> +		core->exposure = ctrl->val;
> +		break;
> +	case V4L2_CID_RED_BALANCE:
> +		core->red_bal = ctrl->val;
> +		break;
> +	case V4L2_CID_BLUE_BALANCE:
> +		core->blue_bal = ctrl->val;
> +		break;
> +	case V4L2_CID_HFLIP:
> +		core->hflip = ctrl->val;
> +		set_read_mode(sd);
> +		return 0;
> +	case V4L2_CID_VFLIP:
> +		core->vflip = ctrl->val;
> +		set_read_mode(sd);
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	set_balance(sd);
> +	return 0;
> +}
> +
> +static struct v4l2_ctrl_ops mt9v011_ctrl_ops = {
>  	.s_ctrl = mt9v011_s_ctrl,
> +};
> +
> +static const struct v4l2_subdev_core_ops mt9v011_core_ops = {
>  	.reset = mt9v011_reset,
>  	.g_chip_ident = mt9v011_g_chip_ident,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
> @@ -658,6 +543,30 @@ static int mt9v011_probe(struct i2c_client *c,
>  		return -EINVAL;
>  	}
>  
> +	v4l2_ctrl_handler_init(&core->ctrls, 5);
> +	v4l2_ctrl_new_std(&core->ctrls, &mt9v011_ctrl_ops,
> +			  V4L2_CID_GAIN, 0, (1 << 12) - 1 - 0x20, 1, 0x20);
> +	v4l2_ctrl_new_std(&core->ctrls, &mt9v011_ctrl_ops,
> +			  V4L2_CID_EXPOSURE, 0, 2047, 1, 0x01fc);
> +	v4l2_ctrl_new_std(&core->ctrls, &mt9v011_ctrl_ops,
> +			  V4L2_CID_RED_BALANCE, -(1 << 9), (1 << 9) - 1, 1, 0);
> +	v4l2_ctrl_new_std(&core->ctrls, &mt9v011_ctrl_ops,
> +			  V4L2_CID_BLUE_BALANCE, -(1 << 9), (1 << 9) - 1, 1, 0);
> +	v4l2_ctrl_new_std(&core->ctrls, &mt9v011_ctrl_ops,
> +			  V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&core->ctrls, &mt9v011_ctrl_ops,
> +			  V4L2_CID_VFLIP, 0, 1, 1, 0);
> +
> +	if (core->ctrls.error) {
> +		int ret = core->ctrls.error;
> +
> +		v4l2_err(sd, "control initialization error %d\n", ret);
> +		v4l2_ctrl_handler_free(&core->ctrls);
> +		kfree(core);
> +		return ret;
> +	}
> +	core->sd.ctrl_handler = &core->ctrls;
> +
>  	core->global_gain = 0x0024;
>  	core->exposure = 0x01fc;
>  	core->width  = 640;
> @@ -681,12 +590,14 @@ static int mt9v011_probe(struct i2c_client *c,
>  static int mt9v011_remove(struct i2c_client *c)
>  {
>  	struct v4l2_subdev *sd = i2c_get_clientdata(c);
> +	struct mt9v011 *core = to_mt9v011(sd);
>  
>  	v4l2_dbg(1, debug, sd,
>  		"mt9v011.c: removing mt9v011 adapter on address 0x%x\n",
>  		c->addr << 1);
>  
>  	v4l2_device_unregister_subdev(sd);
> +	v4l2_ctrl_handler_free(&core->ctrls);
>  	kfree(to_mt9v011(sd));
>  	return 0;
>  }

Tested-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Fixes the em28xx regression (no image control with "Silvercrest 1.3MPix
webcam") in the media-tree.

Regards,
Frank

