Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3871 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab3DVHwr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 03:52:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Leonid Kegulskiy <leo@lumanate.com>
Subject: Re: [PATCH] [media] hdpvr: error handling and alloc abuse cleanup.
Date: Mon, 22 Apr 2013 09:52:28 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1366615383-12380-1-git-send-email-leo@lumanate.com>
In-Reply-To: <1366615383-12380-1-git-send-email-leo@lumanate.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304220952.28105.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon April 22 2013 09:23:03 Leonid Kegulskiy wrote:
> Removed unnecessary use of kzalloc() in get_video_info().
> Removed unnecessary  get_video_info() call from hdpvr_device_init().
> Cleaned up error handling in hdpvr_start_streaming() to ensure
> caller gets a failure status if device is not functioning properly.
> Cleaned up error handling in vidioc_querystd(),
> vidioc_query_dv_timings() and vidioc_g_fmt_vid_cap().
> This change also causes vidioc_g_fmt_vid_cap() not to return
> -EFAULT when video lock is not detected, but return empty
> width/height fields (legacy mode only). This new behavior is
> supported by MythTV.

Hi Leonid,

Can you split this patch up in smaller pieces? Basically in the order
of the changes you mention in your commit log. That makes it a lot
easier to review.

In particular the last change (-EFAULT) needs its own patch. That makes
it easy to revert should that become necessary.

Regards,

	Hans

> 
> Signed-off-by: Leonid Kegulskiy <leo@lumanate.com>
> ---
>  drivers/media/usb/hdpvr/hdpvr-control.c |   20 ++-------
>  drivers/media/usb/hdpvr/hdpvr-core.c    |    8 ----
>  drivers/media/usb/hdpvr/hdpvr-video.c   |   70 +++++++++++++++++--------------
>  drivers/media/usb/hdpvr/hdpvr.h         |    2 +-
>  4 files changed, 43 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
> index ae8f229..16d2d64 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-control.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-control.c
> @@ -45,20 +45,10 @@ int hdpvr_config_call(struct hdpvr_device *dev, uint value, u8 valbuf)
>  	return ret < 0 ? ret : 0;
>  }
>  
> -struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
> +int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
>  {
> -	struct hdpvr_video_info *vidinf = NULL;
> -#ifdef HDPVR_DEBUG
> -	char print_buf[15];
> -#endif
>  	int ret;
>  
> -	vidinf = kzalloc(sizeof(struct hdpvr_video_info), GFP_KERNEL);
> -	if (!vidinf) {
> -		v4l2_err(&dev->v4l2_dev, "out of memory\n");
> -		goto err;
> -	}
> -
>  	mutex_lock(&dev->usbc_mutex);
>  	ret = usb_control_msg(dev->udev,
>  			      usb_rcvctrlpipe(dev->udev, 0),
> @@ -74,6 +64,7 @@ struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
>  
>  #ifdef HDPVR_DEBUG
>  	if (hdpvr_debug & MSG_INFO) {
> +		char print_buf[15];
>  		hex_dump_to_buffer(dev->usbc_buf, 5, 16, 1, print_buf,
>  				   sizeof(print_buf), 0);
>  		v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
> @@ -82,12 +73,7 @@ struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
>  #endif
>  	mutex_unlock(&dev->usbc_mutex);
>  
> -	if (!vidinf->width || !vidinf->height || !vidinf->fps) {
> -		kfree(vidinf);
> -		vidinf = NULL;
> -	}
> -err:
> -	return vidinf;
> +	return ret < 0 ? ret : 0;
>  }
>  
>  int get_input_lines_info(struct hdpvr_device *dev)
> diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
> index 8247c19..cb69405 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-core.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-core.c
> @@ -220,7 +220,6 @@ static int hdpvr_device_init(struct hdpvr_device *dev)
>  {
>  	int ret;
>  	u8 *buf;
> -	struct hdpvr_video_info *vidinf;
>  
>  	if (device_authorization(dev))
>  		return -EACCES;
> @@ -242,13 +241,6 @@ static int hdpvr_device_init(struct hdpvr_device *dev)
>  		 "control request returned %d\n", ret);
>  	mutex_unlock(&dev->usbc_mutex);
>  
> -	vidinf = get_video_info(dev);
> -	if (!vidinf)
> -		v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
> -			"no valid video signal or device init failed\n");
> -	else
> -		kfree(vidinf);
> -
>  	/* enable fan and bling leds */
>  	mutex_lock(&dev->usbc_mutex);
>  	buf[0] = 0x1;
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index 774ba0e..5e8d6c2 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -277,20 +277,21 @@ error:
>  static int hdpvr_start_streaming(struct hdpvr_device *dev)
>  {
>  	int ret;
> -	struct hdpvr_video_info *vidinf;
> +	struct hdpvr_video_info vidinf;
>  
>  	if (dev->status == STATUS_STREAMING)
>  		return 0;
>  	else if (dev->status != STATUS_IDLE)
>  		return -EAGAIN;
>  
> -	vidinf = get_video_info(dev);
> +	ret = get_video_info(dev, &vidinf);
> +	if (ret)		/* device is dead */
> +		return ret;	/* let the caller know */
>  
> -	if (vidinf) {
> +	if (vidinf.width && vidinf.height) {
>  		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
> -			 "video signal: %dx%d@%dhz\n", vidinf->width,
> -			 vidinf->height, vidinf->fps);
> -		kfree(vidinf);
> +			 "video signal: %dx%d@%dhz\n", vidinf.width,
> +			 vidinf.height, vidinf.fps);
>  
>  		/* start streaming 2 request */
>  		ret = usb_control_msg(dev->udev,
> @@ -298,8 +299,12 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
>  				      0xb8, 0x38, 0x1, 0, NULL, 0, 8000);
>  		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
>  			 "encoder start control request returned %d\n", ret);
> +		if (ret < 0)
> +			return ret;
>  
> -		hdpvr_config_call(dev, CTRL_START_STREAMING_VALUE, 0x00);
> +		ret = hdpvr_config_call(dev, CTRL_START_STREAMING_VALUE, 0x00);
> +		if (ret)
> +			return ret;
>  
>  		dev->status = STATUS_STREAMING;
>  
> @@ -606,21 +611,22 @@ static int vidioc_g_std(struct file *file, void *_fh,
>  static int vidioc_querystd(struct file *file, void *_fh, v4l2_std_id *a)
>  {
>  	struct hdpvr_device *dev = video_drvdata(file);
> -	struct hdpvr_video_info *vid_info;
> +	struct hdpvr_video_info vid_info;
>  	struct hdpvr_fh *fh = _fh;
> +	int ret;
>  
>  	*a = V4L2_STD_ALL;
>  	if (dev->options.video_input == HDPVR_COMPONENT)
>  		return fh->legacy_mode ? 0 : -ENODATA;
> -	vid_info = get_video_info(dev);
> -	if (vid_info == NULL)
> -		return 0;
> -	if (vid_info->width == 720 &&
> -	    (vid_info->height == 480 || vid_info->height == 576)) {
> -		*a = (vid_info->height == 480) ?
> +	ret = get_video_info(dev, &vid_info);
> +	if (ret)
> +		return ret;
> +	if (vid_info.width == 720 &&
> +	    (vid_info.height == 480 || vid_info.height == 576)) {
> +		*a = (vid_info.height == 480) ?
>  			V4L2_STD_525_60 : V4L2_STD_625_50;
>  	}
> -	kfree(vid_info);
> +
>  	return 0;
>  }
>  
> @@ -665,7 +671,7 @@ static int vidioc_query_dv_timings(struct file *file, void *_fh,
>  {
>  	struct hdpvr_device *dev = video_drvdata(file);
>  	struct hdpvr_fh *fh = _fh;
> -	struct hdpvr_video_info *vid_info;
> +	struct hdpvr_video_info vid_info;
>  	bool interlaced;
>  	int ret = 0;
>  	int i;
> @@ -673,10 +679,12 @@ static int vidioc_query_dv_timings(struct file *file, void *_fh,
>  	fh->legacy_mode = false;
>  	if (dev->options.video_input)
>  		return -ENODATA;
> -	vid_info = get_video_info(dev);
> -	if (vid_info == NULL)
> +	ret = get_video_info(dev, &vid_info);
> +	if (ret)
> +		return ret;
> +	if (vid_info.fps == 0)
>  		return -ENOLCK;
> -	interlaced = vid_info->fps <= 30;
> +	interlaced = vid_info.fps <= 30;
>  	for (i = 0; i < ARRAY_SIZE(hdpvr_dv_timings); i++) {
>  		const struct v4l2_bt_timings *bt = &hdpvr_dv_timings[i].bt;
>  		unsigned hsize;
> @@ -688,17 +696,17 @@ static int vidioc_query_dv_timings(struct file *file, void *_fh,
>  			bt->il_vfrontporch + bt->il_vsync + bt->il_vbackporch +
>  			bt->height;
>  		fps = (unsigned)bt->pixelclock / (hsize * vsize);
> -		if (bt->width != vid_info->width ||
> -		    bt->height != vid_info->height ||
> +		if (bt->width != vid_info.width ||
> +		    bt->height != vid_info.height ||
>  		    bt->interlaced != interlaced ||
> -		    (fps != vid_info->fps && fps + 1 != vid_info->fps))
> +		    (fps != vid_info.fps && fps + 1 != vid_info.fps))
>  			continue;
>  		*timings = hdpvr_dv_timings[i];
>  		break;
>  	}
>  	if (i == ARRAY_SIZE(hdpvr_dv_timings))
>  		ret = -ERANGE;
> -	kfree(vid_info);
> +
>  	return ret;
>  }
>  
> @@ -988,6 +996,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *_fh,
>  {
>  	struct hdpvr_device *dev = video_drvdata(file);
>  	struct hdpvr_fh *fh = _fh;
> +	int ret;
>  
>  	/*
>  	 * The original driver would always returns the current detected
> @@ -1000,14 +1009,13 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *_fh,
>  	 * last set format.
>  	 */
>  	if (fh->legacy_mode) {
> -		struct hdpvr_video_info *vid_info;
> -
> -		vid_info = get_video_info(dev);
> -		if (!vid_info)
> -			return -EFAULT;
> -		f->fmt.pix.width = vid_info->width;
> -		f->fmt.pix.height = vid_info->height;
> -		kfree(vid_info);
> +		struct hdpvr_video_info vid_info;
> +
> +		ret = get_video_info(dev, &vid_info);
> +		if (ret)
> +			return ret;
> +		f->fmt.pix.width = vid_info.width;
> +		f->fmt.pix.height = vid_info.height;
>  	} else {
>  		f->fmt.pix.width = dev->width;
>  		f->fmt.pix.height = dev->height;
> diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
> index 1478f3d..808ea7a 100644
> --- a/drivers/media/usb/hdpvr/hdpvr.h
> +++ b/drivers/media/usb/hdpvr/hdpvr.h
> @@ -303,7 +303,7 @@ int hdpvr_set_audio(struct hdpvr_device *dev, u8 input,
>  int hdpvr_config_call(struct hdpvr_device *dev, uint value,
>  		      unsigned char valbuf);
>  
> -struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev);
> +int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vid_info);
>  
>  /* :0 s b8 81 1800 0003 0003 3 < */
>  /* :0 0 3 = 0301ff */
> 
