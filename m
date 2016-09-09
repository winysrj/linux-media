Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:8406 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750908AbcIIIym (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Sep 2016 04:54:42 -0400
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org"
        <linux-samsung-soc@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benoit Parrot <bparrot@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?Windows-1252?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org"
        <linux-mediatek@lists.infradead.org>
Date: Fri, 9 Sep 2016 10:53:49 +0200
Subject: Re: [PATCH] [media] platform: constify vb2_ops structures
Message-ID: <ebe67dae-f197-e438-bd3f-0a74c0836a8c@st.com>
References: <1473379150-17315-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1473379150-17315-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi


On 09/09/2016 01:59 AM, Julia Lawall wrote:
> Check for vb2_ops structures that are only stored in the ops field of a
> vb2_queue structure.  That field is declared const, so vb2_ops structures
> that have this property can be declared as const also.
>
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r disable optional_qualifier@
> identifier i;
> position p;
> @@
> static struct vb2_ops i@p = { ... };
>
> @ok@
> identifier r.i;
> struct vb2_queue e;
> position p;
> @@
> e.ops = &i@p;
>
> @bad@
> position p != {r.p,ok.p};
> identifier r.i;
> struct vb2_ops e;
> @@
> e@i@p
>
> @depends on !bad disable optional_qualifier@
> identifier r.i;
> @@
> static
> +const
>   struct vb2_ops i = { ... };
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>   drivers/media/platform/exynos-gsc/gsc-m2m.c              |    2 +-
>   drivers/media/platform/exynos4-is/fimc-capture.c         |    2 +-
>   drivers/media/platform/exynos4-is/fimc-m2m.c             |    2 +-
>   drivers/media/platform/m2m-deinterlace.c                 |    2 +-
>   drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c       |    2 +-
>   drivers/media/platform/mx2_emmaprp.c                     |    2 +-
>   drivers/media/platform/rcar-vin/rcar-dma.c               |    2 +-
>   drivers/media/platform/rcar_jpu.c                        |    2 +-
>   drivers/media/platform/s5p-g2d/g2d.c                     |    2 +-
>   drivers/media/platform/s5p-jpeg/jpeg-core.c              |    2 +-
>   drivers/media/platform/sh_vou.c                          |    2 +-
>   drivers/media/platform/soc_camera/atmel-isi.c            |    2 +-
>   drivers/media/platform/soc_camera/rcar_vin.c             |    2 +-
>   drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |    2 +-

For this driver:
>   drivers/media/platform/sti/bdisp/bdisp-v4l2.c            |    2 +-
Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>

>   drivers/media/platform/ti-vpe/cal.c                      |    2 +-
>   drivers/media/platform/ti-vpe/vpe.c                      |    2 +-
>   drivers/media/platform/vim2m.c                           |    2 +-
>   drivers/media/platform/xilinx/xilinx-dma.c               |    2 +-
>   19 files changed, 19 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index 7ae1a13..1d5836c 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -474,7 +474,7 @@ static void xvip_dma_stop_streaming(struct vb2_queue *vq)
>          spin_unlock_irq(&dma->queued_lock);
>   }
>
> -static struct vb2_ops xvip_dma_queue_qops = {
> +static const struct vb2_ops xvip_dma_queue_qops = {
>          .queue_setup = xvip_dma_queue_setup,
>          .buf_prepare = xvip_dma_buffer_prepare,
>          .buf_queue = xvip_dma_buffer_queue,
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 30211f6..46de657 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -536,7 +536,7 @@ static void stop_streaming(struct vb2_queue *vq)
>          pm_runtime_put(ici->v4l2_dev.dev);
>   }
>
> -static struct vb2_ops isi_video_qops = {
> +static const struct vb2_ops isi_video_qops = {
>          .queue_setup            = queue_setup,
>          .buf_init               = buffer_init,
>          .buf_prepare            = buffer_prepare,
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 785e693..d9c07b8 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -2538,7 +2538,7 @@ static void s5p_jpeg_stop_streaming(struct vb2_queue *q)
>          pm_runtime_put(ctx->jpeg->dev);
>   }
>
> -static struct vb2_ops s5p_jpeg_qops = {
> +static const struct vb2_ops s5p_jpeg_qops = {
>          .queue_setup            = s5p_jpeg_queue_setup,
>          .buf_prepare            = s5p_jpeg_buf_prepare,
>          .buf_queue              = s5p_jpeg_buf_queue,
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index e967fcf..44323cb 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -1379,7 +1379,7 @@ static void cal_stop_streaming(struct vb2_queue *vq)
>          cal_runtime_put(ctx->dev);
>   }
>
> -static struct vb2_ops cal_video_qops = {
> +static const struct vb2_ops cal_video_qops = {
>          .queue_setup            = cal_queue_setup,
>          .buf_prepare            = cal_buffer_prepare,
>          .buf_queue              = cal_buffer_queue,
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 55a1458..0189f7f 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -1878,7 +1878,7 @@ static void vpe_stop_streaming(struct vb2_queue *q)
>          vpdma_dump_regs(ctx->dev->vpdma);
>   }
>
> -static struct vb2_ops vpe_qops = {
> +static const struct vb2_ops vpe_qops = {
>          .queue_setup     = vpe_queue_setup,
>          .buf_prepare     = vpe_buf_prepare,
>          .buf_queue       = vpe_buf_queue,
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 9c13752..0009fc5 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -856,7 +856,7 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
>          spin_unlock_irq(&priv->lock);
>   }
>
> -static struct vb2_ops rcar_vin_vb2_ops = {
> +static const struct vb2_ops rcar_vin_vb2_ops = {
>          .queue_setup    = rcar_vin_videobuf_setup,
>          .buf_queue      = rcar_vin_videobuf_queue,
>          .stop_streaming = rcar_vin_stop_streaming,
> diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> index 02b519d..02c8dc5 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> @@ -470,7 +470,7 @@ static void sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
>          sh_mobile_ceu_soft_reset(pcdev);
>   }
>
> -static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
> +static const struct vb2_ops sh_mobile_ceu_videobuf_ops = {
>          .queue_setup    = sh_mobile_ceu_videobuf_setup,
>          .buf_prepare    = sh_mobile_ceu_videobuf_prepare,
>          .buf_queue      = sh_mobile_ceu_videobuf_queue,
> diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
> index 391dd7a..62c0dec 100644
> --- a/drivers/media/platform/s5p-g2d/g2d.c
> +++ b/drivers/media/platform/s5p-g2d/g2d.c
> @@ -138,7 +138,7 @@ static void g2d_buf_queue(struct vb2_buffer *vb)
>          v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
>   }
>
> -static struct vb2_ops g2d_qops = {
> +static const struct vb2_ops g2d_qops = {
>          .queue_setup    = g2d_queue_setup,
>          .buf_prepare    = g2d_buf_prepare,
>          .buf_queue      = g2d_buf_queue,
> diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
> index 16782ce..d1746ec 100644
> --- a/drivers/media/platform/rcar_jpu.c
> +++ b/drivers/media/platform/rcar_jpu.c
> @@ -1183,7 +1183,7 @@ static void jpu_stop_streaming(struct vb2_queue *vq)
>          }
>   }
>
> -static struct vb2_ops jpu_qops = {
> +static const struct vb2_ops jpu_qops = {
>          .queue_setup            = jpu_queue_setup,
>          .buf_prepare            = jpu_buf_prepare,
>          .buf_queue              = jpu_buf_queue,
> diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> index ec6494c..a341a7f 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> @@ -261,7 +261,7 @@ static void gsc_m2m_buf_queue(struct vb2_buffer *vb)
>                  v4l2_m2m_buf_queue(ctx->m2m_ctx, vbuf);
>   }
>
> -static struct vb2_ops gsc_m2m_qops = {
> +static const struct vb2_ops gsc_m2m_qops = {
>          .queue_setup     = gsc_m2m_queue_setup,
>          .buf_prepare     = gsc_m2m_buf_prepare,
>          .buf_queue       = gsc_m2m_buf_queue,
> diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
> index e1f39b4..1ec9a2e 100644
> --- a/drivers/media/platform/sh_vou.c
> +++ b/drivers/media/platform/sh_vou.c
> @@ -362,7 +362,7 @@ static void sh_vou_stop_streaming(struct vb2_queue *vq)
>          spin_unlock_irqrestore(&vou_dev->lock, flags);
>   }
>
> -static struct vb2_ops sh_vou_qops = {
> +static const struct vb2_ops sh_vou_qops = {
>          .queue_setup            = sh_vou_queue_setup,
>          .buf_prepare            = sh_vou_buf_prepare,
>          .buf_queue              = sh_vou_buf_queue,
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> index 3b1ac68..45f82b5 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> +++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> @@ -527,7 +527,7 @@ static void bdisp_stop_streaming(struct vb2_queue *q)
>          pm_runtime_put(ctx->bdisp_dev->dev);
>   }
>
> -static struct vb2_ops bdisp_qops = {
> +static const struct vb2_ops bdisp_qops = {
>          .queue_setup     = bdisp_queue_setup,
>          .buf_prepare     = bdisp_buf_prepare,
>          .buf_queue       = bdisp_buf_queue,
> diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
> index 0fcb5c78..0870fad 100644
> --- a/drivers/media/platform/m2m-deinterlace.c
> +++ b/drivers/media/platform/m2m-deinterlace.c
> @@ -852,7 +852,7 @@ static void deinterlace_buf_queue(struct vb2_buffer *vb)
>          v4l2_m2m_buf_queue(ctx->m2m_ctx, vbuf);
>   }
>
> -static struct vb2_ops deinterlace_qops = {
> +static const struct vb2_ops deinterlace_qops = {
>          .queue_setup     = deinterlace_queue_setup,
>          .buf_prepare     = deinterlace_buf_prepare,
>          .buf_queue       = deinterlace_buf_queue,
> diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
> index c639406..e68d271 100644
> --- a/drivers/media/platform/mx2_emmaprp.c
> +++ b/drivers/media/platform/mx2_emmaprp.c
> @@ -743,7 +743,7 @@ static void emmaprp_buf_queue(struct vb2_buffer *vb)
>          v4l2_m2m_buf_queue(ctx->m2m_ctx, vbuf);
>   }
>
> -static struct vb2_ops emmaprp_qops = {
> +static const struct vb2_ops emmaprp_qops = {
>          .queue_setup     = emmaprp_queue_setup,
>          .buf_prepare     = emmaprp_buf_prepare,
>          .buf_queue       = emmaprp_buf_queue,
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index 496aa97..07c07c1 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1116,7 +1116,7 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
>          rvin_disable_interrupts(vin);
>   }
>
> -static struct vb2_ops rvin_qops = {
> +static const struct vb2_ops rvin_qops = {
>          .queue_setup            = rvin_queue_setup,
>          .buf_prepare            = rvin_buffer_prepare,
>          .buf_queue              = rvin_buffer_queue,
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index cd0ff4a..a98f679 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -815,7 +815,7 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
>          }
>   }
>
> -static struct vb2_ops vim2m_qops = {
> +static const struct vb2_ops vim2m_qops = {
>          .queue_setup     = vim2m_queue_setup,
>          .buf_prepare     = vim2m_buf_prepare,
>          .buf_queue       = vim2m_buf_queue,
> diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
> index fdec499..344028e 100644
> --- a/drivers/media/platform/exynos4-is/fimc-capture.c
> +++ b/drivers/media/platform/exynos4-is/fimc-capture.c
> @@ -452,7 +452,7 @@ static void buffer_queue(struct vb2_buffer *vb)
>          spin_unlock_irqrestore(&fimc->slock, flags);
>   }
>
> -static struct vb2_ops fimc_capture_qops = {
> +static const struct vb2_ops fimc_capture_qops = {
>          .queue_setup            = queue_setup,
>          .buf_prepare            = buffer_prepare,
>          .buf_queue              = buffer_queue,
> diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
> index b1309e1..6028e4f 100644
> --- a/drivers/media/platform/exynos4-is/fimc-m2m.c
> +++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
> @@ -219,7 +219,7 @@ static void fimc_buf_queue(struct vb2_buffer *vb)
>          v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
>   }
>
> -static struct vb2_ops fimc_qops = {
> +static const struct vb2_ops fimc_qops = {
>          .queue_setup     = fimc_queue_setup,
>          .buf_prepare     = fimc_buf_prepare,
>          .buf_queue       = fimc_buf_queue,
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> index 3ed3f2d..f8e4611 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> @@ -864,7 +864,7 @@ static void vb2ops_venc_stop_streaming(struct vb2_queue *q)
>          ctx->state = MTK_STATE_FREE;
>   }
>
> -static struct vb2_ops mtk_venc_vb2_ops = {
> +static const struct vb2_ops mtk_venc_vb2_ops = {
>          .queue_setup            = vb2ops_venc_queue_setup,
>          .buf_prepare            = vb2ops_venc_buf_prepare,
>          .buf_queue              = vb2ops_venc_buf_queue,
>
