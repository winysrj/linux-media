Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail12.sea5.speakeasy.net ([69.17.117.14]:45495 "EHLO
	mail12.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbZC3UyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 16:54:05 -0400
Date: Mon, 30 Mar 2009 13:54:01 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: Corey Taylor <johnfivealive@yahoo.com>,
	Brandon Jenkins <bcjenkins@tvwhere.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
In-Reply-To: <1238349373.3236.40.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.58.0903300842320.28292@shell2.speakeasy.net>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
 <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>
 <63160.21731.qm@web56906.mail.re3.yahoo.com>  <1237251478.3303.37.camel@palomino.walls.org>
  <954486.20343.qm@web56908.mail.re3.yahoo.com>  <1237425168.3303.94.camel@palomino.walls.org>
  <de8cad4d0903220853v4b871e91x7de6efebfb376034@mail.gmail.com>
 <871136.15243.qm@web56908.mail.re3.yahoo.com>  <1238297237.3235.42.camel@palomino.walls.org>
  <Pine.LNX.4.58.0903290044380.28292@shell2.speakeasy.net>
 <1238349373.3236.40.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 29 Mar 2009, Andy Walls wrote:
> On Sun, 2009-03-29 at 01:24 -0700, Trent Piepho wrote:
> > wait_event() should take care of this.  wait_event(q, test) basically does:
> >
> > for(;;) {
> > 	// point A
> > 	add_me_to_waitqueue(q);
> > 	set_current_state(TASK_UNINTERRUPTIBLE);
> > 	if (test)
> > 		break;
> > 	// point B
> > 	schedule();
> > }
> > clean_up_wait_stuff();
>
> As you know, the condition is checked even before this loop is entered,
> to avoid even being even added to a waitqueue.  (Thank God for ctags...)

I think the initial check of the condition is just an optimization and
everything will still work without it.  Seeing as all this is inlined, I
wonder if it's a good optimization...

> As you may have noticed, the original code was using
> wait_event_timeout() before like this:
>
>         CX18_DEBUG_HI_IRQ("sending interrupt SW1: %x to send %s\n",
>                           irq, info->name);
>         cx18_write_reg_expect(cx, irq, SW1_INT_SET, irq, irq);
>
>         ret = wait_event_timeout(
>                        *waitq,
>                        cx18_readl(cx, &mb->ack) == cx18_readl(cx, &mb->request),
>                        timeout);
>
> Because waiting for the ack back is the right thing to do, but certainly
> waiting too long is not warranted.
>
> This gave me the occasional log message like this:
>
> 1: cx18-0:  irq: sending interrupt SW1: 8 to send CX18_CPU_DE_SET_MDL
> 2: cx18-0:  irq: received interrupts SW1: 0  SW2: 8  HW2: 0
> 3: cx18-0:  irq: received interrupts SW1: 10000  SW2: 0  HW2: 0
> 4: cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for RPU acknowledgement
>
> Where line 1 is the driver notifiying the firmware with a SW1 interrupt.
> Line 2 is the firmware responding back to the cx18_irq_handler() with
> the Ack interrupt in SW2 (the flags match, 8 & 8, by design).
> Line 3 is an unrelated incoming video buffer notification for the cx18
> driver.
> Line 4 is the wait_event_timeout() timing out.

Could it be that the wait_event doesn't actually run and check its
condition until _after_ line 3?  In that case SW2 != 8 and so it goes back
to sleep?  Calling wake_up() just makes the processes on the waitq
runnable, they don't actually run until later, possibly much later.

> > If your event occurs and wake_up() is called at point A, then the test
> > should be true when it's checked and schedule() is never called.  If the
> > event happens at point B, then the process' state will have been changed to
> > TASK_RUNNING by wake_up(), remember it's already on the waitqueue at this
> > point, and schedule() won't sleep.
>
> OK, for some reason, I thought schedule() and schedule_timeout() would
> go to sleep anyway.

AFAIK, they'll still cause the kernel schedule a process.  Maybe a
different process.  But the original process is still in TASK_RUNNING state
and so still in the run queue and will get run again.  If it was in
TASK_(UN)INTERRUPTIBLE state then it wouldn't be in the run queue and
wouldn't run again until something woke it up.

> > I think what's probably happening is the test, cx18_readl(cx, &mb->ack) ==
> > cx18_readl(cx, &mb->request), is somehow not true even though the ack has
> > been received.
>
> A PCI bus read error could be the culprit here.  That's the only thing I
> can think of.  We only get one notification via IRQ from the firmware.
>
>
> >   Maybe a new request was added?
>
> No, I lock the respective epu2apu or epu2cpu mailboxes respectively with
> a mutex.

But in your log:
> 1: cx18-0:  irq: sending interrupt SW1: 8 to send CX18_CPU_DE_SET_MDL
> 2: cx18-0:  irq: received interrupts SW1: 0  SW2: 8  HW2: 0
> 3: cx18-0:  irq: received interrupts SW1: 10000  SW2: 0  HW2: 0
> 4: cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for RPU acknowledgement

Isn't the wait_event_timeout() waiting until line 4?  And doesn't line 3
mean something has changed the registers?  Changed them before the
wait_event finished?

> > I think calling wait_event()'s with something that tests a hardware
> > register is a little iffy.  It's better if the irq handler sets some driver
> > state flag (atomically!) that indicates the event you were waiting for has
> > happened and then you check that flag.
>
> I was toying with setting an atomic while in the IRQ handler.  But then
> I realized when we get the ack interrupt, the firmware should actually
> be done. So really the wakeup() is the only indicator I really need.
> Checking for ack == req is just a formality I guess.

If you use an interruptible timeout, then you could get interrupted with a
signal before the irq handler has woken you.

> There wasn't a wait_timeout(), so I had tried something like this in my
> first iteration:

It's called sleep_on_timeout(q, timeout).
