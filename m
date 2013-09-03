Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35307 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760816Ab3ICUzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Sep 2013 16:55:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 07/19] uvcvideo: Unify error reporting during format descriptor parsing.
Date: Tue, 03 Sep 2013 22:55:51 +0200
Message-ID: <2439294.Z6LFbPGDUj@avalon>
In-Reply-To: <1377829038-4726-8-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-8-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:06 Pawel Osciak wrote:
> Add common error handling paths for format parsing failures.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 35 ++++++++++++++---------------------
> 1 file changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index d950b40..936ddc7 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -322,13 +322,8 @@ static int uvc_parse_format(struct uvc_device *dev,
>  	case UVC_VS_FORMAT_UNCOMPRESSED:
>  	case UVC_VS_FORMAT_FRAME_BASED:
>  		n = buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED ? 27 : 28;
> -		if (buflen < n) {
> -			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
> -			       "interface %d FORMAT error\n",
> -			       dev->udev->devnum,
> -			       alts->desc.bInterfaceNumber);
> -			return -EINVAL;
> -		}
> +		if (buflen < n)
> +			goto format_error;
> 
>  		/* Find the format descriptor from its GUID. */
>  		fmtdesc = uvc_format_by_guid(&buffer[5]);
> @@ -356,13 +351,8 @@ static int uvc_parse_format(struct uvc_device *dev,
>  		break;
> 
>  	case UVC_VS_FORMAT_MJPEG:
> -		if (buflen < 11) {
> -			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
> -			       "interface %d FORMAT error\n",
> -			       dev->udev->devnum,
> -			       alts->desc.bInterfaceNumber);
> -			return -EINVAL;
> -		}
> +		if (buflen < 11)
> +			goto format_error;
> 
>  		strlcpy(format->name, "MJPEG", sizeof format->name);
>  		format->fcc = V4L2_PIX_FMT_MJPEG;
> @@ -372,13 +362,8 @@ static int uvc_parse_format(struct uvc_device *dev,
>  		break;
> 
>  	case UVC_VS_FORMAT_DV:
> -		if (buflen < 9) {
> -			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
> -			       "interface %d FORMAT error\n",
> -			       dev->udev->devnum,
> -			       alts->desc.bInterfaceNumber);
> -			return -EINVAL;
> -		}
> +		if (buflen < 9)
> +			goto format_error;
> 
>  		switch (buffer[8] & 0x7f) {
>  		case 0:
> @@ -542,6 +527,14 @@ static int uvc_parse_format(struct uvc_device *dev,
>  	}
> 
>  	return buffer - start;
> +
> +format_error:
> +	uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
> +			"interface %d FORMAT error\n",
> +			dev->udev->devnum,
> +			alts->desc.bInterfaceNumber);

Could you please align the lines on UVC_TRACE_DESCR ?

> +	return -EINVAL;
> +

And remove the extra blank line ?

>  }
> 
>  static int uvc_parse_streaming(struct uvc_device *dev,
-- 
Regards,

Laurent Pinchart

