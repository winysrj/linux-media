Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab3DZKEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 06:04:33 -0400
Date: Fri, 26 Apr 2013 12:04:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: vishwanath chandapur <vishwavtu@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: Kernel Patch:do not wait for interrupt when releasing buffers
In-Reply-To: <CALQBcOdvTqyg3JzoaQ2FxgAW87Sy_rTWEZg3HtNg7O9iQuZ4hg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1304261204180.32752@axis700.grange>
References: <CALQBcOeQGpwfweM9yOdZ+G-68wbKPiyArULwEAN3Qu+WHrFXVQ@mail.gmail.com>
 <Pine.LNX.4.64.1304261139150.32752@axis700.grange>
 <CALQBcOcj1Ry5hbs=cGxVisVYvk_=TKvYcnKF4OYmcAVJY3qgnQ@mail.gmail.com>
 <Pine.LNX.4.64.1304261153280.32752@axis700.grange>
 <CALQBcOdvTqyg3JzoaQ2FxgAW87Sy_rTWEZg3HtNg7O9iQuZ4hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 26 Apr 2013, vishwanath chandapur wrote:

> Yes it is 3.0
> 
> >>please update and re-test.
> Please let me know which version i need to update,

Please, see my first reply to you.

Thanks
Guennadi

> 
> Thanks
> Vishwa
> 
> 
> On Fri, Apr 26, 2013 at 3:23 PM, Guennadi Liakhovetski <
> g.liakhovetski@gmx.de> wrote:
> 
> > On Fri, 26 Apr 2013, vishwanath chandapur wrote:
> >
> > >  Hi Guennadi,
> > >
> > > Thank you for reply
> > >
> > > Sorry that was typo mistake .
> > > Kernel Version :3.0.8
> >
> > So, it is 3.0? Sorry, please update and re-test.
> >
> > Thanks
> > Guennadi
> >
> > >
> > >
> > > Br
> > > Vishwa
> > >
> > >
> > > On Fri, Apr 26, 2013 at 3:13 PM, Guennadi Liakhovetski <
> > > g.liakhovetski@gmx.de> wrote:
> > >
> > > > Hi
> > > >
> > > > On Fri, 26 Apr 2013, vishwanath chandapur wrote:
> > > >
> > > > > Hi,
> > > > > Sorry my english is poor.
> > > > >
> > > > > This is vishawanath , I have a bug in camera module    ,When ever vb
> > is
> > > > > NULL in sh_mobile_ceu_irq. device will reboot. It seems there is a
> > > > > race condition ,Since we are not clearing the interrupt,the  same
> > > > interrupt
> > > > > occurs continuously and rate of interrupt is also high (30 per
> > > > > Micros seconds ),this not allowing to schedule other tasks ,Finally
> > > >  device
> > > > > reboots with WATCH DOG NMI interrupt.
> > > > >
> > > > >
> > > > > Help on this will be greatly appreciated,As we are struggling to
> > solve
> > > > this
> > > > > bug from last 2 months.
> > > > > Kernel Version :3.0.8
> > > >
> > > > Sorry, do you _really_ mean kernel 3.0(.8)? Not 3.8(.0)? If so, I'm
> > > > afraid, I have to ask you to re-test with a recent kernel - best with
> > > > current Linus' mainline 3.9-rcX, at least with 3.8. If it was a typo
> > and
> > > > you did mean 3.8, please, try to re-send in such a way, that your patch
> > > > doesn't get corrupt as in this your mail. Also, please, add
> > > >
> > > > Linux Media Mailing List <linux-media@vger.kernel.org>
> > > >
> > > > to CC.
> > > >
> > > > Thanks
> > > > Guennadi
> > > >
> > > > >
> > > > > Please let me for more info on this issue.
> > > > >
> > > > >
> > > > > if (!vb)              /* Stale interrupt from a released buffer */
> > <----
> > > > Reboot               goto out;
> > > > >
> > > > > diff --git a/drivers/media/video/sh_mobile_ceu_camera.c
> > > > > b/drivers/media/video/sh_mobile_ceu_camera.cindex d890f8d..67c7dcd
> > > > > 100644--- a/drivers/media/video/sh_mobile_ceu_camera.c+++
> > > > > b/drivers/media/video/sh_mobile_ceu_camera.c@@ -296,8 +306,8 @@
> > > > > static void sh_mobile_ceu_videobuf_queue(struct videobuf_queue *vq,
> > > > >       dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
> > > > >               vb, vb->baddr, vb->bsize);
> > > > >  -    vb->state = VIDEOBUF_QUEUED;
> > > > >       spin_lock_irqsave(&pcdev->lock, flags);+        vb->state =
> > > > VIDEOBUF_QUEUED;
> > > > >       list_add_tail(&vb->queue, &pcdev->capture);
> > > > >
> > > > >       if (!pcdev->active) {@@ -311,6 +321,27 @@  static void
> > > > > sh_mobile_ceu_videobuf_queue(struct videobuf_queue *vq,
> > > > >  static void sh_mobile_ceu_videobuf_release(struct videobuf_queue
> > *vq,
> > > > >                                          struct videobuf_buffer *vb)
> > > > >  {+   struct soc_camera_device *icd = vq->priv_data;+ struct
> > > > > soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);+  struct
> > > > > sh_mobile_ceu_dev *pcdev = ici->priv;+        unsigned long
> > > > > flags;++      spin_lock_irqsave(&pcdev->lock, flags);++       if
> > > > (pcdev->active
> > > > > == vb) {+             /* disable capture (release DMA buffer), reset
> > > > > */+           ceu_write(pcdev, CAPSR, 1 << 16);+
> > > >  pcdev->active = NULL;+  }++     if
> > > > > ((vb->state == VIDEOBUF_ACTIVE || vb->state == VIDEOBUF_QUEUED) &&+
> > > > >  !list_empty(&vb->queue)) {+          vb->state =
> > > > > VIDEOBUF_ERROR;+              list_del_init(&vb->queue);+     }++
> > > > spin_unlock_irqrestore(&pcdev->lock,
> > > > > flags);+
> > > > >       free_buffer(vq, container_of(vb, struct sh_mobile_ceu_buffer,
> > vb));
> > > > >  }
> > > > >  @@ -330,6 +361,10 @@  static irqreturn_t sh_mobile_ceu_irq(int irq,
> > > > void *data)
> > > > >       spin_lock_irqsave(&pcdev->lock, flags);
> > > > >
> > > > >       vb = pcdev->active;+    if (!vb)+               /* Stale
> > interrupt
> > > > from a released
> > > > > buffer */+            goto out;+
> > > > >       list_del_init(&vb->queue);
> > > > >
> > > > >       if (!list_empty(&pcdev->capture))@@ -344,6 +379,8 @@  static
> > > > > irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
> > > > >       do_gettimeofday(&vb->ts);
> > > > >       vb->field_count++;
> > > > >       wake_up(&vb->done);++out:
> > > > >       spin_unlock_irqrestore(&pcdev->lock, flags);
> > > > >
> > > > >       return IRQ_HANDLED;
> > > > >
> > > >
> > > > ---
> > > > Guennadi Liakhovetski, Ph.D.
> > > > Freelance Open-Source Software Developer
> > > > http://www.open-technology.de/
> > > >
> > >
> >
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> >
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
