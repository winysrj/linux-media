Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55814 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbbBCNnX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 08:43:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, isely@isely.net, pali.rohar@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 4/5] uvc gadget: set device_caps in querycap.
Date: Tue, 03 Feb 2015 15:44:06 +0200
Message-ID: <14375558.lMHDtzMOar@avalon>
In-Reply-To: <1422967646-12223-5-git-send-email-hverkuil@xs4all.nl>
References: <1422967646-12223-1-git-send-email-hverkuil@xs4all.nl> <1422967646-12223-5-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 03 February 2015 13:47:25 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The V4L2 core will warn if this is not done. Unfortunately this driver
> wasn't updated.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/usb/gadget/function/uvc_v4l2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/function/uvc_v4l2.c
> b/drivers/usb/gadget/function/uvc_v4l2.c index 67f084f..3207b3e 100644
> --- a/drivers/usb/gadget/function/uvc_v4l2.c
> +++ b/drivers/usb/gadget/function/uvc_v4l2.c
> @@ -76,7 +76,8 @@ uvc_v4l2_querycap(struct file *file, void *fh, struct
> v4l2_capability *cap) strlcpy(cap->bus_info, dev_name(&cdev->gadget->dev),
>  		sizeof(cap->bus_info));
> 
> -	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> +	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> 
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

