Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55551 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964913AbcKKCGZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 21:06:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Thibaut Girka <thib@sitedethib.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] uvcvideo: add support for Oculus Rift Sensor
Date: Fri, 11 Nov 2016 04:06:29 +0200
Message-ID: <4483641.cSCuuSSr05@avalon>
In-Reply-To: <20161107201547.7537-1-philipp.zabel@gmail.com>
References: <20161107201547.7537-1-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Monday 07 Nov 2016 21:15:47 Philipp Zabel wrote:
> The Rift CV1 Sensor has bInterfaceClass set to vendor specific, so we
> need an entry in uvc_ids to probe it. Just as the Rift DK2 IR tracker,
> it misreports the pixel format as YUYV instead of Y8.
> 
> The sensor is configured with a low exposure time and high black level
> by default, so that only bright IR sources can be seen.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree, after fixing the conflict (see below).

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 0eaa9a9..b64bfe4 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2583,6 +2583,15 @@ static struct usb_device_id uvc_ids[] = {
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
>  	  .driver_info		= UVC_QUIRK_FORCE_Y8 },
> +	/* Oculus VR Rift Sensor */
> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> +	  .idVendor		= 0x2833,
> +	  .idProduct		= 0x0211,
> +	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
> +	  .bInterfaceSubClass	= 1,
> +	  .bInterfaceProtocol	= 0,
> +	  .driver_info		= UVC_QUIRK_FORCE_Y8 },
>  	/* Leap Motion Controller LM-010 */

That's not in mainline, where does it come from ?

>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,

-- 
Regards,

Laurent Pinchart

