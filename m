Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:18329 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZCBQEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 11:04:02 -0500
Date: Mon, 2 Mar 2009 17:03:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org
Subject: Re: General protection fault on rmmod cx8800
Message-ID: <20090302170349.18c8fd75@hyperion.delvare>
In-Reply-To: <1236003365.3071.6.camel@palomino.walls.org>
References: <20090215214108.34f31c39@hyperion.delvare>
	<20090302133936.00899692@hyperion.delvare>
	<1236003365.3071.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Mon, 02 Mar 2009 09:16:05 -0500, Andy Walls wrote:
> On Mon, 2009-03-02 at 13:39 +0100, Jean Delvare wrote:
> > On Sun, 15 Feb 2009 21:41:08 +0100, Jean Delvare wrote:
> > > Hi all,
> > > 
> > > Today I have hit the following general protection fault when removing
> > > module cx8800:
> > 
> > This has just happened to me again today, with kernel 2.6.28.7. I have
> > opened a bug in bugzilla:
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=12802
> > 
> 
> I'll try to look at it later today.  But right off the bat, I think
> here's a problem:

Thanks for your help looking into this!

> void cx88_ir_stop(struct cx88_core *core, struct cx88_IR *ir)
> {
> [...]
>         if (ir->polling) {
>                 del_timer_sync(&ir->timer);   <--- Wrong order?
>                 flush_scheduled_work();       <--- Wrong order?
>         }
> }

The order looks OK to me. If you flush the event workqueue before
deleting the timer, the timer could rearm before you delete it, and
you'd return before the workqueue is actually flushed. As a matter of
fact, both bttv-input and ir-kbd-i2c have it in the same order.

> static void cx88_ir_work(struct work_struct *work)
> {
>         struct cx88_IR *ir = container_of(work, struct cx88_IR, work);
> 
>         cx88_ir_handle_key(ir);
>         mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
> }
> 
> 
> mod_timer() acts like del_timer(); mumble; add_timer();  If there was
> any work flushed when stopping the IR, a new timer gets added.  That
> seems wrong.

As far as I can see the key difference between bttv-input and
cx88-input is that bttv-input only uses a simple self-rearming timer,
while cx88-input uses a timer and a separate workqueue. The timer runs
the workqueue, which rearms the timer, etc. When you flush the timer,
the separate workqueue can be still active. I presume this is what
happens on my system. I guess the reason for the separate workqueue is
that the processing may take some time and we don't want to hurt the
system's performance?

So we need to flush both the event workqueue (with
flush_scheduled_work) and the separate workqueue (with
flush_workqueue), at the same time, otherwise the active one may rearm
the flushed one again. This looks tricky, as obviously we can't flush
both at the exact same time. Alternatively, if we could get rid of one
of the queues, we'd have only one that needs flushing, this would be a
lot easier...

-- 
Jean Delvare
