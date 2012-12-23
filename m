Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:41942 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LWN5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Dec 2012 08:57:55 -0500
Received: by mail-ea0-f180.google.com with SMTP id f13so2537480eai.39
        for <linux-media@vger.kernel.org>; Sun, 23 Dec 2012 05:57:53 -0800 (PST)
Message-ID: <50D70DF4.2000408@googlemail.com>
Date: Sun, 23 Dec 2012 14:58:12 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] em28xx: respect the message size constraints for
 i2c transfers
References: <1355682211-13604-1-git-send-email-fschaefer.oss@googlemail.com> <1355682211-13604-3-git-send-email-fschaefer.oss@googlemail.com> <20121222220746.64611c08@redhat.com>
In-Reply-To: <20121222220746.64611c08@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.12.2012 01:07, schrieb Mauro Carvalho Chehab:
> Em Sun, 16 Dec 2012 19:23:28 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> The em2800 can transfer up to 4 bytes per i2c message.
>> All other em25xx/em27xx/28xx chips can transfer at least 64 bytes per message.
>>
>> I2C adapters should never split messages transferred via the I2C subsystem
>> into multiple message transfers, because the result will almost always NOT be
>> the same as when the whole data is transferred to the I2C client in a single
>> message.
>> If the message size exceeds the capabilities of the I2C adapter, -EOPNOTSUPP
>> should be returned.
>>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-i2c.c |   44 ++++++++++++++-------------------
>>  1 Datei geändert, 18 Zeilen hinzugefügt(+), 26 Zeilen entfernt(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
>> index 44533e4..c508c12 100644
>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>> @@ -50,14 +50,18 @@ do {							\
>>  } while (0)
>>  
>>  /*
>> - * em2800_i2c_send_max4()
>> - * send up to 4 bytes to the i2c device
>> + * em2800_i2c_send_bytes()
>> + * send up to 4 bytes to the em2800 i2c device
>>   */
>> -static int em2800_i2c_send_max4(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>> +static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>>  {
>>  	int ret;
>>  	int write_timeout;
>>  	u8 b2[6];
>> +
>> +	if (len < 1 || len > 4)
>> +		return -EOPNOTSUPP;
>> +
> Except if you actually tested it with all em2800 devices, I think that
> this change just broke it for em2800.

Yes, I have tested it. ;)
But it should be obvious that splitting messages doesn't work, because
the first byte of each message is treated as register address:

Let's say we want to transfer the 8 bytes 11 22 33 44 55 66 77 88 to
registers A0-A7 of a client.
The correspondig i2c message transferred via the i2c subsystem is A0 11
22 33 44 55 66 77 88
The current in em28xx splits this message into 3 messages:

message 1: A0 11 22 33
message 2: 44 55 66 77
message 3: 88

The result is, that only the first 3 bytes are transferred correctly.
The data bytes 44 and 88 are interpreted as register index and get lost,
data bytes 55 66 77 end up in registers 0x44, 0x45 and 0x46 instead of
0xA4 to 0xA6.
Ouch !

> Maybe Sascha could review this patch series on his em2800 devices.

Comments / reviews are appreciated.

> Those devices are limited, and just like other devices (cx231xx for example),
> the I2C bus need to split long messages, otherwise the I2C devices will
> fail.

I2C adapters are supposed to fail with -EOPNOTSUPP if the message length
exceeds their capabilities.
Drivers must be able to handle this error, otherwise they have to be fixed.

> Btw, there was already a long discussion with regards to splitting long
> I2C messages at the I2C bus or at the I2C adapters. The decision was
> to do it at the I2C bus logic, as it is simpler than making a code
> at each I2C client for them to properly handle -EOPNOTSUPP and implement
> a fallback logic to reduce the transfer window until reach what's
> supported by the device.

While letting the i2c bus layer split messages sounds like the right
thing to do, it is hard to realize that in practice.
The reason is, that the needed algorithm depends on the capabilities and
behavior of the i2c adapter _and_ the connected i2c client.
The three main parameters are:
- message size limits
- client register width
- automatic register index incrementation

I don't know what has been discussed in past, but I talked to Jean
Delvare about the message size constraints a few weeks ago.
He told me that it doesn't make sense to try to handle this at the i2c
subsystem level. The parameters can be different for reading and
writing, adapter and client and things are getting complicated quickly.

Regards,
Frank

> So, for now, I won't apply this patch series (except for patch 1, with
> is obviously correct).
>
> Cheers,
> Mauro


