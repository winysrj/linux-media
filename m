Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57021 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1BQQDR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 11:03:17 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
Subject: Re: [PATCH RFC] uvcvideo: Add support for MPEG-2 TS payload
Date: Thu, 17 Feb 2011 17:03:16 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-uvc-devel@lists.berlios.de" <linux-uvc-devel@lists.berlios.de>
References: <1296243305.17673.20.camel@svmlwks101>
In-Reply-To: <1296243305.17673.20.camel@svmlwks101>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171703.17164.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Stephan,

On Friday 28 January 2011 20:35:05 Stephan Lachowsky wrote:
> Parse the UVC 1.0 and UVC 1.1 VS_FORMAT_MPEG2TS descriptors.
> This a stream based format, so we generate a dummy frame descriptor
> with a dummy frame interval range.

Thanks for the patch, and sorry for the late reply.

Don't you also need to implement support for the V4L2 MPEG CIDs ? I would 
expect the driver to support at least the controls used to select the MPEG 
format (MPEG2, TS), even if they're hardcoded to MPEG2-TS.

> ---
>  drivers/media/video/uvc/uvc_driver.c |   41
> ++++++++++++++++++++++++++++++++++ drivers/media/video/uvc/uvcvideo.h   | 
>   3 ++
>  2 files changed, 44 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index a1e9dfb..6bcb9e1 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -103,6 +103,11 @@ static struct uvc_format_desc uvc_fmts[] = {
>  		.guid		= UVC_GUID_FORMAT_BY8,
>  		.fcc		= V4L2_PIX_FMT_SBGGR8,
>  	},
> +	{
> +		.name		= "MPEG2 TS",
> +		.guid		= UVC_GUID_FORMAT_MPEG,
> +		.fcc		= V4L2_PIX_FMT_MPEG,
> +	},
>  };
> 
>  /*
> ------------------------------------------------------------------------
> @@ -398,6 +403,33 @@ static int uvc_parse_format(struct uvc_device *dev,
> break;
> 
>  	case UVC_VS_FORMAT_MPEG2TS:
> +		n = dev->uvc_version >= 0x0110 ? 23 : 7;
> +		if (buflen < n) {
> +			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
> +			       "interface %d FORMAT error\n",
> +			       dev->udev->devnum,
> +			       alts->desc.bInterfaceNumber);
> +			return -EINVAL;
> +		}
> +
> +		strlcpy(format->name, "MPEG2 TS", sizeof format->name);
> +		format->fcc = V4L2_PIX_FMT_MPEG;
> +		format->flags = UVC_FMT_FLAG_COMPRESSED | UVC_FMT_FLAG_STREAM;
> +		format->bpp = 0;
> +		ftype = 0;
> +
> +		/* Create a dummy frame descriptor. */
> +		frame = &format->frame[0];
> +		memset(&format->frame[0], 0, sizeof format->frame[0]);
> +		frame->bFrameIntervalType = 0;
> +		frame->dwDefaultFrameInterval = 1;
> +		frame->dwFrameInterval = *intervals;
> +		*(*intervals)++ = 1;
> +		*(*intervals)++ = 10000000;
> +		*(*intervals)++ = 1;
> +		format->nframes = 1;
> +		break;
> +
>  	case UVC_VS_FORMAT_STREAM_BASED:
>  		/* Not supported yet. */
>  	default:
> @@ -673,6 +705,14 @@ static int uvc_parse_streaming(struct uvc_device *dev,
>  			break;
> 
>  		case UVC_VS_FORMAT_MPEG2TS:
> +			/* MPEG2TS format has no frame descriptor. We will create a
> +			 * dummy frame descriptor with a dummy frame interval range.
> +			 */
> +			nformats++;
> +			nframes++;
> +			nintervals += 3;
> +			break;
> +
>  		case UVC_VS_FORMAT_STREAM_BASED:
>  			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
>  				"interface %d FORMAT %u is not supported.\n",
> @@ -724,6 +764,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
>  		switch (buffer[2]) {
>  		case UVC_VS_FORMAT_UNCOMPRESSED:
>  		case UVC_VS_FORMAT_MJPEG:
> +		case UVC_VS_FORMAT_MPEG2TS:
>  		case UVC_VS_FORMAT_DV:
>  		case UVC_VS_FORMAT_FRAME_BASED:
>  			format->frame = frame;
> diff --git a/drivers/media/video/uvc/uvcvideo.h
> b/drivers/media/video/uvc/uvcvideo.h index 45f01e7..e522f99 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -152,6 +152,9 @@ struct uvc_xu_control {
>  #define UVC_GUID_FORMAT_BY8 \
>  	{ 'B',  'Y',  '8',  ' ', 0x00, 0x00, 0x10, 0x00, \
>  	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_MPEG \
> +	{ 'M',  'P',  'E',  'G', 0x00, 0x00, 0x10, 0x00, \
> +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> 
>  /*
> ------------------------------------------------------------------------ *
> Driver specific constants.

-- 
Regards,

Laurent Pinchart
