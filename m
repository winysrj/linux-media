Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:43051 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab3DWQ5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 12:57:03 -0400
Received: by mail-ea0-f181.google.com with SMTP id a11so369131eae.40
        for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 09:57:01 -0700 (PDT)
Message-ID: <5176BDA8.6090602@googlemail.com>
Date: Tue, 23 Apr 2013 18:58:16 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] em28xx: give up GPIO register tracking/caching
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com> <1365846521-3127-2-git-send-email-fschaefer.oss@googlemail.com> <20130413114144.097a21a1@redhat.com> <51697AC8.1050807@googlemail.com> <20130413140444.2fba3e88@redhat.com> <516999EC.6080605@googlemail.com> <20130413150823.6e962285@redhat.com> <516B12F9.4040609@googlemail.com> <20130415095130.78a5ecd9@redhat.com> <516C2A50.3080409@googlemail.com> <20130415200127.3467a003@redhat.com>
In-Reply-To: <20130415200127.3467a003@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

...
>>>
>>>> Am 13.04.2013 20:08, schrieb Mauro Carvalho Chehab:
>>>>> Writing is sane: GPIO input lines requires writing as well, in order to 
>>>>> set it to either pull-up or pull-down mode (not sure if em28xx supports
>>>>> both ways).
>>>>>
>>>>> So, the driver needs to know if it will write there a 0 or 1, and this is part
>>>>> of its GPIO configuration.
>>>>>
>>>>> Let's assume that, on a certain device, you need to write "1" to enable that
>>>>> input.
>>>>>
>>>>> A read I/O to that port can return either 0 or 1. 
>>>>>
>>>>> Giving an hypothetical example, please assume this code:
>>>>>
>>>>> static int write_gpio_bits(u32 out, u32 mask)
>>>>> {
>>>>> 	u32 gpio = (read_gpio_ports() & ~mask) | (out & mask);
>>>>> 	write_gpio_ports(gpio);
>>>>> }
>>>>>
>>>>>
>>>>> ...
>>>>> 	/* Use bit 1 as input GPIO */
>>>>> 	write_gpio_bits(1, 1);
>>>>>
>>>>> 	/* send a reset via bit 2 GPIO */
>>>>> 	write_gpio_bits(2, 2);
>>>>> 	write_gpio_bits(0, 2);
>>>>> 	write_gpio_bits(2, 2);
>>>>>
>>>>> If, at the time the above code runs, the input bit 1 is at "0" state,
>>>>> the subsequent calls will disable the input.
>>>>>
>>>>> If, instead, only the write operations are cached like:
>>>>>
>>>>> static int write_gpio_bits(u32 out, u32 mask)
>>>>> {
>>>>> 	static u32 shadow_cache;
>>>>>
>>>>> 	shadow_cache = (shadow_cache & ~mask) | (out & mask);
>>>>> 	write_gpio_ports(gpio);
>>>>> }
>>>>>
>>>>> there's no such risk, as it will keep using "1" for the input bit.
>>>> Hmm... ok, now I understand what you mean.
>>>> Are you sure the Empia chips are really working this way ?
>>> Yes. It uses a pretty standard GPIO mechanism at register 0x08.
>> Ok, will try to find out how those 0x80...0x87 GPIO registers are working.
> Ok.

Ok, I've made some tests and it seems you are right.
Registers 0x80...0x87 are working the same way.

Will have to think about all this for a while with a clear head before
coming up with a proper solution.

>>> I'm not so sure about the "GPO" register 0x04,
>> Well, we don't need caching for output lines, just for input lines.
> You understood me wrong: I mean that I'm not sure if register 0x04 is
> only for output pins, or if then can also be used for input.

Well, it's named GPO in contrast to reg 0x08 GPIO.
What the hell can we rely on ?

> In doubt, better to cache.
>
>>> but using a shadow for it as
>>> well won't hurt, and will reduce a little bit the USB bus traffic.
>> Sure, but the problem is that caching is getting complicated with the
>> newer devices.
>> The em2765 in the VAD Laplace webcam for example uses registers
>> 0x80/0x84, 0x81/0x85, 0x83/0x87 and also at least register 0x08 for
>> GPIO. I don't not about about reg 0x04.
>> And its seems some bits of reg 0x0C are used for GPIO, too (current
>> snapshot button support uses bit 6).
>> Have fun. :(
> If GPIOLIB solves it on a clean way, then we have a reason to move it.
> Otherwise, we'll need to cache all those registers, and reg 0x0C GPIO
> bits.

And what are the GPIO bits of register 0x0C_USBSUSP ? It seems to be a
mixed register.
Bit 5 is likely GPIO (used for snapshot button), I'm not sure about bit
4 (enabled/disabled on capturing start/stop).

What I hate most about register caching at the moment is, that we are
trying to do a complex thing without even knowing exactly which
registers/bits need to be handled (also depends on the chip variant). :(
It's a mess.

>>>> I checked the em25xx datasheet (excerpt) and it talks about separate
>>>> registers for GPIO configuration (unfortunately without explaining their
>>>> function in detail).
>>> Interesting. There are several old designs (bttv, saa7134,...) that uses
>>> a separate register for defining the input and the output pins.
>> IMHO separate registers are the better design.
> It is a safer design, but it is harder to reverse engineer them.
> See the wiki page that explains it on bt848:
> 	http://linuxtv.org/wiki/index.php/GPIO_pins
> Even experienced people sometimes do bad GPIO settings.

Maybe.

> Using just one register is a way easier.

I think this case proves the opposite. ;)

Regards,
Frank
>
>>>> I going to do some tests with the Laplace webcam, so far it seems to be
>>>> working fine without this caching stuff.
>>>> But the reverse-engineering possibilities are quite limited, so someone
>>>> with a detailed datasheet should really look this up.
>>> Well, that will affect only devices with input pins connected.
>>> If you test on a hardware without it, you won't notice any difference
>>> at all.
>> The Laplace webcam has three buttons assigned to regs 0x80/0x84 and
>> 0x81/0x85.
>> They are inverted (0=pressed, 1=unpressed), which could be the reason
>> why I didn't notice any problems without caching.
> It seems it uses a pull-up resistor on open-drain mode. That's the most
> common way to do GPIO.
>
>> I don't have any other devices with buttons for testing.
>>
>> Regards,
>> Frank
>>
>>> Cheers,
>>> Mauro

