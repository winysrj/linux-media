Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TG0b3D032297
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 12:00:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TG0RS3026980
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 12:00:27 -0400
Date: Tue, 29 Jul 2008 13:00:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Message-ID: <20080729130013.1c61f79f@gaivota>
In-Reply-To: <488E46BC.10104@gmail.com>
References: <488721F2.5000509@hhs.nl> <20080728214927.GA21280@vidsoft.de>
	<488E4090.5020600@gmail.com> <20080728221628.GB21280@vidsoft.de>
	<488E46BC.10104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Brandon Philips <bphilips@suse.de>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	v4l2 library <v4l2-library@linuxtv.org>
Subject: Re: [V4l2-library] Messed up syscall return value
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

On Tue, 29 Jul 2008 00:22:52 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 07/29/2008 12:16 AM, Gregor Jasny wrote:
> > ioctl(3, VIDIOC_REQBUFS or VT_DISALLOCATE, 0x7fffbfda0060) = 2
> > 
> > Huh? Something evils seems to be going on in V4L2 land.
> > I've spotted the following lines in videobuf-core.c:videobuf_reqbufs
> > 
> >         req->count = retval;
> > 
> >  done:
> >         mutex_unlock(&q->vb_lock);
> >         return retval;
> > 
> > That would explain the retval '2'. It seems a retval = 0; statement is missing here for the success case.
> 
> Actually positive ioctl retval used to be often considered as OK in the past 
> (and this approach is still used in few char drivers).
> 
> But according to v4l docco, it isn't permitted here. Anyway I wouldn't place it 
> in videobuf-core.c, but in vivi code; letting this decision on Mauro (CCed) ;).

This is what videobuf-core do, if success:

        req->count = retval;

 done:
        mutex_unlock(&q->vb_lock);
        return retval;

So, it returns the number of buffers that were really allocated. It is too late
to change this, since this behaviour is very old. If the V4L2 API spec is
different, we should fix at the spec, not at the driver.

IMO, the library patch proposed should be applied. All error checks should test
for values lower than zero, since positive values don't indicate errors.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
