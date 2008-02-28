Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1S2w9Wi022038
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 21:58:09 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1S2vbdv006440
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 21:57:37 -0500
Received: by ug-out-1314.google.com with SMTP id t39so87508ugd.6
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 18:57:37 -0800 (PST)
Date: Wed, 27 Feb 2008 18:56:51 -0800
From: Brandon Philips <brandon@ifup.org>
To: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20080228025651.GA16322@plankton.ifup.org>
References: <54fa1a0d9c5bcdfcb2ba.1204098881@localhost>
	<20679.1204128530@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20679.1204128530@vena.lwn.net>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	mchehab@infradead.org
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

On 09:08 Wed 27 Feb 2008, Jonathan Corbet wrote:
> Brandon Philips <brandon@ifup.org> wrote:
> 
> >  	buf = list_entry(q->stream.next, struct videobuf_buffer, stream);
> > +	mutex_unlock(&q->vb_lock);
> >  	retval = videobuf_waiton(buf, nonblocking, 1);
> > +	mutex_lock(&q->vb_lock);
> 
> Are you sure that this doesn't create a race where two threads could end
> up waiting on the same buf?  

You are right... I thought I had thought through this but a race can be
created with two threads doing DQBUF.

> Actually, almost anything could happen to buf by the time you've
> gotten the mutex back - it might not even exist anymore - but there
> are no checks for that.  It seems like a better fix might be to set
> nonblocking unconditionally to 1 for the videobuf_waiton() call, then
> start over from the beginning on a -EAGAIN return (if the caller has
> not requested nonblocking behavior).

Hrm, that is one solution.  I will think about it for a bit and submit a
new patch.

Thanks for catching this, I was being stupid.

Mauro: Please don't push this patch out.  Thanks.

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
