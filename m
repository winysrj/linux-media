Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:35720 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbeKONIC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 08:08:02 -0500
Received: by mail-yw1-f66.google.com with SMTP id h32so2066630ywk.2
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 19:02:02 -0800 (PST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id l84-v6sm8147992ywc.88.2018.11.14.19.02.00
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 19:02:01 -0800 (PST)
Received: by mail-yb1-f180.google.com with SMTP id h187-v6so7789660ybg.10
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 19:02:00 -0800 (PST)
MIME-Version: 1.0
References: <20181114150449.23487-1-p.zabel@pengutronix.de> <7953197.5dbdkFljzD@avalon>
In-Reply-To: <7953197.5dbdkFljzD@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 15 Nov 2018 12:01:48 +0900
Message-ID: <CAAFQd5BbVs6PLE4VpSi2FOZZkox+U8gSLaiDb8Hc8Z2B4vzRTQ@mail.gmail.com>
Subject: Re: [PATCH v3] media: vb2: Allow reqbufs(0) with "in use" MMAP buffers
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        nicolas@ndufresne.ca, Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 15, 2018 at 4:59 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Philipp,
>
> Thank you for the patch.
>
> On Wednesday, 14 November 2018 17:04:49 EET Philipp Zabel wrote:
> > From: John Sheu <sheu@chromium.org>
> >
> > Videobuf2 presently does not allow VIDIOC_REQBUFS to destroy outstanding
> > buffers if the queue is of type V4L2_MEMORY_MMAP, and if the buffers are
> > considered "in use".  This is different behavior than for other memory
> > types and prevents us from deallocating buffers in following two cases:
> >
> > 1) There are outstanding mmap()ed views on the buffer. However even if
> >    we put the buffer in reqbufs(0), there will be remaining references,
> >    due to vma .open/close() adjusting vb2 buffer refcount appropriately.
> >    This means that the buffer will be in fact freed only when the last
> >    mmap()ed view is unmapped.
>
> While I agree that we should remove this restriction, it has helped me in the
> past to find missing munmap() in userspace. This patch thus has the potential
> of causing memory leaks in userspace. Is there a way we could assist
> application developers with this ?
>

I'm not very convinced that it's something we need to have, but
possibly one could have it as a settable capability, that's given to
REQBUF/CREATE_BUFS at allocation (count > 0) time?

> > 2) Buffer has been exported as a DMABUF. Refcount of the vb2 buffer
> >    is managed properly by VB2 DMABUF ops, i.e. incremented on DMABUF
> >    get and decremented on DMABUF release. This means that the buffer
> >    will be alive until all importers release it.
> >
> > Considering both cases above, there does not seem to be any need to
> > prevent reqbufs(0) operation, because buffer lifetime is already
> > properly managed by both mmap() and DMABUF code paths. Let's remove it
> > and allow userspace freeing the queue (and potentially allocating a new
> > one) even though old buffers might be still in processing.
> >
> > To let userspace know that the kernel now supports orphaning buffers
> > that are still in use, add a new V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS
> > to be set by reqbufs and create_bufs.
> >
> > Signed-off-by: John Sheu <sheu@chromium.org>
> > Reviewed-by: Pawel Osciak <posciak@chromium.org>
> > Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > [p.zabel@pengutronix.de: moved __vb2_queue_cancel out of the mmap_lock
> >  and added V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS]
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > Changes since v2:
> >  - Added documentation for V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS
> > ---
> >  .../media/uapi/v4l/vidioc-reqbufs.rst         | 15 ++++++++---
> >  .../media/common/videobuf2/videobuf2-core.c   | 26 +------------------
> >  .../media/common/videobuf2/videobuf2-v4l2.c   |  2 +-
> >  include/uapi/linux/videodev2.h                |  1 +
> >  4 files changed, 15 insertions(+), 29 deletions(-)
> >
> > diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
> > b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst index
> > d4bbbb0c60e8..d53006b938ac 100644
> > --- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
> > +++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
> > @@ -59,9 +59,12 @@ When the I/O method is not supported the ioctl returns an
> > ``EINVAL`` error code.
> >
> >  Applications can call :ref:`VIDIOC_REQBUFS` again to change the number of
> > -buffers, however this cannot succeed when any buffers are still mapped.
> > -A ``count`` value of zero frees all buffers, after aborting or finishing
> > -any DMA in progress, an implicit
> > +buffers. Note that if any buffers are still mapped or exported via DMABUF,
> > +this can only succeed if the ``V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS`` flag
> > +is set. In that case these buffers are orphaned and will be freed when they
> > +are unmapped or when the exported DMABUF fds are closed.
> > +A ``count`` value of zero frees or orphans all buffers, after aborting or
> > +finishing any DMA in progress, an implicit
> >
> >  :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`.
> >
> > @@ -132,6 +135,12 @@ any DMA in progress, an implicit
> >      * - ``V4L2_BUF_CAP_SUPPORTS_REQUESTS``
> >        - 0x00000008
> >        - This buffer type supports :ref:`requests <media-request-api>`.
> > +    * - ``V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS``
> > +      - 0x00000010
> > +      - The kernel allows calling :ref:`VIDIOC_REQBUFS` with a ``count``
> > value +        of zero while buffers are still mapped or exported via
> > DMABUF. These +        orphaned buffers will be freed when they are
> > unmapped or when the +        exported DMABUF fds are closed.
> >
> >  Return Value
> >  ============
> > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c
> > b/drivers/media/common/videobuf2/videobuf2-core.c index
> > 975ff5669f72..608459450c1e 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > @@ -553,20 +553,6 @@ bool vb2_buffer_in_use(struct vb2_queue *q, struct
> > vb2_buffer *vb) }
> >  EXPORT_SYMBOL(vb2_buffer_in_use);
> >
> > -/*
> > - * __buffers_in_use() - return true if any buffers on the queue are in use
> > and - * the queue cannot be freed (by the means of REQBUFS(0)) call
> > - */
> > -static bool __buffers_in_use(struct vb2_queue *q)
> > -{
> > -     unsigned int buffer;
> > -     for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > -             if (vb2_buffer_in_use(q, q->bufs[buffer]))
> > -                     return true;
> > -     }
> > -     return false;
> > -}
> > -
> >  void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  {
> >       call_void_bufop(q, fill_user_buffer, q->bufs[index], pb);
> > @@ -674,23 +660,13 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum
> > vb2_memory memory,
> >
> >       if (*count == 0 || q->num_buffers != 0 ||
> >           (q->memory != VB2_MEMORY_UNKNOWN && q->memory != memory)) {
> > -             /*
> > -              * We already have buffers allocated, so first check if they
> > -              * are not in use and can be freed.
> > -              */
> > -             mutex_lock(&q->mmap_lock);
> > -             if (q->memory == VB2_MEMORY_MMAP && __buffers_in_use(q)) {
> > -                     mutex_unlock(&q->mmap_lock);
> > -                     dprintk(1, "memory in use, cannot free\n");
> > -                     return -EBUSY;
> > -             }
> > -
> >               /*
> >                * Call queue_cancel to clean up any buffers in the
> >                * QUEUED state which is possible if buffers were prepared or
> >                * queued without ever calling STREAMON.
> >                */
> >               __vb2_queue_cancel(q);
> > +             mutex_lock(&q->mmap_lock);
>
> This results in __vb2_queue_cancel() called without the mmap_lock held. Is
> that OK ?

Looks like a rebase error. The original patch didn't move the mutex_lock() call.

Anyway, thanks a lot Philipp for reviving it!

Best regards,
Tomasz
