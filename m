Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1219 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaBMJLP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 04:11:15 -0500
Message-ID: <52FC8B4C.7040702@xs4all.nl>
Date: Thu, 13 Feb 2014 10:07:24 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Pawel Osciak <pawel@osciak.com>
CC: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 01/10] vb2: add debugging code to check for unbalanced
 ops.
References: <1391684554-37956-1-git-send-email-hverkuil@xs4all.nl> <1391684554-37956-2-git-send-email-hverkuil@xs4all.nl> <CAMm-=zAwCmt9c+y_ByBDm0PpvEfvi9sH-76UaEYxEzQHggiHxA@mail.gmail.com>
In-Reply-To: <CAMm-=zAwCmt9c+y_ByBDm0PpvEfvi9sH-76UaEYxEzQHggiHxA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/14 09:01, Pawel Osciak wrote:
> Hi Hans,
> Thanks for the patch. I'm really happy to see this, it's a great idea
> and it will be very useful.
> 
> Two comments:
> - What do you think about moving the debug stuff to something like
> videobuf2-debug.{c,h} instead?

It's not quite worth it at the moment IMHO.

> - At this point vb2_buffer_done() shouldn't be required to be balanced
> with buf_queue(). I know later patches in this series will require it,
> but at this point it's not true. Perhaps we should move this to the
> 8th patch or after it? I don't feel too strong about this though.

I disagree with you here. It has always been required, except nobody noticed
it. Without the call to vb2_buffer_done the finish memop will never be called.

That's always been wrong.

Regards,

	Hans

> 
> One more nit inline.
> 
> But in general:
> 
> Acked-by: Pawel Osciak <pawel@osciak.com>
> 
> 
> On Thu, Feb 6, 2014 at 8:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> When a vb2_queue is freed check if all the mem_ops and queue ops were balanced.
>> So the number of calls to e.g. buf_finish has to match the number of calls to
>> buf_prepare, etc.
>>
>> This code is only enabled if CONFIG_VIDEO_ADV_DEBUG is set.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 233 ++++++++++++++++++++++++-------
>>  include/media/videobuf2-core.h           |  43 ++++++
>>  2 files changed, 226 insertions(+), 50 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 5a5fb7f..07b58bd 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -33,12 +33,63 @@ module_param(debug, int, 0644);
>>                         printk(KERN_DEBUG "vb2: " fmt, ## arg);         \
>>         } while (0)
>>
>> -#define call_memop(q, op, args...)                                     \
>> -       (((q)->mem_ops->op) ?                                           \
>> -               ((q)->mem_ops->op(args)) : 0)
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +
>> +/*
>> + * If advanced debugging is on, then count how often each op is called,
>> + * which can either be per-buffer or per-queue.
>> + *
>> + * If the op failed then the 'fail_' variant is called to decrease the
>> + * counter. That makes it easy to check that the 'init' and 'cleanup'
>> + * (and variations thereof) stay balanced.
>> + */
>> +
>> +#define call_memop(vb, op, args...)                                    \
>> +({                                                                     \
>> +       struct vb2_queue *_q = (vb)->vb2_queue;                         \
>> +       dprintk(2, "call_memop(%p, %d, %s)%s\n",                        \
>> +               _q, (vb)->v4l2_buf.index, #op,                          \
>> +               _q->mem_ops->op ? "" : " (nop)");                       \
>> +       (vb)->cnt_mem_ ## op++;                                         \
>> +       _q->mem_ops->op ? _q->mem_ops->op(args) : 0;                    \
>> +})
>> +#define fail_memop(vb, op) ((vb)->cnt_mem_ ## op--)
>> +
>> +#define call_qop(q, op, args...)                                       \
>> +({                                                                     \
>> +       dprintk(2, "call_qop(%p, %s)%s\n", q, #op,                      \
>> +               (q)->ops->op ? "" : " (nop)");                          \
>> +       (q)->cnt_ ## op++;                                              \
>> +       (q)->ops->op ? (q)->ops->op(args) : 0;                          \
>> +})
>> +#define fail_qop(q, op) ((q)->cnt_ ## op--)
>> +
>> +#define call_vb_qop(vb, op, args...)                                   \
>> +({                                                                     \
>> +       struct vb2_queue *_q = (vb)->vb2_queue;                         \
>> +       dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",                       \
>> +               _q, (vb)->v4l2_buf.index, #op,                          \
>> +               _q->ops->op ? "" : " (nop)");                           \
>> +       (vb)->cnt_ ## op++;                                             \
>> +       _q->ops->op ? _q->ops->op(args) : 0;                            \
>> +})
>> +#define fail_vb_qop(vb, op) ((vb)->cnt_ ## op--)
>> +
>> +#else
>> +
>> +#define call_memop(vb, op, args...)                                    \
>> +       ((vb)->vb2_queue->mem_ops->op ? (vb)->vb2_queue->mem_ops->op(args) : 0)
>> +#define fail_memop(vb, op)
>>
>>  #define call_qop(q, op, args...)                                       \
>> -       (((q)->ops->op) ? ((q)->ops->op(args)) : 0)
>> +       ((q)->ops->op ? (q)->ops->op(args) : 0)
>> +#define fail_qop(q, op)
>> +
>> +#define call_vb_qop(vb, op, args...)                                   \
>> +       ((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
>> +#define fail_vb_qop(vb, op)
>> +
>> +#endif
>>
>>  #define V4L2_BUFFER_MASK_FLAGS (V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
>>                                  V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR | \
>> @@ -61,7 +112,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>>         for (plane = 0; plane < vb->num_planes; ++plane) {
>>                 unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
>>
>> -               mem_priv = call_memop(q, alloc, q->alloc_ctx[plane],
>> +               mem_priv = call_memop(vb, alloc, q->alloc_ctx[plane],
>>                                       size, q->gfp_flags);
>>                 if (IS_ERR_OR_NULL(mem_priv))
>>                         goto free;
>> @@ -73,9 +124,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>>
>>         return 0;
>>  free:
>> +       fail_memop(vb, alloc);
>>         /* Free already allocated memory if one of the allocations failed */
>>         for (; plane > 0; --plane) {
>> -               call_memop(q, put, vb->planes[plane - 1].mem_priv);
>> +               call_memop(vb, put, vb->planes[plane - 1].mem_priv);
>>                 vb->planes[plane - 1].mem_priv = NULL;
>>         }
>>
>> @@ -87,11 +139,10 @@ free:
>>   */
>>  static void __vb2_buf_mem_free(struct vb2_buffer *vb)
>>  {
>> -       struct vb2_queue *q = vb->vb2_queue;
>>         unsigned int plane;
>>
>>         for (plane = 0; plane < vb->num_planes; ++plane) {
>> -               call_memop(q, put, vb->planes[plane].mem_priv);
>> +               call_memop(vb, put, vb->planes[plane].mem_priv);
>>                 vb->planes[plane].mem_priv = NULL;
>>                 dprintk(3, "Freed plane %d of buffer %d\n", plane,
>>                         vb->v4l2_buf.index);
>> @@ -104,12 +155,11 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
>>   */
>>  static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
>>  {
>> -       struct vb2_queue *q = vb->vb2_queue;
>>         unsigned int plane;
>>
>>         for (plane = 0; plane < vb->num_planes; ++plane) {
>>                 if (vb->planes[plane].mem_priv)
>> -                       call_memop(q, put_userptr, vb->planes[plane].mem_priv);
>> +                       call_memop(vb, put_userptr, vb->planes[plane].mem_priv);
>>                 vb->planes[plane].mem_priv = NULL;
>>         }
>>  }
>> @@ -118,15 +168,15 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
>>   * __vb2_plane_dmabuf_put() - release memory associated with
>>   * a DMABUF shared plane
>>   */
>> -static void __vb2_plane_dmabuf_put(struct vb2_queue *q, struct vb2_plane *p)
>> +static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
>>  {
>>         if (!p->mem_priv)
>>                 return;
>>
>>         if (p->dbuf_mapped)
>> -               call_memop(q, unmap_dmabuf, p->mem_priv);
>> +               call_memop(vb, unmap_dmabuf, p->mem_priv);
>>
>> -       call_memop(q, detach_dmabuf, p->mem_priv);
>> +       call_memop(vb, detach_dmabuf, p->mem_priv);
>>         dma_buf_put(p->dbuf);
>>         memset(p, 0, sizeof(*p));
>>  }
>> @@ -137,11 +187,10 @@ static void __vb2_plane_dmabuf_put(struct vb2_queue *q, struct vb2_plane *p)
>>   */
>>  static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
>>  {
>> -       struct vb2_queue *q = vb->vb2_queue;
>>         unsigned int plane;
>>
>>         for (plane = 0; plane < vb->num_planes; ++plane)
>> -               __vb2_plane_dmabuf_put(q, &vb->planes[plane]);
>> +               __vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
>>  }
>>
>>  /**
>> @@ -246,10 +295,11 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
>>                          * callback, if given. An error in initialization
>>                          * results in queue setup failure.
>>                          */
>> -                       ret = call_qop(q, buf_init, vb);
>> +                       ret = call_vb_qop(vb, buf_init, vb);
>>                         if (ret) {
>>                                 dprintk(1, "Buffer %d %p initialization"
>>                                         " failed\n", buffer, vb);
>> +                               fail_vb_qop(vb, buf_init);
>>                                 __vb2_buf_mem_free(vb);
>>                                 kfree(vb);
>>                                 break;
>> @@ -321,18 +371,77 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>>         }
>>
>>         /* Call driver-provided cleanup function for each buffer, if provided */
>> -       if (q->ops->buf_cleanup) {
>> -               for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
>> -                    ++buffer) {
>> -                       if (NULL == q->bufs[buffer])
>> -                               continue;
>> -                       q->ops->buf_cleanup(q->bufs[buffer]);
>> -               }
>> +       for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
>> +            ++buffer) {
>> +               if (q->bufs[buffer])
>> +                       call_vb_qop(q->bufs[buffer], buf_cleanup, q->bufs[buffer]);
>>         }
>>
>>         /* Release video buffer memory */
>>         __vb2_free_mem(q, buffers);
>>
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +       /*
>> +        * Check that all the calls were balances during the life-time of this
>> +        * queue. If not (or if the debug level is 1 or up), then dump the
>> +        * counters to the kernel log.
>> +        */
>> +       if (q->num_buffers) {
>> +               bool unbalanced = q->cnt_start_streaming != q->cnt_stop_streaming ||
>> +                                 q->cnt_wait_prepare != q->cnt_wait_finish;
>> +
>> +               if (unbalanced || debug) {
>> +                       pr_info("vb2: counters for queue %p:%s\n", q,
>> +                               unbalanced ? " UNBALANCED!" : "");
>> +                       pr_info("vb2:     setup: %u start_streaming: %u stop_streaming: %u\n",
>> +                               q->cnt_queue_setup, q->cnt_start_streaming,
>> +                               q->cnt_stop_streaming);
>> +                       pr_info("vb2:     wait_prepare: %u wait_finish: %u\n",
>> +                               q->cnt_wait_prepare, q->cnt_wait_finish);
>> +               }
>> +               q->cnt_queue_setup = 0;
>> +               q->cnt_wait_prepare = 0;
>> +               q->cnt_wait_finish = 0;
>> +               q->cnt_start_streaming = 0;
>> +               q->cnt_stop_streaming = 0;
>> +       }
>> +       for (buffer = 0; buffer < q->num_buffers; ++buffer) {
>> +               struct vb2_buffer *vb = q->bufs[buffer];
>> +               bool unbalanced = vb->cnt_mem_alloc != vb->cnt_mem_put ||
>> +                                 vb->cnt_mem_prepare != vb->cnt_mem_finish ||
>> +                                 vb->cnt_mem_get_userptr != vb->cnt_mem_put_userptr ||
>> +                                 vb->cnt_mem_attach_dmabuf != vb->cnt_mem_detach_dmabuf ||
>> +                                 vb->cnt_mem_map_dmabuf != vb->cnt_mem_unmap_dmabuf ||
>> +                                 vb->cnt_buf_queue != vb->cnt_buf_done ||
>> +                                 vb->cnt_buf_prepare != vb->cnt_buf_finish ||
>> +                                 vb->cnt_buf_init != vb->cnt_buf_cleanup;
>> +
>> +               if (unbalanced || debug) {
>> +                       pr_info("vb2:   counters for queue %p, buffer %d:%s\n",
>> +                               q, buffer, unbalanced ? " UNBALANCED!" : "");
>> +                       pr_info("vb2:     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
>> +                               vb->cnt_buf_init, vb->cnt_buf_cleanup,
>> +                               vb->cnt_buf_prepare, vb->cnt_buf_finish);
>> +                       pr_info("vb2:     buf_queue: %u buf_done: %u\n",
>> +                               vb->cnt_buf_queue, vb->cnt_buf_done);
>> +                       pr_info("vb2:     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
>> +                               vb->cnt_mem_alloc, vb->cnt_mem_put,
>> +                               vb->cnt_mem_prepare, vb->cnt_mem_finish,
>> +                               vb->cnt_mem_mmap);
>> +                       pr_info("vb2:     get_userptr: %u put_userptr: %u\n",
>> +                               vb->cnt_mem_get_userptr, vb->cnt_mem_put_userptr);
>> +                       pr_info("vb2:     attach_dmabuf: %u detach_dmabuf: %u map_dmabuf: %u unmap_dmabuf: %u\n",
>> +                               vb->cnt_mem_attach_dmabuf, vb->cnt_mem_detach_dmabuf,
>> +                               vb->cnt_mem_map_dmabuf, vb->cnt_mem_unmap_dmabuf);
>> +                       pr_info("vb2:     get_dmabuf: %u num_users: %u vaddr: %u cookie: %u\n",
>> +                               vb->cnt_mem_get_dmabuf,
>> +                               vb->cnt_mem_num_users,
>> +                               vb->cnt_mem_vaddr,
>> +                               vb->cnt_mem_cookie);
>> +               }
>> +       }
>> +#endif
>> +
>>         /* Free videobuf buffers */
>>         for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
>>              ++buffer) {
>> @@ -424,7 +533,7 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>>                  * case anyway. If num_users() returns more than 1,
>>                  * we are not the only user of the plane's memory.
>>                  */
>> -               if (mem_priv && call_memop(q, num_users, mem_priv) > 1)
>> +               if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
>>                         return true;
>>         }
>>         return false;
>> @@ -703,8 +812,10 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>>          */
>>         ret = call_qop(q, queue_setup, q, NULL, &num_buffers, &num_planes,
>>                        q->plane_sizes, q->alloc_ctx);
>> -       if (ret)
>> +       if (ret) {
>> +               fail_qop(q, queue_setup);
>>                 return ret;
>> +       }
>>
>>         /* Finally, allocate buffers and video memory */
>>         ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
>> @@ -723,6 +834,8 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>>
>>                 ret = call_qop(q, queue_setup, q, NULL, &num_buffers,
>>                                &num_planes, q->plane_sizes, q->alloc_ctx);
>> +               if (ret)
>> +                       fail_qop(q, queue_setup);
>>
>>                 if (!ret && allocated_buffers < num_buffers)
>>                         ret = -ENOMEM;
>> @@ -803,8 +916,10 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>>          */
>>         ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
>>                        &num_planes, q->plane_sizes, q->alloc_ctx);
>> -       if (ret)
>> +       if (ret) {
>> +               fail_qop(q, queue_setup);
>>                 return ret;
>> +       }
>>
>>         /* Finally, allocate buffers and video memory */
>>         ret = __vb2_queue_alloc(q, create->memory, num_buffers,
>> @@ -828,6 +943,8 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>>                  */
>>                 ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
>>                                &num_planes, q->plane_sizes, q->alloc_ctx);
>> +               if (ret)
>> +                       fail_qop(q, queue_setup);
>>
>>                 if (!ret && allocated_buffers < num_buffers)
>>                         ret = -ENOMEM;
>> @@ -882,12 +999,10 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
>>   */
>>  void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
>>  {
>> -       struct vb2_queue *q = vb->vb2_queue;
>> -
>>         if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
>>                 return NULL;
>>
>> -       return call_memop(q, vaddr, vb->planes[plane_no].mem_priv);
>> +       return call_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
>>
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
>> @@ -905,12 +1020,10 @@ EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
>>   */
>>  void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
>>  {
>> -       struct vb2_queue *q = vb->vb2_queue;
>> -
>>         if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
>>                 return NULL;
>>
>> -       return call_memop(q, cookie, vb->planes[plane_no].mem_priv);
>> +       return call_memop(vb, cookie, vb->planes[plane_no].mem_priv);
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_plane_cookie);
>>
>> @@ -938,12 +1051,19 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>>         if (state != VB2_BUF_STATE_DONE && state != VB2_BUF_STATE_ERROR)
>>                 return;
>>
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +       /*
>> +        * Although this is not a callback, it still does have to balance
>> +        * with the buf_queue op. So update this counter manually.
>> +        */
>> +       vb->cnt_buf_done++;
>> +#endif
>>         dprintk(4, "Done processing on buffer %d, state: %d\n",
>>                         vb->v4l2_buf.index, state);
>>
>>         /* sync buffers */
>>         for (plane = 0; plane < vb->num_planes; ++plane)
>> -               call_memop(q, finish, vb->planes[plane].mem_priv);
>> +               call_memop(vb, finish, vb->planes[plane].mem_priv);
>>
>>         /* Add the buffer to the done buffers list */
>>         spin_lock_irqsave(&q->done_lock, flags);
>> @@ -1067,19 +1187,20 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>
>>                 /* Release previously acquired memory if present */
>>                 if (vb->planes[plane].mem_priv)
>> -                       call_memop(q, put_userptr, vb->planes[plane].mem_priv);
>> +                       call_memop(vb, put_userptr, vb->planes[plane].mem_priv);
>>
>>                 vb->planes[plane].mem_priv = NULL;
>>                 vb->v4l2_planes[plane].m.userptr = 0;
>>                 vb->v4l2_planes[plane].length = 0;
>>
>>                 /* Acquire each plane's memory */
>> -               mem_priv = call_memop(q, get_userptr, q->alloc_ctx[plane],
>> +               mem_priv = call_memop(vb, get_userptr, q->alloc_ctx[plane],
>>                                       planes[plane].m.userptr,
>>                                       planes[plane].length, write);
>>                 if (IS_ERR_OR_NULL(mem_priv)) {
>>                         dprintk(1, "qbuf: failed acquiring userspace "
>>                                                 "memory for plane %d\n", plane);
>> +                       fail_memop(vb, get_userptr);
>>                         ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
>>                         goto err;
>>                 }
>> @@ -1090,9 +1211,10 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>          * Call driver-specific initialization on the newly acquired buffer,
>>          * if provided.
>>          */
>> -       ret = call_qop(q, buf_init, vb);
>> +       ret = call_vb_qop(vb, buf_init, vb);
>>         if (ret) {
>>                 dprintk(1, "qbuf: buffer initialization failed\n");
>> +               fail_vb_qop(vb, buf_init);
>>                 goto err;
>>         }
>>
>> @@ -1108,7 +1230,7 @@ err:
>>         /* In case of errors, release planes that were already acquired */
>>         for (plane = 0; plane < vb->num_planes; ++plane) {
>>                 if (vb->planes[plane].mem_priv)
>> -                       call_memop(q, put_userptr, vb->planes[plane].mem_priv);
>> +                       call_memop(vb, put_userptr, vb->planes[plane].mem_priv);
>>                 vb->planes[plane].mem_priv = NULL;
>>                 vb->v4l2_planes[plane].m.userptr = 0;
>>                 vb->v4l2_planes[plane].length = 0;
>> @@ -1173,14 +1295,15 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>                 dprintk(1, "qbuf: buffer for plane %d changed\n", plane);
>>
>>                 /* Release previously acquired memory if present */
>> -               __vb2_plane_dmabuf_put(q, &vb->planes[plane]);
>> +               __vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
>>                 memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
>>
>>                 /* Acquire each plane's memory */
>> -               mem_priv = call_memop(q, attach_dmabuf, q->alloc_ctx[plane],
>> +               mem_priv = call_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
>>                         dbuf, planes[plane].length, write);
>>                 if (IS_ERR(mem_priv)) {
>>                         dprintk(1, "qbuf: failed to attach dmabuf\n");
>> +                       fail_memop(vb, attach_dmabuf);
>>                         ret = PTR_ERR(mem_priv);
>>                         dma_buf_put(dbuf);
>>                         goto err;
>> @@ -1195,10 +1318,11 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>          * the buffer(s)..
>>          */
>>         for (plane = 0; plane < vb->num_planes; ++plane) {
>> -               ret = call_memop(q, map_dmabuf, vb->planes[plane].mem_priv);
>> +               ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
>>                 if (ret) {
>>                         dprintk(1, "qbuf: failed to map dmabuf for plane %d\n",
>>                                 plane);
>> +                       fail_memop(vb, map_dmabuf);
>>                         goto err;
>>                 }
>>                 vb->planes[plane].dbuf_mapped = 1;
>> @@ -1208,9 +1332,10 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>          * Call driver-specific initialization on the newly acquired buffer,
>>          * if provided.
>>          */
>> -       ret = call_qop(q, buf_init, vb);
>> +       ret = call_vb_qop(vb, buf_init, vb);
>>         if (ret) {
>>                 dprintk(1, "qbuf: buffer initialization failed\n");
>> +               fail_vb_qop(vb, buf_init);
>>                 goto err;
>>         }
>>
>> @@ -1242,9 +1367,9 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>>
>>         /* sync buffers */
>>         for (plane = 0; plane < vb->num_planes; ++plane)
>> -               call_memop(q, prepare, vb->planes[plane].mem_priv);
>> +               call_memop(vb, prepare, vb->planes[plane].mem_priv);
>>
>> -       q->ops->buf_queue(vb);
>> +       call_vb_qop(vb, buf_queue, vb);
>>  }
>>
>>  static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>> @@ -1295,8 +1420,11 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>                 ret = -EINVAL;
>>         }
>>
>> -       if (!ret)
>> -               ret = call_qop(q, buf_prepare, vb);
>> +       if (!ret) {
>> +               ret = call_vb_qop(vb, buf_prepare, vb);
>> +               if (ret)
>> +                       fail_vb_qop(vb, buf_prepare);
>> +       }
>>         if (ret)
>>                 dprintk(1, "qbuf: buffer preparation failed: %d\n", ret);
>>         vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
>> @@ -1393,6 +1521,8 @@ static int vb2_start_streaming(struct vb2_queue *q)
>>
>>         /* Tell the driver to start streaming */
>>         ret = call_qop(q, start_streaming, q, atomic_read(&q->queued_count));
>> +       if (ret)
>> +               fail_qop(q, start_streaming);
> 
> I wonder whether we should treat ENOBUFS as a failed callback. It
> won't balance then either, will it?

That's correct. Which is why patch 8/10 replaces the whole ENOBUFS idea with
a cleaner solution.

Regards,

	Hans
