Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49780 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbaHYPBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 11:01:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 16/29] uvc: fix sparse warning
Date: Mon, 25 Aug 2014 17:02:35 +0200
Message-ID: <2955863.XgjjzxJM0n@avalon>
In-Reply-To: <1408575568-20562-17-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl> <1408575568-20562-17-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday 21 August 2014 00:59:15 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> drivers/media/usb/uvc/uvc_video.c:1466:38: warning: incorrect type in return
> expression (different base types)
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I assume you will push the patch yourself. Please let me know if you would 
like me to take it into my tree instead.

> ---
>  drivers/media/usb/uvc/uvc_video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 9144a2f..7e350d7 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1463,7 +1463,7 @@ static unsigned int uvc_endpoint_max_bpi(struct
> usb_device *dev,
> 
>  	switch (dev->speed) {
>  	case USB_SPEED_SUPER:
> -		return ep->ss_ep_comp.wBytesPerInterval;
> +		return le16_to_cpu(ep->ss_ep_comp.wBytesPerInterval);
>  	case USB_SPEED_HIGH:
>  		psize = usb_endpoint_maxp(&ep->desc);
>  		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));

-- 
Regards,

Laurent Pinchart

