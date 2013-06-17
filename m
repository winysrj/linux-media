Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51309 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab3FQULu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 16:11:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 08/12] f_uvc: add v4l2_device and replace parent with v4l2_dev
Date: Mon, 17 Jun 2013 22:12:02 +0200
Message-ID: <2193306.FIqlzJFcP5@avalon>
In-Reply-To: <1371049262-5799-9-git-send-email-hverkuil@xs4all.nl>
References: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl> <1371049262-5799-9-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Wednesday 12 June 2013 17:00:58 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This driver did not yet support struct v4l2_device, so add it. This
> make it possible to replace the deprecated parent field with the
> v4l2_dev field, allowing the eventual removal of the parent field.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/usb/gadget/f_uvc.c |    9 ++++++++-
>  drivers/usb/gadget/uvc.h   |    2 ++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
> index 38dcedd..1d06567 100644
> --- a/drivers/usb/gadget/f_uvc.c
> +++ b/drivers/usb/gadget/f_uvc.c
> @@ -413,7 +413,7 @@ uvc_register_video(struct uvc_device *uvc)
>  	if (video == NULL)
>  		return -ENOMEM;
> 
> -	video->parent = &cdev->gadget->dev;
> +	video->v4l2_dev = &uvc->v4l2_dev;
>  	video->fops = &uvc_v4l2_fops;
>  	video->release = video_device_release;
>  	strlcpy(video->name, cdev->gadget->name, sizeof(video->name));
> @@ -570,6 +570,7 @@ uvc_function_unbind(struct usb_configuration *c, struct
> usb_function *f) INFO(cdev, "uvc_function_unbind\n");
> 
>  	video_unregister_device(uvc->vdev);
> +	v4l2_device_unregister(&uvc->v4l2_dev);
>  	uvc->control_ep->driver_data = NULL;
>  	uvc->video.ep->driver_data = NULL;
> 
> @@ -697,6 +698,11 @@ uvc_function_bind(struct usb_configuration *c, struct
> usb_function *f) if ((ret = usb_function_deactivate(f)) < 0)
>  		goto error;
> 
> +	if (v4l2_device_register(&cdev->gadget->dev, &uvc->v4l2_dev)) {
> +		printk(KERN_INFO "v4l2_device_register failed\n");
> +		goto error;
> +	}
> +
>  	/* Initialise video. */
>  	ret = uvc_video_init(&uvc->video);
>  	if (ret < 0)
> @@ -712,6 +718,7 @@ uvc_function_bind(struct usb_configuration *c, struct
> usb_function *f) return 0;
> 
>  error:
> +	v4l2_device_unregister(&uvc->v4l2_dev);
>  	if (uvc->vdev)
>  		video_device_release(uvc->vdev);
> 
> diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
> index 817e9e1..7a9111d 100644
> --- a/drivers/usb/gadget/uvc.h
> +++ b/drivers/usb/gadget/uvc.h
> @@ -57,6 +57,7 @@ struct uvc_event
>  #include <linux/videodev2.h>
>  #include <linux/version.h>
>  #include <media/v4l2-fh.h>
> +#include <media/v4l2-device.h>
> 
>  #include "uvc_queue.h"
> 
> @@ -145,6 +146,7 @@ enum uvc_state
>  struct uvc_device
>  {
>  	struct video_device *vdev;
> +	struct v4l2_device v4l2_dev;
>  	enum uvc_state state;
>  	struct usb_function func;
>  	struct uvc_video video;
-- 
Regards,

Laurent Pinchart

