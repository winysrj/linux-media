Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41277 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751439AbdBHNnM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 08:43:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: evgeni.raikhel@gmail.com
Cc: linux-media@vger.kernel.org, guennadi.liakhovetski@intel.com,
        eliezer.tamir@intel.com, sergey.dorodnicov@intel.com,
        Daniel Patrick Johnson <teknotus@teknot.us>,
        Aviv Greenberg <avivgr@gmail.com>,
        Evgeni Raikhel <evgeni.raikhel@intel.com>
Subject: Re: [PATCH v2 2/2] uvcvideo: Add support for Intel SR300 depth camera
Date: Wed, 08 Feb 2017 15:41:47 +0200
Message-ID: <2977004.kzl6j44Hvb@avalon>
In-Reply-To: <1486542864-5832-2-git-send-email-evgeni.raikhel@intel.com>
References: <AA09C8071EEEFC44A7852ADCECA86673A1E6E7@hasmsx108.ger.corp.intel.com> <1486542864-5832-1-git-send-email-evgeni.raikhel@intel.com> <1486542864-5832-2-git-send-email-evgeni.raikhel@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Evgeni,

Thank you for the patch.

On Wednesday 08 Feb 2017 10:34:24 evgeni.raikhel@gmail.com wrote:
> From: Daniel Patrick Johnson <teknotus@teknot.us>
> 
> Add support for Intel SR300 depth camera in uvc driver.
> This includes adding three uvc GUIDs for the required pixel formats,
> adding a new V4L pixel format definition to user api headers,

The header change has been split to patch 1/2, you can remove this sentence.

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> and updating the uvc driver GUID-to-4cc tables with the new formats.
> 
> Signed-off-by: Daniel Patrick Johnson <teknotus@teknot.us>
> Signed-off-by: Aviv Greenberg <avivgr@gmail.com>
> Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 15 +++++++++++++++
>  drivers/media/usb/uvc/uvcvideo.h   |  9 +++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 04bf35063c4c..46d6be0bb316
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -188,6 +188,21 @@ static struct uvc_format_desc uvc_fmts[] = {
>  		.guid		= UVC_GUID_FORMAT_GR16,
>  		.fcc		= V4L2_PIX_FMT_SGRBG16,
>  	},
> +	{
> +		.name		= "Depth data 16-bit (Z16)",
> +		.guid		= UVC_GUID_FORMAT_INVZ,
> +		.fcc		= V4L2_PIX_FMT_Z16,
> +	},
> +	{
> +		.name		= "Greyscale 10-bit (Y10 )",
> +		.guid		= UVC_GUID_FORMAT_INVI,
> +		.fcc		= V4L2_PIX_FMT_Y10,
> +	},
> +	{
> +		.name		= "IR:Depth 26-bit (INZI)",
> +		.guid		= UVC_GUID_FORMAT_INZI,
> +		.fcc		= V4L2_PIX_FMT_INZI,
> +	},
>  };
> 
>  /* ------------------------------------------------------------------------
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 4205e7a423f0..15e415e32c7f 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.hdrivers/media/usb/uvc/uvcvideo.h
> @@ -143,6 +143,15 @@
>  #define UVC_GUID_FORMAT_RW10 \
>  	{ 'R',  'W',  '1',  '0', 0x00, 0x00, 0x10, 0x00, \
>  	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_INVZ \
> +	{ 'I',  'N',  'V',  'Z', 0x90, 0x2d, 0x58, 0x4a, \
> +	 0x92, 0x0b, 0x77, 0x3f, 0x1f, 0x2c, 0x55, 0x6b}
> +#define UVC_GUID_FORMAT_INZI \
> +	{ 'I',  'N',  'Z',  'I', 0x66, 0x1a, 0x42, 0xa2, \
> +	 0x90, 0x65, 0xd0, 0x18, 0x14, 0xa8, 0xef, 0x8a}
> +#define UVC_GUID_FORMAT_INVI \
> +	{ 'I',  'N',  'V',  'I', 0xdb, 0x57, 0x49, 0x5e, \
> +	 0x8e, 0x3f, 0xf4, 0x79, 0x53, 0x2b, 0x94, 0x6f}
> 
>  /* ------------------------------------------------------------------------
> * Driver specific constants.

-- 
Regards,

Laurent Pinchart

