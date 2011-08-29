Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:55974 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab1H2Iat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 04:30:49 -0400
Date: Mon, 29 Aug 2011 10:30:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pawel Osciak <pawel@osciak.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 5/7 v5] V4L: vb2: add support for buffers of different
 sizes on a single queue
In-Reply-To: <CAMm-=zDzCEM6euT9TNJCEE9uhWM7GMbSF68sxyFOHn1kGeJ5VA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1108290918180.31184@axis700.grange>
References: <1314211292-10414-1-git-send-email-g.liakhovetski@gmx.de>
 <1314211292-10414-6-git-send-email-g.liakhovetski@gmx.de>
 <CAMm-=zDzCEM6euT9TNJCEE9uhWM7GMbSF68sxyFOHn1kGeJ5VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel

Thanks for the review.

On Sun, 28 Aug 2011, Pawel Osciak wrote:

> Hi Guennadi,
> 
> On Wed, Aug 24, 2011 at 11:41, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > The two recently added ioctl()s VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF
> > allow user-space applications to allocate video buffers of different
> > sizes and hand them over to the driver for fast switching between
> > different frame formats. This patch adds support for buffers of different
> > sizes on the same buffer-queue to vb2.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Cc: Pawel Osciak <pawel@osciak.com>
> > Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > ---
> >  drivers/media/video/videobuf2-core.c |  278 ++++++++++++++++++++++++++++------
> >  include/media/videobuf2-core.h       |   31 +++--
> >  2 files changed, 252 insertions(+), 57 deletions(-)
> >
> > diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> > index 8a81a89..fed6f2d 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c

[snip]

> >  /**
> > + * vb2_create_bufs() - Allocate buffers and any required auxiliary structs
> > + * @q:         videobuf2 queue
> > + * @create:    creation parameters, passed from userspace to vidioc_create_bufs
> > + *             handler in driver
> > + *
> > + * Should be called from vidioc_create_bufs ioctl handler of a driver.
> > + * This function:
> > + * 1) verifies parameter sanity
> > + * 2) calls the .queue_setup() queue operation
> > + * 3) performs any necessary memory allocations
> > + *
> > + * The return values from this function are intended to be directly returned
> > + * from vidioc_create_bufs handler in driver.
> > + */
> > +int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
> > +{
> > +       unsigned int num_planes, num_buffers = create->count, allocated_buffers;
> > +       unsigned long plane_sizes[VIDEO_MAX_PLANES];
> > +       int ret = 0;
> > +
> > +       if (q->fileio) {
> > +               dprintk(1, "%s(): file io in progress\n", __func__);
> > +               return -EBUSY;
> > +       }
> > +
> > +       if (create->memory != V4L2_MEMORY_MMAP
> > +                       && create->memory != V4L2_MEMORY_USERPTR) {
> > +               dprintk(1, "%s(): unsupported memory type\n", __func__);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (create->format.type != q->type) {
> > +               dprintk(1, "%s(): requested type is incorrect\n", __func__);
> > +               return -EINVAL;
> > +       }
> > +
> > +       /*
> > +        * Make sure all the required memory ops for given memory type
> > +        * are available.
> > +        */
> > +       if (create->memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
> > +               dprintk(1, "%s(): MMAP for current setup unsupported\n", __func__);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (create->memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
> > +               dprintk(1, "%s(): USERPTR for current setup unsupported\n", __func__);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (q->num_buffers == VIDEO_MAX_FRAME) {
> > +               dprintk(1, "%s(): maximum number of buffers already allocated\n",
> > +                       __func__);
> > +               return -ENOBUFS;
> > +       }
> 
> I think we should be verifying that q->num_buffers + create->count <=
> VIDEO_MAX_FRAME.

Yeah, something like that, thanks. Some of us didn't like this 
VIDEO_MAX_FRAME limit at all, but as long as we have it, e-g-. as long as 
struct vb2_queue::bufs[] is a fixed-size array with exactly that many 
elements, we have to check for it. Increasing / eliminating it could be a 
separate patch.

> 
> > +
> > +       create->index = q->num_buffers;
> > +
> > +       if (!q->num_buffers) {
> > +               memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
> > +               q->memory = create->memory;
> > +       }
> > +
> > +       /*
> > +        * Ask the driver, whether the requested number of buffers, planes per
> > +        * buffer and their sizes are acceptable
> > +        */
> > +       ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
> > +                      &num_planes, plane_sizes, q->alloc_ctx);
> 
> I don't see you zeroing neither num_planes nor plane_sizes[] in
> vb2_create_bufs and vb2_reqbufs. Since instead of always requiring the
> driver to fill them, you've introduced the "non-zero num_planes and/or
> plane_sizes" case (see my comment for queue_setup() documentation in
> videobuf2-core.h), it looks to me that the drivers will be getting
> random values in num_planes and plane_sizes in queue_setup() and will
> have to attempt to use them. Ditto for all other qop calls to
> queue_setup in this file (in vb2_reqbufs as well).

No, it's the documentation that's wrong:-) Both num_planes and plane_sizes 
have always been pure output parameters of .queue_setup(), so, I don't 
think there's a need to initialise them. Will have to update the comment.

> 
> > +       if (ret)
> > +               return ret;
> > +
> > +       /* Finally, allocate buffers and video memory */
> > +       ret = __vb2_queue_alloc(q, create->memory, num_buffers,
> > +                               num_planes, plane_sizes);
> > +       if (ret < 0) {
> > +               dprintk(1, "Memory allocation failed with error: %d\n", ret);
> > +               return ret;
> > +       }
> > +
> > +       allocated_buffers = ret;
> > +
> > +       /*
> > +        * Check if driver can handle the so far allocated number of buffers.
> > +        */
> > +       if (ret < num_buffers) {
> > +               num_buffers = ret;
> > +
> > +               /*
> > +                * q->num_buffers contains the total number of buffers, that the
> > +                * queue driver has set up
> > +                */
> > +               ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
> > +                              &num_planes, plane_sizes, q->alloc_ctx);
> 
> We need to be sure that drivers understand that num_buffers is _in
> addition_ to previous allocations if fmt!=NULL (see my comments for
> videobuf2-core.h below).

Hm, no. If they really need to know that, they have to look at 
q->num_buffers. And yes, I think both my sh-mobile-ceu-camera and 
mx3-camera implementations do have a problem with this, thanks for 
pointing out.

> > +
> > +               if (!ret && allocated_buffers < num_buffers)
> > +                       ret = -ENOMEM;
> > +
> > +               /*
> > +                * Either the driver has accepted a smaller number of buffers,
> > +                * or .queue_setup() returned an error
> > +                */
> > +       }
> > +
> > +       q->num_buffers += allocated_buffers;
> > +
> > +       if (ret < 0) {
> > +               __vb2_queue_free(q, allocated_buffers);
> > +               return ret;
> > +       }
> > +
> > +       /*
> > +        * Return the number of successfully allocated buffers
> > +        * to the userspace.
> > +        */
> > +       create->count = allocated_buffers;
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_create_bufs);
> > +
> 
> <snip>
> 
> >  /**
> > + * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
> > + * @q:         videobuf2 queue
> > + * @b:         buffer structure passed from userspace to vidioc_prepare_buf
> > + *             handler in driver
> > + *
> > + * Should be called from vidioc_prepare_buf ioctl handler of a driver.
> > + * This function:
> > + * 1) verifies the passed buffer,
> > + * 2) calls buf_prepare callback in the driver (if provided), in which
> > + *    driver-specific buffer initialization can be performed,
> > + *
> > + * The return values from this function are intended to be directly returned
> > + * from vidioc_prepare_buf handler in driver.
> > + */
> > +int vb2_prepare_buf(struct vb2_queue *q, const struct v4l2_buffer *b)
> > +{
> > +       struct vb2_buffer *vb;
> > +
> > +       if (q->fileio) {
> > +               dprintk(1, "%s(): file io in progress\n", __func__);
> > +               return -EBUSY;
> > +       }
> > +
> > +       if (b->type != q->type) {
> > +               dprintk(1, "%s(): invalid buffer type\n", __func__);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (b->index >= q->num_buffers) {
> > +               dprintk(1, "%s(): buffer index out of range\n", __func__);
> > +               return -EINVAL;
> > +       }
> > +
> > +       vb = q->bufs[b->index];
> > +       if (NULL == vb) {
> > +               /* Should never happen */
> > +               dprintk(1, "%s(): buffer is NULL\n", __func__);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (b->memory != q->memory) {
> > +               dprintk(1, "%s(): invalid memory type\n", __func__);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (vb->state != VB2_BUF_STATE_DEQUEUED) {
> > +               dprintk(1, "%s(): invalid buffer state %d\n", __func__, vb->state);
> > +               return -EINVAL;
> > +       }
> > +
> > +       return __buf_prepare(vb, b);
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_prepare_buf);
> > +
> 
> I don't see vb->state being set to VB2_BUF_STATE_PREPARED anywhere...
> Shouldn't it be done here? Otherwise we'll be calling buf_prepare
> again on qbuf...

Yes, you're right, it seems to have got lost in multiple revisions:-( But 
in fact it should be fixed in the earlier "V4L: add a new videobuf2 buffer 
state VB2_BUF_STATE_PREPARED" patch.

> <snip>
> 
> > diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> > index d043132..ddebcd3 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -172,13 +172,17 @@ struct vb2_buffer {
> >  /**
> >  * struct vb2_ops - driver-specific callbacks
> >  *
> > - * @queue_setup:       called from a VIDIOC_REQBUFS handler, before
> > - *                     memory allocation; driver should return the required
> > - *                     number of buffers in num_buffers, the required number
> > - *                     of planes per buffer in num_planes; the size of each
> > - *                     plane should be set in the sizes[] array and optional
> > - *                     per-plane allocator specific context in alloc_ctxs[]
> > - *                     array
> > + * @queue_setup:       called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
> > + *                     handlers, before memory allocation. When called with
> > + *                     zeroed num_planes or plane sizes, the driver should
> > + *                     return the required number of buffers in num_buffers,
> > + *                     the required number of planes per buffer in num_planes;
> > + *                     the size of each plane should be set in the sizes[]
> > + *                     array and optional per-plane allocator specific context
> > + *                     in alloc_ctxs[] array. If num_planes and sizes[] are
> > + *                     both non-zero, the driver should use them. Otherwise the
> > + *                     driver must make no assumptions about the buffers, that
> > + *                     will be made available to it.
> 
> 
> Could you explain why different behavior from a driver is required
> depending on the values of num_planes and plane_sizes? Are you
> expecting vb2 to fill num_planes and plane_sizes? That would require
> it to parse the format...

As I said, that's outdated documentation, will fix.

> Another subtle problem here is that on vb2_reqbufs, we call
> queue_setup() asking the driver whether it can manage the allocated
> number of buffers. Now with queue_setup being called from
> vb2_create_bufs as well, we need to make sure that the driver
> understands that num_buffers passed then is only for buffers of the
> format passed to create. In other words, if fmt==NULL, driver must be
> able to handle num_buffers buffers of current format; else if fmt !=
> NULL, the driver must be able to handle any previously allocated
> buffers _plus_ the number passed to this queue_setup call. This not
> only means last call to queue_setup with fmt==NULL plus current call,
> but previous call with fmt==NULL _plus_ all previous calls with
> fmt!=NULL _plus_ the current call.

Yes, exactly. .queue_setup() has 3 modes of operation:

(1) when called from vb2_reqbufs() (fmt == NULL): only num_buffers of the 
currently configured format have to be set up. Both num_planes and 
plane_sizes can be considered purely output.

(2) first call from vb2_create_bufs() (fmt != NULL): new buffers have to 
be added to q->num_buffers of whatever formats, allocated up to now. After 
this, in case of the V4L2_MEMORY_MMAP memory, .buf_init() will be called 
for each new buffer.

(3) second call from vb2_create_bufs() (fmt != NULL): verify, that the 
num_buffers in addition to q->num_buffers is also ok. In case of 
V4L2_MEMORY_MMAP, those num_buffers are already allocated and initialised, 
we have to check, that that's enough.

And yes, it seems, checking for *num_planes == 0 is a simple way to 
differentiate between (2) and (3) in the driver.

> <snip>
> 
> Could you share the userspace code that you used for testing this? I
> just wanted to get a feel of how those new ioctls fall into place
> together.

Theoretically - yes, just will have to clean up the code a bit;-) Will try 
to find some time for this in the next couple of days.

> Also, did you try multiple CREATE_BUFS calls?

Yes, it currently does two CREATE_BUFS, I might try to mix REQBUFS with 
CREATE_BUFS too though.

Thanks for the comments!
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
