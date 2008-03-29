Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2T5aNpD027987
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 01:36:23 -0400
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2T5aB9g028629
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 01:36:12 -0400
Received: by qb-out-0506.google.com with SMTP id o12so5265019qba.17
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 22:36:11 -0700 (PDT)
Date: Fri, 28 Mar 2008 22:35:20 -0700
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080329053520.GB4470@plankton.ifup.org>
References: <patchbomb.1206699511@localhost>
	<304e0a371d12f77e1575.1206699518@localhost>
	<20080328153442.58b2c108@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328153442.58b2c108@gaivota>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [PATCH 7 of 9] vivi: Simplify the vivi driver and avoid
	deadlocks
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

On 15:34 Fri 28 Mar 2008, Mauro Carvalho Chehab wrote:
> This is under copyright (2006), as if you were one of the authors of the
> original driver. Also, I prefer if you add a short line bellow your copyright
> for the job you've done on the driver. Something like:
> 
> + *
> + *  Copyright (c) 2008 by Brandon Philips <brandon@ifup.org>
> + *       - Fix bad locks and cleans up streaming code

Ok, this is fixed in the patch I just sent.  I didn't add the
"changelog" entry below the copyright because the git-log will show what
I did.

> > -static int restart_video_queue(struct vivi_dmaqueue *dma_q)
> > -{
> ...
> > -}
> 
> While the restart and timeout code is not needed on vivi driver, IMO, we should
> keep it, since the main reason for this driver is to be a reference code. 

I couldn't figure out how it worked well enough to fix it.   In
particular code similar to the following is copied around throughout
several drivers and I have no idea what it does:  

@@ -785,45 +657,12 @@ buffer_queue(struct videobuf_queue *vq, 
-       if (!list_empty(&vidq->queued)) {
-               dprintk(dev, 1, "adding vb queue=0x%08lx\n",
-                       (unsigned long)&buf->vb.queue);
-               list_add_tail(&buf->vb.queue, &vidq->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(dev, 2, "[%p/%d] buffer_queue - append to queued\n",
-                       buf, buf->vb.i);
-       } else if (list_empty(&vidq->active)) {
-               list_add_tail(&buf->vb.queue, &vidq->active);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               mod_timer(&vidq->timeout, jiffies+BUFFER_TIMEOUT);
-               dprintk(dev, 2, "[%p/%d] buffer_queue - first active\n",
-                       buf, buf->vb.i);
-
-               vivi_start_thread(vidq);
-       } else {
-               prev = list_entry(vidq->active.prev,
-                                 struct vivi_buffer, vb.queue);
-               if (prev->vb.width  == buf->vb.width  &&
-                   prev->vb.height == buf->vb.height &&
-                   prev->fmt       == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &vidq->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       dprintk(dev, 2,
-                               "[%p/%d] buffer_queue - append to active\n",
-                               buf, buf->vb.i);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &vidq->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(dev, 2,
-                               "[%p/%d] buffer_queue - first queued\n",
-                               buf, buf->vb.i);
-               }
-       }

What is the difference between VIDEOBUF_ACTIVE and VIDEOBUF_QUEUED?

> This kind of code is important on real drivers, since the IRQ's may not be called
> for some reason. On cx88 and on saa7134, this happens on several situations[2]. 

Yes, I agree.  But, as I said I couldn't figure it out.

> Without a timeout, the driver will wait forever to receive a buffer.

Well, yes on real hardware.  But, in the case of vivi we can just create
the frames as they are needed.  It is dead simple for a fake device :D

> This task is also needed by tm6000 driver, for the same reasons.

Huh?  What task?

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
