Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab1CDPqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 10:46:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH 3/4] omap3isp: ccdc: support Y10, Y12, SGRBG8, SBGGR8
Date: Fri, 4 Mar 2011 16:46:20 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1299229084-8335-1-git-send-email-michael.jones@matrix-vision.de> <1299229084-8335-4-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1299229084-8335-4-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103041646.20563.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

Thanks for the patch.

On Friday 04 March 2011 09:58:03 Michael Jones wrote:
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> ---
>  drivers/media/video/omap3-isp/ispccdc.c  |    4 ++++
>  drivers/media/video/omap3-isp/ispvideo.c |    8 ++++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap3-isp/ispccdc.c
> b/drivers/media/video/omap3-isp/ispccdc.c index e4d04ce..166115d 100644
> --- a/drivers/media/video/omap3-isp/ispccdc.c
> +++ b/drivers/media/video/omap3-isp/ispccdc.c
> @@ -43,6 +43,10 @@ __ccdc_get_format(struct isp_ccdc_device *ccdc, struct
> v4l2_subdev_fh *fh,
> 
>  static const unsigned int ccdc_fmts[] = {
>  	V4L2_MBUS_FMT_Y8_1X8,
> +	V4L2_MBUS_FMT_Y10_1X10,
> +	V4L2_MBUS_FMT_Y12_1X12,
> +	V4L2_MBUS_FMT_SGRBG8_1X8,
> +	V4L2_MBUS_FMT_SBGGR8_1X8,

While you're at it, what about SGBRG8_1X8 and SRGGB8_1X8 (here and in 
ispvideo.c) ?

>  	V4L2_MBUS_FMT_SGRBG10_1X10,
>  	V4L2_MBUS_FMT_SRGGB10_1X10,
>  	V4L2_MBUS_FMT_SBGGR10_1X10,
> diff --git a/drivers/media/video/omap3-isp/ispvideo.c
> b/drivers/media/video/omap3-isp/ispvideo.c index f16d787..c406043 100644
> --- a/drivers/media/video/omap3-isp/ispvideo.c
> +++ b/drivers/media/video/omap3-isp/ispvideo.c
> @@ -48,6 +48,14 @@
>  static struct isp_format_info formats[] = {
>  	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
>  	  V4L2_MBUS_FMT_Y8_1X8, V4L2_PIX_FMT_GREY, 8, },
> +	{ V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y10_1X10,
> +	  V4L2_MBUS_FMT_Y10_1X10, V4L2_PIX_FMT_Y10, 10, },
> +	{ V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y10_1X10,
> +	  V4L2_MBUS_FMT_Y12_1X12, V4L2_PIX_FMT_Y12, 12, },
> +	{ V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
> +	  V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_PIX_FMT_SBGGR8, 8, },
> +	{ V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
> +	  V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_PIX_FMT_SGRBG8, 8, },
>  	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
>  	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
>  	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,

-- 
Regards,

Laurent Pinchart
