Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:62291 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbZCBUIy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2009 15:08:54 -0500
Subject: Re: General protection fault on rmmod cx8800
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090302170349.18c8fd75@hyperion.delvare>
References: <20090215214108.34f31c39@hyperion.delvare>
	 <20090302133936.00899692@hyperion.delvare>
	 <1236003365.3071.6.camel@palomino.walls.org>
	 <20090302170349.18c8fd75@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 15:09:06 -0500
Message-Id: <1236024546.3066.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-03-02 at 17:03 +0100, Jean Delvare wrote:
> Hi Andy,
> 
> On Mon, 02 Mar 2009 09:16:05 -0500, Andy Walls wrote:
> > On Mon, 2009-03-02 at 13:39 +0100, Jean Delvare wrote:
> > > On Sun, 15 Feb 2009 21:41:08 +0100, Jean Delvare wrote:
> > > > Hi all,
> > > > 
> > > > Today I have hit the following general protection fault when removing
> > > > module cx8800:
> > > 
> > > This has just happened to me again today, with kernel 2.6.28.7. I have
> > > opened a bug in bugzilla:
> > > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=12802
> > > 
> > 
> > I'll try to look at it later today.  But right off the bat, I think
> > here's a problem:
> 
> Thanks for your help looking into this!
> 
> > void cx88_ir_stop(struct cx88_core *core, struct cx88_IR *ir)
> > {
> > [...]
> >         if (ir->polling) {
> >                 del_timer_sync(&ir->timer);   <--- Wrong order?
> >                 flush_scheduled_work();       <--- Wrong order?
> >         }
> > }
> 
> The order looks OK to me. If you flush the event workqueue before
> deleting the timer, the timer could rearm before you delete it, and
> you'd return before the workqueue is actually flushed. As a matter of
> fact, both bttv-input and ir-kbd-i2c have it in the same order.

flush_scheduled_work() causes any queued work to execute.  If queued
cx88_IR work exists, it *will* rearm the timer via mod_timer() - the
del_timer_sync() is nullified in this case.



> > static void cx88_ir_work(struct work_struct *work)
> > {
> >         struct cx88_IR *ir = container_of(work, struct cx88_IR, work);
> > 
> >         cx88_ir_handle_key(ir);
> >         mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
> > }
> > 
> > 
> > mod_timer() acts like del_timer(); mumble; add_timer();  If there was
> > any work flushed when stopping the IR, a new timer gets added.  That
> > seems wrong.
> 
> As far as I can see the key difference between bttv-input and
> cx88-input is that bttv-input only uses a simple self-rearming timer,
> while cx88-input uses a timer and a separate workqueue. The timer runs
> the workqueue, which rearms the timer, etc. When you flush the timer,
> the separate workqueue can be still active. I presume this is what
> happens on my system. I guess the reason for the separate workqueue is
> that the processing may take some time and we don't want to hurt the
> system's performance?

It depends.  You use work_queus in the first place to have interrupts
disabled for as little time as possible on a processor; increasing
system performance.  If ordering of deferred work is important, you want
your own single threaded work handler.  If latency of deferred work is
important, you want your own normal (multithreaded) work handler.  If
neither is important, you just use the default kernel eventd. 

> So we need to flush both the event workqueue (with
> flush_scheduled_work) and the separate workqueue (with
> flush_workqueue), at the same time, otherwise the active one may rearm
> the flushed one again. This looks tricky, as obviously we can't flush
> both at the exact same time. Alternatively, if we could get rid of one
> of the queues, we'd have only one that needs flushing, this would be a
> lot easier...

I still need to look into what you just mentioned (I've be out shoveling
over 12 inches of snow off of my driveway for the past few hours).

Depending on how tangled the mess is I was thinking of a few things:

1. cancelling the work instead of flushing it (only good for newer
kernels)

2. a state variable that indicates we're removing the device and to not
call mod_timer() which rearms the timer.


But before all that, I still need to decode the oops to see exactly what
failed.


Regards,
Andy

