Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58214 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1CIXjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 18:39:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH v2 2/4] media: add 8-bit bayer formats and Y12
Date: Thu, 10 Mar 2011 00:39:40 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1299686863-20701-1-git-send-email-michael.jones@matrix-vision.de> <1299686863-20701-3-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1299686863-20701-3-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103100039.42581.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

Thanks for the patch.

On Wednesday 09 March 2011 17:07:41 Michael Jones wrote:
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/linux/v4l2-mediabus.h |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> index 7054a7a..46caecd 100644
> --- a/include/linux/v4l2-mediabus.h
> +++ b/include/linux/v4l2-mediabus.h
> @@ -47,8 +47,9 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
>  	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
> 
> -	/* YUV (including grey) - next is 0x2013 */
> +	/* YUV (including grey) - next is 0x2014 */
>  	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
> +	V4L2_MBUS_FMT_Y12_1X12 = 0x2013,
>  	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
>  	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
>  	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2004,
> @@ -67,9 +68,11 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
>  	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
> 
> -	/* Bayer - next is 0x3013 */
> +	/* Bayer - next is 0x3015 */
>  	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
> +	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
>  	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
> +	V4L2_MBUS_FMT_SRGGB8_1X8 = 0x3014,
>  	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
>  	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 = 0x300c,
>  	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,

Could you please also document those formats in 
Documentation/DocBook/v4l/subdev-formats.xml ?

-- 
Regards,

Laurent Pinchart
