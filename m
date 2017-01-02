Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:38234 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751353AbdABNJz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 08:09:55 -0500
Subject: Re: [PATCH 02/15] ov7670: call v4l2_async_register_subdev
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
 <20161212155520.41375-3-hverkuil@xs4all.nl>
 <20161218220809.GV16630@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1863874d-034d-fe56-bc6c-b87edfdf09cf@xs4all.nl>
Date: Mon, 2 Jan 2017 14:09:48 +0100
MIME-Version: 1.0
In-Reply-To: <20161218220809.GV16630@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/16 23:08, Sakari Ailus wrote:
> On Mon, Dec 12, 2016 at 04:55:07PM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add v4l2-async support for this driver.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/i2c/ov7670.c | 21 +++++++++++++++------
>>  1 file changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
>> index b0315bb..3f0522f 100644
>> --- a/drivers/media/i2c/ov7670.c
>> +++ b/drivers/media/i2c/ov7670.c
>> @@ -1641,18 +1641,15 @@ static int ov7670_probe(struct i2c_client *client,
>>  	if (info->hdl.error) {
>>  		int err = info->hdl.error;
>>
>> -		v4l2_ctrl_handler_free(&info->hdl);
>> -		return err;
>> +		goto fail;
>>  	}
>>
>>  #if defined(CONFIG_MEDIA_CONTROLLER)
>>  	info->pad.flags = MEDIA_PAD_FL_SOURCE;
>>  	info->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>>  	ret = media_entity_pads_init(&info->sd.entity, 1, &info->pad);
>> -	if (ret < 0) {
>> -		v4l2_ctrl_handler_free(&info->hdl);
>> -		return ret;
>> -	}
>> +	if (ret < 0)
>> +		goto fail;
>>  #endif
>>  	/*
>>  	 * We have checked empirically that hw allows to read back the gain
>> @@ -1664,7 +1661,19 @@ static int ov7670_probe(struct i2c_client *client,
>>  	v4l2_ctrl_cluster(2, &info->saturation);
>>  	v4l2_ctrl_handler_setup(&info->hdl);
>>
>> +	ret = v4l2_async_register_subdev(&info->sd);
>> +	if (ret < 0) {
>> +#if defined(CONFIG_MEDIA_CONTROLLER)
>> +		media_entity_cleanup(&info->sd.entity);
>
> I think it'd be cleaner if you added another label for this. Up to you.

That's better indeed. Added the label.

	Hans

>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
>> +#endif
>> +		goto fail;
>> +	}
>> +
>>  	return 0;
>> +
>> +fail:
>> +	v4l2_ctrl_handler_free(&info->hdl);
>> +	return ret;
>>  }
>>
>>
>

