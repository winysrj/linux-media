Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:40089 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDRGGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Apr 2014 02:06:09 -0400
Received: by mail-ve0-f170.google.com with SMTP id pa12so2160078veb.29
        for <linux-media@vger.kernel.org>; Thu, 17 Apr 2014 23:06:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397726510-12005-2-git-send-email-hverkuil@xs4all.nl>
References: <1397726510-12005-1-git-send-email-hverkuil@xs4all.nl> <1397726510-12005-2-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 18 Apr 2014 11:35:37 +0530
Message-ID: <CA+V-a8sko_j37qcPgEX+cV+Wo57dHqL4=xL6fTvmg7bQ77jsog@mail.gmail.com>
Subject: Re: [PATCHv4 1/3] vb2: stop_streaming should return void
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Thu, Apr 17, 2014 at 2:51 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The vb2 core ignores any return code from the stop_streaming op.
> And there really isn't anything it can do anyway in case of an error.
> So change the return type to void and update any drivers that implement it.
>
> The int return gave drivers the idea that this operation could actually
> fail, but that's really not the case.
>
> The pwc amd sdr-msi3101 drivers both had this construction:
>
>         if (mutex_lock_interruptible(&s->v4l2_lock))
>                 return -ERESTARTSYS;
>
> This has been updated to just call mutex_lock(). The stop_streaming op
> expects this to really stop streaming and I very much doubt this will
> work reliably if stop_streaming just returns without really stopping the
> DMA.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pawel Osciak <pawel@osciak.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
[snip]
>  drivers/media/platform/davinci/vpbe_display.c      |  5 ++---
>  drivers/media/platform/davinci/vpif_capture.c      |  6 ++----
>  drivers/media/platform/davinci/vpif_display.c      |  6 ++----
[snip]
>  drivers/staging/media/davinci_vpfe/vpfe_video.c    |  3 +--

For the above all,

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar Lad

>  drivers/staging/media/dt3155v4l/dt3155v4l.c        |  3 +--
>  drivers/staging/media/go7007/go7007-v4l2.c         |  3 +--
>  drivers/staging/media/msi3101/sdr-msi3101.c        | 24 ++++++++--------------
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c   |  7 ++-----
>  drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |  3 +--
>  drivers/staging/media/solo6x10/solo6x10-v4l2.c     |  3 +--
>  include/media/videobuf2-core.h                     |  2 +-
>  41 files changed, 69 insertions(+), 128 deletions(-)
>
> diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
> index 80251dc..53dd346 100644
> --- a/Documentation/video4linux/v4l2-pci-skeleton.c
> +++ b/Documentation/video4linux/v4l2-pci-skeleton.c
> @@ -269,7 +269,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>   * Stop the DMA engine. Any remaining buffers in the DMA queue are dequeued
>   * and passed on to the vb2 framework marked as STATE_ERROR.
>   */
> -static int stop_streaming(struct vb2_queue *vq)
> +static void stop_streaming(struct vb2_queue *vq)
>  {
>         struct skeleton *skel = vb2_get_drv_priv(vq);
>
> @@ -277,7 +277,6 @@ static int stop_streaming(struct vb2_queue *vq)
>
>         /* Release all active buffers */
>         return_all_buffers(skel, VB2_BUF_STATE_ERROR);
> -       return 0;
>  }
>
>  /*
> diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
> index bb11443..7559951 100644
> --- a/drivers/media/pci/sta2x11/sta2x11_vip.c
> +++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
> @@ -357,7 +357,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>  }
>
>  /* abort streaming and wait for last buffer */
> -static int stop_streaming(struct vb2_queue *vq)
> +static void stop_streaming(struct vb2_queue *vq)
>  {
>         struct sta2x11_vip *vip = vb2_get_drv_priv(vq);
>         struct vip_buffer *vip_buf, *node;
> @@ -374,7 +374,6 @@ static int stop_streaming(struct vb2_queue *vq)
>                 list_del(&vip_buf->list);
>         }
>         spin_unlock(&vip->lock);
> -       return 0;
>  }
>
>  static struct vb2_ops vip_video_qops = {
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 200bec9..dfb09d4 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -427,7 +427,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
>         return 0;
>  }
>
> -static int bcap_stop_streaming(struct vb2_queue *vq)
> +static void bcap_stop_streaming(struct vb2_queue *vq)
>  {
>         struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
>         struct ppi_if *ppi = bcap_dev->ppi;
> @@ -452,7 +452,6 @@ static int bcap_stop_streaming(struct vb2_queue *vq)
>                 list_del(&bcap_dev->cur_frm->list);
>                 vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
>         }
> -       return 0;
>  }
>
>  static struct vb2_ops bcap_video_qops = {
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 3e5199e..d9b1a04 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -2269,7 +2269,7 @@ out:
>         return ret;
>  }
>
> -static int coda_stop_streaming(struct vb2_queue *q)
> +static void coda_stop_streaming(struct vb2_queue *q)
>  {
>         struct coda_ctx *ctx = vb2_get_drv_priv(q);
>         struct coda_dev *dev = ctx->dev;
> @@ -2295,8 +2295,6 @@ static int coda_stop_streaming(struct vb2_queue *q)
>                         ctx->bitstream.vaddr, ctx->bitstream.size);
>                 ctx->runcounter = 0;
>         }
> -
> -       return 0;
>  }
>
>  static struct vb2_ops coda_qops = {
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index a9ad949..4025b1b 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -368,7 +368,7 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
>         return ret;
>  }
>
> -static int vpbe_stop_streaming(struct vb2_queue *vq)
> +static void vpbe_stop_streaming(struct vb2_queue *vq)
>  {
>         struct vpbe_fh *fh = vb2_get_drv_priv(vq);
>         struct vpbe_layer *layer = fh->layer;
> @@ -376,7 +376,7 @@ static int vpbe_stop_streaming(struct vb2_queue *vq)
>         unsigned long flags;
>
>         if (!vb2_is_streaming(vq))
> -               return 0;
> +               return;
>
>         /* release all active buffers */
>         spin_lock_irqsave(&disp->dma_queue_lock, flags);
> @@ -398,7 +398,6 @@ static int vpbe_stop_streaming(struct vb2_queue *vq)
>                 vb2_buffer_done(&layer->next_frm->vb, VB2_BUF_STATE_ERROR);
>         }
>         spin_unlock_irqrestore(&disp->dma_queue_lock, flags);
> -       return 0;
>  }
>
>  static struct vb2_ops video_qops = {
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 8dea0b8..d09a27a 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -346,7 +346,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>  }
>
>  /* abort streaming and wait for last buffer */
> -static int vpif_stop_streaming(struct vb2_queue *vq)
> +static void vpif_stop_streaming(struct vb2_queue *vq)
>  {
>         struct vpif_fh *fh = vb2_get_drv_priv(vq);
>         struct channel_obj *ch = fh->channel;
> @@ -354,7 +354,7 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
>         unsigned long flags;
>
>         if (!vb2_is_streaming(vq))
> -               return 0;
> +               return;
>
>         common = &ch->common[VPIF_VIDEO_INDEX];
>
> @@ -390,8 +390,6 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
>                 vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
>         }
>         spin_unlock_irqrestore(&common->irqlock, flags);
> -
> -       return 0;
>  }
>
>  static struct vb2_ops video_qops = {
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index aed41ed..d03487f 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -308,7 +308,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>  }
>
>  /* abort streaming and wait for last buffer */
> -static int vpif_stop_streaming(struct vb2_queue *vq)
> +static void vpif_stop_streaming(struct vb2_queue *vq)
>  {
>         struct vpif_fh *fh = vb2_get_drv_priv(vq);
>         struct channel_obj *ch = fh->channel;
> @@ -316,7 +316,7 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
>         unsigned long flags;
>
>         if (!vb2_is_streaming(vq))
> -               return 0;
> +               return;
>
>         common = &ch->common[VPIF_VIDEO_INDEX];
>
> @@ -352,8 +352,6 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
>                 vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
>         }
>         spin_unlock_irqrestore(&common->irqlock, flags);
> -
> -       return 0;
>  }
>
>  static struct vb2_ops video_qops = {
> diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> index d0ea94f..e434f1f0 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> @@ -66,15 +66,13 @@ static int gsc_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
>         return ret > 0 ? 0 : ret;
>  }
>
> -static int gsc_m2m_stop_streaming(struct vb2_queue *q)
> +static void gsc_m2m_stop_streaming(struct vb2_queue *q)
>  {
>         struct gsc_ctx *ctx = q->drv_priv;
>
>         __gsc_m2m_job_abort(ctx);
>
>         pm_runtime_put(&ctx->gsc_dev->pdev->dev);
> -
> -       return 0;
>  }
>
>  void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
> diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
> index 92ae812..3d2babd 100644
> --- a/drivers/media/platform/exynos4-is/fimc-capture.c
> +++ b/drivers/media/platform/exynos4-is/fimc-capture.c
> @@ -294,15 +294,15 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
>         return 0;
>  }
>
> -static int stop_streaming(struct vb2_queue *q)
> +static void stop_streaming(struct vb2_queue *q)
>  {
>         struct fimc_ctx *ctx = q->drv_priv;
>         struct fimc_dev *fimc = ctx->fimc_dev;
>
>         if (!fimc_capture_active(fimc))
> -               return -EINVAL;
> +               return;
>
> -       return fimc_stop_capture(fimc, false);
> +       fimc_stop_capture(fimc, false);
>  }
>
>  int fimc_capture_suspend(struct fimc_dev *fimc)
> diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
> index e92b4e1..ced4660 100644
> --- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
> +++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
> @@ -125,7 +125,7 @@ static int isp_video_capture_start_streaming(struct vb2_queue *q,
>         return ret;
>  }
>
> -static int isp_video_capture_stop_streaming(struct vb2_queue *q)
> +static void isp_video_capture_stop_streaming(struct vb2_queue *q)
>  {
>         struct fimc_isp *isp = vb2_get_drv_priv(q);
>         struct fimc_is *is = fimc_isp_to_is(isp);
> @@ -134,7 +134,7 @@ static int isp_video_capture_stop_streaming(struct vb2_queue *q)
>
>         ret = fimc_pipeline_call(&isp->video_capture.ve, set_stream, 0);
>         if (ret < 0)
> -               return ret;
> +               return;
>
>         dma->cmd = DMA_OUTPUT_COMMAND_DISABLE;
>         dma->notify_dma_done = DMA_OUTPUT_NOTIFY_DMA_DONE_DISABLE;
> @@ -155,7 +155,6 @@ static int isp_video_capture_stop_streaming(struct vb2_queue *q)
>         clear_bit(ST_ISP_VID_CAP_STREAMING, &isp->state);
>
>         isp->video_capture.buf_count = 0;
> -       return 0;
>  }
>
>  static int isp_video_capture_buffer_prepare(struct vb2_buffer *vb)
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
> index 3ad660b..630aef5 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> @@ -350,14 +350,14 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
>         return 0;
>  }
>
> -static int stop_streaming(struct vb2_queue *q)
> +static void stop_streaming(struct vb2_queue *q)
>  {
>         struct fimc_lite *fimc = q->drv_priv;
>
>         if (!fimc_lite_active(fimc))
> -               return -EINVAL;
> +               return;
>
> -       return fimc_lite_stop_capture(fimc, false);
> +       fimc_lite_stop_capture(fimc, false);
>  }
>
>  static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
> diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
> index 36971d9..d314155 100644
> --- a/drivers/media/platform/exynos4-is/fimc-m2m.c
> +++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
> @@ -85,7 +85,7 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
>         return ret > 0 ? 0 : ret;
>  }
>
> -static int stop_streaming(struct vb2_queue *q)
> +static void stop_streaming(struct vb2_queue *q)
>  {
>         struct fimc_ctx *ctx = q->drv_priv;
>         int ret;
> @@ -95,7 +95,6 @@ static int stop_streaming(struct vb2_queue *q)
>                 fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
>
>         pm_runtime_put(&ctx->fimc_dev->pdev->dev);
> -       return 0;
>  }
>
>  static void fimc_device_run(void *priv)
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index 8b34c48..be4b512 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -1156,7 +1156,7 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
>         return mcam_read_setup(cam);
>  }
>
> -static int mcam_vb_stop_streaming(struct vb2_queue *vq)
> +static void mcam_vb_stop_streaming(struct vb2_queue *vq)
>  {
>         struct mcam_camera *cam = vb2_get_drv_priv(vq);
>         unsigned long flags;
> @@ -1164,10 +1164,10 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
>         if (cam->state == S_BUFWAIT) {
>                 /* They never gave us buffers */
>                 cam->state = S_IDLE;
> -               return 0;
> +               return;
>         }
>         if (cam->state != S_STREAMING)
> -               return -EINVAL;
> +               return;
>         mcam_ctlr_stop_dma(cam);
>         /*
>          * Reset the CCIC PHY after stopping streaming,
> @@ -1182,7 +1182,6 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
>         spin_lock_irqsave(&cam->dev_lock, flags);
>         INIT_LIST_HEAD(&cam->buffers);
>         spin_unlock_irqrestore(&cam->dev_lock, flags);
> -       return 0;
>  }
>
>
> diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
> index 4f3096b..0714070 100644
> --- a/drivers/media/platform/mem2mem_testdev.c
> +++ b/drivers/media/platform/mem2mem_testdev.c
> @@ -787,7 +787,7 @@ static int m2mtest_start_streaming(struct vb2_queue *q, unsigned count)
>         return 0;
>  }
>
> -static int m2mtest_stop_streaming(struct vb2_queue *q)
> +static void m2mtest_stop_streaming(struct vb2_queue *q)
>  {
>         struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
>         struct vb2_buffer *vb;
> @@ -799,12 +799,11 @@ static int m2mtest_stop_streaming(struct vb2_queue *q)
>                 else
>                         vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
>                 if (vb == NULL)
> -                       return 0;
> +                       return;
>                 spin_lock_irqsave(&ctx->dev->irqlock, flags);
>                 v4l2_m2m_buf_done(vb, VB2_BUF_STATE_ERROR);
>                 spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
>         }
> -       return 0;
>  }
>
>  static struct vb2_ops m2mtest_qops = {
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
> index 4e4d163..deba425 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -435,10 +435,10 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>         return 0;
>  }
>
> -static int stop_streaming(struct vb2_queue *vq)
> +static void stop_streaming(struct vb2_queue *vq)
>  {
>         struct camif_vp *vp = vb2_get_drv_priv(vq);
> -       return camif_stop_capture(vp);
> +       camif_stop_capture(vp);
>  }
>
>  static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 8a18972..368b3f6 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1670,13 +1670,11 @@ static int s5p_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
>         return ret > 0 ? 0 : ret;
>  }
>
> -static int s5p_jpeg_stop_streaming(struct vb2_queue *q)
> +static void s5p_jpeg_stop_streaming(struct vb2_queue *q)
>  {
>         struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(q);
>
>         pm_runtime_put(ctx->jpeg->dev);
> -
> -       return 0;
>  }
>
>  static struct vb2_ops s5p_jpeg_qops = {
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 8faf969..58b7bba 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -1027,7 +1027,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
>         return 0;
>  }
>
> -static int s5p_mfc_stop_streaming(struct vb2_queue *q)
> +static void s5p_mfc_stop_streaming(struct vb2_queue *q)
>  {
>         unsigned long flags;
>         struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
> @@ -1071,7 +1071,6 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
>         }
>         if (aborted)
>                 ctx->state = MFCINST_RUNNING;
> -       return 0;
>  }
>
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index df83cd1..458279e 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -1954,7 +1954,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
>         return 0;
>  }
>
> -static int s5p_mfc_stop_streaming(struct vb2_queue *q)
> +static void s5p_mfc_stop_streaming(struct vb2_queue *q)
>  {
>         unsigned long flags;
>         struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
> @@ -1983,7 +1983,6 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
>                 ctx->src_queue_cnt = 0;
>         }
>         spin_unlock_irqrestore(&dev->irqlock, flags);
> -       return 0;
>  }
>
>  static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
> diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
> index a1ce55f..9f1e52f 100644
> --- a/drivers/media/platform/s5p-tv/mixer_video.c
> +++ b/drivers/media/platform/s5p-tv/mixer_video.c
> @@ -985,7 +985,7 @@ static void mxr_watchdog(unsigned long arg)
>         spin_unlock_irqrestore(&layer->enq_slock, flags);
>  }
>
> -static int stop_streaming(struct vb2_queue *vq)
> +static void stop_streaming(struct vb2_queue *vq)
>  {
>         struct mxr_layer *layer = vb2_get_drv_priv(vq);
>         struct mxr_device *mdev = layer->mdev;
> @@ -1031,7 +1031,6 @@ static int stop_streaming(struct vb2_queue *vq)
>         mxr_streamer_put(mdev);
>         /* allow changes in output configuration */
>         mxr_output_put(mdev);
> -       return 0;
>  }
>
>  static struct vb2_ops mxr_video_qops = {
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index f0b6c90..38c723a 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -406,7 +406,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>  }
>
>  /* abort streaming and wait for last buffer */
> -static int stop_streaming(struct vb2_queue *vq)
> +static void stop_streaming(struct vb2_queue *vq)
>  {
>         struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>         struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> @@ -433,7 +433,7 @@ static int stop_streaming(struct vb2_queue *vq)
>         if (time_after(jiffies, timeout)) {
>                 dev_err(icd->parent,
>                         "Timeout waiting for finishing codec request\n");
> -               return -ETIMEDOUT;
> +               return;
>         }
>
>         /* Disable interrupts */
> @@ -444,8 +444,6 @@ static int stop_streaming(struct vb2_queue *vq)
>         ret = atmel_isi_wait_status(isi, WAIT_ISI_DISABLE);
>         if (ret < 0)
>                 dev_err(icd->parent, "Disable ISI timed out\n");
> -
> -       return ret;
>  }
>
>  static struct vb2_ops isi_video_qops = {
> diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
> index 3e84480..b40bc2e 100644
> --- a/drivers/media/platform/soc_camera/mx2_camera.c
> +++ b/drivers/media/platform/soc_camera/mx2_camera.c
> @@ -741,7 +741,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
>         return 0;
>  }
>
> -static int mx2_stop_streaming(struct vb2_queue *q)
> +static void mx2_stop_streaming(struct vb2_queue *q)
>  {
>         struct soc_camera_device *icd = soc_camera_from_vb2q(q);
>         struct soc_camera_host *ici =
> @@ -773,8 +773,6 @@ static int mx2_stop_streaming(struct vb2_queue *q)
>
>         dma_free_coherent(ici->v4l2_dev.dev,
>                           pcdev->discard_size, b, pcdev->discard_buffer_dma);
> -
> -       return 0;
>  }
>
>  static struct vb2_ops mx2_videobuf_ops = {
> diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
> index 9ed81ac..83315df 100644
> --- a/drivers/media/platform/soc_camera/mx3_camera.c
> +++ b/drivers/media/platform/soc_camera/mx3_camera.c
> @@ -406,7 +406,7 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)
>         return 0;
>  }
>
> -static int mx3_stop_streaming(struct vb2_queue *q)
> +static void mx3_stop_streaming(struct vb2_queue *q)
>  {
>         struct soc_camera_device *icd = soc_camera_from_vb2q(q);
>         struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> @@ -430,8 +430,6 @@ static int mx3_stop_streaming(struct vb2_queue *q)
>         }
>
>         spin_unlock_irqrestore(&mx3_cam->lock, flags);
> -
> -       return 0;
>  }
>
>  static struct vb2_ops mx3_videobuf_ops = {
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 704eee7..e594230 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -513,7 +513,7 @@ static int rcar_vin_videobuf_init(struct vb2_buffer *vb)
>         return 0;
>  }
>
> -static int rcar_vin_stop_streaming(struct vb2_queue *vq)
> +static void rcar_vin_stop_streaming(struct vb2_queue *vq)
>  {
>         struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>         struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> @@ -524,8 +524,6 @@ static int rcar_vin_stop_streaming(struct vb2_queue *vq)
>         list_for_each_safe(buf_head, tmp, &priv->capture)
>                 list_del_init(buf_head);
>         spin_unlock_irq(&priv->lock);
> -
> -       return 0;
>  }
>
>  static struct vb2_ops rcar_vin_vb2_ops = {
> diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> index 3e75a46..20ad4a5 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> @@ -471,7 +471,7 @@ static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
>         return 0;
>  }
>
> -static int sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
> +static void sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
>  {
>         struct soc_camera_device *icd = container_of(q, struct soc_camera_device, vb2_vidq);
>         struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> @@ -487,7 +487,7 @@ static int sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
>
>         spin_unlock_irq(&pcdev->lock);
>
> -       return sh_mobile_ceu_soft_reset(pcdev);
> +       sh_mobile_ceu_soft_reset(pcdev);
>  }
>
>  static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index 3890f4f..d00bf3d 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -906,12 +906,11 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>  }
>
>  /* abort streaming and wait for last buffer */
> -static int stop_streaming(struct vb2_queue *vq)
> +static void stop_streaming(struct vb2_queue *vq)
>  {
>         struct vivi_dev *dev = vb2_get_drv_priv(vq);
>         dprintk(dev, 1, "%s\n", __func__);
>         vivi_stop_generating(dev);
> -       return 0;
>  }
>
>  static void vivi_lock(struct vb2_queue *vq)
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index b48f135..a0595c1 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -720,7 +720,7 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
>         return 0;
>  }
>
> -static int vsp1_video_stop_streaming(struct vb2_queue *vq)
> +static void vsp1_video_stop_streaming(struct vb2_queue *vq)
>  {
>         struct vsp1_video *video = vb2_get_drv_priv(vq);
>         struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
> @@ -743,8 +743,6 @@ static int vsp1_video_stop_streaming(struct vb2_queue *vq)
>         spin_lock_irqsave(&video->irqlock, flags);
>         INIT_LIST_HEAD(&video->irqqueue);
>         spin_unlock_irqrestore(&video->irqlock, flags);
> -
> -       return 0;
>  }
>
>  static struct vb2_ops vsp1_video_queue_qops = {
> diff --git a/drivers/media/usb/em28xx/em28xx-v4l.h b/drivers/media/usb/em28xx/em28xx-v4l.h
> index bce4386..432862c 100644
> --- a/drivers/media/usb/em28xx/em28xx-v4l.h
> +++ b/drivers/media/usb/em28xx/em28xx-v4l.h
> @@ -16,5 +16,5 @@
>
>
>  int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count);
> -int em28xx_stop_vbi_streaming(struct vb2_queue *vq);
> +void em28xx_stop_vbi_streaming(struct vb2_queue *vq);
>  extern struct vb2_ops em28xx_vbi_qops;
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 0856e5d..cdcd751 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -937,7 +937,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
>         return rc;
>  }
>
> -static int em28xx_stop_streaming(struct vb2_queue *vq)
> +static void em28xx_stop_streaming(struct vb2_queue *vq)
>  {
>         struct em28xx *dev = vb2_get_drv_priv(vq);
>         struct em28xx_dmaqueue *vidq = &dev->vidq;
> @@ -961,11 +961,9 @@ static int em28xx_stop_streaming(struct vb2_queue *vq)
>         }
>         dev->usb_ctl.vid_buf = NULL;
>         spin_unlock_irqrestore(&dev->slock, flags);
> -
> -       return 0;
>  }
>
> -int em28xx_stop_vbi_streaming(struct vb2_queue *vq)
> +void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
>  {
>         struct em28xx *dev = vb2_get_drv_priv(vq);
>         struct em28xx_dmaqueue *vbiq = &dev->vbiq;
> @@ -989,8 +987,6 @@ int em28xx_stop_vbi_streaming(struct vb2_queue *vq)
>         }
>         dev->usb_ctl.vbi_buf = NULL;
>         spin_unlock_irqrestore(&dev->slock, flags);
> -
> -       return 0;
>  }
>
>  static void
> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> index 84a6720..a73b0bc 100644
> --- a/drivers/media/usb/pwc/pwc-if.c
> +++ b/drivers/media/usb/pwc/pwc-if.c
> @@ -681,12 +681,11 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>         return r;
>  }
>
> -static int stop_streaming(struct vb2_queue *vq)
> +static void stop_streaming(struct vb2_queue *vq)
>  {
>         struct pwc_device *pdev = vb2_get_drv_priv(vq);
>
> -       if (mutex_lock_interruptible(&pdev->v4l2_lock))
> -               return -ERESTARTSYS;
> +       mutex_lock(&pdev->v4l2_lock);
>         if (pdev->udev) {
>                 pwc_set_leds(pdev, 0, 0);
>                 pwc_camera_power(pdev, 0);
> @@ -695,8 +694,6 @@ static int stop_streaming(struct vb2_queue *vq)
>
>         pwc_cleanup_queued_bufs(pdev);
>         mutex_unlock(&pdev->v4l2_lock);
> -
> -       return 0;
>  }
>
>  static struct vb2_ops pwc_vb_queue_ops = {
> diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
> index 1d4ba2b..e019dd6 100644
> --- a/drivers/media/usb/s2255/s2255drv.c
> +++ b/drivers/media/usb/s2255/s2255drv.c
> @@ -714,7 +714,7 @@ static void buffer_queue(struct vb2_buffer *vb)
>  }
>
>  static int start_streaming(struct vb2_queue *vq, unsigned int count);
> -static int stop_streaming(struct vb2_queue *vq);
> +static void stop_streaming(struct vb2_queue *vq);
>
>  static struct vb2_ops s2255_video_qops = {
>         .queue_setup = queue_setup,
> @@ -1109,7 +1109,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>  }
>
>  /* abort streaming and wait for last buffer */
> -static int stop_streaming(struct vb2_queue *vq)
> +static void stop_streaming(struct vb2_queue *vq)
>  {
>         struct s2255_vc *vc = vb2_get_drv_priv(vq);
>         struct s2255_buffer *buf, *node;
> @@ -1123,7 +1123,6 @@ static int stop_streaming(struct vb2_queue *vq)
>                         buf, buf->vb.v4l2_buf.index);
>         }
>         spin_unlock_irqrestore(&vc->qlock, flags);
> -       return 0;
>  }
>
>  static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
> diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
> index 37bc00f..46e8a50 100644
> --- a/drivers/media/usb/stk1160/stk1160-v4l.c
> +++ b/drivers/media/usb/stk1160/stk1160-v4l.c
> @@ -583,10 +583,10 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>  }
>
>  /* abort streaming and wait for last buffer */
> -static int stop_streaming(struct vb2_queue *vq)
> +static void stop_streaming(struct vb2_queue *vq)
>  {
>         struct stk1160 *dev = vb2_get_drv_priv(vq);
> -       return stk1160_stop_streaming(dev);
> +       stk1160_stop_streaming(dev);
>  }
>
>  static struct vb2_ops stk1160_video_qops = {
> diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
> index 20365bd..2967e80 100644
> --- a/drivers/media/usb/usbtv/usbtv-video.c
> +++ b/drivers/media/usb/usbtv/usbtv-video.c
> @@ -634,15 +634,12 @@ static int usbtv_start_streaming(struct vb2_queue *vq, unsigned int count)
>         return usbtv_start(usbtv);
>  }
>
> -static int usbtv_stop_streaming(struct vb2_queue *vq)
> +static void usbtv_stop_streaming(struct vb2_queue *vq)
>  {
>         struct usbtv *usbtv = vb2_get_drv_priv(vq);
>
> -       if (usbtv->udev == NULL)
> -               return -ENODEV;
> -
> -       usbtv_stop(usbtv);
> -       return 0;
> +       if (usbtv->udev)
> +               usbtv_stop(usbtv);
>  }
>
>  static struct vb2_ops usbtv_vb2_ops = {
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 3f0cdb1..f8f694a 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2086,7 +2086,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>          * buffers.
>          */
>         if (q->start_streaming_called)
> -               call_qop(q, stop_streaming, q);
> +               call_void_qop(q, stop_streaming, q);
>         q->streaming = 0;
>         q->start_streaming_called = 0;
>         q->queued_count = 0;
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 9337d92..7b213a7 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -1249,7 +1249,7 @@ static int vpfe_buffer_init(struct vb2_buffer *vb)
>  }
>
>  /* abort streaming and wait for last buffer */
> -static int vpfe_stop_streaming(struct vb2_queue *vq)
> +static void vpfe_stop_streaming(struct vb2_queue *vq)
>  {
>         struct vpfe_fh *fh = vb2_get_drv_priv(vq);
>         struct vpfe_video_device *video = fh->video;
> @@ -1272,7 +1272,6 @@ static int vpfe_stop_streaming(struct vb2_queue *vq)
>                 list_del(&video->next_frm->list);
>                 vb2_buffer_done(&video->next_frm->vb, VB2_BUF_STATE_ERROR);
>         }
> -       return 0;
>  }
>
>  static void vpfe_buf_cleanup(struct vb2_buffer *vb)
> diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> index afbc2e5..14bdc19 100644
> --- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
> +++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> @@ -262,7 +262,7 @@ dt3155_buf_prepare(struct vb2_buffer *vb)
>         return 0;
>  }
>
> -static int
> +static void
>  dt3155_stop_streaming(struct vb2_queue *q)
>  {
>         struct dt3155_priv *pd = vb2_get_drv_priv(q);
> @@ -276,7 +276,6 @@ dt3155_stop_streaming(struct vb2_queue *q)
>         }
>         spin_unlock_irq(&pd->lock);
>         msleep(45); /* irq hendler will stop the hardware */
> -       return 0;
>  }
>
>  static void
> diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
> index b397aa3..090b3e6e 100644
> --- a/drivers/staging/media/go7007/go7007-v4l2.c
> +++ b/drivers/staging/media/go7007/go7007-v4l2.c
> @@ -516,7 +516,7 @@ static int go7007_start_streaming(struct vb2_queue *q, unsigned int count)
>         return ret;
>  }
>
> -static int go7007_stop_streaming(struct vb2_queue *q)
> +static void go7007_stop_streaming(struct vb2_queue *q)
>  {
>         struct go7007 *go = vb2_get_drv_priv(q);
>         unsigned long flags;
> @@ -538,7 +538,6 @@ static int go7007_stop_streaming(struct vb2_queue *q)
>         /* Turn on Capture LED */
>         if (go->board_id == GO7007_BOARDID_ADS_USBAV_709)
>                 go7007_write_addr(go, 0x3c82, 0x000d);
> -       return 0;
>  }
>
>  static struct vb2_ops go7007_video_qops = {
> diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
> index 65d351f..08d0d09 100644
> --- a/drivers/staging/media/msi3101/sdr-msi3101.c
> +++ b/drivers/staging/media/msi3101/sdr-msi3101.c
> @@ -1074,14 +1074,13 @@ static int msi3101_start_streaming(struct vb2_queue *vq, unsigned int count)
>         return ret;
>  }
>
> -static int msi3101_stop_streaming(struct vb2_queue *vq)
> +static void msi3101_stop_streaming(struct vb2_queue *vq)
>  {
>         struct msi3101_state *s = vb2_get_drv_priv(vq);
> -       int ret;
> +
>         dev_dbg(&s->udev->dev, "%s:\n", __func__);
>
> -       if (mutex_lock_interruptible(&s->v4l2_lock))
> -               return -ERESTARTSYS;
> +       mutex_lock(&s->v4l2_lock);
>
>         if (s->udev)
>                 msi3101_isoc_cleanup(s);
> @@ -1090,22 +1089,15 @@ static int msi3101_stop_streaming(struct vb2_queue *vq)
>
>         /* according to tests, at least 700us delay is required  */
>         msleep(20);
> -       ret = msi3101_ctrl_msg(s, CMD_STOP_STREAMING, 0);
> -       if (ret)
> -               goto err_sleep_tuner;
> -
> -       /* sleep USB IF / ADC */
> -       ret = msi3101_ctrl_msg(s, CMD_WREG, 0x01000003);
> -       if (ret)
> -               goto err_sleep_tuner;
> +       if (!msi3101_ctrl_msg(s, CMD_STOP_STREAMING, 0)) {
> +               /* sleep USB IF / ADC */
> +               msi3101_ctrl_msg(s, CMD_WREG, 0x01000003);
> +       }
>
> -err_sleep_tuner:
>         /* sleep tuner */
> -       ret = v4l2_subdev_call(s->v4l2_subdev, core, s_power, 0);
> +       v4l2_subdev_call(s->v4l2_subdev, core, s_power, 0);
>
>         mutex_unlock(&s->v4l2_lock);
> -
> -       return ret;
>  }
>
>  static struct vb2_ops msi3101_vb2_ops = {
> diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> index 104ee8a..093df6b 100644
> --- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> +++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> @@ -1032,13 +1032,12 @@ err:
>         return ret;
>  }
>
> -static int rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
> +static void rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
>  {
>         struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
>         dev_dbg(&s->udev->dev, "%s:\n", __func__);
>
> -       if (mutex_lock_interruptible(&s->v4l2_lock))
> -               return -ERESTARTSYS;
> +       mutex_lock(&s->v4l2_lock);
>
>         rtl2832_sdr_kill_urbs(s);
>         rtl2832_sdr_free_urbs(s);
> @@ -1053,8 +1052,6 @@ static int rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
>                 s->d->props->power_ctrl(s->d, 0);
>
>         mutex_unlock(&s->v4l2_lock);
> -
> -       return 0;
>  }
>
>  static struct vb2_ops rtl2832_sdr_vb2_ops = {
> diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
> index 2cbe088..b8ff113 100644
> --- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
> +++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
> @@ -745,14 +745,13 @@ static int solo_enc_start_streaming(struct vb2_queue *q, unsigned int count)
>         return solo_ring_start(solo_enc->solo_dev);
>  }
>
> -static int solo_enc_stop_streaming(struct vb2_queue *q)
> +static void solo_enc_stop_streaming(struct vb2_queue *q)
>  {
>         struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
>
>         solo_enc_off(solo_enc);
>         INIT_LIST_HEAD(&solo_enc->vidq_active);
>         solo_ring_stop(solo_enc->solo_dev);
> -       return 0;
>  }
>
>  static struct vb2_ops solo_enc_video_qops = {
> diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2.c b/drivers/staging/media/solo6x10/solo6x10-v4l2.c
> index 1815f76..5d0100e 100644
> --- a/drivers/staging/media/solo6x10/solo6x10-v4l2.c
> +++ b/drivers/staging/media/solo6x10/solo6x10-v4l2.c
> @@ -336,13 +336,12 @@ static int solo_start_streaming(struct vb2_queue *q, unsigned int count)
>         return solo_start_thread(solo_dev);
>  }
>
> -static int solo_stop_streaming(struct vb2_queue *q)
> +static void solo_stop_streaming(struct vb2_queue *q)
>  {
>         struct solo_dev *solo_dev = vb2_get_drv_priv(q);
>
>         solo_stop_thread(solo_dev);
>         INIT_LIST_HEAD(&solo_dev->vidq_active);
> -       return 0;
>  }
>
>  static void solo_buf_queue(struct vb2_buffer *vb)
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 46e7609..bca25dc 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -324,7 +324,7 @@ struct vb2_ops {
>         void (*buf_cleanup)(struct vb2_buffer *vb);
>
>         int (*start_streaming)(struct vb2_queue *q, unsigned int count);
> -       int (*stop_streaming)(struct vb2_queue *q);
> +       void (*stop_streaming)(struct vb2_queue *q);
>
>         void (*buf_queue)(struct vb2_buffer *vb);
>  };
> --
> 1.9.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
