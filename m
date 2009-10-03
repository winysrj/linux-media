Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:44230
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbZJCDPq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 23:15:46 -0400
Cc: Jean Delvare <khali@linux-fr.org>, m8923014@msg.ndhu.edu.tw,
	"H.Y. Chin" <hychin@twins.ee.nctu.edu.tw>,
	Daniel Chao <daniel.chao@gmail.com>,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	hermann pitton <hermann-pitton@arcor.de>
Message-Id: <9D21D579-D26C-4BED-AA3A-7137B6B48D7C@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: LMML <linux-media@vger.kernel.org>
In-Reply-To: <1254514826.3261.33.camel@pc07.localdom.local>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: IR device at I2C address 0x7a
Date: Fri, 2 Oct 2009 23:16:12 -0400
References: <20091002134722.61abbd48@hyperion.delvare> <1254514826.3261.33.camel@pc07.localdom.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 2, 2009, at 4:20 PM, hermann pitton wrote:

> Am Freitag, den 02.10.2009, 13:47 +0200 schrieb Jean Delvare:
>>
...
>> While investigating another issue, I have noticed the following  
>> message
>> in the kernel logs of a saa7134 user:
>>
>> i2c-adapter i2c-0: Invalid 7-bit address 0x7a
>>
>> The address in question is attempted by an IR device probe, and is  
>> only
>> probed on SAA7134 adapters. The problem with this address is that  
>> it is
>> reserved by the I2C specification for 10-bit addressing, and is thus
>> not a valid 7-bit address. Before the conversion of ir-kbd-i2c to the
>> new-style i2c device driver binding model, device probing was done by
>> ir-kbd-i2c itself so no check was done by i2c-core for address
>> validity. But since kernel 2.6.31, probing at address 0x7a will be
>> denied by i2c-core.
>>
>> So, SAA7134 adapters with an IR device at 0x7a are currently broken.
>> Do we know how many devices use this address for IR and which they
>> are? Tracking the changes in the source code, this address was added
>> in kernel 2.6.8 by Gerd Knorr:
>>  http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=581f0d1a0ded3e3d4408e5bb7f81b9ee221f6b7a
>> So this would be used by the "Upmost Purple TV" adapter. Question is,
>> are there other?
>
> Yes, currently 0x7a is only used by the Upmost Purple TV (Yuan  
> Tun800).
>
> Here are some more details.
> http://archives.devshed.com/forums/linux-97/troubles-with-yuan-tun900-board-detected-as-upmost-purple-tv-1283673.html
>
> Support for the card and the i2c remote was added by Wang-Chan Chen.
>
> For testers it is useful to know that the card is still not fully
> supported.
>
> It has a NEC D64083GF video enhancer converting TV baseband video from
> tuner to S-Video and shares the vmux = 7 with the S-Video input.
>
> By default it comes up in external S-Video input mode.
> There is a Pericom videomux on it and we don't know how to switch it.
>
> Chen used to boot at first windows, switched there to tuner input and
> rebooted to GNU/Linux ...
>
>> Some web research has pointed me to the Yuan TUN-900:
>>  http://www.linuxtv.org/pipermail/linux-dvb/2008-January/023405.html
>> but it isn't clear to me whether the device at 0x7a on this adapter  
>> is
>> the same as the one on the Purple TV. And saa7134-cards says of the
>> TUN-900: "Remote control not yet implemented" so maybe we can just
>> ignore it for now.
>
> Yes, that card has a device at 0xf4/0x7a too.
> I asked to test the remote with the Upmost Purple TV entry, but never
> got a reply. As we know these days, radio amux is wrong too on Yuan
> TUN900 card=66.
>
> Last contact to Chen was four years back, but he confirmed that both
> cards have the same PCI subsystem. Some bytes in the eeprom, meaning
> unknown, are different, though.
>
>> If we have to, I could make i2c-core more permissive, but I am rather
>> reluctant to letting invalid addressed being probed, because you  
>> never
>> know how complying chips on the I2C bus will react. I am OK  
>> supporting
>> invalid addresses if they really exist out there, but the impact  
>> should
>> be limited to the hardware in question.
>>
>> If we only have to care about the Upmost Purple TV, then the  
>> following
>> patch should solve the problem:
>
> For what is known so far.
>
> Acked-by: hermann pitton <hermann-pitton@arcor.de>

Seems like a sane thing to do to me too, and I've not seen nor heard  
of any other devices that use 0x7a. (Hell, I wasn't even aware of  
these ones 'til now).

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@wilsonet.com




