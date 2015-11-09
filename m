Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44989 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbKIRnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 12:43:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Zvi Effron <viz+kernel@flippedperspective.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] add interface protocol 1 for Surface Pro 3 cameras
Date: Mon, 09 Nov 2015 19:43:21 +0200
Message-ID: <1857618.KAc0uFPV7D@avalon>
In-Reply-To: <1440457062-2633-1-git-send-email-viz+kernel@flippedperspective.com>
References: <1440457062-2633-1-git-send-email-viz+kernel@flippedperspective.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Zvi,

Thank you for the patch.

On Monday 24 August 2015 15:57:42 Zvi Effron wrote:
> The cameras on the Surface Pro 3 report interface protocol of 1.
> The generic USB video class doesn't work for them.
> This adds entries for the front and rear camera.

This doesn't need to be restricted to the Surface Pro 3 cameras as 
bInterfaceProtocol 1 is (or at least should be) used by all UVC 1.5 devices.

I've just posted "[PATCH] uvcvideo: Enable UVC 1.5 device detection" to the 
linux-media mailing list. Could you check whether it fixes your problem ?

> Signed-off-by: Zvi Effron <viz+kernel@flippedperspective.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 4b5b3e8..d2fdbc1 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2142,6 +2142,22 @@ static struct usb_device_id uvc_ids[] = {
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
>  	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
> +	/* Microsoft Surface Pro 3 LifeCam Front */
> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> +	  .idVendor		= 0x045e,
> +	  .idProduct		= 0x07be,
> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> +	  .bInterfaceSubClass	= 1,
> +	  .bInterfaceProtocol	= 1 },
> +	/* Microsoft Surface Pro 3 LifeCam Rear */
> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> +	  .idVendor		= 0x045e,
> +	  .idProduct		= 0x07bf,
> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> +	  .bInterfaceSubClass	= 1,
> +	  .bInterfaceProtocol	= 1 },
>  	/* Logitech Quickcam Fusion */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,

-- 
Regards,

Laurent Pinchart

