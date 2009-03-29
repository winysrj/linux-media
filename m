Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail12.sea5.speakeasy.net ([69.17.117.14]:40126 "EHLO
	mail12.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZC2IYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 04:24:22 -0400
Date: Sun, 29 Mar 2009 01:24:19 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: Corey Taylor <johnfivealive@yahoo.com>,
	Brandon Jenkins <bcjenkins@tvwhere.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	ivtv-users@ivtv-driver.org
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
In-Reply-To: <1238297237.3235.42.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.58.0903290044380.28292@shell2.speakeasy.net>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
 <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>
 <63160.21731.qm@web56906.mail.re3.yahoo.com>  <1237251478.3303.37.camel@palomino.walls.org>
  <954486.20343.qm@web56908.mail.re3.yahoo.com>  <1237425168.3303.94.camel@palomino.walls.org>
  <de8cad4d0903220853v4b871e91x7de6efebfb376034@mail.gmail.com>
 <871136.15243.qm@web56908.mail.re3.yahoo.com> <1238297237.3235.42.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 28 Mar 2009, Andy Walls wrote:
> On Mon, 2009-03-23 at 06:52 -0700, Corey Taylor wrote:
> I found a race condition between the cx driver and the CX23418 firmware.
> I have a patch that mitigates the problem here:
>
> http://linuxtv.org/hg/~awalls/cx18/rev/9f5f44e0ce6c

> [ We have to do this polling wait because there is a race with the
> firmware.  Once we give it the SW1 interrupt above, it can wake up our
> waitq with an ack interrupt via the irq handler after we're ready to
> wait, but before we actually get put to sleep by schedule().  Loosing
> that race causes us to wait the entire timeout, waitng for a wakeup
> that's never going to come.  ]

A race like this should be avoidable.  The way it works is you do something
like this:

/* 1 */ set_current_state(TASK_INTERRUPTIBLE);
/* 2 */ cx18_write_reg_expect(cx, irq, SW1_INT_SET, irq, irq);
/* 3 */ schedule();
/* 4 */ ack_has_now_been_received();

The race you are talking about is when the ack arrives between line 2 and
3.  If this happens here, the process' current state is changed to
TASK_RUNNING when the irq hander that receives the ack tries to wake our
process.  If schedule() is called with the state set to TASK_RUNNING then
the process doesn't sleep.  And thus there is no race.  The key is that
preparing to sleep at line 1 happens before we start the event we want to
wait for at line 2.

wait_event() should take care of this.  wait_event(q, test) basically does:

for(;;) {
	// point A
	add_me_to_waitqueue(q);
	set_current_state(TASK_UNINTERRUPTIBLE);
	if (test)
		break;
	// point B
	schedule();
}
clean_up_wait_stuff();

If your event occurs and wake_up() is called at point A, then the test
should be true when it's checked and schedule() is never called.  If the
event happens at point B, then the process' state will have been changed to
TASK_RUNNING by wake_up(), remember it's already on the waitqueue at this
point, and schedule() won't sleep.

I think what's probably happening is the test, cx18_readl(cx, &mb->ack) ==
cx18_readl(cx, &mb->request), is somehow not true even though the ack has
been received.  Maybe a new request was added?

I think calling wait_event()'s with something that tests a hardware
register is a little iffy.  It's better if the irq handler sets some driver
state flag (atomically!) that indicates the event you were waiting for has
happened and then you check that flag.
