Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:35937 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbdI0FPh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 01:15:37 -0400
Subject: Re: [PATCH v2 5/5] media: atmel-isc: Rework the format list
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20170918063925.6372-1-wenyou.yang@microchip.com>
 <20170918063925.6372-6-wenyou.yang@microchip.com>
 <33dbaf5d-f51a-c148-460b-9079a2696fb1@xs4all.nl>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <2557b706-9786-0d81-08d5-b61547ddb3e1@Microchip.com>
Date: Wed, 27 Sep 2017 13:15:25 +0800
MIME-Version: 1.0
In-Reply-To: <33dbaf5d-f51a-c148-460b-9079a2696fb1@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank  you very much for your review.

On 2017/9/25 21:24, Hans Verkuil wrote:
> Hi Wenyou,
>
> On 18/09/17 08:39, Wenyou Yang wrote:
>> To improve the readability of code, split the format array into two,
>> one for the format description, other for the register configuration.
>> Meanwhile, add the flag member to indicate the format can be achieved
>> from the sensor or be produced by the controller, and rename members
>> related to the register configuration.
>>
>> Also add more formats support: GREY, ARGB444, ARGB555 and ARGB32.
>>
>> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
> This looks better. Just a few comments, see below.
>
>> ---
>>
>> Changes in v2:
>>   - Add the new patch to remove the unnecessary member from
>>     isc_subdev_entity struct.
>>   - Rebase on the patch set,
>>          [PATCH 0/6] [media] Atmel: Adjustments for seven function implementations
>>          https://www.mail-archive.com/linux-media@vger.kernel.org/msg118342.html
>>
>>   drivers/media/platform/atmel/atmel-isc.c | 524 ++++++++++++++++++++++++-------
>>   1 file changed, 405 insertions(+), 119 deletions(-)
>>
>> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
>> index 2d876903da71..90bd0b28a975 100644
>> --- a/drivers/media/platform/atmel/atmel-isc.c
>> +++ b/drivers/media/platform/atmel/atmel-isc.c
>> @@ -89,34 +89,56 @@ struct isc_subdev_entity {
>>   	struct list_head list;
>>   };
>>   
>> +#define FMT_FLAG_FROM_SENSOR		BIT(0)
>> +#define FMT_FLAG_FROM_CONTROLLER	BIT(1)
> Document the meaning of these flags.
Will add it in next version.
>
>> +
>>   /*
>>    * struct isc_format - ISC media bus format information
>>    * @fourcc:		Fourcc code for this format
>>    * @mbus_code:		V4L2 media bus format code.
>> + * flags:		Indicate format from sensor or converted by controller
>>    * @bpp:		Bits per pixel (when stored in memory)
>> - * @reg_bps:		reg value for bits per sample
>>    *			(when transferred over a bus)
>> - * @pipeline:		pipeline switch
>>    * @sd_support:		Subdev supports this format
>>    * @isc_support:	ISC can convert raw format to this format
>>    */
>> +
>>   struct isc_format {
>>   	u32	fourcc;
>>   	u32	mbus_code;
>> +	u32	flags;
>>   	u8	bpp;
>>   
>> -	u32	reg_bps;
>> -	u32	reg_bay_cfg;
>> -	u32	reg_rlp_mode;
>> -	u32	reg_dcfg_imode;
>> -	u32	reg_dctrl_dview;
>> -
>> -	u32	pipeline;
>> -
>>   	bool	sd_support;
>>   	bool	isc_support;
>>   };
>>   
>> +/* Pipeline bitmap */
>> +#define WB_ENABLE	BIT(0)
>> +#define CFA_ENABLE	BIT(1)
>> +#define CC_ENABLE	BIT(2)
>> +#define GAM_ENABLE	BIT(3)
>> +#define GAM_BENABLE	BIT(4)
>> +#define GAM_GENABLE	BIT(5)
>> +#define GAM_RENABLE	BIT(6)
>> +#define CSC_ENABLE	BIT(7)
>> +#define CBC_ENABLE	BIT(8)
>> +#define SUB422_ENABLE	BIT(9)
>> +#define SUB420_ENABLE	BIT(10)
>> +
>> +#define GAM_ENABLES	(GAM_RENABLE | GAM_GENABLE | GAM_BENABLE | GAM_ENABLE)
>> +
>> +struct fmt_config {
>> +	u32	fourcc;
>> +
>> +	u32	pfe_cfg0_bps;
>> +	u32	cfa_baycfg;
>> +	u32	rlp_cfg_mode;
>> +	u32	dcfg_imode;
>> +	u32	dctrl_dview;
>> +
>> +	u32	bits_pipeline;
>> +};
>>   
>>   #define HIST_ENTRIES		512
>>   #define HIST_BAYER		(ISC_HIS_CFG_MODE_B + 1)
>> @@ -181,80 +203,321 @@ struct isc_device {
>>   	struct list_head		subdev_entities;
>>   };
>>   
>> -#define RAW_FMT_IND_START    0
>> -#define RAW_FMT_IND_END      11
>> -#define ISC_FMT_IND_START    12
>> -#define ISC_FMT_IND_END      14
>> -
>> -static struct isc_format isc_formats[] = {
>> -	{ V4L2_PIX_FMT_SBGGR8, MEDIA_BUS_FMT_SBGGR8_1X8, 8,
>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT8,
>> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -	{ V4L2_PIX_FMT_SGBRG8, MEDIA_BUS_FMT_SGBRG8_1X8, 8,
>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT8,
>> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -	{ V4L2_PIX_FMT_SGRBG8, MEDIA_BUS_FMT_SGRBG8_1X8, 8,
>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT8,
>> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -	{ V4L2_PIX_FMT_SRGGB8, MEDIA_BUS_FMT_SRGGB8_1X8, 8,
>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT8,
>> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -
>> -	{ V4L2_PIX_FMT_SBGGR10, MEDIA_BUS_FMT_SBGGR10_1X10, 16,
>> -	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT10,
>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -	{ V4L2_PIX_FMT_SGBRG10, MEDIA_BUS_FMT_SGBRG10_1X10, 16,
>> -	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT10,
>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -	{ V4L2_PIX_FMT_SGRBG10, MEDIA_BUS_FMT_SGRBG10_1X10, 16,
>> -	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT10,
>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -	{ V4L2_PIX_FMT_SRGGB10, MEDIA_BUS_FMT_SRGGB10_1X10, 16,
>> -	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT10,
>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -
>> -	{ V4L2_PIX_FMT_SBGGR12, MEDIA_BUS_FMT_SBGGR12_1X12, 16,
>> -	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT12,
>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -	{ V4L2_PIX_FMT_SGBRG12, MEDIA_BUS_FMT_SGBRG12_1X12, 16,
>> -	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT12,
>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -	{ V4L2_PIX_FMT_SGRBG12, MEDIA_BUS_FMT_SGRBG12_1X12, 16,
>> -	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT12,
>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -	{ V4L2_PIX_FMT_SRGGB12, MEDIA_BUS_FMT_SRGGB12_1X12, 16,
>> -	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT12,
>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> -
>> -	{ V4L2_PIX_FMT_YUV420, 0x0, 12,
>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_YYCC,
>> -	  ISC_DCFG_IMODE_YC420P, ISC_DCTRL_DVIEW_PLANAR, 0x7fb,
>> -	  false, false },
>> -	{ V4L2_PIX_FMT_YUV422P, 0x0, 16,
>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_YYCC,
>> -	  ISC_DCFG_IMODE_YC422P, ISC_DCTRL_DVIEW_PLANAR, 0x3fb,
>> -	  false, false },
>> -	{ V4L2_PIX_FMT_RGB565, MEDIA_BUS_FMT_RGB565_2X8_LE, 16,
>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_RGB565,
>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x7b,
>> -	  false, false },
>> -
>> -	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YUYV8_2X8, 16,
>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT8,
>> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
>> -	  false, false },
>> +#define MAX_RAW_FMT_INDEX	11
> Do you still need this? The FMT_FLAG_FROM_SENSOR already tells you if it
> is a raw format or not.
>
> As far as I can tell you can drop this define.
The MAX_RAW_FMT_INDEX is used to get the raw format supported by the sensor.
Some sensor provide more formats other than the raw format, so the 
FMT_FLAG_FROM_SENSOR is not enough.

> Regards,
>
> 	Hans

Best Regards,
Wenyou Yang
>> +static struct isc_format formats_list[] = {
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SBGGR8,
>> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR8_1X8,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 8,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGBRG8,
>> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG8_1X8,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 8,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGRBG8,
>> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG8_1X8,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 8,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SRGGB8,
>> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB8_1X8,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 8,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SBGGR10,
>> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGBRG10,
>> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG10_1X10,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGRBG10,
>> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG10_1X10,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SRGGB10,
>> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB10_1X10,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SBGGR12,
>> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR12_1X12,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGBRG12,
>> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG12_1X12,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGRBG12,
>> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG12_1X12,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SRGGB12,
>> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB12_1X12,
>> +		.flags		= FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_YUV420,
>> +		.mbus_code	= 0x0,
>> +		.flags		= FMT_FLAG_FROM_CONTROLLER,
>> +		.bpp		= 12,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_YUV422P,
>> +		.mbus_code	= 0x0,
>> +		.flags		= FMT_FLAG_FROM_CONTROLLER,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_GREY,
>> +		.mbus_code	= MEDIA_BUS_FMT_Y8_1X8,
>> +		.flags		= FMT_FLAG_FROM_CONTROLLER |
>> +				  FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 8,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_ARGB444,
>> +		.mbus_code	= MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
>> +		.flags		= FMT_FLAG_FROM_CONTROLLER,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_ARGB555,
>> +		.mbus_code	= MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
>> +		.flags		= FMT_FLAG_FROM_CONTROLLER,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_RGB565,
>> +		.mbus_code	= MEDIA_BUS_FMT_RGB565_2X8_LE,
>> +		.flags		= FMT_FLAG_FROM_CONTROLLER,
>> +		.bpp		= 16,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_ARGB32,
>> +		.mbus_code	= MEDIA_BUS_FMT_ARGB8888_1X32,
>> +		.flags		= FMT_FLAG_FROM_CONTROLLER,
>> +		.bpp		= 32,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_YUYV,
>> +		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
>> +		.flags		= FMT_FLAG_FROM_CONTROLLER |
>> +				  FMT_FLAG_FROM_SENSOR,
>> +		.bpp		= 16,
>> +	},
>> +};
>> +
>> +struct fmt_config fmt_configs_list[] = {
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SBGGR8,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT8,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGBRG8,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_GBGB,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT8,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGRBG8,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_GRGR,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT8,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SRGGB8,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT8,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SBGGR10,
>> +		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
>> +		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT10,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGBRG10,
>> +		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
>> +		.cfa_baycfg	= ISC_BAY_CFG_GBGB,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT10,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGRBG10,
>> +		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
>> +		.cfa_baycfg	= ISC_BAY_CFG_GRGR,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT10,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SRGGB10,
>> +		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TEN,
>> +		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT10,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SBGGR12,
>> +		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
>> +		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT12,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGBRG12,
>> +		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
>> +		.cfa_baycfg	= ISC_BAY_CFG_GBGB,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT12,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SGRBG12,
>> +		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
>> +		.cfa_baycfg	= ISC_BAY_CFG_GRGR,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT12,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_SRGGB12,
>> +		.pfe_cfg0_bps	= ISC_PFG_CFG0_BPS_TWELVE,
>> +		.cfa_baycfg	= ISC_BAY_CFG_RGRG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT12,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0,
>> +	},
>> +	{
>> +		.fourcc = V4L2_PIX_FMT_YUV420,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_YYCC,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_YC420P,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PLANAR,
>> +		.bits_pipeline	= SUB420_ENABLE | SUB422_ENABLE |
>> +				  CBC_ENABLE | CSC_ENABLE |
>> +				  GAM_ENABLES |
>> +				  CFA_ENABLE | WB_ENABLE,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_YUV422P,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_YYCC,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_YC422P,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PLANAR,
>> +		.bits_pipeline	= SUB422_ENABLE |
>> +				  CBC_ENABLE | CSC_ENABLE |
>> +				  GAM_ENABLES |
>> +				  CFA_ENABLE | WB_ENABLE,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_GREY,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DATY8,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= CBC_ENABLE | CSC_ENABLE |
>> +				  GAM_ENABLES |
>> +				  CFA_ENABLE | WB_ENABLE,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_ARGB444,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_ARGB444,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_ARGB555,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_ARGB555,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_RGB565,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_RGB565,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED16,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_ARGB32,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_ARGB32,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED32,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= GAM_ENABLES | CFA_ENABLE | WB_ENABLE,
>> +	},
>> +	{
>> +		.fourcc		= V4L2_PIX_FMT_YUYV,
>> +		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
>> +		.cfa_baycfg	= ISC_BAY_CFG_BGBG,
>> +		.rlp_cfg_mode	= ISC_RLP_CFG_MODE_DAT8,
>> +		.dcfg_imode	= ISC_DCFG_IMODE_PACKED8,
>> +		.dctrl_dview	= ISC_DCTRL_DVIEW_PACKED,
>> +		.bits_pipeline	= 0x0
>> +	},
>>   };
>>   
>>   #define GAMMA_MAX	2
>> @@ -616,11 +879,27 @@ static inline bool sensor_is_preferred(const struct isc_format *isc_fmt)
>>   		!isc_fmt->isc_support;
>>   }
>>   
>> +static struct fmt_config *get_fmt_config(u32 fourcc)
>> +{
>> +	struct fmt_config *config;
>> +	int i;
>> +
>> +	config = &fmt_configs_list[0];
>> +	for (i = 0; i < ARRAY_SIZE(fmt_configs_list); i++) {
>> +		if (config->fourcc == fourcc)
>> +			return config;
>> +
>> +		config++;
>> +	}
>> +	return NULL;
>> +}
>> +
>>   static void isc_start_dma(struct isc_device *isc)
>>   {
>>   	struct regmap *regmap = isc->regmap;
>>   	struct v4l2_pix_format *pixfmt = &isc->fmt.fmt.pix;
>>   	u32 sizeimage = pixfmt->sizeimage;
>> +	struct fmt_config *config = get_fmt_config(isc->current_fmt->fourcc);
>>   	u32 dctrl_dview;
>>   	dma_addr_t addr0;
>>   
>> @@ -643,7 +922,7 @@ static void isc_start_dma(struct isc_device *isc)
>>   	if (sensor_is_preferred(isc->current_fmt))
>>   		dctrl_dview = ISC_DCTRL_DVIEW_PACKED;
>>   	else
>> -		dctrl_dview = isc->current_fmt->reg_dctrl_dview;
>> +		dctrl_dview = config->dctrl_dview;
>>   
>>   	regmap_write(regmap, ISC_DCTRL, dctrl_dview | ISC_DCTRL_IE_IS);
>>   	regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_CAPTURE);
>> @@ -653,6 +932,7 @@ static void isc_set_pipeline(struct isc_device *isc, u32 pipeline)
>>   {
>>   	struct regmap *regmap = isc->regmap;
>>   	struct isc_ctrls *ctrls = &isc->ctrls;
>> +	struct fmt_config *config = get_fmt_config(isc->raw_fmt->fourcc);
>>   	u32 val, bay_cfg;
>>   	const u32 *gamma;
>>   	unsigned int i;
>> @@ -666,7 +946,7 @@ static void isc_set_pipeline(struct isc_device *isc, u32 pipeline)
>>   	if (!pipeline)
>>   		return;
>>   
>> -	bay_cfg = isc->raw_fmt->reg_bay_cfg;
>> +	bay_cfg = config->cfa_baycfg;
>>   
>>   	regmap_write(regmap, ISC_WB_CFG, bay_cfg);
>>   	regmap_write(regmap, ISC_WB_O_RGR, 0x0);
>> @@ -719,11 +999,13 @@ static void isc_set_histogram(struct isc_device *isc)
>>   {
>>   	struct regmap *regmap = isc->regmap;
>>   	struct isc_ctrls *ctrls = &isc->ctrls;
>> +	struct fmt_config *config = get_fmt_config(isc->raw_fmt->fourcc);
>>   
>>   	if (ctrls->awb && (ctrls->hist_stat != HIST_ENABLED)) {
>> -		regmap_write(regmap, ISC_HIS_CFG, ISC_HIS_CFG_MODE_R |
>> -		      (isc->raw_fmt->reg_bay_cfg << ISC_HIS_CFG_BAYSEL_SHIFT) |
>> -		      ISC_HIS_CFG_RAR);
>> +		regmap_write(regmap, ISC_HIS_CFG,
>> +			     ISC_HIS_CFG_MODE_R |
>> +			     (config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT) |
>> +			     ISC_HIS_CFG_RAR);
>>   		regmap_write(regmap, ISC_HIS_CTRL, ISC_HIS_CTRL_EN);
>>   		regmap_write(regmap, ISC_INTEN, ISC_INT_HISDONE);
>>   		ctrls->hist_id = ISC_HIS_CFG_MODE_R;
>> @@ -740,8 +1022,10 @@ static void isc_set_histogram(struct isc_device *isc)
>>   }
>>   
>>   static inline void isc_get_param(const struct isc_format *fmt,
>> -				  u32 *rlp_mode, u32 *dcfg)
>> +				 u32 *rlp_mode, u32 *dcfg)
>>   {
>> +	struct fmt_config *config = get_fmt_config(fmt->fourcc);
>> +
>>   	*dcfg = ISC_DCFG_YMBSIZE_BEATS8;
>>   
>>   	switch (fmt->fourcc) {
>> @@ -753,8 +1037,8 @@ static inline void isc_get_param(const struct isc_format *fmt,
>>   	case V4L2_PIX_FMT_SGBRG12:
>>   	case V4L2_PIX_FMT_SGRBG12:
>>   	case V4L2_PIX_FMT_SRGGB12:
>> -		*rlp_mode = fmt->reg_rlp_mode;
>> -		*dcfg |= fmt->reg_dcfg_imode;
>> +		*rlp_mode = config->rlp_cfg_mode;
>> +		*dcfg |= config->dcfg_imode;
>>   		break;
>>   	default:
>>   		*rlp_mode = ISC_RLP_CFG_MODE_DAT8;
>> @@ -767,20 +1051,22 @@ static int isc_configure(struct isc_device *isc)
>>   {
>>   	struct regmap *regmap = isc->regmap;
>>   	const struct isc_format *current_fmt = isc->current_fmt;
>> +	struct fmt_config *curfmt_config = get_fmt_config(current_fmt->fourcc);
>> +	struct fmt_config *rawfmt_config = get_fmt_config(isc->raw_fmt->fourcc);
>>   	struct isc_subdev_entity *subdev = isc->current_subdev;
>>   	u32 pfe_cfg0, rlp_mode, dcfg, mask, pipeline;
>>   
>>   	if (sensor_is_preferred(current_fmt)) {
>> -		pfe_cfg0 = current_fmt->reg_bps;
>> +		pfe_cfg0 = curfmt_config->pfe_cfg0_bps;
>>   		pipeline = 0x0;
>>   		isc_get_param(current_fmt, &rlp_mode, &dcfg);
>>   		isc->ctrls.hist_stat = HIST_INIT;
>>   	} else {
>> -		pfe_cfg0  = isc->raw_fmt->reg_bps;
>> -		pipeline = current_fmt->pipeline;
>> -		rlp_mode = current_fmt->reg_rlp_mode;
>> -		dcfg = current_fmt->reg_dcfg_imode | ISC_DCFG_YMBSIZE_BEATS8 |
>> -		       ISC_DCFG_CMBSIZE_BEATS8;
>> +		pfe_cfg0 = rawfmt_config->pfe_cfg0_bps;
>> +		pipeline = curfmt_config->bits_pipeline;
>> +		rlp_mode = curfmt_config->rlp_cfg_mode;
>> +		dcfg = curfmt_config->dcfg_imode |
>> +		       ISC_DCFG_YMBSIZE_BEATS8 | ISC_DCFG_CMBSIZE_BEATS8;
>>   	}
>>   
>>   	pfe_cfg0  |= subdev->pfe_cfg0 | ISC_PFE_CFG0_MODE_PROGRESSIVE;
>> @@ -1365,6 +1651,7 @@ static void isc_awb_work(struct work_struct *w)
>>   	struct isc_device *isc =
>>   		container_of(w, struct isc_device, awb_work);
>>   	struct regmap *regmap = isc->regmap;
>> +	struct fmt_config *config = get_fmt_config(isc->raw_fmt->fourcc);
>>   	struct isc_ctrls *ctrls = &isc->ctrls;
>>   	u32 hist_id = ctrls->hist_id;
>>   	u32 baysel;
>> @@ -1382,7 +1669,7 @@ static void isc_awb_work(struct work_struct *w)
>>   	}
>>   
>>   	ctrls->hist_id = hist_id;
>> -	baysel = isc->raw_fmt->reg_bay_cfg << ISC_HIS_CFG_BAYSEL_SHIFT;
>> +	baysel = config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT;
>>   
>>   	pm_runtime_get_sync(isc->dev);
>>   
>> @@ -1483,10 +1770,10 @@ static void isc_async_unbind(struct v4l2_async_notifier *notifier,
>>   
>>   static struct isc_format *find_format_by_code(unsigned int code, int *index)
>>   {
>> -	struct isc_format *fmt = &isc_formats[0];
>> +	struct isc_format *fmt = &formats_list[0];
>>   	unsigned int i;
>>   
>> -	for (i = 0; i < ARRAY_SIZE(isc_formats); i++) {
>> +	for (i = 0; i < ARRAY_SIZE(formats_list); i++) {
>>   		if (fmt->mbus_code == code) {
>>   			*index = i;
>>   			return fmt;
>> @@ -1503,37 +1790,36 @@ static int isc_formats_init(struct isc_device *isc)
>>   	struct isc_format *fmt;
>>   	struct v4l2_subdev *subdev = isc->current_subdev->sd;
>>   	unsigned int num_fmts, i, j;
>> +	u32 list_size = ARRAY_SIZE(formats_list);
>>   	struct v4l2_subdev_mbus_code_enum mbus_code = {
>>   		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>>   	};
>>   
>> -	fmt = &isc_formats[0];
>> -	for (i = 0; i < ARRAY_SIZE(isc_formats); i++) {
>> -		fmt->isc_support = false;
>> -		fmt->sd_support = false;
>> -
>> -		fmt++;
>> -	}
>> -
>>   	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
>>   	       NULL, &mbus_code)) {
>>   		mbus_code.index++;
>> +
>>   		fmt = find_format_by_code(mbus_code.code, &i);
>> -		if (!fmt)
>> +		if ((!fmt) || (!(fmt->flags & FMT_FLAG_FROM_SENSOR)))
>>   			continue;
>>   
>>   		fmt->sd_support = true;
>>   
>> -		if (i <= RAW_FMT_IND_END) {
>> -			for (j = ISC_FMT_IND_START; j <= ISC_FMT_IND_END; j++)
>> -				isc_formats[j].isc_support = true;
>> -
>> +		if (i <= MAX_RAW_FMT_INDEX)
>>   			isc->raw_fmt = fmt;
>> -		}
>>   	}
>>   
>> -	fmt = &isc_formats[0];
>> -	for (i = 0, num_fmts = 0; i < ARRAY_SIZE(isc_formats); i++) {
>> +	fmt = &formats_list[0];
>> +	for (i = 0; i < list_size; i++) {
>> +		if (fmt->flags & FMT_FLAG_FROM_CONTROLLER)
>> +			fmt->isc_support = true;
>> +
>> +		fmt++;
>> +	}
>> +
>> +	fmt = &formats_list[0];
>> +	num_fmts = 0;
>> +	for (i = 0; i < list_size; i++) {
>>   		if (fmt->isc_support || fmt->sd_support)
>>   			num_fmts++;
>>   
>> @@ -1550,8 +1836,8 @@ static int isc_formats_init(struct isc_device *isc)
>>   	if (!isc->user_formats)
>>   		return -ENOMEM;
>>   
>> -	fmt = &isc_formats[0];
>> -	for (i = 0, j = 0; i < ARRAY_SIZE(isc_formats); i++) {
>> +	fmt = &formats_list[0];
>> +	for (i = 0, j = 0; i < list_size; i++) {
>>   		if (fmt->isc_support || fmt->sd_support)
>>   			isc->user_formats[j++] = fmt;
>>   
>>
