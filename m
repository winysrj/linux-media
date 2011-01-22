Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:55758 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1AVXpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 18:45:18 -0500
Date: Sun, 23 Jan 2011 00:45:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [RFC PATCH 04/12] mt9m111.c: convert to the control framework.
In-Reply-To: <56c1a8ef6e1a5405881611a18579db98e271fb86.1294786597.git.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1101230032110.1872@axis700.grange>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
 <56c1a8ef6e1a5405881611a18579db98e271fb86.1294786597.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 12 Jan 2011, Hans Verkuil wrote:

> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/mt9m111.c |  184 ++++++++++++-----------------------------
>  1 files changed, 54 insertions(+), 130 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index 53fa2a7..2328579 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c

[snip]

> -static int mt9m111_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +static int mt9m111_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> +	struct v4l2_subdev *sd =
> +		&container_of(ctrl->handler, struct mt9m111, hdl)->subdev;
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct mt9m111 *mt9m111 = to_mt9m111(client);
> -	const struct v4l2_queryctrl *qctrl;
> -	int ret;
> -
> -	qctrl = soc_camera_find_qctrl(&mt9m111_ops, ctrl->id);
> -	if (!qctrl)
> -		return -EINVAL;
>  
>  	switch (ctrl->id) {
>  	case V4L2_CID_VFLIP:
> -		mt9m111->vflip = ctrl->value;
> -		ret = mt9m111_set_flip(client, ctrl->value,
> +		return mt9m111_set_flip(client, ctrl->val,
>  					MT9M111_RMB_MIRROR_ROWS);
> -		break;
>  	case V4L2_CID_HFLIP:
> -		mt9m111->hflip = ctrl->value;
> -		ret = mt9m111_set_flip(client, ctrl->value,
> +		return mt9m111_set_flip(client, ctrl->val,
>  					MT9M111_RMB_MIRROR_COLS);
> -		break;
>  	case V4L2_CID_GAIN:
> -		ret = mt9m111_set_global_gain(client, ctrl->value);
> -		break;
> +		return mt9m111_set_global_gain(client, ctrl->val);
> +
>  	case V4L2_CID_EXPOSURE_AUTO:
> -		ret =  mt9m111_set_autoexposure(client, ctrl->value);
> -		break;
> +		return mt9m111_set_autoexposure(client, ctrl->val);
> +
>  	case V4L2_CID_AUTO_WHITE_BALANCE:
> -		ret =  mt9m111_set_autowhitebalance(client, ctrl->value);
> -		break;
> -	default:
> -		ret = -EINVAL;
> +		return mt9m111_set_autowhitebalance(client, ctrl->val);
>  	}
> -
> -	return ret;
> +	return -EINVAL;
>  }
>  
>  static int mt9m111_suspend(struct soc_camera_device *icd, pm_message_t state)

[snip]

> @@ -1067,6 +968,26 @@ static int mt9m111_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  
>  	v4l2_i2c_subdev_init(&mt9m111->subdev, client, &mt9m111_subdev_ops);
> +	v4l2_ctrl_handler_init(&mt9m111->hdl, 5);
> +	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
> +			V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
> +			V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
> +			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
> +	mt9m111->gain = v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
> +			V4L2_CID_GAIN, 0, 63 * 2 * 2, 1, 32);
> +	v4l2_ctrl_new_std_menu(&mt9m111->hdl,
> +			&mt9m111_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
> +			V4L2_EXPOSURE_AUTO);
> +	mt9m111->subdev.ctrl_handler = &mt9m111->hdl;
> +	if (mt9m111->hdl.error) {
> +		int err = mt9m111->hdl.error;
> +
> +		kfree(mt9m111);
> +		return err;
> +	}
> +	mt9m111->gain->is_volatile = 1;

I'm not sure I like this approach: you register each control separately, 
but with the same handler, and then in that handler you switch-case again 
to find out which control has to be processed... If we already register 
them separately, and they share no code, apart from context extraction 
from parameters - why not make separate handlers, waste some memory on a 
couple more structs, but avoid run-time switching (I know it is not 
critical, although, with still photo-shooting you might want to care about 
the time between your controls and the actual shot), and win clarity?

>  
>  	/* Second stage probe - when a capture adapter is there */
>  	icd->ops		= &mt9m111_ops;
> @@ -1080,6 +1001,7 @@ static int mt9m111_probe(struct i2c_client *client,
>  	ret = mt9m111_video_probe(icd, client);
>  	if (ret) {
>  		icd->ops = NULL;
> +		v4l2_ctrl_handler_free(&mt9m111->hdl);
>  		kfree(mt9m111);
>  	}
>  
> @@ -1091,7 +1013,9 @@ static int mt9m111_remove(struct i2c_client *client)
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  	struct soc_camera_device *icd = client->dev.platform_data;
>  
> +	v4l2_device_unregister_subdev(&mt9m111->subdev);

Same here - don't like redundancy with soc_camera.c

Thanks
Guennadi

>  	icd->ops = NULL;
> +	v4l2_ctrl_handler_free(&mt9m111->hdl);
>  	kfree(mt9m111);
>  
>  	return 0;
> -- 
> 1.7.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
