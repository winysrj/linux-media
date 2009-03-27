Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47388 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZC0PnF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 11:43:05 -0400
Date: Fri, 27 Mar 2009 15:42:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Darius Augulis <augulis.darius@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
Message-ID: <20090327154251.GA28983@n2100.arm.linux.org.uk>
References: <49C89F00.1020402@gmail.com> <Pine.LNX.4.64.0903261405520.5438@axis700.grange> <49CCEE3A.8000502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CCEE3A.8000502@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 27, 2009 at 05:18:18PM +0200, Darius Augulis wrote:
> > You use an FIQ for SoF, and spin_lock_irqsave() to protect. Don't they 
> > only disable IRQs and not FIQs? But it seems your FIQ cannot cause any 
> > trouble, so, it should be fine. Do you really need an FIQ?

This is precisely the area where FIQs can't be used.  You can't take
spinlocks (even IRQ-safe spinlocks) from FIQs.  Why?  You'll deadlock.

Consider:

	spin_lock_irqsave(lock, flags);
	...
FIQ happens
FIQ:	spin_lock_irqsave(lock, flags); <=== deadlock

And there's nothing you can do about that.  And no, converting this
locking primitive to also disable FIQs means that then FIQs will be
subject to the same latency as normal IRQs.

In fact, in uniprocessor mode, you might as well completely forget the
spinlock, because the lock part is a no-op, and the IRQ disable has no
effect on FIQs.

If you're going to be using FIQs in C code, you need to be _very_ _very_
careful about what you do.  Calling normal kernel functions is generally
not going to be safe in any way.
