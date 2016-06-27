Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:56493 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751869AbcF0OuW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 10:50:22 -0400
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 27 Jun 2016 16:50:05 +0200
Subject: Re: [PATCHv5 08/13] media/platform: convert drivers to use the new
 vb2_queue dev field
Message-ID: <57713D1D.8080301@st.com>
References: <1467034324-37626-1-git-send-email-hverkuil@xs4all.nl>
 <1467034324-37626-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467034324-37626-9-git-send-email-hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/27/2016 03:31 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Stop using alloc_ctx and just fill in the device pointer.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Fabien Dessenne <fabien.dessenne@st.com>
> Acked-by: Benoit Parrot <bparrot@ti.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 18 ++++--------------
>   drivers/media/platform/sti/bdisp/bdisp.h      |  2 --
>   drivers/media/platform/ti-vpe/cal.c           | 15 +--------------
>   drivers/media/platform/ti-vpe/vpe.c           | 20 ++++----------------
>   drivers/media/platform/vsp1/vsp1_video.c      | 14 ++------------
>   drivers/media/platform/vsp1/vsp1_video.h      |  1 -
>   drivers/media/platform/xilinx/xilinx-dma.c    | 11 +----------
>   drivers/media/platform/xilinx/xilinx-dma.h    |  2 --
>   8 files changed, 12 insertions(+), 71 deletions(-)

Acked-by: Fabien Dessenne<fabien.dessenne@st.com>

>
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> index d12a419..b3e8b5a 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> +++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> @@ -439,7 +439,7 @@ static void bdisp_ctrls_delete(struct bdisp_ctx *ctx)
>
>   static int bdisp_queue_setup(struct vb2_queue *vq,
>                               unsigned int *nb_buf, unsigned int *nb_planes,
> -                            unsigned int sizes[], void *allocators[])
> +                            unsigned int sizes[], void *alloc_ctxs[])
>   {
>          struct bdisp_ctx *ctx = vb2_get_drv_priv(vq);
>          struct bdisp_frame *frame = ctx_get_frame(ctx, vq->type);
> @@ -453,7 +453,6 @@ static int bdisp_queue_setup(struct vb2_queue *vq,
>                  dev_err(ctx->bdisp_dev->dev, "Invalid format\n");
>                  return -EINVAL;
>          }
> -       allocators[0] = ctx->bdisp_dev->alloc_ctx;
>
>          if (*nb_planes)
>                  return sizes[0] < frame->sizeimage ? -EINVAL : 0;
> @@ -553,6 +552,7 @@ static int queue_init(void *priv,
>          src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>          src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>          src_vq->lock = &ctx->bdisp_dev->lock;
> +       src_vq->dev = ctx->bdisp_dev->v4l2_dev.dev;
>
>          ret = vb2_queue_init(src_vq);
>          if (ret)
> @@ -567,6 +567,7 @@ static int queue_init(void *priv,
>          dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>          dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>          dst_vq->lock = &ctx->bdisp_dev->lock;
> +       dst_vq->dev = ctx->bdisp_dev->v4l2_dev.dev;
>
>          return vb2_queue_init(dst_vq);
>   }
> @@ -1269,8 +1270,6 @@ static int bdisp_remove(struct platform_device *pdev)
>
>          bdisp_hw_free_filters(bdisp->dev);
>
> -       vb2_dma_contig_cleanup_ctx(bdisp->alloc_ctx);
> -
>          pm_runtime_disable(&pdev->dev);
>
>          bdisp_debugfs_remove(bdisp);
> @@ -1371,18 +1370,11 @@ static int bdisp_probe(struct platform_device *pdev)
>                  goto err_dbg;
>          }
>
> -       /* Continuous memory allocator */
> -       bdisp->alloc_ctx = vb2_dma_contig_init_ctx(dev);
> -       if (IS_ERR(bdisp->alloc_ctx)) {
> -               ret = PTR_ERR(bdisp->alloc_ctx);
> -               goto err_pm;
> -       }
> -
>          /* Filters */
>          if (bdisp_hw_alloc_filters(bdisp->dev)) {
>                  dev_err(bdisp->dev, "no memory for filters\n");
>                  ret = -ENOMEM;
> -               goto err_vb2_dma;
> +               goto err_pm;
>          }
>
>          /* Register */
> @@ -1401,8 +1393,6 @@ static int bdisp_probe(struct platform_device *pdev)
>
>   err_filter:
>          bdisp_hw_free_filters(bdisp->dev);
> -err_vb2_dma:
> -       vb2_dma_contig_cleanup_ctx(bdisp->alloc_ctx);
>   err_pm:
>          pm_runtime_put(dev);
>   err_dbg:
> diff --git a/drivers/media/platform/sti/bdisp/bdisp.h b/drivers/media/platform/sti/bdisp/bdisp.h
> index 0cf9857..b3fbf99 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp.h
> +++ b/drivers/media/platform/sti/bdisp/bdisp.h
> @@ -175,7 +175,6 @@ struct bdisp_dbg {
>    * @id:         device index
>    * @m2m:        memory-to-memory V4L2 device information
>    * @state:      flags used to synchronize m2m and capture mode operation
> - * @alloc_ctx:  videobuf2 memory allocator context
>    * @clock:      IP clock
>    * @regs:       registers
>    * @irq_queue:  interrupt handler waitqueue
> @@ -193,7 +192,6 @@ struct bdisp_dev {
>          u16                     id;
>          struct bdisp_m2m_device m2m;
>          unsigned long           state;
> -       struct vb2_alloc_ctx    *alloc_ctx;
>          struct clk              *clock;
>          void __iomem            *regs;
>          wait_queue_head_t       irq_queue;
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index 82001e6..51ebf32 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -287,7 +287,6 @@ struct cal_ctx {
>          /* Several counters */
>          unsigned long           jiffies;
>
> -       struct vb2_alloc_ctx    *alloc_ctx;
>          struct cal_dmaqueue     vidq;
>
>          /* Input Number */
> @@ -1233,7 +1232,6 @@ static int cal_queue_setup(struct vb2_queue *vq,
>
>          if (vq->num_buffers + *nbuffers < 3)
>                  *nbuffers = 3 - vq->num_buffers;
> -       alloc_ctxs[0] = ctx->alloc_ctx;
>
>          if (*nplanes) {
>                  if (sizes[0] < size)
> @@ -1551,6 +1549,7 @@ static int cal_complete_ctx(struct cal_ctx *ctx)
>          q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>          q->lock = &ctx->mutex;
>          q->min_buffers_needed = 3;
> +       q->dev = ctx->v4l2_dev.dev;
>
>          ret = vb2_queue_init(q);
>          if (ret)
> @@ -1578,18 +1577,7 @@ static int cal_complete_ctx(struct cal_ctx *ctx)
>          v4l2_info(&ctx->v4l2_dev, "V4L2 device registered as %s\n",
>                    video_device_node_name(vfd));
>
> -       ctx->alloc_ctx = vb2_dma_contig_init_ctx(vfd->v4l2_dev->dev);
> -       if (IS_ERR(ctx->alloc_ctx)) {
> -               ctx_err(ctx, "Failed to alloc vb2 context\n");
> -               ret = PTR_ERR(ctx->alloc_ctx);
> -               goto vdev_unreg;
> -       }
> -
>          return 0;
> -
> -vdev_unreg:
> -       video_unregister_device(vfd);
> -       return ret;
>   }
>
>   static struct device_node *
> @@ -1914,7 +1902,6 @@ static int cal_remove(struct platform_device *pdev)
>                                  video_device_node_name(&ctx->vdev));
>                          camerarx_phy_disable(ctx);
>                          v4l2_async_notifier_unregister(&ctx->notifier);
> -                       vb2_dma_contig_cleanup_ctx(ctx->alloc_ctx);
>                          v4l2_ctrl_handler_free(&ctx->ctrl_handler);
>                          v4l2_device_unregister(&ctx->v4l2_dev);
>                          video_unregister_device(&ctx->vdev);
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 1fa00c2..3fefd8a 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -362,7 +362,6 @@ struct vpe_dev {
>          void __iomem            *base;
>          struct resource         *res;
>
> -       struct vb2_alloc_ctx    *alloc_ctx;
>          struct vpdma_data       *vpdma;         /* vpdma data handle */
>          struct sc_data          *sc;            /* scaler data handle */
>          struct csc_data         *csc;           /* csc data handle */
> @@ -1807,10 +1806,8 @@ static int vpe_queue_setup(struct vb2_queue *vq,
>
>          *nplanes = q_data->fmt->coplanar ? 2 : 1;
>
> -       for (i = 0; i < *nplanes; i++) {
> +       for (i = 0; i < *nplanes; i++)
>                  sizes[i] = q_data->sizeimage[i];
> -               alloc_ctxs[i] = ctx->dev->alloc_ctx;
> -       }
>
>          vpe_dbg(ctx->dev, "get %d buffer(s) of size %d", *nbuffers,
>                  sizes[VPE_LUMA]);
> @@ -1907,6 +1904,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>          src_vq->mem_ops = &vb2_dma_contig_memops;
>          src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>          src_vq->lock = &dev->dev_mutex;
> +       src_vq->dev = dev->v4l2_dev.dev;
>
>          ret = vb2_queue_init(src_vq);
>          if (ret)
> @@ -1921,6 +1919,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>          dst_vq->mem_ops = &vb2_dma_contig_memops;
>          dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>          dst_vq->lock = &dev->dev_mutex;
> +       dst_vq->dev = dev->v4l2_dev.dev;
>
>          return vb2_queue_init(dst_vq);
>   }
> @@ -2161,7 +2160,6 @@ static void vpe_fw_cb(struct platform_device *pdev)
>                  vpe_runtime_put(pdev);
>                  pm_runtime_disable(&pdev->dev);
>                  v4l2_m2m_release(dev->m2m_dev);
> -               vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>                  v4l2_device_unregister(&dev->v4l2_dev);
>
>                  return;
> @@ -2213,18 +2211,11 @@ static int vpe_probe(struct platform_device *pdev)
>
>          platform_set_drvdata(pdev, dev);
>
> -       dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> -       if (IS_ERR(dev->alloc_ctx)) {
> -               vpe_err(dev, "Failed to alloc vb2 context\n");
> -               ret = PTR_ERR(dev->alloc_ctx);
> -               goto v4l2_dev_unreg;
> -       }
> -
>          dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
>          if (IS_ERR(dev->m2m_dev)) {
>                  vpe_err(dev, "Failed to init mem2mem device\n");
>                  ret = PTR_ERR(dev->m2m_dev);
> -               goto rel_ctx;
> +               goto v4l2_dev_unreg;
>          }
>
>          pm_runtime_enable(&pdev->dev);
> @@ -2269,8 +2260,6 @@ runtime_put:
>   rel_m2m:
>          pm_runtime_disable(&pdev->dev);
>          v4l2_m2m_release(dev->m2m_dev);
> -rel_ctx:
> -       vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>   v4l2_dev_unreg:
>          v4l2_device_unregister(&dev->v4l2_dev);
>
> @@ -2286,7 +2275,6 @@ static int vpe_remove(struct platform_device *pdev)
>          v4l2_m2m_release(dev->m2m_dev);
>          video_unregister_device(&dev->vfd);
>          v4l2_device_unregister(&dev->v4l2_dev);
> -       vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>
>          vpe_set_clock_enable(dev, 0);
>          vpe_runtime_put(pdev);
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index a9aec5c..0e94e3b 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -533,17 +533,14 @@ vsp1_video_queue_setup(struct vb2_queue *vq,
>                  for (i = 0; i < *nplanes; i++) {
>                          if (sizes[i] < format->plane_fmt[i].sizeimage)
>                                  return -EINVAL;
> -                       alloc_ctxs[i] = video->alloc_ctx;
>                  }
>                  return 0;
>          }
>
>          *nplanes = format->num_planes;
>
> -       for (i = 0; i < format->num_planes; ++i) {
> +       for (i = 0; i < format->num_planes; ++i)
>                  sizes[i] = format->plane_fmt[i].sizeimage;
> -               alloc_ctxs[i] = video->alloc_ctx;
> -       }
>
>          return 0;
>   }
> @@ -983,12 +980,6 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
>          video_set_drvdata(&video->video, video);
>
>          /* ... and the buffers queue... */
> -       video->alloc_ctx = vb2_dma_contig_init_ctx(video->vsp1->dev);
> -       if (IS_ERR(video->alloc_ctx)) {
> -               ret = PTR_ERR(video->alloc_ctx);
> -               goto error;
> -       }
> -
>          video->queue.type = video->type;
>          video->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>          video->queue.lock = &video->lock;
> @@ -997,6 +988,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
>          video->queue.ops = &vsp1_video_queue_qops;
>          video->queue.mem_ops = &vb2_dma_contig_memops;
>          video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +       video->queue.dev = video->vsp1->dev;
>          ret = vb2_queue_init(&video->queue);
>          if (ret < 0) {
>                  dev_err(video->vsp1->dev, "failed to initialize vb2 queue\n");
> @@ -1014,7 +1006,6 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
>          return video;
>
>   error:
> -       vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
>          vsp1_video_cleanup(video);
>          return ERR_PTR(ret);
>   }
> @@ -1024,6 +1015,5 @@ void vsp1_video_cleanup(struct vsp1_video *video)
>          if (video_is_registered(&video->video))
>                  video_unregister_device(&video->video);
>
> -       vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
>          media_entity_cleanup(&video->video.entity);
>   }
> diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
> index 867b008..4487dc8 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.h
> +++ b/drivers/media/platform/vsp1/vsp1_video.h
> @@ -46,7 +46,6 @@ struct vsp1_video {
>          unsigned int pipe_index;
>
>          struct vb2_queue queue;
> -       void *alloc_ctx;
>          spinlock_t irqlock;
>          struct list_head irqqueue;
>          unsigned int sequence;
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index 7f6898b..3838e11 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -322,7 +322,6 @@ xvip_dma_queue_setup(struct vb2_queue *vq,
>   {
>          struct xvip_dma *dma = vb2_get_drv_priv(vq);
>
> -       alloc_ctxs[0] = dma->alloc_ctx;
>          /* Make sure the image size is large enough. */
>          if (*nplanes)
>                  return sizes[0] < dma->format.sizeimage ? -EINVAL : 0;
> @@ -706,12 +705,6 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
>          video_set_drvdata(&dma->video, dma);
>
>          /* ... and the buffers queue... */
> -       dma->alloc_ctx = vb2_dma_contig_init_ctx(dma->xdev->dev);
> -       if (IS_ERR(dma->alloc_ctx)) {
> -               ret = PTR_ERR(dma->alloc_ctx);
> -               goto error;
> -       }
> -
>          /* Don't enable VB2_READ and VB2_WRITE, as using the read() and write()
>           * V4L2 APIs would be inefficient. Testing on the command line with a
>           * 'cat /dev/video?' thus won't be possible, but given that the driver
> @@ -728,6 +721,7 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
>          dma->queue.mem_ops = &vb2_dma_contig_memops;
>          dma->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
>                                     | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
> +       dma->queue.dev = dma->xdev->dev;
>          ret = vb2_queue_init(&dma->queue);
>          if (ret < 0) {
>                  dev_err(dma->xdev->dev, "failed to initialize VB2 queue\n");
> @@ -766,9 +760,6 @@ void xvip_dma_cleanup(struct xvip_dma *dma)
>          if (dma->dma)
>                  dma_release_channel(dma->dma);
>
> -       if (!IS_ERR_OR_NULL(dma->alloc_ctx))
> -               vb2_dma_contig_cleanup_ctx(dma->alloc_ctx);
> -
>          media_entity_cleanup(&dma->video.entity);
>
>          mutex_destroy(&dma->lock);
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.h b/drivers/media/platform/xilinx/xilinx-dma.h
> index 7a1621a..e95d136 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.h
> +++ b/drivers/media/platform/xilinx/xilinx-dma.h
> @@ -65,7 +65,6 @@ static inline struct xvip_pipeline *to_xvip_pipeline(struct media_entity *e)
>    * @format: active V4L2 pixel format
>    * @fmtinfo: format information corresponding to the active @format
>    * @queue: vb2 buffers queue
> - * @alloc_ctx: allocation context for the vb2 @queue
>    * @sequence: V4L2 buffers sequence number
>    * @queued_bufs: list of queued buffers
>    * @queued_lock: protects the buf_queued list
> @@ -88,7 +87,6 @@ struct xvip_dma {
>          const struct xvip_video_format *fmtinfo;
>
>          struct vb2_queue queue;
> -       void *alloc_ctx;
>          unsigned int sequence;
>
>          struct list_head queued_bufs;
> --
> 2.8.1
>
