Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54929 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdKDHLJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Nov 2017 03:11:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uvc: Add D3DFMT_L8 support
Date: Sat, 04 Nov 2017 09:11:10 +0200
Message-ID: <7297726.O69fnl4949@avalon>
In-Reply-To: <20171103175746.30456-1-nicolas.dufresne@collabora.com>
References: <20171103175746.30456-1-nicolas.dufresne@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

Thank you for the patch.

On Friday, 3 November 2017 19:57:46 EET Nicolas Dufresne wrote:
> Microsoft HoloLense UVC sensor uses D3DFMT instead of FOURCC when
> exposing formats. This add support for D3DFMT_L8 as exposed from

s/add/adds/

> the Acer Windows Mixed Reality Headset.
> 
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 5 +++++
>  drivers/media/usb/uvc/uvcvideo.h   | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 6d22b22cb35b..56f70851f88b
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -203,6 +203,11 @@ static struct uvc_format_desc uvc_fmts[] = {
>  		.guid		= UVC_GUID_FORMAT_INZI,
>  		.fcc		= V4L2_PIX_FMT_INZI,
>  	},
> +	{
> +		.name		= "Greyscale 8-bit (D3DFMT_L8)",
> +		.guid		= UVC_GUID_FORMAT_D3DFMT_L8,
> +		.fcc		= V4L2_PIX_FMT_GREY,
> +	},

How about moving this entry just after the two existing GREY entries ?

Apart from this,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

If you're fine with those two minor changes there's no need to resubmit, I'll 
fold the changes in when applying the patch.

>  };
> 
>  /* ------------------------------------------------------------------------
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 34c7ee6cc9e5..fbc1f433ff05 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -153,6 +153,11 @@
>  	{ 'I',  'N',  'V',  'I', 0xdb, 0x57, 0x49, 0x5e, \
>  	 0x8e, 0x3f, 0xf4, 0x79, 0x53, 0x2b, 0x94, 0x6f}
> 
> +#define UVC_GUID_FORMAT_D3DFMT_L8 \
> +	{0x32, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, \
> +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +
> +
>  /* ------------------------------------------------------------------------
> * Driver specific constants.
>   */

-- 
Regards,

Laurent Pinchart
