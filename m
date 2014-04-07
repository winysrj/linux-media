Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:61858 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbaDGHbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 03:31:00 -0400
Received: by mail-yh0-f43.google.com with SMTP id b6so5413908yha.2
        for <linux-media@vger.kernel.org>; Mon, 07 Apr 2014 00:30:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394486458-9836-5-git-send-email-hverkuil@xs4all.nl>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl> <1394486458-9836-5-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 7 Apr 2014 16:30:19 +0900
Message-ID: <CAMm-=zANa3wF5kd2dBZMWtdr4rMGRtEizwJsY9nUrQZPkuHQrg@mail.gmail.com>
Subject: Re: [REVIEW PATCH 04/11] vb2: use correct prefix
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The idea behind not using __func__ was that it was much more
informative when debugging to see a "reqbufs" prefix instead of, for
example "__verify_memory_type". But since some of the functions are
shared across multiple ioctl impls now (e.g. __verify_memory_type is
used by both reqbufs and createbufs), as much as I would prefer to
keep this convention, it'd probably be too much to maintain.

But if we want to do this, we should move "__func__" to dprintk()
definition, instead of adding it to the call sites.

On Tue, Mar 11, 2014 at 6:20 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Many dprintk's in vb2 use a hardcoded prefix with the function name. In
> many cases that is now outdated. Replace prefixes by the function name using
> __func__. At least now I know if I see a 'qbuf:' prefix whether that refers
> to the mmap, userptr or dmabuf variant.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 102 ++++++++++++++++---------------
>  1 file changed, 54 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 83e78e9..71be247 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -371,7 +371,8 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>                 if (q->bufs[buffer] == NULL)
>                         continue;
>                 if (q->bufs[buffer]->state == VB2_BUF_STATE_PREPARING) {
> -                       dprintk(1, "reqbufs: preparing buffers, cannot free\n");
> +                       dprintk(1, "%s: preparing buffers, cannot free\n",
> +                                       __func__);
>                         return -EAGAIN;
>                 }
>         }
> @@ -656,12 +657,12 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
>         int ret;
>
>         if (b->type != q->type) {
> -               dprintk(1, "querybuf: wrong buffer type\n");
> +               dprintk(1, "%s: wrong buffer type\n", __func__);
>                 return -EINVAL;
>         }
>
>         if (b->index >= q->num_buffers) {
> -               dprintk(1, "querybuf: buffer index out of range\n");
> +               dprintk(1, "%s: buffer index out of range\n", __func__);
>                 return -EINVAL;
>         }
>         vb = q->bufs[b->index];
> @@ -721,12 +722,12 @@ static int __verify_memory_type(struct vb2_queue *q,
>  {
>         if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR &&
>             memory != V4L2_MEMORY_DMABUF) {
> -               dprintk(1, "reqbufs: unsupported memory type\n");
> +               dprintk(1, "%s: unsupported memory type\n", __func__);
>                 return -EINVAL;
>         }
>
>         if (type != q->type) {
> -               dprintk(1, "reqbufs: requested type is incorrect\n");
> +               dprintk(1, "%s: requested type is incorrect\n", __func__);
>                 return -EINVAL;
>         }
>
> @@ -735,17 +736,20 @@ static int __verify_memory_type(struct vb2_queue *q,
>          * are available.
>          */
>         if (memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
> -               dprintk(1, "reqbufs: MMAP for current setup unsupported\n");
> +               dprintk(1, "%s: MMAP for current setup unsupported\n",
> +                               __func__);
>                 return -EINVAL;
>         }
>
>         if (memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
> -               dprintk(1, "reqbufs: USERPTR for current setup unsupported\n");
> +               dprintk(1, "%s: USERPTR for current setup unsupported\n",
> +                               __func__);
>                 return -EINVAL;
>         }
>
>         if (memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
> -               dprintk(1, "reqbufs: DMABUF for current setup unsupported\n");
> +               dprintk(1, "%s: DMABUF for current setup unsupported\n",
> +                               __func__);
>                 return -EINVAL;
>         }
>
> @@ -755,7 +759,7 @@ static int __verify_memory_type(struct vb2_queue *q,
>          * do the memory and type validation.
>          */
>         if (q->fileio) {
> -               dprintk(1, "reqbufs: file io in progress\n");
> +               dprintk(1, "%s: file io in progress\n", __func__);
>                 return -EBUSY;
>         }
>         return 0;
> @@ -790,7 +794,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>         int ret;
>
>         if (q->streaming) {
> -               dprintk(1, "reqbufs: streaming active\n");
> +               dprintk(1, "%s: streaming active\n", __func__);
>                 return -EBUSY;
>         }
>
> @@ -800,7 +804,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>                  * are not in use and can be freed.
>                  */
>                 if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
> -                       dprintk(1, "reqbufs: memory in use, cannot free\n");
> +                       dprintk(1, "%s: memory in use, cannot free\n", __func__);
>                         return -EBUSY;
>                 }
>
> @@ -1272,15 +1276,14 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                     && vb->v4l2_planes[plane].length == planes[plane].length)
>                         continue;
>
> -               dprintk(3, "qbuf: userspace address for plane %d changed, "
> -                               "reacquiring memory\n", plane);
> +               dprintk(3, "%s: userspace address for plane %d changed, reacquiring memory\n",
> +                       __func__, plane);
>
>                 /* Check if the provided plane buffer is large enough */
>                 if (planes[plane].length < q->plane_sizes[plane]) {
> -                       dprintk(1, "qbuf: provided buffer size %u is less than "
> -                                               "setup size %u for plane %d\n",
> -                                               planes[plane].length,
> -                                               q->plane_sizes[plane], plane);
> +                       dprintk(1, "%s: provided buffer size %u is less than setup size %u for plane %d\n",
> +                               __func__, planes[plane].length,
> +                               q->plane_sizes[plane], plane);
>                         ret = -EINVAL;
>                         goto err;
>                 }
> @@ -1302,8 +1305,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                                       planes[plane].m.userptr,
>                                       planes[plane].length, write);
>                 if (IS_ERR_OR_NULL(mem_priv)) {
> -                       dprintk(1, "qbuf: failed acquiring userspace "
> -                                               "memory for plane %d\n", plane);
> +                       dprintk(1, "%s: failed acquiring userspace memory for plane %d\n",
> +                               __func__, plane);
>                         fail_memop(vb, get_userptr);
>                         ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
>                         goto err;
> @@ -1326,7 +1329,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                  */
>                 ret = call_vb_qop(vb, buf_init, vb);
>                 if (ret) {
> -                       dprintk(1, "qbuf: buffer initialization failed\n");
> +                       dprintk(1, "%s: buffer initialization failed\n",
> +                               __func__);
>                         fail_vb_qop(vb, buf_init);
>                         goto err;
>                 }
> @@ -1334,7 +1338,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>
>         ret = call_vb_qop(vb, buf_prepare, vb);
>         if (ret) {
> -               dprintk(1, "qbuf: buffer preparation failed\n");
> +               dprintk(1, "%s: buffer preparation failed\n", __func__);
>                 fail_vb_qop(vb, buf_prepare);
>                 call_vb_qop(vb, buf_cleanup, vb);
>                 goto err;
> @@ -1388,8 +1392,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                 struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
>
>                 if (IS_ERR_OR_NULL(dbuf)) {
> -                       dprintk(1, "qbuf: invalid dmabuf fd for plane %d\n",
> -                               plane);
> +                       dprintk(1, "%s: invalid dmabuf fd for plane %d\n",
> +                               __func__, plane);
>                         ret = -EINVAL;
>                         goto err;
>                 }
> @@ -1399,8 +1403,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                         planes[plane].length = dbuf->size;
>
>                 if (planes[plane].length < q->plane_sizes[plane]) {
> -                       dprintk(1, "qbuf: invalid dmabuf length for plane %d\n",
> -                               plane);
> +                       dprintk(1, "%s: invalid dmabuf length for plane %d\n",
> +                               __func__, plane);
>                         ret = -EINVAL;
>                         goto err;
>                 }
> @@ -1412,7 +1416,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                         continue;
>                 }
>
> -               dprintk(1, "qbuf: buffer for plane %d changed\n", plane);
> +               dprintk(1, "%s: buffer for plane %d changed\n",
> +                       __func__, plane);
>
>                 if (!reacquired) {
>                         reacquired = true;
> @@ -1427,7 +1432,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                 mem_priv = call_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
>                         dbuf, planes[plane].length, write);
>                 if (IS_ERR(mem_priv)) {
> -                       dprintk(1, "qbuf: failed to attach dmabuf\n");
> +                       dprintk(1, "%s: failed to attach dmabuf\n", __func__);
>                         fail_memop(vb, attach_dmabuf);
>                         ret = PTR_ERR(mem_priv);
>                         dma_buf_put(dbuf);
> @@ -1445,8 +1450,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>         for (plane = 0; plane < vb->num_planes; ++plane) {
>                 ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
>                 if (ret) {
> -                       dprintk(1, "qbuf: failed to map dmabuf for plane %d\n",
> -                               plane);
> +                       dprintk(1, "%s: failed to map dmabuf for plane %d\n",
> +                               __func__, plane);
>                         fail_memop(vb, map_dmabuf);
>                         goto err;
>                 }
> @@ -1467,7 +1472,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                  */
>                 ret = call_vb_qop(vb, buf_init, vb);
>                 if (ret) {
> -                       dprintk(1, "qbuf: buffer initialization failed\n");
> +                       dprintk(1, "%s: buffer initialization failed\n",
> +                               __func__);
>                         fail_vb_qop(vb, buf_init);
>                         goto err;
>                 }
> @@ -1475,7 +1481,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>
>         ret = call_vb_qop(vb, buf_prepare, vb);
>         if (ret) {
> -               dprintk(1, "qbuf: buffer preparation failed\n");
> +               dprintk(1, "%s: buffer preparation failed\n", __func__);
>                 fail_vb_qop(vb, buf_prepare);
>                 call_vb_qop(vb, buf_cleanup, vb);
>                 goto err;
> @@ -1671,7 +1677,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
>                 return 0;
>
>         fail_qop(q, start_streaming);
> -       dprintk(1, "qbuf: driver refused to start streaming\n");
> +       dprintk(1, "%s: driver refused to start streaming\n", __func__);
>         if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
>                 unsigned i;
>
> @@ -1709,7 +1715,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>         case VB2_BUF_STATE_PREPARED:
>                 break;
>         case VB2_BUF_STATE_PREPARING:
> -               dprintk(1, "qbuf: buffer still being prepared\n");
> +               dprintk(1, "%s: buffer still being prepared\n", __func__);
>                 return -EINVAL;
>         default:
>                 dprintk(1, "%s(): invalid buffer state %d\n", __func__,
> @@ -1945,7 +1951,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
>         int ret;
>
>         if (b->type != q->type) {
> -               dprintk(1, "dqbuf: invalid buffer type\n");
> +               dprintk(1, "%s: invalid buffer type\n", __func__);
>                 return -EINVAL;
>         }
>         ret = __vb2_get_done_vb(q, &vb, b, nonblocking);
> @@ -1954,13 +1960,13 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
>
>         switch (vb->state) {
>         case VB2_BUF_STATE_DONE:
> -               dprintk(3, "dqbuf: Returning done buffer\n");
> +               dprintk(3, "%s: Returning done buffer\n", __func__);
>                 break;
>         case VB2_BUF_STATE_ERROR:
> -               dprintk(3, "dqbuf: Returning done buffer with errors\n");
> +               dprintk(3, "%s: Returning done buffer with errors\n", __func__);
>                 break;
>         default:
> -               dprintk(1, "dqbuf: Invalid buffer state\n");
> +               dprintk(1, "%s: Invalid buffer state\n", __func__);
>                 return -EINVAL;
>         }
>
> @@ -2004,7 +2010,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
>  int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
>  {
>         if (q->fileio) {
> -               dprintk(1, "dqbuf: file io in progress\n");
> +               dprintk(1, "%s: file io in progress\n", __func__);
>                 return -EBUSY;
>         }
>         return vb2_internal_dqbuf(q, b, nonblocking);
> @@ -2076,7 +2082,7 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>         int ret;
>
>         if (type != q->type) {
> -               dprintk(1, "streamon: invalid stream type\n");
> +               dprintk(1, "%s: invalid stream type\n", __func__);
>                 return -EINVAL;
>         }
>
> @@ -2086,17 +2092,17 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>         }
>
>         if (!q->num_buffers) {
> -               dprintk(1, "streamon: no buffers have been allocated\n");
> +               dprintk(1, "%s: no buffers have been allocated\n", __func__);
>                 return -EINVAL;
>         }
>
>         if (!q->num_buffers) {
> -               dprintk(1, "streamon: no buffers have been allocated\n");
> +               dprintk(1, "%s: no buffers have been allocated\n", __func__);
>                 return -EINVAL;
>         }
>         if (q->num_buffers < q->min_buffers_needed) {
> -               dprintk(1, "streamon: need at least %u allocated buffers\n",
> -                               q->min_buffers_needed);
> +               dprintk(1, "%s: need at least %u allocated buffers\n",
> +                               __func__, q->min_buffers_needed);
>                 return -EINVAL;
>         }
>
> @@ -2134,7 +2140,7 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>  int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>  {
>         if (q->fileio) {
> -               dprintk(1, "streamon: file io in progress\n");
> +               dprintk(1, "%s: file io in progress\n", __func__);
>                 return -EBUSY;
>         }
>         return vb2_internal_streamon(q, type);
> @@ -2144,7 +2150,7 @@ EXPORT_SYMBOL_GPL(vb2_streamon);
>  static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
>  {
>         if (type != q->type) {
> -               dprintk(1, "streamoff: invalid stream type\n");
> +               dprintk(1, "%s: invalid stream type\n", __func__);
>                 return -EINVAL;
>         }
>
> @@ -2181,7 +2187,7 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
>  int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
>  {
>         if (q->fileio) {
> -               dprintk(1, "streamoff: file io in progress\n");
> +               dprintk(1, "%s: file io in progress\n", __func__);
>                 return -EBUSY;
>         }
>         return vb2_internal_streamoff(q, type);
> @@ -2249,7 +2255,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
>         }
>
>         if (eb->type != q->type) {
> -               dprintk(1, "qbuf: invalid buffer type\n");
> +               dprintk(1, "%s: invalid buffer type\n", __func__);
>                 return -EINVAL;
>         }
>
> @@ -2863,7 +2869,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>                 fileio->b.index = index;
>                 fileio->b.bytesused = buf->pos;
>                 ret = vb2_internal_qbuf(q, &fileio->b);
> -               dprintk(5, "file io: vb2_dbuf result: %d\n", ret);
> +               dprintk(5, "file io: vb2_internal_qbuf result: %d\n", ret);
>                 if (ret)
>                         return ret;
>
> --
> 1.9.0
>



-- 
Best regards,
Pawel Osciak
