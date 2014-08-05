Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4898 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaHEOTJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 10:19:09 -0400
Message-ID: <53E0E7C4.8080205@xs4all.nl>
Date: Tue, 05 Aug 2014 16:18:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shuah Khan <shuahkhan@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH] em28xx: fix compiler warnings
References: <53E080F6.30301@xs4all.nl> <CAKocOONtJJmnAELZzVG_4KdgrXrMrwXVGW=quh=vDqa+pm1tbQ@mail.gmail.com>
In-Reply-To: <CAKocOONtJJmnAELZzVG_4KdgrXrMrwXVGW=quh=vDqa+pm1tbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2014 03:57 PM, Shuah Khan wrote:
> On Tue, Aug 5, 2014 at 1:00 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Fix three compiler warnings:
>>
>> drivers/media/usb/em28xx/em28xx-input.c: In function ‘em28xx_i2c_ir_handle_key’:
>> drivers/media/usb/em28xx/em28xx-input.c:318:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>  }
>>  ^
>>   CC [M]  drivers/media/usb/em28xx/em28xx-dvb.o
>> drivers/media/usb/em28xx/em28xx-camera.c: In function ‘em28xx_probe_sensor_micron’:
>> drivers/media/usb/em28xx/em28xx-camera.c:199:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>  }
>>  ^
>> drivers/media/usb/em28xx/em28xx-camera.c: In function ‘em28xx_probe_sensor_omnivision’:
>> drivers/media/usb/em28xx/em28xx-camera.c:304:1: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>  }
>>  ^
>>
>> Note: there is no way the code in em28xx_i2c_ir_handle_key() is correct: it's
>> using an almost completely uninitialized i2c_client struct with random flags,
>> dev and name fields. Can't this turned into a proper i2c_client struct in
>> struct em28xx? At least with this patch it's no longer random data.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
> 
>> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
>> index ed843bd..07069b6 100644
>> --- a/drivers/media/usb/em28xx/em28xx-input.c
>> +++ b/drivers/media/usb/em28xx/em28xx-input.c
>> @@ -298,12 +298,11 @@ static int em28xx_i2c_ir_handle_key(struct em28xx_IR *ir)
>>         static u32 scancode;
>>         enum rc_type protocol;
>>         int rc;
>> -       struct i2c_client client;
>>
>> -       client.adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
>> -       client.addr = ir->i2c_dev_addr;
>> +       dev->tmp_i2c_client.adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
>> +       dev->tmp_i2c_client.addr = ir->i2c_dev_addr;
>>
>> -       rc = ir->get_key_i2c(&client, &protocol, &scancode);
>> +       rc = ir->get_key_i2c(&dev->tmp_i2c_client, &protocol, &scancode);
>>         if (rc < 0) {
>>                 dprintk("ir->get_key_i2c() failed: %d\n", rc);
>>                 return rc;
>> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
>> index 84ef8ef..437ca08 100644
>> --- a/drivers/media/usb/em28xx/em28xx.h
>> +++ b/drivers/media/usb/em28xx/em28xx.h
>> @@ -630,6 +630,7 @@ struct em28xx {
>>         struct i2c_adapter i2c_adap[NUM_I2C_BUSES];
>>         struct i2c_client i2c_client[NUM_I2C_BUSES];
>>         struct em28xx_i2c_bus i2c_bus[NUM_I2C_BUSES];
>> +       struct i2c_client tmp_i2c_client;
> 
> Hans,
> 
> Is it necessary to add this temp variable to the structure? It is
> always assigned
> whenever it is used in this patch. It might make sense to make it
> local variable.

I'm not sure what you mean. It *was* a local variable, that was the problem.
There are two option: one is to add it to the main struct, then other is to
allocate and free it inside the function. In general I dislike that since it
adds aan extra check (did we really get the memory?) and you have to make sure
you will free the memory. And that's besides the overhead of having to allocate
memory. Originally I named tmp_i2c_client 'probe_i2c_client', but then I saw
that the ir code needs it as well. If the ir code is fixed so it has its own
i2c client, then the name can revert to probe_i2c_client.

Regards,

	Hans

> Somehow seeing a tmp field in the structure doesn't sound right and
> also since it
> maintains state being in the structure, it could be used with incorrect data.
> 
> -- Shuah
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

