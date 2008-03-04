Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m24Dk0MF007414
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 08:46:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m24DjSOi030955
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 08:45:28 -0500
Date: Tue, 4 Mar 2008 10:45:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080304104516.21fcf30f@gaivota>
In-Reply-To: <20080303081305.GA18774@plankton.ifup.org>
References: <54fa1a0d9c5bcdfcb2ba.1204098881@localhost>
	<20679.1204128530@vena.lwn.net>
	<20080228025651.GA16322@plankton.ifup.org>
	<20080229063458.0f49ddb0@areia>
	<20080303081305.GA18774@plankton.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] v4l: Deadlock in videobuf-core for DQBUF waiting on QBUF
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

On Mon, 3 Mar 2008 00:13:05 -0800
Brandon Philips <brandon@ifup.org> wrote:

> On 06:34 Fri 29 Feb 2008, Mauro Carvalho Chehab wrote:
> > On Wed, 27 Feb 2008 18:56:51 -0800
> > Brandon Philips <brandon@ifup.org> wrote:
> > 
> > > On 09:08 Wed 27 Feb 2008, Jonathan Corbet wrote:
> > > > Brandon Philips <brandon@ifup.org> wrote:
> > > > 
> > > > >  	buf = list_entry(q->stream.next, struct videobuf_buffer, stream);
> > > > > +	mutex_unlock(&q->vb_lock);
> > > > >  	retval = videobuf_waiton(buf, nonblocking, 1);
> > > > > +	mutex_lock(&q->vb_lock);
> > > > 
> > > > Are you sure that this doesn't create a race where two threads could end
> > > > up waiting on the same buf?  
> > > 
> > > You are right... I thought I had thought through this but a race can be
> > > created with two threads doing DQBUF.
> > > 
> > > > Actually, almost anything could happen to buf by the time you've
> > > > gotten the mutex back - it might not even exist anymore - but there
> > > > are no checks for that.  It seems like a better fix might be to set
> > > > nonblocking unconditionally to 1 for the videobuf_waiton() call, then
> > > > start over from the beginning on a -EAGAIN return (if the caller has
> > > > not requested nonblocking behavior).
> > > 
> > > Hrm, that is one solution.  I will think about it for a bit and submit a
> > > new patch.
> > > 
> > > Thanks for catching this, I was being stupid.
> > > 
> > > Mauro: Please don't push this patch out.  Thanks.
> > 
> > The patch were already applied at the staging tree. I'll keep it there until we
> > have a definitive solution. After that, the better would be to fold the both
> > patches and send to 2.6.25-rc.
> 
> Quick update:
> 
> Sorry for the delay I was mentoring my robotics team since Thursday.
> 
> I wrote a test program (attached, super hacky) and I have found that the
> current vivi can easily hang a kernel on a spinlock even before my
> patch...

Argh!
> 
> I will work on fixing this tomorrow before fixing the videobuf issue.  I
> would like to be able to test my fix before submitting it this time.
This would be nice.

About your testing program, it would be a good idea to add it at v4l2-apps/test
dir. The original non-threaded code from V4L2 specs is also there.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
