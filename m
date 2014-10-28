Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49064 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaJ1Wcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 18:32:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arend van Spriel <aspriel@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: uvc: add support for Toshiba FHD Webcam
Date: Wed, 29 Oct 2014 00:32:47 +0200
Message-ID: <1611045.7yGLlX0ceE@avalon>
In-Reply-To: <1414535418-6133-1-git-send-email-aspriel@gmail.com>
References: <1414535418-6133-1-git-send-email-aspriel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arend,

Thank you for the patch.

On Tuesday 28 October 2014 23:30:18 Arend van Spriel wrote:
> The webcam is identified as Toshiba webcam although it seems a module
> from Chicony Electronics. Not sure about the model so just refering
> to it as Toshiba webcam that is in Portege z30 laptop.
> 
> Signed-off-by: Arend van Spriel <aspriel@gmail.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 7c8322d..f0b7eab 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2193,6 +2193,14 @@ static struct usb_device_id uvc_ids[] = {
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
>  	  .driver_info		= UVC_QUIRK_RESTRICT_FRAME_RATE },
> +	/* Chicony (Toshiba FHD Webcam) */
> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> +	  .idVendor		= 0x04f2,
> +	  .idProduct		= 0xb3b2,
> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> +	  .bInterfaceSubClass	= 1,
> +	  .bInterfaceProtocol	= 0 },

Is this really needed ? Isn't the camera properly detected and supported 
without this patch ?

>  	/* Alcor Micro AU3820 (Future Boy PC USB Webcam) */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,

-- 
Regards,

Laurent Pinchart

