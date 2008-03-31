Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2VJaElw019082
	for <video4linux-list@redhat.com>; Mon, 31 Mar 2008 15:36:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2VJa3u7001869
	for <video4linux-list@redhat.com>; Mon, 31 Mar 2008 15:36:03 -0400
Date: Mon, 31 Mar 2008 16:35:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080331163550.0b0f7bd8@gaivota>
In-Reply-To: <20080329053520.GB4470@plankton.ifup.org>
References: <patchbomb.1206699511@localhost>
	<304e0a371d12f77e1575.1206699518@localhost>
	<20080328153442.58b2c108@gaivota>
	<20080329053520.GB4470@plankton.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

On Fri, 28 Mar 2008 22:35:20 -0700
Brandon Philips <brandon@ifup.org> wrote:

> On 15:34 Fri 28 Mar 2008, Mauro Carvalho Chehab wrote:
> > This is under copyright (2006), as if you were one of the authors of the
> > original driver. Also, I prefer if you add a short line bellow your copyright
> > for the job you've done on the driver. Something like:
> > 
> > + *
> > + *  Copyright (c) 2008 by Brandon Philips <brandon@ifup.org>
> > + *       - Fix bad locks and cleans up streaming code
> 
> Ok, this is fixed in the patch I just sent.
Ok.

>  I didn't add the
> "changelog" entry below the copyright because the git-log will show what
> I did.

I prefer if you do so. I had to much stress in the past due to those copyright
messages. I very much prefer to have a very short description, when newer
copyrights are added. This avoids later senseless discussions.

> > While the restart and timeout code is not needed on vivi driver, IMO, we should
> > keep it, since the main reason for this driver is to be a reference code. 
> 
> I couldn't figure out how it worked well enough to fix it.   In
> particular code similar to the following is copied around throughout
> several drivers and I have no idea what it does:  
> 
> @@ -785,45 +657,12 @@ buffer_queue(struct videobuf_queue *vq, 
> -       if (!list_empty(&vidq->queued)) {
> -               dprintk(dev, 1, "adding vb queue=0x%08lx\n",
> -                       (unsigned long)&buf->vb.queue);
> -               list_add_tail(&buf->vb.queue, &vidq->queued);
> -               buf->vb.state = VIDEOBUF_QUEUED;
> -               dprintk(dev, 2, "[%p/%d] buffer_queue - append to queued\n",
> -                       buf, buf->vb.i);
> -       } else if (list_empty(&vidq->active)) {
> -               list_add_tail(&buf->vb.queue, &vidq->active);
> -               buf->vb.state = VIDEOBUF_ACTIVE;
> -               mod_timer(&vidq->timeout, jiffies+BUFFER_TIMEOUT);
> -               dprintk(dev, 2, "[%p/%d] buffer_queue - first active\n",
> -                       buf, buf->vb.i);
> -
> -               vivi_start_thread(vidq);
> -       } else {
> -               prev = list_entry(vidq->active.prev,
> -                                 struct vivi_buffer, vb.queue);
> -               if (prev->vb.width  == buf->vb.width  &&
> -                   prev->vb.height == buf->vb.height &&
> -                   prev->fmt       == buf->fmt) {
> -                       list_add_tail(&buf->vb.queue, &vidq->active);
> -                       buf->vb.state = VIDEOBUF_ACTIVE;
> -                       dprintk(dev, 2,
> -                               "[%p/%d] buffer_queue - append to active\n",
> -                               buf, buf->vb.i);
> -
> -               } else {
> -                       list_add_tail(&buf->vb.queue, &vidq->queued);
> -                       buf->vb.state = VIDEOBUF_QUEUED;
> -                       dprintk(dev, 2,
> -                               "[%p/%d] buffer_queue - first queued\n",
> -                               buf, buf->vb.i);
> -               }
> -       }
> 
> What is the difference between VIDEOBUF_ACTIVE and VIDEOBUF_QUEUED?
I think we can later try to simplify the state machine. From what I understood,
VIDEOBUF_ACTIVE is used to indicate that a driver started, but hasn't yet
received anything.

About the same logic used on vivi is present also on bttv, cx88 and saa7134.

> Well, yes on real hardware.  But, in the case of vivi we can just create
> the frames as they are needed.  It is dead simple for a fake device :D

 
> > This task is also needed by tm6000 driver, for the same reasons.
> 
> Huh?  What task?

I mean the watchdog task. If the device stops sending streams for more than a
certain amount of time [1], a task is wake. This task unblocks the userspace app
(this returns an error to userspace), and tries to restart the streaming.

[1] Since a TV device is expected to receive 25 to 30 frames/sec, In thesis,
you should have a frame on each 33 ms or 40ms. The watchdog is configured to a
higher value (for example, 500ms), since, on real devices, some frames could be
lost due to bad signal.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
