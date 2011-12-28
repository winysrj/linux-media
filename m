Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab1L1K0p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 05:26:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 2/2] omap3isp: Support additional in-memory compressed bayer formats
Date: Wed, 28 Dec 2011 11:26:49 +0100
Cc: linux-media@vger.kernel.org
References: <20111228102028.GR3677@valkosipuli.localdomain> <1325067657-32556-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1325067657-32556-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112281126.49602.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Wednesday 28 December 2011 11:20:57 Sakari Ailus wrote:
> This also prevents accessing NULL pointer in csi2_try_format().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/omap3isp/ispvideo.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index 0568234..3c984ae 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -46,6 +46,10 @@
>   * Helper functions
>   */
> 
> +/*
> + * NOTE: When adding new media bus codes, always remember to add
> + * corresponding in-memory formats to the table below!!!
> + */
>  static struct isp_format_info formats[] = {
>  	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
>  	  V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
> @@ -68,9 +72,18 @@ static struct isp_format_info formats[] = {
>  	{ V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
>  	  V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
>  	  V4L2_PIX_FMT_SRGGB8, 8, },
> +	{ V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8, V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8,
> +	  V4L2_MBUS_FMT_SBGGR10_1X10, 0,
> +	  V4L2_PIX_FMT_SBGGR10DPCM8, 8, },
> +	{ V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8, V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8,
> +	  V4L2_MBUS_FMT_SGBRG10_1X10, 0,
> +	  V4L2_PIX_FMT_SGBRG10DPCM8, 8, },
>  	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
>  	  V4L2_MBUS_FMT_SGRBG10_1X10, 0,
>  	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
> +	{ V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8, V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8,
> +	  V4L2_MBUS_FMT_SRGGB10_1X10, 0,
> +	  V4L2_PIX_FMT_SRGGB10DPCM8, 8, },
>  	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
>  	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR8_1X8,
>  	  V4L2_PIX_FMT_SBGGR10, 10, },

-- 
Regards,

Laurent Pinchart
