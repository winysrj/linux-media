Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:61791 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbZDCWrX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2009 18:47:23 -0400
Subject: When is a wake_up() not a wake up?
From: Andy Walls <awalls@radix.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 03 Apr 2009 18:48:44 -0400
Message-Id: <1238798924.3130.72.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.  I've got a problem where in the cx18 driver, the wake_up() call
doesn't seem to be waking up a process or work queue thread that tried
to wait on a wait queue.

While doing some investigation, I found I was unable to understand the
conditions under which try_to_wake_up() will return success or not.  Can
anyone give short summary on the conditions under which it does not?

FYI:
$ uname -a
Linux palomino.walls.org 2.6.27.9-159.fc10.x86_64 #1 SMP Tue Dec 16 14:47:52 EST 2008 x86_64 x86_64 x86_64 GNU/Linux


Also, just to provide some context on the larger problem, here's what's
supposed to happen in the cx18 driver:

1. A work queue thread or read() call needs to send a command to the
CX23418 using the cx18_api_call() function
2. It fills out a mailbox with a command for the CX23418
3. It prepares to wait, just in case a wait is needed
4. A SW1 interrupt is sent to the CX23418 telling it a mailbox is ready
5. The ack filed in the mailbox, a PCI MMIO location, is checked to see
if the mailbox was ack'ed already
6. If not, schedule_timeout() for up to 10 msecs (a near eternity...)
7. Clean up the wait and move on

In response to the SW1 interrupt in step 4 above, the CX23418 processes
the command mailbox, fills out the "ack" field in the mailbox with a
good value, and sends a SW2 ack interrupt back.  The cx18_irq_hander()
calls wake_up() in response to this.

However, I am running across occasions where the maximum timeout has
expired, and the mailbox has been ack'ed.  It's as if the wake_up()
didn't work.  Here's a sample from the log:


Mar 31 23:36:56 palomino kernel: cx18-0:  irq: sending interrupt SW1: 8 to send CX18_CPU_DE_SET_MDL
Mar 31 23:36:56 palomino kernel: cx18-0:  api: scheduling to wait for ack of CX18_CPU_DE_SET_MDL: req 51267 ack 51266, pid 21092, state 2
Mar 31 23:36:56 palomino kernel: cx18-0:  irq: received interrupts SW1: 0  SW2: 8  HW2: 0
Mar 31 23:36:56 palomino kernel: cx18-0:  irq: Wake up initiated on pid 21092 in state 2
Mar 31 23:36:56 palomino kernel: cx18-0:  irq: Wake up succeeded on pid 21092, state 2 -> 0
Mar 31 23:36:56 palomino kernel: cx18-0:  api: done wait for ack of CX18_CPU_DE_SET_MDL: req 51267 ack 51267, current pid 21092, current state 0, state 0
Mar 31 23:36:56 palomino kernel: cx18-0:  warning: failed to be awakened upon RPU acknowledgment sending CX18_CPU_DE_SET_MDL; timed out waiting 10 msecs

A wait of 10 msecs is not impossible I guess.  However, they should be
much less frequent that what I am seeing in my logs, given that this is
an ATSC video stream capture. 

Here's the highlights from a patched cx18 driver that I have in place to
try and see what's going on:

static int cx18_autoremove_wake_function(wait_queue_t *w, unsigned mode,
                                         int sync, void *key)
{
        struct cx18 *cx = key;
        struct task_struct *t = w->private;
        long old_state;
        int ret;

        old_state = t->state;
        CX18_DEBUG_HI_IRQ("Wake up initiated on pid %d in state %lx\n",
                          task_pid_nr(t), old_state);

        ret = default_wake_function(w, mode, sync, NULL);

        if (ret) {
                CX18_DEBUG_HI_IRQ("Wake up succeeded on pid %d, "
                                  "state %lx -> %lx\n",
                                  task_pid_nr(t), old_state, t->state);
                list_del_init(&w->task_list);
        } else {
                CX18_DEBUG_WARN("Wake up failed on pid %d, "
                                "state %lx -> %lx\n",
                                task_pid_nr(t), old_state, t->state);
        }
        return ret;
}

static int cx18_api_call(struct cx18 *cx, u32 cmd, int args, u32 data[])
{
        u32 state, irq, req, ack, err;
        struct cx18_mailbox __iomem *mb;
        wait_queue_head_t *waitq;
        struct mutex *mb_lock;
        long int timeout, ret;
        int i;
        wait_queue_t w;                               
	
	... 

	/* Setup pointers and values we need */
	waitq = &cx->mb_cpu_waitq;
        mb_lock = &cx->epu2cpu_mb_lock;
        irq = IRQ_EPU_TO_CPU;
        mb = &cx->scb->epu2cpu_mb;
	...

	/* Acquire the mutex for the mailbox, and put a request in it */
	/* blah blah blah */
	...

	timeout = msecs_to_jiffies(10);
        CX18_DEBUG_HI_IRQ("sending interrupt SW1: %x to send %s\n",
                          irq, info->name);
        ret = timeout;

	/* setup for a wait */
        init_wait(&w);
        w.func = cx18_autoremove_wake_function;
        prepare_to_wait(waitq, &w, TASK_UNINTERRUPTIBLE);

	/* Tell the device our request is in it's mailbox */
        cx18_write_reg_expect(cx, irq, SW1_INT_SET, irq, irq);

	/* Did it ack our request already? */
        ack = cx18_readl(cx, &mb->ack);
        if (req != ack) {
                CX18_DEBUG_HI_API("scheduling to wait for ack of %s: req %u "
                                  "ack %u, pid %u, state %lx\n",
                                  info->name, req, ack,
                                  task_pid_nr(w.private),
                                  ((struct task_struct *)(w.private))->state);

		/* Go to sleep.  Wake up when the ack IRQ comes in or timeout */
                ret = schedule_timeout(timeout);
                ack = cx18_readl(cx, &mb->ack);

                CX18_DEBUG_HI_API("done wait for ack of %s: req %u "
                                  "ack %u, current pid %u, current state %lx, "
                                  "state %lx\n",
                                  info->name, req, ack,
                                  task_pid_nr(current),
                                  current->state,
                                  ((struct task_struct *)(w.private))->state);
        }
	finish_wait(waitq, &w);

	if (req != ack) {
		/* Release mutex, Log stuff */
		return -EINVAL;
	}
	
	if (ret == 0)
	        CX18_DEBUG_WARN("failed to be awakened upon RPU acknowledgment "
                                "sending %s; timed out waiting %d msecs\n",
                                info->name, jiffies_to_msecs(timeout));
	...
	/* Unlock mutex, do other stuff */
	return 0;
}



/* A simplified version of the IRQ handler for this ML post */
irqreturn_t cx18_irq_handler(int irq, void *dev_id)
{
        struct cx18 *cx = (struct cx18 *)dev_id;
        u32 sw1, sw2, hw2;
	...
        sw2 = cx18_read_reg(cx, SW2_INT_STATUS) & cx->sw2_irq_mask;
	...
        if (sw2)
                cx18_write_reg_expect(cx, sw2, SW2_INT_STATUS, ~sw2, sw2);
	...
        if (sw1 || sw2 || hw2)
                CX18_DEBUG_HI_IRQ("received interrupts "
                                  "SW1: %x  SW2: %x  HW2: %x\n", sw1, sw2, hw2);
	...
	/* Did we get a mailbox ack? */
        if (sw2 & IRQ_CPU_TO_EPU_ACK)
                __wake_up(&cx->mb_cpu_waitq, TASK_NORMAL, 1, cx);
	...
        return (sw1 || sw2 || hw2) ? IRQ_HANDLED : IRQ_NONE;
}



Regards,
Andy

