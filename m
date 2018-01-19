Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:45762 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753332AbeASNnc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 08:43:32 -0500
Date: Fri, 19 Jan 2018 11:43:13 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH v7 5/6] [media] vb2: add out-fence support to QBUF
Message-ID: <20180119134313.GE9598@jade>
References: <20180110160732.7722-1-gustavo@padovan.org>
 <20180110160732.7722-6-gustavo@padovan.org>
 <CAPBb6MU-83QXHht_gLciGzfZtNxJL_=Fj5h1yfwPEt3vSKHVXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPBb6MU-83QXHht_gLciGzfZtNxJL_=Fj5h1yfwPEt3vSKHVXg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-01-15 Alexandre Courbot <acourbot@chromium.org>:

> On Thu, Jan 11, 2018 at 1:07 AM, Gustavo Padovan <gustavo@padovan.org> wrote:
> >  /*
> >   * vb2_start_streaming() - Attempt to start streaming.
> >   * @q:         videobuf2 queue
> > @@ -1489,18 +1562,16 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> >         if (vb->in_fence) {
> >                 ret = dma_fence_add_callback(vb->in_fence, &vb->fence_cb,
> >                                              vb2_qbuf_fence_cb);
> > -               if (ret == -EINVAL) {
> > +               /* is the fence signaled? */
> > +               if (ret == -ENOENT) {
> > +                       dma_fence_put(vb->in_fence);
> > +                       vb->in_fence = NULL;
> > +               } else if (ret) {
> >                         spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> >                         goto err;
> > -               } else if (!ret) {
> > -                       goto fill;
> >                 }
> > -
> > -               dma_fence_put(vb->in_fence);
> > -               vb->in_fence = NULL;
> 
> This chunk seems to deal with input fences, shouldn't it be part of
> the previous patch instead of this one?
> 
> >
> > -       if ((b->fence_fd != 0 && b->fence_fd != -1) &&
> > -           !(b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
> > +       if (b->fence_fd > 0 && !(b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
> >                 dprintk(1, "%s: fence_fd set without IN_FENCE flag\n", opname);
> >                 return -EINVAL;
> >         }
> >
> > +       if (b->fence_fd == -1 && (b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
> > +               dprintk(1, "%s: IN_FENCE flag set but no fence_fd\n", opname);
> > +               return -EINVAL;
> > +       }
> > +
> 
> Same here?
> 
> >         return __verify_planes_array(q->bufs[b->index], b);
> >  }
> >
> > @@ -212,7 +216,12 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
> >         b->sequence = vbuf->sequence;
> >         b->reserved = 0;
> >
> > -       b->fence_fd = 0;
> > +       if (b->flags & V4L2_BUF_FLAG_OUT_FENCE) {
> > +               b->fence_fd = vb->out_fence_fd;
> > +       } else {
> > +               b->fence_fd = 0;
> > +       }
> 
> Sorry if this has already been discussed, but I don't remember the
> outcome if it has.
> 
> I wonder if doing this here could not make out_fence_fd leak in
> situations where we don't need/want it to. Let's take for instance a
> multi-process user program. One process queues a buffer with an
> OUT_FENCE and gets a valid fd in fence_fd upon return. Then the other
> process performs a QUERYBUF and gets the same fence_fd - which is
> invalid in its context. Would it not be preferable fill the out fence
> information only when queuing buffers, since it is the only time where
> we are guaranteed it will be usable by the caller?
> 
> Similarly, when a buffer is processed and user-space performs a DQBUF,
> the V4L2_BUF_FLAG_OUT_FENCE will be set but fence_fd will be 0. Again,
> limiting the return of out fence information to QBUF would prevent
> this.

Right. So in summary as this is something Hans commented on another
e-mail in this thread.

Your proposal is to only return the out_fence fd number on QBUF, right?
And DQBUF and QUERYBUF would only return -1 in the fence_fd field.

What I understood from Hans comment is that he is okay with sharing the
fd in such cases and v4l2 already does that for dmabuf fds.

I believe sharing is okay, as it will be either the same process or a
process we gave the device fd in the first place.

I'm not invested in any particular approach here. Thoughts?

> 
> If we go that route, out_fence_fd could maybe become a local variable
> of vb2_qbuf() instead of being a member of vb2_buffer, and would be
> returned by vb2_setup_out_fence(). This would guarantee it does not
> leak anywhere else.


Gustavo
