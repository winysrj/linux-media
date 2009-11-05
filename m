Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3713 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbZKEPqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 10:46:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC 9/9] mt9t031: make the use of the soc-camera client API optional
Date: Thu, 5 Nov 2009 16:46:44 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange> <Pine.LNX.4.64.0910301442570.4378@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0910301442570.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200911051646.44619.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 30 October 2009 15:01:36 Guennadi Liakhovetski wrote:
> Now that we have moved most of the functions over to the v4l2-subdev API, only
> quering and setting bus parameters are still performed using the legacy
> soc-camera client API. Make the use of this API optional for mt9t031.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Muralidharan, this one is for you to test. To differentiate between the 
> soc-camera case and a generic user I check i2c client's platform data 
> (client->dev.platform_data), so, you have to make sure your user doesn't 
> use that field for something else.
> 
> One more note: I'm not sure about where v4l2_device_unregister_subdev() 
> should be called. In soc-camera the core calls 
> v4l2_i2c_new_subdev_board(), which then calls 
> v4l2_device_register_subdev(). Logically, it's also the core that then 
> calls v4l2_device_unregister_subdev(). Whereas I see many other client 
> drivers call v4l2_device_unregister_subdev() internally. So, if your 
> bridge driver does not call v4l2_device_unregister_subdev() itself and 
> expects the client to call it, there will be a slight problem with that 
> too.

The remove function of an i2c module should call v4l2_device_unregister_subdev.

>From the v4l2-framework.txt document:

"Make sure to call v4l2_device_unregister_subdev(sd) when the remove() callback
is called. This will unregister the sub-device from the bridge driver. It is
safe to call this even if the sub-device was never registered.

You need to do this because when the bridge driver destroys the i2c adapter
the remove() callbacks are called of the i2c devices on that adapter.
After that the corresponding v4l2_subdev structures are invalid, so they
have to be unregistered first. Calling v4l2_device_unregister_subdev(sd)
from the remove() callback ensures that this is always done correctly."

Note that this is something that will not normally happen on a SoC, but it
is common for USB or PCI devices.

Regards,

	Hans

> 
>  drivers/media/video/mt9t031.c |  146 ++++++++++++++++++++---------------------
>  1 files changed, 70 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> index c95c277..49357bd 100644
> --- a/drivers/media/video/mt9t031.c
> +++ b/drivers/media/video/mt9t031.c
> @@ -204,6 +204,59 @@ static unsigned long mt9t031_query_bus_param(struct soc_camera_device *icd)
>  	return soc_camera_apply_sensor_flags(icl, MT9T031_BUS_PARAM);
>  }
>  
> +static const struct v4l2_queryctrl mt9t031_controls[] = {
> +	{
> +		.id		= V4L2_CID_VFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Vertically",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	}, {
> +		.id		= V4L2_CID_HFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Horizontally",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	}, {
> +		.id		= V4L2_CID_GAIN,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Gain",
> +		.minimum	= 0,
> +		.maximum	= 127,
> +		.step		= 1,
> +		.default_value	= 64,
> +		.flags		= V4L2_CTRL_FLAG_SLIDER,
> +	}, {
> +		.id		= V4L2_CID_EXPOSURE,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Exposure",
> +		.minimum	= 1,
> +		.maximum	= 255,
> +		.step		= 1,
> +		.default_value	= 255,
> +		.flags		= V4L2_CTRL_FLAG_SLIDER,
> +	}, {
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
> @@ -223,10 +276,9 @@ static u16 mt9t031_skip(s32 *source, s32 target, s32 max)
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
> @@ -307,7 +359,7 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
>  		if (ret >= 0) {
>  			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
>  			const struct v4l2_queryctrl *qctrl =
> -				soc_camera_find_qctrl(icd->ops,
> +				soc_camera_find_qctrl(&mt9t031_ops,
>  						      V4L2_CID_EXPOSURE);
>  			mt9t031->exposure = (shutter_max / 2 + (total_h - 1) *
>  				 (qctrl->maximum - qctrl->minimum)) /
> @@ -333,7 +385,6 @@ static int mt9t031_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	struct v4l2_rect rect = a->c;
>  	struct i2c_client *client = sd->priv;
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
> -	struct soc_camera_device *icd = client->dev.platform_data;
>  
>  	rect.width = ALIGN(rect.width, 2);
>  	rect.height = ALIGN(rect.height, 2);
> @@ -344,7 +395,7 @@ static int mt9t031_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	soc_camera_limit_side(&rect.top, &rect.height,
>  		     MT9T031_ROW_SKIP, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT);
>  
> -	return mt9t031_set_params(icd, &rect, mt9t031->xskip, mt9t031->yskip);
> +	return mt9t031_set_params(client, &rect, mt9t031->xskip, mt9t031->yskip);
>  }
>  
>  static int mt9t031_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> @@ -391,7 +442,6 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd,
>  {
>  	struct i2c_client *client = sd->priv;
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
> -	struct soc_camera_device *icd = client->dev.platform_data;
>  	u16 xskip, yskip;
>  	struct v4l2_rect rect = mt9t031->rect;
>  
> @@ -403,7 +453,7 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd,
>  	yskip = mt9t031_skip(&rect.height, imgf->height, MT9T031_MAX_HEIGHT);
>  
>  	/* mt9t031_set_params() doesn't change width and height */
> -	return mt9t031_set_params(icd, &rect, xskip, yskip);
> +	return mt9t031_set_params(client, &rect, xskip, yskip);
>  }
>  
>  /*
> @@ -476,59 +526,6 @@ static int mt9t031_s_register(struct v4l2_subdev *sd,
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
> @@ -565,7 +562,6 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
>  	struct i2c_client *client = sd->priv;
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
> -	struct soc_camera_device *icd = client->dev.platform_data;
>  	const struct v4l2_queryctrl *qctrl;
>  	int data;
>  
> @@ -657,7 +653,8 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  
>  			if (set_shutter(client, total_h) < 0)
>  				return -EIO;
> -			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
> +			qctrl = soc_camera_find_qctrl(&mt9t031_ops,
> +						      V4L2_CID_EXPOSURE);
>  			mt9t031->exposure = (shutter_max / 2 + (total_h - 1) *
>  				 (qctrl->maximum - qctrl->minimum)) /
>  				shutter_max + qctrl->minimum;
> @@ -751,18 +748,16 @@ static int mt9t031_probe(struct i2c_client *client,
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
> @@ -777,9 +772,6 @@ static int mt9t031_probe(struct i2c_client *client,
>  
>  	v4l2_i2c_subdev_init(&mt9t031->subdev, client, &mt9t031_subdev_ops);
>  
> -	/* Second stage probe - when a capture adapter is there */
> -	icd->ops		= &mt9t031_ops;
> -
>  	mt9t031->rect.left	= MT9T031_COLUMN_SKIP;
>  	mt9t031->rect.top	= MT9T031_ROW_SKIP;
>  	mt9t031->rect.width	= MT9T031_MAX_WIDTH;
> @@ -801,7 +793,8 @@ static int mt9t031_probe(struct i2c_client *client,
>  	mt9t031_disable(client);
>  
>  	if (ret) {
> -		icd->ops = NULL;
> +		if (icd)
> +			icd->ops = NULL;
>  		i2c_set_clientdata(client, NULL);
>  		kfree(mt9t031);
>  	}
> @@ -814,7 +807,8 @@ static int mt9t031_remove(struct i2c_client *client)
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
