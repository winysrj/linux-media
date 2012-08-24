Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2HXLJT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 07:09:19 -0400
Date: Fri, 24 Aug 2012 13:08:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: Re: [PATCH 1/3] mt9v022: add v4l2 controls for blanking and other
 register settings
In-Reply-To: <1345799431-29426-2-git-send-email-agust@denx.de>
Message-ID: <Pine.LNX.4.64.1208241227140.20710@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
 <1345799431-29426-2-git-send-email-agust@denx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anatolij

On Fri, 24 Aug 2012, Anatolij Gustschin wrote:

> Add controls for horizontal and vertical blanking, analog control
> and control for undocumented register 32.

Sorry, I don't think this is a good idea to export an undocumented 
register as a control. At most I would add a platform parameter for it, if 
really needed. Or do you have to switch it at run-time? If so, you would 
have some idea - at what time to switch it to what value and what effect 
that produces. Then you could define a _logical_ control. If you 
absolutely need to write random values to various registers, you can use 
VIDIOC_DBG_S_REGISTER and VIDIOC_DBG_G_REGISTER.

> Also add an error message
> for case that the control handler init failed. Since setting the
> blanking registers is done by controls now, we should't change these
> registers outside of the control function. Use v4l2_ctrl_s_ctrl()
> to set them.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> ---
>  drivers/media/i2c/soc_camera/mt9v022.c |  105 ++++++++++++++++++++++++++++++--
>  1 files changed, 100 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
> index 350d0d8..d13c8c4 100644
> --- a/drivers/media/i2c/soc_camera/mt9v022.c
> +++ b/drivers/media/i2c/soc_camera/mt9v022.c
> @@ -50,12 +50,14 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
>  #define MT9V022_PIXEL_OPERATION_MODE	0x0f
>  #define MT9V022_LED_OUT_CONTROL		0x1b
>  #define MT9V022_ADC_MODE_CONTROL	0x1c
> +#define MT9V022_REG32			0x20
>  #define MT9V022_ANALOG_GAIN		0x35
>  #define MT9V022_BLACK_LEVEL_CALIB_CTRL	0x47
>  #define MT9V022_PIXCLK_FV_LV		0x74
>  #define MT9V022_DIGITAL_TEST_PATTERN	0x7f
>  #define MT9V022_AEC_AGC_ENABLE		0xAF
>  #define MT9V022_MAX_TOTAL_SHUTTER_WIDTH	0xBD
> +#define MT9V022_ANALOG_CONTROL		0xC2
>  
>  /* mt9v024 partial list register addresses changes with respect to mt9v022 */
>  #define MT9V024_PIXCLK_FV_LV		0x72
> @@ -71,6 +73,13 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
>  #define MT9V022_COLUMN_SKIP		1
>  #define MT9V022_ROW_SKIP		4
>  
> +#define MT9V022_HORIZONTAL_BLANKING_MIN	43
> +#define MT9V022_HORIZONTAL_BLANKING_MAX	1023
> +#define MT9V022_HORIZONTAL_BLANKING_DEF	94
> +#define MT9V022_VERTICAL_BLANKING_MIN	2

Interesting, in my datasheet min is 4. Maybe 4 would be a safer bet then.

> +#define MT9V022_VERTICAL_BLANKING_MAX	3000
> +#define MT9V022_VERTICAL_BLANKING_DEF	45
> +
>  #define is_mt9v024(id) (id == 0x1324)
>  
>  /* MT9V022 has only one fixed colorspace per pixelcode */
> @@ -136,6 +145,8 @@ struct mt9v022 {
>  		struct v4l2_ctrl *autogain;
>  		struct v4l2_ctrl *gain;
>  	};
> +	struct v4l2_ctrl *hblank;
> +	struct v4l2_ctrl *vblank;
>  	struct v4l2_rect rect;	/* Sensor window */
>  	const struct mt9v022_datafmt *fmt;
>  	const struct mt9v022_datafmt *fmts;
> @@ -277,11 +288,10 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  		 * Default 94, Phytec driver says:
>  		 * "width + horizontal blank >= 660"
>  		 */
> -		ret = reg_write(client, MT9V022_HORIZONTAL_BLANKING,
> -				rect.width > 660 - 43 ? 43 :
> -				660 - rect.width);
> +		ret = v4l2_ctrl_s_ctrl(mt9v022->hblank,
> +				rect.width > 660 - 43 ? 43 : 660 - rect.width);
>  	if (!ret)
> -		ret = reg_write(client, MT9V022_VERTICAL_BLANKING, 45);
> +		ret = v4l2_ctrl_s_ctrl(mt9v022->vblank, 45);
>  	if (!ret)
>  		ret = reg_write(client, MT9V022_WINDOW_WIDTH, rect.width);
>  	if (!ret)
> @@ -476,6 +486,9 @@ static int mt9v022_s_power(struct v4l2_subdev *sd, int on)
>  	return soc_camera_set_power(&client->dev, icl, on);
>  }
>  
> +#define V4L2_CID_REG32			(V4L2_CTRL_CLASS_CAMERA | 0x1001)
> +#define V4L2_CID_ANALOG_CONTROLS	(V4L2_CTRL_CLASS_CAMERA | 0x1002)

Sorry, no again. The MT9V022_ANALOG_CONTROL register contains two fields: 
anti-eclipse and "anti-eclipse reference voltage control," don't think 
they should be set as a single control value. IIUC, controls are supposed 
to control logical parameters of the system. In this case you could 
introduce an "anti-eclipse reference voltage" control with values in the 
range between 0 and 2250mV, setting it to anything below 1900mV would turn 
the enable bit off. Would such a control make sense? Then you might want 
to ask on the ML, whether this control would make sense as a generic one, 
not mt9v022 specific.

> +
>  static int mt9v022_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct mt9v022 *mt9v022 = container_of(ctrl->handler,
> @@ -504,6 +517,30 @@ static int mt9v022_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>  		range = exp->maximum - exp->minimum;
>  		exp->val = ((data - 1) * range + 239) / 479 + exp->minimum;
>  		return 0;
> +	case V4L2_CID_HBLANK:
> +		data = reg_read(client, MT9V022_HORIZONTAL_BLANKING);
> +		if (data < 0)
> +			return -EIO;
> +		ctrl->val = data;
> +		return 0;
> +	case V4L2_CID_VBLANK:
> +		data = reg_read(client, MT9V022_VERTICAL_BLANKING);
> +		if (data < 0)
> +			return -EIO;
> +		ctrl->val = data;
> +		return 0;
> +	case V4L2_CID_REG32:
> +		data = reg_read(client, MT9V022_REG32);
> +		if (data < 0)
> +			return -EIO;
> +		ctrl->val = data;
> +		return 0;
> +	case V4L2_CID_ANALOG_CONTROLS:
> +		data = reg_read(client, MT9V022_ANALOG_CONTROL);
> +		if (data < 0)
> +			return -EIO;
> +		ctrl->val = data;
> +		return 0;
>  	}
>  	return -EINVAL;
>  }
> @@ -585,6 +622,26 @@ static int mt9v022_s_ctrl(struct v4l2_ctrl *ctrl)
>  				return -EIO;
>  		}
>  		return 0;
> +	case V4L2_CID_HBLANK:
> +		if (reg_write(client, MT9V022_HORIZONTAL_BLANKING,
> +				ctrl->val) < 0)
> +			return -EIO;
> +		return 0;
> +	case V4L2_CID_VBLANK:
> +		if (reg_write(client, MT9V022_VERTICAL_BLANKING,
> +				ctrl->val) < 0)
> +			return -EIO;
> +		return 0;
> +	case V4L2_CID_REG32:
> +		if (reg_write(client, MT9V022_REG32,
> +				ctrl->val) < 0)
> +			return -EIO;
> +		return 0;
> +	case V4L2_CID_ANALOG_CONTROLS:
> +		if (reg_write(client, MT9V022_ANALOG_CONTROL,
> +				ctrl->val) < 0)
> +			return -EIO;
> +		return 0;
>  	}
>  	return -EINVAL;
>  }
> @@ -697,6 +754,30 @@ static const struct v4l2_ctrl_ops mt9v022_ctrl_ops = {
>  	.s_ctrl = mt9v022_s_ctrl,
>  };
>  
> +static const struct v4l2_ctrl_config mt9v022_ctrls[] = {
> +	{
> +		.ops		= &mt9v022_ctrl_ops,
> +		.id		= V4L2_CID_REG32,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "reg32 (0x20)",
> +		.min		= 0,
> +		.max		= 0x0fff,
> +		.step		= 1,
> +		.def		= 0x01d1,
> +		.flags		= V4L2_CTRL_FLAG_VOLATILE,
> +	}, {
> +		.ops		= &mt9v022_ctrl_ops,
> +		.id		= V4L2_CID_ANALOG_CONTROLS,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "analog controls",
> +		.min		= 0,
> +		.max		= 0xffff,
> +		.step		= 1,
> +		.def		= 0x1840,
> +		.flags		= V4L2_CTRL_FLAG_VOLATILE,
> +	},
> +};
> +
>  static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
>  	.g_chip_ident	= mt9v022_g_chip_ident,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
> @@ -832,7 +913,7 @@ static int mt9v022_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  
>  	v4l2_i2c_subdev_init(&mt9v022->subdev, client, &mt9v022_subdev_ops);
> -	v4l2_ctrl_handler_init(&mt9v022->hdl, 6);
> +	v4l2_ctrl_handler_init(&mt9v022->hdl, 6 + ARRAY_SIZE(mt9v022_ctrls));
>  	v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
>  			V4L2_CID_VFLIP, 0, 1, 1, 0);
>  	v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
> @@ -852,10 +933,24 @@ static int mt9v022_probe(struct i2c_client *client,
>  	mt9v022->exposure = v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
>  			V4L2_CID_EXPOSURE, 1, 255, 1, 255);
>  
> +	mt9v022->hblank = v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
> +			V4L2_CID_HBLANK, MT9V022_HORIZONTAL_BLANKING_MIN,
> +			MT9V022_HORIZONTAL_BLANKING_MAX, 1,
> +			MT9V022_HORIZONTAL_BLANKING_DEF);
> +
> +	mt9v022->vblank = v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
> +			V4L2_CID_VBLANK, MT9V022_VERTICAL_BLANKING_MIN,
> +			MT9V022_VERTICAL_BLANKING_MAX, 1,
> +			MT9V022_VERTICAL_BLANKING_DEF);
> +
> +	v4l2_ctrl_new_custom(&mt9v022->hdl, &mt9v022_ctrls[0], NULL);
> +	v4l2_ctrl_new_custom(&mt9v022->hdl, &mt9v022_ctrls[1], NULL);
> +
>  	mt9v022->subdev.ctrl_handler = &mt9v022->hdl;
>  	if (mt9v022->hdl.error) {
>  		int err = mt9v022->hdl.error;
>  
> +		dev_err(&client->dev, "hdl init err %d\n", err);

That's not very clear IMHO. "hdl" isn't too specific, just "control 
initialisation?"

>  		kfree(mt9v022);
>  		return err;
>  	}
> -- 
> 1.7.1
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
