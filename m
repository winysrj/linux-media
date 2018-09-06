Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39963 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbeIFOMR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Sep 2018 10:12:17 -0400
Subject: Re: [PATCH 2/2] CNF4 pixel format for media subsystem
To: dorodnic@gmail.com, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, evgeni.raikhel@intel.com,
        Sergey Dorodnicov <sergey.dorodnicov@intel.com>
References: <1536220267-22347-1-git-send-email-sergey.dorodnicov@intel.com>
 <1536220267-22347-3-git-send-email-sergey.dorodnicov@intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <25f8e48c-24ff-7577-2f83-7cf25993e9c8@xs4all.nl>
Date: Thu, 6 Sep 2018 11:37:36 +0200
MIME-Version: 1.0
In-Reply-To: <1536220267-22347-3-git-send-email-sergey.dorodnicov@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/18 09:51, dorodnic@gmail.com wrote:
> From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> 
> Registering new GUID used by Intel RealSense depth cameras with fourcc
> CNF4, encoding sensor confidence information for every pixel.
> 
> Signed-off-by: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 5 +++++
>  drivers/media/usb/uvc/uvcvideo.h   | 3 +++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index d46dc43..c8d40a4 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -214,6 +214,11 @@ static struct uvc_format_desc uvc_fmts[] = {
>  		.guid		= UVC_GUID_FORMAT_INZI,
>  		.fcc		= V4L2_PIX_FMT_INZI,
>  	},
> +	{
> +		.name		= "Confidence 4-bit Packed (CNF4)",

The name should correspond to what is set in v4l2-ioctl.c.

Regards,

	Hans

> +		.guid		= UVC_GUID_FORMAT_CNF4,
> +		.fcc		= V4L2_PIX_FMT_CNF4,
> +	},
>  };
>  
>  /* ------------------------------------------------------------------------
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index e5f5d84..779bab2 100644
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
> 
