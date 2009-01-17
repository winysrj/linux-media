Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51415 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371AbZAQNUh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 08:20:37 -0500
Subject: Re: [linux-dvb] RFC - Flexcop Streaming watchdog (VDSB)
From: Andy Walls <awalls@radix.net>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: BOUWSMA Barry <freebeer.bouwsma@gmail.com>, lexW <HondaNSX@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LRH.1.10.0901170923030.5725@pub4.ifh.de>
References: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de>
	 <4970D464.5070509@gmx.de>
	 <alpine.DEB.2.00.0901170035190.18012@ybpnyubfg.ybpnyqbznva>
	 <alpine.LRH.1.10.0901170923030.5725@pub4.ifh.de>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 08:18:56 -0500
Message-Id: <1232198336.2951.13.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patrick,

Please ignore my comment prior in this thread about using
spin_lock_irq() vs. spin_lock_irqsave().  Between lack of sleep and
trying to install Fedora 10 and recover my data on what now appears to
be a failing motherboard/cpu, I made an error.  I realized spinlock
functions should always disable local IRQs (*smacks forehead*).

What one has to take care with is unconditionally re-enabling local IRQs
with spin_unlock_irq().  One would think that a work handler is known to
be called in a non-irq context.  So, at the risk of being wrong again,
using spin_unlock_irq() should be OK, if spin_lock_irq() is allowed by
the kernel in a work handler context (which your experimentation
indicates that it is not).

Regards,
Andy

