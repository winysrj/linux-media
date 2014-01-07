Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64245 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaAGROc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 12:14:32 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so205206eek.39
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 09:14:31 -0800 (PST)
Message-ID: <52CC363A.7070202@googlemail.com>
Date: Tue, 07 Jan 2014 18:15:38 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 16/22] [media] em28xx: use a better value for I2C timeouts
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-17-git-send-email-m.chehab@samsung.com> <52C9C2C7.7020509@googlemail.com> <20140105185717.7a6bd8e3@samsung.com>
In-Reply-To: <20140105185717.7a6bd8e3@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.01.2014 21:57, schrieb Mauro Carvalho Chehab:
> Em Sun, 05 Jan 2014 21:38:31 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
>>> In the lack of a better spec, let's assume the timeout
>>> values compatible with SMBus spec:
>>> 	http://smbus.org/specs/smbus110.pdf
>>>
>>> at chapter 8 - Electrical Characteristics of SMBus devices
>>>
>>> Ok, SMBus is a subset of I2C, and not all devices will be
>>> following it, but the timeout value before this patch was not
>>> even following the spec.
>>>
>>> So, while we don't have a better guess for it, use 35 + 1
>>> ms as the timeout.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>>> ---
>>>  drivers/media/usb/em28xx/em28xx.h | 17 +++++++++++++++--
>>>  1 file changed, 15 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
>>> index db47c2236ca4..9af19332b0f1 100644
>>> --- a/drivers/media/usb/em28xx/em28xx.h
>>> +++ b/drivers/media/usb/em28xx/em28xx.h
>>> @@ -183,8 +183,21 @@
>>>  
>>>  #define EM28XX_INTERLACED_DEFAULT 1
>>>  
>>> -/* time in msecs to wait for i2c xfers to finish */
>>> -#define EM2800_I2C_XFER_TIMEOUT		20
>>> +/*
>>> + * Time in msecs to wait for i2c xfers to finish.
>>> + * 35ms is the maximum time a SMBUS device could wait when
>>> + * clock stretching is used. As the transfer itself will take
>>> + * some time to happen, set it to 35 ms.
>>> + *
>>> + * Ok, I2C doesn't specify any limit. So, eventually, we may need
>>> + * to increase this timeout.
>>> + *
>>> + * FIXME: this assumes that an I2C message is not longer than 1ms.
>>> + * This is actually dependent on the I2C bus speed, although most
>>> + * devices use a 100kHz clock. So, this assumtion is true most of
>>> + * the time.
>>> + */
>>> +#define EM2800_I2C_XFER_TIMEOUT		36
>>>  
>>>  /* time in msecs to wait for AC97 xfers to finish */
>>>  #define EM2800_AC97_XFER_TIMEOUT	100
>> Mauro...
>> What exactly are you fixing with this patch ?
> It fixes some of the timeouts I noticed here with HVR-950.
>
>> Which devices are not working with the current timeout value ?
>>
>> You really shouldn't increase the timout to 172% for all devices based
>> on such a fragile pure theory.
> It is not fragile. It is the SMBUS spec. It should _at_least_ wait up to
> the timeout specified there.
>
> Btw, it is not increasing the timeout. It is actually reducing it.
>
> See, this is the code before the patch:
>
> for (read_timeout = EM2800_I2C_XFER_TIMEOUT; read_timeout > 0;
> 	     read_timeout -= 5) {
> 		ret = dev->em28xx_read_reg(dev, 0x05);
> 		if (ret == 0x84 + len - 1) {
> 			break;
> 		} else if (ret == 0x94 + len - 1) {
> 			return -ENODEV;
> 		} else if (ret < 0) {
> 			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> 				    ret);
> 			return ret;
> 		}
> 		msleep(5);
> 	}
>
> msleep(5) actually sleeps up to 20 ms, as the minimal time is the
> schedule() time - being 10 ms a typical value (CONFIG_HZ equal to 100). 
>
> So, the current code has a timeout of up to 100 ms.
20ms / 5ms = 4.
4 * 10ms = 40ms ?

> This patch is actually reducing from 100 ms to 36 ms.
Ok, it's the same as with AC97 reads/writes.
I would accept any value from 20ms to 40ms.

> Regards,
> Mauro

