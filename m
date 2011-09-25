Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61145 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab1IYRa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 13:30:26 -0400
Received: by pzk1 with SMTP id 1so12539790pzk.1
        for <linux-media@vger.kernel.org>; Sun, 25 Sep 2011 10:30:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E7E25BC.5090709@skynet.fr>
References: <S1752295Ab1IWUja/20110923203930Z+74@vger.kernel.org>
	<4E7CF4DA.5020607@skynet.fr>
	<4E7D02DC.3010201@iki.fi>
	<4E7E25BC.5090709@skynet.fr>
Date: Sun, 25 Sep 2011 19:30:25 +0200
Message-ID: <CAL9G6WUH8GHN5pEo0kJYmAwKWJL377A+WTGBxjRJsiZaJpy7uA@mail.gmail.com>
Subject: Re: af9015/tda18218: Multiples (separates) usb devices errors/conflicts
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Jin Kazama <jin.ml@skynet.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/9/24 Jin Kazama <jin.ml@skynet.fr>:
> On 9/24/11 12:06 AM, Antti Palosaari wrote:
>>
>> On 09/24/2011 12:06 AM, Jin Kazama wrote:
>>>
>>> Hello,
>>> I've been testing af9015/tda18218 based usb DVB-T tuners on a 2.6.39.4
>>> kernel with the latest v4l drivers avaiable (from git).
>>> When I'm using a single USB module, (listed as /dev/dvb/adapter0),
>>> everything works fine.
>>> When I'm plugging another module, at first it looks like everything's ok
>>> (/dev/dvb/adapter1) and if I try to use this module while the adapter0
>>> is not been used, it works - but if try to use both modules at the same
>>> time, I get garbage output on both cards (error: warning: discontinuity
>>> for PID... with dvblast on both cards.
>>> Does anyone have any idea on how to fix this problem?
>>
>> Feel free to fix it. I am too busy currently.
>>
> Well, it looks like if I put 2 devices on different USB buses (on the same
> machine), they work fine, but if they're on the same USB bus, I get the
> problem...
> I think the driver may get raw data from the USB bus - and the way it
> identifies the device is not the proper way (I have 2 exactly identical
> devices) => when both devices send data, the driver catches all the data
> from the bus, which is a corrupt mix of both streams...)
> Unfortunately, I don't think that I'm capable of fixing the problem by
> myself, I don't even know which part of the driver to look for... if someone
> can give me a hint, I might *try* to *attempt* to fix it :)...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hello, I have similar problem, I have a dual tuner and they don't work together:

# i2cdetect -l
i2c-0	smbus     	SMBus nForce2 adapter at 4d00   	SMBus adapter
i2c-1	i2c       	cx23885[0]                      	I2C adapter
i2c-2	i2c       	cx23885[0]                      	I2C adapter
i2c-3	i2c       	cx23885[0]                      	I2C adapter
i2c-4	i2c       	NVIDIA i2c adapter 0 at 3:00.0  	I2C adapter
i2c-5	i2c       	NVIDIA i2c adapter 2 at 3:00.0  	I2C adapter
i2c-6	i2c       	NVIDIA i2c adapter 3 at 3:00.0  	I2C adapter
i2c-7	i2c       	KWorld PlusTV Dual DVB-T Stick (DVB-T 399U)	I2C adapter
i2c-8	i2c       	KWorld PlusTV Dual DVB-T Stick (DVB-T 399U)	I2C adapter

I can not change the USB bus, because they are on the same physical
device.I have no idea how to fix it but I am ready to test all fixes.
I read some Antti posts on how to is designed the af9015 dual demod:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg36821.html
http://palosaari.fi/linux/v4l-dvb/controlling_tuner_af9015_dual_demod.txt

Is there any tool to check the i2c errors?

Thanks for all your work and best regards.

-- 
Josu Lazkano
