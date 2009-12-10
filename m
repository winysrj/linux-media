Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:35645 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbZLJBN1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 20:13:27 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org,
	stoth@kernellabs.com
In-Reply-To: <200912091754.09985.liplianin@me.by>
References: <4B0459B1.50600@fechner.net>
	 <200912081959.21245.liplianin@me.by>
	 <1260359266.3093.15.camel@palomino.walls.org>
	 <200912091754.09985.liplianin@me.by>
Content-Type: text/plain
Date: Wed, 09 Dec 2009 20:12:39 -0500
Message-Id: <1260407559.3084.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-12-09 at 17:54 +0200, Igor M. Liplianin wrote:
> > > > Igor and Matthias,
> > > >
> > > > Please try the changes that I have for the TeVii S470 that are here:
> > > >
> > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir
> > > >


> In fact some time ago I was writing some code for cx23885 IR, but not reached IR interrupts to 
> work. Though I used PCI_MSK_AV_CORE (1 << 27), then test register PIN_CTRL for field 
> FLD_IR_IRQ_STAT.

Igor,

You are exactly right on this.  I used the wrong interrupt status flag.
I have pushed a patch to my repository to use the PCI_MSK_AV_CORE status
flag.

Could you please update an test the TeVii S470 again when you have time?


> I have Compro E650F with RC6 remote, also have RC5 remote from TV set.
> I will made little hack to test Compro & RC5.

OK. Thank you.

Regards,
Andy

