Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40619 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3BCPfq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 10:35:46 -0500
Received: by mail-pa0-f50.google.com with SMTP id fa11so362718pad.37
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 07:35:46 -0800 (PST)
Message-ID: <510F3B78.3020700@gmail.com>
Date: Sun, 03 Feb 2013 23:39:20 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 10/18] tlg2300: embed video_device.
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <b7465542a57ac28f1c9d54bfb11766e8c8f35e64.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <b7465542a57ac28f1c9d54bfb11766e8c8f35e64.1359627298.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年01月31日 05:25, Hans Verkuil 写道:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-common.h |    6 ++--
>  drivers/media/usb/tlg2300/pd-video.c  |   55 +++++++--------------------------
>  2 files changed, 13 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
> index 67ad065..052cb0c 100644
> --- a/drivers/media/usb/tlg2300/pd-common.h
> +++ b/drivers/media/usb/tlg2300/pd-common.h
> @@ -40,7 +40,7 @@
>  #define TUNER_FREQ_MAX		(862000000)
>  
>  struct vbi_data {
> -	struct video_device	*v_dev;
> +	struct video_device	v_dev;
>  	struct video_data	*video;
>  	struct front_face	*front;
>  
> @@ -63,7 +63,7 @@ struct running_context {
>  
>  struct video_data {
>  	/* v4l2 video device */
> -	struct video_device	*v_dev;
> +	struct video_device	v_dev;
>  
>  	/* the working context */
>  	struct running_context	context;
> @@ -234,7 +234,6 @@ void dvb_stop_streaming(struct pd_dvb_adapter *);
>  /* FM */
>  int poseidon_fm_init(struct poseidon *);
>  int poseidon_fm_exit(struct poseidon *);
> -struct video_device *vdev_init(struct poseidon *, struct video_device *);
>  
>  /* vendor command ops */
>  int send_set_req(struct poseidon*, u8, s32, s32*);
> @@ -250,7 +249,6 @@ void free_all_urb_generic(struct urb **urb_array, int num);
>  
>  /* misc */
>  void poseidon_delete(struct kref *kref);
> -void destroy_video_device(struct video_device **v_dev);
>  extern int debug_mode;
>  void set_debug_mode(struct video_device *vfd, int debug_mode);
>  
> diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
> index 2172337..312809a 100644
> --- a/drivers/media/usb/tlg2300/pd-video.c
> +++ b/drivers/media/usb/tlg2300/pd-video.c
> @@ -1590,48 +1590,18 @@ static struct video_device pd_video_template = {
>  	.name = "Telegent-Video",
>  	.fops = &pd_video_fops,
>  	.minor = -1,
> -	.release = video_device_release,
> +	.release = video_device_release_empty,
>  	.tvnorms = V4L2_STD_ALL,
>  	.ioctl_ops = &pd_video_ioctl_ops,
>  };
>  
> -struct video_device *vdev_init(struct poseidon *pd, struct video_device *tmp)
> -{
> -	struct video_device *vfd;
> -
> -	vfd = video_device_alloc();
> -	if (vfd == NULL)
> -		return NULL;
> -	*vfd		= *tmp;
> -	vfd->minor	= -1;
> -	vfd->v4l2_dev	= &pd->v4l2_dev;
> -	/*vfd->parent	= &(pd->udev->dev); */
> -	vfd->release	= video_device_release;
> -	video_set_drvdata(vfd, pd);
> -	return vfd;
> -}
> -
> -void destroy_video_device(struct video_device **v_dev)
> -{
> -	struct video_device *dev = *v_dev;
> -
> -	if (dev == NULL)
> -		return;
> -
> -	if (video_is_registered(dev))
> -		video_unregister_device(dev);
> -	else
> -		video_device_release(dev);
> -	*v_dev = NULL;
> -}
> -
>  void pd_video_exit(struct poseidon *pd)
>  {
>  	struct video_data *video = &pd->video_data;
>  	struct vbi_data *vbi = &pd->vbi_data;
>  
> -	destroy_video_device(&video->v_dev);
> -	destroy_video_device(&vbi->v_dev);
> +	video_unregister_device(&video->v_dev);
> +	video_unregister_device(&vbi->v_dev);
>  	log();
>  }
>  
> @@ -1641,21 +1611,19 @@ int pd_video_init(struct poseidon *pd)
>  	struct vbi_data *vbi	= &pd->vbi_data;
>  	int ret = -ENOMEM;
>  
> -	video->v_dev = vdev_init(pd, &pd_video_template);
> -	if (video->v_dev == NULL)
> -		goto out;
> +	video->v_dev = pd_video_template;
> +	video->v_dev.v4l2_dev = &pd->v4l2_dev;
> +	video_set_drvdata(&video->v_dev, pd);
>  
> -	ret = video_register_device(video->v_dev, VFL_TYPE_GRABBER, -1);
> +	ret = video_register_device(&video->v_dev, VFL_TYPE_GRABBER, -1);
>  	if (ret != 0)
>  		goto out;
>  
>  	/* VBI uses the same template as video */
> -	vbi->v_dev = vdev_init(pd, &pd_video_template);
> -	if (vbi->v_dev == NULL) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -	ret = video_register_device(vbi->v_dev, VFL_TYPE_VBI, -1);
> +	vbi->v_dev = pd_video_template;
> +	vbi->v_dev.v4l2_dev = &pd->v4l2_dev;
> +	video_set_drvdata(&vbi->v_dev, pd);
> +	ret = video_register_device(&vbi->v_dev, VFL_TYPE_VBI, -1);
>  	if (ret != 0)
>  		goto out;
>  	log("register VIDEO/VBI devices");
> @@ -1665,4 +1633,3 @@ out:
>  	pd_video_exit(pd);
>  	return ret;
>  }
> -
Acked-by: Huang Shijie <shijie8@gmail.com>
