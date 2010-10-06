Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:53572 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab0JFJTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 05:19:35 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Wed, 6 Oct 2010 14:49:25 +0530
Subject: RE: [PATCH/RFC v3 04/11] v4l: Add 8-bit YUYV on 16-bit bus and
 SGRBG10 media bus pixel codes
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21CCB2@dbde02.ent.ti.com>
References: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1286288714-16506-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286288714-16506-5-git-send-email-laurent.pinchart@ideasonboard.com>
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
> Subject: [PATCH/RFC v3 04/11] v4l: Add 8-bit YUYV on 16-bit bus and
> SGRBG10 media bus pixel codes
> 
> Add the following media bus format code definitions:
> 
> - V4L2_MBUS_FMT_SGRBG10_1X10 for 10-bit GRBG Bayer
> - V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 for 10-bit DPCM compressed GRBG Bayer
> - V4L2_MBUS_FMT_YUYV16_1X16 for 8-bit YUYV on 16-bit bus
> - V4L2_MBUS_FMT_UYVY16_1X16 for 8-bit UYVY on 16-bit bus
> - V4L2_MBUS_FMT_YVYU16_1X16 for 8-bit YVYU on 16-bit bus
> - V4L2_MBUS_FMT_VYUY16_1X16 for 8-bit VYUY on 16-bit bus
> 
[Hiremath, Vaibhav] Laurent I may be wrong here, but I think above definition is confusing -

For me the above definition actually means, 16bits are coming on the bus for every cycle.

If you are referring to OMAP3 interface here then 8->16 bit conversion happens inside ISP-bridge, the interface from sensor-to-CCDC is still 8 bit (Technically it is 10, but we are using lane shifter to get 8 bits) and I believe sensor is also sending one component for every cycle (either UYVY or YUYV).

And I believe the bridge driver is not exported to user application so we should be using MBUS_FMT_UYVY8_2x8 and family.

Thanks,
Vaibhav

> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/linux/v4l2-mediabus.h |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> index 53c81f2..8987d4b 100644
> --- a/include/linux/v4l2-mediabus.h
> +++ b/include/linux/v4l2-mediabus.h
> @@ -43,7 +43,7 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1003,
>  	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1004,
> 
> -	/* YUV (including grey) - next is 0x200b */
> +	/* YUV (including grey) - next is 0x200f */
>  	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
>  	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
>  	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
> @@ -54,15 +54,21 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_YUYV8_2X8 = 0x2008,
>  	V4L2_MBUS_FMT_YVYU8_2X8 = 0x2009,
>  	V4L2_MBUS_FMT_Y10_1X10 = 0x200a,
> +	V4L2_MBUS_FMT_UYVY8_1X16 = 0x200b,
> +	V4L2_MBUS_FMT_VYUY8_1X16 = 0x200c,
> +	V4L2_MBUS_FMT_YUYV8_1X16 = 0x200d,
> +	V4L2_MBUS_FMT_YVYU8_1X16 = 0x200e,
> 
> -	/* Bayer - next is 0x3009 */
> +	/* Bayer - next is 0x300b */
>  	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
>  	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
> +	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,
>  	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3003,
>  	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3004,
>  	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3005,
>  	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3006,
>  	V4L2_MBUS_FMT_SBGGR10_1X10 = 0x3007,
> +	V4L2_MBUS_FMT_SGRBG10_1X10 = 0x300a,
>  	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,
>  };
> 
> --
> 1.7.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
