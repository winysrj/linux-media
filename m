Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56023 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754599AbdHVGyc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 02:54:32 -0400
Subject: Re: [PATCH 3/3] media: atmel-isc: Add more format configurations
To: Wenyou Yang <wenyou.yang@microchip.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20170817071614.12767-1-wenyou.yang@microchip.com>
 <20170817071614.12767-4-wenyou.yang@microchip.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3b7a0d2a-f8e7-93d1-6cfc-78bfe5e4dbba@xs4all.nl>
Date: Tue, 22 Aug 2017 08:54:26 +0200
MIME-Version: 1.0
In-Reply-To: <20170817071614.12767-4-wenyou.yang@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/17/2017 09:16 AM, Wenyou Yang wrote:
> Add the configuration of formats: GREY, ARGB444, ARGB555 and ARGB32.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
> ---
> 
>  drivers/media/platform/atmel/atmel-isc.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> index d91f4e5f8a8d..4e18fe1104c8 100644
> --- a/drivers/media/platform/atmel/atmel-isc.c
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -184,7 +184,7 @@ struct isc_device {
>  #define RAW_FMT_IND_START    0
>  #define RAW_FMT_IND_END      11
>  #define ISC_FMT_IND_START    12
> -#define ISC_FMT_IND_END      14
> +#define ISC_FMT_IND_END      18

Shouldn't this be 19?

Regards,

	Hans

>  
>  static struct isc_format isc_formats[] = {
>  	/* 0 */
> @@ -246,12 +246,30 @@ static struct isc_format isc_formats[] = {
>  	{ V4L2_PIX_FMT_YUV422P, 0x0, 16,
>  	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_YYCC,
>  	  ISC_DCFG_IMODE_YC422P, ISC_DCTRL_DVIEW_PLANAR, 0x3fb },
> +
>  	/* 14 */
> +	{ V4L2_PIX_FMT_GREY, MEDIA_BUS_FMT_Y8_1X8, 8,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DATY8,
> +	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x1fb },
> +
> +	/* 15 */
> +	{ V4L2_PIX_FMT_ARGB444, MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE, 16,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_ARGB444,
> +	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x7b },
> +	/* 16 */
> +	{ V4L2_PIX_FMT_ARGB555, MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE, 16,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_ARGB555,
> +	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x7b },
> +	/* 17 */
>  	{ V4L2_PIX_FMT_RGB565, MEDIA_BUS_FMT_RGB565_2X8_LE, 16,
>  	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_RGB565,
>  	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x7b },
> +	/* 18 */
> +	{ V4L2_PIX_FMT_ARGB32, MEDIA_BUS_FMT_ARGB8888_1X32, 32,
> +	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_ARGB32,
> +	  ISC_DCFG_IMODE_PACKED32, ISC_DCTRL_DVIEW_PACKED, 0x7b },
>  
> -	/* 15 */
> +	/* 19 */
>  	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YUYV8_2X8, 16,
>  	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT8,
>  	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0 },
> 
