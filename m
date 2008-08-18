Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7I2xIH1010896
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 22:59:18 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7I2x7Ud025283
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 22:59:07 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200808172201.57105.hverkuil@xs4all.nl>
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<200808171141.05619.hverkuil@xs4all.nl>
	<1219000370.3747.76.camel@morgan.walls.org>
	<200808172201.57105.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sun, 17 Aug 2008 22:53:58 -0400
Message-Id: <1219028038.2700.40.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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

On Sun, 2008-08-17 at 22:01 +0200, Hans Verkuil wrote:
> On Sunday 17 August 2008 21:12:50 Andy Walls wrote:
> > On Sun, 2008-08-17 at 11:41 +0200, Hans Verkuil wrote:
> > > On Sunday 17 August 2008 04:13:24 Andy Walls wrote:
> > > > On Mon, 2008-08-11 at 17:33 -0400, Brandon Jenkins wrote:
> > > > > On Fri, Aug 8, 2008 at 10:18 AM, Andy Walls <awalls@radix.net>


> > See my concern above.  In brief, AFAICT, a system call on one
> > processor concurrent with interrupt service on another processor
> > requires the irq handler to obtain the proper lock before mucking
> > with the shared data structure.
> 
> You are completely right and I stand corrected. cx18_queue_find_buf (aka 
> cx18_queue_get_buf_irq) must have a spin_lock. So that spin_lock in 
> ivtv wasn't bogus either :-)
> 
> Damn, it's so easy to get confused with locking, even you've implemented 
> it several times already.

Yup.  And I found that "reading the code" without any sort of design
paperwork, design description, or reference textbooks makes locking
problems hard to spot.

I spent ~6 years on $BIG_PROJECT on a team maintaining highly
multithreaded applications that ran on an SMP machine.  The apps used
spinlocks, mutexes (with and without condition variables), semaphores,
rendezvous, etc.  A peer review of any significant code change usually
revealed at least one locking problem.


> That's a serious bug which needs to go into 2.6.27 (and probably to the 
> 2.6.26 stable series as well).
> 
> Andy, can you make a patch that adds the spin_lock to 
> cx18_queue_find_buf(). It's better to do it there rather than in the 
> interrupt routine.
> 
> Then that patch can go into v4l-dvb and from there to 2.6.27. The other 
> changes can come later.

Done.  Pull request submitted.


> Apologies for probably confusing you. I certainly confused myself.

No big deal.  I wasn't confused, but I did think I had missed something.


Regards,
Andy

> Regards,
> 
> 	Hans
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
