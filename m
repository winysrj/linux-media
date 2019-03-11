Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E10C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB28E206BA
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfCKOgb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:36:31 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52775 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbfCKOga (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 10:36:30 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3M2PhS7N74HFn3M2ShExpF; Mon, 11 Mar 2019 15:36:24 +0100
Subject: Re: [PATCH] media: atmel: atmel-isc: reworked driver and formats
To:     Eugen.Hristev@microchip.com, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mchehab@kernel.org, Nicolas.Ferre@microchip.com,
        ksloat@aampglobal.com, sakari.ailus@iki.fi
References: <1550219467-9532-1-git-send-email-eugen.hristev@microchip.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6eaea987-e87f-2b8c-f347-c67ccc8148f2@xs4all.nl>
Date:   Mon, 11 Mar 2019 15:36:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1550219467-9532-1-git-send-email-eugen.hristev@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCWOq37G2vB/0iYlTJx7w/YW+1sFuCbd3nuPbk1h7wNIzwi44oej2imyucj8Bus78TFk4XZ1OwDCrO1Q6B8h8Hf5xYxzmtQV1QSnKtzX8Wy6w1vq5Tw8
 t4SExRD/P/GrX94kRARUClzF00EIU5BWq9jAFlcjZgRnah3Ntm5+HeIKv0XMCKIa32F8ZOfz0KCW5o2glTV8jMpmffgVV/VDpaVUX3E6t71j/OuEP8FIBJdY
 K12CI6GoCbl9fbtrcDH0Yst0qpnkSYv7gACl781NQm63cUa7Dx2UZ3sGtKf/pverQYENh6P/fM1W6wE1OvIF3xsKOSyCBqYtKEz8G9yAdwJRa+Ai5dJztPIt
 kchqrjCDv928aBO7nWlgU8/C4aRPb7WQF058ZM8RkrdAhJ55onR64BmH62UemE9pL6aryEBNOH9GRDCSDIFYZJS6A2vQ/imzKHIOqBPxfoGrPx3YPjk=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Eugen,

On 2/15/19 9:37 AM, Eugen.Hristev@microchip.com wrote:
> From: Eugen Hristev <eugen.hristev@microchip.com>
> 
> This change is a redesign in the formats and the way the ISC is
> configured w.r.t. sensor format and the output format from the ISC.
> I have changed the splitting between sensor output (which is also ISC input)
> and ISC output.
> The sensor format represents the way the sensor is configured, and what ISC
> is receiving.
> The format configuration represents the way ISC is interpreting the data and
> formatting the output to the subsystem.
> Now it's much easier to figure out what is the ISC configuration for input, and
> what is the configuration for output.
> The non-raw format can be obtained directly from sensor or it can be done
> inside the ISC. The controller format list will include a configuration for
> each format.
> The old supported formats are still in place, if we want to dump the sensor
> format directly to the output, the try format routine will detect and
> configure the pipeline accordingly.
> This also fixes the previous issues when the raw format was NULL which
> resulted in many crashes for sensors which did not have the expected/tested
> formats.

This is quite a big change, so I would like to see the v4l2-compliance
output before I accept this.

Make sure you compile the very latest v4l2-compliance direct from the
v4l-utils git repo!

See also a comment below:

> 
> Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
> ---
> Hello Ken and possibly others using ISC driver,
> 
> I would appreciate if you could test this patch with your sensor,
> because I do not wish to break anything in your setups.
> Feedback is appreciated if any errors appear, so I can fix them.
> I tested with ov5640, ov7670, ov7740(only in 4.19 because on latest it's broken
> for me...)
> Rebased this patch on top of mediatree.git/master
> Thanks!
> 
> Eugen
> 
>  drivers/media/platform/atmel/atmel-isc.c | 882 ++++++++++++++++---------------
>  1 file changed, 465 insertions(+), 417 deletions(-)
> 
> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> index 5017896..7f0a6cc 100644
> --- a/drivers/media/platform/atmel/atmel-isc.c
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -89,35 +89,25 @@ struct isc_subdev_entity {
>  	struct list_head list;
>  };
>  
> -/* Indicate the format is generated by the sensor */
> -#define FMT_FLAG_FROM_SENSOR		BIT(0)
> -/* Indicate the format is produced by ISC itself */
> -#define FMT_FLAG_FROM_CONTROLLER	BIT(1)
> -/* Indicate a Raw Bayer format */
> -#define FMT_FLAG_RAW_FORMAT		BIT(2)
> -
> -#define FMT_FLAG_RAW_FROM_SENSOR	(FMT_FLAG_FROM_SENSOR | \
> -					 FMT_FLAG_RAW_FORMAT)
> -
>  /*
>   * struct isc_format - ISC media bus format information
> +			This structure represents the interface between the ISC
> +			and the sensor. It's the input format received by
> +			the ISC.
>   * @fourcc:		Fourcc code for this format
>   * @mbus_code:		V4L2 media bus format code.
> - * flags:		Indicate format from sensor or converted by controller
> - * @bpp:		Bits per pixel (when stored in memory)
> - *			(when transferred over a bus)
> - * @sd_support:		Subdev supports this format
> - * @isc_support:	ISC can convert raw format to this format
> + * @cfa_baycfg:		If this format is RAW BAYER, indicate the type of bayer.
> +			this is either BGBG, RGRG, etc.
> + * @pfe_cfg0_bps:	Number of hardware data lines connected to the ISC
>   */
>  
>  struct isc_format {
>  	u32	fourcc;
>  	u32	mbus_code;
> -	u32	flags;
> -	u8	bpp;
> +	u32	cfa_baycfg;
>  
>  	bool	sd_support;
> -	bool	isc_support;
> +	u32	pfe_cfg0_bps;
>  };
>  
>  /* Pipeline bitmap */
> @@ -135,16 +125,31 @@ struct isc_format {
>  
>  #define GAM_ENABLES	(GAM_RENABLE | GAM_GENABLE | GAM_BENABLE | GAM_ENABLE)
>  
> +/*
> + * struct fmt_config - ISC format configuration and internal pipeline
> +			This structure represents the internal configuration
> +			of the ISC.
> +			It also holds the format that ISC will present to v4l2.
> + * @sd_format:		Pointer to an isc_format struct that holds the sensor
> +			configuration.
> + * @fourcc:		Fourcc code for this format.
> + * @bpp:		Bytes per pixel in the current format.
> + * @rlp_cfg_mode:	Configuration of the RLP (rounding, limiting packaging)
> + * @dcfg_imode:		Configuration of the input of the DMA module
> + * @dctrl_dview:	Configuration of the output of the DMA module
> + * @bits_pipeline:	Configuration of the pipeline, which modules are enabled
> + */
>  struct fmt_config {
> -	u32	fourcc;
> +	struct isc_format	*sd_format;
>  
> -	u32	pfe_cfg0_bps;
> -	u32	cfa_baycfg;
> -	u32	rlp_cfg_mode;
> -	u32	dcfg_imode;
> -	u32	dctrl_dview;
> +	u32			fourcc;
> +	u8			bpp;
>  
> -	u32	bits_pipeline;
> +	u32			rlp_cfg_mode;
> +	u32			dcfg_imode;
> +	u32			dctrl_dview;
> +
> +	u32			bits_pipeline;
>  };
>  
>  #define HIST_ENTRIES		512
> @@ -196,8 +201,7 @@ struct isc_device {
>  	struct v4l2_format	fmt;
>  	struct isc_format	**user_formats;
>  	unsigned int		num_user_formats;
> -	const struct isc_format	*current_fmt;
> -	const struct isc_format	*raw_fmt;
> +	struct fmt_config	config;
>  
>  	struct isc_ctrls	ctrls;
>  	struct work_struct	awb_work;
> @@ -210,319 +214,122 @@ struct isc_device {
>  	struct list_head		subdev_entities;
>  };
>  
> -static struct isc_format formats_list[] = {
> +/* This is a list of the formats that the ISC can *output* */
> +static struct isc_format controller_formats[] = {
>  	{
> -		.fourcc		= V4L2_PIX_FMT_SBGGR8,
> -		.mbus_code	= MEDIA_BUS_FMT_SBGGR8_1X8,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 8,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_SGBRG8,
> -		.mbus_code	= MEDIA_BUS_FMT_SGBRG8_1X8,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 8,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_SGRBG8,
> -		.mbus_code	= MEDIA_BUS_FMT_SGRBG8_1X8,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 8,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_SRGGB8,
> -		.mbus_code	= MEDIA_BUS_FMT_SRGGB8_1X8,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 8,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_SBGGR10,
> -		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 16,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_SGBRG10,
> -		.mbus_code	= MEDIA_BUS_FMT_SGBRG10_1X10,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 16,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_SGRBG10,
> -		.mbus_code	= MEDIA_BUS_FMT_SGRBG10_1X10,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 16,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_SRGGB10,
> -		.mbus_code	= MEDIA_BUS_FMT_SRGGB10_1X10,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 16,
> +		.fourcc		= V4L2_PIX_FMT_ARGB444,
>  	},
>  	{
> -		.fourcc		= V4L2_PIX_FMT_SBGGR12,
> -		.mbus_code	= MEDIA_BUS_FMT_SBGGR12_1X12,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 16,
> +		.fourcc		= V4L2_PIX_FMT_ARGB555,
>  	},
>  	{
> -		.fourcc		= V4L2_PIX_FMT_SGBRG12,
> -		.mbus_code	= MEDIA_BUS_FMT_SGBRG12_1X12,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 16,
> +		.fourcc		= V4L2_PIX_FMT_RGB565,
>  	},
>  	{
> -		.fourcc		= V4L2_PIX_FMT_SGRBG12,
> -		.mbus_code	= MEDIA_BUS_FMT_SGRBG12_1X12,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 16,
> +		.fourcc		= V4L2_PIX_FMT_ARGB32,
>  	},
>  	{
> -		.fourcc		= V4L2_PIX_FMT_SRGGB12,
> -		.mbus_code	= MEDIA_BUS_FMT_SRGGB12_1X12,
> -		.flags		= FMT_FLAG_RAW_FROM_SENSOR,
> -		.bpp		= 16,
> +		.fourcc		= V4L2_PIX_FMT_YUV420,
>  	},
>  	{
> -		.fourcc		= V4L2_PIX_FMT_YUV420,
> -		.mbus_code	= 0x0,
> -		.flags		= FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		= 12,
> +		.fourcc		= V4L2_PIX_FMT_YUYV,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_YUV422P,
> -		.mbus_code	= 0x0,
> -		.flags		= FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		= 16,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_GREY,
> -		.mbus_code	= MEDIA_BUS_FMT_Y8_1X8,
> -		.flags		= FMT_FLAG_FROM_CONTROLLER |
> -				  FMT_FLAG_FROM_SENSOR,
> -		.bpp		= 8,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_ARGB444,
> -		.mbus_code	= MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
> -		.flags		= FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		= 16,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_ARGB555,
> -		.mbus_code	= MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
> -		.flags		= FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		= 16,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_RGB565,
> -		.mbus_code	= MEDIA_BUS_FMT_RGB565_2X8_LE,
> -		.flags		= FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		= 16,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_ARGB32,
> -		.mbus_code	= MEDIA_BUS_FMT_ARGB8888_1X32,
> -		.flags		= FMT_FLAG_FROM_CONTROLLER,
> -		.bpp		= 32,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_YUYV,
> -		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
> -		.flags		= FMT_FLAG_FROM_CONTROLLER |
> -				  FMT_FLAG_FROM_SENSOR,
> -		.bpp		= 16,
>  	},
>  };
>  
> -static struct fmt_config fmt_configs_list[] = {
> +/* This is a list of formats that the ISC can receive as *input* */
> +static struct isc_format formats_list[] = {
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SBGGR8,
> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR8_1X8,
>  		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>  		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT8,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SGBRG8,
> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG8_1X8,
>  		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>  		.cfa_baycfg	= ISC_BAY_CFG_GBGB,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT8,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SGRBG8,
> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG8_1X8,
>  		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>  		.cfa_baycfg	= ISC_BAY_CFG_GRGR,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT8,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SRGGB8,
> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB8_1X8,
>  		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>  		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT8,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SBGGR10,
> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
>  		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
> -		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT10,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0,
> +		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SGBRG10,
> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG10_1X10,
>  		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
>  		.cfa_baycfg	= ISC_BAY_CFG_GBGB,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT10,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SGRBG10,
> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG10_1X10,
>  		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
>  		.cfa_baycfg	= ISC_BAY_CFG_GRGR,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT10,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SRGGB10,
> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB10_1X10,
>  		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
>  		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT10,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SBGGR12,
> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR12_1X12,
>  		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
>  		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT12,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SGBRG12,
> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG12_1X12,
>  		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
>  		.cfa_baycfg	= ISC_BAY_CFG_GBGB,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT12,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SGRBG12,
> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG12_1X12,
>  		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
>  		.cfa_baycfg	= ISC_BAY_CFG_GRGR,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT12,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_SRGGB12,
> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB12_1X12,
>  		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
>  		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT12,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0,
> -	},
> -	{
> -		.fourcc = V4L2_PIX_FMT_YUV420,
> -		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_YYCC,
> -		.dcfg_imode	= ISC_DCFG_IMODE_YC420P,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PLANAR,
> -		.bits_pipeline	= SUB420_ENABLE | SUB422_ENABLE |
> -				  CBC_ENABLE | CSC_ENABLE |
> -				  GAM_ENABLES |
> -				  CFA_ENABLE | WB_ENABLE,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_YUV422P,
> -		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_YYCC,
> -		.dcfg_imode	= ISC_DCFG_IMODE_YC422P,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PLANAR,
> -		.bits_pipeline	= SUB422_ENABLE |
> -				  CBC_ENABLE | CSC_ENABLE |
> -				  GAM_ENABLES |
> -				  CFA_ENABLE | WB_ENABLE,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_GREY,
> +		.mbus_code	= MEDIA_BUS_FMT_Y8_1X8,
>  		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DATY8,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= CBC_ENABLE | CSC_ENABLE |
> -				  GAM_ENABLES |
> -				  CFA_ENABLE | WB_ENABLE,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_ARGB444,
> -		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_ARGB444,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
>  	},
>  	{
> -		.fourcc		= V4L2_PIX_FMT_ARGB555,
> +		.fourcc		= V4L2_PIX_FMT_YUYV,
> +		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
>  		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_ARGB555,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
>  	},
>  	{
>  		.fourcc		= V4L2_PIX_FMT_RGB565,
> +		.mbus_code	= MEDIA_BUS_FMT_RGB565_2X8_LE,
>  		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_RGB565,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_ARGB32,
> -		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_ARGB32,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED32,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
> -	},
> -	{
> -		.fourcc		= V4L2_PIX_FMT_YUYV,
> -		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
> -		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
> -		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT8,
> -		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
> -		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
> -		.bits_pipeline	= 0x0
>  	},
>  };
>  
> @@ -571,6 +378,13 @@ static const u32 isc_gamma_table[GAMMA_MAX + 1][GAMMA_ENTRIES] = {
>  	  0x3E20007, 0x3E90007, 0x3F00008, 0x3F80007 },
>  };
>  
> +#define ISC_IS_SENSOR_RAW_MODE(isc) \
> +	(((isc)->config.sd_format->mbus_code & 0xf000) == 0x3000)
> +
> +static unsigned int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "debug level (0-2)");
> +
>  static unsigned int sensor_preferred = 1;
>  module_param(sensor_preferred, uint, 0644);
>  MODULE_PARM_DESC(sensor_preferred,
> @@ -896,40 +710,17 @@ static int isc_buffer_prepare(struct vb2_buffer *vb)
>  	return 0;
>  }
>  
> -static inline bool sensor_is_preferred(const struct isc_format *isc_fmt)
> -{
> -	return (sensor_preferred && isc_fmt->sd_support) ||
> -		!isc_fmt->isc_support;
> -}
> -
> -static struct fmt_config *get_fmt_config(u32 fourcc)
> -{
> -	struct fmt_config *config;
> -	int i;
> -
> -	config = &fmt_configs_list[0];
> -	for (i = 0; i < ARRAY_SIZE(fmt_configs_list); i++) {
> -		if (config->fourcc == fourcc)
> -			return config;
> -
> -		config++;
> -	}
> -	return NULL;
> -}
> -
>  static void isc_start_dma(struct isc_device *isc)
>  {
>  	struct regmap *regmap = isc->regmap;
> -	struct v4l2_pix_format *pixfmt = &isc->fmt.fmt.pix;
> -	u32 sizeimage = pixfmt->sizeimage;
> -	struct fmt_config *config = get_fmt_config(isc->current_fmt->fourcc);
> +	u32 sizeimage = isc->fmt.fmt.pix.sizeimage;
>  	u32 dctrl_dview;
>  	dma_addr_t addr0;
>  
>  	addr0 = vb2_dma_contig_plane_dma_addr(&isc->cur_frm->vb.vb2_buf, 0);
>  	regmap_write(regmap, ISC_DAD0, addr0);
>  
> -	switch (pixfmt->pixelformat) {
> +	switch (isc->config.fourcc) {
>  	case V4L2_PIX_FMT_YUV420:
>  		regmap_write(regmap, ISC_DAD1, addr0 + (sizeimage * 2) / 3);
>  		regmap_write(regmap, ISC_DAD2, addr0 + (sizeimage * 5) / 6);
> @@ -942,10 +733,7 @@ static void isc_start_dma(struct isc_device *isc)
>  		break;
>  	}
>  
> -	if (sensor_is_preferred(isc->current_fmt))
> -		dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> -	else
> -		dctrl_dview = config->dctrl_dview;
> +	dctrl_dview = isc->config.dctrl_dview;
>  
>  	regmap_write(regmap, ISC_DCTRL, dctrl_dview | ISC_DCTRL_IE_IS);
>  	regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_CAPTURE);
> @@ -955,7 +743,6 @@ static void isc_set_pipeline(struct isc_device *isc, u32 pipeline)
>  {
>  	struct regmap *regmap = isc->regmap;
>  	struct isc_ctrls *ctrls = &isc->ctrls;
> -	struct fmt_config *config = get_fmt_config(isc->raw_fmt->fourcc);
>  	u32 val, bay_cfg;
>  	const u32 *gamma;
>  	unsigned int i;
> @@ -969,7 +756,7 @@ static void isc_set_pipeline(struct isc_device *isc, u32 pipeline)
>  	if (!pipeline)
>  		return;
>  
> -	bay_cfg = config->cfa_baycfg;
> +	bay_cfg = isc->config.sd_format->cfa_baycfg;
>  
>  	regmap_write(regmap, ISC_WB_CFG, bay_cfg);
>  	regmap_write(regmap, ISC_WB_O_RGR, 0x0);
> @@ -1011,24 +798,24 @@ static int isc_update_profile(struct isc_device *isc)
>  	}
>  
>  	if (counter < 0) {
> -		v4l2_warn(&isc->v4l2_dev, "Time out to update profie\n");
> +		v4l2_warn(&isc->v4l2_dev, "Time out to update profile\n");
>  		return -ETIMEDOUT;
>  	}
>  
>  	return 0;
>  }
>  
> -static void isc_set_histogram(struct isc_device *isc)
> +static void isc_set_histogram(struct isc_device *isc, bool enable)
>  {
>  	struct regmap *regmap = isc->regmap;
>  	struct isc_ctrls *ctrls = &isc->ctrls;
> -	struct fmt_config *config = get_fmt_config(isc->raw_fmt->fourcc);
>  
> -	if (ctrls->awb && (ctrls->hist_stat != HIST_ENABLED)) {
> +	if (enable) {
>  		regmap_write(regmap, ISC_HIS_CFG,
>  			     ISC_HIS_CFG_MODE_R |
> -			     (config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT) |
> -			     ISC_HIS_CFG_RAR);
> +			     (isc->config.sd_format->cfa_baycfg
> +					<< ISC_HIS_CFG_BAYSEL_SHIFT) |
> +					ISC_HIS_CFG_RAR);
>  		regmap_write(regmap, ISC_HIS_CTRL, ISC_HIS_CTRL_EN);
>  		regmap_write(regmap, ISC_INTEN, ISC_INT_HISDONE);
>  		ctrls->hist_id = ISC_HIS_CFG_MODE_R;
> @@ -1036,7 +823,7 @@ static void isc_set_histogram(struct isc_device *isc)
>  		regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_HISREQ);
>  
>  		ctrls->hist_stat = HIST_ENABLED;
> -	} else if (!ctrls->awb && (ctrls->hist_stat != HIST_DISABLED)) {
> +	} else {
>  		regmap_write(regmap, ISC_INTDIS, ISC_INT_HISDONE);
>  		regmap_write(regmap, ISC_HIS_CTRL, ISC_HIS_CTRL_DIS);
>  
> @@ -1044,53 +831,18 @@ static void isc_set_histogram(struct isc_device *isc)
>  	}
>  }
>  
> -static inline void isc_get_param(const struct isc_format *fmt,
> -				 u32 *rlp_mode, u32 *dcfg)
> -{
> -	struct fmt_config *config = get_fmt_config(fmt->fourcc);
> -
> -	*dcfg = ISC_DCFG_YMBSIZE_BEATS8;
> -
> -	switch (fmt->fourcc) {
> -	case V4L2_PIX_FMT_SBGGR10:
> -	case V4L2_PIX_FMT_SGBRG10:
> -	case V4L2_PIX_FMT_SGRBG10:
> -	case V4L2_PIX_FMT_SRGGB10:
> -	case V4L2_PIX_FMT_SBGGR12:
> -	case V4L2_PIX_FMT_SGBRG12:
> -	case V4L2_PIX_FMT_SGRBG12:
> -	case V4L2_PIX_FMT_SRGGB12:
> -		*rlp_mode = config->rlp_cfg_mode;
> -		*dcfg |= config->dcfg_imode;
> -		break;
> -	default:
> -		*rlp_mode = ISC_RLP_CFG_MODE_DAT8;
> -		*dcfg |= ISC_DCFG_IMODE_PACKED8;
> -		break;
> -	}
> -}
> -
>  static int isc_configure(struct isc_device *isc)
>  {
>  	struct regmap *regmap = isc->regmap;
> -	const struct isc_format *current_fmt = isc->current_fmt;
> -	struct fmt_config *curfmt_config = get_fmt_config(current_fmt->fourcc);
> -	struct fmt_config *rawfmt_config = get_fmt_config(isc->raw_fmt->fourcc);
> -	struct isc_subdev_entity *subdev = isc->current_subdev;
>  	u32 pfe_cfg0, rlp_mode, dcfg, mask, pipeline;
> +	struct isc_subdev_entity *subdev = isc->current_subdev;
>  
> -	if (sensor_is_preferred(current_fmt)) {
> -		pfe_cfg0 = curfmt_config->pfe_cfg0_bps;
> -		pipeline = 0x0;
> -		isc_get_param(current_fmt, &rlp_mode, &dcfg);
> -		isc->ctrls.hist_stat = HIST_INIT;
> -	} else {
> -		pfe_cfg0 = rawfmt_config->pfe_cfg0_bps;
> -		pipeline = curfmt_config->bits_pipeline;
> -		rlp_mode = curfmt_config->rlp_cfg_mode;
> -		dcfg = curfmt_config->dcfg_imode |
> +	pfe_cfg0 = isc->config.sd_format->pfe_cfg0_bps;
> +	rlp_mode = isc->config.rlp_cfg_mode;
> +	pipeline = isc->config.bits_pipeline;
> +
> +	dcfg = isc->config.dcfg_imode |
>  		       ISC_DCFG_YMBSIZE_BEATS8 | ISC_DCFG_CMBSIZE_BEATS8;
> -	}
>  
>  	pfe_cfg0  |= subdev->pfe_cfg0 | ISC_PFE_CFG0_MODE_PROGRESSIVE;
>  	mask = ISC_PFE_CFG0_BPS_MASK | ISC_PFE_CFG0_HPOL_LOW |
> @@ -1107,8 +859,16 @@ static int isc_configure(struct isc_device *isc)
>  	/* Set the pipeline */
>  	isc_set_pipeline(isc, pipeline);
>  
> -	if (pipeline)
> -		isc_set_histogram(isc);
> +	/*
> +	 * The current implemented histogram is available for RAW R, B, GB
> +	 * channels. Hence we can use it if CFA is disabled and CSC is disabled
> +	 * and the sensor outputs RAW mode.
> +	 */
> +	if (isc->ctrls.awb && ((pipeline & (CFA_ENABLE | CSC_ENABLE)) == 0)
> +	    && ISC_IS_SENSOR_RAW_MODE(isc))
> +		isc_set_histogram(isc, true);
> +	else
> +		isc_set_histogram(isc, false);
>  
>  	/* Update profile */
>  	return isc_update_profile(isc);
> @@ -1125,7 +885,8 @@ static int isc_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	/* Enable stream on the sub device */
>  	ret = v4l2_subdev_call(isc->current_subdev->sd, video, s_stream, 1);
>  	if (ret && ret != -ENOIOCTLCMD) {
> -		v4l2_err(&isc->v4l2_dev, "stream on failed in subdev\n");
> +		v4l2_err(&isc->v4l2_dev, "stream on failed in subdev %d\n",
> +			 ret);
>  		goto err_start_stream;
>  	}
>  
> @@ -1223,6 +984,22 @@ static void isc_buffer_queue(struct vb2_buffer *vb)
>  	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
>  }
>  
> +static struct isc_format *find_format_by_fourcc(struct isc_device *isc,
> +						 unsigned int fourcc)
> +{
> +	unsigned int num_formats = isc->num_user_formats;
> +	struct isc_format *fmt;
> +	unsigned int i;
> +
> +	for (i = 0; i < num_formats; i++) {
> +		fmt = isc->user_formats[i];
> +		if (fmt->fourcc == fourcc)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
>  static const struct vb2_ops isc_vb2_ops = {
>  	.queue_setup		= isc_queue_setup,
>  	.wait_prepare		= vb2_ops_wait_prepare,
> @@ -1249,15 +1026,31 @@ static int isc_querycap(struct file *file, void *priv,
>  static int isc_enum_fmt_vid_cap(struct file *file, void *priv,
>  				 struct v4l2_fmtdesc *f)
>  {
> -	struct isc_device *isc = video_drvdata(file);
>  	u32 index = f->index;
> +	u32 i, supported_index;
>  
> -	if (index >= isc->num_user_formats)
> -		return -EINVAL;
> +	if (index < ARRAY_SIZE(controller_formats)) {
> +		f->pixelformat = controller_formats[index].fourcc;
> +		return 0;
> +	}
>  
> -	f->pixelformat = isc->user_formats[index]->fourcc;
> +	index -= ARRAY_SIZE(controller_formats);
>  
> -	return 0;
> +	i = 0;
> +	supported_index = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(formats_list); i++) {
> +		if (((formats_list[i].mbus_code & 0xf000) != 0x3000) ||
> +		    !formats_list[i].sd_support)
> +			continue;
> +		if (supported_index == index) {
> +			f->pixelformat = formats_list[i].fourcc;
> +			return 0;
> +		}
> +		supported_index++;
> +	}
> +
> +	return -EINVAL;
>  }
>  
>  static int isc_g_fmt_vid_cap(struct file *file, void *priv,
> @@ -1270,26 +1063,230 @@ static int isc_g_fmt_vid_cap(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static struct isc_format *find_format_by_fourcc(struct isc_device *isc,
> -						 unsigned int fourcc)
> +/*
> + * Checks the current configured format, if ISC can output it,
> + * considering which type of format the ISC receives from the sensor
> + */
> +static int isc_validate_formats(struct isc_device *isc)
>  {
> -	unsigned int num_formats = isc->num_user_formats;
> -	struct isc_format *fmt;
> -	unsigned int i;
> +	int ret;
> +	bool bayer = false, yuv = false, rgb = false, grey = false;
> +
> +	/* all formats supported by the RLP module are OK */
> +	switch (isc->config.fourcc) {
> +	case V4L2_PIX_FMT_SBGGR8:
> +	case V4L2_PIX_FMT_SGBRG8:
> +	case V4L2_PIX_FMT_SGRBG8:
> +	case V4L2_PIX_FMT_SRGGB8:
> +	case V4L2_PIX_FMT_SBGGR10:
> +	case V4L2_PIX_FMT_SGBRG10:
> +	case V4L2_PIX_FMT_SGRBG10:
> +	case V4L2_PIX_FMT_SRGGB10:
> +	case V4L2_PIX_FMT_SBGGR12:
> +	case V4L2_PIX_FMT_SGBRG12:
> +	case V4L2_PIX_FMT_SGRBG12:
> +	case V4L2_PIX_FMT_SRGGB12:
> +		ret = 0;
> +		bayer = true;
> +		break;
>  
> -	for (i = 0; i < num_formats; i++) {
> -		fmt = isc->user_formats[i];
> -		if (fmt->fourcc == fourcc)
> -			return fmt;
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YUV422P:
> +	case V4L2_PIX_FMT_YUYV:
> +		ret = 0;
> +		yuv = true;
> +		break;
> +
> +	case V4L2_PIX_FMT_RGB565:
> +	case V4L2_PIX_FMT_ARGB32:
> +	case V4L2_PIX_FMT_ARGB444:
> +	case V4L2_PIX_FMT_ARGB555:
> +		ret = 0;
> +		rgb = true;
> +		break;
> +	case V4L2_PIX_FMT_GREY:
> +		ret = 0;
> +		grey = true;
> +		break;
> +	default:
> +	/* any other different formats are not supported */
> +		ret = -EINVAL;
>  	}
>  
> -	return NULL;
> +	/* we cannot output RAW/Grey if we do not receive RAW */
> +	if ((bayer || grey) && !ISC_IS_SENSOR_RAW_MODE(isc))
> +		return -EINVAL;
> +
> +	return ret;
> +}
> +
> +/*
> + * Configures the RLP and DMA modules, depending on the output format
> + * configured for the ISC.
> + * If direct_dump == true, just dump raw data 8 bits.
> + */
> +static int isc_configure_rlp_dma(struct isc_device *isc, bool direct_dump)
> +{
> +	if (direct_dump) {
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_DAT8;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_PACKED8;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> +		isc->config.bpp = 16;
> +		return 0;
> +	}
> +
> +	switch (isc->config.fourcc) {
> +	case V4L2_PIX_FMT_SBGGR8:
> +	case V4L2_PIX_FMT_SGBRG8:
> +	case V4L2_PIX_FMT_SGRBG8:
> +	case V4L2_PIX_FMT_SRGGB8:
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_DAT8;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_PACKED8;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> +		isc->config.bpp = 8;
> +		break;
> +	case V4L2_PIX_FMT_SBGGR10:
> +	case V4L2_PIX_FMT_SGBRG10:
> +	case V4L2_PIX_FMT_SGRBG10:
> +	case V4L2_PIX_FMT_SRGGB10:
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_DAT10;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_PACKED16;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> +		isc->config.bpp = 16;
> +		break;
> +	case V4L2_PIX_FMT_SBGGR12:
> +	case V4L2_PIX_FMT_SGBRG12:
> +	case V4L2_PIX_FMT_SGRBG12:
> +	case V4L2_PIX_FMT_SRGGB12:
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_DAT12;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_PACKED16;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> +		isc->config.bpp = 16;
> +		break;
> +	case V4L2_PIX_FMT_RGB565:
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_RGB565;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_PACKED16;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> +		isc->config.bpp = 16;
> +		break;
> +	case V4L2_PIX_FMT_ARGB444:
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_ARGB444;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_PACKED16;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> +		isc->config.bpp = 16;
> +		break;
> +	case V4L2_PIX_FMT_ARGB555:
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_ARGB555;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_PACKED16;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> +		isc->config.bpp = 16;
> +		break;
> +	case V4L2_PIX_FMT_ARGB32:
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_ARGB32;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_PACKED32;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> +		isc->config.bpp = 32;
> +		break;
> +	case V4L2_PIX_FMT_YUV420:
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_YYCC;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_YC420P;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PLANAR;
> +		isc->config.bpp = 12;
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_YYCC;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_YC422P;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PLANAR;
> +		isc->config.bpp = 16;
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_YYCC;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_PACKED32;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> +		isc->config.bpp = 16;
> +		break;
> +	case V4L2_PIX_FMT_GREY:
> +		isc->config.rlp_cfg_mode = ISC_RLP_CFG_MODE_DATY8;
> +		isc->config.dcfg_imode = ISC_DCFG_IMODE_PACKED8;
> +		isc->config.dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
> +		isc->config.bpp = 8;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Configuring pipeline modules, depending on which format the ISC outputs
> + * and considering which format it has as input from the sensor.
> + */
> +static int isc_configure_pipeline(struct isc_device *isc)
> +{
> +	switch (isc->config.fourcc) {
> +	case V4L2_PIX_FMT_RGB565:
> +	case V4L2_PIX_FMT_ARGB555:
> +	case V4L2_PIX_FMT_ARGB444:
> +	case V4L2_PIX_FMT_ARGB32:
> +		/* if sensor format is RAW, we convert inside ISC */
> +		if (ISC_IS_SENSOR_RAW_MODE(isc)) {
> +			isc->config.bits_pipeline = CFA_ENABLE |
> +				WB_ENABLE | GAM_ENABLES;
> +		} else {
> +			isc->config.bits_pipeline = 0x0;
> +		}
> +		break;
> +	case V4L2_PIX_FMT_YUV420:
> +		/* if sensor format is RAW, we convert inside ISC */
> +		if (ISC_IS_SENSOR_RAW_MODE(isc)) {
> +			isc->config.bits_pipeline = CFA_ENABLE |
> +				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
> +				SUB420_ENABLE | SUB422_ENABLE | CBC_ENABLE;
> +		} else {
> +			isc->config.bits_pipeline = 0x0;
> +		}
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +		/* if sensor format is RAW, we convert inside ISC */
> +		if (ISC_IS_SENSOR_RAW_MODE(isc)) {
> +			isc->config.bits_pipeline = CFA_ENABLE |
> +				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
> +				SUB422_ENABLE | CBC_ENABLE;
> +		} else {
> +			isc->config.bits_pipeline = 0x0;
> +		}
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +		/* if sensor format is RAW, we convert inside ISC */
> +		if (ISC_IS_SENSOR_RAW_MODE(isc)) {
> +			isc->config.bits_pipeline = CFA_ENABLE |
> +				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
> +				SUB422_ENABLE | CBC_ENABLE;
> +		} else {
> +			isc->config.bits_pipeline = 0x0;
> +		}
> +		break;
> +	case V4L2_PIX_FMT_GREY:
> +		/* if sensor format is RAW, we convert inside ISC */
> +		if (ISC_IS_SENSOR_RAW_MODE(isc)) {
> +			isc->config.bits_pipeline = CFA_ENABLE |
> +				CSC_ENABLE | WB_ENABLE | GAM_ENABLES |
> +				CBC_ENABLE;
> +		} else {
> +			isc->config.bits_pipeline = 0x0;
> +		}
> +		break;
> +	default:
> +		isc->config.bits_pipeline = 0x0;
> +	}
> +	return 0;
>  }
>  
>  static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
> -			struct isc_format **current_fmt, u32 *code)
> +			u32 *code)
>  {
> -	struct isc_format *isc_fmt;
> +	int i;
> +	struct isc_format *sd_fmt = NULL, *direct_fmt = NULL;
>  	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
>  	struct v4l2_subdev_pad_config pad_cfg;
>  	struct v4l2_subdev_format format = {
> @@ -1297,48 +1294,114 @@ static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
>  	};
>  	u32 mbus_code;
>  	int ret;
> +	bool rlp_dma_direct_dump = false;
>  
>  	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  
> -	isc_fmt = find_format_by_fourcc(isc, pixfmt->pixelformat);
> -	if (!isc_fmt) {
> -		v4l2_warn(&isc->v4l2_dev, "Format 0x%x not found\n",
> -			  pixfmt->pixelformat);
> -		isc_fmt = isc->user_formats[isc->num_user_formats - 1];
> -		pixfmt->pixelformat = isc_fmt->fourcc;
> +	/* Step 1: find a RAW format that is supported */
> +	for (i = 0; i < isc->num_user_formats; i++) {
> +		if ((isc->user_formats[i]->mbus_code & 0xf000) == 0x3000) {
> +			sd_fmt = isc->user_formats[i];
> +			break;
> +		}
> +	}
> +	/* Step 2: We can continue with this RAW format, or we can look
> +	 * for better: maybe sensor supports directly what we need.
> +	 */
> +	direct_fmt = find_format_by_fourcc(isc, pixfmt->pixelformat);
> +
> +	/* Step 3: We have both. We decide given the module parameter which
> +	 * one to use.
> +	 */
> +	if (direct_fmt && sd_fmt && sensor_preferred)
> +		sd_fmt = direct_fmt;
> +
> +	/* Step 4: we do not have RAW but we have a direct format. Use it. */
> +	if (direct_fmt && !sd_fmt)
> +		sd_fmt = direct_fmt;
> +
> +	/* Step 5: if we are using a direct format, we need to package
> +	 * everything as 8 bit data and just dump it
> +	 */
> +	if (sd_fmt == direct_fmt)
> +		rlp_dma_direct_dump = true;
> +
> +	/* Step 6: We have no format. This can happen if the userspace
> +	 * requests some weird/invalid format.
> +	 * In this case, default to whatever we have
> +	 */
> +	if (!sd_fmt && !direct_fmt) {
> +		sd_fmt = isc->user_formats[isc->num_user_formats - 1];
> +		v4l2_dbg(1, debug, &isc->v4l2_dev,
> +			 "Sensor not supporting %.4s, using %.4s\n",
> +			 (char *)&pixfmt->pixelformat, (char *)&sd_fmt->fourcc);
>  	}
>  
> +	/* Step 7: Print out what we decided for debugging */
> +	v4l2_dbg(1, debug, &isc->v4l2_dev,
> +		 "Preferring to have sensor using format %.4s\n",
> +		 (char *)&sd_fmt->fourcc);
> +
> +	/* Step 8: at this moment we decided which format the subdev will use */
> +	isc->config.sd_format = sd_fmt;

This is try_fmt(), i.e. it only validates and does not actually make
any changes. But this line suggests that something is actually changed.

Are you sure this is correct? TRY_FMT must not have any side-effects, and
it can also be called while streaming.

If nothing else it would need some comments explaining why this is safe.

> +
>  	/* Limit to Atmel ISC hardware capabilities */
>  	if (pixfmt->width > ISC_MAX_SUPPORT_WIDTH)
>  		pixfmt->width = ISC_MAX_SUPPORT_WIDTH;
>  	if (pixfmt->height > ISC_MAX_SUPPORT_HEIGHT)
>  		pixfmt->height = ISC_MAX_SUPPORT_HEIGHT;
>  
> -	if (sensor_is_preferred(isc_fmt))
> -		mbus_code = isc_fmt->mbus_code;
> -	else
> -		mbus_code = isc->raw_fmt->mbus_code;
> +	/*
> +	 * The mbus format is the one the subdev outputs.
> +	 * The pixels will be transferred in this format Sensor -> ISC
> +	 */
> +	mbus_code = sd_fmt->mbus_code;
> +
> +	/*
> +	 * Validate formats. If the required format is not OK, default to raw.
> +	 */
> +
> +	isc->config.fourcc = pixfmt->pixelformat;
> +
> +	if (isc_validate_formats(isc)) {
> +		pixfmt->pixelformat = isc->config.fourcc = sd_fmt->fourcc;
> +		/* This should be redundant, format should be supported */
> +		ret = isc_validate_formats(isc);
> +		if (ret)
> +			goto isc_try_fmt_err;
> +	}
> +
> +	ret = isc_configure_rlp_dma(isc, rlp_dma_direct_dump);
> +	if (ret)
> +		goto isc_try_fmt_err;
> +
> +	ret = isc_configure_pipeline(isc);
> +	if (ret)
> +		goto isc_try_fmt_err;
>  
>  	v4l2_fill_mbus_format(&format.format, pixfmt, mbus_code);
>  	ret = v4l2_subdev_call(isc->current_subdev->sd, pad, set_fmt,
>  			       &pad_cfg, &format);
>  	if (ret < 0)
> -		return ret;
> +		goto isc_try_fmt_err;
>  
>  	v4l2_fill_pix_format(pixfmt, &format.format);
>  
>  	pixfmt->field = V4L2_FIELD_NONE;
> -	pixfmt->bytesperline = (pixfmt->width * isc_fmt->bpp) >> 3;
> +	pixfmt->bytesperline = (pixfmt->width * isc->config.bpp) >> 3;
>  	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
>  
> -	if (current_fmt)
> -		*current_fmt = isc_fmt;
> -
>  	if (code)
>  		*code = mbus_code;
>  
>  	return 0;
> +
> +isc_try_fmt_err:
> +	v4l2_err(&isc->v4l2_dev, "Could not find any possible format for a working pipeline\n");
> +	memset(&isc->config, 0, sizeof(isc->config));
> +
> +	return ret;
>  }
>  
>  static int isc_set_fmt(struct isc_device *isc, struct v4l2_format *f)
> @@ -1346,11 +1409,10 @@ static int isc_set_fmt(struct isc_device *isc, struct v4l2_format *f)
>  	struct v4l2_subdev_format format = {
>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
> -	struct isc_format *current_fmt;
> -	u32 mbus_code;
> +	u32 mbus_code = 0;
>  	int ret;
>  
> -	ret = isc_try_fmt(isc, f, &current_fmt, &mbus_code);
> +	ret = isc_try_fmt(isc, f, &mbus_code);
>  	if (ret)
>  		return ret;
>  
> @@ -1361,7 +1423,6 @@ static int isc_set_fmt(struct isc_device *isc, struct v4l2_format *f)
>  		return ret;
>  
>  	isc->fmt = *f;
> -	isc->current_fmt = current_fmt;
>  
>  	return 0;
>  }
> @@ -1382,7 +1443,7 @@ static int isc_try_fmt_vid_cap(struct file *file, void *priv,
>  {
>  	struct isc_device *isc = video_drvdata(file);
>  
> -	return isc_try_fmt(isc, f, NULL, NULL);
> +	return isc_try_fmt(isc, f, NULL);
>  }
>  
>  static int isc_enum_input(struct file *file, void *priv,
> @@ -1431,27 +1492,31 @@ static int isc_enum_framesizes(struct file *file, void *fh,
>  			       struct v4l2_frmsizeenum *fsize)
>  {
>  	struct isc_device *isc = video_drvdata(file);
> -	const struct isc_format *isc_fmt;
>  	struct v4l2_subdev_frame_size_enum fse = {
>  		.index = fsize->index,
>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
> -	int ret;
> +	int ret = -EINVAL;
> +	int i;
>  
> -	isc_fmt = find_format_by_fourcc(isc, fsize->pixel_format);
> -	if (!isc_fmt)
> -		return -EINVAL;
> +	for (i = 0; i < isc->num_user_formats; i++)
> +		if (isc->user_formats[i]->fourcc == fsize->pixel_format)
> +			ret = 0;
>  
> -	if (sensor_is_preferred(isc_fmt))
> -		fse.code = isc_fmt->mbus_code;
> -	else
> -		fse.code = isc->raw_fmt->mbus_code;
> +	for (i = 0; i < ARRAY_SIZE(controller_formats); i++)
> +		if (controller_formats[i].fourcc == fsize->pixel_format)
> +			ret = 0;
> +
> +	if (ret)
> +		return ret;
>  
>  	ret = v4l2_subdev_call(isc->current_subdev->sd, pad, enum_frame_size,
>  			       NULL, &fse);
>  	if (ret)
>  		return ret;
>  
> +	fse.code = isc->config.sd_format->mbus_code;
> +
>  	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
>  	fsize->discrete.width = fse.max_width;
>  	fsize->discrete.height = fse.max_height;
> @@ -1463,29 +1528,32 @@ static int isc_enum_frameintervals(struct file *file, void *fh,
>  				    struct v4l2_frmivalenum *fival)
>  {
>  	struct isc_device *isc = video_drvdata(file);
> -	const struct isc_format *isc_fmt;
>  	struct v4l2_subdev_frame_interval_enum fie = {
>  		.index = fival->index,
>  		.width = fival->width,
>  		.height = fival->height,
>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
> -	int ret;
> +	int ret = -EINVAL;
> +	int i;
>  
> -	isc_fmt = find_format_by_fourcc(isc, fival->pixel_format);
> -	if (!isc_fmt)
> -		return -EINVAL;
> +	for (i = 0; i < isc->num_user_formats; i++)
> +		if (isc->user_formats[i]->fourcc == fival->pixel_format)
> +			ret = 0;
>  
> -	if (sensor_is_preferred(isc_fmt))
> -		fie.code = isc_fmt->mbus_code;
> -	else
> -		fie.code = isc->raw_fmt->mbus_code;
> +	for (i = 0; i < ARRAY_SIZE(controller_formats); i++)
> +		if (controller_formats[i].fourcc == fival->pixel_format)
> +			ret = 0;
> +
> +	if (ret)
> +		return ret;
>  
>  	ret = v4l2_subdev_call(isc->current_subdev->sd, pad,
>  			       enum_frame_interval, NULL, &fie);
>  	if (ret)
>  		return ret;
>  
> +	fie.code = isc->config.sd_format->mbus_code;
>  	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
>  	fival->discrete = fie.interval;
>  
> @@ -1668,7 +1736,6 @@ static void isc_awb_work(struct work_struct *w)
>  	struct isc_device *isc =
>  		container_of(w, struct isc_device, awb_work);
>  	struct regmap *regmap = isc->regmap;
> -	struct fmt_config *config = get_fmt_config(isc->raw_fmt->fourcc);
>  	struct isc_ctrls *ctrls = &isc->ctrls;
>  	u32 hist_id = ctrls->hist_id;
>  	u32 baysel;
> @@ -1686,7 +1753,7 @@ static void isc_awb_work(struct work_struct *w)
>  	}
>  
>  	ctrls->hist_id = hist_id;
> -	baysel = config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT;
> +	baysel = isc->config.sd_format->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT;
>  
>  	pm_runtime_get_sync(isc->dev);
>  
> @@ -1754,7 +1821,6 @@ static int isc_ctrl_init(struct isc_device *isc)
>  	return 0;
>  }
>  
> -
>  static int isc_async_bound(struct v4l2_async_notifier *notifier,
>  			    struct v4l2_subdev *subdev,
>  			    struct v4l2_async_subdev *asd)
> @@ -1812,35 +1878,20 @@ static int isc_formats_init(struct isc_device *isc)
>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
>  
> +	num_fmts = 0;
>  	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
>  	       NULL, &mbus_code)) {
>  		mbus_code.index++;
>  
>  		fmt = find_format_by_code(mbus_code.code, &i);
> -		if ((!fmt) || (!(fmt->flags & FMT_FLAG_FROM_SENSOR)))
> +		if (!fmt) {
> +			v4l2_warn(&isc->v4l2_dev, "Mbus code %x not supported\n",
> +				  mbus_code.code);
>  			continue;
> +		}
>  
>  		fmt->sd_support = true;
> -
> -		if (fmt->flags & FMT_FLAG_RAW_FORMAT)
> -			isc->raw_fmt = fmt;
> -	}
> -
> -	fmt = &formats_list[0];
> -	for (i = 0; i < list_size; i++) {
> -		if (fmt->flags & FMT_FLAG_FROM_CONTROLLER)
> -			fmt->isc_support = true;
> -
> -		fmt++;
> -	}
> -
> -	fmt = &formats_list[0];
> -	num_fmts = 0;
> -	for (i = 0; i < list_size; i++) {
> -		if (fmt->isc_support || fmt->sd_support)
> -			num_fmts++;
> -
> -		fmt++;
> +		num_fmts++;
>  	}
>  
>  	if (!num_fmts)
> @@ -1855,9 +1906,8 @@ static int isc_formats_init(struct isc_device *isc)
>  
>  	fmt = &formats_list[0];
>  	for (i = 0, j = 0; i < list_size; i++) {
> -		if (fmt->isc_support || fmt->sd_support)
> +		if (fmt->sd_support)
>  			isc->user_formats[j++] = fmt;
> -
>  		fmt++;
>  	}
>  
> @@ -1877,13 +1927,11 @@ static int isc_set_default_fmt(struct isc_device *isc)
>  	};
>  	int ret;
>  
> -	ret = isc_try_fmt(isc, &f, NULL, NULL);
> +	ret = isc_try_fmt(isc, &f, NULL);
>  	if (ret)
>  		return ret;
>  
> -	isc->current_fmt = isc->user_formats[0];
>  	isc->fmt = f;
> -
>  	return 0;
>  }
>  
> 

Regards,

	Hans
