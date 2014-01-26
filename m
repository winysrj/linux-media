Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45126 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaAZXML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 18:12:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thomas Pugliese <thomas.pugliese@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] uvc: update uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS devices
Date: Mon, 27 Jan 2014 00:12:59 +0100
Message-ID: <8041079.da1zLPkO88@avalon>
In-Reply-To: <1390598248-343-1-git-send-email-thomas.pugliese@gmail.com>
References: <1390598248-343-1-git-send-email-thomas.pugliese@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

Thank you for the patch.

On Friday 24 January 2014 15:17:28 Thomas Pugliese wrote:
> Isochronous endpoints on devices with speed == USB_SPEED_WIRELESS can
> have a max packet size ranging from 1-3584 bytes.  Add a case to
> uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS.  Otherwise endpoints
> for those devices will fall to the default case which masks off any
> values > 2047.  This causes uvc_init_video to underestimate the
> bandwidth available and fail to find a suitable alt setting for high
> bandwidth video streams.

I'm not too familiar with wireless USB, but shouldn't the value be multiplied 
by bMaxBurst from the endpoint companion descriptor ? Superspeed devices 
provide the multiplied value in their endpoint companion descriptor's 
wBytesPerInterval field, but there's no such field for wireless devices.

Out of curiosity, which device have you tested this with ?

> Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 898c208..103cd4e 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1453,6 +1453,9 @@ static unsigned int uvc_endpoint_max_bpi(struct
> usb_device *dev, case USB_SPEED_HIGH:
>  		psize = usb_endpoint_maxp(&ep->desc);
>  		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
> +	case USB_SPEED_WIRELESS:
> +		psize = usb_endpoint_maxp(&ep->desc);
> +		return psize;
>  	default:
>  		psize = usb_endpoint_maxp(&ep->desc);
>  		return psize & 0x07ff;

-- 
Regards,

Laurent Pinchart

