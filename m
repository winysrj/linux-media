Return-path: <mchehab@gaivota>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:33385 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab0LPC0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 21:26:13 -0500
Received: by eyg5 with SMTP id 5so1668692eyg.2
        for <linux-media@vger.kernel.org>; Wed, 15 Dec 2010 18:26:11 -0800 (PST)
Date: Thu, 16 Dec 2010 12:26:09 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 and IR
Message-ID: <20101216122609.28313a35@glory.local>
In-Reply-To: <4D08E43C.8080002@arcor.de>
References: <4CAD5A78.3070803@redhat.com>
	<20101008150301.2e3ceaff@glory.local>
	<4CAF0602.6050002@redhat.com>
	<20101012142856.2b4ee637@glory.local>
	<4CB492D4.1000609@arcor.de>
	<20101129174412.08f2001c@glory.local>
	<4CF51C9E.6040600@arcor.de>
	<20101201144704.43b58f2c@glory.local>
	<4CF67AB9.6020006@arcor.de>
	<20101202134128.615bbfa0@glory.local>
	<4CF71CF6.7080603@redhat.com>
	<20101206010934.55d07569@glory.local>
	<4CFBF62D.7010301@arcor.de>
	<20101206190230.2259d7ab@glory.local>
	<4CFEA3D2.4050309@arcor.de>
	<20101208125539.739e2ed2@glory.local>
	<4CFFAD1E.7040004@arcor.de>
	<20101214122325.5cdea67e@glory.local>
	<4D079ADF.2000705@arcor.de>
	<20101215164634.44846128@glory.local>
	<4D08E43C.8080002@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Stefan

> >> The nec initiation looks right and must adding code for
> >> tm5600/6000 (going over message pipe).
> > I haven't USB stick with tm5600/6000 for test. Need people with
> > this TV cards.
> >
> then add a todo line.

I'll do it.

> >> rc5 need some code for tm6010 (for tm5600/6000 are the hack).
> > I didn't touch this code because I haven't RC5 remotes and
> > tm5600/6000
> >
> >> And the logic for your remote control is unused  for
> >> the second variant, but ir->rc_type = rc_type are o.k.
> but the line ir->rc_type = rc_type; are o.k.
> 
> > I think your mean is wrong. Our IR remotes send extended NEC it is
> > 4 bytes. We removed inverted 4 byte and now we have 3 bytes from
> > remotes. I think we must have full RCMAP with this 3 bytes from
> > remotes. And use this remotes with some different IR recievers like
> > some TV cards and LIRC-hardware and other. No need different RCMAP
> > for the same remotes to different IR recievers like now.
> Your change doesn't work with my terratec remote control !!

I'll try solve this problem don't worry.

> > If we use second variant I can't use RCMAP_BEHOLD because it has
> > full 3 bytes scancodes. As you wrote.
> >
> And if you use two bytes rc map table. We have add filter for address 
> and commands to pass all. With an external tool can change the map ( 
> ir_keytable). Why you will use more than two bytes.

With my last code this tool is working. When you call change_protocol new
value of address stored. But if a keytable of remotes hasn't full scancodes it
doesn't work

How to main IR core search scancodes in RCMAP keytable?
I think it search full equal scancode value with returned from tm6000.

Example:
defined keytable:
0x86 0x6B 0x00

tm6000 read IR data
0x86 0x00

When return 0x86 0x00 to IR core a key is unknown because
0x86 0x6B 0x00 != 0x86 0x00

I think we can have two different solutions:

1. My variant. When init IR tm6000, get full address from a keytable, store it. After key filtering
restore full scancode and return it to IR core -> 0x86 0x6B 0x00. A keytable must has really full scancodes.

2. More simple. A keytable has only data byte. Get IR data and return only data byte without filtering because
a keytable hasn't this information. This is bad the TV card can do some task by other IR remotes. Or add some place where 
stored filter information and update filter when keytable replaced.

With my best regards, Dmitry.
