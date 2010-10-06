Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:34605 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab0JFJTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 05:19:32 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Wed, 6 Oct 2010 14:49:21 +0530
Subject: RE: [PATCH/RFC v3 03/11] v4l: Group media bus pixel codes by types
 and sort them alphabetically
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21CCB1@dbde02.ent.ti.com>
References: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1286288714-16506-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286288714-16506-4-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Tuesday, October 05, 2010 7:55 PM
> To: linux-media@vger.kernel.org
> Cc: sakari.ailus@maxwell.research.nokia.com
> Subject: [PATCH/RFC v3 03/11] v4l: Group media bus pixel codes by types
> and sort them alphabetically
> 
> Adding new pixel codes at the end of the enumeration will soon create a
> mess, so group the pixel codes by type and sort them by bus_width, bits
> per component, samples per pixel and order of subsamples.
> 
> As the codes are part of the kernel ABI their value can't change when a
> new code is inserted in the enumeration, so they are given an explicit
> numerical value. When inserting a new pixel code developers must use and
> update the next free value.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/linux/v4l2-mediabus.h |   61 +++++++++++++++++++++++++-----------
> ----
>  1 files changed, 38 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> index 75c2d55..53c81f2 100644
> --- a/include/linux/v4l2-mediabus.h
> +++ b/include/linux/v4l2-mediabus.h
> @@ -24,31 +24,46 @@
>   * transferred first, "BE" means that the most significant bits are
> transferred
>   * first, and "PADHI" and "PADLO" define which bits - low or high, in the
>   * incomplete high byte, are filled with padding bits.
> + *
> + * The pixel codes are grouped by type, bus_width, bits per component,
> samples
> + * per pixel and order of subsamples. Numerical values are sorted using
> generic
> + * numerical sort order (8 thus comes before 10).
> + *
> + * As their value can't change when a new pixel code is inserted in the
> + * enumeration, the pixel codes are explicitly given a numerical value.
> The next
> + * free values for each category are listed below, update them when
> inserting
> + * new pixel codes.
>   */
>  enum v4l2_mbus_pixelcode {
> -	V4L2_MBUS_FMT_FIXED = 1,
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
> -	V4L2_MBUS_FMT_Y8_1X8,
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
> +	V4L2_MBUS_FMT_FIXED = 0x0001,
> +
> +	/* RGB - next is 0x1005 */
[Hiremath, Vaibhav] Don't you think adding "next is 0x" is not required? Also while adding to this list someone has to modify here too.

Same applies to all such places.

Thanks,
Vaibhav
> +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1001,
> +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE = 0x1002,
> +	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1003,
> +	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1004,
> +
> +	/* YUV (including grey) - next is 0x200b */
> +	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
> +	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
> +	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
> +	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2004,
> +	V4L2_MBUS_FMT_YVYU8_1_5X8 = 0x2005,
> +	V4L2_MBUS_FMT_UYVY8_2X8 = 0x2006,
> +	V4L2_MBUS_FMT_VYUY8_2X8 = 0x2007,
> +	V4L2_MBUS_FMT_YUYV8_2X8 = 0x2008,
> +	V4L2_MBUS_FMT_YVYU8_2X8 = 0x2009,
> +	V4L2_MBUS_FMT_Y10_1X10 = 0x200a,
> +
> +	/* Bayer - next is 0x3009 */
> +	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
> +	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3003,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3004,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3005,
> +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3006,
> +	V4L2_MBUS_FMT_SBGGR10_1X10 = 0x3007,
> +	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,
>  };
> 
>  /**
> --
> 1.7.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
