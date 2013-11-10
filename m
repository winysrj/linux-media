Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43163 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3KJW3f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 17:29:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 08/19] uvcvideo: Add UVC1.5 VP8 format support.
Date: Sun, 10 Nov 2013 23:30:09 +0100
Message-ID: <9889033.QClsvketAP@avalon>
In-Reply-To: <1377829038-4726-9-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-9-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:07 Pawel Osciak wrote:
> Add detection and parsing of VP8 format and frame descriptors and
> reorganize format parsing code.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 120 +++++++++++++++++++++++++---------
>  drivers/media/usb/uvc/uvcvideo.h   |   4 +-
>  include/uapi/linux/usb/video.h     |   8 +++
>  3 files changed, 104 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 936ddc7..27a7a11 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -312,7 +312,7 @@ static int uvc_parse_format(struct uvc_device *dev,
>  	struct uvc_frame *frame;
>  	const unsigned char *start = buffer;
>  	unsigned int interval;
> -	unsigned int i, n;
> +	unsigned int i, n, intervals_off;

Could you please define the intervals_off variable on a new line, right above 
interval ?

>  	__u8 ftype;
> 
>  	format->type = buffer[2];
> @@ -401,6 +401,18 @@ static int uvc_parse_format(struct uvc_device *dev,
>  		format->nframes = 1;
>  		break;
> 
> +	case UVC_VS_FORMAT_VP8:
> +		if (buflen < 13)
> +			goto format_error;
> +
> +		format->bpp = 0;
> +		format->flags = UVC_FMT_FLAG_COMPRESSED;
> +		ftype = UVC_VS_FRAME_VP8;

Nitpicking, could you please move this line after format->fcc, to keep 
statements initializing format together ?

> +		strlcpy(format->name, "VP8", sizeof(format->name));
> +		format->fcc = V4L2_PIX_FMT_VP8;
> +
> +		break;
> +
>  	case UVC_VS_FORMAT_MPEG2TS:
>  	case UVC_VS_FORMAT_STREAM_BASED:
>  		/* Not supported yet. */
> @@ -417,44 +429,83 @@ static int uvc_parse_format(struct uvc_device *dev,
>  	buflen -= buffer[0];
>  	buffer += buffer[0];
> 
> -	/* Parse the frame descriptors. Only uncompressed, MJPEG and frame
> -	 * based formats have frame descriptors.
> +	/* Parse the frame descriptors. Only uncompressed, MJPEG, temporally
> +	 * encoded and frame based formats have frame descriptors.
>  	 */
>  	while (buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
>  	       buffer[2] == ftype) {
>  		frame = &format->frame[format->nframes];
> -		if (ftype != UVC_VS_FRAME_FRAME_BASED)
> -			n = buflen > 25 ? buffer[25] : 0;
> -		else
> -			n = buflen > 21 ? buffer[21] : 0;
> -
> -		n = n ? n : 3;
> 
> -		if (buflen < 26 + 4*n) {
> -			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
> -			       "interface %d FRAME error\n", dev->udev->devnum,
> -			       alts->desc.bInterfaceNumber);
> -			return -EINVAL;
> -		}
> -
> -		frame->bFrameIndex = buffer[3];
> -		frame->bmCapabilities = buffer[4];
> -		frame->wWidth = get_unaligned_le16(&buffer[5]);
> -		frame->wHeight = get_unaligned_le16(&buffer[7]);
> -		frame->dwMinBitRate = get_unaligned_le32(&buffer[9]);
> -		frame->dwMaxBitRate = get_unaligned_le32(&buffer[13]);
> -		if (ftype != UVC_VS_FRAME_FRAME_BASED) {

I'd like to create a uvc_parse_frame function for the code below. The function 
should be created in a new patch before this one. I can do it if you would 
like me to.

> +		switch (ftype) {
> +		case UVC_VS_FRAME_UNCOMPRESSED:
> +		case UVC_VS_FRAME_MJPEG:
> +			intervals_off = 26;
> +			if (buflen < intervals_off)
> +				goto frame_error;
> +
> +			frame->bFrameIndex = buffer[3];
> +			frame->bmCapabilities = buffer[4];
> +			frame->wWidth = get_unaligned_le16(&buffer[5]);
> +			frame->wHeight = get_unaligned_le16(&buffer[7]);
> +			frame->dwMinBitRate = get_unaligned_le32(&buffer[9]);
> +			frame->dwMaxBitRate = get_unaligned_le32(&buffer[13]);
>  			frame->dwMaxVideoFrameBufferSize =
>  				get_unaligned_le32(&buffer[17]);
>  			frame->dwDefaultFrameInterval =
>  				get_unaligned_le32(&buffer[21]);
> -			frame->bFrameIntervalType = buffer[25];
> -		} else {
> +			frame->bFrameIntervalType = n = buffer[25];

One assignement per line please.

> +			break;
> +
> +		case UVC_VS_FRAME_FRAME_BASED:
> +			intervals_off = 26;
> +			if (buflen < intervals_off)
> +				goto frame_error;
> +
> +			frame->bFrameIndex = buffer[3];
> +			frame->bmCapabilities = buffer[4];
> +			frame->wWidth = get_unaligned_le16(&buffer[5]);
> +			frame->wHeight = get_unaligned_le16(&buffer[7]);
> +			frame->dwMinBitRate = get_unaligned_le32(&buffer[9]);
> +			frame->dwMaxBitRate = get_unaligned_le32(&buffer[13]);
>  			frame->dwMaxVideoFrameBufferSize = 0;
>  			frame->dwDefaultFrameInterval =
>  				get_unaligned_le32(&buffer[17]);
> -			frame->bFrameIntervalType = buffer[21];
> +			frame->bFrameIntervalType = n = buffer[21];

What about combining the 3 cases above ? Most of the code is identical.

> +			break;
> +
> +		case UVC_VS_FRAME_VP8:
> +			intervals_off = 31;
> +			if (buflen < intervals_off)
> +				goto frame_error;
> +
> +			frame->bFrameIndex = buffer[3];
> +			frame->bmSupportedUsages =
> +				get_unaligned_le32(&buffer[8]);
> +			frame->bmCapabilities =
> +				get_unaligned_le16(&buffer[12]);
> +			frame->bmScalabilityCapabilities =
> +				get_unaligned_le32(&buffer[14]);
> +			frame->wWidth = get_unaligned_le16(&buffer[4]);
> +			frame->wHeight = get_unaligned_le16(&buffer[6]);

Could you keep these sorted by the buffer offset ?

> +			frame->dwMinBitRate = get_unaligned_le32(&buffer[18]);
> +			frame->dwMaxBitRate = get_unaligned_le32(&buffer[22]);
> +			frame->dwMaxVideoFrameBufferSize = 0;
> +			frame->dwDefaultFrameInterval =
> +				get_unaligned_le32(&buffer[26]);
> +			frame->bFrameIntervalType = n = buffer[30];

One assignment per line here as well please.

VP8 doesn't seem to support continuous frame intervals. Are the number of 
frames intervals always greater than 0, or is a 0 value valid ?

> +			break;
> +
> +		default:
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				"Unsupported frame descriptor %d\n", ftype);
> +			return -EINVAL;
>  		}
> +
> +		/* For n=0 - continuous intervals given, always 3 values. */
> +		n = n ? n : 3;

Maybe

		/* A zero frame interval type indicates a continuous range,
		 * always described by 3 values.
		 */
		n = frame->bFrameIntervalType ? frame->bFrameIntervalType : 3;

You could then get rid of the n assignment in the different cases.

> +		if (buflen < intervals_off + 4 * n)
> +			goto frame_error;
> +
>  		frame->dwFrameInterval = *intervals;
> 
>  		/* Several UVC chipsets screw up dwMaxVideoFrameBufferSize
> @@ -475,12 +526,14 @@ static int uvc_parse_format(struct uvc_device *dev,
>  		 * some other divisions by zero that could happen.
>  		 */
>  		for (i = 0; i < n; ++i) {
> -			interval = get_unaligned_le32(&buffer[26+4*i]);
> +			interval = get_unaligned_le32(
> +					&buffer[intervals_off + 4 * i]);
>  			*(*intervals)++ = interval ? interval : 1;
>  		}
> 
>  		/* Make sure that the default frame interval stays between
>  		 * the boundaries.
> +		 * For type = 0, the last value is interval step, so skip it.
>  		 */
>  		n -= frame->bFrameIntervalType ? 1 : 2;
>  		frame->dwDefaultFrameInterval =
> @@ -535,6 +588,11 @@ format_error:
>  			alts->desc.bInterfaceNumber);
>  	return -EINVAL;
> 
> +frame_error:
> +	uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
> +			"interface %d FRAME error\n", dev->udev->devnum,
> +			alts->desc.bInterfaceNumber);
> +	return -EINVAL;
>  }
> 
>  static int uvc_parse_streaming(struct uvc_device *dev,


-- 
Regards,

Laurent Pinchart

