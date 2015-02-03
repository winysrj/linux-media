Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55830 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbbBCNyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 08:54:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, isely@isely.net, pali.rohar@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/5] uvc gadget: switch to unlocked_ioctl.
Date: Tue, 03 Feb 2015 15:55:03 +0200
Message-ID: <3185495.drmK3h6s8j@avalon>
In-Reply-To: <1422967646-12223-4-git-send-email-hverkuil@xs4all.nl>
References: <1422967646-12223-1-git-send-email-hverkuil@xs4all.nl> <1422967646-12223-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 03 February 2015 13:47:24 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Instead of .ioctl use unlocked_ioctl. While all the queue ops
> already use a lock, there was no lock to protect uvc_video, so
> add that one.

There's more. streamon and streamoff need to be protected by a lock for 
instance. Wouldn't it be easier to just set vdev->lock for this driver instead 
of adding manual locking ?

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/usb/gadget/function/f_uvc.c    | 1 +
>  drivers/usb/gadget/function/uvc.h      | 1 +
>  drivers/usb/gadget/function/uvc_v4l2.c | 6 +++++-
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/function/f_uvc.c
> b/drivers/usb/gadget/function/f_uvc.c index 945b3bd..748a80c 100644
> --- a/drivers/usb/gadget/function/f_uvc.c
> +++ b/drivers/usb/gadget/function/f_uvc.c
> @@ -817,6 +817,7 @@ static struct usb_function *uvc_alloc(struct
> usb_function_instance *fi) if (uvc == NULL)
>  		return ERR_PTR(-ENOMEM);
> 
> +	mutex_init(&uvc->video.mutex);

We need a corresponding mutex_destroy() somewhere.

>  	uvc->state = UVC_STATE_DISCONNECTED;
>  	opts = to_f_uvc_opts(fi);
> 
> diff --git a/drivers/usb/gadget/function/uvc.h
> b/drivers/usb/gadget/function/uvc.h index f67695c..3390ecd 100644
> --- a/drivers/usb/gadget/function/uvc.h
> +++ b/drivers/usb/gadget/function/uvc.h
> @@ -115,6 +115,7 @@ struct uvc_video
>  	unsigned int width;
>  	unsigned int height;
>  	unsigned int imagesize;
> +	struct mutex mutex;	/* protects frame parameters */
> 
>  	/* Requests */
>  	unsigned int req_size;
> diff --git a/drivers/usb/gadget/function/uvc_v4l2.c
> b/drivers/usb/gadget/function/uvc_v4l2.c index 5aad7fe..67f084f 100644
> --- a/drivers/usb/gadget/function/uvc_v4l2.c
> +++ b/drivers/usb/gadget/function/uvc_v4l2.c
> @@ -88,6 +88,7 @@ uvc_v4l2_get_format(struct file *file, void *fh, struct
> v4l2_format *fmt) struct uvc_device *uvc = video_get_drvdata(vdev);
>  	struct uvc_video *video = &uvc->video;
> 
> +	mutex_lock(&video->mutex);
>  	fmt->fmt.pix.pixelformat = video->fcc;
>  	fmt->fmt.pix.width = video->width;
>  	fmt->fmt.pix.height = video->height;
> @@ -96,6 +97,7 @@ uvc_v4l2_get_format(struct file *file, void *fh, struct
> v4l2_format *fmt) fmt->fmt.pix.sizeimage = video->imagesize;
>  	fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
>  	fmt->fmt.pix.priv = 0;
> +	mutex_unlock(&video->mutex);
> 
>  	return 0;
>  }
> @@ -126,11 +128,13 @@ uvc_v4l2_set_format(struct file *file, void *fh,
> struct v4l2_format *fmt) bpl = format->bpp * fmt->fmt.pix.width / 8;
>  	imagesize = bpl ? bpl * fmt->fmt.pix.height : fmt->fmt.pix.sizeimage;
> 
> +	mutex_lock(&video->mutex);
>  	video->fcc = format->fcc;
>  	video->bpp = format->bpp;
>  	video->width = fmt->fmt.pix.width;
>  	video->height = fmt->fmt.pix.height;
>  	video->imagesize = imagesize;
> +	mutex_unlock(&video->mutex);
> 
>  	fmt->fmt.pix.field = V4L2_FIELD_NONE;
>  	fmt->fmt.pix.bytesperline = bpl;
> @@ -356,7 +360,7 @@ struct v4l2_file_operations uvc_v4l2_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= uvc_v4l2_open,
>  	.release	= uvc_v4l2_release,
> -	.ioctl		= video_ioctl2,
> +	.unlocked_ioctl	= video_ioctl2,
>  	.mmap		= uvc_v4l2_mmap,
>  	.poll		= uvc_v4l2_poll,
>  #ifndef CONFIG_MMU

-- 
Regards,

Laurent Pinchart

