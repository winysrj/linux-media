Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58316 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933202AbdKGDkh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Nov 2017 22:40:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] uvc: Add D3DFMT_L8 support
Date: Tue, 07 Nov 2017 05:40:39 +0200
Message-ID: <1796861.IONRWI83yA@avalon>
In-Reply-To: <20171106201328.8875-1-nicolas.dufresne@collabora.com>
References: <7297726.O69fnl4949@avalon> <20171106201328.8875-1-nicolas.dufresne@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

Thank you for the patch.

On Monday, 6 November 2017 22:13:28 EET Nicolas Dufresne wrote:
> Microsoft HoloLense UVC sensor uses D3DFMT instead of FOURCC when
> exposing formats. This adds support for D3DFMT_L8 as exposed from
> the Acer Windows Mixed Reality Headset.
> 
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree with "uvc" replaced by "uvcvideo" in the subject to 
match other commits.

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 5 +++++
>  drivers/media/usb/uvc/uvcvideo.h   | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 6d22b22cb35b..113130b6b2d6
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -94,6 +94,11 @@ static struct uvc_format_desc uvc_fmts[] = {
>  		.fcc		= V4L2_PIX_FMT_GREY,
>  	},
>  	{
> +		.name		= "Greyscale 8-bit (D3DFMT_L8)",
> +		.guid		= UVC_GUID_FORMAT_D3DFMT_L8,
> +		.fcc		= V4L2_PIX_FMT_GREY,
> +	},
> +	{
>  		.name		= "Greyscale 10-bit (Y10 )",
>  		.guid		= UVC_GUID_FORMAT_Y10,
>  		.fcc		= V4L2_PIX_FMT_Y10,
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
