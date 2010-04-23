Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45572 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925Ab0DWWUQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 18:20:16 -0400
Subject: Re: [PATCH 00/15] ir-core: Several improvements to allow adding
 LIRC  and decoder plugins
From: Andy Walls <awalls@md.metrocast.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <o2l9e4733911004231106te8b727e9nfa75bfd9c73e9506@mail.gmail.com>
References: <20100401145632.5631756f@pedra>
	 <t2z9e4733911004011844pd155bbe8g13e4cbcc1a5bf1f6@mail.gmail.com>
	 <20100402102011.GA6947@hardeman.nu>
	 <p2ube3a4a1004051349y11e3004bk1c71e3ab38d3f669@mail.gmail.com>
	 <20100407093205.GB3029@hardeman.nu>
	 <z2hbe3a4a1004231040uce51091fnf24b97de215e3ef1@mail.gmail.com>
	 <o2l9e4733911004231106te8b727e9nfa75bfd9c73e9506@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Apr 2010 18:20:28 -0400
Message-Id: <1272061228.3089.8.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-04-23 at 14:06 -0400, Jon Smirl wrote:
> On Fri, Apr 23, 2010 at 1:40 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> >
> > So now that I'm more or less done with porting the imon driver, I
> > think I'm ready to start tackling the mceusb driver. But I'm debating
> > on what approach to take with respect to lirc support. It sort of
> > feels like we should have lirc_dev ported as an ir "decoder"
> > driver/plugin before starting to port mceusb to ir-core, so that we
> > can maintain lirc compat and transmit support. Alternatively, I could
> > port mceusb without lirc support for now, leaving it to only use
> > in-kernel decoding and have no transmit support for the moment, then
> > re-add lirc support. I'm thinking that porting lirc_dev as, say,
> > ir-lirc-decoder first is probably the way to go though. Anyone else
> > want to share their thoughts on this?
> 
> I'd take whatever you think is the simplest path. It is more likely
> that initial testers will want to work with the new in-kernel system
> than the compatibility layer to LIRC. Existing users that are happy
> with the current LIRC should just keep on using it.

Jarod,

Not that my commit rate has been > 0 LOC lately, but I'd like to see
lirc_dev, just to get transmit worked out for the CX23888 chip and
cx23885 driver.

I think this device will bring to light some assumptions LIRC currently
makes about transmit that don't apply to the CX23888 (i.e. LIRC having
to perform the pulse timing).  The cx23888-ir implementation has a kfifo
for holding outgoing pulse data and the hardware itself has an 8 pulse
measurement deep fifo.


But I'd recommend whatever helps you get more productive work done
first.  I've had no time for linux lately.

Regards,
Andy

