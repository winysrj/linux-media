Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51425 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1LONC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 08:02:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH 1/2] media: add new mediabus format enums for dm365
Date: Thu, 15 Dec 2011 14:02:44 +0100
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
References: <1323951898-16330-1-git-send-email-manjunath.hadli@ti.com> <1323951898-16330-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1323951898-16330-2-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112151402.45100.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manhunath,

Thanks for the patch.

On Thursday 15 December 2011 13:24:57 Manjunath Hadli wrote:
> add new enum entry V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 into mbus_pixel_code
> to represent A-LAW compressed Bayer format. This corresponds to pixel
> format - V4L2_PIX_FMT_SGRBG10ALAW8.
> add UV8 and NV12 ( Y and C separate with UV interleaved) which are
> supported on dm365.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/linux/v4l2-mediabus.h |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)

Please also update the documentation in Documentation/DocBook/media/v4l.

> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> index 5ea7f75..d408654 100644
> --- a/include/linux/v4l2-mediabus.h
> +++ b/include/linux/v4l2-mediabus.h
> @@ -47,7 +47,7 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
>  	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
> 
> -	/* YUV (including grey) - next is 0x2014 */
> +	/* YUV (including grey) - next is 0x2016 */
>  	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
>  	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
>  	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
> @@ -67,8 +67,10 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
>  	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
>  	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
> +	V4L2_MBUS_FMT_NV12_1X20 = 0x2014,
> +	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,

NV12, on the bus ? How does that work ? (The documentation should answer my 
question :-))

> -	/* Bayer - next is 0x3015 */
> +	/* Bayer - next is 0x3019 */
>  	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
>  	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
>  	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
> @@ -89,6 +91,10 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_SGBRG12_1X12 = 0x3010,
>  	V4L2_MBUS_FMT_SGRBG12_1X12 = 0x3011,
>  	V4L2_MBUS_FMT_SRGGB12_1X12 = 0x3012,
> +	V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 = 0x3015,
> +	V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8 = 0x3016,
> +	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 = 0x3017,
> +	V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8 = 0x3018,

Please keep the names sorted as described in the comment at the beginning of 
the file.

> 
>  	/* JPEG compressed formats - next is 0x4002 */
>  	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,

-- 
Regards,

Laurent Pinchart
