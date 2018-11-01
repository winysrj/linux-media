Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49344 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbeKBBNj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 21:13:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: dorodnic@gmail.com
Cc: linux-media@vger.kernel.org, evgeni.raikhel@intel.com,
        Sergey Dorodnicov <sergey.dorodnicov@intel.com>
Subject: Re: [PATCH v2 2/2] [media] CNF4 pixel format for media subsystem
Date: Thu, 01 Nov 2018 18:10:08 +0200
Message-ID: <1887189.gMKOtKLMbF@avalon>
In-Reply-To: <1536734527-3770-3-git-send-email-sergey.dorodnicov@intel.com>
References: <1536734527-3770-1-git-send-email-sergey.dorodnicov@intel.com> <1536734527-3770-3-git-send-email-sergey.dorodnicov@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergey,

Thank you for the patch.

As for patch 1/2, the subject line needs a prefix. Furthermore it doesn't 
really describe the patch. I propose writing it as

media: uvcvideo: Add support for the CNF4 format

On Wednesday, 12 September 2018 09:42:07 EET dorodnic@gmail.com wrote:
> From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> 
> Registering new GUID used by Intel RealSense cameras with fourcc CNF4,
> encoding depth sensor confidence information for every pixel.

And there I would write "Register the GUID ...".

Apart from that the patch looks good to me,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

If you're fine with the subject line change there's no need to resubmit, I'll 
fix it when applying the patch to my tree.

> Signed-off-by: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 5 +++++
>  drivers/media/usb/uvc/uvcvideo.h   | 3 +++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index d46dc43..19f129f 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -214,6 +214,11 @@ static struct uvc_format_desc uvc_fmts[] = {
>  		.guid		= UVC_GUID_FORMAT_INZI,
>  		.fcc		= V4L2_PIX_FMT_INZI,
>  	},
> +	{
> +		.name		= "4-bit Depth Confidence (Packed)",
> +		.guid		= UVC_GUID_FORMAT_CNF4,
> +		.fcc		= V4L2_PIX_FMT_CNF4,
> +	},
>  };
> 
>  /* ------------------------------------------------------------------------
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index e5f5d84..779bab2 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -154,6 +154,9 @@
>  #define UVC_GUID_FORMAT_INVI \
>  	{ 'I',  'N',  'V',  'I', 0xdb, 0x57, 0x49, 0x5e, \
>  	 0x8e, 0x3f, 0xf4, 0x79, 0x53, 0x2b, 0x94, 0x6f}
> +#define UVC_GUID_FORMAT_CNF4 \
> +	{ 'C',  ' ',  ' ',  ' ', 0x00, 0x00, 0x10, 0x00, \
> +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> 
>  #define UVC_GUID_FORMAT_D3DFMT_L8 \
>  	{0x32, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, \

-- 
Regards,

Laurent Pinchart
