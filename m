Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42038 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbaBROg0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 09:36:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Edgar Thier <info@edgarthier.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Added bayer 8-bit patterns to uvcvideo
Date: Tue, 18 Feb 2014 15:37:34 +0100
Message-ID: <232139127.sJD4YvNJ9E@avalon>
In-Reply-To: <CAENiEt-OA==jH_tA4HBP68RW3vGga99dpuFE+Zx7=QNYBqeC5A@mail.gmail.com>
References: <CAENiEt-OA==jH_tA4HBP68RW3vGga99dpuFE+Zx7=QNYBqeC5A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Edgar,

Thank you for the patch.

On Monday 20 January 2014 09:11:28 Edgar Thier wrote:
> Add bayer 8-bit GUIDs to uvcvideo and
> associate them with the corresponding V4L2 pixel formats.
> 
> Signed-off-by: Edgar Thier <info@edgarthier.net>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Out of curiosity, could you please send me the lsusb -v output of the camera 
you need this for ?

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 22 +++++++++++++++++++++-
>  drivers/media/usb/uvc/uvcvideo.h   | 12 ++++++++++++
>  2 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c
> index c3bb250..84da426 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -108,11 +108,31 @@ static struct uvc_format_desc uvc_fmts[] = {
>          .fcc        = V4L2_PIX_FMT_Y16,
>      },
>      {
> -        .name        = "RGB Bayer",
> +        .name        = "RGB Bayer (bggr)",
>          .guid        = UVC_GUID_FORMAT_BY8,
>          .fcc        = V4L2_PIX_FMT_SBGGR8,

It looks like your mailer has corrupted the patch by replacing tabs with 
spaces. Could you please fix that and resubmit ? While you're at it, could you 
please prefix the commit subject with "uvcvideo: " ?

>      },
>      {
> +        .name        = "RGB Bayer (bggr)",
> +        .guid        = UVC_GUID_FORMAT_BY8_BA81,
> +        .fcc        = V4L2_PIX_FMT_SBGGR8,
> +    },
> +    {
> +        .name        = "RGB Bayer (grbg)",
> +        .guid        = UVC_GUID_FORMAT_BY8_GRBG,
> +        .fcc        = V4L2_PIX_FMT_SGRBG8,
> +    },
> +    {
> +        .name        = "RGB Bayer (gbrg)",
> +        .guid        = UVC_GUID_FORMAT_BY8_GBRG,
> +        .fcc        = V4L2_PIX_FMT_SGBRG8,
> +    },
> +    {
> +        .name        = "RGB Bayer (rggb)",
> +        .guid        = UVC_GUID_FORMAT_BY8_RGGB,
> +        .fcc        = V4L2_PIX_FMT_SRGGB8,
> +    },
> +    {
>          .name        = "RGB565",
>          .guid        = UVC_GUID_FORMAT_RGBP,
>          .fcc        = V4L2_PIX_FMT_RGB565,
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 9e35982..57357d9 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -94,6 +94,18 @@
>  #define UVC_GUID_FORMAT_BY8 \
>      { 'B',  'Y',  '8',  ' ', 0x00, 0x00, 0x10, 0x00, \
>       0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_BY8_BA81 \
> +    { 'B',  'A',  '8',  '1', 0x00, 0x00, 0x10, 0x00, \
> +     0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_BY8_GRBG \
> +    { 'G',  'R',  'B',  'G', 0x00, 0x00, 0x10, 0x00, \
> +     0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_BY8_GBRG \
> +    { 'G',  'B',  'R',  'G', 0x00, 0x00, 0x10, 0x00, \
> +     0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_BY8_RGGB \
> +    { 'R',  'G',  'G',  'B', 0x00, 0x00, 0x10, 0x00, \
> +     0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
>  #define UVC_GUID_FORMAT_RGBP \
>      { 'R',  'G',  'B',  'P', 0x00, 0x00, 0x10, 0x00, \
>       0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}

-- 
Regards,

Laurent Pinchart

