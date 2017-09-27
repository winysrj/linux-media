Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47726 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751362AbdI0IEE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 04:04:04 -0400
Subject: Re: [PATCH v2 5/5] media: atmel-isc: Rework the format list
To: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20170918063925.6372-1-wenyou.yang@microchip.com>
 <20170918063925.6372-6-wenyou.yang@microchip.com>
 <33dbaf5d-f51a-c148-460b-9079a2696fb1@xs4all.nl>
 <2557b706-9786-0d81-08d5-b61547ddb3e1@Microchip.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c3a96aa1-2faf-1d1d-b73e-347b25affeab@xs4all.nl>
Date: Wed, 27 Sep 2017 10:03:57 +0200
MIME-Version: 1.0
In-Reply-To: <2557b706-9786-0d81-08d5-b61547ddb3e1@Microchip.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/2017 07:15 AM, Yang, Wenyou wrote:
> Hi Hans,
> 
> Thank  you very much for your review.
> 
> On 2017/9/25 21:24, Hans Verkuil wrote:
>> Hi Wenyou,
>>
>> On 18/09/17 08:39, Wenyou Yang wrote:
>>> To improve the readability of code, split the format array into two,
>>> one for the format description, other for the register configuration.
>>> Meanwhile, add the flag member to indicate the format can be achieved
>>> from the sensor or be produced by the controller, and rename members
>>> related to the register configuration.
>>>
>>> Also add more formats support: GREY, ARGB444, ARGB555 and ARGB32.
>>>
>>> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
>> This looks better. Just a few comments, see below.
>>
>>> ---
>>>
>>> Changes in v2:
>>>   - Add the new patch to remove the unnecessary member from
>>>     isc_subdev_entity struct.
>>>   - Rebase on the patch set,
>>>          [PATCH 0/6] [media] Atmel: Adjustments for seven function implementations
>>>          https://www.mail-archive.com/linux-media@vger.kernel.org/msg118342.html
>>>
>>>   drivers/media/platform/atmel/atmel-isc.c | 524 ++++++++++++++++++++++++-------
>>>   1 file changed, 405 insertions(+), 119 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
>>> index 2d876903da71..90bd0b28a975 100644
>>> --- a/drivers/media/platform/atmel/atmel-isc.c
>>> +++ b/drivers/media/platform/atmel/atmel-isc.c
>>> @@ -89,34 +89,56 @@ struct isc_subdev_entity {
>>>   	struct list_head list;
>>>   };
>>>   
>>> +#define FMT_FLAG_FROM_SENSOR		BIT(0)
>>> +#define FMT_FLAG_FROM_CONTROLLER	BIT(1)
>> Document the meaning of these flags.
> Will add it in next version.
>>
>>> +
>>>   /*
>>>    * struct isc_format - ISC media bus format information
>>>    * @fourcc:		Fourcc code for this format
>>>    * @mbus_code:		V4L2 media bus format code.
>>> + * flags:		Indicate format from sensor or converted by controller
>>>    * @bpp:		Bits per pixel (when stored in memory)
>>> - * @reg_bps:		reg value for bits per sample
>>>    *			(when transferred over a bus)
>>> - * @pipeline:		pipeline switch
>>>    * @sd_support:		Subdev supports this format
>>>    * @isc_support:	ISC can convert raw format to this format
>>>    */
>>> +
>>>   struct isc_format {
>>>   	u32	fourcc;
>>>   	u32	mbus_code;
>>> +	u32	flags;
>>>   	u8	bpp;
>>>   
>>> -	u32	reg_bps;
>>> -	u32	reg_bay_cfg;
>>> -	u32	reg_rlp_mode;
>>> -	u32	reg_dcfg_imode;
>>> -	u32	reg_dctrl_dview;
>>> -
>>> -	u32	pipeline;
>>> -
>>>   	bool	sd_support;
>>>   	bool	isc_support;
>>>   };
>>>   
>>> +/* Pipeline bitmap */
>>> +#define WB_ENABLE	BIT(0)
>>> +#define CFA_ENABLE	BIT(1)
>>> +#define CC_ENABLE	BIT(2)
>>> +#define GAM_ENABLE	BIT(3)
>>> +#define GAM_BENABLE	BIT(4)
>>> +#define GAM_GENABLE	BIT(5)
>>> +#define GAM_RENABLE	BIT(6)
>>> +#define CSC_ENABLE	BIT(7)
>>> +#define CBC_ENABLE	BIT(8)
>>> +#define SUB422_ENABLE	BIT(9)
>>> +#define SUB420_ENABLE	BIT(10)
>>> +
>>> +#define GAM_ENABLES	(GAM_RENABLE | GAM_GENABLE | GAM_BENABLE | GAM_ENABLE)
>>> +
>>> +struct fmt_config {
>>> +	u32	fourcc;
>>> +
>>> +	u32	pfe_cfg0_bps;
>>> +	u32	cfa_baycfg;
>>> +	u32	rlp_cfg_mode;
>>> +	u32	dcfg_imode;
>>> +	u32	dctrl_dview;
>>> +
>>> +	u32	bits_pipeline;
>>> +};
>>>   
>>>   #define HIST_ENTRIES		512
>>>   #define HIST_BAYER		(ISC_HIS_CFG_MODE_B + 1)
>>> @@ -181,80 +203,321 @@ struct isc_device {
>>>   	struct list_head		subdev_entities;
>>>   };
>>>   
>>> -#define RAW_FMT_IND_START    0
>>> -#define RAW_FMT_IND_END      11
>>> -#define ISC_FMT_IND_START    12
>>> -#define ISC_FMT_IND_END      14
>>> -
>>> -static struct isc_format isc_formats[] = {
>>> -	{ V4L2_PIX_FMT_SBGGR8, MEDIA_BUS_FMT_SBGGR8_1X8, 8,
>>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT8,
>>> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -	{ V4L2_PIX_FMT_SGBRG8, MEDIA_BUS_FMT_SGBRG8_1X8, 8,
>>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT8,
>>> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -	{ V4L2_PIX_FMT_SGRBG8, MEDIA_BUS_FMT_SGRBG8_1X8, 8,
>>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT8,
>>> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -	{ V4L2_PIX_FMT_SRGGB8, MEDIA_BUS_FMT_SRGGB8_1X8, 8,
>>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT8,
>>> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -
>>> -	{ V4L2_PIX_FMT_SBGGR10, MEDIA_BUS_FMT_SBGGR10_1X10, 16,
>>> -	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT10,
>>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -	{ V4L2_PIX_FMT_SGBRG10, MEDIA_BUS_FMT_SGBRG10_1X10, 16,
>>> -	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT10,
>>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -	{ V4L2_PIX_FMT_SGRBG10, MEDIA_BUS_FMT_SGRBG10_1X10, 16,
>>> -	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT10,
>>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -	{ V4L2_PIX_FMT_SRGGB10, MEDIA_BUS_FMT_SRGGB10_1X10, 16,
>>> -	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT10,
>>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -
>>> -	{ V4L2_PIX_FMT_SBGGR12, MEDIA_BUS_FMT_SBGGR12_1X12, 16,
>>> -	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT12,
>>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -	{ V4L2_PIX_FMT_SGBRG12, MEDIA_BUS_FMT_SGBRG12_1X12, 16,
>>> -	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_GBGB, ISC_RLP_CFG_MODE_DAT12,
>>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -	{ V4L2_PIX_FMT_SGRBG12, MEDIA_BUS_FMT_SGRBG12_1X12, 16,
>>> -	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_GRGR, ISC_RLP_CFG_MODE_DAT12,
>>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -	{ V4L2_PIX_FMT_SRGGB12, MEDIA_BUS_FMT_SRGGB12_1X12, 16,
>>> -	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_RGRG, ISC_RLP_CFG_MODE_DAT12,
>>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> -
>>> -	{ V4L2_PIX_FMT_YUV420, 0x0, 12,
>>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_YYCC,
>>> -	  ISC_DCFG_IMODE_YC420P, ISC_DCTRL_DVIEW_PLANAR, 0x7fb,
>>> -	  false, false },
>>> -	{ V4L2_PIX_FMT_YUV422P, 0x0, 16,
>>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_YYCC,
>>> -	  ISC_DCFG_IMODE_YC422P, ISC_DCTRL_DVIEW_PLANAR, 0x3fb,
>>> -	  false, false },
>>> -	{ V4L2_PIX_FMT_RGB565, MEDIA_BUS_FMT_RGB565_2X8_LE, 16,
>>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_RGB565,
>>> -	  ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x7b,
>>> -	  false, false },
>>> -
>>> -	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YUYV8_2X8, 16,
>>> -	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_DAT8,
>>> -	  ISC_DCFG_IMODE_PACKED8, ISC_DCTRL_DVIEW_PACKED, 0x0,
>>> -	  false, false },
>>> +#define MAX_RAW_FMT_INDEX	11
>> Do you still need this? The FMT_FLAG_FROM_SENSOR already tells you if it
>> is a raw format or not.
>>
>> As far as I can tell you can drop this define.
> The MAX_RAW_FMT_INDEX is used to get the raw format supported by the sensor.
> Some sensor provide more formats other than the raw format, so the 
> FMT_FLAG_FROM_SENSOR is not enough.

So, add a new flag. The problem with a define like that is that is easily
can get out-of-sync with the array. It's a fragile coding approach.

Regards,

	Hans
