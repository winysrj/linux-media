Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2510 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3CVLPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 07:15:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Leonid Kegulskiy <leo@lumanate.com>, Janne Grunau <j@jannau.net>
Subject: Re: [PATCH] [media] hdpvr: vidioc_g_fmt_vid_cap should not fail
Date: Fri, 22 Mar 2013 12:15:01 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1363949945-18656-1-git-send-email-leo@lumanate.com>
In-Reply-To: <1363949945-18656-1-git-send-email-leo@lumanate.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221215.01193.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri March 22 2013 11:59:05 Leonid Kegulskiy wrote:
> Fixed get_video_info() function that used to return NULL
> if video source is not present, subsequently causing
> vidioc_g_fmt_vid_cap to fail. Originally issue reported here:
> http://www.spinics.net/lists/linux-media/msg54246.html

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

A change like this should be done on top of my hdpvr patch series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg60040.html

I worked around it by keeping track if one of the new DV_TIMINGS ioctls
for HDTV is used: if so, then the proper v4l2 behavior is used, otherwise
I keep the existing behavior.

Janne, it is really strange that EFAULT is returned if there is no signal.
Does mythtv or another application rely on that? If so, then we need to
keep it like that for now.

gstreamer can try to use the DV_TIMINGS API instead, which has proper
behavior.

Regards,

	Hans

> 
> Signed-off-by: Leonid Kegulskiy <leo@lumanate.com>
> ---
>  drivers/media/usb/hdpvr/hdpvr-control.c |   29 +++++++++++++----------------
>  drivers/media/usb/hdpvr/hdpvr-video.c   |    5 ++++-
>  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
> index ae8f229..ed12159 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-control.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-control.c
> @@ -53,12 +53,6 @@ struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
>  #endif
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
> @@ -66,12 +60,6 @@ struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
>  			      0x1400, 0x0003,
>  			      dev->usbc_buf, 5,
>  			      1000);
> -	if (ret == 5) {
> -		vidinf->width	= dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
> -		vidinf->height	= dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
> -		vidinf->fps	= dev->usbc_buf[4];
> -	}
> -
>  #ifdef HDPVR_DEBUG
>  	if (hdpvr_debug & MSG_INFO) {
>  		hex_dump_to_buffer(dev->usbc_buf, 5, 16, 1, print_buf,
> @@ -82,11 +70,20 @@ struct hdpvr_video_info *get_video_info(struct hdpvr_device *dev)
>  #endif
>  	mutex_unlock(&dev->usbc_mutex);
>  
> -	if (!vidinf->width || !vidinf->height || !vidinf->fps) {
> -		kfree(vidinf);
> -		vidinf = NULL;
> +	if (ret == 5)
> +	{
> +		vidinf = kzalloc(sizeof(struct hdpvr_video_info), GFP_KERNEL);
> +		if (vidinf)
> +		{
> +			vidinf->width	= dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
> +			vidinf->height	= dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
> +			vidinf->fps	= dev->usbc_buf[4];
> +		}
> +		else
> +		{
> +			v4l2_err(&dev->v4l2_dev, "out of memory\n");
> +		}
>  	}
> -err:
>  	return vidinf;
>  }
>  
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index da6b779..fb14012 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -268,7 +268,7 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
>  
>  	vidinf = get_video_info(dev);
>  
> -	if (vidinf) {
> +	if (vidinf && vidinf->width && vidinf->height && vidinf->fps) {
>  		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
>  			 "video signal: %dx%d@%dhz\n", vidinf->width,
>  			 vidinf->height, vidinf->fps);
> @@ -293,6 +293,9 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
>  
>  		return 0;
>  	}
> +	
> +	if (vidinf)
> +		kfree(vidinf);
>  	msleep(250);
>  	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
>  		 "no video signal at input %d\n", dev->options.video_input);
> 
