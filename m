Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:55208 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1AVVWS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 16:22:18 -0500
Date: Sat, 22 Jan 2011 22:21:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [RFC PATCH 03/12] mt9m001: convert to the control framework.
In-Reply-To: <47023fea8af2dd4be5c03491427bf0edd2592cb6.1294786597.git.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1101222135010.31015@axis700.grange>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
 <47023fea8af2dd4be5c03491427bf0edd2592cb6.1294786597.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 12 Jan 2011, Hans Verkuil wrote:

> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/mt9m001.c |  210 +++++++++++++++--------------------------
>  1 files changed, 75 insertions(+), 135 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
> index f7fc88d..b9b6e33 100644
> --- a/drivers/media/video/mt9m001.c
> +++ b/drivers/media/video/mt9m001.c
> @@ -15,6 +15,7 @@
>  
>  #include <media/v4l2-subdev.h>
>  #include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/soc_camera.h>
>  
>  /*
> @@ -84,15 +85,18 @@ static const struct mt9m001_datafmt mt9m001_monochrome_fmts[] = {
>  
>  struct mt9m001 {
>  	struct v4l2_subdev subdev;
> +	struct v4l2_ctrl_handler hdl;
> +	struct {
> +		/* exposure/auto-exposure cluster */
> +		struct v4l2_ctrl *autoexposure;
> +		struct v4l2_ctrl *exposure;
> +	};

Hm, why an anonymous struct? Why not just put them directly at the top 
level?

>  	struct v4l2_rect rect;	/* Sensor window */
>  	const struct mt9m001_datafmt *fmt;
>  	const struct mt9m001_datafmt *fmts;
>  	int num_fmts;
>  	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
> -	unsigned int gain;
> -	unsigned int exposure;
>  	unsigned short y_skip_top;	/* Lines to skip at the top */
> -	unsigned char autoexposure;
>  };
>  
>  static struct mt9m001 *to_mt9m001(const struct i2c_client *client)
> @@ -209,7 +213,6 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  	struct v4l2_rect rect = a->c;
> -	struct soc_camera_device *icd = client->dev.platform_data;
>  	int ret;
>  	const u16 hblank = 9, vblank = 25;
>  	unsigned int total_h;
> @@ -251,17 +254,18 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	if (!ret)
>  		ret = reg_write(client, MT9M001_WINDOW_HEIGHT,
>  				rect.height + mt9m001->y_skip_top - 1);
> -	if (!ret && mt9m001->autoexposure) {
> +	v4l2_ctrl_lock(mt9m001->autoexposure);
> +	if (!ret && mt9m001->autoexposure->cur.val == V4L2_EXPOSURE_AUTO) {
>  		ret = reg_write(client, MT9M001_SHUTTER_WIDTH, total_h);
>  		if (!ret) {
> -			const struct v4l2_queryctrl *qctrl =
> -				soc_camera_find_qctrl(icd->ops,
> -						      V4L2_CID_EXPOSURE);
> -			mt9m001->exposure = (524 + (total_h - 1) *
> -				 (qctrl->maximum - qctrl->minimum)) /
> -				1048 + qctrl->minimum;
> +			struct v4l2_ctrl *ctrl = mt9m001->exposure;
> +
> +			ctrl->cur.val = (524 + (total_h - 1) *
> +				 (ctrl->maximum - ctrl->minimum)) /
> +				1048 + ctrl->minimum;
>  		}
>  	}
> +	v4l2_ctrl_unlock(mt9m001->autoexposure);
>  
>  	if (!ret)
>  		mt9m001->rect = rect;
> @@ -421,107 +425,36 @@ static int mt9m001_s_register(struct v4l2_subdev *sd,
>  }
>  #endif
>  
> -static const struct v4l2_queryctrl mt9m001_controls[] = {
> -	{
> -		.id		= V4L2_CID_VFLIP,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "Flip Vertically",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 0,
> -	}, {
> -		.id		= V4L2_CID_GAIN,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Gain",
> -		.minimum	= 0,
> -		.maximum	= 127,
> -		.step		= 1,
> -		.default_value	= 64,
> -		.flags		= V4L2_CTRL_FLAG_SLIDER,
> -	}, {
> -		.id		= V4L2_CID_EXPOSURE,
> -		.type		= V4L2_CTRL_TYPE_INTEGER,
> -		.name		= "Exposure",
> -		.minimum	= 1,
> -		.maximum	= 255,
> -		.step		= 1,
> -		.default_value	= 255,
> -		.flags		= V4L2_CTRL_FLAG_SLIDER,
> -	}, {
> -		.id		= V4L2_CID_EXPOSURE_AUTO,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "Automatic Exposure",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 1,
> -	}
> -};
> -
>  static struct soc_camera_ops mt9m001_ops = {
>  	.set_bus_param		= mt9m001_set_bus_param,
>  	.query_bus_param	= mt9m001_query_bus_param,
> -	.controls		= mt9m001_controls,
> -	.num_controls		= ARRAY_SIZE(mt9m001_controls),
>  };
>  
> -static int mt9m001_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> +	struct v4l2_subdev *sd =
> +		&container_of(ctrl->handler, struct mt9m001, hdl)->subdev;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);

This looks a bit clumsy to me, sorry. Above you already have "struct 
mt9m001 *" (container_of(ctrl->handler, struct mt9m001, hdl)), but you 
only use it implicitly to get to sd, and then mt9m001 is calculated 
again...

> +	struct v4l2_ctrl *exp = mt9m001->exposure;
>  	int data;
>  
>  	switch (ctrl->id) {
>  	case V4L2_CID_VFLIP:
> -		data = reg_read(client, MT9M001_READ_OPTIONS2);
> -		if (data < 0)
> -			return -EIO;
> -		ctrl->value = !!(data & 0x8000);
> -		break;
> -	case V4L2_CID_EXPOSURE_AUTO:
> -		ctrl->value = mt9m001->autoexposure;
> -		break;
> -	case V4L2_CID_GAIN:
> -		ctrl->value = mt9m001->gain;
> -		break;
> -	case V4L2_CID_EXPOSURE:
> -		ctrl->value = mt9m001->exposure;
> -		break;
> -	}
> -	return 0;
> -}
> -
> -static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> -{
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct mt9m001 *mt9m001 = to_mt9m001(client);
> -	struct soc_camera_device *icd = client->dev.platform_data;
> -	const struct v4l2_queryctrl *qctrl;
> -	int data;
> -
> -	qctrl = soc_camera_find_qctrl(&mt9m001_ops, ctrl->id);
> -
> -	if (!qctrl)
> -		return -EINVAL;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_VFLIP:
> -		if (ctrl->value)
> +		if (ctrl->val)
>  			data = reg_set(client, MT9M001_READ_OPTIONS2, 0x8000);
>  		else
>  			data = reg_clear(client, MT9M001_READ_OPTIONS2, 0x8000);
>  		if (data < 0)
>  			return -EIO;
> -		break;
> +		return 0;
> +
>  	case V4L2_CID_GAIN:
> -		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
> -			return -EINVAL;
>  		/* See Datasheet Table 7, Gain settings. */
> -		if (ctrl->value <= qctrl->default_value) {
> +		if (ctrl->val <= ctrl->default_value) {
>  			/* Pack it into 0..1 step 0.125, register values 0..8 */
> -			unsigned long range = qctrl->default_value - qctrl->minimum;
> -			data = ((ctrl->value - qctrl->minimum) * 8 + range / 2) / range;
> +			unsigned long range = ctrl->default_value - ctrl->minimum;
> +			data = ((ctrl->val - ctrl->minimum) * 8 + range / 2) / range;
>  
>  			dev_dbg(&client->dev, "Setting gain %d\n", data);
>  			data = reg_write(client, MT9M001_GLOBAL_GAIN, data);
> @@ -530,8 +463,8 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  		} else {
>  			/* Pack it into 1.125..15 variable step, register values 9..67 */
>  			/* We assume qctrl->maximum - qctrl->default_value - 1 > 0 */
> -			unsigned long range = qctrl->maximum - qctrl->default_value - 1;
> -			unsigned long gain = ((ctrl->value - qctrl->default_value - 1) *
> +			unsigned long range = ctrl->maximum - ctrl->default_value - 1;
> +			unsigned long gain = ((ctrl->val - ctrl->default_value - 1) *
>  					       111 + range / 2) / range + 9;
>  
>  			if (gain <= 32)
> @@ -547,47 +480,36 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  			if (data < 0)
>  				return -EIO;
>  		}
> +		return 0;
>  
> -		/* Success */
> -		mt9m001->gain = ctrl->value;
> -		break;
> -	case V4L2_CID_EXPOSURE:
> -		/* mt9m001 has maximum == default */
> -		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
> -			return -EINVAL;
> -		else {
> -			unsigned long range = qctrl->maximum - qctrl->minimum;
> -			unsigned long shutter = ((ctrl->value - qctrl->minimum) * 1048 +
> +	case V4L2_CID_EXPOSURE_AUTO:
> +		/* Force manual exposure if only the exposure was changed */
> +		if (!ctrl->has_new)
> +			ctrl->val = V4L2_EXPOSURE_MANUAL;
> +		if (ctrl->val == V4L2_EXPOSURE_MANUAL) {
> +			unsigned long range = exp->maximum - exp->minimum;
> +			unsigned long shutter = ((exp->val - exp->minimum) * 1048 +
>  						 range / 2) / range + 1;
>  
>  			dev_dbg(&client->dev,
>  				"Setting shutter width from %d to %lu\n",
> -				reg_read(client, MT9M001_SHUTTER_WIDTH),
> -				shutter);
> +				reg_read(client, MT9M001_SHUTTER_WIDTH), shutter);
>  			if (reg_write(client, MT9M001_SHUTTER_WIDTH, shutter) < 0)
>  				return -EIO;
> -			mt9m001->exposure = ctrl->value;
> -			mt9m001->autoexposure = 0;
> -		}
> -		break;
> -	case V4L2_CID_EXPOSURE_AUTO:
> -		if (ctrl->value) {
> +		} else {
>  			const u16 vblank = 25;
>  			unsigned int total_h = mt9m001->rect.height +
>  				mt9m001->y_skip_top + vblank;
> -			if (reg_write(client, MT9M001_SHUTTER_WIDTH,
> -				      total_h) < 0)
> +
> +			if (reg_write(client, MT9M001_SHUTTER_WIDTH, total_h) < 0)
>  				return -EIO;
> -			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
> -			mt9m001->exposure = (524 + (total_h - 1) *
> -				 (qctrl->maximum - qctrl->minimum)) /
> -				1048 + qctrl->minimum;
> -			mt9m001->autoexposure = 1;
> -		} else
> -			mt9m001->autoexposure = 0;
> -		break;
> +			exp->val = (524 + (total_h - 1) *
> +					(exp->maximum - exp->minimum)) / 1048 +
> +						exp->minimum;
> +		}
> +		return 0;
>  	}
> -	return 0;
> +	return -EINVAL;

It seems to me, that you've dropped V4L2_CID_EXPOSURE here, was it 
intentional? I won't verify this in detail now, because, if it wasn't 
intentional and you fix it in v2, I'll have to re-check it anyway. Or is 
it supposed to be handled by that V4L2_EXPOSURE_MANUAL? So, if the user 
issues a V4L2_CID_EXPOSURE, are you getting V4L2_CID_EXPOSURE_AUTO with 
val == V4L2_EXPOSURE_MANUAL instead? Weird...

>  }
>  
>  /*
> @@ -665,10 +587,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
>  		dev_err(&client->dev, "Failed to initialise the camera\n");
>  
>  	/* mt9m001_init() has reset the chip, returning registers to defaults */
> -	mt9m001->gain = 64;
> -	mt9m001->exposure = 255;
> -
> -	return ret;
> +	return v4l2_ctrl_handler_setup(&mt9m001->hdl);
>  }
>  
>  static void mt9m001_video_remove(struct soc_camera_device *icd)
> @@ -691,9 +610,11 @@ static int mt9m001_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
>  	return 0;
>  }
>  
> +static const struct v4l2_ctrl_ops mt9m001_ctrl_ops = {
> +	.s_ctrl = mt9m001_s_ctrl,
> +};
> +
>  static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
> -	.g_ctrl		= mt9m001_g_ctrl,
> -	.s_ctrl		= mt9m001_s_ctrl,
>  	.g_chip_ident	= mt9m001_g_chip_ident,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	.g_register	= mt9m001_g_register,
> @@ -766,6 +687,28 @@ static int mt9m001_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  
>  	v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_ops);
> +	v4l2_ctrl_handler_init(&mt9m001->hdl, 4);
> +	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
> +			V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
> +			V4L2_CID_GAIN, 0, 127, 1, 64);
> +	mt9m001->exposure = v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
> +			V4L2_CID_EXPOSURE, 1, 255, 1, 255);
> +	/*
> +	 * Simulated autoexposure. If enabled, we calculate shutter width
> +	 * ourselves in the driver based on vertical blanking and frame width
> +	 */
> +	mt9m001->autoexposure = v4l2_ctrl_new_std_menu(&mt9m001->hdl,
> +			&mt9m001_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
> +			V4L2_EXPOSURE_AUTO);
> +	mt9m001->subdev.ctrl_handler = &mt9m001->hdl;
> +	if (mt9m001->hdl.error) {
> +		int err = mt9m001->hdl.error;
> +
> +		kfree(mt9m001);
> +		return err;
> +	}
> +	v4l2_ctrl_cluster(2, &mt9m001->autoexposure);

Ooh, is this the reason for that anonymous struct?...

>  
>  	/* Second stage probe - when a capture adapter is there */
>  	icd->ops		= &mt9m001_ops;
> @@ -776,15 +719,10 @@ static int mt9m001_probe(struct i2c_client *client,
>  	mt9m001->rect.width	= MT9M001_MAX_WIDTH;
>  	mt9m001->rect.height	= MT9M001_MAX_HEIGHT;
>  
> -	/*
> -	 * Simulated autoexposure. If enabled, we calculate shutter width
> -	 * ourselves in the driver based on vertical blanking and frame width
> -	 */
> -	mt9m001->autoexposure = 1;
> -
>  	ret = mt9m001_video_probe(icd, client);
>  	if (ret) {
>  		icd->ops = NULL;
> +		v4l2_ctrl_handler_free(&mt9m001->hdl);
>  		kfree(mt9m001);
>  	}
>  
> @@ -796,6 +734,8 @@ static int mt9m001_remove(struct i2c_client *client)
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  	struct soc_camera_device *icd = client->dev.platform_data;
>  
> +	v4l2_device_unregister_subdev(&mt9m001->subdev);

hm, first, this is not really related, right? Secondly, are you sure this 
is needed? It is now double with soc_camera_remove(). I know, it is safe, 
but still, one of them looks superfluous to me.

> +	v4l2_ctrl_handler_free(&mt9m001->hdl);
>  	icd->ops = NULL;
>  	mt9m001_video_remove(icd);
>  	kfree(mt9m001);
> -- 
> 1.7.0.4
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
