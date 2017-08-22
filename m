Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:50987 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754434AbdHVBSl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 21:18:41 -0400
Subject: Re: [PATCH 1/3] media: atmel-isc: Not support RBG format from sensor.
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20170817071614.12767-1-wenyou.yang@microchip.com>
 <20170817071614.12767-2-wenyou.yang@microchip.com>
 <61cb51fa-8d05-6707-00cc-429c761fa6f5@xs4all.nl>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <14941b74-8931-4d00-0664-0735fad9b5d1@Microchip.com>
Date: Tue, 22 Aug 2017 09:18:17 +0800
MIME-Version: 1.0
In-Reply-To: <61cb51fa-8d05-6707-00cc-429c761fa6f5@xs4all.nl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2017/8/21 22:07, Hans Verkuil wrote:
> On 08/17/2017 09:16 AM, Wenyou Yang wrote:
>> The 12-bit parallel interface supports the Raw Bayer, YCbCr,
>> Monochrome and JPEG Compressed pixel formats from the external
>> sensor, not support RBG pixel format.
>>
>> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
>> ---
>>
>>   drivers/media/platform/atmel/atmel-isc.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
>> index d4df3d4ccd85..535bb03783fe 100644
>> --- a/drivers/media/platform/atmel/atmel-isc.c
>> +++ b/drivers/media/platform/atmel/atmel-isc.c
>> @@ -1478,6 +1478,11 @@ static int isc_formats_init(struct isc_device *isc)
>>   	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
>>   	       NULL, &mbus_code)) {
>>   		mbus_code.index++;
>> +
>> +		/* Not support the RGB pixel formats from sensor */
>> +		if ((mbus_code.code & 0xf000) == 0x1000)
>> +			continue;
> Am I missing something? Here you skip any RGB mediabus formats, but in patch 3/3
> you add RGB mediabus formats. But this patch prevents those new formats from being
> selected, right?
This patch prevents getting the RGB format from the sensor directly.
The RGB format can be produced by ISC controller by itself.

> Regards,
>
> 	Hans
>
>> +
>>   		fmt = find_format_by_code(mbus_code.code, &i);
>>   		if (!fmt)
>>   			continue;
>>

Best Regards,
Wenyou Yang
