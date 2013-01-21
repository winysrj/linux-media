Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33551 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3AUKDK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 05:03:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: [PATCH v2] uvc: Replace memcpy with struct assignment
Date: Mon, 21 Jan 2013 11:04:52 +0100
Message-ID: <1792770.uXGWb880Hs@avalon>
In-Reply-To: <1358187775-17592-1-git-send-email-elezegarcia@gmail.com>
References: <1358187775-17592-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Monday 14 January 2013 15:22:55 Ezequiel Garcia wrote:
> This kind of memcpy() is error-prone. Its replacement with a struct
> assignment is prefered because it's type-safe and much easier to read.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>

Thank you for the patch. I've applied it to my tree.

> ---
> Changes from v1:
>  * Replaced a memcpy() in ucv_ctrl_add_info(),
>    originally missed by the coccinelle script.
> 
>  drivers/media/usb/uvc/uvc_ctrl.c |    2 +-
>  drivers/media/usb/uvc/uvc_v4l2.c |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index 516a5b1..f2f6443 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1839,7 +1839,7 @@ static int uvc_ctrl_add_info(struct uvc_device *dev,
> struct uvc_control *ctrl, {
>  	int ret = 0;
> 
> -	memcpy(&ctrl->info, info, sizeof(*info));
> +	ctrl->info = *info;
>  	INIT_LIST_HEAD(&ctrl->info.mappings);
> 
>  	/* Allocate an array to save control values (cur, def, max, etc.) */
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 8e05604..36e79ed 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -315,7 +315,7 @@ static int uvc_v4l2_set_format(struct uvc_streaming
> *stream, goto done;
>  	}
> 
> -	memcpy(&stream->ctrl, &probe, sizeof probe);
> +	stream->ctrl = probe;
>  	stream->cur_format = format;
>  	stream->cur_frame = frame;
> 
> @@ -387,7 +387,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming
> *stream, return -EBUSY;
>  	}
> 
> -	memcpy(&probe, &stream->ctrl, sizeof probe);
> +	probe = stream->ctrl;
>  	probe.dwFrameInterval =
>  		uvc_try_frame_interval(stream->cur_frame, interval);
> 
> @@ -398,7 +398,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming
> *stream, return ret;
>  	}
> 
> -	memcpy(&stream->ctrl, &probe, sizeof probe);
> +	stream->ctrl = probe;
>  	mutex_unlock(&stream->mutex);
> 
>  	/* Return the actual frame period. */

-- 
Regards,

Laurent Pinchart

