Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:33702 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3ABVYq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 16:24:46 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so7025966eek.18
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 13:24:45 -0800 (PST)
Message-ID: <50E4A5B6.1090005@googlemail.com>
Date: Wed, 02 Jan 2013 22:25:10 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Sascha Sommer <saschasommer@freenet.de>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/5] em28xx: respect the message size constraints for
 i2c transfers
References: <1355682211-13604-1-git-send-email-fschaefer.oss@googlemail.com> <1355682211-13604-3-git-send-email-fschaefer.oss@googlemail.com> <20121222220746.64611c08@redhat.com> <20130102214512.5e73075c@madeira.sommer.dynalias.net>
In-Reply-To: <20130102214512.5e73075c@madeira.sommer.dynalias.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

Am 02.01.2013 21:45, schrieb Sascha Sommer:
> Hello,
>
> Am Sat, 22 Dec 2012 22:07:46 -0200
> schrieb Mauro Carvalho Chehab <mchehab@redhat.com>:
>
>> Em Sun, 16 Dec 2012 19:23:28 +0100
>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>
>>> The em2800 can transfer up to 4 bytes per i2c message.
>>> All other em25xx/em27xx/28xx chips can transfer at least 64 bytes
>>> per message.
>>>
>>> I2C adapters should never split messages transferred via the I2C
>>> subsystem into multiple message transfers, because the result will
>>> almost always NOT be the same as when the whole data is transferred
>>> to the I2C client in a single message.
>>> If the message size exceeds the capabilities of the I2C adapter,
>>> -EOPNOTSUPP should be returned.
>>>
>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>> ---
>>>  drivers/media/usb/em28xx/em28xx-i2c.c |   44
>>> ++++++++++++++------------------- 1 Datei geändert, 18 Zeilen
>>> hinzugefügt(+), 26 Zeilen entfernt(-)
>>>
>>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c
>>> b/drivers/media/usb/em28xx/em28xx-i2c.c index 44533e4..c508c12
>>> 100644 --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>>> @@ -50,14 +50,18 @@ do
>>> {							\ } while
>>> (0) 
>>>  /*
>>> - * em2800_i2c_send_max4()
>>> - * send up to 4 bytes to the i2c device
>>> + * em2800_i2c_send_bytes()
>>> + * send up to 4 bytes to the em2800 i2c device
>>>   */
>>> -static int em2800_i2c_send_max4(struct em28xx *dev, u8 addr, u8
>>> *buf, u16 len) +static int em2800_i2c_send_bytes(struct em28xx
>>> *dev, u8 addr, u8 *buf, u16 len) {
>>>  	int ret;
>>>  	int write_timeout;
>>>  	u8 b2[6];
>>> +
>>> +	if (len < 1 || len > 4)
>>> +		return -EOPNOTSUPP;
>>> +
>> Except if you actually tested it with all em2800 devices, I think that
>> this change just broke it for em2800.
>>
>> Maybe Sascha could review this patch series on his em2800 devices.
>>
>> Those devices are limited, and just like other devices (cx231xx for
>> example), the I2C bus need to split long messages, otherwise the I2C
>> devices will fail.
>>
> The only device that I own is the Terratec Cinergy 200 USB.
> Unfortunately I left it in my parents house so I won't be able to
> test the patch within the next two weeks. I don't know if any of the
> other devices ever transfered more than 4 bytes but as far as I
> remember the windows driver of the cinergy 200 usb did not do this.
> The traces obtained from it were the only information I had during
> development. On first sight, the splitting code looks wrong.

Thanks for your reply !
I have a Terratec Cinergy 200 USB, too, and I used this device for
testing the code.
You are right, the Windows driver never transfers more than 4 bytes
(verified with USB-logs).
Do you know if there is something like a control flag for non-stopping
i2c transfers ?

Maybe you also noticed the following tread:
http://www.spinics.net/lists/linux-media/msg57442.html

Do you remember any details about your device ?
One thing not mentioned in this tread is, that there seem to be multiple
chip IDs for the EM2800.
The em28xx only knows about ID=7 and I assume that's what you device
uses. But the chip in my device uses ID=4...

Regards,
Frank

> Regards
>
> Sascha
>
>

