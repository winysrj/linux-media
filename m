Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34921 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1CAKyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 05:54:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [RFC/PATCH 1/2] v4l: videobuf2: Handle buf_queue errors
Date: Tue, 1 Mar 2011 11:54:19 +0100
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	hverkuil@xs4all.nl
References: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com> <1298830353-9797-2-git-send-email-laurent.pinchart@ideasonboard.com> <AANLkTimx+MBg4qPHzubOCrAe7vDsic8_ot99NOxOWDHD@mail.gmail.com>
In-Reply-To: <AANLkTimx+MBg4qPHzubOCrAe7vDsic8_ot99NOxOWDHD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011154.19883.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Pawel,

On Monday 28 February 2011 16:44:38 Pawel Osciak wrote:
> Hi Laurent,
> A few questions from me below. I feel we need to talk about this
> change a bit more, it introduces some recovery and consistency
> problems, unless I'm missing something.
> 
> On Sun, Feb 27, 2011 at 10:12, Laurent Pinchart wrote:
> > videobuf2 expects drivers to check buffer in the buf_prepare operation
> > and to return success only if the buffer can queued without any issue.
> > 
> > For hot-pluggable devices, disconnection events need to be handled at
> > buf_queue time. Checking the disconnected flag and adding the buffer to
> > the driver queue need to be performed without releasing the driver
> > spinlock, otherwise race conditions can occur in which the driver could
> > still allow a buffer to be queued after the disconnected flag has been
> > set, resulting in a hang during the next DQBUF operation.
> > 
> > This problem can be solved either in the videobuf2 core or in the device
> > drivers. To avoid adding a spinlock to videobuf2, make buf_queue return
> > an int and handle buf_queue failures in videobuf2. Drivers must not
> > return an error in buf_queue if the condition leading to the error can
> > be caught in buf_prepare.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  drivers/media/video/videobuf2-core.c |   32
> > ++++++++++++++++++++++++++------ include/media/videobuf2-core.h       |
> >    2 +-
> >  2 files changed, 27 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/media/video/videobuf2-core.c
> > b/drivers/media/video/videobuf2-core.c index cc7ab0a..1d81536 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -798,13 +798,22 @@ static int __qbuf_mmap(struct vb2_buffer *vb,
> > struct v4l2_buffer *b) /**
> >  * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
> >  */
> > -static void __enqueue_in_driver(struct vb2_buffer *vb)
> > +static int __enqueue_in_driver(struct vb2_buffer *vb)
> >  {
> >        struct vb2_queue *q = vb->vb2_queue;
> > +       int ret;
> > 
> >        vb->state = VB2_BUF_STATE_ACTIVE;
> >        atomic_inc(&q->queued_count);
> > -       q->ops->buf_queue(vb);
> > +       ret = q->ops->buf_queue(vb);
> > +       if (ret == 0)
> > +               return 0;
> > +
> > +       vb->state = VB2_BUF_STATE_ERROR;
> > +       atomic_dec(&q->queued_count);
> > +       wake_up_all(&q->done_wq);
> > +
> > +       return ret;
> 
> Unless I am missing something, when this happens for an n-th buffer,
> we wake up all, but only one buffer will have the ERROR state, all the
> other will be in QUEUED state. This will mess up return values from
> dqbuf (if this happens on streamon) for other buffers, they will have
> their V4L2_BUF_FLAG_QUEUED set after dqbuf. Also, returning 0 from
> DQBUF and the V4L2_BUF_FLAG_ERROR for the failed buffer suggests that
> streaming may continue.

Actually not quite, as the driver is expected to mark all buffers as erroneous 
and wake up userspace when the disconnection event is received. Subsequent 
calls to VIDIOC_QBUF (or VIDIOC_STREAMON) need to return an error. I'm not 
sure if we need to wake up userspace then, as applications shouldn't sleep on 
VIDIOC_DQBUF or select() after VIDIOC_QBUF or VIDIOC_STREAMON returned an 
error.

> So how do we recover from this disconnection event? What is the
> general idea? If buf_queue fails, can we restart from some point (i.e.
> reuse the buffers later) or do we have to clean up completely (i.e.
> deallocate, etc.)? Right now we are staying in an undefined state.
> If we cannot recover, we shouldn't be setting V4L2_BUF_FLAG_ERROR, but
> returning a stronger error instead and maybe clean up the rest, which
> is not waited for somehow. If we can recover on the other hand, we
> shouldn't be probably waking up all sleepers or at least giving them
> meaningful errors.

I think a disconnection is pretty fatal. If the user unplugs the webcam, 
there's not much that can be done anymore. Userspace needs to be woken up with 
all buffers marked as erroneous, and the next QBUF call needs to return an 
error without queuing any buffer. We need to define the expected behaviour in 
the V4L2 spec, so that applications can rely on it and implement it properly. 
I would also like to handle this inside videobuf2 if possible (something like 
vb2_disconnect() ?) to ensure that all drivers behave correctly, but I'm not 
sure if that will be possible without messing locking up.

> >  }
> >  /**
> > @@ -890,8 +899,13 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer
> > *b) * If already streaming, give the buffer to driver for processing. *
> > If not, the buffer will be given to driver on next streamon. */
> > -       if (q->streaming)
> > -               __enqueue_in_driver(vb);
> > +       if (q->streaming) {
> > +               ret = __enqueue_in_driver(vb);
> > +               if (ret < 0) {
> > +                       dprintk(1, "qbuf: buffer queue failed\n");
> > +                       return ret;
> > +               }
> > +       }
> 
> What errors can be allowed to be returned from driver here? EIO? Also,
> isn't returning an error here to userspace suggesting that qbuf didn't
> happen? But it actually did happen, we put the buffer onto vb2 list
> and set it state to QUEUED. From the point of view of vb2, the buffer
> is on its queue, but the userspace may not think so.

You're right, that's an issue. The buffer shouldn't be queued at all.

Regarding error codes, I would return -ENXIO (No such device or address - 
POSIX.1) to tell that the device has been disconnected. -ENODEV is misleading, 
it's short description is "No such device", but it means that the device 
doesn't support the requested operation.

> >        dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
> >        return 0;
> > @@ -1101,6 +1115,7 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
> >  int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
> >  {
> >        struct vb2_buffer *vb;
> > +       int ret;
> > 
> >        if (q->fileio) {
> >                dprintk(1, "streamon: file io in progress\n");
> > @@ -1139,8 +1154,13 @@ int vb2_streamon(struct vb2_queue *q, enum
> > v4l2_buf_type type) * If any buffers were queued before streamon,
> >         * we can now pass them to driver for processing.
> >         */
> > -       list_for_each_entry(vb, &q->queued_list, queued_entry)
> > -               __enqueue_in_driver(vb);
> > +       list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > +               ret = __enqueue_in_driver(vb);
> > +               if (ret < 0) {
> > +                       dprintk(1, "streamon: buffer queue failed\n");
> > +                       return ret;
> > +               }
> > +       }
> 
> We need to add new return values from streamon to the API if we want
> to return errors here. We'd need to keep them in sync in API with
> return values from qbuf as well. Maybe we need to add EIO to return
> values from streamon. Is there any other error the driver might want
> to return from buf_queue? ENOMEM?

I don't think we should allow anything else than -ENXIO (or -EIO, depending on 
which error we select to mean that the device has been disconnected). Memory 
should be allocated in buf_prepare if needed, not in buf_queue.

> >        dprintk(3, "Streamon successful\n");
> >        return 0;
> > diff --git a/include/media/videobuf2-core.h
> > b/include/media/videobuf2-core.h index 597efe6..3a92f75 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -225,7 +225,7 @@ struct vb2_ops {
> >        int (*start_streaming)(struct vb2_queue *q);
> >        int (*stop_streaming)(struct vb2_queue *q);
> > 
> > -       void (*buf_queue)(struct vb2_buffer *vb);
> > +       int (*buf_queue)(struct vb2_buffer *vb);
> >  };
> 
> This of course will require an update in documentation above. As we
> are returning buf_queue return values to userspace directly, drivers
> need to be careful what they return.

Right.

-- 
Regards,

Laurent Pinchart
