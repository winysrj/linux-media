Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46817 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab1BQQCB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 11:02:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
Subject: Re: [PATCH RFC] uvcvideo: Add a mapping for H.264 payloads
Date: Thu, 17 Feb 2011 17:01:56 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-uvc-devel@lists.berlios.de" <linux-uvc-devel@lists.berlios.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1296243538.17673.23.camel@svmlwks101>
In-Reply-To: <1296243538.17673.23.camel@svmlwks101>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171701.57759.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

HI Stephan,

Thanks for the patch, and sorry for the late reply.

On Friday 28 January 2011 20:38:58 Stephan Lachowsky wrote:
> Associate the H.264 GUID with an H.264 pixel format so that frame
> and stream based format descriptors with this GUID are recognized
> by the UVC video driver.
> ---
>  drivers/media/video/uvc/uvc_driver.c |    5 +++++
>  drivers/media/video/uvc/uvcvideo.h   |    3 +++
>  include/linux/videodev2.h            |    1 +
>  3 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index 6bcb9e1..a5a86ce 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -108,6 +108,11 @@ static struct uvc_format_desc uvc_fmts[] = {
>  		.guid		= UVC_GUID_FORMAT_MPEG,
>  		.fcc		= V4L2_PIX_FMT_MPEG,
>  	},
> +	{
> +		.name		= "H.264",
> +		.guid		= UVC_GUID_FORMAT_H264,
> +		.fcc		= V4L2_PIX_FMT_H264,
> +	},
>  };
> 
>  /*
> ------------------------------------------------------------------------
> diff --git a/drivers/media/video/uvc/uvcvideo.h
> b/drivers/media/video/uvc/uvcvideo.h index e522f99..4f65ac6 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -155,6 +155,9 @@ struct uvc_xu_control {
>  #define UVC_GUID_FORMAT_MPEG \
>  	{ 'M',  'P',  'E',  'G', 0x00, 0x00, 0x10, 0x00, \
>  	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_H264 \
> +	{ 'H',  '2',  '6',  '4', 0x00, 0x00, 0x10, 0x00, \
> +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> 
>  /*
> ------------------------------------------------------------------------ *
> Driver specific constants.
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 5f6f470..d3b5877 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -341,6 +341,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_JPEG     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF JPEG
>     */ #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /*
> 1394          */ #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E',
> 'G') /* MPEG-1/2/4    */ +#define V4L2_PIX_FMT_H264     v4l2_fourcc('H',
> '2', '6', '4') /* H.264 Annex-B NAL Units */

I've discussed H.264 support with Hans Verkuil (CC'ed) some time ago, and his 
opinion was that we shouldn't use a new V4L2 format for it. H.264 is 
essentially an MPEG version, so drivers should use V4L2_PIX_FMT_MPEG and 
select the details using the MPEG CIDs.

Of course feel free to disagree with Hans and discuss the matter with him :-)

>  /*  Vendor-specific formats   */
>  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV
> */

-- 
Regards,

Laurent Pinchart
