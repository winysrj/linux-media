Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45479 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751660AbZBRCFJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 21:05:09 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
Date: Wed, 18 Feb 2009 03:04:27 +0100
Cc: Trent Piepho <xyzzy@speakeasy.org>
References: <4986507C.1050609@googlemail.com> <200902170140.53617@orion.escape-edv.de> <499A36CD.4070209@linuxtv.org>
In-Reply-To: <499A36CD.4070209@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902180304.28615@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andreas Oberritter wrote:
> Oliver Endriss wrote:
> > ...
> > @Andreas:
> > Could you please explain in more detail what bad things might happen?
> 
> To quote myself from the changelog: This fixes a deadlock discovered
> by lockdep.

I re-read the commit message, but it still does not ring any bells.
Could you please post the lockdep output?

> The lock is used in process context (e.g. DMX_START) and might also be
> used from interrupt context (e.g. dvb_dmx_swfilter).

Correct:
- dvb_dmx_swfilter uses spin_lock (called from irq, tasklet, whatever)
- DMX_START uses spin_lock_irq (called from process)
-> ok (see below).

> >From http://osdir.com/ml/kernel.janitors/2002-08/msg00022.html:
> 
> "spin_lock_irq disables local interrupts and then takes the spin_lock.
> If you know you're in process context and other users may be in
> interrupt context, this is the correct call to make.
> 
> spin_lock_irqsave saves local interrupt state into the flags variable,
> disables interrupts, then takes the spin_lock.  spin_unlock_irqrestore
> restores the local state saved in the flags.  Use this variant if you
> don't know whether you're in interrupt or process context."
> 
> So, if the assumtions above are correct, then spin_lock_irq must be
> used by all functions called from process context and
> spin_lock_irqsave must be used by all functions called from an unknown
> context.

Correct.

[1] If you want to lock a process against an interrupt handler,
- the process must use spin_lock_irq()
- the interrupt can use spin_lock()

A routine has to use spin_lock_irqsave if (and only if) process and irq
call the routine concurrently. I do not see yet how this might happen.

(Basically, the same happens when locking between tasklet and process
context, except that it is sufficient to use spin_lock_bh instead of
spin_lock_irq.)

Regards
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
