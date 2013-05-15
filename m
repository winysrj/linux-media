Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab3EOJ5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 05:57:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Shawn Nematbakhsh <shawnn@chromium.org>
Subject: Re: [PATCH v2] uvcvideo: Fix open/close race condition
Date: Wed, 15 May 2013 11:58:02 +0200
Message-ID: <10450810.MOPyhOxKX4@avalon>
In-Reply-To: <1367925577-26907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1367925577-26907-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shawn,

Could you please confirm whether this patch fixes the issue you've reported ?

On Tuesday 07 May 2013 13:19:37 Laurent Pinchart wrote:
> Maintaining the users count using an atomic variable makes sure that
> access to the counter won't be racy, but doesn't serialize access to the
> operations protected by the counter. This creates a race condition that
> could result in the status URB being submitted multiple times.
> 
> Use a mutex to protect the users count and serialize access to the
> status start and stop operations.
> 
> Reported-by: Shawn Nematbakhsh <shawnn@chromium.org>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 23 +++++++++++++++++------
>  drivers/media/usb/uvc/uvc_status.c | 21 ++-------------------
>  drivers/media/usb/uvc/uvc_v4l2.c   | 14 ++++++++++----
>  drivers/media/usb/uvc/uvcvideo.h   |  7 +++----
>  4 files changed, 32 insertions(+), 33 deletions(-)
> 
> Changes since v1:
> 
> - Add a missing return back in the uvc_suspend() function
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index e68fa53..d704be3 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1836,8 +1836,8 @@ static int uvc_probe(struct usb_interface *intf,
>  	INIT_LIST_HEAD(&dev->chains);
>  	INIT_LIST_HEAD(&dev->streams);
>  	atomic_set(&dev->nstreams, 0);
> -	atomic_set(&dev->users, 0);
>  	atomic_set(&dev->nmappings, 0);
> +	mutex_init(&dev->lock);
> 
>  	dev->udev = usb_get_dev(udev);
>  	dev->intf = usb_get_intf(intf);
> @@ -1953,8 +1953,13 @@ static int uvc_suspend(struct usb_interface *intf,
> pm_message_t message)
> 
>  	/* Controls are cached on the fly so they don't need to be saved. */
>  	if (intf->cur_altsetting->desc.bInterfaceSubClass ==
> -	    UVC_SC_VIDEOCONTROL)
> -		return uvc_status_suspend(dev);
> +	    UVC_SC_VIDEOCONTROL) {
> +		mutex_lock(&dev->lock);
> +		if (dev->users)
> +			uvc_status_stop(dev);
> +		mutex_unlock(&dev->lock);
> +		return 0;
> +	}
> 
>  	list_for_each_entry(stream, &dev->streams, list) {
>  		if (stream->intf == intf)
> @@ -1976,14 +1981,20 @@ static int __uvc_resume(struct usb_interface *intf,
> int reset)
> 
>  	if (intf->cur_altsetting->desc.bInterfaceSubClass ==
>  	    UVC_SC_VIDEOCONTROL) {
> -		if (reset) {
> -			int ret = uvc_ctrl_resume_device(dev);
> +		int ret = 0;
> 
> +		if (reset) {
> +			ret = uvc_ctrl_resume_device(dev);
>  			if (ret < 0)
>  				return ret;
>  		}
> 
> -		return uvc_status_resume(dev);
> +		mutex_lock(&dev->lock);
> +		if (dev->users)
> +			ret = uvc_status_start(dev, GFP_NOIO);
> +		mutex_unlock(&dev->lock);
> +
> +		return ret;
>  	}
> 
>  	list_for_each_entry(stream, &dev->streams, list) {
> diff --git a/drivers/media/usb/uvc/uvc_status.c
> b/drivers/media/usb/uvc/uvc_status.c index b749277..f552ab9 100644
> --- a/drivers/media/usb/uvc/uvc_status.c
> +++ b/drivers/media/usb/uvc/uvc_status.c
> @@ -206,32 +206,15 @@ void uvc_status_cleanup(struct uvc_device *dev)
>  	uvc_input_cleanup(dev);
>  }
> 
> -int uvc_status_start(struct uvc_device *dev)
> +int uvc_status_start(struct uvc_device *dev, gfp_t flags)
>  {
>  	if (dev->int_urb == NULL)
>  		return 0;
> 
> -	return usb_submit_urb(dev->int_urb, GFP_KERNEL);
> +	return usb_submit_urb(dev->int_urb, flags);
>  }
> 
>  void uvc_status_stop(struct uvc_device *dev)
>  {
>  	usb_kill_urb(dev->int_urb);
>  }
> -
> -int uvc_status_suspend(struct uvc_device *dev)
> -{
> -	if (atomic_read(&dev->users))
> -		usb_kill_urb(dev->int_urb);
> -
> -	return 0;
> -}
> -
> -int uvc_status_resume(struct uvc_device *dev)
> -{
> -	if (dev->int_urb == NULL || atomic_read(&dev->users) == 0)
> -		return 0;
> -
> -	return usb_submit_urb(dev->int_urb, GFP_NOIO);
> -}
> -
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index b2dc326..3afff92 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -498,16 +498,20 @@ static int uvc_v4l2_open(struct file *file)
>  		return -ENOMEM;
>  	}
> 
> -	if (atomic_inc_return(&stream->dev->users) == 1) {
> -		ret = uvc_status_start(stream->dev);
> +	mutex_lock(&stream->dev->lock);
> +	if (stream->dev->users == 0) {
> +		ret = uvc_status_start(stream->dev, GFP_KERNEL);
>  		if (ret < 0) {
> -			atomic_dec(&stream->dev->users);
> +			mutex_unlock(&stream->dev->lock);
>  			usb_autopm_put_interface(stream->dev->intf);
>  			kfree(handle);
>  			return ret;
>  		}
>  	}
> 
> +	stream->dev->users++;
> +	mutex_unlock(&stream->dev->lock);
> +
>  	v4l2_fh_init(&handle->vfh, stream->vdev);
>  	v4l2_fh_add(&handle->vfh);
>  	handle->chain = stream->chain;
> @@ -538,8 +542,10 @@ static int uvc_v4l2_release(struct file *file)
>  	kfree(handle);
>  	file->private_data = NULL;
> 
> -	if (atomic_dec_return(&stream->dev->users) == 0)
> +	mutex_lock(&stream->dev->lock);
> +	if (--stream->dev->users == 0)
>  		uvc_status_stop(stream->dev);
> +	mutex_unlock(&stream->dev->lock);
> 
>  	usb_autopm_put_interface(stream->dev->intf);
>  	return 0;
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 9cd584a..eb90a92 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -515,7 +515,8 @@ struct uvc_device {
>  	char name[32];
> 
>  	enum uvc_device_state state;
> -	atomic_t users;
> +	struct mutex lock;		/* Protects users */
> +	unsigned int users;
>  	atomic_t nmappings;
> 
>  	/* Video control interface */
> @@ -661,10 +662,8 @@ void uvc_video_clock_update(struct uvc_streaming
> *stream, /* Status */
>  extern int uvc_status_init(struct uvc_device *dev);
>  extern void uvc_status_cleanup(struct uvc_device *dev);
> -extern int uvc_status_start(struct uvc_device *dev);
> +extern int uvc_status_start(struct uvc_device *dev, gfp_t flags);
>  extern void uvc_status_stop(struct uvc_device *dev);
> -extern int uvc_status_suspend(struct uvc_device *dev);
> -extern int uvc_status_resume(struct uvc_device *dev);
> 
>  /* Controls */
>  extern const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops;
-- 
Regards,

Laurent Pinchart

