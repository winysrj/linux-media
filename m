Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63819 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab2ASTIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 14:08:14 -0500
Received: by vcbfo1 with SMTP id fo1so214287vcb.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jan 2012 11:08:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325760118-27997-3-git-send-email-sumit.semwal@ti.com>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com> <1325760118-27997-3-git-send-email-sumit.semwal@ti.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 19 Jan 2012 11:07:32 -0800
Message-ID: <CAMm-=zB+Sg4XZX_MLGt1fvURCFf8QbWcmZHSUbMYbGfiSz2+gg@mail.gmail.com>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
To: Sumit Semwal <sumit.semwal@ti.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, m.szyprowski@samsung.com,
	rob@ti.com, daniel@ffwll.ch, t.stanislaws@samsung.com,
	patches@linaro.org, Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sumit,
Thank you for your work. Please find my comments below.

On Thu, Jan 5, 2012 at 2:41 AM, Sumit Semwal <sumit.semwal@ti.com> wrote:
> This patch adds support for DMABUF memory type in videobuf2. It calls relevant
> APIs of dma_buf for v4l reqbuf / qbuf / dqbuf operations.
>
> For this version, the support is for videobuf2 as a user of the shared buffer;
> so the allocation of the buffer is done outside of V4L2. [A sample allocator of
> dma-buf shared buffer is given at [1]]
>
> [1]: Rob Clark's DRM:
>   https://github.com/robclark/kernel-omap4/commits/drmplane-dmabuf
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>   [original work in the PoC for buffer sharing]
> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> ---
>  drivers/media/video/videobuf2-core.c |  186 +++++++++++++++++++++++++++++++++-
>  include/media/videobuf2-core.h       |   30 ++++++
>  2 files changed, 215 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 95a3f5e..6cd2f97 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -107,6 +107,27 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
>  }
>
>  /**
> + * __vb2_buf_dmabuf_put() - release memory associated with
> + * a DMABUF shared buffer
> + */
> +static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
> +{
> +       struct vb2_queue *q = vb->vb2_queue;
> +       unsigned int plane;
> +
> +       for (plane = 0; plane < vb->num_planes; ++plane) {
> +               void *mem_priv = vb->planes[plane].mem_priv;
> +
> +               if (mem_priv) {
> +                       call_memop(q, plane, detach_dmabuf, mem_priv);
> +                       dma_buf_put(vb->planes[plane].dbuf);
> +                       vb->planes[plane].dbuf = NULL;
> +                       vb->planes[plane].mem_priv = NULL;
> +               }
> +       }
> +}
> +
> +/**
>  * __setup_offsets() - setup unique offsets ("cookies") for every plane in
>  * every buffer on the queue
>  */
> @@ -228,6 +249,8 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
>                /* Free MMAP buffers or release USERPTR buffers */
>                if (q->memory == V4L2_MEMORY_MMAP)
>                        __vb2_buf_mem_free(vb);
> +               if (q->memory == V4L2_MEMORY_DMABUF)
> +                       __vb2_buf_dmabuf_put(vb);
>                else
>                        __vb2_buf_userptr_put(vb);

This looks like a bug. If memory is MMAP, you'd __vb2_buf_mem_free(vb)
AND __vb2_buf_userptr_put(vb), which is wrong. Have you tested MMAP
and USERPTR with those patches applied?

>        }
> @@ -350,6 +373,13 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>                 */
>                memcpy(b->m.planes, vb->v4l2_planes,
>                        b->length * sizeof(struct v4l2_plane));
> +
> +               if (q->memory == V4L2_MEMORY_DMABUF) {
> +                       unsigned int plane;
> +                       for (plane = 0; plane < vb->num_planes; ++plane) {
> +                               b->m.planes[plane].m.fd = 0;

I'm confused here. Isn't this the way to return fd for userspace to
pass to other drivers? I was imagining that the userspace would be
getting an fd back in plane structure to pass to other drivers, i.e.
userspace dequeuing a DMABUF v4l2_buffer should be able to pass it
forward to another driver using fd found in dequeued buffer.
Shouldn't this also fill in length?

> +                       }
> +               }
>        } else {
>                /*
>                 * We use length and offset in v4l2_planes array even for
> @@ -361,6 +391,8 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>                        b->m.offset = vb->v4l2_planes[0].m.mem_offset;
>                else if (q->memory == V4L2_MEMORY_USERPTR)
>                        b->m.userptr = vb->v4l2_planes[0].m.userptr;
> +               else if (q->memory == V4L2_MEMORY_DMABUF)
> +                       b->m.fd = 0;
>        }
>

Same here...

>        /*
> @@ -452,6 +484,21 @@ static int __verify_mmap_ops(struct vb2_queue *q)
>  }
>
>  /**
> + * __verify_dmabuf_ops() - verify that all memory operations required for
> + * DMABUF queue type have been provided
> + */
> +static int __verify_dmabuf_ops(struct vb2_queue *q)
> +{
> +       if (!(q->io_modes & VB2_DMABUF) || !q->mem_ops->attach_dmabuf
> +                       || !q->mem_ops->detach_dmabuf
> +                       || !q->mem_ops->map_dmabuf
> +                       || !q->mem_ops->unmap_dmabuf)
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
> +/**
>  * vb2_reqbufs() - Initiate streaming
>  * @q:         videobuf2 queue
>  * @req:       struct passed from userspace to vidioc_reqbufs handler in driver
> @@ -485,6 +532,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>        }
>
>        if (req->memory != V4L2_MEMORY_MMAP
> +                       && req->memory != V4L2_MEMORY_DMABUF
>                        && req->memory != V4L2_MEMORY_USERPTR) {
>                dprintk(1, "reqbufs: unsupported memory type\n");
>                return -EINVAL;
> @@ -514,6 +562,11 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>                return -EINVAL;
>        }
>
> +       if (req->memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
> +               dprintk(1, "reqbufs: DMABUF for current setup unsupported\n");
> +               return -EINVAL;
> +       }
> +
>        if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
>                /*
>                 * We already have buffers allocated, so first check if they
> @@ -621,7 +674,8 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
>        }
>
>        if (create->memory != V4L2_MEMORY_MMAP
> -                       && create->memory != V4L2_MEMORY_USERPTR) {
> +                       && create->memory != V4L2_MEMORY_USERPTR
> +                       && create->memory != V4L2_MEMORY_DMABUF) {
>                dprintk(1, "%s(): unsupported memory type\n", __func__);
>                return -EINVAL;
>        }
> @@ -645,6 +699,11 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
>                return -EINVAL;
>        }
>
> +       if (create->memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
> +               dprintk(1, "%s(): DMABUF for current setup unsupported\n", __func__);
> +               return -EINVAL;
> +       }
> +
>        if (q->num_buffers == VIDEO_MAX_FRAME) {
>                dprintk(1, "%s(): maximum number of buffers already allocated\n",
>                        __func__);
> @@ -840,6 +899,11 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
>                                        b->m.planes[plane].length;
>                        }
>                }
> +               if (b->memory == V4L2_MEMORY_DMABUF) {
> +                       for (plane = 0; plane < vb->num_planes; ++plane) {
> +                               v4l2_planes[plane].m.fd = b->m.planes[plane].m.fd;

Shouldn't this fill length too?

> +                       }
> +               }
>        } else {
>                /*
>                 * Single-planar buffers do not use planes array,
> @@ -854,6 +918,10 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
>                        v4l2_planes[0].m.userptr = b->m.userptr;
>                        v4l2_planes[0].length = b->length;
>                }
> +               if (b->memory == V4L2_MEMORY_DMABUF) {
> +                       v4l2_planes[0].m.fd = b->m.fd;

Ditto.

> +               }
> +
>        }
>
>        vb->v4l2_buf.field = b->field;
> @@ -962,6 +1030,109 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  }
>
>  /**
> + * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
> + */
> +static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +{
> +       struct v4l2_plane planes[VIDEO_MAX_PLANES];
> +       struct vb2_queue *q = vb->vb2_queue;
> +       void *mem_priv;
> +       unsigned int plane;
> +       int ret;
> +       int write = !V4L2_TYPE_IS_OUTPUT(q->type);
> +
> +       /* Verify and copy relevant information provided by the userspace */
> +       ret = __fill_vb2_buffer(vb, b, planes);
> +       if (ret)
> +               return ret;
> +
> +       for (plane = 0; plane < vb->num_planes; ++plane) {
> +               struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
> +
> +               if (IS_ERR_OR_NULL(dbuf)) {
> +                       dprintk(1, "qbuf: invalid dmabuf fd for "
> +                               "plane %d\n", plane);
> +                       ret = PTR_ERR(dbuf);
> +                       goto err;
> +               }
> +
> +               /* this doesn't get filled in until __fill_vb2_buffer(),
> +                * since it isn't known until after dma_buf_get()..
> +                */
> +               planes[plane].length = dbuf->size;

But this is after dma_buf_get, unless I'm missing something... And
__fill_vb2_buffer() is not filing length...

> +
> +               /* Skip the plane if already verified */
> +               if (dbuf == vb->planes[plane].dbuf) {
> +                       dma_buf_put(dbuf);
> +                       continue;
> +               }

Won't this prevent us from using a buffer if the exporter only allows
exclusive access to it?

> +
> +               dprintk(3, "qbuf: buffer description for plane %d changed, "

s/description/descriptor ?

> +                       "reattaching dma buf\n", plane);
> +
> +               /* Release previously acquired memory if present */
> +               if (vb->planes[plane].mem_priv) {
> +                       call_memop(q, plane, detach_dmabuf,
> +                               vb->planes[plane].mem_priv);
> +                       dma_buf_put(vb->planes[plane].dbuf);
> +               }
> +
> +               vb->planes[plane].mem_priv = NULL;
> +
> +               /* Acquire each plane's memory */
> +               mem_priv = q->mem_ops->attach_dmabuf(
> +                               q->alloc_ctx[plane], dbuf);
> +               if (IS_ERR(mem_priv)) {
> +                       dprintk(1, "qbuf: failed acquiring dmabuf "
> +                               "memory for plane %d\n", plane);
> +                       ret = PTR_ERR(mem_priv);
> +                       goto err;

Since mem_priv is not assigned back to plane's mem_priv if an error
happens here, we won't be calling dma_buf_put on this dbuf, even
though we called _get() above.

> +               }
> +
> +               vb->planes[plane].dbuf = dbuf;
> +               vb->planes[plane].mem_priv = mem_priv;
> +       }
> +
> +       /* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
> +        * really we want to do this just before the DMA, not while queueing
> +        * the buffer(s)..
> +        */
> +       for (plane = 0; plane < vb->num_planes; ++plane) {
> +               ret = q->mem_ops->map_dmabuf(
> +                               vb->planes[plane].mem_priv, write);
> +               if (ret) {
> +                       dprintk(1, "qbuf: failed mapping dmabuf "
> +                               "memory for plane %d\n", plane);
> +                       goto err;
> +               }
> +       }
> +
> +       /*
> +        * Call driver-specific initialization on the newly acquired buffer,
> +        * if provided.
> +        */
> +       ret = call_qop(q, buf_init, vb);
> +       if (ret) {
> +               dprintk(1, "qbuf: buffer initialization failed\n");
> +               goto err;
> +       }
> +
> +       /*
> +        * Now that everything is in order, copy relevant information
> +        * provided by userspace.
> +        */
> +       for (plane = 0; plane < vb->num_planes; ++plane)
> +               vb->v4l2_planes[plane] = planes[plane];
> +
> +       return 0;
> +err:
> +       /* In case of errors, release planes that were already acquired */
> +       __vb2_buf_dmabuf_put(vb);
> +
> +       return ret;
> +}
> +
> +/**
>  * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
>  */
>  static void __enqueue_in_driver(struct vb2_buffer *vb)
> @@ -985,6 +1156,9 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>        case V4L2_MEMORY_USERPTR:
>                ret = __qbuf_userptr(vb, b);
>                break;
> +       case V4L2_MEMORY_DMABUF:
> +               ret = __qbuf_dmabuf(vb, b);
> +               break;
>        default:
>                WARN(1, "Invalid queue type\n");
>                ret = -EINVAL;
> @@ -1284,6 +1458,7 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
>  {
>        struct vb2_buffer *vb = NULL;
>        int ret;
> +       unsigned int plane;
>
>        if (q->fileio) {
>                dprintk(1, "dqbuf: file io in progress\n");
> @@ -1307,6 +1482,15 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
>                return ret;
>        }
>
> +       /* TODO: this unpins the buffer(dma_buf_unmap_attachment()).. but
> +        * really we want tot do this just after DMA, not when the
> +        * buffer is dequeued..
> +        */
> +       if (q->memory == V4L2_MEMORY_DMABUF)
> +               for (plane = 0; plane < vb->num_planes; ++plane)
> +                       call_memop(q, plane, unmap_dmabuf,
> +                               vb->planes[plane].mem_priv);
> +
>        switch (vb->state) {
>        case VB2_BUF_STATE_DONE:
>                dprintk(3, "dqbuf: Returning done buffer\n");
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index a15d1f1..5c1836d 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -16,6 +16,7 @@
>  #include <linux/mutex.h>
>  #include <linux/poll.h>
>  #include <linux/videodev2.h>
> +#include <linux/dma-buf.h>
>
>  struct vb2_alloc_ctx;
>  struct vb2_fileio_data;
> @@ -41,6 +42,20 @@ struct vb2_fileio_data;
>  *              argument to other ops in this structure
>  * @put_userptr: inform the allocator that a USERPTR buffer will no longer
>  *              be used
> + * @attach_dmabuf: attach a shared struct dma_buf for a hardware operation;
> + *                used for DMABUF memory types; alloc_ctx is the alloc context
> + *                dbuf is the shared dma_buf; returns NULL on failure;
> + *                allocator private per-buffer structure on success;
> + *                this needs to be used for further accesses to the buffer
> + * @detach_dmabuf: inform the exporter of the buffer that the current DMABUF
> + *                buffer is no longer used; the buf_priv argument is the
> + *                allocator private per-buffer structure previously returned
> + *                from the attach_dmabuf callback
> + * @map_dmabuf: request for access to the dmabuf from allocator; the allocator
> + *             of dmabuf is informed that this driver is going to use the
> + *             dmabuf
> + * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
> + *               that this driver is done using the dmabuf for now

I feel this requires more clarification. For example, for both detach
and unmap this says "the current DMABUF buffer is no longer used" and
"driver is done using the dmabuf for now", respectively. Without prior
knowledge of dmabuf, you don't know which one to use in which
situation. Similarly, attach and map could be clarified as well.

> @@ -56,6 +71,8 @@ struct vb2_fileio_data;
>  * Required ops for USERPTR types: get_userptr, put_userptr.
>  * Required ops for MMAP types: alloc, put, num_users, mmap.
>  * Required ops for read/write access types: alloc, put, num_users, vaddr
> + * Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf,
> + *                               unmap_dmabuf.
>  */
>  struct vb2_mem_ops {
>        void            *(*alloc)(void *alloc_ctx, unsigned long size);
> @@ -65,6 +82,16 @@ struct vb2_mem_ops {
>                                        unsigned long size, int write);
>        void            (*put_userptr)(void *buf_priv);
>
> +       /* Comment from Rob Clark: XXX: I think the attach / detach could be handled
> +        * in the vb2 core, and vb2_mem_ops really just need to get/put the
> +        * sglist (and make sure that the sglist fits it's needs..)
> +        */

I *strongly* agree with Rob here. Could you explain the reason behind
not doing this?
Allocator should ideally not have to be aware of attaching/detaching,
this is not specific to an allocator.

> +       void            *(*attach_dmabuf)(void *alloc_ctx,
> +                                         struct dma_buf *dbuf);
> +       void            (*detach_dmabuf)(void *buf_priv);
> +       int             (*map_dmabuf)(void *buf_priv, int write);
> +       void            (*unmap_dmabuf)(void *buf_priv);
> +
>        void            *(*vaddr)(void *buf_priv);
>        void            *(*cookie)(void *buf_priv);
>
> @@ -75,6 +102,7 @@ struct vb2_mem_ops {
>
>  struct vb2_plane {
>        void                    *mem_priv;
> +       struct dma_buf          *dbuf;
>  };
>
>  /**
> @@ -83,12 +111,14 @@ struct vb2_plane {
>  * @VB2_USERPTR:       driver supports USERPTR with streaming API
>  * @VB2_READ:          driver supports read() style access
>  * @VB2_WRITE:         driver supports write() style access
> + * @VB2_DMABUF:                driver supports DMABUF with streaming API
>  */
>  enum vb2_io_modes {
>        VB2_MMAP        = (1 << 0),
>        VB2_USERPTR     = (1 << 1),
>        VB2_READ        = (1 << 2),
>        VB2_WRITE       = (1 << 3),
> +       VB2_DMABUF      = (1 << 4),
>  };
>
>  /**
> --
> 1.7.5.4

-- 
Best regards,
Pawel Osciak
