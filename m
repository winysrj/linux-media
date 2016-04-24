Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36561 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbcDXU6J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 16:58:09 -0400
Received: by mail-wm0-f48.google.com with SMTP id v188so76853816wme.1
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 13:58:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461409429-24995-8-git-send-email-hverkuil@xs4all.nl>
References: <1461409429-24995-1-git-send-email-hverkuil@xs4all.nl> <1461409429-24995-8-git-send-email-hverkuil@xs4all.nl>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Sun, 24 Apr 2016 21:57:38 +0100
Message-ID: <CA+V-a8ufBet0bDq_Cu_LQ3bjcjr9r9Njmnc7wsrY+NvTSiA1xA@mail.gmail.com>
Subject: Re: [PATCHv4 07/13] media/platform: convert drivers to use the new
 vb2_queue dev field
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sat, Apr 23, 2016 at 12:03 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Stop using alloc_ctx and just fill in the device pointer.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/am437x/am437x-vpfe.c    | 10 +---------
>  drivers/media/platform/am437x/am437x-vpfe.h    |  2 --
>  drivers/media/platform/davinci/vpbe_display.c  | 12 +-----------
>  drivers/media/platform/davinci/vpif_capture.c  | 11 +----------
>  drivers/media/platform/davinci/vpif_capture.h  |  2 --
>  drivers/media/platform/davinci/vpif_display.c  | 11 +----------
>  drivers/media/platform/davinci/vpif_display.h  |  2 --
>  include/media/davinci/vpbe_display.h           |  2 --
>  11 files changed, 8 insertions(+), 76 deletions(-)
>

For all the above

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> index e749eb7..d22b09d 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -1915,7 +1915,6 @@ static int vpfe_queue_setup(struct vb2_queue *vq,
>
>         if (vq->num_buffers + *nbuffers < 3)
>                 *nbuffers = 3 - vq->num_buffers;
> -       alloc_ctxs[0] = vpfe->alloc_ctx;
>
>         if (*nplanes) {
>                 if (sizes[0] < size)
> @@ -2364,13 +2363,6 @@ static int vpfe_probe_complete(struct vpfe_device *vpfe)
>                 goto probe_out;
>
>         /* Initialize videobuf2 queue as per the buffer type */
> -       vpfe->alloc_ctx = vb2_dma_contig_init_ctx(vpfe->pdev);
> -       if (IS_ERR(vpfe->alloc_ctx)) {
> -               vpfe_err(vpfe, "Failed to get the context\n");
> -               err = PTR_ERR(vpfe->alloc_ctx);
> -               goto probe_out;
> -       }
> -
>         q = &vpfe->buffer_queue;
>         q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>         q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
> @@ -2381,11 +2373,11 @@ static int vpfe_probe_complete(struct vpfe_device *vpfe)
>         q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>         q->lock = &vpfe->lock;
>         q->min_buffers_needed = 1;
> +       q->dev = vpfe->pdev;
>
>         err = vb2_queue_init(q);
>         if (err) {
>                 vpfe_err(vpfe, "vb2_queue_init() failed\n");
> -               vb2_dma_contig_cleanup_ctx(vpfe->alloc_ctx);
>                 goto probe_out;
>         }
>
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.h b/drivers/media/platform/am437x/am437x-vpfe.h
> index 777bf97..17d7aa4 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.h
> +++ b/drivers/media/platform/am437x/am437x-vpfe.h
> @@ -264,8 +264,6 @@ struct vpfe_device {
>         struct v4l2_rect crop;
>         /* Buffer queue used in video-buf */
>         struct vb2_queue buffer_queue;
> -       /* Allocator-specific contexts for each plane */
> -       struct vb2_alloc_ctx *alloc_ctx;
>         /* Queue of filled frames */
>         struct list_head dma_queue;
>         /* IRQ lock for DMA queue */
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index d0092da..1e244287 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -91,8 +91,6 @@ struct bcap_device {
>         struct bcap_buffer *cur_frm;
>         /* buffer queue used in videobuf2 */
>         struct vb2_queue buffer_queue;
> -       /* allocator-specific contexts for each plane */
> -       struct vb2_alloc_ctx *alloc_ctx;
>         /* queue of filled frames */
>         struct list_head dma_queue;
>         /* used in videobuf2 callback */
> @@ -209,7 +207,6 @@ static int bcap_queue_setup(struct vb2_queue *vq,
>
>         if (vq->num_buffers + *nbuffers < 2)
>                 *nbuffers = 2;
> -       alloc_ctxs[0] = bcap_dev->alloc_ctx;
>
>         if (*nplanes)
>                 return sizes[0] < bcap_dev->fmt.sizeimage ? -EINVAL : 0;
> @@ -820,12 +817,6 @@ static int bcap_probe(struct platform_device *pdev)
>         }
>         bcap_dev->ppi->priv = bcap_dev;
>
> -       bcap_dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> -       if (IS_ERR(bcap_dev->alloc_ctx)) {
> -               ret = PTR_ERR(bcap_dev->alloc_ctx);
> -               goto err_free_ppi;
> -       }
> -
>         vfd = &bcap_dev->video_dev;
>         /* initialize field of video device */
>         vfd->release            = video_device_release_empty;
> @@ -839,7 +830,7 @@ static int bcap_probe(struct platform_device *pdev)
>         if (ret) {
>                 v4l2_err(pdev->dev.driver,
>                                 "Unable to register v4l2 device\n");
> -               goto err_cleanup_ctx;
> +               goto err_free_ppi;
>         }
>         v4l2_info(&bcap_dev->v4l2_dev, "v4l2 device registered\n");
>
> @@ -863,6 +854,7 @@ static int bcap_probe(struct platform_device *pdev)
>         q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>         q->lock = &bcap_dev->mutex;
>         q->min_buffers_needed = 1;
> +       q->dev = &pdev->dev;
>
>         ret = vb2_queue_init(q);
>         if (ret)
> @@ -967,8 +959,6 @@ err_free_handler:
>         v4l2_ctrl_handler_free(&bcap_dev->ctrl_handler);
>  err_unreg_v4l2:
>         v4l2_device_unregister(&bcap_dev->v4l2_dev);
> -err_cleanup_ctx:
> -       vb2_dma_contig_cleanup_ctx(bcap_dev->alloc_ctx);
>  err_free_ppi:
>         ppi_delete_instance(bcap_dev->ppi);
>  err_free_dev:
> @@ -986,7 +976,6 @@ static int bcap_remove(struct platform_device *pdev)
>         video_unregister_device(&bcap_dev->video_dev);
>         v4l2_ctrl_handler_free(&bcap_dev->ctrl_handler);
>         v4l2_device_unregister(v4l2_dev);
> -       vb2_dma_contig_cleanup_ctx(bcap_dev->alloc_ctx);
>         ppi_delete_instance(bcap_dev->ppi);
>         kfree(bcap_dev);
>         return 0;
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 133ab9f..3d57c35 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1151,9 +1151,6 @@ static int coda_queue_setup(struct vb2_queue *vq,
>         *nplanes = 1;
>         sizes[0] = size;
>
> -       /* Set to vb2-dma-contig allocator context, ignored by vb2-vmalloc */
> -       alloc_ctxs[0] = ctx->dev->alloc_ctx;
> -
>         v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>                  "get %d buffer(s) of size %d each.\n", *nbuffers, size);
>
> @@ -1599,6 +1596,7 @@ static int coda_queue_init(struct coda_ctx *ctx, struct vb2_queue *vq)
>          * that videobuf2 will keep the value of bytesused intact.
>          */
>         vq->allow_zero_bytesused = 1;
> +       vq->dev = &ctx->dev->plat_dev->dev;
>
>         return vb2_queue_init(vq);
>  }
> @@ -2040,16 +2038,10 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
>         if (ret < 0)
>                 goto put_pm;
>
> -       dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> -       if (IS_ERR(dev->alloc_ctx)) {
> -               v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
> -               goto put_pm;
> -       }
> -
>         dev->m2m_dev = v4l2_m2m_init(&coda_m2m_ops);
>         if (IS_ERR(dev->m2m_dev)) {
>                 v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
> -               goto rel_ctx;
> +               goto put_pm;
>         }
>
>         for (i = 0; i < dev->devtype->num_vdevs; i++) {
> @@ -2072,8 +2064,6 @@ rel_vfd:
>         while (--i >= 0)
>                 video_unregister_device(&dev->vfd[i]);
>         v4l2_m2m_release(dev->m2m_dev);
> -rel_ctx:
> -       vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>  put_pm:
>         pm_runtime_put_sync(&pdev->dev);
>  }
> @@ -2324,8 +2314,6 @@ static int coda_remove(struct platform_device *pdev)
>         if (dev->m2m_dev)
>                 v4l2_m2m_release(dev->m2m_dev);
>         pm_runtime_disable(&pdev->dev);
> -       if (dev->alloc_ctx)
> -               vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>         v4l2_device_unregister(&dev->v4l2_dev);
>         destroy_workqueue(dev->workqueue);
>         if (dev->iram.vaddr)
> diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
> index 8f2c71e..53f9666 100644
> --- a/drivers/media/platform/coda/coda.h
> +++ b/drivers/media/platform/coda/coda.h
> @@ -92,7 +92,6 @@ struct coda_dev {
>         struct mutex            coda_mutex;
>         struct workqueue_struct *workqueue;
>         struct v4l2_m2m_dev     *m2m_dev;
> -       struct vb2_alloc_ctx    *alloc_ctx;
>         struct list_head        instances;
>         unsigned long           instance_mask;
>         struct dentry           *debugfs_root;
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 0abcdfe..2a4c291 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -242,7 +242,6 @@ vpbe_buffer_queue_setup(struct vb2_queue *vq,
>         /* Store number of buffers allocated in numbuffer member */
>         if (vq->num_buffers + *nbuffers < VPBE_DEFAULT_NUM_BUFS)
>                 *nbuffers = VPBE_DEFAULT_NUM_BUFS - vq->num_buffers;
> -       alloc_ctxs[0] = layer->alloc_ctx;
>
>         if (*nplanes)
>                 return sizes[0] < layer->pix_fmt.sizeimage ? -EINVAL : 0;
> @@ -1451,20 +1450,13 @@ static int vpbe_display_probe(struct platform_device *pdev)
>                 q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>                 q->min_buffers_needed = 1;
>                 q->lock = &disp_dev->dev[i]->opslock;
> +               q->dev = disp_dev->vpbe_dev->pdev;
>                 err = vb2_queue_init(q);
>                 if (err) {
>                         v4l2_err(v4l2_dev, "vb2_queue_init() failed\n");
>                         goto probe_out;
>                 }
>
> -               disp_dev->dev[i]->alloc_ctx =
> -                       vb2_dma_contig_init_ctx(disp_dev->vpbe_dev->pdev);
> -               if (IS_ERR(disp_dev->dev[i]->alloc_ctx)) {
> -                       v4l2_err(v4l2_dev, "Failed to get the context\n");
> -                       err = PTR_ERR(disp_dev->dev[i]->alloc_ctx);
> -                       goto probe_out;
> -               }
> -
>                 INIT_LIST_HEAD(&disp_dev->dev[i]->dma_queue);
>
>                 if (register_device(disp_dev->dev[i], disp_dev, pdev)) {
> @@ -1482,7 +1474,6 @@ probe_out:
>         for (k = 0; k < VPBE_DISPLAY_MAX_DEVICES; k++) {
>                 /* Unregister video device */
>                 if (disp_dev->dev[k] != NULL) {
> -                       vb2_dma_contig_cleanup_ctx(disp_dev->dev[k]->alloc_ctx);
>                         video_unregister_device(&disp_dev->dev[k]->video_dev);
>                         kfree(disp_dev->dev[k]);
>                 }
> @@ -1510,7 +1501,6 @@ static int vpbe_display_remove(struct platform_device *pdev)
>         for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
>                 /* Get the pointer to the layer object */
>                 vpbe_display_layer = disp_dev->dev[i];
> -               vb2_dma_contig_cleanup_ctx(vpbe_display_layer->alloc_ctx);
>                 /* Unregister video device */
>                 video_unregister_device(&vpbe_display_layer->video_dev);
>
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 08f7028..d5afab0 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -133,7 +133,6 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
>
>         *nplanes = 1;
>         sizes[0] = size;
> -       alloc_ctxs[0] = common->alloc_ctx;
>
>         /* Calculate the offset for Y and C data in the buffer */
>         vpif_calculate_offsets(ch);
> @@ -1371,6 +1370,7 @@ static int vpif_probe_complete(void)
>                 q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>                 q->min_buffers_needed = 1;
>                 q->lock = &common->lock;
> +               q->dev = vpif_dev;
>
>                 err = vb2_queue_init(q);
>                 if (err) {
> @@ -1378,13 +1378,6 @@ static int vpif_probe_complete(void)
>                         goto probe_out;
>                 }
>
> -               common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
> -               if (IS_ERR(common->alloc_ctx)) {
> -                       vpif_err("Failed to get the context\n");
> -                       err = PTR_ERR(common->alloc_ctx);
> -                       goto probe_out;
> -               }
> -
>                 INIT_LIST_HEAD(&common->dma_queue);
>
>                 /* Initialize the video_device structure */
> @@ -1412,7 +1405,6 @@ probe_out:
>                 /* Get the pointer to the channel object */
>                 ch = vpif_obj.dev[k];
>                 common = &ch->common[k];
> -               vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>                 /* Unregister video device */
>                 video_unregister_device(&ch->video_dev);
>         }
> @@ -1546,7 +1538,6 @@ static int vpif_remove(struct platform_device *device)
>                 /* Get the pointer to the channel object */
>                 ch = vpif_obj.dev[i];
>                 common = &ch->common[VPIF_VIDEO_INDEX];
> -               vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>                 /* Unregister video device */
>                 video_unregister_device(&ch->video_dev);
>                 kfree(vpif_obj.dev[i]);
> diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
> index 4a76009..9e35b67 100644
> --- a/drivers/media/platform/davinci/vpif_capture.h
> +++ b/drivers/media/platform/davinci/vpif_capture.h
> @@ -65,8 +65,6 @@ struct common_obj {
>         struct v4l2_format fmt;
>         /* Buffer queue used in video-buf */
>         struct vb2_queue buffer_queue;
> -       /* allocator-specific contexts for each plane */
> -       struct vb2_alloc_ctx *alloc_ctx;
>         /* Queue of filled frames */
>         struct list_head dma_queue;
>         /* Used in video-buf */
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index f40755c..5d77884 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -126,7 +126,6 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
>
>         *nplanes = 1;
>         sizes[0] = size;
> -       alloc_ctxs[0] = common->alloc_ctx;
>
>         /* Calculate the offset for Y and C data  in the buffer */
>         vpif_calculate_offsets(ch);
> @@ -1191,19 +1190,13 @@ static int vpif_probe_complete(void)
>                 q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>                 q->min_buffers_needed = 1;
>                 q->lock = &common->lock;
> +               q->dev = vpif_dev;
>                 err = vb2_queue_init(q);
>                 if (err) {
>                         vpif_err("vpif_display: vb2_queue_init() failed\n");
>                         goto probe_out;
>                 }
>
> -               common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
> -               if (IS_ERR(common->alloc_ctx)) {
> -                       vpif_err("Failed to get the context\n");
> -                       err = PTR_ERR(common->alloc_ctx);
> -                       goto probe_out;
> -               }
> -
>                 INIT_LIST_HEAD(&common->dma_queue);
>
>                 /* register video device */
> @@ -1233,7 +1226,6 @@ probe_out:
>         for (k = 0; k < j; k++) {
>                 ch = vpif_obj.dev[k];
>                 common = &ch->common[k];
> -               vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>                 video_unregister_device(&ch->video_dev);
>         }
>         return err;
> @@ -1355,7 +1347,6 @@ static int vpif_remove(struct platform_device *device)
>                 /* Get the pointer to the channel object */
>                 ch = vpif_obj.dev[i];
>                 common = &ch->common[VPIF_VIDEO_INDEX];
> -               vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>                 /* Unregister video device */
>                 video_unregister_device(&ch->video_dev);
>                 kfree(vpif_obj.dev[i]);
> diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
> index e7a1723..af2765f 100644
> --- a/drivers/media/platform/davinci/vpif_display.h
> +++ b/drivers/media/platform/davinci/vpif_display.h
> @@ -74,8 +74,6 @@ struct common_obj {
>         struct v4l2_format fmt;                 /* Used to store the format */
>         struct vb2_queue buffer_queue;          /* Buffer queue used in
>                                                  * video-buf */
> -       /* allocator-specific contexts for each plane */
> -       struct vb2_alloc_ctx *alloc_ctx;
>
>         struct list_head dma_queue;             /* Queue of filled frames */
>         spinlock_t irqlock;                     /* Used in video-buf */
> diff --git a/include/media/davinci/vpbe_display.h b/include/media/davinci/vpbe_display.h
> index e14a937..12783fd 100644
> --- a/include/media/davinci/vpbe_display.h
> +++ b/include/media/davinci/vpbe_display.h
> @@ -81,8 +81,6 @@ struct vpbe_layer {
>          * Buffer queue used in video-buf
>          */
>         struct vb2_queue buffer_queue;
> -       /* allocator-specific contexts for each plane */
> -       struct vb2_alloc_ctx *alloc_ctx;
>         /* Queue of filled frames */
>         struct list_head dma_queue;
>         /* Used in video-buf */
> --
> 2.8.0.rc3
>
