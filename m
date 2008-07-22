Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+904052d24212f421a2b2+1794+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KLHCS-0004iq-Oj
	for linux-dvb@linuxtv.org; Tue, 22 Jul 2008 14:42:40 +0200
Date: Tue, 22 Jul 2008 08:42:35 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ricardo Carrillo Cruz <emaildericky@gmail.com>
In-Reply-To: <3271f22e0807220540n5c619f7ckabb0221add604084@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807220841200.24182@bombadil.infradead.org>
References: <d350e5180804290541q6455c0b3s63aafbbc17e424e2@mail.gmail.com>
	<48171AA0.2060203@linuxtv.org> <1216716678.7270.15.camel@localhost>
	<alpine.LFD.1.10.0807220823090.24182@bombadil.infradead.org>
	<3271f22e0807220540n5c619f7ckabb0221add604084@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hauppauge HVR 900H
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Thanks, Ricardo. For sure we'll need some testing after I fix the current 
issue.

Cheers,
Mauro

On Tue, 22 Jul 2008, Ricardo Carrillo Cruz wrote:

> I just wanted to give you thanks Mauro, your work is much appreciated
> on supporting HVR900H.
> If there's anything we mere users can do ( dunno, perhaps providing
> dumps, logs), please let me know.
>
> Cheers
>
> 2008/7/22 Mauro Carvalho Chehab <mchehab@infradead.org>:
>> Hi Eddi,
>>
>> I'm working on this driver. I have one HVR900H. Unfortunately, I've been
>> too busy those days, since I'm responsible for the entire subsystem
>> maintainership and I have a job that it is unrelated to V4L. So, I can
>> work on it only on my spare time.
>>
>> The HVR uses a tm6010 chip. The commands for this is slicely different
>> than the ones for tm6000. The driver has some support for it, but some
>> adjustments are needed.
>>
>> The firmware file is for xc3028XL variant.
>>
>> The current tree is broken (the urb decoding code is causing some OOPS
>> during IRQ, causing kernel panic). I'm debugging it.
>>
>> About i2c discover, don't trust on their results. The normal procedure for
>> detecting i2c devices doesn't seem to work with tm6000.
>>
>> Cheers,
>> Mauro
>>
>>
>> On Tue, 22 Jul 2008, Eddi De Pieri wrote:
>>
>>> Hi Steven,
>>>
>>> Il giorno mar, 29/04/2008 alle 08.54 -0400, Steven Toth ha scritto:
>>>>> Before I sink many more hours into this, has any made any progress with
>>>>> this card or can point me in the right direction ?
>>>>
>>>> Mauro (tm6000 maintainer) already has one of these units, and I thought
>>>> he had it partially working (I could be wrong).
>>>>
>>>> He's certainly the right person to discuss the firmware tool with.
>>>
>>> Hi Steven,
>>>
>>> I bought HVR-900 since i know it has good linux support.
>>> When I opened the box I discovered it was the HVR-900H.
>>> (I was stupid since on the bow hauppauge wrote HVR-900-HD)
>>>
>>> Since I don't see any progress about this card I tried to make it
>>> working under linux.
>>>
>>> I removed the card plastic cover, ant i seen the TM6xxx chip (but a
>>> sticker deny me to read the full chipset model).
>>>
>>> Since the demodulator and the tuner is under an heatsink soldered to the
>>> PCB I can't get confirmation about the model of the chips.
>>>
>>> I tried compiling tm6010 mercurial but it refuse to load xc3028 firmware
>>> extracted from HVR-1200 driver.
>>>
>>> After some i2cdiscover/i2cdump over the whale i2c address I found:
>>> 80 0x50 ok  a0 >>1  eeprom
>>> 82 0x52     a4 >>1  ??
>>> 87 0x57     ae >>1  ??
>>> 97 0x61 ok  c2 >>1  tuner
>>>
>>> So I suspect that demodulator and infrared are on 0x52 and 0x57 i2c
>>> address, but that address in quite uncommon and never used in any other
>>> card.
>>>
>>> Can you give some additional information about the chip used in this usb
>>> stick (without desoldering)?
>>>
>>> Regards,
>>> Eddi
>>>
>>>
>>
>> --
>> Cheers,
>> Mauro Carvalho Chehab
>> http://linuxtv.org
>> mchehab@infradead.org
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
