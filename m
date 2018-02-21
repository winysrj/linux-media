Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52082 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbeBUTgv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 14:36:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: chf.fritz@googlemail.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Norbert Wesp <n.wesp@phytec.de>
Subject: Re: [PATCH] uvcvideo: add quirk to force Phytec CAM 004H to GBRG
Date: Wed, 21 Feb 2018 21:37:33 +0200
Message-ID: <1971379.NnuTUWjF6a@avalon>
In-Reply-To: <1519212389.11643.13.camel@googlemail.com>
References: <1519212389.11643.13.camel@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christoph,

Thank you for the patch.

On Wednesday, 21 February 2018 13:26:29 EET Christoph Fritz wrote:
> This patch adds a quirk to force Phytec CAM 004H to format GBRG because
> it is announcing its format wrong.

Could you please send me the output of 'lsusb -d 199e:8302 -v' (if possible 
running as root) ?

> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
> Tested-by: Norbert Wesp <n.wesp@phytec.de>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 16 ++++++++++++++++
>  drivers/media/usb/uvc/uvcvideo.h   |  1 +
>  2 files changed, 17 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index cde43b6..8bfa40b 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -406,6 +406,13 @@ static int uvc_parse_format(struct uvc_device *dev,
>  				width_multiplier = 2;
>  			}
>  		}
> +		if (dev->quirks & UVC_QUIRK_FORCE_GBRG) {
> +			if (format->fcc == V4L2_PIX_FMT_SGRBG8) {
> +				strlcpy(format->name, "GBRG Bayer (GBRG)",
> +					sizeof(format->name));
> +				format->fcc = V4L2_PIX_FMT_SGBRG8;
> +			}
> +		}
> 
>  		if (buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED) {
>  			ftype = UVC_VS_FRAME_UNCOMPRESSED;
> @@ -2631,6 +2638,15 @@ static struct usb_device_id uvc_ids[] = {
>  	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0 },
> +	/* PHYTEC CAM 004H cameras */
> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> +	  .idVendor		= 0x199e,
> +	  .idProduct		= 0x8302,
> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> +	  .bInterfaceSubClass	= 1,
> +	  .bInterfaceProtocol	= 0,
> +	  .driver_info		= UVC_QUIRK_FORCE_GBRG },
>  	/* Bodelin ProScopeHR */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_DEV_HI
> 
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 7e4d3ee..ad51002 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -164,6 +164,7 @@
>  #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
>  #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
>  #define UVC_QUIRK_FORCE_Y8		0x00000800
> +#define UVC_QUIRK_FORCE_GBRG		0x00001000

I don't think we should add a quirk flag for every format that needs to be 
forced. Instead, now that we have a new way to store per-device parameters 
since commit 3bc85817d798 ("media: uvcvideo: Add extensible device 
information"), how about making use of it and adding a field to the 
uvc_device_info structure to store the forced format ?

>  /* Format flags */
>  #define UVC_FMT_FLAG_COMPRESSED		0x00000001

-- 
Regards,

Laurent Pinchart
