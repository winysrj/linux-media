Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3679 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab1AYHyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jan 2011 02:54:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC PATCH 03/12] mt9m001: convert to the control framework.
Date: Tue, 25 Jan 2011 08:54:09 +0100
Cc: linux-media@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl> <47023fea8af2dd4be5c03491427bf0edd2592cb6.1294786597.git.hverkuil@xs4all.nl> <Pine.LNX.4.64.1101222135010.31015@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1101222135010.31015@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101250854.09148.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, January 22, 2011 22:21:23 Guennadi Liakhovetski wrote:
> On Wed, 12 Jan 2011, Hans Verkuil wrote:
> 
> > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> > ---
> >  drivers/media/video/mt9m001.c |  210 +++++++++++++++--------------------------
> >  1 files changed, 75 insertions(+), 135 deletions(-)
> > 
> > diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
> > index f7fc88d..b9b6e33 100644
> > --- a/drivers/media/video/mt9m001.c
> > +++ b/drivers/media/video/mt9m001.c
> > @@ -15,6 +15,7 @@
> >  
> >  #include <media/v4l2-subdev.h>
> >  #include <media/v4l2-chip-ident.h>
> > +#include <media/v4l2-ctrls.h>
> >  #include <media/soc_camera.h>
> >  
> >  /*
> > @@ -84,15 +85,18 @@ static const struct mt9m001_datafmt mt9m001_monochrome_fmts[] = {
> >  
> >  struct mt9m001 {
> >  	struct v4l2_subdev subdev;
> > +	struct v4l2_ctrl_handler hdl;
> > +	struct {
> > +		/* exposure/auto-exposure cluster */
> > +		struct v4l2_ctrl *autoexposure;
> > +		struct v4l2_ctrl *exposure;
> > +	};
> 
> Hm, why an anonymous struct? Why not just put them directly at the top 
> level?

There are a few ways you can declare control clusters. This is the most obvious:

struct v4l2_ctrl *exp_cluster[2];

The only problem with this is that it is very annoying if you have to access
one of these controls: doing 'state->exp_cluster[CTRL_EXPOSURE]->cur.val' is
quite a mouthful.

The other approach is to define the pointers directly at top level:

struct mt9m001 {
	...
	/* exposure/auto-exposure cluster */
	struct v4l2_ctrl *autoexposure;
	struct v4l2_ctrl *exposure;
};

The problem with that is that it isn't clear that this is a unit and that
you can't just add a field in between.

Using an anonymous struct will 1) keep the ease of use and 2) visually put
these pointers together in a unit.

I've been using it everywhere I need to make a control cluster and it works
very nicely.
 
> >  	struct v4l2_rect rect;	/* Sensor window */
> >  	const struct mt9m001_datafmt *fmt;
> >  	const struct mt9m001_datafmt *fmts;
> >  	int num_fmts;
> >  	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
> > -	unsigned int gain;
> > -	unsigned int exposure;
> >  	unsigned short y_skip_top;	/* Lines to skip at the top */
> > -	unsigned char autoexposure;
> >  };
> >  
> >  static struct mt9m001 *to_mt9m001(const struct i2c_client *client)
> > @@ -209,7 +213,6 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> >  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >  	struct mt9m001 *mt9m001 = to_mt9m001(client);
> >  	struct v4l2_rect rect = a->c;
> > -	struct soc_camera_device *icd = client->dev.platform_data;
> >  	int ret;
> >  	const u16 hblank = 9, vblank = 25;
> >  	unsigned int total_h;
> > @@ -251,17 +254,18 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> >  	if (!ret)
> >  		ret = reg_write(client, MT9M001_WINDOW_HEIGHT,
> >  				rect.height + mt9m001->y_skip_top - 1);
> > -	if (!ret && mt9m001->autoexposure) {
> > +	v4l2_ctrl_lock(mt9m001->autoexposure);
> > +	if (!ret && mt9m001->autoexposure->cur.val == V4L2_EXPOSURE_AUTO) {
> >  		ret = reg_write(client, MT9M001_SHUTTER_WIDTH, total_h);
> >  		if (!ret) {
> > -			const struct v4l2_queryctrl *qctrl =
> > -				soc_camera_find_qctrl(icd->ops,
> > -						      V4L2_CID_EXPOSURE);
> > -			mt9m001->exposure = (524 + (total_h - 1) *
> > -				 (qctrl->maximum - qctrl->minimum)) /
> > -				1048 + qctrl->minimum;
> > +			struct v4l2_ctrl *ctrl = mt9m001->exposure;
> > +
> > +			ctrl->cur.val = (524 + (total_h - 1) *
> > +				 (ctrl->maximum - ctrl->minimum)) /
> > +				1048 + ctrl->minimum;
> >  		}
> >  	}
> > +	v4l2_ctrl_unlock(mt9m001->autoexposure);
> >  
> >  	if (!ret)
> >  		mt9m001->rect = rect;
> > @@ -421,107 +425,36 @@ static int mt9m001_s_register(struct v4l2_subdev *sd,
> >  }
> >  #endif
> >  
> > -static const struct v4l2_queryctrl mt9m001_controls[] = {
> > -	{
> > -		.id		= V4L2_CID_VFLIP,
> > -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> > -		.name		= "Flip Vertically",
> > -		.minimum	= 0,
> > -		.maximum	= 1,
> > -		.step		= 1,
> > -		.default_value	= 0,
> > -	}, {
> > -		.id		= V4L2_CID_GAIN,
> > -		.type		= V4L2_CTRL_TYPE_INTEGER,
> > -		.name		= "Gain",
> > -		.minimum	= 0,
> > -		.maximum	= 127,
> > -		.step		= 1,
> > -		.default_value	= 64,
> > -		.flags		= V4L2_CTRL_FLAG_SLIDER,
> > -	}, {
> > -		.id		= V4L2_CID_EXPOSURE,
> > -		.type		= V4L2_CTRL_TYPE_INTEGER,
> > -		.name		= "Exposure",
> > -		.minimum	= 1,
> > -		.maximum	= 255,
> > -		.step		= 1,
> > -		.default_value	= 255,
> > -		.flags		= V4L2_CTRL_FLAG_SLIDER,
> > -	}, {
> > -		.id		= V4L2_CID_EXPOSURE_AUTO,
> > -		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> > -		.name		= "Automatic Exposure",
> > -		.minimum	= 0,
> > -		.maximum	= 1,
> > -		.step		= 1,
> > -		.default_value	= 1,
> > -	}
> > -};
> > -
> >  static struct soc_camera_ops mt9m001_ops = {
> >  	.set_bus_param		= mt9m001_set_bus_param,
> >  	.query_bus_param	= mt9m001_query_bus_param,
> > -	.controls		= mt9m001_controls,
> > -	.num_controls		= ARRAY_SIZE(mt9m001_controls),
> >  };
> >  
> > -static int mt9m001_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> > +static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
> >  {
> > +	struct v4l2_subdev *sd =
> > +		&container_of(ctrl->handler, struct mt9m001, hdl)->subdev;
> >  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >  	struct mt9m001 *mt9m001 = to_mt9m001(client);
> 
> This looks a bit clumsy to me, sorry. Above you already have "struct 
> mt9m001 *" (container_of(ctrl->handler, struct mt9m001, hdl)), but you 
> only use it implicitly to get to sd, and then mt9m001 is calculated 
> again...

Yeah, I'll improve this.

> 
> > +	struct v4l2_ctrl *exp = mt9m001->exposure;
> >  	int data;
> >  
> >  	switch (ctrl->id) {
> >  	case V4L2_CID_VFLIP:
> > -		data = reg_read(client, MT9M001_READ_OPTIONS2);
> > -		if (data < 0)
> > -			return -EIO;
> > -		ctrl->value = !!(data & 0x8000);
> > -		break;
> > -	case V4L2_CID_EXPOSURE_AUTO:
> > -		ctrl->value = mt9m001->autoexposure;
> > -		break;
> > -	case V4L2_CID_GAIN:
> > -		ctrl->value = mt9m001->gain;
> > -		break;
> > -	case V4L2_CID_EXPOSURE:
> > -		ctrl->value = mt9m001->exposure;
> > -		break;
> > -	}
> > -	return 0;
> > -}
> > -
> > -static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> > -{
> > -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > -	struct mt9m001 *mt9m001 = to_mt9m001(client);
> > -	struct soc_camera_device *icd = client->dev.platform_data;
> > -	const struct v4l2_queryctrl *qctrl;
> > -	int data;
> > -
> > -	qctrl = soc_camera_find_qctrl(&mt9m001_ops, ctrl->id);
> > -
> > -	if (!qctrl)
> > -		return -EINVAL;
> > -
> > -	switch (ctrl->id) {
> > -	case V4L2_CID_VFLIP:
> > -		if (ctrl->value)
> > +		if (ctrl->val)
> >  			data = reg_set(client, MT9M001_READ_OPTIONS2, 0x8000);
> >  		else
> >  			data = reg_clear(client, MT9M001_READ_OPTIONS2, 0x8000);
> >  		if (data < 0)
> >  			return -EIO;
> > -		break;
> > +		return 0;
> > +
> >  	case V4L2_CID_GAIN:
> > -		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
> > -			return -EINVAL;
> >  		/* See Datasheet Table 7, Gain settings. */
> > -		if (ctrl->value <= qctrl->default_value) {
> > +		if (ctrl->val <= ctrl->default_value) {
> >  			/* Pack it into 0..1 step 0.125, register values 0..8 */
> > -			unsigned long range = qctrl->default_value - qctrl->minimum;
> > -			data = ((ctrl->value - qctrl->minimum) * 8 + range / 2) / range;
> > +			unsigned long range = ctrl->default_value - ctrl->minimum;
> > +			data = ((ctrl->val - ctrl->minimum) * 8 + range / 2) / range;
> >  
> >  			dev_dbg(&client->dev, "Setting gain %d\n", data);
> >  			data = reg_write(client, MT9M001_GLOBAL_GAIN, data);
> > @@ -530,8 +463,8 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> >  		} else {
> >  			/* Pack it into 1.125..15 variable step, register values 9..67 */
> >  			/* We assume qctrl->maximum - qctrl->default_value - 1 > 0 */
> > -			unsigned long range = qctrl->maximum - qctrl->default_value - 1;
> > -			unsigned long gain = ((ctrl->value - qctrl->default_value - 1) *
> > +			unsigned long range = ctrl->maximum - ctrl->default_value - 1;
> > +			unsigned long gain = ((ctrl->val - ctrl->default_value - 1) *
> >  					       111 + range / 2) / range + 9;
> >  
> >  			if (gain <= 32)
> > @@ -547,47 +480,36 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> >  			if (data < 0)
> >  				return -EIO;
> >  		}
> > +		return 0;
> >  
> > -		/* Success */
> > -		mt9m001->gain = ctrl->value;
> > -		break;
> > -	case V4L2_CID_EXPOSURE:
> > -		/* mt9m001 has maximum == default */
> > -		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
> > -			return -EINVAL;
> > -		else {
> > -			unsigned long range = qctrl->maximum - qctrl->minimum;
> > -			unsigned long shutter = ((ctrl->value - qctrl->minimum) * 1048 +
> > +	case V4L2_CID_EXPOSURE_AUTO:
> > +		/* Force manual exposure if only the exposure was changed */
> > +		if (!ctrl->has_new)
> > +			ctrl->val = V4L2_EXPOSURE_MANUAL;
> > +		if (ctrl->val == V4L2_EXPOSURE_MANUAL) {
> > +			unsigned long range = exp->maximum - exp->minimum;
> > +			unsigned long shutter = ((exp->val - exp->minimum) * 1048 +
> >  						 range / 2) / range + 1;
> >  
> >  			dev_dbg(&client->dev,
> >  				"Setting shutter width from %d to %lu\n",
> > -				reg_read(client, MT9M001_SHUTTER_WIDTH),
> > -				shutter);
> > +				reg_read(client, MT9M001_SHUTTER_WIDTH), shutter);
> >  			if (reg_write(client, MT9M001_SHUTTER_WIDTH, shutter) < 0)
> >  				return -EIO;
> > -			mt9m001->exposure = ctrl->value;
> > -			mt9m001->autoexposure = 0;
> > -		}
> > -		break;
> > -	case V4L2_CID_EXPOSURE_AUTO:
> > -		if (ctrl->value) {
> > +		} else {
> >  			const u16 vblank = 25;
> >  			unsigned int total_h = mt9m001->rect.height +
> >  				mt9m001->y_skip_top + vblank;
> > -			if (reg_write(client, MT9M001_SHUTTER_WIDTH,
> > -				      total_h) < 0)
> > +
> > +			if (reg_write(client, MT9M001_SHUTTER_WIDTH, total_h) < 0)
> >  				return -EIO;
> > -			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
> > -			mt9m001->exposure = (524 + (total_h - 1) *
> > -				 (qctrl->maximum - qctrl->minimum)) /
> > -				1048 + qctrl->minimum;
> > -			mt9m001->autoexposure = 1;
> > -		} else
> > -			mt9m001->autoexposure = 0;
> > -		break;
> > +			exp->val = (524 + (total_h - 1) *
> > +					(exp->maximum - exp->minimum)) / 1048 +
> > +						exp->minimum;
> > +		}
> > +		return 0;
> >  	}
> > -	return 0;
> > +	return -EINVAL;
> 
> It seems to me, that you've dropped V4L2_CID_EXPOSURE here, was it 
> intentional? I won't verify this in detail now, because, if it wasn't 
> intentional and you fix it in v2, I'll have to re-check it anyway. Or is 
> it supposed to be handled by that V4L2_EXPOSURE_MANUAL? So, if the user 
> issues a V4L2_CID_EXPOSURE, are you getting V4L2_CID_EXPOSURE_AUTO with 
> val == V4L2_EXPOSURE_MANUAL instead? Weird...

If you cluster multiple controls (i.e. controls that need to be set atomically
for one reason or another), then whenever the application changes one or more
controls in that cluster only one call to s_ctrl will be made with the ID of
the first (aka 'master') control of the cluster. All the new values of all the
controls in the cluster are filled in, ready to be applied. Since EXPOSURE_AUTO
is the first control in the cluster, that's the ID you get here.

While this is all documented in v4l2-controls.txt your question makes it clear
that I need to add a comment before case statements like this.

> 
> >  }
> >  
> >  /*
> > @@ -665,10 +587,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
> >  		dev_err(&client->dev, "Failed to initialise the camera\n");
> >  
> >  	/* mt9m001_init() has reset the chip, returning registers to defaults */
> > -	mt9m001->gain = 64;
> > -	mt9m001->exposure = 255;
> > -
> > -	return ret;
> > +	return v4l2_ctrl_handler_setup(&mt9m001->hdl);
> >  }
> >  
> >  static void mt9m001_video_remove(struct soc_camera_device *icd)
> > @@ -691,9 +610,11 @@ static int mt9m001_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
> >  	return 0;
> >  }
> >  
> > +static const struct v4l2_ctrl_ops mt9m001_ctrl_ops = {
> > +	.s_ctrl = mt9m001_s_ctrl,
> > +};
> > +
> >  static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
> > -	.g_ctrl		= mt9m001_g_ctrl,
> > -	.s_ctrl		= mt9m001_s_ctrl,
> >  	.g_chip_ident	= mt9m001_g_chip_ident,
> >  #ifdef CONFIG_VIDEO_ADV_DEBUG
> >  	.g_register	= mt9m001_g_register,
> > @@ -766,6 +687,28 @@ static int mt9m001_probe(struct i2c_client *client,
> >  		return -ENOMEM;
> >  
> >  	v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_ops);
> > +	v4l2_ctrl_handler_init(&mt9m001->hdl, 4);
> > +	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
> > +			V4L2_CID_VFLIP, 0, 1, 1, 0);
> > +	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
> > +			V4L2_CID_GAIN, 0, 127, 1, 64);
> > +	mt9m001->exposure = v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
> > +			V4L2_CID_EXPOSURE, 1, 255, 1, 255);
> > +	/*
> > +	 * Simulated autoexposure. If enabled, we calculate shutter width
> > +	 * ourselves in the driver based on vertical blanking and frame width
> > +	 */
> > +	mt9m001->autoexposure = v4l2_ctrl_new_std_menu(&mt9m001->hdl,
> > +			&mt9m001_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
> > +			V4L2_EXPOSURE_AUTO);
> > +	mt9m001->subdev.ctrl_handler = &mt9m001->hdl;
> > +	if (mt9m001->hdl.error) {
> > +		int err = mt9m001->hdl.error;
> > +
> > +		kfree(mt9m001);
> > +		return err;
> > +	}
> > +	v4l2_ctrl_cluster(2, &mt9m001->autoexposure);
> 
> Ooh, is this the reason for that anonymous struct?...
> 
> >  
> >  	/* Second stage probe - when a capture adapter is there */
> >  	icd->ops		= &mt9m001_ops;
> > @@ -776,15 +719,10 @@ static int mt9m001_probe(struct i2c_client *client,
> >  	mt9m001->rect.width	= MT9M001_MAX_WIDTH;
> >  	mt9m001->rect.height	= MT9M001_MAX_HEIGHT;
> >  
> > -	/*
> > -	 * Simulated autoexposure. If enabled, we calculate shutter width
> > -	 * ourselves in the driver based on vertical blanking and frame width
> > -	 */
> > -	mt9m001->autoexposure = 1;
> > -
> >  	ret = mt9m001_video_probe(icd, client);
> >  	if (ret) {
> >  		icd->ops = NULL;
> > +		v4l2_ctrl_handler_free(&mt9m001->hdl);
> >  		kfree(mt9m001);
> >  	}
> >  
> > @@ -796,6 +734,8 @@ static int mt9m001_remove(struct i2c_client *client)
> >  	struct mt9m001 *mt9m001 = to_mt9m001(client);
> >  	struct soc_camera_device *icd = client->dev.platform_data;
> >  
> > +	v4l2_device_unregister_subdev(&mt9m001->subdev);
> 
> hm, first, this is not really related, right? Secondly, are you sure this 
> is needed? It is now double with soc_camera_remove(). I know, it is safe, 
> but still, one of them looks superfluous to me.

As long as this subdev is only used with soc_camera, then this isn't needed.
But we are now getting close to the point where these subdevs are no longer
tied to soc_camera. And as soon as they can be used in e.g. USB devices, then
this call is needed. Many (all?) USB drivers will not unregister the subdevs
before removing the i2c adapter, instead they just delete the i2c adapter,
which forces the removal of all attached i2c drivers. So any i2c subdev drivers
need to call the unregister_subdev themselves as part of the cleanup.

This is actually documented in v4l2-framework.txt. It's not pretty, but unless
all drivers are audited for the order in which they clean up their subdevs and
i2c adapter we have to support both methods.

So this is a preparation for the moment the last connection to soc_camera is
removed.

If you really don't want this, then I can remove it. But then we must remember
to put this back later.

> 
> > +	v4l2_ctrl_handler_free(&mt9m001->hdl);
> >  	icd->ops = NULL;
> >  	mt9m001_video_remove(icd);
> >  	kfree(mt9m001);
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
