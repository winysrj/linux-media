Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:43093 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934684AbdCVNyo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 09:54:44 -0400
Subject: Re: [PATCH v4 2/6] media: uapi: Add RGB and YUV bus formats for
 Synopsys HDMI TX Controller
To: Neil Armstrong <narmstrong@baylibre.com>,
        <dri-devel@lists.freedesktop.org>,
        <laurent.pinchart+renesas@ideasonboard.com>,
        <architt@codeaurora.org>, <mchehab@kernel.org>
References: <1490109161-20529-1-git-send-email-narmstrong@baylibre.com>
 <1490109161-20529-3-git-send-email-narmstrong@baylibre.com>
CC: <Jose.Abreu@synopsys.com>, <kieran.bingham@ideasonboard.com>,
        <linux-amlogic@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <hans.verkuil@cisco.com>, <sakari.ailus@linux.intel.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <d4928e0c-ee95-53d0-788f-22b948db19fa@synopsys.com>
Date: Wed, 22 Mar 2017 13:54:33 +0000
MIME-Version: 1.0
In-Reply-To: <1490109161-20529-3-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,


On 21-03-2017 15:12, Neil Armstrong wrote:
> In order to describe the RGB and YUV bus formats used to feed the
> Synopsys DesignWare HDMI TX Controller, add missing formats to the
> list of Bus Formats.
>
> Documentation for these formats is added in a separate patch.
>
> Reviewed-by: Archit Taneja <architt@codeaurora.org>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>

Reviewed-by: Jose Abreu <joabreu@synopsys.com>

Best regards,
Jose Miguel Abreu

> ---
>  include/uapi/linux/media-bus-format.h | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
> index 2168759..6c8f31c 100644
> --- a/include/uapi/linux/media-bus-format.h
> +++ b/include/uapi/linux/media-bus-format.h
> @@ -33,7 +33,7 @@
>  
>  #define MEDIA_BUS_FMT_FIXED			0x0001
>  
> -/* RGB - next is	0x1018 */
> +/* RGB - next is	0x101b */
>  #define MEDIA_BUS_FMT_RGB444_1X12		0x1016
>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
> @@ -57,8 +57,11 @@
>  #define MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA	0x1012
>  #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
>  #define MEDIA_BUS_FMT_RGB888_1X32_PADHI		0x100f
> +#define MEDIA_BUS_FMT_RGB101010_1X30		0x1018
> +#define MEDIA_BUS_FMT_RGB121212_1X36		0x1019
> +#define MEDIA_BUS_FMT_RGB161616_1X48		0x101a
>  
> -/* YUV (including grey) - next is	0x2026 */
> +/* YUV (including grey) - next is	0x202c */
>  #define MEDIA_BUS_FMT_Y8_1X8			0x2001
>  #define MEDIA_BUS_FMT_UV8_1X8			0x2015
>  #define MEDIA_BUS_FMT_UYVY8_1_5X8		0x2002
> @@ -90,12 +93,18 @@
>  #define MEDIA_BUS_FMT_YVYU10_1X20		0x200e
>  #define MEDIA_BUS_FMT_VUY8_1X24			0x2024
>  #define MEDIA_BUS_FMT_YUV8_1X24			0x2025
> +#define MEDIA_BUS_FMT_UYYVYY8_1X24		0x2026
>  #define MEDIA_BUS_FMT_UYVY12_1X24		0x2020
>  #define MEDIA_BUS_FMT_VYUY12_1X24		0x2021
>  #define MEDIA_BUS_FMT_YUYV12_1X24		0x2022
>  #define MEDIA_BUS_FMT_YVYU12_1X24		0x2023
>  #define MEDIA_BUS_FMT_YUV10_1X30		0x2016
> +#define MEDIA_BUS_FMT_UYYVYY10_1X30		0x2027
>  #define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
> +#define MEDIA_BUS_FMT_UYYVYY12_1X36		0x2028
> +#define MEDIA_BUS_FMT_YUV12_1X36		0x2029
> +#define MEDIA_BUS_FMT_YUV16_1X48		0x202a
> +#define MEDIA_BUS_FMT_UYYVYY16_1X48		0x202b
>  
>  /* Bayer - next is	0x3021 */
>  #define MEDIA_BUS_FMT_SBGGR8_1X8		0x3001
