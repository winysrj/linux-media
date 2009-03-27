Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39827 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752849AbZC0PzA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 11:55:00 -0400
Date: Fri, 27 Mar 2009 16:55:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Darius Augulis <augulis.darius@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
In-Reply-To: <20090327154251.GA28983@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0903271653410.4635@axis700.grange>
References: <49C89F00.1020402@gmail.com> <Pine.LNX.4.64.0903261405520.5438@axis700.grange>
 <49CCEE3A.8000502@gmail.com> <20090327154251.GA28983@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Mar 2009, Russell King - ARM Linux wrote:

> On Fri, Mar 27, 2009 at 05:18:18PM +0200, Darius Augulis wrote:
> > > You use an FIQ for SoF, and spin_lock_irqsave() to protect. Don't they 
> > > only disable IRQs and not FIQs? But it seems your FIQ cannot cause any 
> > > trouble, so, it should be fine. Do you really need an FIQ?
> 
> This is precisely the area where FIQs can't be used.  You can't take
> spinlocks (even IRQ-safe spinlocks) from FIQs.  Why?  You'll deadlock.
> 
> Consider:
> 
> 	spin_lock_irqsave(lock, flags);
> 	...
> FIQ happens
> FIQ:	spin_lock_irqsave(lock, flags); <=== deadlock
> 
> And there's nothing you can do about that.  And no, converting this
> locking primitive to also disable FIQs means that then FIQs will be
> subject to the same latency as normal IRQs.
> 
> In fact, in uniprocessor mode, you might as well completely forget the
> spinlock, because the lock part is a no-op, and the IRQ disable has no
> effect on FIQs.
> 
> If you're going to be using FIQs in C code, you need to be _very_ _very_
> careful about what you do.  Calling normal kernel functions is generally
> not going to be safe in any way.

No, they are not calling C from FIQs and they are not protecting against 
FIQs with a spinlock_irq*, that was my misinterpretation, sorry.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
