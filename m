Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35951 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753818AbdKGLgj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Nov 2017 06:36:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jaejoong Kim <climbbb.kim@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] media: usb: uvc: remove duplicate & operation
Date: Tue, 07 Nov 2017 13:36:42 +0200
Message-ID: <2094561.XVScKd08z9@avalon>
In-Reply-To: <1508484328-11018-2-git-send-email-climbbb.kim@gmail.com>
References: <1508484328-11018-1-git-send-email-climbbb.kim@gmail.com> <1508484328-11018-2-git-send-email-climbbb.kim@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jaejoong,

Thank you for the patch.

On Friday, 20 October 2017 10:25:27 EET Jaejoong Kim wrote:
> usb_endpoint_maxp() has an inline keyword and searches for bits[10:0]
> by & operation with 0x7ff. So, we can remove the duplicate & operation
> with 0x7ff.
> 
> Signed-off-by: Jaejoong Kim <climbbb.kim@gmail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/usb/uvc/uvc_video.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index fb86d6a..f4ace63 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1469,13 +1469,13 @@ static unsigned int uvc_endpoint_max_bpi(struct
> usb_device *dev, case USB_SPEED_HIGH:
>  		psize = usb_endpoint_maxp(&ep->desc);
>  		mult = usb_endpoint_maxp_mult(&ep->desc);
> -		return (psize & 0x07ff) * mult;
> +		return psize * mult;
>  	case USB_SPEED_WIRELESS:
>  		psize = usb_endpoint_maxp(&ep->desc);
>  		return psize;
>  	default:
>  		psize = usb_endpoint_maxp(&ep->desc);
> -		return psize & 0x07ff;
> +		return psize;
>  	}
>  }


-- 
Regards,

Laurent Pinchart
