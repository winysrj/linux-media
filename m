Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:49165 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2ATKlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 05:41:42 -0500
Received: by qabg24 with SMTP id g24so242408qab.19
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2012 02:41:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMm-=zB+Sg4XZX_MLGt1fvURCFf8QbWcmZHSUbMYbGfiSz2+gg@mail.gmail.com>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
 <1325760118-27997-3-git-send-email-sumit.semwal@ti.com> <CAMm-=zB+Sg4XZX_MLGt1fvURCFf8QbWcmZHSUbMYbGfiSz2+gg@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Fri, 20 Jan 2012 16:11:20 +0530
Message-ID: <CAO_48GEo8icpXrFh_VmGUF-MU2N9BU=xrVVN0VRG37j5NbC0sQ@mail.gmail.com>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
To: Pawel Osciak <pawel@osciak.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, arnd@arndb.de,
	jesse.barker@linaro.org, m.szyprowski@samsung.com, rob@ti.com,
	daniel@ffwll.ch, t.stanislaws@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 January 2012 00:37, Pawel Osciak <pawel@osciak.com> wrote:
> Hi Sumit,
> Thank you for your work. Please find my comments below.
Hi Pawel,

Thank you for finding time for this review, and your comments :) - my
comments inline.
[Also, as an aside, Tomasz has also been working on the vb2 adaptation
to dma-buf, and his patches should be more comprehensive, in that he
is also planning to include 'vb2 as exporter' of dma-buf. He might
take and improve on this RFC, so it might be worthwhile to wait for
it?]
>
<snip>
>>  * __setup_offsets() - setup unique offsets ("cookies") for every plane in
>>  * every buffer on the queue
>>  */
>> @@ -228,6 +249,8 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
>>                /* Free MMAP buffers or release USERPTR buffers */
>>                if (q->memory == V4L2_MEMORY_MMAP)
>>                        __vb2_buf_mem_free(vb);
>> +               if (q->memory == V4L2_MEMORY_DMABUF)
>> +                       __vb2_buf_dmabuf_put(vb);
>>                else
>>                        __vb2_buf_userptr_put(vb);
>
> This looks like a bug. If memory is MMAP, you'd __vb2_buf_mem_free(vb)
> AND __vb2_buf_userptr_put(vb), which is wrong. Have you tested MMAP
> and USERPTR with those patches applied?
>
I agree - fairly stupid mistake on my end. will correct in the next version.
>>        }
>> @@ -350,6 +373,13 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>>                 */
>>                memcpy(b->m.planes, vb->v4l2_planes,
>>                        b->length * sizeof(struct v4l2_plane));
>> +
>> +               if (q->memory == V4L2_MEMORY_DMABUF) {
>> +                       unsigned int plane;
>> +                       for (plane = 0; plane < vb->num_planes; ++plane) {
>> +                               b->m.planes[plane].m.fd = 0;
>
> I'm confused here. Isn't this the way to return fd for userspace to
> pass to other drivers? I was imagining that the userspace would be
> getting an fd back in plane structure to pass to other drivers, i.e.
> userspace dequeuing a DMABUF v4l2_buffer should be able to pass it
> forward to another driver using fd found in dequeued buffer.
> Shouldn't this also fill in length?
>
Well, as a 'dma-buf' 'user', V4L2 will only get an FD from userspace
to map it to a dma-buf. The 'give-an-fd-to-pass-to-other-drivers' is
part of the exporter's functionality.
That's why I guess we did it like this - the __fill_vb2_buffer() does
copy data from userspace to vb2.
But perhaps you're right; it might be needed if the userspace refers
back to the fd from a dequeued buffer. Let me think through, and I
will reply again.
>> +                       }
<snip>
>> @@ -840,6 +899,11 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
>>                                        b->m.planes[plane].length;
>>                        }
>>                }
>> +               if (b->memory == V4L2_MEMORY_DMABUF) {
>> +                       for (plane = 0; plane < vb->num_planes; ++plane) {
>> +                               v4l2_planes[plane].m.fd = b->m.planes[plane].m.fd;
>
> Shouldn't this fill length too?
The reason this doesn't fill length is because length gets updated
based on the actual size of the buffer from the dma-buf gotten from
dma_buf_get() called in __qbuf_dmabuf().
>
>> +                       }
>> +               }
>>        } else {
>>                /*
>>                 * Single-planar buffers do not use planes array,
>> @@ -854,6 +918,10 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
>>                        v4l2_planes[0].m.userptr = b->m.userptr;
>>                        v4l2_planes[0].length = b->length;
>>                }
>> +               if (b->memory == V4L2_MEMORY_DMABUF) {
>> +                       v4l2_planes[0].m.fd = b->m.fd;
>
> Ditto.
see above.
>
>> +               }
>> +
>>        }
>>
>>        vb->v4l2_buf.field = b->field;
>> @@ -962,6 +1030,109 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>  }
>>
>>  /**
>> + * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
>> + */
>> +static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>> +{
>> +       struct v4l2_plane planes[VIDEO_MAX_PLANES];
>> +       struct vb2_queue *q = vb->vb2_queue;
>> +       void *mem_priv;
>> +       unsigned int plane;
>> +       int ret;
>> +       int write = !V4L2_TYPE_IS_OUTPUT(q->type);
>> +
>> +       /* Verify and copy relevant information provided by the userspace */
>> +       ret = __fill_vb2_buffer(vb, b, planes);
>> +       if (ret)
>> +               return ret;
>> +
>> +       for (plane = 0; plane < vb->num_planes; ++plane) {
>> +               struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
>> +
>> +               if (IS_ERR_OR_NULL(dbuf)) {
>> +                       dprintk(1, "qbuf: invalid dmabuf fd for "
>> +                               "plane %d\n", plane);
>> +                       ret = PTR_ERR(dbuf);
>> +                       goto err;
>> +               }
>> +
>> +               /* this doesn't get filled in until __fill_vb2_buffer(),
>> +                * since it isn't known until after dma_buf_get()..
>> +                */
>> +               planes[plane].length = dbuf->size;
>
> But this is after dma_buf_get, unless I'm missing something... And
> __fill_vb2_buffer() is not filing length...
I guess replacing "this doesn't get filled in until
__fill_vb2_buffer()" with "We fill length here instead of in
__fill_vb2_buffer()" would make it clearer? This only informs about
why length is being filled here.
>
>> +
>> +               /* Skip the plane if already verified */
>> +               if (dbuf == vb->planes[plane].dbuf) {
>> +                       dma_buf_put(dbuf);
>> +                       continue;
>> +               }
>
> Won't this prevent us from using a buffer if the exporter only allows
> exclusive access to it?
I wouldn't think so; dma_buf_get() can be nested calls, and the
dma_buf_put() should match correspoding dma_buf_get(). It is of course
dependent on the exporter though.
>
>> +
>> +               dprintk(3, "qbuf: buffer description for plane %d changed, "
>
> s/description/descriptor ?
Right.
>
>> +                       "reattaching dma buf\n", plane);
>> +
>> +               /* Release previously acquired memory if present */
>> +               if (vb->planes[plane].mem_priv) {
>> +                       call_memop(q, plane, detach_dmabuf,
>> +                               vb->planes[plane].mem_priv);
>> +                       dma_buf_put(vb->planes[plane].dbuf);
>> +               }
>> +
>> +               vb->planes[plane].mem_priv = NULL;
>> +
>> +               /* Acquire each plane's memory */
>> +               mem_priv = q->mem_ops->attach_dmabuf(
>> +                               q->alloc_ctx[plane], dbuf);
>> +               if (IS_ERR(mem_priv)) {
>> +                       dprintk(1, "qbuf: failed acquiring dmabuf "
>> +                               "memory for plane %d\n", plane);
>> +                       ret = PTR_ERR(mem_priv);
>> +                       goto err;
>
> Since mem_priv is not assigned back to plane's mem_priv if an error
> happens here, we won't be calling dma_buf_put on this dbuf, even
> though we called _get() above.
>
Yes you're right of course - we should just do a dma-buf-put() for the
new buf in the IS_ERR() case.

<snip>
>> + * @attach_dmabuf: attach a shared struct dma_buf for a hardware operation;
>> + *                used for DMABUF memory types; alloc_ctx is the alloc context
>> + *                dbuf is the shared dma_buf; returns NULL on failure;
>> + *                allocator private per-buffer structure on success;
>> + *                this needs to be used for further accesses to the buffer
>> + * @detach_dmabuf: inform the exporter of the buffer that the current DMABUF
>> + *                buffer is no longer used; the buf_priv argument is the
>> + *                allocator private per-buffer structure previously returned
>> + *                from the attach_dmabuf callback
>> + * @map_dmabuf: request for access to the dmabuf from allocator; the allocator
>> + *             of dmabuf is informed that this driver is going to use the
>> + *             dmabuf
>> + * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
>> + *               that this driver is done using the dmabuf for now
>
> I feel this requires more clarification. For example, for both detach
> and unmap this says "the current DMABUF buffer is no longer used" and
> "driver is done using the dmabuf for now", respectively. Without prior
> knowledge of dmabuf, you don't know which one to use in which
> situation. Similarly, attach and map could be clarified as well.
Ok - maybe I will put a small pseudo code here?
like this:
attach()
while we will use it {
 map()
 dma .. etc etc
 unmap()
}
// finished using the buffer completely
detach()
>
>> @@ -56,6 +71,8 @@ struct vb2_fileio_data;
>>  * Required ops for USERPTR types: get_userptr, put_userptr.
>>  * Required ops for MMAP types: alloc, put, num_users, mmap.
>>  * Required ops for read/write access types: alloc, put, num_users, vaddr
>> + * Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf,
>> + *                               unmap_dmabuf.
>>  */
>>  struct vb2_mem_ops {
>>        void            *(*alloc)(void *alloc_ctx, unsigned long size);
>> @@ -65,6 +82,16 @@ struct vb2_mem_ops {
>>                                        unsigned long size, int write);
>>        void            (*put_userptr)(void *buf_priv);
>>
>> +       /* Comment from Rob Clark: XXX: I think the attach / detach could be handled
>> +        * in the vb2 core, and vb2_mem_ops really just need to get/put the
>> +        * sglist (and make sure that the sglist fits it's needs..)
>> +        */
>
> I *strongly* agree with Rob here. Could you explain the reason behind
> not doing this?
> Allocator should ideally not have to be aware of attaching/detaching,
> this is not specific to an allocator.
>
Ok, I thought we'll start with this version first, and then refine.
But you guys are right.

> --
> Best regards,
> Pawel Osciak

-- 
Thanks and best regards,
Sumit Semwal
Linaro Kernel Engineer - Graphics working group
