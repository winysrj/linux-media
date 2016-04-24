Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35034 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbcDXU7t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 16:59:49 -0400
Received: by mail-wm0-f45.google.com with SMTP id e201so66850377wme.0
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 13:59:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461314299-36126-6-git-send-email-hverkuil@xs4all.nl>
References: <1461314299-36126-1-git-send-email-hverkuil@xs4all.nl> <1461314299-36126-6-git-send-email-hverkuil@xs4all.nl>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Sun, 24 Apr 2016 21:59:17 +0100
Message-ID: <CA+V-a8u+VzW4nH02DC=cp8Wj=2mH-boF4wTR=fO-VPNnEBvVwA@mail.gmail.com>
Subject: Re: [PATCHv3 05/12] staging/media: convert drivers to use the new
 vb2_queue dev field
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Fri, Apr 22, 2016 at 9:38 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Stop using alloc_ctx and just fill in the device pointer.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 10 +---------
>  drivers/staging/media/davinci_vpfe/vpfe_video.h |  2 --

For the above

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

>  drivers/staging/media/omap4iss/iss_video.c      | 10 +---------
>  drivers/staging/media/omap4iss/iss_video.h      |  1 -
>  4 files changed, 2 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index ea3ddec..77e66e7 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -542,7 +542,6 @@ static int vpfe_release(struct file *file)
>                 video->io_usrs = 0;
>                 /* Free buffers allocated */
>                 vb2_queue_release(&video->buffer_queue);
> -               vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
>         }
>         /* Decrement device users counter */
>         video->usrs--;
> @@ -1115,7 +1114,6 @@ vpfe_buffer_queue_setup(struct vb2_queue *vq,
>
>         *nplanes = 1;
>         sizes[0] = size;
> -       alloc_ctxs[0] = video->alloc_ctx;
>         v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
>                  "nbuffers=%d, size=%lu\n", *nbuffers, size);
>         return 0;
> @@ -1350,12 +1348,6 @@ static int vpfe_reqbufs(struct file *file, void *priv,
>         video->memory = req_buf->memory;
>
>         /* Initialize videobuf2 queue as per the buffer type */
> -       video->alloc_ctx = vb2_dma_contig_init_ctx(vpfe_dev->pdev);
> -       if (IS_ERR(video->alloc_ctx)) {
> -               v4l2_err(&vpfe_dev->v4l2_dev, "Failed to get the context\n");
> -               return PTR_ERR(video->alloc_ctx);
> -       }
> -
>         q = &video->buffer_queue;
>         q->type = req_buf->type;
>         q->io_modes = VB2_MMAP | VB2_USERPTR;
> @@ -1365,11 +1357,11 @@ static int vpfe_reqbufs(struct file *file, void *priv,
>         q->mem_ops = &vb2_dma_contig_memops;
>         q->buf_struct_size = sizeof(struct vpfe_cap_buffer);
>         q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +       q->dev = vpfe_dev->pdev;
>
>         ret = vb2_queue_init(q);
>         if (ret) {
>                 v4l2_err(&vpfe_dev->v4l2_dev, "vb2_queue_init() failed\n");
> -               vb2_dma_contig_cleanup_ctx(vpfe_dev->pdev);
>                 return ret;
>         }
>
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.h b/drivers/staging/media/davinci_vpfe/vpfe_video.h
> index 653334d..aaec440 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.h
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.h
> @@ -123,8 +123,6 @@ struct vpfe_video_device {
>         /* Used to store pixel format */
>         struct v4l2_format                      fmt;
>         struct vb2_queue                        buffer_queue;
> -       /* allocator-specific contexts for each plane */
> -       struct vb2_alloc_ctx *alloc_ctx;
>         /* Queue of filled frames */
>         struct list_head                        dma_queue;
>         spinlock_t                              irqlock;
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> index cf8da23..3c077e3 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -310,8 +310,6 @@ static int iss_video_queue_setup(struct vb2_queue *vq,
>         if (sizes[0] == 0)
>                 return -EINVAL;
>
> -       alloc_ctxs[0] = video->alloc_ctx;
> -
>         *count = min(*count, video->capture_mem / PAGE_ALIGN(sizes[0]));
>
>         return 0;
> @@ -1017,13 +1015,6 @@ static int iss_video_open(struct file *file)
>                 goto done;
>         }
>
> -       video->alloc_ctx = vb2_dma_contig_init_ctx(video->iss->dev);
> -       if (IS_ERR(video->alloc_ctx)) {
> -               ret = PTR_ERR(video->alloc_ctx);
> -               omap4iss_put(video->iss);
> -               goto done;
> -       }
> -
>         q = &handle->queue;
>
>         q->type = video->type;
> @@ -1033,6 +1024,7 @@ static int iss_video_open(struct file *file)
>         q->mem_ops = &vb2_dma_contig_memops;
>         q->buf_struct_size = sizeof(struct iss_buffer);
>         q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +       q->dev = video->iss->dev;
>
>         ret = vb2_queue_init(q);
>         if (ret) {
> diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
> index c8bd295..d7e05d0 100644
> --- a/drivers/staging/media/omap4iss/iss_video.h
> +++ b/drivers/staging/media/omap4iss/iss_video.h
> @@ -170,7 +170,6 @@ struct iss_video {
>         spinlock_t qlock;               /* protects dmaqueue and error */
>         struct list_head dmaqueue;
>         enum iss_video_dmaqueue_flags dmaqueue_flags;
> -       struct vb2_alloc_ctx *alloc_ctx;
>
>         const struct iss_video_operations *ops;
>  };
> --
> 2.8.0.rc3
>
