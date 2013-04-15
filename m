Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60020 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab3DOQZr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 12:25:47 -0400
Received: by mail-ee0-f45.google.com with SMTP id c50so2286999eek.4
        for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 09:25:46 -0700 (PDT)
Message-ID: <516C2A50.3080409@googlemail.com>
Date: Mon, 15 Apr 2013 18:26:56 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] em28xx: give up GPIO register tracking/caching
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com> <1365846521-3127-2-git-send-email-fschaefer.oss@googlemail.com> <20130413114144.097a21a1@redhat.com> <51697AC8.1050807@googlemail.com> <20130413140444.2fba3e88@redhat.com> <516999EC.6080605@googlemail.com> <20130413150823.6e962285@redhat.com> <516B12F9.4040609@googlemail.com> <20130415095130.78a5ecd9@redhat.com>
In-Reply-To: <20130415095130.78a5ecd9@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 15.04.2013 14:51, schrieb Mauro Carvalho Chehab:
> Em Sun, 14 Apr 2013 22:35:05 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 13.04.2013 20:08, schrieb Mauro Carvalho Chehab:
>>> Em Sat, 13 Apr 2013 19:46:20 +0200
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>> Am 13.04.2013 19:04, schrieb Mauro Carvalho Chehab:
>>>>> Em Sat, 13 Apr 2013 17:33:28 +0200
>>>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>>>
>>>>>> Am 13.04.2013 16:41, schrieb Mauro Carvalho Chehab:
>>>>>>> Em Sat, 13 Apr 2013 11:48:39 +0200
>>>>>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>>>>>
>>>>>>>> The GPIO register tracking/caching code is partially broken, because newer
>>>>>>>> devices provide more than one GPIO register and some of them are even using
>>>>>>>> separate registers for read and write access.
>>>>>>>> Making it work would be too complicated.
>>>>>>>> It is also used nowhere and doesn't make sense in cases where input lines are
>>>>>>>> connected to buttons etc.
>>>>>>>>
>>>>>>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>>>>>>> ---
>>>>>>>>  drivers/media/usb/em28xx/em28xx-cards.c |   12 ------------
>>>>>>>>  drivers/media/usb/em28xx/em28xx-core.c  |   27 ++-------------------------
>>>>>>>>  drivers/media/usb/em28xx/em28xx.h       |    6 ------
>>>>>>>>  3 Dateien geändert, 2 Zeilen hinzugefügt(+), 43 Zeilen entfernt(-)
>>>>>>> ...
>>>>>>>
>>>>>>>
>>>>>>>> @@ -231,14 +215,7 @@ int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
>>>>>>>>  	int oldval;
>>>>>>>>  	u8 newval;
>>>>>>>>  
>>>>>>>> -	/* Uses cache for gpo/gpio registers */
>>>>>>>> -	if (reg == dev->reg_gpo_num)
>>>>>>>> -		oldval = dev->reg_gpo;
>>>>>>>> -	else if (reg == dev->reg_gpio_num)
>>>>>>>> -		oldval = dev->reg_gpio;
>>>>>>>> -	else
>>>>>>>> -		oldval = em28xx_read_reg(dev, reg);
>>>>>>>> -
>>>>>>>> +	oldval = em28xx_read_reg(dev, reg);
>>>>>>>>  	if (oldval < 0)
>>>>>>>>  		return oldval;
>>>>>>> That's plain wrong, as it will break GPIO input.
>>>>>>>
>>>>>>> With GPIO, you can write either 0 or 1 to a GPIO output port. So, your
>>>>>>> code works for output ports.
>>>>>>>
>>>>>>> However, an input port requires an specific value (either 1 or 0 depending
>>>>>>> on the GPIO circuitry). If the wrong value is written there, the input port
>>>>>>> will stop working.
>>>>>>>
>>>>>>> So, you can't simply read a value from a GPIO input and write it. You need
>>>>>>> to shadow the GPIO write values instead.
>>>>>> I don't understand what you mean.
>>>>>> Why can I not read the value of a GPIO input and write it ?
>>>>> Because, depending on the value you write, it can transform the input into an
>>>>> output port.
>>>> I don't get it.
>>>> We always write to the GPIO register. That's why these functions are
>>>> called em28xx_write_* ;)
>>>> Whether the write operation is sane or not (e.g. because it modifies the
>>>> bit corresponding to an input line) is not subject of these functions.
>>> Writing is sane: GPIO input lines requires writing as well, in order to 
>>> set it to either pull-up or pull-down mode (not sure if em28xx supports
>>> both ways).
>>>
>>> So, the driver needs to know if it will write there a 0 or 1, and this is part
>>> of its GPIO configuration.
>>>
>>> Let's assume that, on a certain device, you need to write "1" to enable that
>>> input.
>>>
>>> A read I/O to that port can return either 0 or 1. 
>>>
>>> Giving an hypothetical example, please assume this code:
>>>
>>> static int write_gpio_bits(u32 out, u32 mask)
>>> {
>>> 	u32 gpio = (read_gpio_ports() & ~mask) | (out & mask);
>>> 	write_gpio_ports(gpio);
>>> }
>>>
>>>
>>> ...
>>> 	/* Use bit 1 as input GPIO */
>>> 	write_gpio_bits(1, 1);
>>>
>>> 	/* send a reset via bit 2 GPIO */
>>> 	write_gpio_bits(2, 2);
>>> 	write_gpio_bits(0, 2);
>>> 	write_gpio_bits(2, 2);
>>>
>>> If, at the time the above code runs, the input bit 1 is at "0" state,
>>> the subsequent calls will disable the input.
>>>
>>> If, instead, only the write operations are cached like:
>>>
>>> static int write_gpio_bits(u32 out, u32 mask)
>>> {
>>> 	static u32 shadow_cache;
>>>
>>> 	shadow_cache = (shadow_cache & ~mask) | (out & mask);
>>> 	write_gpio_ports(gpio);
>>> }
>>>
>>> there's no such risk, as it will keep using "1" for the input bit.
>> Hmm... ok, now I understand what you mean.
>> Are you sure the Empia chips are really working this way ?
> Yes. It uses a pretty standard GPIO mechanism at register 0x08.

Ok, will try to find out how those 0x80...0x87 GPIO registers are working.

> I'm not so sure about the "GPO" register 0x04,

Well, we don't need caching for output lines, just for input lines.

> but using a shadow for it as
> well won't hurt, and will reduce a little bit the USB bus traffic.

Sure, but the problem is that caching is getting complicated with the
newer devices.
The em2765 in the VAD Laplace webcam for example uses registers
0x80/0x84, 0x81/0x85, 0x83/0x87 and also at least register 0x08 for
GPIO. I don't not about about reg 0x04.
And its seems some bits of reg 0x0C are used for GPIO, too (current
snapshot button support uses bit 6).
Have fun. :(

>> I checked the em25xx datasheet (excerpt) and it talks about separate
>> registers for GPIO configuration (unfortunately without explaining their
>> function in detail).
> Interesting. There are several old designs (bttv, saa7134,...) that uses
> a separate register for defining the input and the output pins.

IMHO separate registers are the better design.

>
>> I going to do some tests with the Laplace webcam, so far it seems to be
>> working fine without this caching stuff.
>> But the reverse-engineering possibilities are quite limited, so someone
>> with a detailed datasheet should really look this up.
> Well, that will affect only devices with input pins connected.
> If you test on a hardware without it, you won't notice any difference
> at all.

The Laplace webcam has three buttons assigned to regs 0x80/0x84 and
0x81/0x85.
They are inverted (0=pressed, 1=unpressed), which could be the reason
why I didn't notice any problems without caching.
I don't have any other devices with buttons for testing.

Regards,
Frank

> Cheers,
> Mauro

