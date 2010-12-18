Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:41822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab0LRAZM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 19:25:12 -0500
Message-ID: <4D0BFF4B.3060001@redhat.com>
Date: Fri, 17 Dec 2010 22:24:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Stefan Ringel <stefan.ringel@arcor.de>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: tm6000 and IR
References: <4CAD5A78.3070803@redhat.com>	<20101008150301.2e3ceaff@glory.local>	<4CAF0602.6050002@redhat.com>	<20101012142856.2b4ee637@glory.local>	<4CB492D4.1000609@arcor.de>	<20101129174412.08f2001c@glory.local>	<4CF51C9E.6040600@arcor.de>	<20101201144704.43b58f2c@glory.local>	<4CF67AB9.6020006@arcor.de>	<20101202134128.615bbfa0@glory.local>	<4CF71CF6.7080603@redhat.com>	<20101206010934.55d07569@glory.local>	<4CFBF62D.7010301@arcor.de>	<20101206190230.2259d7ab@glory.local>	<4CFEA3D2.4050309@arcor.de>	<20101208125539.739e2ed2@glory.local>	<4CFFAD1E.7040004@arcor.de>	<20101214122325.5cdea67e@glory.local>	<4D079ADF.2000705@arcor.de>	<20101215164634.44846128@glory.local>	<4D08E43C.8080002@arcor.de>	<20101216183844.6258734e@glory.local>	<4D0A4883.20804@arcor.de>	<20101217104633.7c9d10d7@glory.local>	<4D0AF2A7.6080100@arcor.de> <20101217160854.16a1f754@glory.local>
In-Reply-To: <20101217160854.16a1f754@glory.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Dmitri/Stefan,

Em 17-12-2010 05:08, Dmitri Belimov escreveu:
> On Fri, 17 Dec 2010 06:18:31 +0100
> Stefan Ringel <stefan.ringel@arcor.de> wrote:
> 
>> Am 17.12.2010 02:46, schrieb Dmitri Belimov:
>>> Hi Stefan
>>>
>>>> Am 16.12.2010 10:38, schrieb Dmitri Belimov:
>>>>> Hi
>>>>>
>>>>>>> I think your mean is wrong. Our IR remotes send extended NEC it
>>>>>>> is 4 bytes. We removed inverted 4 byte and now we have 3 bytes
>>>>>>> from remotes. I think we must have full RCMAP with this 3 bytes
>>>>>>> from remotes. And use this remotes with some different IR
>>>>>>> recievers like some TV cards and LIRC-hardware and other. No
>>>>>>> need different RCMAP for the same remotes to different IR
>>>>>>> recievers like now.
>>>>>> Your change doesn't work with my terratec remote control !!
>>>>> I found what happens. Try my new patch.
>>>>>
>>>>> What about NEC. Original NEC send
>>>>> address (inverted address) key (inverted key)
>>>>> this is realy old standart now all remotes use extended NEC
>>>>> (adress high) (address low) key (inverted key)
>>>>> The trident 5600/6000/6010 use old protocol but didn't test
>>>>> inverted address byte.
>>>>>
>>>>> I think much better discover really address value and write it to
>>>>> keytable. For your remotes I add low address byte. This value is
>>>>> incorrent but usefull for tm6000. When you found correct value
>>>>> update keytable.
>>>>>
>>>> That is not acceptable. Have you forgotten what Mauro have written?
>>>> The Terratec rc map are use from other devices.
>>> NO
>>> The RC_MAP_NEC_TERRATEC_CINERGY_XS used only in tm6000 module.
>>> My patch didn't kill support any other devices.
>> That is not true.
> 
> I search "RC_MAP_NEC_TERRATEC_CINERGY_XS" on FULL linux kernel sources.
> And found this string in:
> include/media/rc-map.h
> drivers/staging//tm6000/tm6000-cards.c
> drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
> 
> No any other devices didn't use this keymap.
> 
>>>> The best are only the
>>>> received data without additional data. And I think the Trident chip
>>>> send only compatibly data (send all extended data like standard
>>>> data). The device decoded the protocols not the driver.
>>> You can't use this remotes with normal working IR receivers because
>>> this receivers returned FULL scancodes. Need add one more keytable.
>>>
>>> 1. With my variant we have one keytable of remote and some
>>> workaround in device drivers. And can switch keytable and remotes
>>> on the fly (of course when keytable has really value and device
>>> driver has workaround)
>>>
>>> 2. With your variant we have some keytables for one remote for
>>> different IR recevers. Can't use incompatible keytable with other
>>> IR recievers. It is black magic for understanding what remotes is
>>> working with this hardware.
>>>
>>> I think my variant much better.
>>>
>>> With my best regards, Dmitry.
>>>
>> I think your variant is bad.
> 
> Mauro we need your opinion about this question.

I'm c/c Jarod, as he has a similar issue with some NEC-based boards 
(Apple "variant").

I also have experienced some cases where the NEC protocol in-hardware
decoder can provide only part of the NEC "extended" range.

I don't have a clear opinion about this issue, but I think that putting
all our brains to think about that, we may have a solution for it.

Let me summarize the issues. Please complete/correct me if is there anything
else.

1) NEC original format is 16 bits. However, some variants use 24 bits for it
(it is called, currently, NEC extended). A few other manufacturers, like Apple,
defines NEC protocol with 32 bits, removing both address and command checksums.

2) NEC raw decoder is capable of decoding the entire NEC code, but it only
accepts 16 or 24 bits, returning the scan code as:

	scancode = address << 8 | command;

for 16 bits, and:

	scancode = address << 16 | not_address <<  8 | command;

for 24 bits. There were some proposals to extend it to something like:

	scancode = address << 24 | not_address << 16 | not_command << 8 | command;
	(or some other bit order)

Or just return the complete 32 bits even for the original NEC protocol. However,
changing it will break the existing userspace decoding tables.

Another way would be to store the length of the scancode, using it as well during
the scancode->keycode translation.

But no patches were merged yet.

3) Some hardware decoders can't return the complete NEC address. There are variants
that returns 8 bits, others that returns 16 bits, and others that return the complete
code.

For hardware that returns only 8 bits, we currently address the issue by using a 
scancode mask. When "scanmask" is set at the rc structs, the scancode->keycode
logic will consider only the bits that are in the mask.

4) Some hardware filters the NEC address, returning only the codes for
some specific vendors.

Despite all discussions, we didn't reach an agreement yet.

There are some points to consider whatever solution we do:

1) A keycode table should be able to work with a generic raw decoder. So, on all
drivers, the bit order and the number of bits for a given protocol should be the same;

2) we should avoid to cause regressions on the existing definitions.

That's said, suggestions to meet the needs are welcome.

Thanks,
Mauro
