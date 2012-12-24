Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:50578 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2LXLQZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 06:16:25 -0500
Received: by mail-bk0-f41.google.com with SMTP id jg9so3307082bkc.28
        for <linux-media@vger.kernel.org>; Mon, 24 Dec 2012 03:16:24 -0800 (PST)
Message-ID: <50D837EE.6040207@googlemail.com>
Date: Mon, 24 Dec 2012 12:09:34 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: saschasommer@freenet.de,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] em28xx: respect the message size constraints for
 i2c transfers
References: <1355682211-13604-1-git-send-email-fschaefer.oss@googlemail.com> <1355682211-13604-3-git-send-email-fschaefer.oss@googlemail.com> <20121222220746.64611c08@redhat.com> <50D70DF4.2000408@googlemail.com> <20121223124624.0122504c@redhat.com>
In-Reply-To: <20121223124624.0122504c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.12.2012 15:46, schrieb Mauro Carvalho Chehab:
> Em Sun, 23 Dec 2012 14:58:12 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 23.12.2012 01:07, schrieb Mauro Carvalho Chehab:
>>> Em Sun, 16 Dec 2012 19:23:28 +0100
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>> The em2800 can transfer up to 4 bytes per i2c message.
>>>> All other em25xx/em27xx/28xx chips can transfer at least 64 bytes per message.
>>>>
>>>> I2C adapters should never split messages transferred via the I2C subsystem
>>>> into multiple message transfers, because the result will almost always NOT be
>>>> the same as when the whole data is transferred to the I2C client in a single
>>>> message.
>>>> If the message size exceeds the capabilities of the I2C adapter, -EOPNOTSUPP
>>>> should be returned.
>>>>
>>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>>> ---
>>>>  drivers/media/usb/em28xx/em28xx-i2c.c |   44 ++++++++++++++-------------------
>>>>  1 Datei geändert, 18 Zeilen hinzugefügt(+), 26 Zeilen entfernt(-)
>>>>
>>>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
>>>> index 44533e4..c508c12 100644
>>>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>>>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>>>> @@ -50,14 +50,18 @@ do {							\
>>>>  } while (0)
>>>>  
>>>>  /*
>>>> - * em2800_i2c_send_max4()
>>>> - * send up to 4 bytes to the i2c device
>>>> + * em2800_i2c_send_bytes()
>>>> + * send up to 4 bytes to the em2800 i2c device
>>>>   */
>>>> -static int em2800_i2c_send_max4(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>>>> +static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>>>>  {
>>>>  	int ret;
>>>>  	int write_timeout;
>>>>  	u8 b2[6];
>>>> +
>>>> +	if (len < 1 || len > 4)
>>>> +		return -EOPNOTSUPP;
>>>> +
>>> Except if you actually tested it with all em2800 devices, I think that
>>> this change just broke it for em2800.
>> Yes, I have tested it. ;)
>> But it should be obvious that splitting messages doesn't work, because
>> the first byte of each message is treated as register address:
>>
>> Let's say we want to transfer the 8 bytes 11 22 33 44 55 66 77 88 to
>> registers A0-A7 of a client.
>> The correspondig i2c message transferred via the i2c subsystem is A0 11
>> 22 33 44 55 66 77 88
>> The current in em28xx splits this message into 3 messages:
>>
>> message 1: A0 11 22 33
>> message 2: 44 55 66 77
>> message 3: 88
>>
>> The result is, that only the first 3 bytes are transferred correctly.
>> The data bytes 44 and 88 are interpreted as register index and get lost,
>> data bytes 55 66 77 end up in registers 0x44, 0x45 and 0x46 instead of
>> 0xA4 to 0xA6.
>> Ouch !
> I see your point, but there are devices that allow sending a message
> splitted into smaller URB data and do the right thing when the I2C
> transfer actually happen. The cx231xx is one of such devices: it has
> 4 I2C buses internally; a few of them have a limit of 4 bytes per
> transfer. Even so, manufacturers use this limited buses, plugging
> I2C devices there that require I2C transfers with more than 4 bytes.
>
> One of the tricks used on such devices to write long messages is
> to disable I2C stop on the first I2C block, and to disable I2C
> start+address data on the next messages. Only the I2C bus can do
> such things, and such logic avoids to push down to all I2C clients
> a complex logic to split messages there.

Yes, if the i2c adapter supports this feature, there is no problem with
splitting messages.

> I'm not sure if this is the case of em2800 though, as I don't have
> any device with it.

I'm not aware of a possibility to do this with the em2800.

> In any case, before dropping it, we should be sure that this won't
> break any supported device. Probably the worse case are the TV-based
> em2800 boards, with tuners, as they may need to transfer more than 4
> bytes via I2C.

I agree.

We currently have 6 boards with the em2800. Used i2c clients are

TDA9887
SAA711X
TUNER_PHILIPS_FCV1236D
TUNER_LG_PAL_NEW_TAPC
TUNER_LG_TALN
and in case of the Terratec Cinergy 200 USB an external IR receiver IC

None of these clients tries to transfer more than 4 bytes at once.
Terratec Cinergy 200 USB has also been tested by me.

Anyway, even if one of those client drivers would writes more than 4
bytes at once to the device, it wouldn't work with the current code.

>>> Maybe Sascha could review this patch series on his em2800 devices.
>> Comments / reviews are appreciated.
> Let's give him some time to review, before merging it.

Sure.

>>> Those devices are limited, and just like other devices (cx231xx for example),
>>> the I2C bus need to split long messages, otherwise the I2C devices will
>>> fail.
>> I2C adapters are supposed to fail with -EOPNOTSUPP if the message length
>> exceeds their capabilities.
>> Drivers must be able to handle this error, otherwise they have to be fixed.
> Currently, afaikt, no V4L2 I2C client knows how to handle it.

Maybe. Fortunately, it seems to cause no trouble.

>  Ok, returning
> -EOPNOTSUPP if the I2C data came from userspace makes sense.
>
>>> Btw, there was already a long discussion with regards to splitting long
>>> I2C messages at the I2C bus or at the I2C adapters. The decision was
>>> to do it at the I2C bus logic, as it is simpler than making a code
>>> at each I2C client for them to properly handle -EOPNOTSUPP and implement
>>> a fallback logic to reduce the transfer window until reach what's
>>> supported by the device.
>> While letting the i2c bus layer split messages sounds like the right
>> thing to do, it is hard to realize that in practice.
>> The reason is, that the needed algorithm depends on the capabilities and
>> behavior of the i2c adapter _and_ the connected i2c client.
>> The three main parameters are:
>> - message size limits
>> - client register width
>> - automatic register index incrementation
>>
>> I don't know what has been discussed in past,
> You'll need to dig into the ML archives. This is a recurrent theme, and,
> we have implementations doing I2C split at bus (most cases) and a few
> ones doing it at the client side.

Yeah, I also have a working implementation of i2c block read/write
emulation in my experimental code. ;)

>> but I talked to Jean
>> Delvare about the message size constraints a few weeks ago.
>> He told me that it doesn't make sense to try to handle this at the i2c
>> subsystem level. The parameters can be different for reading and
>> writing, adapter and client and things are getting complicated quickly.
> Jean's opinion is to push it to I2C clients (and we actually do it on a
> few cases), but as I explained before, there are several drivers where
> this is better done at the I2C bus driver, as the I2C implementation 
> allows doing it easily at bus level by playing with I2C STOP bits/I2C 
> start bits.
>
> We simply have too much I2C clients, and -EOPNOTSUPP error code doesn't
> tell the max size of the I2C messages. Adding a complex split logic
> for every driver is not a common practice, as just a few I2C bus bridge
> drivers suffer from very strict limits.

Yes, and even with those who have such a strict limit, it is usually not
exceeded because the clients are too 'simple'. ;)

> Also, clients that split I2C messages don't actually handle -EOPNOTSUPP.
> Instead, they have an init parameter telling the maximum size of the
> I2C messages accepted by the bus.
>
> The logic there is complex, and may require an additional logic at the
> bus side, in order to warrant that no I2C stop/start bits will be sent
> in the middle of a message, or otherwise the device will fail[1].
>
> So, it is generally simpler and more effective to just do it at the bus
> side.

Maybe. I have no opinion yet.
My feeling is, that this should be handled by the i2c subsystem as much
as possible, but
a) it's complex due to the described reasons
b) I have no complete concept yet
c) the i2c people seem to be not very interested
d) there is lots of other stuff with a higher priority on my TODO list


The reason why I started looking into this is, that the em2765 in the
SpeedLink VAD Laplace webcam (and likely all similar chip variants, e.g.
em2760, em277x, em25xx) can transfer only 1 byte per message to/from the
sensor client when using the 2nd i2c bus. I don't know where this
restriction comes from, possible explanations are:
- because that the 2nd bus is realized using GPIO pins
- because the OV2640 uses SCCB
Sensor probing for example includes reading 16 bit VID and VID from the
client, which means that we require 2 instead of 1 i2c transfers.
Sure, for this special case we could live with it, especially because
the OV2640 driver uses single byte transfers only...

But that's a separate issue, we can talk about later in a different tread.

This patch just removes some code which is currently not working (and
appearantly not needed).
So I think it should be applied.

Regards,
Frank

> [1] not all I2C client drivers have an address sub-address. Also, several
> of them require a long I2C message to be handled at once, otherwise the
> device fails.
>
> Regards,
> Mauro






