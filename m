Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:50379 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755911Ab0I0IbD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 04:31:03 -0400
Date: Mon, 27 Sep 2010 10:31:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH 2/9] v4l: Group media bus pixel codes by types and
 sort them alphabetically
In-Reply-To: <1285517612-20230-3-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1009271028160.16377@axis700.grange>
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1285517612-20230-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 26 Sep 2010, Laurent Pinchart wrote:

> Adding new pixel codes at the end of the enumeration will soon create a
> mess, so sort the pixel codes by type and then sort them alphabetically.
> 
> As the codes are part of the kernel ABI their value can't change when a
> new code is inserted in the enumeration, so they are given an explicit
> numerical value. When inserting a new pixel code developers must use and
> update the V4L2_MBUS_FMT_LAST value.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/linux/v4l2-mediabus.h |   54 ++++++++++++++++++++++++----------------
>  1 files changed, 32 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> index 127512a..bc637a5 100644
> --- a/include/linux/v4l2-mediabus.h
> +++ b/include/linux/v4l2-mediabus.h
> @@ -24,31 +24,41 @@
>   * transferred first, "BE" means that the most significant bits are transferred
>   * first, and "PADHI" and "PADLO" define which bits - low or high, in the
>   * incomplete high byte, are filled with padding bits.
> + *
> + * The pixel codes are grouped by types and (mostly) sorted alphabetically. As

Why mostly? Wouldn't it make it easier for future additions if we sorted 
them strictly from the beginning?

> + * their value can't change when a new pixel code is inserted in the
> + * enumeration, they are explicitly given a numerical value. When inserting a
> + * new pixel code use and update the V4L2_MBUS_FMT_LAST value.
>   */
>  enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_FIXED = 1,
> -	V4L2_MBUS_FMT_YUYV8_2X8,
> -	V4L2_MBUS_FMT_YVYU8_2X8,
> -	V4L2_MBUS_FMT_UYVY8_2X8,
> -	V4L2_MBUS_FMT_VYUY8_2X8,
> -	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> -	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
> -	V4L2_MBUS_FMT_RGB565_2X8_LE,
> -	V4L2_MBUS_FMT_RGB565_2X8_BE,
> -	V4L2_MBUS_FMT_SBGGR8_1X8,
> -	V4L2_MBUS_FMT_SBGGR10_1X10,
> -	V4L2_MBUS_FMT_GREY8_1X8,
> -	V4L2_MBUS_FMT_Y10_1X10,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> -	V4L2_MBUS_FMT_SGRBG8_1X8,
> -	V4L2_MBUS_FMT_SBGGR12_1X12,
> -	V4L2_MBUS_FMT_YUYV8_1_5X8,
> -	V4L2_MBUS_FMT_YVYU8_1_5X8,
> -	V4L2_MBUS_FMT_UYVY8_1_5X8,
> -	V4L2_MBUS_FMT_VYUY8_1_5X8,
> +	/* RGB */
> +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 7,
> +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE = 6,
> +	V4L2_MBUS_FMT_RGB565_2X8_BE = 9,
> +	V4L2_MBUS_FMT_RGB565_2X8_LE = 8,
> +	/* YUV (including grey) */
> +	V4L2_MBUS_FMT_GREY8_1X8 = 12,
> +	V4L2_MBUS_FMT_Y10_1X10 = 13,
> +	V4L2_MBUS_FMT_YUYV8_1_5X8 = 20,
> +	V4L2_MBUS_FMT_YVYU8_1_5X8 = 21,
> +	V4L2_MBUS_FMT_UYVY8_1_5X8 = 22,
> +	V4L2_MBUS_FMT_VYUY8_1_5X8 = 23,
> +	V4L2_MBUS_FMT_YUYV8_2X8 = 2,
> +	V4L2_MBUS_FMT_UYVY8_2X8 = 4,
> +	V4L2_MBUS_FMT_YVYU8_2X8 = 3,
> +	V4L2_MBUS_FMT_VYUY8_2X8 = 5,
> +	/* Bayer */
> +	V4L2_MBUS_FMT_SBGGR8_1X8 = 10,
> +	V4L2_MBUS_FMT_SBGGR10_1X10 = 11,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 16,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 14,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 17,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 15,
> +	V4L2_MBUS_FMT_SBGGR12_1X12 = 19,
> +	V4L2_MBUS_FMT_SGRBG8_1X8 = 18,
> +	/* Last - Update this when adding a new pixel code */
> +	V4L2_MBUS_FMT_LAST = 24,
>  };
>  
>  /**
> -- 
> 1.7.2.2

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
