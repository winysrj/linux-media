Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:59486 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZCEFKB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 00:10:01 -0500
Date: Wed, 4 Mar 2009 21:09:58 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org
Subject: Re: General protection fault on rmmod cx8800
In-Reply-To: <1236024546.3066.11.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.58.0903021212350.24268@shell2.speakeasy.net>
References: <20090215214108.34f31c39@hyperion.delvare>
 <20090302133936.00899692@hyperion.delvare>  <1236003365.3071.6.camel@palomino.walls.org>
  <20090302170349.18c8fd75@hyperion.delvare> <1236024546.3066.11.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Mar 2009, Andy Walls wrote:
> On Mon, 2009-03-02 at 17:03 +0100, Jean Delvare wrote:
> > >         if (ir->polling) {
> > >                 del_timer_sync(&ir->timer);   <--- Wrong order?
> > >                 flush_scheduled_work();       <--- Wrong order?
> > >         }
> > > }
> >
> > The order looks OK to me. If you flush the event workqueue before
> > deleting the timer, the timer could rearm before you delete it, and
> > you'd return before the workqueue is actually flushed. As a matter of
> > fact, both bttv-input and ir-kbd-i2c have it in the same order.
>
> flush_scheduled_work() causes any queued work to execute.  If queued
> cx88_IR work exists, it *will* rearm the timer via mod_timer() - the
> del_timer_sync() is nullified in this case.

The timer could go off between the call to flush_s_w and del_t_s.  In that
case the work function could call mod_timer after del_t_s is called restart
the timer.

I think what you have to do is first disable the timer so that it won't run
the work fuction when it goes off.  Then flush the work, then delete the
timer.

Or make the work function not mod the timer (i.e., add "if (!ir->exiting)"
to the mod_timer() call), then flush the work, then delete the timer,
then I think you have to flush the work again.

Of course, the best method is to use delayed_work, which takes care of all
this trickiness.  I think it's able to use the work queue code on a lower
level and do it more efficiently than would be possible with just the
public work queue api.

> > the separate workqueue can be still active. I presume this is what
> > happens on my system. I guess the reason for the separate workqueue is
> > that the processing may take some time and we don't want to hurt the
> > system's performance?
>
> It depends.  You use work_queus in the first place to have interrupts
> disabled for as little time as possible on a processor; increasing
> system performance.  If ordering of deferred work is important, you want
> your own single threaded work handler.  If latency of deferred work is
> important, you want your own normal (multithreaded) work handler.  If
> neither is important, you just use the default kernel eventd.

For IR polling, latency might be important.  IIRC, there are also RT
priority work queues now that can be used.
