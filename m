Return-path: <linux-media-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:40427 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759162Ab1IIRIG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Sep 2011 13:08:06 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 08/13 v3] ov6650: convert to the control framework.
Date: Fri, 9 Sep 2011 19:07:05 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de> <1315471446-17890-9-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1315471446-17890-9-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109091907.05823.jkrzyszt@tis.icnet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 8 Sep 2011 at 10:44:01 Guennadi Liakhovetski wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> [g.liakhovetski@gmx.de: simplified pointer arithmetic]
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Hi,
I've successfully tested this one for you, to the extent possible using 
mplayer, i.e., only saturation, hue and brightness controls, and an 
overall functionality.

Modifications to other (not runtime tested) controls look good to me, 
except for one copy-paste mistake, see below. With that erratic REG_BLUE 
corrected:

Acked-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

There are also a few minor comments for you to consider.

Thanks,
Janusz

> ---
>  drivers/media/video/ov6650.c |  381 +++++++++++++-----------------------------
>  1 files changed, 115 insertions(+), 266 deletions(-)
> 
> diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
> index 654b2f5..089a4aa 100644
> --- a/drivers/media/video/ov6650.c
> +++ b/drivers/media/video/ov6650.c
> @@ -32,6 +32,7 @@
>  #include <media/soc_camera.h>
>  #include <media/soc_mediabus.h>
>  #include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-ctrls.h>
>  
>  /* Register definitions */
>  #define REG_GAIN		0x00	/* range 00 - 3F */
> @@ -177,20 +178,23 @@ struct ov6650_reg {
>  
>  struct ov6650 {
>  	struct v4l2_subdev	subdev;
> -
> -	int			gain;
> -	int			blue;
> -	int			red;
> -	int			saturation;
> -	int			hue;
> -	int			brightness;
> -	int			exposure;
> -	int			gamma;
> -	int			aec;
> -	bool			vflip;
> -	bool			hflip;
> -	bool			awb;
> -	bool			agc;
> +	struct v4l2_ctrl_handler hdl;
> +	struct {
> +		/* exposure/autoexposure cluster */
> +		struct v4l2_ctrl *autoexposure;
> +		struct v4l2_ctrl *exposure;
> +	};
> +	struct {
> +		/* gain/autogain cluster */
> +		struct v4l2_ctrl *autogain;
> +		struct v4l2_ctrl *gain;
> +	};
> +	struct {
> +		/* blue/red/autowhitebalance cluster */
> +		struct v4l2_ctrl *autowb;
> +		struct v4l2_ctrl *blue;
> +		struct v4l2_ctrl *red;
> +	};
>  	bool			half_scale;	/* scale down output by 2 */
>  	struct v4l2_rect	rect;		/* sensor cropping window */
>  	unsigned long		pclk_limit;	/* from host */
> @@ -210,126 +214,6 @@ static enum v4l2_mbus_pixelcode ov6650_codes[] = {
>  	V4L2_MBUS_FMT_Y8_1X8,
>  };
>  
> -static const struct v4l2_queryctrl ov6650_controls[] = {
> -	{
> -		.id		= V4L2_CID_AUTOGAIN,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "AGC",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 1,
> -	},
> -	{
> -		.id		= V4L2_CID_GAIN,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Gain",
> -		.minimum	= 0,
> -		.maximum	= 0x3f,
> -		.step		= 1,
> -		.default_value	= DEF_GAIN,
> -	},
> -	{
> -		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "AWB",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 1,
> -	},
> -	{
> -		.id		= V4L2_CID_BLUE_BALANCE,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Blue",
> -		.minimum	= 0,
> -		.maximum	= 0xff,
> -		.step		= 1,
> -		.default_value	= DEF_BLUE,
> -	},
> -	{
> -		.id		= V4L2_CID_RED_BALANCE,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Red",
> -		.minimum	= 0,
> -		.maximum	= 0xff,
> -		.step		= 1,
> -		.default_value	= DEF_RED,
> -	},
> -	{
> -		.id		= V4L2_CID_SATURATION,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Saturation",
> -		.minimum	= 0,
> -		.maximum	= 0xf,
> -		.step		= 1,
> -		.default_value	= 0x8,
> -	},
> -	{
> -		.id		= V4L2_CID_HUE,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Hue",
> -		.minimum	= 0,
> -		.maximum	= HUE_MASK,
> -		.step		= 1,
> -		.default_value	= DEF_HUE,
> -	},
> -	{
> -		.id		= V4L2_CID_BRIGHTNESS,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Brightness",
> -		.minimum	= 0,
> -		.maximum	= 0xff,
> -		.step		= 1,
> -		.default_value	= 0x80,
> -	},
> -	{
> -		.id		= V4L2_CID_EXPOSURE_AUTO,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "AEC",
> -		.minimum	= 0,
> -		.maximum	= 3,
> -		.step		= 1,
> -		.default_value	= 0,
> -	},
> -	{
> -		.id		= V4L2_CID_EXPOSURE,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Exposure",
> -		.minimum	= 0,
> -		.maximum	= 0xff,
> -		.step		= 1,
> -		.default_value	= DEF_AECH,
> -	},
> -	{
> -		.id		= V4L2_CID_GAMMA,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Gamma",
> -		.minimum	= 0,
> -		.maximum	= 0xff,
> -		.step		= 1,
> -		.default_value	= 0x12,
> -	},
> -	{
> -		.id		= V4L2_CID_VFLIP,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "Flip Vertically",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 0,
> -	},
> -	{
> -		.id		= V4L2_CID_HFLIP,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "Flip Horizontally",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 0,
> -	},
> -};
> -
>  /* read a register */
>  static int ov6650_reg_read(struct i2c_client *client, u8 reg, u8 *val)
>  {
> @@ -420,166 +304,91 @@ static int ov6650_s_stream(struct v4l2_subdev *sd, int enable)
>  }
>  
>  /* Get status of additional camera capabilities */
> -static int ov6650_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +static int ov6550_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>  {
> +	struct ov6650 *priv = container_of(ctrl->handler, struct ov6650, hdl);
> +	struct v4l2_subdev *sd = &priv->subdev;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct ov6650 *priv = to_ov6650(client);
> -	uint8_t reg;
> +	uint8_t reg, reg2;
>  	int ret = 0;

With no "retrun ret;" at the end, there is no need to initialize ret any 
longer.

>  	switch (ctrl->id) {
>  	case V4L2_CID_AUTOGAIN:
> -		ctrl->value = priv->agc;
> -		break;
> -	case V4L2_CID_GAIN:
> -		if (priv->agc) {
> -			ret = ov6650_reg_read(client, REG_GAIN, &reg);
> -			ctrl->value = reg;
> -		} else {
> -			ctrl->value = priv->gain;
> -		}
> -		break;
> +		ret = ov6650_reg_read(client, REG_GAIN, &reg);
> +		if (!ret)
> +			priv->gain->val = reg;
> +		return ret;
>  	case V4L2_CID_AUTO_WHITE_BALANCE:
> -		ctrl->value = priv->awb;
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		if (priv->awb) {
> -			ret = ov6650_reg_read(client, REG_BLUE, &reg);
> -			ctrl->value = reg;
> -		} else {
> -			ctrl->value = priv->blue;
> -		}
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		if (priv->awb) {
> -			ret = ov6650_reg_read(client, REG_RED, &reg);
> -			ctrl->value = reg;
> -		} else {
> -			ctrl->value = priv->red;
> +		ret = ov6650_reg_read(client, REG_BLUE, &reg);
> +		if (!ret)
> +			ret = ov6650_reg_read(client, REG_RED, &reg2);
> +		if (!ret) {
> +			priv->blue->val = reg;
> +			priv->red->val = reg2;
>  		}
> -		break;
> -	case V4L2_CID_SATURATION:
> -		ctrl->value = priv->saturation;
> -		break;
> -	case V4L2_CID_HUE:
> -		ctrl->value = priv->hue;
> -		break;
> -	case V4L2_CID_BRIGHTNESS:
> -		ctrl->value = priv->brightness;
> -		break;
> +		return ret;
>  	case V4L2_CID_EXPOSURE_AUTO:
> -		ctrl->value = priv->aec;
> -		break;
> -	case V4L2_CID_EXPOSURE:
> -		if (priv->aec) {
> -			ret = ov6650_reg_read(client, REG_AECH, &reg);
> -			ctrl->value = reg;
> -		} else {
> -			ctrl->value = priv->exposure;
> -		}
> -		break;
> -	case V4L2_CID_GAMMA:
> -		ctrl->value = priv->gamma;
> -		break;
> -	case V4L2_CID_VFLIP:
> -		ctrl->value = priv->vflip;
> -		break;
> -	case V4L2_CID_HFLIP:
> -		ctrl->value = priv->hflip;
> -		break;
> +		ret = ov6650_reg_read(client, REG_AECH, &reg);
> +		if (!ret)
> +			priv->exposure->val = reg;
> +		return ret;
>  	}
> -	return ret;
> +	return -EINVAL;
>  }
>  
>  /* Set status of additional camera capabilities */
> -static int ov6650_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +static int ov6550_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> +	struct ov6650 *priv = container_of(ctrl->handler, struct ov6650, hdl);
> +	struct v4l2_subdev *sd = &priv->subdev;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct ov6650 *priv = to_ov6650(client);
>  	int ret = 0;

ditto

>  	switch (ctrl->id) {
>  	case V4L2_CID_AUTOGAIN:
>  		ret = ov6650_reg_rmw(client, REG_COMB,
> -				ctrl->value ? COMB_AGC : 0, COMB_AGC);
> -		if (!ret)
> -			priv->agc = ctrl->value;
> -		break;
> -	case V4L2_CID_GAIN:
> -		ret = ov6650_reg_write(client, REG_GAIN, ctrl->value);
> -		if (!ret)
> -			priv->gain = ctrl->value;
> -		break;
> +				ctrl->val ? COMB_AGC : 0, COMB_AGC);
> +		if (!ret && !ctrl->val)
> +			ret = ov6650_reg_write(client, REG_GAIN, priv->gain->val);
> +		return ret;
>  	case V4L2_CID_AUTO_WHITE_BALANCE:
>  		ret = ov6650_reg_rmw(client, REG_COMB,
> -				ctrl->value ? COMB_AWB : 0, COMB_AWB);
> -		if (!ret)
> -			priv->awb = ctrl->value;
> -		break;
> -	case V4L2_CID_BLUE_BALANCE:
> -		ret = ov6650_reg_write(client, REG_BLUE, ctrl->value);
> -		if (!ret)
> -			priv->blue = ctrl->value;
> -		break;
> -	case V4L2_CID_RED_BALANCE:
> -		ret = ov6650_reg_write(client, REG_RED, ctrl->value);
> -		if (!ret)
> -			priv->red = ctrl->value;
> -		break;
> +				ctrl->val ? COMB_AWB : 0, COMB_AWB);
> +		if (!ret && !ctrl->val) {
> +			ret = ov6650_reg_write(client, REG_BLUE, priv->blue->val);
> +			if (!ret)
> +				ret = ov6650_reg_write(client, REG_BLUE,

REG_RED

> +							priv->red->val);
> +		}
> +		return ret;
>  	case V4L2_CID_SATURATION:
> -		ret = ov6650_reg_rmw(client, REG_SAT, SET_SAT(ctrl->value),
> +		return ov6650_reg_rmw(client, REG_SAT, SET_SAT(ctrl->val),
>  				SAT_MASK);
> -		if (!ret)
> -			priv->saturation = ctrl->value;
> -		break;
>  	case V4L2_CID_HUE:
> -		ret = ov6650_reg_rmw(client, REG_HUE, SET_HUE(ctrl->value),
> +		return ov6650_reg_rmw(client, REG_HUE, SET_HUE(ctrl->val),
>  				HUE_MASK);
> -		if (!ret)
> -			priv->hue = ctrl->value;
> -		break;
>  	case V4L2_CID_BRIGHTNESS:
> -		ret = ov6650_reg_write(client, REG_BRT, ctrl->value);
> -		if (!ret)
> -			priv->brightness = ctrl->value;
> -		break;
> +		return ov6650_reg_write(client, REG_BRT, ctrl->val);
>  	case V4L2_CID_EXPOSURE_AUTO:
> -		switch (ctrl->value) {
> -		case V4L2_EXPOSURE_AUTO:

For consitency with other cases (V4L2_CID_AUTOGAIN, 
V4L2_CID_AUTO_WHITE_BALANCE, V4L2_CID_VFLIP, V4L2_CID_HFLIP), the 
following snippet:

> +		if (ctrl->val == V4L2_EXPOSURE_AUTO)
>  			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AEC, 0);
> -			break;
> -		default:
> +		else
>  			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AEC);

could perhaps be replaced with something like:

-		if (ctrl->val == V4L2_EXPOSURE_AUTO)
-			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AEC, 0);
-			break;
-		default:
-			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AEC);
+		ret = ov6650_reg_rmw(client, REG_COMB, ctrl->val ==
+				V4L2_EXPOSURE_AUTO ? COMB_AEC : 0, COMB_AEC);

or, the other way around, conditional expressions could be replaced with 
if...else constructs in those other cases consequently.

> -			break;
> -		}
> -		if (!ret)
> -			priv->aec = ctrl->value;
> -		break;
> -	case V4L2_CID_EXPOSURE:
> -		ret = ov6650_reg_write(client, REG_AECH, ctrl->value);
> -		if (!ret)
> -			priv->exposure = ctrl->value;
> -		break;
> +		if (!ret && ctrl->val == V4L2_EXPOSURE_MANUAL)
> +			ret = ov6650_reg_write(client, REG_AECH,
> +						priv->exposure->val);
> +		return ret;
>  	case V4L2_CID_GAMMA:
> -		ret = ov6650_reg_write(client, REG_GAM1, ctrl->value);
> -		if (!ret)
> -			priv->gamma = ctrl->value;
> -		break;
> +		return ov6650_reg_write(client, REG_GAM1, ctrl->val);
>  	case V4L2_CID_VFLIP:
> -		ret = ov6650_reg_rmw(client, REG_COMB,
> -				ctrl->value ? COMB_FLIP_V : 0, COMB_FLIP_V);
> -		if (!ret)
> -			priv->vflip = ctrl->value;
> -		break;
> +		return ov6650_reg_rmw(client, REG_COMB,
> +				ctrl->val ? COMB_FLIP_V : 0, COMB_FLIP_V);
>  	case V4L2_CID_HFLIP:
> -		ret = ov6650_reg_rmw(client, REG_COMB,
> -				ctrl->value ? COMB_FLIP_H : 0, COMB_FLIP_H);
> -		if (!ret)
> -			priv->hflip = ctrl->value;
> -		break;
> +		return ov6650_reg_rmw(client, REG_COMB,
> +				ctrl->val ? COMB_FLIP_H : 0, COMB_FLIP_H);
>  	}
>  
> -	return ret;
> +	return -EINVAL;
>  }
>  
>  /* Get chip identification */
> @@ -1048,14 +857,12 @@ static int ov6650_video_probe(struct soc_camera_device *icd,
>  	return ret;
>  }
>  
> -static struct soc_camera_ops ov6650_ops = {
> -	.controls		= ov6650_controls,
> -	.num_controls		= ARRAY_SIZE(ov6650_controls),
> +static const struct v4l2_ctrl_ops ov6550_ctrl_ops = {
> +	.g_volatile_ctrl = ov6550_g_volatile_ctrl,
> +	.s_ctrl = ov6550_s_ctrl,
>  };
>  
>  static struct v4l2_subdev_core_ops ov6650_core_ops = {
> -	.g_ctrl			= ov6650_g_ctrl,
> -	.s_ctrl			= ov6650_s_ctrl,
>  	.g_chip_ident		= ov6650_g_chip_ident,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	.g_register		= ov6650_get_register,
> @@ -1164,8 +971,46 @@ static int ov6650_probe(struct i2c_client *client,
>  	}
>  
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov6650_subdev_ops);
> +	v4l2_ctrl_handler_init(&priv->hdl, 13);
> +	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	priv->autogain = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
> +	priv->gain = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_GAIN, 0, 0x3f, 1, DEF_GAIN);
> +	priv->autowb = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
> +	priv->blue = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_BLUE_BALANCE, 0, 0xff, 1, DEF_BLUE);
> +	priv->red = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_RED_BALANCE, 0, 0xff, 1, DEF_RED);
> +	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_SATURATION, 0, 0xf, 1, 0x8);
> +	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_HUE, 0, HUE_MASK, 1, DEF_HUE);
> +	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_BRIGHTNESS, 0, 0xff, 1, 0x80);
> +	priv->autoexposure = v4l2_ctrl_new_std_menu(&priv->hdl,
> +			&ov6550_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,

max value of V4L2_EXPOSURE_MANUAL instead of equivalent 1 could be more 
clear.

> +			V4L2_EXPOSURE_AUTO);
> +	priv->exposure = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_EXPOSURE, 0, 0xff, 1, DEF_AECH);
> +	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
> +			V4L2_CID_GAMMA, 0, 0xff, 1, 0x12);
> +
> +	priv->subdev.ctrl_handler = &priv->hdl;
> +	if (priv->hdl.error) {
> +		int err = priv->hdl.error;
>  
> -	icd->ops = &ov6650_ops;
> +		kfree(priv);
> +		return err;
> +	}
> +	v4l2_ctrl_auto_cluster(2, &priv->autogain, 0, true);
> +	v4l2_ctrl_auto_cluster(3, &priv->autowb, 0, true);
> +	v4l2_ctrl_auto_cluster(2, &priv->autoexposure,
> +				V4L2_EXPOSURE_MANUAL, true);
>  
>  	priv->rect.left	  = DEF_HSTRT << 1;
>  	priv->rect.top	  = DEF_VSTRT << 1;
> @@ -1176,9 +1021,11 @@ static int ov6650_probe(struct i2c_client *client,
>  	priv->colorspace  = V4L2_COLORSPACE_JPEG;
>  
>  	ret = ov6650_video_probe(icd, client);
> +	if (!ret)
> +		ret = v4l2_ctrl_handler_setup(&priv->hdl);

Are you sure the probe function should fail if v4l2_ctrl_handler_setup() 
fails? Its usage is documented as optional.

>  
>  	if (ret) {
> -		icd->ops = NULL;
> +		v4l2_ctrl_handler_free(&priv->hdl);
>  		kfree(priv);
>  	}
>  
> @@ -1189,6 +1036,8 @@ static int ov6650_remove(struct i2c_client *client)
>  {
>  	struct ov6650 *priv = to_ov6650(client);
>  
> +	v4l2_device_unregister_subdev(&priv->subdev);
> +	v4l2_ctrl_handler_free(&priv->hdl);
>  	kfree(priv);
>  	return 0;
>  }
> 
