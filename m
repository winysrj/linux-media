Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:52542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1DDHzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 03:55:38 -0400
Date: Mon, 4 Apr 2011 09:55:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pawel Osciak <pawel@osciak.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 2/4 v2] V4L: add videobuf2 helper functions to support
 multi-size video-buffers
In-Reply-To: <BANLkTikdwRMp4n_wsSu7Gnm4qXYboDGY6Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1104040945130.4668@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
 <Pine.LNX.4.64.1104011011220.9530@axis700.grange>
 <Pine.LNX.4.64.1104011604360.11504@axis700.grange>
 <BANLkTikdwRMp4n_wsSu7Gnm4qXYboDGY6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Pawel

On Sun, 3 Apr 2011, Pawel Osciak wrote:

> Hi Gueannadi,
> A preliminary quick scan over the patch while waiting for documentation.
> 
> On Fri, Apr 1, 2011 at 07:06, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > This patch extends the videobuf2 framework with new helper functions and
> > modifies existing ones to support multi-size video-buffers.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >
> > v2: fix offset calculation in __setup_offsets()
> >
> >  drivers/media/video/videobuf2-core.c |  195 ++++++++++++++++++++++++++++++----
> >  include/media/videobuf2-core.h       |   15 +++
> >  2 files changed, 187 insertions(+), 23 deletions(-)
> >
> > diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> > index 71734a4..20e1572 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -41,7 +41,7 @@ module_param(debug, int, 0644);
> >  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
> >  */
> >  static int __vb2_buf_mem_alloc(struct vb2_buffer *vb,
> > -                               unsigned long *plane_sizes)
> > +                               const unsigned long *plane_sizes)
> >  {
> >        struct vb2_queue *q = vb->vb2_queue;
> >        void *mem_priv;
> > @@ -107,13 +107,22 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
> >  * __setup_offsets() - setup unique offsets ("cookies") for every plane in
> >  * every buffer on the queue
> >  */
> > -static void __setup_offsets(struct vb2_queue *q)
> > +static void __setup_offsets(struct vb2_queue *q, unsigned int n)
> >  {
> >        unsigned int buffer, plane;
> >        struct vb2_buffer *vb;
> > -       unsigned long off = 0;
> > +       unsigned long off;
> >
> > -       for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > +       if (q->num_buffers) {
> > +               struct v4l2_plane *p;
> > +               vb = q->bufs[q->num_buffers - 1];
> > +               p = &vb->v4l2_planes[vb->num_planes - 1];
> > +               off = PAGE_ALIGN(p->m.mem_offset + p->length);
> > +       } else {
> > +               off = 0;
> > +       }
> > +
> > +       for (buffer = q->num_buffers - n; buffer < q->num_buffers; ++buffer) {
> >                vb = q->bufs[buffer];
> >                if (!vb)
> >                        continue;
> > @@ -139,7 +148,7 @@ static void __setup_offsets(struct vb2_queue *q)
> >  */
> >  static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
> >                             unsigned int num_buffers, unsigned int num_planes,
> > -                            unsigned long plane_sizes[])
> > +                            const unsigned long plane_sizes[])
> >  {
> >        unsigned int buffer;
> >        struct vb2_buffer *vb;
> > @@ -160,7 +169,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
> >                vb->state = VB2_BUF_STATE_DEQUEUED;
> >                vb->vb2_queue = q;
> >                vb->num_planes = num_planes;
> > -               vb->v4l2_buf.index = buffer;
> > +               vb->v4l2_buf.index = q->num_buffers + buffer;
> >                vb->v4l2_buf.type = q->type;
> >                vb->v4l2_buf.memory = memory;
> >
> > @@ -188,12 +197,12 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
> >                        }
> >                }
> >
> > -               q->bufs[buffer] = vb;
> > +               q->bufs[q->num_buffers + buffer] = vb;
> >        }
> >
> > -       q->num_buffers = buffer;
> > +       q->num_buffers += buffer;
> >
> > -       __setup_offsets(q);
> > +       __setup_offsets(q, buffer);
> >
> >        dprintk(1, "Allocated %d buffers, %d plane(s) each\n",
> >                        q->num_buffers, num_planes);
> > @@ -204,12 +213,13 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
> >  /**
> >  * __vb2_free_mem() - release all video buffer memory for a given queue
> >  */
> > -static void __vb2_free_mem(struct vb2_queue *q)
> > +static void __vb2_free_mem(struct vb2_queue *q, struct v4l2_buffer_span *span)
> >  {
> >        unsigned int buffer;
> >        struct vb2_buffer *vb;
> >
> > -       for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > +       for (buffer = span->index; buffer < span->index + span->count;
> > +            ++buffer) {
> >                vb = q->bufs[buffer];
> >                if (!vb)
> >                        continue;
> > @@ -222,18 +232,17 @@ static void __vb2_free_mem(struct vb2_queue *q)
> >        }
> >  }
> >
> > -/**
> > - * __vb2_queue_free() - free the queue - video memory and related information
> > - * and return the queue to an uninitialized state. Might be called even if the
> > - * queue has already been freed.
> > - */
> > -static void __vb2_queue_free(struct vb2_queue *q)
> > +int vb2_destroy_bufs(struct vb2_queue *q, struct v4l2_buffer_span *span)
> >  {
> > -       unsigned int buffer;
> > +       int buffer;
> > +
> > +       if (span->index + span->count > q->num_buffers)
> > +               return -EINVAL;
> >
> 
> Maybe it'd be better to free what we can here?

Don't think so - it's a bogus request...

> >        /* Call driver-provided cleanup function for each buffer, if provided */
> >        if (q->ops->buf_cleanup) {
> > -               for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > +               for (buffer = span->index;
> > +                    buffer < span->index + span->count; ++buffer) {
> >                        if (NULL == q->bufs[buffer])
> >                                continue;
> >                        q->ops->buf_cleanup(q->bufs[buffer]);
> > @@ -241,16 +250,36 @@ static void __vb2_queue_free(struct vb2_queue *q)
> >        }
> >
> >        /* Release video buffer memory */
> > -       __vb2_free_mem(q);
> > +       __vb2_free_mem(q, span);
> >
> >        /* Free videobuf buffers */
> > -       for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > +       for (buffer = span->index;
> > +            buffer < span->index + span->count; ++buffer) {
> >                kfree(q->bufs[buffer]);
> >                q->bufs[buffer] = NULL;
> >        }
> >
> > -       q->num_buffers = 0;
> > -       q->memory = 0;
> > +       q->num_buffers -= span->count;
> > +       if (!q->num_buffers)
> > +               q->memory = 0;
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_destroy_bufs);
> > +
> 
> This messes up q->num_buffers, which is used in other places as the
> upper bound for indexes and assumes <0; q->num_buffers> is contiguous.
> Examples include querybufs, buffers_in_use. In general, I find it
> unnecessary complicated and dangerous to allow introducing "holes" in
> buffer indexes.

Yes, there are issues... I think, we can just return -EBUSY on such 
fragmenting DESTROY calls. Anything left over will be freed on last 
close() anyway. Let's decide how we want to handle these and I'll prepare 
a v2, probably with documentation this time:-)

> > +/**
> > + * __vb2_queue_free() - free the queue - video memory and related information
> > + * and return the queue to an uninitialized state. Might be called even if the
> > + * queue has already been freed.
> > + */
> > +static void __vb2_queue_free(struct vb2_queue *q)
> > +{
> > +       struct v4l2_buffer_span span = {
> > +               .index = 0,
> > +               .count = q->num_buffers,
> > +       };
> > +
> > +       vb2_destroy_bufs(q, &span);
> >  }
> >
> >  /**
> > @@ -576,6 +605,126 @@ free_mem:
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_reqbufs);
> >
> > +int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
> > +{
> > +       unsigned int num_planes, num_buffers = 0;
> > +       unsigned long plane_sizes[VIDEO_MAX_PLANES] = {create->size};
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
> > +
> > +       create->index = q->num_buffers + 1;
> > +
> 
> Is this gap in indexes deliberate?

It was deliberate, yes, but it seems wrong to me now too... I'll re-think 
and probably remove it.

> > +       /*
> > +        * Make sure the requested values and current defaults are sane.
> > +        */
> > +       create->count = min_t(unsigned int, create->count, VIDEO_MAX_FRAME - q->num_buffers);
> > +
> > +       if (!q->num_buffers)
> > +               memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
> > +
> > +       /*
> > +        * Ask the driver how many buffers and planes per buffer it requires.
> > +        * Driver also sets the size and allocator context for each plane.
> > +        */
> > +       ret = call_qop(q, queue_add, q, create, &num_buffers, &num_planes,
> > +                      plane_sizes, q->alloc_ctx);
> > +       if (ret)
> > +               return ret;
> > +
> > +       /* Finally, allocate buffers and video memory */
> > +       ret = __vb2_queue_alloc(q, create->memory, num_buffers, num_planes,
> > +                               plane_sizes);
> > +       if (ret < 0) {
> > +               dprintk(1, "Memory allocation failed with error: %d\n", ret);
> > +               return ret;
> > +       }
> > +
> > +       /*
> > +        * Check if driver can handle the so far allocated number of buffers.
> > +        */
> > +       if (ret < num_buffers) {
> > +               unsigned int orig_num_buffers;
> > +
> > +               create->count = ret;
> > +               orig_num_buffers = ret;
> > +
> > +               /*
> > +                * num_buffers still contains the number of buffers, that the
> > +                * queue driver has allocated
> > +                */
> > +               ret = call_qop(q, queue_add, q, create, &num_buffers,
> > +                              &num_planes, plane_sizes, q->alloc_ctx);
> > +               if (ret)
> > +                       goto free_mem;
> > +
> > +               if (orig_num_buffers < num_buffers) {
> > +                       ret = -ENOMEM;
> > +                       goto free_mem;
> > +               }
> > +
> > +               /*
> > +                * Ok, driver accepted smaller number of buffers.
> > +                */
> > +               ret = num_buffers;
> > +       }
> > +
> > +       /*
> > +        * Return the number of successfully allocated buffers
> > +        * to the userspace.
> > +        */
> > +       create->count = ret;
> > +
> > +       q->memory = create->memory;
> > +
> > +       return 0;
> > +
> > +free_mem:
> > +       __vb2_queue_free(q);
> 
> Are we freeing the whole queue on a failed CREATE? Shouldn't we only
> be freeing the buffers that CREATE requested?

Right, thanks for catching.

> > +       return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_create_bufs);
> > +
> > +int vb2_submit_buf(struct vb2_queue *q, unsigned int idx)
> > +{
> > +       return call_qop(q, buf_submit, q->bufs[idx]);
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_submit_buf);
> > +
> >  /**
> >  * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
> >  * @vb:                vb2_buffer to which the plane in question belongs to
> > diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> > index f87472a..88076fc 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> 
> I'll be adding more detailed documentation of vb2_ops soon as well.
> Some comments in spirit of that change:
> 
> > @@ -177,6 +177,10 @@ struct vb2_buffer {
> >  *                     plane should be set in the sizes[] array and optional
> >  *                     per-plane allocator specific context in alloc_ctxs[]
> >  *                     array
> > + * @queue_add:         like above, but called from VIDIOC_CREATE_BUFS, but if
> > + *                     there are already buffers on the queue, it won't replace
> > + *                     them, but add new ones, possibly with a different format
> > + *                     and plane sizes
> 
> Needs some info how the driver can react and what to return.
> 
> >  * @wait_prepare:      release any locks taken while calling vb2 functions;
> >  *                     it is called before an ioctl needs to wait for a new
> >  *                     buffer to arrive; required to avoid a deadlock in
> > @@ -194,6 +198,8 @@ struct vb2_buffer {
> >  *                     each hardware operation in this callback;
> >  *                     if an error is returned, the buffer will not be queued
> >  *                     in driver; optional
> > + * @buf_submit:                called primarily to invalidate buffer caches for faster
> > + *                     consequent queuing; optional
> 
> Ditto. Also, I think it needs a more detailed explanation...

Ok, will have a look at these.

> 
> >  * @buf_finish:                called before every dequeue of the buffer back to
> >  *                     userspace; drivers may perform any operations required
> >  *                     before userspace accesses the buffer; optional
> > @@ -213,11 +219,16 @@ struct vb2_ops {
> >        int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
> >                           unsigned int *num_planes, unsigned long sizes[],
> >                           void *alloc_ctxs[]);
> > +       int (*queue_add)(struct vb2_queue *q,
> > +                        struct v4l2_create_buffers *create,
> > +                        unsigned int *num_buffers, unsigned int *num_planes,
> > +                        unsigned long sizes[], void *alloc_ctxs[]);
> >
> >        void (*wait_prepare)(struct vb2_queue *q);
> >        void (*wait_finish)(struct vb2_queue *q);
> >
> >        int (*buf_init)(struct vb2_buffer *vb);
> > +       int (*buf_submit)(struct vb2_buffer *vb);
> >        int (*buf_prepare)(struct vb2_buffer *vb);
> >        int (*buf_finish)(struct vb2_buffer *vb);
> >        void (*buf_cleanup)(struct vb2_buffer *vb);
> > @@ -291,6 +302,10 @@ int vb2_wait_for_all_buffers(struct vb2_queue *q);
> >  int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
> >  int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
> >
> > +int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
> > +int vb2_destroy_bufs(struct vb2_queue *q, struct v4l2_buffer_span *span);
> > +int vb2_submit_buf(struct vb2_queue *q, unsigned int idx);
> > +
> >  int vb2_queue_init(struct vb2_queue *q);
> >
> >  void vb2_queue_release(struct vb2_queue *q);
> > --
> > 1.7.2.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> -- 
> Best regards,
> Pawel Osciak

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
