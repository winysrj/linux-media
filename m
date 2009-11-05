Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4206 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbZKEP6A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 10:58:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC 9/9 v2] mt9t031: make the use of the soc-camera client API optional
Date: Thu, 5 Nov 2009 16:57:59 +0100
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange> <A69FA2915331DC488A831521EAE36FE40155798D56@dlee06.ent.ti.com> <Pine.LNX.4.64.0911041703000.4837@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0911041703000.4837@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051657.59303.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 04 November 2009 17:49:28 Guennadi Liakhovetski wrote:
> Now that we have moved most of the functions over to the v4l2-subdev API, only
> quering and setting bus parameters are still performed using the legacy
> soc-camera client API. Make the use of this API optional for mt9t031.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> On Mon, 2 Nov 2009, Karicheri, Muralidharan wrote:
> 
> > >> >+static struct soc_camera_ops mt9t031_ops = {
> > >> >+	.set_bus_param		= mt9t031_set_bus_param,
> > >> >+	.query_bus_param	= mt9t031_query_bus_param,
> > >> >+	.controls		= mt9t031_controls,
> > >> >+	.num_controls		= ARRAY_SIZE(mt9t031_controls),
> > >> >+};
> > >> >+
> > >>
> > >> [MK] Why don't you implement queryctrl ops in core? query_bus_param
> > >> & set_bus_param() can be implemented as a sub device operation as well
> > >> right? I think we need to get the bus parameter RFC implemented and
> > >> this driver could be targeted for it's first use so that we could
> > >> work together to get it accepted. I didn't get a chance to study your
> > >> bus image format RFC, but plan to review it soon and to see if it can be
> > >> used in my platform as well. For use of this driver in our platform,
> > >> all reference to soc_ must be removed. I am ok if the structure is
> > >> re-used, but if this driver calls any soc_camera function, it canot
> > >> be used in my platform.
> > >
> > >Why? Some soc-camera functions are just library functions, you just have
> > >to build soc-camera into your kernel. (also see below)
> > >
> > My point is that the control is for the sensor device, so why to implement
> > queryctrl in SoC camera? Just for this I need to include SOC camera in 
> > my build? That doesn't make any sense at all. IMHO, queryctrl() 
> > logically belongs to this sensor driver which can be called from the 
> > bridge driver using sudev API call. Any reverse dependency from MT9T031 
> > to SoC camera to be removed if it is to be re-used across other 
> > platforms. Can we agree on this?
> 
> In general I'm sure you understand, that there are lots of functions in 
> the kernel, that we use in specific modules, not because they interact 
> with other systems, but because they implement some common functionality 
> and just reduce code-duplication. And I can well imagine that in many such 
> cases using just one or a couple of such functions will pull a much larger 
> pile of unused code with them. But in this case those calls can indeed be 
> very easily eliminated. Please have a look at the version below.

I'm not following this, I'm afraid. The sensor drivers should just support
queryctrl and should use v4l2_ctrl_query_fill() from v4l2-common.c to fill
in the v4l2_queryctrl struct.

This will also make it easy to convert them to the control framework that I
am working on.

Regards,

	Hans

> 
> > Did you have a chance to compare the driver file that I had sent to you?
> 
> I looked at it, but it is based on an earlier version of the driver, so, 
> it wasn't very easy to compare. Maybe you could send a diff against the 
> mainline version, on which it is based?
> 
> Thanks
> Guennadi
> 
>  drivers/media/video/mt9t031.c |  167 +++++++++++++++++++++--------------------
>  1 files changed, 85 insertions(+), 82 deletions(-)
> 
> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> index c95c277..86bf8f6 100644
> --- a/drivers/media/video/mt9t031.c
> +++ b/drivers/media/video/mt9t031.c
> @@ -204,6 +204,71 @@ static unsigned long mt9t031_query_bus_param(struct soc_camera_device *icd)
>  	return soc_camera_apply_sensor_flags(icl, MT9T031_BUS_PARAM);
>  }
>  
> +enum {
> +	MT9T031_CTRL_VFLIP,
> +	MT9T031_CTRL_HFLIP,
> +	MT9T031_CTRL_GAIN,
> +	MT9T031_CTRL_EXPOSURE,
> +	MT9T031_CTRL_EXPOSURE_AUTO,
> +};
> +
> +static const struct v4l2_queryctrl mt9t031_controls[] = {
> +	[MT9T031_CTRL_VFLIP] = {
> +		.id		= V4L2_CID_VFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Vertically",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +	[MT9T031_CTRL_HFLIP] = {
> +		.id		= V4L2_CID_HFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Horizontally",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +	[MT9T031_CTRL_GAIN] = {
> +		.id		= V4L2_CID_GAIN,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Gain",
> +		.minimum	= 0,
> +		.maximum	= 127,
> +		.step		= 1,
> +		.default_value	= 64,
> +		.flags		= V4L2_CTRL_FLAG_SLIDER,
> +	},
> +	[MT9T031_CTRL_EXPOSURE] = {
> +		.id		= V4L2_CID_EXPOSURE,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Exposure",
> +		.minimum	= 1,
> +		.maximum	= 255,
> +		.step		= 1,
> +		.default_value	= 255,
> +		.flags		= V4L2_CTRL_FLAG_SLIDER,
> +	},
> +	[MT9T031_CTRL_EXPOSURE_AUTO] = {
> +		.id		= V4L2_CID_EXPOSURE_AUTO,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Automatic Exposure",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 1,
> +	}
> +};
> +
> +static struct soc_camera_ops mt9t031_ops = {
> +	.set_bus_param		= mt9t031_set_bus_param,
> +	.query_bus_param	= mt9t031_query_bus_param,
> +	.controls		= mt9t031_controls,
> +	.num_controls		= ARRAY_SIZE(mt9t031_controls),
> +};
> +
>  /* target must be _even_ */
>  static u16 mt9t031_skip(s32 *source, s32 target, s32 max)
>  {
> @@ -223,10 +288,9 @@ static u16 mt9t031_skip(s32 *source, s32 target, s32 max)
>  }
>  
>  /* rect is the sensor rectangle, the caller guarantees parameter validity */
> -static int mt9t031_set_params(struct soc_camera_device *icd,
> +static int mt9t031_set_params(struct i2c_client *client,
>  			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
>  {
> -	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  	int ret;
>  	u16 xbin, ybin;
> @@ -307,8 +371,7 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
>  		if (ret >= 0) {
>  			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
>  			const struct v4l2_queryctrl *qctrl =
> -				soc_camera_find_qctrl(icd->ops,
> -						      V4L2_CID_EXPOSURE);
> +				&mt9t031_controls[MT9T031_CTRL_EXPOSURE];
>  			mt9t031->exposure = (shutter_max / 2 + (total_h - 1) *
>  				 (qctrl->maximum - qctrl->minimum)) /
>  				shutter_max + qctrl->minimum;
> @@ -333,7 +396,6 @@ static int mt9t031_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	struct v4l2_rect rect = a->c;
>  	struct i2c_client *client = sd->priv;
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
> -	struct soc_camera_device *icd = client->dev.platform_data;
>  
>  	rect.width = ALIGN(rect.width, 2);
>  	rect.height = ALIGN(rect.height, 2);
> @@ -344,7 +406,7 @@ static int mt9t031_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	soc_camera_limit_side(&rect.top, &rect.height,
>  		     MT9T031_ROW_SKIP, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT);
>  
> -	return mt9t031_set_params(icd, &rect, mt9t031->xskip, mt9t031->yskip);
> +	return mt9t031_set_params(client, &rect, mt9t031->xskip, mt9t031->yskip);
>  }
>  
>  static int mt9t031_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> @@ -391,7 +453,6 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd,
>  {
>  	struct i2c_client *client = sd->priv;
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
> -	struct soc_camera_device *icd = client->dev.platform_data;
>  	u16 xskip, yskip;
>  	struct v4l2_rect rect = mt9t031->rect;
>  
> @@ -403,7 +464,7 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd,
>  	yskip = mt9t031_skip(&rect.height, imgf->height, MT9T031_MAX_HEIGHT);
>  
>  	/* mt9t031_set_params() doesn't change width and height */
> -	return mt9t031_set_params(icd, &rect, xskip, yskip);
> +	return mt9t031_set_params(client, &rect, xskip, yskip);
>  }
>  
>  /*
> @@ -476,59 +537,6 @@ static int mt9t031_s_register(struct v4l2_subdev *sd,
>  }
>  #endif
>  
> -static const struct v4l2_queryctrl mt9t031_controls[] = {
> -	{
> -		.id		= V4L2_CID_VFLIP,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "Flip Vertically",
> -		.minimum	= 0,
> -		.maximum	= 1,
> -		.step		= 1,
> -		.default_value	= 0,
> -	}, {
> -		.id		= V4L2_CID_HFLIP,
> -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> -		.name		= "Flip Horizontally",
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
> -static struct soc_camera_ops mt9t031_ops = {
> -	.set_bus_param		= mt9t031_set_bus_param,
> -	.query_bus_param	= mt9t031_query_bus_param,
> -	.controls		= mt9t031_controls,
> -	.num_controls		= ARRAY_SIZE(mt9t031_controls),
> -};
> -
>  static int mt9t031_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
>  	struct i2c_client *client = sd->priv;
> @@ -565,15 +573,9 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
>  	struct i2c_client *client = sd->priv;
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
> -	struct soc_camera_device *icd = client->dev.platform_data;
>  	const struct v4l2_queryctrl *qctrl;
>  	int data;
>  
> -	qctrl = soc_camera_find_qctrl(&mt9t031_ops, ctrl->id);
> -
> -	if (!qctrl)
> -		return -EINVAL;
> -
>  	switch (ctrl->id) {
>  	case V4L2_CID_VFLIP:
>  		if (ctrl->value)
> @@ -592,6 +594,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  			return -EIO;
>  		break;
>  	case V4L2_CID_GAIN:
> +		qctrl = &mt9t031_controls[MT9T031_CTRL_GAIN];
>  		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
>  			return -EINVAL;
>  		/* See Datasheet Table 7, Gain settings. */
> @@ -631,6 +634,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  		mt9t031->gain = ctrl->value;
>  		break;
>  	case V4L2_CID_EXPOSURE:
> +		qctrl = &mt9t031_controls[MT9T031_CTRL_EXPOSURE];
>  		/* mt9t031 has maximum == default */
>  		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
>  			return -EINVAL;
> @@ -657,7 +661,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  
>  			if (set_shutter(client, total_h) < 0)
>  				return -EIO;
> -			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
> +			qctrl = &mt9t031_controls[MT9T031_CTRL_EXPOSURE];
>  			mt9t031->exposure = (shutter_max / 2 + (total_h - 1) *
>  				 (qctrl->maximum - qctrl->minimum)) /
>  				shutter_max + qctrl->minimum;
> @@ -665,6 +669,8 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  		} else
>  			mt9t031->autoexposure = 0;
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  	return 0;
>  }
> @@ -751,18 +757,16 @@ static int mt9t031_probe(struct i2c_client *client,
>  	struct mt9t031 *mt9t031;
>  	struct soc_camera_device *icd = client->dev.platform_data;
>  	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> -	struct soc_camera_link *icl;
>  	int ret;
>  
> -	if (!icd) {
> -		dev_err(&client->dev, "MT9T031: missing soc-camera data!\n");
> -		return -EINVAL;
> -	}
> +	if (icd) {
> +		struct soc_camera_link *icl = to_soc_camera_link(icd);
> +		if (!icl) {
> +			dev_err(&client->dev, "MT9T031 driver needs platform data\n");
> +			return -EINVAL;
> +		}
>  
> -	icl = to_soc_camera_link(icd);
> -	if (!icl) {
> -		dev_err(&client->dev, "MT9T031 driver needs platform data\n");
> -		return -EINVAL;
> +		icd->ops = &mt9t031_ops;
>  	}
>  
>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> @@ -777,9 +781,6 @@ static int mt9t031_probe(struct i2c_client *client,
>  
>  	v4l2_i2c_subdev_init(&mt9t031->subdev, client, &mt9t031_subdev_ops);
>  
> -	/* Second stage probe - when a capture adapter is there */
> -	icd->ops		= &mt9t031_ops;
> -
>  	mt9t031->rect.left	= MT9T031_COLUMN_SKIP;
>  	mt9t031->rect.top	= MT9T031_ROW_SKIP;
>  	mt9t031->rect.width	= MT9T031_MAX_WIDTH;
> @@ -801,7 +802,8 @@ static int mt9t031_probe(struct i2c_client *client,
>  	mt9t031_disable(client);
>  
>  	if (ret) {
> -		icd->ops = NULL;
> +		if (icd)
> +			icd->ops = NULL;
>  		i2c_set_clientdata(client, NULL);
>  		kfree(mt9t031);
>  	}
> @@ -814,7 +816,8 @@ static int mt9t031_remove(struct i2c_client *client)
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  	struct soc_camera_device *icd = client->dev.platform_data;
>  
> -	icd->ops = NULL;
> +	if (icd)
> +		icd->ops = NULL;
>  	i2c_set_clientdata(client, NULL);
>  	client->driver = NULL;
>  	kfree(mt9t031);



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
