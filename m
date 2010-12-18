Return-path: <mchehab@gaivota>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:44301 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756710Ab0LRPzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 10:55:50 -0500
Message-ID: <4D0CD983.9010701@arcor.de>
Date: Sat, 18 Dec 2010 16:55:47 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: tm6000 and IR
References: <4CAD5A78.3070803@redhat.com>	 <20101008150301.2e3ceaff@glory.local>	<4CAF0602.6050002@redhat.com>	 <20101012142856.2b4ee637@glory.local>	<4CB492D4.1000609@arcor.de>	 <20101129174412.08f2001c@glory.local>	<4CF51C9E.6040600@arcor.de>	 <20101201144704.43b58f2c@glory.local>	<4CF67AB9.6020006@arcor.de>	 <20101202134128.615bbfa0@glory.local>	<4CF71CF6.7080603@redhat.com>	 <20101206010934.55d07569@glory.local>	<4CFBF62D.7010301@arcor.de>	 <20101206190230.2259d7ab@glory.local>	<4CFEA3D2.4050309@arcor.de>	 <20101208125539.739e2ed2@glory.local>	<4CFFAD1E.7040004@arcor.de>	 <20101214122325.5cdea67e@glory.local>	<4D079ADF.2000705@arcor.de>	 <20101215164634.44846128@glory.local>	<4D08E43C.8080002@arcor.de>	 <20101216183844.6258734e@glory.local>	<4D0A4883.20804@arcor.de>	 <20101217104633.7c9d10d7@glory.local>	<4D0AF2A7.6080100@arcor.de>	 <20101217160854.16a1f754@glory.local>  <4D0BFF4B.3060001@redhat.com> <1292680595.2061.37.camel@morgan.silverblock.net>
In-Reply-To: <1292680595.2061.37.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Am 18.12.2010 14:56, schrieb Andy Walls:
> On Fri, 2010-12-17 at 22:24 -0200, Mauro Carvalho Chehab wrote:
>
>
>> Despite all discussions, we didn't reach an agreement yet.
>>
>> There are some points to consider whatever solution we do:
>>
>> 1) A keycode table should be able to work with a generic raw decoder. So, on all
>> drivers, the bit order and the number of bits for a given protocol should be the same;
>>
>> 2) we should avoid to cause regressions on the existing definitions.
>>
>> That's said, suggestions to meet the needs are welcome.
> Just to throw out some ideas:
>
> It appears to me that what you are looking at are communications
> protocols with
>
> a. a common Physical layer (PHY): a pulse distance protocol with a
> common carrier freq, bit symbol encoding, leader pulse, trailer pulse,
> and repeat sequence.  The number of bits (and the leader pulse length?)
> is allowed to vary.
>
> b. differing Data Link layers (LL): the data link address can be
> different lengths and in different places; so can the data payload, so
> can the checks on address and data payload.
>
> For the end user, I would present each PHY/LL combination a different
> protocol.  How the kernel implements it internally doesn't matter much.
> It could be one raw decoder handling all the PHY/LL combinations that it
> can, or one PHY decoder and several LL decoders.
>
> The keytables should probably be working on cooked LL output from the
> raw decoder.  I think that will handle a lot of the issues you mention.
> The output from a LL could include
>
> 	destination address (from the transmitted code),
> 	source address (useful if different remotes can be detected),
> 	payload length,
> 	payload, and
> 	maybe button up/down.
>
> The LL could swallow the automatic repeats, since they are just part of
> the button up/down scheme.
>
> Aside from backward compatibility with existing keytables, I don't see
> much point in a decoder trying to flip bits from the PHY layer around to
> present a pseudo-PHY layer output.  Don't keytables get updated with the
> kernel release anyway, or did they all move to userspace utils?
>
>
> Anyway, just some thoughts.
>
> Regards,
> Andy
>
>
>> Thanks,
>> Mauro
>
TM5600, TM6000 and TM6010 IR
==========================

It give two ways to receive data

1. over the control pipe (ep0)
- polling must stop if it loads firmware
- data length are a byte (command)

2. over interrupt pipe (only TM6010)
- data length are two bytes (address << 8 | command)

It has any control registers to configure IR (protocol ...)

TM6010_REQ07_RD8_IR
??, we use 0x2f

TM6010_REQ07_RD8_IR_BSIZE
??

TM6010_REQ07_RD8_IR_WAKEUP_SEL
command mask, I think,   we use here 0xff

TM6010_REQ07_RD8_IR_WAKEUP_ADD
address mask, we use 0xff

TM6010_REQ07_RD8_IR_LEADER1
TM6010_REQ07_RD8_IR_LEADER0
is a 16bit register
for NEC 0xaa30

TM6010_REQ07_RD8_IR_PULSE_CNT1
TM6010_REQ07_RD8_IR_PULSE_CNT0
is a 16bit register
for NEC 0x20d0


Stefan Ringel
