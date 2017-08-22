Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:54886 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754563AbdHVHA2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 03:00:28 -0400
Subject: Re: [PATCH 1/3] media: atmel-isc: Not support RBG format from sensor.
To: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20170817071614.12767-1-wenyou.yang@microchip.com>
 <20170817071614.12767-2-wenyou.yang@microchip.com>
 <61cb51fa-8d05-6707-00cc-429c761fa6f5@xs4all.nl>
 <14941b74-8931-4d00-0664-0735fad9b5d1@Microchip.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ce6d074b-1c13-d3ea-5dfa-89cca2f26feb@xs4all.nl>
Date: Tue, 22 Aug 2017 09:00:23 +0200
MIME-Version: 1.0
In-Reply-To: <14941b74-8931-4d00-0664-0735fad9b5d1@Microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/22/2017 03:18 AM, Yang, Wenyou wrote:
> Hi Hans,
> 
> On 2017/8/21 22:07, Hans Verkuil wrote:
>> On 08/17/2017 09:16 AM, Wenyou Yang wrote:
>>> The 12-bit parallel interface supports the Raw Bayer, YCbCr,
>>> Monochrome and JPEG Compressed pixel formats from the external
>>> sensor, not support RBG pixel format.
>>>
>>> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
>>> ---
>>>
>>>   drivers/media/platform/atmel/atmel-isc.c | 5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
>>> index d4df3d4ccd85..535bb03783fe 100644
>>> --- a/drivers/media/platform/atmel/atmel-isc.c
>>> +++ b/drivers/media/platform/atmel/atmel-isc.c
>>> @@ -1478,6 +1478,11 @@ static int isc_formats_init(struct isc_device *isc)
>>>   	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
>>>   	       NULL, &mbus_code)) {
>>>   		mbus_code.index++;
>>> +
>>> +		/* Not support the RGB pixel formats from sensor */
>>> +		if ((mbus_code.code & 0xf000) == 0x1000)
>>> +			continue;
>> Am I missing something? Here you skip any RGB mediabus formats, but in patch 3/3
>> you add RGB mediabus formats. But this patch prevents those new formats from being
>> selected, right?
> This patch prevents getting the RGB format from the sensor directly.
> The RGB format can be produced by ISC controller by itself.

OK, I think I see what is going on here. The isc_formats array really is two
arrays in one: up to RAW_FMT_IND_END it describes what it can receive from
the source, and after that it describes what it can convert it to.

But if you can't handle RGB formats from the sensor, then why not make
sure none of the mbus codes in isc_formats uses RGB? That makes much
more sense.

E.g.:

        { V4L2_PIX_FMT_RGB565, MEDIA_BUS_FMT_RGB565_2X8_LE, 16,
          ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG, ISC_RLP_CFG_MODE_RGB565,
          ISC_DCFG_IMODE_PACKED16, ISC_DCTRL_DVIEW_PACKED, 0x7b,
          false, false },

Why use MEDIA_BUS_FMT_RGB565_2X8_LE if this apparently is not supported?

Regards,

	Hans

> 
>> Regards,
>>
>> 	Hans
>>
>>> +
>>>   		fmt = find_format_by_code(mbus_code.code, &i);
>>>   		if (!fmt)
>>>   			continue;
>>>
> 
> Best Regards,
> Wenyou Yang
> 
