Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48592 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3DMSSF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 14:18:05 -0400
Received: by mail-ee0-f45.google.com with SMTP id c50so1647106eek.4
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 11:18:03 -0700 (PDT)
Message-ID: <5169A19F.6080407@googlemail.com>
Date: Sat, 13 Apr 2013 20:19:11 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] em28xx: give up GPIO register tracking/caching
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com> <1365846521-3127-2-git-send-email-fschaefer.oss@googlemail.com> <20130413114144.097a21a1@redhat.com> <51697AC8.1050807@googlemail.com> <20130413140444.2fba3e88@redhat.com> <516999EC.6080605@googlemail.com>
In-Reply-To: <516999EC.6080605@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.04.2013 19:46, schrieb Frank Schäfer:
> Am 13.04.2013 19:04, schrieb Mauro Carvalho Chehab:
>> Em Sat, 13 Apr 2013 17:33:28 +0200
>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>
>>> Am 13.04.2013 16:41, schrieb Mauro Carvalho Chehab:
>>>> Em Sat, 13 Apr 2013 11:48:39 +0200
>>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>>
>>>>> The GPIO register tracking/caching code is partially broken, because newer
>>>>> devices provide more than one GPIO register and some of them are even using
>>>>> separate registers for read and write access.
>>>>> Making it work would be too complicated.
>>>>> It is also used nowhere and doesn't make sense in cases where input lines are
>>>>> connected to buttons etc.
>>>>>
>>>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>>>> ---
>>>>>  drivers/media/usb/em28xx/em28xx-cards.c |   12 ------------
>>>>>  drivers/media/usb/em28xx/em28xx-core.c  |   27 ++-------------------------
>>>>>  drivers/media/usb/em28xx/em28xx.h       |    6 ------
>>>>>  3 Dateien geändert, 2 Zeilen hinzugefügt(+), 43 Zeilen entfernt(-)
>>>> ...
>>>>
>>>>
>>>>> @@ -231,14 +215,7 @@ int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
>>>>>  	int oldval;
>>>>>  	u8 newval;
>>>>>  
>>>>> -	/* Uses cache for gpo/gpio registers */
>>>>> -	if (reg == dev->reg_gpo_num)
>>>>> -		oldval = dev->reg_gpo;
>>>>> -	else if (reg == dev->reg_gpio_num)
>>>>> -		oldval = dev->reg_gpio;
>>>>> -	else
>>>>> -		oldval = em28xx_read_reg(dev, reg);
>>>>> -
>>>>> +	oldval = em28xx_read_reg(dev, reg);
>>>>>  	if (oldval < 0)
>>>>>  		return oldval;
>>>> That's plain wrong, as it will break GPIO input.
>>>>
>>>> With GPIO, you can write either 0 or 1 to a GPIO output port. So, your
>>>> code works for output ports.
>>>>
>>>> However, an input port requires an specific value (either 1 or 0 depending
>>>> on the GPIO circuitry). If the wrong value is written there, the input port
>>>> will stop working.
>>>>
>>>> So, you can't simply read a value from a GPIO input and write it. You need
>>>> to shadow the GPIO write values instead.
>>> I don't understand what you mean.
>>> Why can I not read the value of a GPIO input and write it ?
>> Because, depending on the value you write, it can transform the input into an
>> output port.
> I don't get it.
> We always write to the GPIO register. That's why these functions are
> called em28xx_write_* ;)
> Whether the write operation is sane or not (e.g. because it modifies the
> bit corresponding to an input line) is not subject of these functions.

Hmm... that's actually not true for em28xx_write_regs().
The current/old code never writes the value to GPIO registers, it just
saves it to the device struct.
IMHO, this is plain wrong and yet antoher reason for applying this patch. ;)
It just didn't cause any trouble (hopefully) because for the GPIO
registers em28xx_write_reg_bits() is usually used instead (which works
correctly).

After checking the whole GPIO stuff again, I noticed a different
potential problem:
Register 0x04 seems to be a pure GPO register, so it is possible that
reading the current value from this register doesn't work.
The note in em28xx_write_regs() implies that noone has ever tested if it
works correctly.
Anyway, the current code reads register 0x04, too, to get the initial
value for caching. ;)

Regards,
Frank

>
>
> Frank
>

