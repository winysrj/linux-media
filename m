Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40327 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2BCPne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 10:43:34 -0500
Received: by vcge1 with SMTP id e1so2661841vcg.19
        for <linux-media@vger.kernel.org>; Fri, 03 Feb 2012 07:43:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327326675-8431-4-git-send-email-t.stanislaws@samsung.com>
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <1327326675-8431-4-git-send-email-t.stanislaws@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 3 Feb 2012 07:42:53 -0800
Message-ID: <CAMm-=zDjPSG58tWXNRejmzZmrYXdmS9vtia7g5UP_9Qb3Xk6qQ@mail.gmail.com>
Subject: Re: [PATCH 03/10] media: vb2: add prepare/finish callbacks to allocators
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Mon, Jan 23, 2012 at 05:51, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/videobuf2-core.c |   11 +++++++++++
>  include/media/videobuf2-core.h       |    2 ++
>  2 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 4c3a82e..cb85874 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -836,6 +836,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  {
>        struct vb2_queue *q = vb->vb2_queue;
>        unsigned long flags;
> +       int plane;
>
>        if (vb->state != VB2_BUF_STATE_ACTIVE)
>                return;
> @@ -846,6 +847,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>        dprintk(4, "Done processing on buffer %d, state: %d\n",
>                        vb->v4l2_buf.index, vb->state);
>
> +       /* sync buffers */
> +       for (plane = 0; plane < vb->num_planes; ++plane)
> +               call_memop(q, finish, vb->planes[plane].mem_priv);
> +
>        /* Add the buffer to the done buffers list */
>        spin_lock_irqsave(&q->done_lock, flags);
>        vb->state = state;
> @@ -1136,9 +1141,15 @@ err:
>  static void __enqueue_in_driver(struct vb2_buffer *vb)
>  {
>        struct vb2_queue *q = vb->vb2_queue;
> +       int plane;
>
>        vb->state = VB2_BUF_STATE_ACTIVE;
>        atomic_inc(&q->queued_count);
> +
> +       /* sync buffers */
> +       for (plane = 0; plane < vb->num_planes; ++plane)
> +               call_memop(q, prepare, vb->planes[plane].mem_priv);
> +
>        q->ops->buf_queue(vb);
>  }
>
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 35607f7..d8b8171 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -76,6 +76,8 @@ struct vb2_fileio_data;
>  */
>  struct vb2_mem_ops {
>        void            *(*alloc)(void *alloc_ctx, unsigned long size);
> +       void            (*prepare)(void *buf_priv);
> +       void            (*finish)(void *buf_priv);
>        void            (*put)(void *buf_priv);
>
>        void            *(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
> --
> 1.7.5.4
>

Those callbacks need to be documented in struct vb2_mem_ops
documentation in code. Apart from that the patch looks good.

-- 
Best regards,
Pawel Osciak
