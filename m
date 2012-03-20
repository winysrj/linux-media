Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:43677 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760466Ab2CTPLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 11:11:22 -0400
Received: by mail-gy0-f181.google.com with SMTP id z13so160679ghb.12
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 08:11:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331033890-10350-2-git-send-email-t.stanislaws@samsung.com>
References: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com> <1331033890-10350-2-git-send-email-t.stanislaws@samsung.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Tue, 20 Mar 2012 20:34:33 +0530
Message-ID: <CAB2ybb9_469n5SqvwhbdZ+7SJUjO1o9wGtoczxzoNVsm35boDQ@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 1/9] v4l: vb2: fixes for DMABUF support
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, daeinki@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 6, 2012 at 5:08 PM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
> This patch contains fixes to DMABUF support in vb2-core.
> - fixes number of arguments of call_memop macro
> - fixes setup of plane length
> - fixes handling of error pointers
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Sumit Semwal <sumit.semwal@linaro.org>
> ---
>  drivers/media/video/videobuf2-core.c |   24 +++++++++++-------------
>  include/media/videobuf2-core.h       |    6 +++---
>  2 files changed, 14 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 951cb56..e7df560 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -118,7 +118,7 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
>                void *mem_priv = vb->planes[plane].mem_priv;
>
>                if (mem_priv) {
> -                       call_memop(q, plane, detach_dmabuf, mem_priv);
> +                       call_memop(q, detach_dmabuf, mem_priv);
>                        dma_buf_put(vb->planes[plane].dbuf);
>                        vb->planes[plane].dbuf = NULL;
>                        vb->planes[plane].mem_priv = NULL;
> @@ -905,6 +905,8 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
>                }
>                if (b->memory == V4L2_MEMORY_DMABUF) {
>                        for (plane = 0; plane < vb->num_planes; ++plane) {
> +                               v4l2_planes[plane].bytesused =
> +                                       b->m.planes[plane].bytesused;
>                                v4l2_planes[plane].m.fd = b->m.planes[plane].m.fd;
>                        }
>                }
> @@ -1052,17 +1054,13 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                if (IS_ERR_OR_NULL(dbuf)) {
>                        dprintk(1, "qbuf: invalid dmabuf fd for "
>                                "plane %d\n", plane);
> -                       ret = PTR_ERR(dbuf);
> +                       ret = -EINVAL;
>                        goto err;
>                }
>
> -               /* this doesn't get filled in until __fill_vb2_buffer(),
> -                * since it isn't known until after dma_buf_get()..
> -                */
> -               planes[plane].length = dbuf->size;
> -
>                /* Skip the plane if already verified */
>                if (dbuf == vb->planes[plane].dbuf) {
> +                       planes[plane].length = dbuf->size;
>                        dma_buf_put(dbuf);
>                        continue;
>                }
> @@ -1072,7 +1070,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>
>                /* Release previously acquired memory if present */
>                if (vb->planes[plane].mem_priv) {
> -                       call_memop(q, plane, detach_dmabuf,
> +                       call_memop(q, detach_dmabuf,
>                                vb->planes[plane].mem_priv);
>                        dma_buf_put(vb->planes[plane].dbuf);
>                }
> @@ -1080,8 +1078,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                vb->planes[plane].mem_priv = NULL;
>
>                /* Acquire each plane's memory */
> -               mem_priv = q->mem_ops->attach_dmabuf(
> -                               q->alloc_ctx[plane], dbuf);
> +               mem_priv = call_memop(q, attach_dmabuf, q->alloc_ctx[plane],
> +                       dbuf, q->plane_sizes[plane], write);
>                if (IS_ERR(mem_priv)) {
>                        dprintk(1, "qbuf: failed acquiring dmabuf "
>                                "memory for plane %d\n", plane);
> @@ -1089,6 +1087,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                        goto err;
>                }
>
> +               planes[plane].length = dbuf->size;
>                vb->planes[plane].dbuf = dbuf;
>                vb->planes[plane].mem_priv = mem_priv;
>        }
> @@ -1098,8 +1097,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>         * the buffer(s)..
>         */
>        for (plane = 0; plane < vb->num_planes; ++plane) {
> -               ret = q->mem_ops->map_dmabuf(
> -                               vb->planes[plane].mem_priv, write);
> +               ret = call_memop(q, map_dmabuf, vb->planes[plane].mem_priv);
>                if (ret) {
>                        dprintk(1, "qbuf: failed mapping dmabuf "
>                                "memory for plane %d\n", plane);
> @@ -1527,7 +1525,7 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
>         */
>        if (q->memory == V4L2_MEMORY_DMABUF)
>                for (plane = 0; plane < vb->num_planes; ++plane)
> -                       call_memop(q, plane, unmap_dmabuf,
> +                       call_memop(q, unmap_dmabuf,
>                                vb->planes[plane].mem_priv);
>
>        switch (vb->state) {
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index d8b8171..412c6a4 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -88,10 +88,10 @@ struct vb2_mem_ops {
>         * in the vb2 core, and vb2_mem_ops really just need to get/put the
>         * sglist (and make sure that the sglist fits it's needs..)
>         */
> -       void            *(*attach_dmabuf)(void *alloc_ctx,
> -                                         struct dma_buf *dbuf);
> +       void            *(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
> +                               unsigned long size, int write);
>        void            (*detach_dmabuf)(void *buf_priv);
> -       int             (*map_dmabuf)(void *buf_priv, int write);
> +       int             (*map_dmabuf)(void *buf_priv);
>        void            (*unmap_dmabuf)(void *buf_priv);
>
>        void            *(*vaddr)(void *buf_priv);
> --
> 1.7.5.4
>
