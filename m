Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51512 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbZC2SAb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 14:00:31 -0400
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
From: Andy Walls <awalls@radix.net>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Corey Taylor <johnfivealive@yahoo.com>,
	Brandon Jenkins <bcjenkins@tvwhere.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org
In-Reply-To: <Pine.LNX.4.58.0903290044380.28292@shell2.speakeasy.net>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
	 <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>
	 <63160.21731.qm@web56906.mail.re3.yahoo.com>
	 <1237251478.3303.37.camel@palomino.walls.org>
	 <954486.20343.qm@web56908.mail.re3.yahoo.com>
	 <1237425168.3303.94.camel@palomino.walls.org>
	 <de8cad4d0903220853v4b871e91x7de6efebfb376034@mail.gmail.com>
	 <871136.15243.qm@web56908.mail.re3.yahoo.com>
	 <1238297237.3235.42.camel@palomino.walls.org>
	 <Pine.LNX.4.58.0903290044380.28292@shell2.speakeasy.net>
Content-Type: text/plain
Date: Sun, 29 Mar 2009 13:56:13 -0400
Message-Id: <1238349373.3236.40.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-03-29 at 01:24 -0700, Trent Piepho wrote:
> On Sat, 28 Mar 2009, Andy Walls wrote:
> > On Mon, 2009-03-23 at 06:52 -0700, Corey Taylor wrote:
> > I found a race condition between the cx driver and the CX23418 firmware.
> > I have a patch that mitigates the problem here:
> >
> > http://linuxtv.org/hg/~awalls/cx18/rev/9f5f44e0ce6c
> 
> > [ We have to do this polling wait because there is a race with the
> > firmware.  Once we give it the SW1 interrupt above, it can wake up our
> > waitq with an ack interrupt via the irq handler after we're ready to
> > wait, but before we actually get put to sleep by schedule().  Loosing
> > that race causes us to wait the entire timeout, waitng for a wakeup
> > that's never going to come.  ]

Trent,

First, thanks for the fresh perspective.


> A race like this should be avoidable.  The way it works is you do something
> like this:
> 
> /* 1 */ set_current_state(TASK_INTERRUPTIBLE);
> /* 2 */ cx18_write_reg_expect(cx, irq, SW1_INT_SET, irq, irq);
> /* 3 */ schedule();
> /* 4 */ ack_has_now_been_received();

I tried something like this in my second iteration, see below.  (The
patch I put in my repo was actually my third iteration.)


> The race you are talking about is when the ack arrives between line 2 and
> 3.  If this happens here, the process' current state is changed to
> TASK_RUNNING when the irq hander that receives the ack tries to wake our
> process.  If schedule() is called with the state set to TASK_RUNNING then
> the process doesn't sleep.  And thus there is no race.  The key is that
> preparing to sleep at line 1 happens before we start the event we want to
> wait for at line 2.
> 
> wait_event() should take care of this.  wait_event(q, test) basically does:
> 
> for(;;) {
> 	// point A
> 	add_me_to_waitqueue(q);
> 	set_current_state(TASK_UNINTERRUPTIBLE);
> 	if (test)
> 		break;
> 	// point B
> 	schedule();
> }
> clean_up_wait_stuff();

As you know, the condition is checked even before this loop is entered,
to avoid even being even added to a waitqueue.  (Thank God for ctags...)

As you may have noticed, the original code was using
wait_event_timeout() before like this:

        CX18_DEBUG_HI_IRQ("sending interrupt SW1: %x to send %s\n",
                          irq, info->name);
        cx18_write_reg_expect(cx, irq, SW1_INT_SET, irq, irq);

        ret = wait_event_timeout(
                       *waitq,
                       cx18_readl(cx, &mb->ack) == cx18_readl(cx, &mb->request),
                       timeout);

Because waiting for the ack back is the right thing to do, but certainly
waiting too long is not warranted.

This gave me the occasional log message like this:

1: cx18-0:  irq: sending interrupt SW1: 8 to send CX18_CPU_DE_SET_MDL
2: cx18-0:  irq: received interrupts SW1: 0  SW2: 8  HW2: 0
3: cx18-0:  irq: received interrupts SW1: 10000  SW2: 0  HW2: 0
4: cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for RPU acknowledgement

Where line 1 is the driver notifiying the firmware with a SW1 interrupt.
Line 2 is the firmware responding back to the cx18_irq_handler() with
the Ack interrupt in SW2 (the flags match, 8 & 8, by design).
Line 3 is an unrelated incoming video buffer notification for the cx18
driver.
Line 4 is the wait_event_timeout() timing out.

Since, I'm sending buffers back to the firmware on the read()-ing
applications timeline, these delays caused playback problems.


> If your event occurs and wake_up() is called at point A, then the test
> should be true when it's checked and schedule() is never called.  If the
> event happens at point B, then the process' state will have been changed to
> TASK_RUNNING by wake_up(), remember it's already on the waitqueue at this
> point, and schedule() won't sleep.

OK, for some reason, I thought schedule() and schedule_timeout() would
go to sleep anyway.


> I think what's probably happening is the test, cx18_readl(cx, &mb->ack) ==
> cx18_readl(cx, &mb->request), is somehow not true even though the ack has
> been received.

A PCI bus read error could be the culprit here.  That's the only thing I
can think of.  We only get one notification via IRQ from the firmware.


>   Maybe a new request was added?

No, I lock the respective epu2apu or epu2cpu mailboxes respectively with
a mutex.


> I think calling wait_event()'s with something that tests a hardware
> register is a little iffy.  It's better if the irq handler sets some driver
> state flag (atomically!) that indicates the event you were waiting for has
> happened and then you check that flag.

I was toying with setting an atomic while in the IRQ handler.  But then
I realized when we get the ack interrupt, the firmware should actually
be done. So really the wakeup() is the only indicator I really need.
Checking for ack == req is just a formality I guess.


There wasn't a wait_timeout(), so I had tried something like this in my
first iteration:

#define wait_event_oneshot_timeout(wq, condition, timeout)              \
({                                                                      \
        long __ret = timeout;                                           \
        if (!(condition)) {                                             \
                DEFINE_WAIT(__wait);                                    \
                prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);    \
                if (!(condition)) {                                     \
                        __ret = schedule_timeout(__ret);                \
                }                                                       \
                finish_wait(&wq, &__wait);                              \
        }                                                               \
        __ret;                                                          \
})

...
	cx18_write_reg_expect(cx, irq, SW1_INT_SET, irq, irq);

        ret = wait_event_oneshot_timeout(*waitq,
                                         cx18_readl(cx, &mb->request) ==
                                         cx18_readl(cx, &mb->ack),
                                         timeout);
...


It didn't work.  Sometimes it would wait the whole timeout, but the
cx18_irq_handler() had gotten an ack interrupt.


Then I tried:


        // FIXME break into several small timeouts/poll
        // or use an atomic to communicate completion
        CX18_DEBUG_HI_IRQ("sending interrupt SW1: %x to send %s\n",
                          irq, info->name);
        ret = timeout;
        prepare_to_wait(waitq, &w, TASK_UNINTERRUPTIBLE);
        cx18_write_reg_expect(cx, irq, SW1_INT_SET, irq, irq);
        /*
         * Will we schedule in time, before the IRQ handler wakes up our waitq? 
         * Who knows?!  How exciting!  Let the race begin!
         */
        if (req != cx18_readl(cx, &mb->ack))
                ret = schedule_timeout(timeout);
        finish_wait(waitq, &w);


It didn't work, sometimes it would wait the whole timeout even though
the ack interrupt had arrived.  Again at the time, I was under the
impression that schedule_timeout() would go to sleep anyway even if we
had been awakened (thus my sarcastic comments).


Did I miss anything with either of those two previous tries?


I guess I need to dig into the guts of schedule_timeout() to convince
myself that the process won't be put to sleep.


I'm using Fedora 10 BTW:

Linux palomino.walls.org 2.6.27.9-159.fc10.x86_64 #1 SMP Tue Dec 16
14:47:52 EST 2008 x86_64 x86_64 x86_64 GNU/Linux

Thanks.

Regards,
Andy

