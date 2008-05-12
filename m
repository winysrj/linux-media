Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CNKTOT013170
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 19:20:29 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4CNKGSA021630
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 19:20:16 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200805121648.59225.hverkuil@xs4all.nl>
References: <481B1027.1040002@linuxtv.org> <481B31CC.6090606@linuxtv.org>
	<48285754.8010608@linuxtv.org> <200805121648.59225.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 12 May 2008 19:20:01 -0400
Message-Id: <1210634401.3194.30.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Steven Toth <stoth@hauppauge.com>, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: cx18-0: ioremap failed, perhaps increasing __VMALLOC_RESERVE
	in page.h
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

On Mon, 2008-05-12 at 16:48 +0200, Hans Verkuil wrote:
> On Monday 12 May 2008 16:42:28 Steven Toth wrote:
> > Steven Toth wrote:
> > >>         if (cx->dev)
> > >>                 cx18_iounmap(cx);
> > >
> > > This doesn't feel right.
> >
> > Hans / Andy,
> >
> > Any comments?
> >
> > - Steve
> 
> 
> This conditional is indeed bogus. I've just removed it in my v4l-dvb 
> tree.
> 
> Regards,
> 
> 	Hans


I noticed it was bogus a while ago.  See my comment near the end of
this:

https://www.redhat.com/mailman/private/video4linux-list/2008-May/msg00026.html


Given that "cx->dev->irq" dereference would cause a kernel oops before
the "if(cx->dev)" reference prevents an iounmap() from happening, I
don't have high hopes it will solve Mike's problem.  Even if compiler
optimization reorders calls, the oops should happen if cx->dev == NULL.
(It's still worth getting rid of the bogus check though.)

It could very well be the case however, that the contents of cx->enc_mem
has been corrupted, in which case the iounmap() won't free the proper
memory region. Sooo....


Mike,

Could you add a log statement to output the value of "cx->enc_mem"
before and after the call to cx18_iounmap() in
cx18_driver.c:cx18_remove() ?

It should match the memory address displayed when the driver was loaded
with debug "info" enabled.



Hans,

In researching Mike's problem, I noticed that the cx18_probe() function
leaks struct cx18 allocations and cx18_cards[] entries on error exits.
I posted 2 patches to the ivtv-devel list.  The 2nd one is the preferred
fix; the first was too complex.  See

http://www.ivtvdriver.org/pipermail/ivtv-devel/2008-May/005530.html


Also, I've run across a corruption problem with cx->capturing being
greater than 0 when no captures were going on, on 4 separate occasions.
(I can't reproduce it on demand though.)  I'm still trying to track the
source, but the indication is MythTV getting an EBUSY returned when it
tries to do a VIDIOC_S_FMT when trying to start cx18 analog capture.
The EBUSY is at cx18-ioctl.c:cx18_try_or_set_fmt() at line 257.



Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
