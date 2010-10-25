Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:9476 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab0JYKwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 06:52:19 -0400
Received: from epmmp2 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0LAU00MKGE75EU50@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Oct 2010 19:52:17 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LAU00CS9E71W5@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Oct 2010 19:52:17 +0900 (KST)
Date: Mon, 25 Oct 2010 12:52:11 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 5/7] v4l: videobuf2: add read() emulator
In-reply-to: <AANLkTinyzJ9B8QCyQo89HBS0-yD09fPNSrSXUEBYJVYA@mail.gmail.com>
To: 'Pawel Osciak' <pawel@osciak.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com
Message-id: <019a01cb7432$aff02990$0fd07cb0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
References: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com>
 <1287556873-23179-6-git-send-email-m.szyprowski@samsung.com>
 <AANLkTinyzJ9B8QCyQo89HBS0-yD09fPNSrSXUEBYJVYA@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Monday, October 25, 2010 2:13 AM Pawel Osciak wrote:

> Hi Marek,
> This is a pretty crafty patch, you've managed to make it nice and
> clean, without adding complexity to streaming code. Nice job. A few of
> my comments below.

Thanks!

> On Tue, Oct 19, 2010 at 23:41, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> > Add a generic read() emulator for videobuf2. It uses MMAP memory type
> > buffers and generic vb2 calls: req_bufs, qbuf and dqbuf. Video date is
> > being copied from mmap buffers to userspace with standard copy_to_user()
> > function. To add read() support to the driver, only one additional
> > structure should be provides which defines the default number of buffers
> > used by emulator and detemines the style of read() emulation
> > ('streaming' or 'one shot').
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > CC: Pawel Osciak <pawel@osciak.com>
> > ---
> >  drivers/media/video/videobuf2-core.c |  322 ++++++++++++++++++++++++++++++++--
> >  include/media/videobuf2-core.h       |   21 +++
> >  2 files changed, 325 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> > index 4a29c49..ab00246 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -471,7 +471,7 @@ static bool __buffers_in_use(struct vb2_queue *q)
> >  * The return values from this function are intended to be directly returned
> >  * from vidioc_reqbufs handler in driver.
> >  */
> > -int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> > +static int __vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> >  {
> >        unsigned int num_buffers, num_planes;
> >        int ret = 0;
> > @@ -482,8 +482,6 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> >                return -EINVAL;
> >        }
> >
> > -       mutex_lock(&q->vb_lock);
> > -
> >        if (req->type != q->type) {
> >                dprintk(1, "reqbufs: queue type invalid\n");
> >                ret = -EINVAL;
> > @@ -567,6 +565,15 @@ end:
> >        mutex_unlock(&q->vb_lock);
> >        return ret;
> >  }
> > +
> > +int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> > +{
> > +       int ret = 0;
> > +       mutex_lock(&q->vb_lock);
> > +       ret = (q->read_data) ? -EBUSY : __vb2_reqbufs(q, req);
> > +       mutex_unlock(&q->vb_lock);
> > +       return ret;
> > +}
> >  EXPORT_SYMBOL_GPL(vb2_reqbufs);
> >
> >  /**
> > @@ -821,14 +828,11 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
> >  * The return values from this function are intended to be directly returned
> >  * from vidioc_qbuf handler in driver.
> >  */
> > -int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> > +static int __vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> >  {
> >        struct vb2_buffer *vb;
> > -       int ret;
> > -
> > -       mutex_lock(&q->vb_lock);
> > +       int ret = -EINVAL;
> >
> > -       ret = -EINVAL;
> >        if (b->type != q->type) {
> >                dprintk(1, "qbuf: invalid buffer type\n");
> >                goto done;
> > @@ -887,6 +891,14 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> >        dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
> >        ret = 0;
> >  done:
> > +       return ret;
> > +}
> > +
> > +int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> > +{
> > +       int ret = 0;
> > +       mutex_lock(&q->vb_lock);
> > +       ret = (q->read_data) ? -EBUSY : __vb2_qbuf(q, b);
> >        mutex_unlock(&q->vb_lock);
> >        return ret;
> >  }
> > @@ -996,13 +1008,11 @@ end:
> >  * The return values from this function are intended to be directly returned
> >  * from vidioc_dqbuf handler in driver.
> >  */
> > -int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
> > +static int __vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
> >  {
> >        struct vb2_buffer *vb = NULL;
> >        int ret;
> >
> > -       mutex_lock(&q->vb_lock);
> > -
> >        if (b->type != q->type) {
> >                dprintk(1, "dqbuf: invalid buffer type\n");
> >                ret = -EINVAL;
> > @@ -1047,6 +1057,14 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
> >        vb->state = VB2_BUF_STATE_DEQUEUED;
> >
> >  done:
> > +       return ret;
> > +}
> > +
> > +int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
> > +{
> > +       int ret;
> > +       mutex_lock(&q->vb_lock);
> > +       ret = (q->read_data) ? -EBUSY : __vb2_dqbuf(q, b, nonblocking);
> >        mutex_unlock(&q->vb_lock);
> >        return ret;
> >  }
> > @@ -1065,13 +1083,11 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
> >  * The return values from this function are intended to be directly returned
> >  * from vidioc_streamon handler in the driver.
> >  */
> > -int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
> > +static int __vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
> >  {
> >        struct vb2_buffer *vb;
> >        int ret = 0;
> >
> > -       mutex_lock(&q->vb_lock);
> > -
> >        if (type != q->type) {
> >                dprintk(1, "streamon: invalid stream type\n");
> >                ret = -EINVAL;
> > @@ -1113,6 +1129,14 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
> >
> >        dprintk(3, "Streamon successful\n");
> >  done:
> > +       return ret;
> > +}
> > +
> > +int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
> > +{
> > +       int ret;
> > +       mutex_lock(&q->vb_lock);
> > +       ret = (q->read_data) ? -EBUSY : __vb2_streamon(q, type);
> >        mutex_unlock(&q->vb_lock);
> >        return ret;
> >  }
> > @@ -1161,12 +1185,10 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
> >  * The return values from this function are intended to be directly returned
> >  * from vidioc_streamoff handler in the driver
> >  */
> > -int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
> > +static int __vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
> >  {
> >        int ret = 0;
> >
> > -       mutex_lock(&q->vb_lock);
> > -
> >        if (type != q->type) {
> >                dprintk(1, "streamoff: invalid stream type\n");
> >                ret = -EINVAL;
> > @@ -1187,6 +1209,14 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
> >
> >        dprintk(3, "Streamoff successful\n");
> >  end:
> > +       return ret;
> > +}
> > +
> > +int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
> > +{
> > +       int ret;
> > +       mutex_lock(&q->vb_lock);
> > +       ret = (q->read_data) ? -EBUSY : __vb2_streamoff(q, type);
> >        mutex_unlock(&q->vb_lock);
> >        return ret;
> >  }
> > @@ -1311,6 +1341,9 @@ bool vb2_has_consumers(struct vb2_queue *q)
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_has_consumers);
> >
> > +static int __vb2_init_read(struct vb2_queue *q);
> > +static int __vb2_cleanup_read(struct vb2_queue *q);
> > +
> >  /**
> >  * vb2_poll() - implements poll userspace operation
> >  * @q:         videobuf2 queue
> > @@ -1336,6 +1369,15 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table
> *wait)
> >        mutex_lock(&q->vb_lock);
> >
> >        /*
> > +        * Start read() emulator if streaming api has not been used yet.
> > +        */
> > +       if (q->num_buffers == 0 && q->read_data == NULL && q->read_ctx) {
> > +               ret = __vb2_init_read(q);
> > +               if (ret)
> > +                       goto end;
> > +       }
> > +
> > +       /*
> >         * There is nothing to wait for if no buffers have already been queued.
> >         */
> >        if (list_empty(&q->queued_list)) {
> > @@ -1378,12 +1420,15 @@ EXPORT_SYMBOL_GPL(vb2_poll);
> >  *             the given context will be used for memory allocation on all
> >  *             planes and buffers; it is possible to assign different contexts
> >  *             per plane, use vb2_set_alloc_ctx() for that
> > + * @read_ctx:  parameters for read() api to be used; can be NULL if no read
> > + *             callback is used
> >  * @type:      queue type
> >  * @drv_priv:  driver private data, may be NULL; it can be used by driver in
> >  *             driver-specific callbacks when issued
> >  */
> >  int vb2_queue_init(struct vb2_queue *q, const struct vb2_ops *ops,
> >                        const struct vb2_alloc_ctx *alloc_ctx,
> > +                       const struct vb2_read_ctx *read_ctx,
> >                        enum v4l2_buf_type type, void *drv_priv)
> >  {
> >        unsigned int i;
> > @@ -1403,6 +1448,7 @@ int vb2_queue_init(struct vb2_queue *q, const struct vb2_ops *ops,
> >        for (i = 0; i < VIDEO_MAX_PLANES; ++i)
> >                q->alloc_ctx[i] = alloc_ctx;
> >
> > +       q->read_ctx = read_ctx;
> >        q->type = type;
> >        q->drv_priv = drv_priv;
> >
> > @@ -1428,6 +1474,7 @@ void vb2_queue_release(struct vb2_queue *q)
> >  {
> >        mutex_lock(&q->vb_lock);
> >
> > +       __vb2_cleanup_read(q);
> >        __vb2_queue_cancel(q);
> >        __vb2_queue_free(q);
> >
> > @@ -1435,6 +1482,245 @@ void vb2_queue_release(struct vb2_queue *q)
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_queue_release);
> >
> > +/**
> > + * struct vb2_read_data - internal structure used by read() emulator
> > + *
> > + * vb2 provides a compatibility layer and emulator of read() calls on top
> > + * of streaming api. For proper operation it required this structure to
> > + * save the driver state between each call of the read function.
> > + */
> > +struct vb2_read_data {
> > +       struct v4l2_requestbuffers req;
> > +       struct v4l2_buffer b;
> > +       void *buff_vaddr[VIDEO_MAX_FRAME];
> > +       unsigned cur_offset;
> > +       unsigned cur_bufsize;
> > +       unsigned read_offset;
> > +       int cur_buffer;
> > +       int buffer_count;
> > +};
> > +
> > +/**
> > + * __vb2_init_read() - initialize read() emulator
> > + * @q:         videobuf2 queue
> > + */
> > +static int __vb2_init_read(struct vb2_queue *q)
> > +{
> > +       struct vb2_read_data *rd;
> > +       int i, ret;
> > +
> > +       if (!q->read_ctx)
> > +               BUG();
> > +
> > +       /*
> > +        * Check if device supports mapping buffers to kernel virtual space
> > +        */
> > +       if (!q->alloc_ctx[0]->mem_ops->vaddr)
> > +               return -EBUSY;
> > +
> > +       /*
> > +        * Check if steaming api has not been already activated.
> > +        */
> > +       if (q->streaming || q->num_buffers > 0)
> > +               return -EBUSY;
> > +
> > +       /*
> > +        * Basic checks done, lets try to set up read emulator
> > +        */
> > +       dprintk(3, "setting up read() emulator\n");
> > +
> > +       q->read_data = kmalloc(sizeof(struct vb2_read_data), GFP_KERNEL);
> > +       if (q->read_data == NULL)
> > +               return -ENOMEM;
> > +
> > +       memset(q->read_data, 0, sizeof(*q->read_data));
> 
> kzalloc() ?

Right

> 
> > +       rd = q->read_data;
> > +
> > +       /*
> > +        * Request buffers and use MMAP type to force driver
> > +        * to allocate buffers by itself.
> > +        */
> > +       rd->req.count = q->read_ctx->num_bufs;
> > +       rd->req.memory = V4L2_MEMORY_MMAP;
> > +       rd->req.type = q->type;
> > +       ret = __vb2_reqbufs(q, &rd->req);
> > +       if (ret)
> > +               goto err_kfree;
> > +
> > +       /*
> > +        * Check if plane_count is correct
> > +        * (multiplane buffers are not supported).
> > +        */
> > +       if (q->bufs[0]->num_planes != 1) {
> > +               rd->req.count = 0;
> > +               ret = -EBUSY;
> > +               goto err_reqbufs;
> > +       }
> > +
> > +       /*
> > +        * Get kernel address of each buffer.
> > +        */
> > +       for (i = 0; i < q->num_buffers; i++)
> > +               rd->buff_vaddr[i] = vb2_plane_vaddr(q->bufs[i], 0);
> > +
> 
> Even if the driver provided a vaddr() callback, it may still return a
> NULL. I'd be better to verify that here.

Right, I will fix this.

> > +       /*
> > +        * Queue all buffers.
> > +        */
> > +       for (i = 0; i < q->num_buffers; i++) {
> > +               memset(&rd->b, 0, sizeof(rd->b));
> > +               rd->b.type = q->type;
> > +               rd->b.memory = q->memory;
> > +               rd->b.index = i;
> > +               ret = __vb2_qbuf(q, &rd->b);
> > +               if (ret)
> > +                       goto err_reqbufs;
> > +       }
> > +
> > +       /*
> > +        * Start streaming.
> > +        */
> > +       ret = __vb2_streamon(q, q->type);
> > +       if (ret)
> > +               goto err_reqbufs;
> > +
> > +       return ret;
> > +
> > +err_reqbufs:
> > +       __vb2_reqbufs(q, &rd->req);
> > +
> > +err_kfree:
> > +       kfree(q->read_data);
> > +       return ret;
> > +}
> > +
> > +/**
> > + * __vb2_cleanup_read() - free resourced used by read() emulator
> > + * @q:         videobuf2 queue
> > + */
> > +static int __vb2_cleanup_read(struct vb2_queue *q)
> > +{
> > +       struct vb2_read_data *rd = q->read_data;
> > +       if (rd) {
> > +               __vb2_streamoff(q, q->type);
> > +               rd->req.count = 0;
> > +               __vb2_reqbufs(q, &rd->req);
> > +               kfree(rd);
> > +               q->read_data = NULL;
> > +               dprintk(3, "read() emulator released\n");
> > +       }
> > +       return 0;
> > +}
> > +
> > +size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
> > +               loff_t *ppos, int nonblocking)
> > +{
> > +       struct vb2_read_data *rd;
> > +       int ret;
> > +
> > +       dprintk(3, "read: offset %ld, count %d, %sblocking\n", (long)*ppos,
> > +               count, nonblocking ? "non" : "");
> > +
> > +       if (!data)
> > +               return -EINVAL;
> > +
> > +       mutex_lock(&q->vb_lock);
> > +
> > +       /*
> > +        * Initialize emulator on first read() call.
> > +        */
> > +       if (!q->read_data) {
> > +               ret = __vb2_init_read(q);
> > +               dprintk(3, "read: vb2_init_read result: %d\n", ret);
> > +               if (ret)
> > +                       goto end;
> > +       }
> > +
> > +       rd = q->read_data;
> > +
> > +       /*
> > +        * Current buffer is empty...
> > +        */
> > +       if (rd->cur_offset == 0 && rd->cur_bufsize == 0) {
> > +               /*
> > +                * ... check if this was the last buffer to read.
> > +                */
> > +               if (q->read_ctx->read_once &&
> > +                   rd->buffer_count == q->read_ctx->num_bufs) {
> > +                       ret = __vb2_cleanup_read(q);
> > +                       goto end;
> > +               }
> > +
> > +               /*
> > +                * ... or call vb2_dqbuf to get next buffer with data.
> > +                */
> > +               memset(&rd->b, 0, sizeof(rd->b));
> > +               rd->b.type = q->type;
> > +               rd->b.memory = q->memory;
> > +               rd->b.index = rd->cur_buffer;
> > +               ret = __vb2_dqbuf(q, &rd->b, nonblocking);
> > +               dprintk(5, "read: vb2_dqbuf result: %d\n", ret);
> > +               if (ret)
> > +                       goto end;
> > +               rd->buffer_count += 1;
> > +               rd->cur_bufsize = rd->b.length;
> 
> This is tricky. Since you are supporting both non-multiplanar types
> and 1-plane multiplanar, in the latter case this value will be in
> b.m.planes[0]->length instead.

Well, in fact I should use b.bytesused here. I will update the code to read
it from q->bufs->planes[0].bytesused.

> 
> > +       }
> > +
> > +       /*
> > +        * Limit count on last few bytes of the buffer.
> > +        */
> 
> This comment is confusing. Maybe something like "If the user requested
> more bytes than we can fit in buffer, reduce that number" would be
> better?

OK
 
> > +       if (count + rd->cur_offset > rd->cur_bufsize) {
> > +               count = rd->cur_bufsize - rd->cur_offset;
> > +               dprintk(5, "reducing read count: %d\n", count);
> > +       }
> > +
> > +       /*
> > +        * Transfer data to userspace.
> > +        */
> > +       dprintk(3, "read: copying %d data from buffer %d (offset %d bytes)\n",
> > +               count, rd->cur_buffer, rd->cur_offset);
> > +       if (copy_to_user(data,
> > +                        rd->buff_vaddr[rd->cur_buffer] + rd->cur_offset,
> > +                        count)) {
> > +               dprintk(3, "read: error copying data\n");
> > +               ret = -EFAULT;
> > +               goto end;
> > +       }
> > +
> > +       /*
> > +        * Update counters.
> > +        */
> > +       rd->cur_offset += count;
> > +       rd->read_offset += count;
> > +       *ppos += count;
> > +
> > +       /*
> > +        * Queue next buffer if required.
> > +        */
> > +       if (rd->cur_offset == rd->cur_bufsize) {
> 
> This should actually be rd->cur_offset == rd->b.planes[0].bytesused
> for 1-plane multiplanar and rd->b.bytesused for non-multiplanar. (See
> also my comment about length above). You want to get the size of
> actual video data, which may be smaller than buffer size.

Right, I used wrong field here.
 
> By the way, vb2 internally always stores those values in planes[0],
> even for non-multiplanar types, which makes things more consistent,
> but you are using dqbuf and everything gets moved back to v4l2_buffer
> struct there.

Right, I will use it then to simplify the code;

> <snip>

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

