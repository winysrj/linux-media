Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HK2wfM020438
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 16:02:58 -0400
Received: from smtp-vbr13.xs4all.nl (smtp-vbr13.xs4all.nl [194.109.24.33])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HK2iJP007730
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 16:02:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Date: Sun, 17 Aug 2008 22:01:57 +0200
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<200808171141.05619.hverkuil@xs4all.nl>
	<1219000370.3747.76.camel@morgan.walls.org>
In-Reply-To: <1219000370.3747.76.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808172201.57105.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	ivtv-devel@ivtvdriver.org
Subject: Re: CX18 Oops
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sunday 17 August 2008 21:12:50 Andy Walls wrote:
> On Sun, 2008-08-17 at 11:41 +0200, Hans Verkuil wrote:
> > On Sunday 17 August 2008 04:13:24 Andy Walls wrote:
> > > On Mon, 2008-08-11 at 17:33 -0400, Brandon Jenkins wrote:
> > > > On Fri, Aug 8, 2008 at 10:18 AM, Andy Walls <awalls@radix.net>
> >
> > wrote:
> > > I have updated my repo at
> > >
> > > http://linuxtv.org/hg/~awalls/v4l-dvb
> > >
> > > with 3 changes:
> > >
> > > 1. Back out the original band aid fix
> > > 2. Simplify the queue flush routines (you will not see that oops
> > > again)
> >
> > Nice! Cleans it up considerably.
> >
> :)
> :
> > > 3. Fix the interrupt handler to obtain a queue lock (prevents
> > > queue corruption)
> >
> > No, that is not the bug.
>
> Yeah, it is not *the* bug I was after, but pending further discussion
> below I'll maintain it is a bug.
>
>
> I really want to do a full audit of all the queue manipulations in
> the driver.  I'll try to find some time when I'm offline this week.
>
> (Thanks for all the comments BTW!)
>
> > I'm pretty sure that the real bug is that the
> > old cx18_queue_move() function didn't use a spin_lock_irqsave(). I
> > think that it was possible for an interrupt to arrive when the CPU
> > was in the middle of a cx18_queue_move().
>
> On the surface it did look OK since all the interrupts for that
> stream *should* have been stopped.  But after some hypothetical
> thought about how the encoder might not stop right away and looking
> at Jeff's logs where a new capture may have been started before the
> queue flush was done, it's safer just to have the queue flush routine
> to acquire the lock.  Since the queue flush routine in question is
> called very infrequently, there's not much of a time penalty.
>
> >  A spinlock in an interrupt
> > handler is usually bogus (and that includes the one in the ivtv irq
> > handler, I've just realized).
>
> Chapter 5 of _Understanding_the_Linux_Kernel_ (2nd edition) on page
> 185 & 188 mentions that to protect data structures, being accessed by
> both exceptions (like open/close/read/write/poll induced INT 0x80
> exceptions on Intel) and interrupt handlers on a MP system, a
> spinlock needs to be used.  The book also mentions that a semaphore
> (now a mutex) is sometimes preferable in this case, where the
> interrupt routine polls the semaphore in a tight loop like a
> spinlock, but the system calls use the semaphore normally and are
> allowed to sleep.
>
> > What I am uneasy about, though, is why an interrupt could arrive
> > while in the cx18_queue_move() function. In principle this function
> > should only be called when the capture has stopped. I think it
> > might be a good idea to debug this: is it possible for interrupts
> > to arrive after the capture was stopped? Or is it possible for
> > cx18_queue_move() to be called when a capture is still in progress?
>
> Right.  I should really test to see if this actually happens.  Since
> spinlocks are supposedly optimized for the case of the lock being
> available and the cx18_queue_move() is called infrequently, leaving
> it in for now, should be OK.
>
> I also have difficulty reproducing the original oops, so my test
> results could be misleading.  I have no good criteria for terminating
> the experiment/testing and declaring "interrupts can't happen when we
> decide to flush queues".
>
> > I do think it is a good idea to rename cx18_queue_find_buf to
> > cx18_queue_get_buf_irq to denote that it 1) not just finds a buffer
> > but also removes it from the queue, and 2) it can only be called
> > safely from interrupt context.
>
> Agree.  I'll make that part of the final change.
>
> > > >From most of the output you provided, it was pretty obvious that
> > > > q_full
> > >
> > > was always claiming to have more buffers that it actually did.  I
> > > hypothesized this could come about at the end of a capture when
> > > the encoder hadn't really stopped transferring buffers yet (after
> > > we told it to stop) and then we try to clear q_full while the
> > > interrupt handler is still trying to add buffers.  This could
> > > happen because the interrupt handler never (ever) properly
> > > obtained a lock for manipulating the queues.  This could have
> > > been causing the queue corruption.
> > >
> > > Please test.  I need feedback that I haven't introduced a
> > > deadlock.
> > >
> > > It also appears that the last change requiring the interrupt
> > > handler to obtain a lock, completely mitigates me having to use
> > > the "-cache 8192" option to mplayer for digital captures, and
> > > greatly reduces the amount of cache I need to have mplayer use
> > > for analog captures.
> >
> > I suspect that it is the change before that one: adding a spinlock
> > to cx18_queue_move().
>
> I have a recollection that in my incremental testing that this was
> not the case.  It was actually the spinlock in the irq handler that
> made things better.  But it was late and I was tired.  I'll retest
> and run my blocking read timing test to see if I can see a difference
> in the numbers for a few cases.
>
> >  The spinlock in the interrupt handler doesn't do
> > anything. It would only be useful if you could have two independent
> > interrupt handlers that both needed access to that resource. But
> > that is not the case here.
>
> I agree that 2+ interrupt handlers could not access that resource
> concurrently.  But, AFAICT, a system call on one processor and the
> interrupt handler on the other processor can access the queues
> concurrently.
>
> It's my understanding that spin_lock_irqsave() and spin_lock_irq()
> only disable local interrupts for the particular CPU and not
> globally.  So here's the case I think needs a spinlock lock in the
> irq handler:
>
> 1. A capture is in progress
>
> 2. Application on CPU #0 issues a read(). cx18_dequeue() is
> ultimately called on q_full.  cx18_dequeue() calls
> spin_lock_irqsave(), disabling preemption, disabling local
> interrupts, and acquiring the lock, and begins manipulating q_full
>
> 3. At an inopportune time, an interrupt arrives from the encoder and
> is sent to CPU #1 for servicing.   In the cx18 driver, in an
> interrupt context, epu_dma_done() is eventually invoked.  Without
> obtaining a lock, epu_dma_done() calls cx18_queue_find_buf() and
> manipulates q_full. This manipulation of q_full happens while the
> system call on CPU #0 holds the lock and thinks things are safe.
>
>
> Given the above situation I think the interrupt handler does need to
> acquire the spinlock.  So, here's where people get to hit me with the
> clue-stick: in the above case, what do I have wrong?
>
> > > Hans,
> > > (or anyone else with expertise in using spinlocks withing an
> > > interrupt handler),
> > >
> > > Could you please provide comments on if I'm doing something wrong
> > > with the way I obtain the spinlock in the interrupt handler?
> >
> > See above :-)
> >
> > > http://linuxtv.org/hg/~awalls/v4l-dvb/rev/f3ada35200c0
> > >
> > > >From reading Bovet and Cesati's _Understanding_the_Linux_Kernel_
> > > > and
> > >
> > > Corbet, Rubini, and Kroah-Hartman's _Linux_Device_Drivers_ I
> > > think I've got it right.
> > >
> > > When the stream queues (q_full, q_io, and q_free) are accessed
> > > from the system call exception handler, I need to do a
> > > spin_lock_irqsave() to disable local CPU interrupts and protect
> > > access to the queues by kernel control paths on other CPU's. 
> > > When they stream queues are accessed by the interrupt handler on
> > > any CPU, the interrupt handler is serialized with respect to
> > > itself and need not disable any interrupts and simply obtain the
> > > lock via spin_lock() to protect against access from system call
> > > exceptions.
> >
> > System call exceptions? Not sure what you mean.
>
> As I understand it, on Intel platforms, when a user land application
> invokes read(), write(), or some other system call, said system call
> eventually invokes an INT 0x80 software exception to make the
> transition to kernel code and data space with the proper privileges.

Ah, I just call them 'system calls' :-)

> > AFAIK the interrupt
> > handler doesn't have to protect against anything.
>
> See my concern above.  In brief, AFAICT, a system call on one
> processor concurrent with interrupt service on another processor
> requires the irq handler to obtain the proper lock before mucking
> with the shared data structure.

You are completely right and I stand corrected. cx18_queue_find_buf (aka 
cx18_queue_get_buf_irq) must have a spin_lock. So that spin_lock in 
ivtv wasn't bogus either :-)

Damn, it's so easy to get confused with locking, even you've implemented 
it several times already.

That's a serious bug which needs to go into 2.6.27 (and probably to the 
2.6.26 stable series as well).

Andy, can you make a patch that adds the spin_lock to 
cx18_queue_find_buf(). It's better to do it there rather than in the 
interrupt routine.

Then that patch can go into v4l-dvb and from there to 2.6.27. The other 
changes can come later.

Apologies for probably confusing you. I certainly confused myself.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
