Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:12365 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730Ab0G1Ojb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 10:39:31 -0400
Subject: Re: Can I expect in-kernel decoding to work out of box?
From: Andy Walls <awalls@md.metrocast.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
In-Reply-To: <AANLkTinCs7f6zF-tYZqJ49CAjNWF=2MPGh0VRuU=VLzq@mail.gmail.com>
References: <1280269990.21278.15.camel@maxim-laptop>
	 <1280273550.32216.4.camel@maxim-laptop>
	 <AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>
	 <AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>
	 <1280298606.6736.15.camel@maxim-laptop>
	 <AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>
	 <4C502CE6.80106@redhat.com>
	 <AANLkTinCs7f6zF-tYZqJ49CAjNWF=2MPGh0VRuU=VLzq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 10:38:49 -0400
Message-ID: <1280327929.11072.24.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-07-28 at 09:46 -0400, Jon Smirl wrote:
> Let's be really sure it is NEC and not JVC.
> 
> > >    8850     4350      525     1575      525     1575
> > >     525      450      525      450      525      450
> > >     525      450      525     1575      525      450
> > >     525     1575      525      450      525     1575
> > >     525      450      525      450      525     1575
> > >     525      450      525      450      525    23625
> 
> 
> NEC timings are 9000 4500 560 1680 560 560 etc
> 
> JVC timings are 8400 4200 525 1575 525 525
> 
> It is a closer match to the JVC timing.  But neither protocol uses a
> different mark/space timing -- 450 vs 525

I assume you mean "different mark/space timing for the symbol for which
they are the same length" (in NEC that's the '0' symbol IIRC).
  

I've noticed different mark/space timings for the '0' symbol from NEC
remotes and with some RC-5 remotes.  I usually attribute it to cheap
remote designs, weak batteries, capacitive effects, receiver pulse
measurement technique, etc.

Here's an example of NEC remote from a DTV STB remote as measured by the
CX23888 IR receiver on an HVR-1850:

8257296 ns  mark
4206185 ns  space
        leader
 482926 ns  mark
 545296 ns  space
        0
 481296 ns  mark
1572259 ns  space
        1
 481148 ns  mark
 546333 ns  space
        0
 479963 ns  mark
 551815 ns  space
        0
 454333 ns  mark
1615519 ns  space
        1
 435074 ns  mark
 591370 ns  space
[...]

I don't know the source of the error.  I would have to check the same
remote against my MCE USB receiver to try and determine any receiver
induced measurement errors.

But, in Maxim's case, the difference isn't bad: 450/525 ~= 86%.  I would
hope a 15% difference would still be recognizable.


> Also look at the repeats. This is repeating at about 25ms. NEC repeat
> spacing is 110ms. JVC is supposed to be at 50-60ms. NEC does not
> repeat the entire command and JVC does. The repeats are closer to
> following the JVC model.
> 
> I'd say this is a JVC command. So the question is, why didn't JVC
> decoder get out of state zero?

Is JVC enabled by default?  I recall analyzing that it could generate
false positives on NEC codes.

Regards,
Andy

