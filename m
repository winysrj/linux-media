Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:33921 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbdHQBiw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 21:38:52 -0400
Subject: Re: [PATCH 1/2] media: ov7670: Add entity pads initialization
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Jonathan Corbet <corbet@lwn.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20170810090645.24344-1-wenyou.yang@microchip.com>
 <20170810090645.24344-2-wenyou.yang@microchip.com>
 <20170815162351.ikd4n2zl2gj26m5r@valkosipuli.retiisi.org.uk>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <8eddc757-0919-6470-f000-f764c3b27152@Microchip.com>
Date: Thu, 17 Aug 2017 09:38:29 +0800
MIME-Version: 1.0
In-Reply-To: <20170815162351.ikd4n2zl2gj26m5r@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 2017/8/16 0:23, Sakari Ailus wrote:
> Hi Wenyou,
>
> On Thu, Aug 10, 2017 at 05:06:44PM +0800, Wenyou Yang wrote:
>> Add the media entity pads initialization.
>>
>> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
> The patch itself seems fine. However the driver is lacking support for
> get_fmt which I think would be necessary for the user space API to work
> properly. Without sub-device nodes it might not have been an issue with
> certain master drivers.
>
> Could you add that in v2, in a separate patch before this one, please?
Okay, I will do.
Thank you for your review.

>
>> ---
>>
>>   drivers/media/i2c/ov7670.c | 13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
>> index e88549f0e704..5c8460ee65c3 100644
>> --- a/drivers/media/i2c/ov7670.c
>> +++ b/drivers/media/i2c/ov7670.c
>> @@ -213,6 +213,7 @@ struct ov7670_devtype {
>>   struct ov7670_format_struct;  /* coming later */
>>   struct ov7670_info {
>>   	struct v4l2_subdev sd;
>> +	struct media_pad pad;
>>   	struct v4l2_ctrl_handler hdl;
>>   	struct {
>>   		/* gain cluster */
>> @@ -1688,14 +1689,23 @@ static int ov7670_probe(struct i2c_client *client,
>>   	v4l2_ctrl_auto_cluster(2, &info->auto_exposure,
>>   			       V4L2_EXPOSURE_MANUAL, false);
>>   	v4l2_ctrl_cluster(2, &info->saturation);
>> +
>> +	info->pad.flags = MEDIA_PAD_FL_SOURCE;
>> +	info->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>> +	ret = media_entity_pads_init(&info->sd.entity, 1, &info->pad);
>> +	if (ret < 0)
>> +		goto hdl_free;
>> +
>>   	v4l2_ctrl_handler_setup(&info->hdl);
>>   
>>   	ret = v4l2_async_register_subdev(&info->sd);
>>   	if (ret < 0)
>> -		goto hdl_free;
>> +		goto entity_cleanup;
>>   
>>   	return 0;
>>   
>> +entity_cleanup:
>> +	media_entity_cleanup(&info->sd.entity);
>>   hdl_free:
>>   	v4l2_ctrl_handler_free(&info->hdl);
>>   clk_disable:
>> @@ -1712,6 +1722,7 @@ static int ov7670_remove(struct i2c_client *client)
>>   	v4l2_device_unregister_subdev(sd);
>>   	v4l2_ctrl_handler_free(&info->hdl);
>>   	clk_disable_unprepare(info->clk);
>> +	media_entity_cleanup(&info->sd.entity);
>>   	return 0;
>>   }
>>   
>> -- 
>> 2.13.0
>>
Best Regards,
Wenyou Yang
