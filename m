Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:38622 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbZAQDhm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 22:37:42 -0500
Subject: Re: RFC - Flexcop Streaming watchdog (VDSB)
From: Andy Walls <awalls@radix.net>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: linux-dvb@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de>
References: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 22:37:22 -0500
Message-Id: <1232163442.3263.55.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-01-16 at 16:03 +0100, Patrick Boettcher wrote:
> Hi lists,

> There a struct-work-watchdog looking at the number of irq-received while 
> having PIDs active in the PID-filter. If no IRQs are received, the 
> pid-filter-system is reset.
> 
> It seems to fix the problem and so far I've not seen any false positives 
> (like resetting the pid-filter even though streaming is working fine).
> 
> Before asking to pull the patch I'd like to discuss an issue: my 
> work-around is iterating over the pid-filter-list in the dvb_demux. I'm 
> doing this in the struct-work-callback. In dvb_demux.c I see that this 
> list is protected with a spinlock. When I now try to take the spinlock in 
> the work-function I'll get a nice message saying, that I cannot do take a 
> spinlock in a work-function.
> 
> What can I do?

I am surprised you cannot acquire a spinlock in a deferable work
handler.  I would not have thought this the case, but I don't know for
sure.  BTW, why are you using spin_lock_irq() to disable local
interrupts in the work handler instead of spin_lock_irqsave()?  I would
think one would only call spin_lock_irq() in the irq handler and then
under limited circumstances (I could be wrong).  

However, if you cannot take a spinlock in a work handler, then you must
acquire the spinlock in the irq handler, walk the list there to *collect
information* on the deferable work you must do, and then submit the
information about deferable work you need to do onto the work queue.

You can pass the information to the work-handler in a structure that
contains a struct work object plus the other data you need.  If you use
a single-threaded work handler, then ordering of the work is preserved
by virtue of only one thread pulling work off of the work queue.  The
normal multithreaed work-handling doesn't preserve ordering of the
deferable work.

For an example which you can look at:
In cx18, I used "work orders" that would be submitted to the deferable
work-handler.  In struct cx18, you will see an array (pool) of
epu_work_orders for each device.  All of the work handling and
scheduling is done in cx18-mailbox.c, IIRC.



> What is the proper way to protect access to this list?

To acquire the spinlock.  If you don't, you invalidate a fundamental
assumption made by other code that accesses that list.

>  Is 
> it needed at all?

I would assume yes, but I haven't inspected the dvb code to verify.

Regards,
Andy

> thanks for you input in advance,
> Patrick.
> 
> --
>    Mail: patrick.boettcher@desy.de
>    WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

