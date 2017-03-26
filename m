Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34991 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbdCZOYR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 10:24:17 -0400
Received: by mail-wr0-f193.google.com with SMTP id p52so2551636wrc.2
        for <linux-media@vger.kernel.org>; Sun, 26 Mar 2017 07:24:16 -0700 (PDT)
Subject: Re: [PATCH 2/2] em28xx: simplify ID-reading from Micron sensors
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20170219182918.4978-1-fschaefer.oss@googlemail.com>
 <20170219182918.4978-2-fschaefer.oss@googlemail.com>
 <20170322114606.1feeb960@vento.lan>
 <5107179d-74fd-3b98-5fc6-ba7051927ae2@googlemail.com>
 <20170323095612.72216892@vento.lan>
 <84459d79-eccc-1888-1dad-6935cf85b18a@googlemail.com>
 <20170324161616.74e5dbc7@vento.lan>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org, arnd@arndb.de
From: =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>
Message-ID: <2f06c7bb-1951-fdce-8890-470be73c15ff@googlemail.com>
Date: Sun, 26 Mar 2017 16:24:17 +0200
MIME-Version: 1.0
In-Reply-To: <20170324161616.74e5dbc7@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 24.03.2017 um 20:16 schrieb Mauro Carvalho Chehab:
> Em Thu, 23 Mar 2017 19:03:20 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 23.03.2017 um 13:56 schrieb Mauro Carvalho Chehab:
>>> Em Thu, 23 Mar 2017 13:01:32 +0100
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>   
>>>> Am 22.03.2017 um 15:46 schrieb Mauro Carvalho Chehab:
>>>>> Em Sun, 19 Feb 2017 19:29:18 +0100
>>>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>>>      
>>>>>> Use i2c_smbus_read_word_data() instead of i2c_master_send() and
>>>>>> i2c_master_recv() for reading the ID of Micorn sensors.
>>>>>> Bytes need to be swapped afterwards, because i2c_smbus_read_word_data()
>>>>>> assumes that the received bytes are little-endian byte order (as specified
>>>>>> by smbus), while Micron sensors with 16 bit register width use big endian
>>>>>> byte order.
>>>>>>
>>>>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>>>>> ---
>>>>>>     drivers/media/usb/em28xx/em28xx-camera.c | 28 ++++------------------------
>>>>>>     1 file changed, 4 insertions(+), 24 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
>>>>>> index 7b4129ab1cf9..4839479624e7 100644
>>>>>> --- a/drivers/media/usb/em28xx/em28xx-camera.c
>>>>>> +++ b/drivers/media/usb/em28xx/em28xx-camera.c
>>>>>> @@ -106,8 +106,6 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
>>>>>>     {
>>>>>>     	int ret, i;
>>>>>>     	char *name;
>>>>>> -	u8 reg;
>>>>>> -	__be16 id_be;
>>>>>>     	u16 id;
>>>>>>     
>>>>>>     	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
>>>>>> @@ -115,10 +113,8 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
>>>>>>     	dev->em28xx_sensor = EM28XX_NOSENSOR;
>>>>>>     	for (i = 0; micron_sensor_addrs[i] != I2C_CLIENT_END; i++) {
>>>>>>     		client->addr = micron_sensor_addrs[i];
>>>>>> -		/* NOTE: i2c_smbus_read_word_data() doesn't work with BE data */
>>>>>>     		/* Read chip ID from register 0x00 */
>>>>>> -		reg = 0x00;
>>>>>> -		ret = i2c_master_send(client, &reg, 1);
>>>>>> +		ret = i2c_smbus_read_word_data(client, 0x00); /* assumes LE */
>>>>>>     		if (ret < 0) {
>>>>>>     			if (ret != -ENXIO)
>>>>>>     				dev_err(&dev->intf->dev,
>>>>>> @@ -126,24 +122,9 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
>>>>>>     				       client->addr << 1, ret);
>>>>>>     			continue;
>>>>>>     		}
>>>>>> -		ret = i2c_master_recv(client, (u8 *)&id_be, 2);
>>>>>> -		if (ret < 0) {
>>>>>> -			dev_err(&dev->intf->dev,
>>>>>> -				"couldn't read from i2c device 0x%02x: error %i\n",
>>>>>> -				client->addr << 1, ret);
>>>>>> -			continue;
>>>>>> -		}
>>>>>> -		id = be16_to_cpu(id_be);
>>>>>> +		id = swab16(ret); /* LE -> BE */
>>>>> That's wrong! You can't assume that CPU is BE, as some archs use LE.
>>>>>
>>>>> You should, instead, call le16_to_cpu(), to be sure that it will be
>>>>> doing the right thing.
>>>>>
>>>>> Something like:
>>>>>
>>>>> 	id = le16_to_cpu((__le16)ret);
>>>> SMBus read/write word transfers are always LE (see SMBus spec section
>>>> 6.5.5),
>>>> which is also what i2c_smbus_xfer_emulated() assumes:
>>>> http://lxr.free-electrons.com/source/drivers/i2c/i2c-core.c#L3485
>>> I got that part, but, if the CPU is also LE, doing swab16() is
>>> wrong. It should swap it *only* if the CPU is BE.
>> No, it should always be swapped, because the bytes are always transfered
>> in the wrong order.
>> The cpu endianess doesn't matter, (0x12 << 8) | 0x34 is always 0x1234.
> You still didn't get it.
>
> Let's assume that the ID is 0x148c (MT9M112).
>
> This value, represented in low endian, is stored in memory as:
>
> 	unsigned char __id[2] = { 0x8c, 0x14 };
>
> If we do:
> 	u16 ret = *(u16 *)__id;
>
> What's stored at "ret" will depend if the sistem is LE or BE:
>
> 	on LE, ret == 0x148c
> 	on BE, ret == 0x8c14
>
> If you do:
> 	u16 id = swapb16(val)
>
> you'll get:
>
> 	on LE, id == 0x8c14
> 	on BE, id == 0x148c
>
> So, the value will be *wrong* at LE.
>
> However, if you do:
> 	id = le16_to_cpu((__le16)ret);
>
> On LE, this will evaluate to id = ret, and on BE, to id = swab16(ret).
> So, on both, you'll have:
> 	id = 0x148c.

Can you please show me the code line(s) that make the value of the word 
returned by i2c_smbus_read_word_data() cpu endianess dependent ? :)

Cheers,
Frank

>
>
> Thanks,
> Mauro
