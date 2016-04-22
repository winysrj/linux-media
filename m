Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:33820 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbcDVSz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 14:55:58 -0400
Received: by mail-lf0-f50.google.com with SMTP id j11so84476991lfb.1
        for <linux-media@vger.kernel.org>; Fri, 22 Apr 2016 11:55:57 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 22 Apr 2016 20:55:54 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: Re: [PATCH 3/6] rcar-vin: support the source change event and fix
 s_std
Message-ID: <20160422185554.GB23014@bigcity.dyn.berto.se>
References: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
 <1461330222-34096-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1461330222-34096-4-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Great patch,

On 2016-04-22 15:03:39 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The patch adds support for the source change event and it fixes
> the s_std support: changing the standard will also change the
> resolution, and that was never updated.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 48 +++++++++++++++++++++++++++--
>  1 file changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 8ac6149..49058ea 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -421,8 +421,25 @@ static int rvin_s_std(struct file *file, void *priv, v4l2_std_id a)
>  {
>  	struct rvin_dev *vin = video_drvdata(file);
>  	struct v4l2_subdev *sd = vin_to_sd(vin);
> +	struct v4l2_subdev_format fmt = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	struct v4l2_mbus_framefmt *mf = &fmt.format;
> +	int ret = v4l2_subdev_call(sd, video, s_std, a);
> +
> +	if (ret < 0)
> +		return ret;
>  
> -	return v4l2_subdev_call(sd, video, s_std, a);
> +	/* Changing the standard will change the width/height */
> +	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
> +	if (ret) {
> +		vin_err(vin, "Failed to get initial format\n");
> +		return ret;
> +	}
> +
> +	vin->format.width = mf->width;
> +	vin->format.height = mf->height;

I think you should reset the vin->crop and vin->compose v4l2_rect to 
match the new size here.

On this note I feel the documentation at 
https://linuxtv.org/downloads/v4l-dvb-apis/selection-api.html are a bit 
unclear. In the section 'Configuration of video capture' one can read:

"Each capture device has a default source rectangle, given by the 
V4L2_SEL_TGT_CROP_DEFAULT target. This rectangle shall over what the 
driver writer considers the complete picture. Drivers shall set the 
active crop rectangle to the default when the driver is first loaded, 
but not later."

For the driver to change this rectangle in s_std is that not in the 'but 
not later' category?

On the same note, should the crop and compose rectangles be reset if the 
user requests a resolution change with vidioc_s_fmt_vid_cap? 

> +	return 0;
>  }
>  
>  static int rvin_g_std(struct file *file, void *priv, v4l2_std_id *a)
> @@ -433,6 +450,16 @@ static int rvin_g_std(struct file *file, void *priv, v4l2_std_id *a)
>  	return v4l2_subdev_call(sd, video, g_std, a);
>  }
>  
> +static int rvin_subscribe_event(struct v4l2_fh *fh,
> +				const struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_SOURCE_CHANGE:
> +		return v4l2_event_subscribe(fh, sub, 4, NULL);
> +	}
> +	return v4l2_ctrl_subscribe_event(fh, sub);
> +}
> +
>  static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
>  	.vidioc_querycap		= rvin_querycap,
>  	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
> @@ -464,7 +491,7 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
>  	.vidioc_streamoff		= vb2_ioctl_streamoff,
>  
>  	.vidioc_log_status		= v4l2_ctrl_log_status,
> -	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_subscribe_event		= rvin_subscribe_event,
>  	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
>  };
>  
> @@ -623,6 +650,21 @@ void rvin_v4l2_remove(struct rvin_dev *vin)
>  	video_unregister_device(&vin->vdev);
>  }
>  
> +static void rvin_notify(struct v4l2_subdev *sd,
> +			unsigned int notification, void *arg)
> +{
> +	struct rvin_dev *vin =
> +		container_of(sd->v4l2_dev, struct rvin_dev, v4l2_dev);
> +
> +	switch (notification) {
> +	case V4L2_DEVICE_NOTIFY_EVENT:
> +		v4l2_event_queue(&vin->vdev, arg);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>  int rvin_v4l2_probe(struct rvin_dev *vin)
>  {
>  	struct v4l2_subdev_format fmt = {
> @@ -635,6 +677,8 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  
>  	v4l2_set_subdev_hostdata(sd, vin);
>  
> +	vin->v4l2_dev.notify = rvin_notify;
> +
>  	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
>  	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
>  		return ret;
> -- 
> 2.8.0.rc3
> 

-- 
Regards,
Niklas Söderlund
