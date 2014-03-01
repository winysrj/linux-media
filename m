Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4613 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaCANoV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Mar 2014 08:44:21 -0500
Message-ID: <5311E41A.7050600@xs4all.nl>
Date: Sat, 01 Mar 2014 14:43:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: k.debski@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATH v6 04/10] v4l: Rename vb2_queue.timestamp_type as timestamp_flags
References: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi> <1393679828-25878-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393679828-25878-5-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

On 03/01/2014 02:17 PM, Sakari Ailus wrote:
> The timestamp_type field used to contain only the timestamp type. Soon it
> will be used for timestamp source flags as well. Rename the field
> accordingly.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/parport/bw-qcam.c                          |    2 +-
>  drivers/media/platform/blackfin/bfin_capture.c           |    2 +-
>  drivers/media/platform/coda.c                            |    4 ++--
>  drivers/media/platform/davinci/vpbe_display.c            |    2 +-
>  drivers/media/platform/davinci/vpif_capture.c            |    2 +-
>  drivers/media/platform/davinci/vpif_display.c            |    2 +-
>  drivers/media/platform/exynos-gsc/gsc-m2m.c              |    4 ++--
>  drivers/media/platform/exynos4-is/fimc-capture.c         |    2 +-
>  drivers/media/platform/exynos4-is/fimc-lite.c            |    2 +-
>  drivers/media/platform/exynos4-is/fimc-m2m.c             |    4 ++--
>  drivers/media/platform/m2m-deinterlace.c                 |    4 ++--
>  drivers/media/platform/mem2mem_testdev.c                 |    4 ++--
>  drivers/media/platform/mx2_emmaprp.c                     |    4 ++--
>  drivers/media/platform/s3c-camif/camif-capture.c         |    2 +-
>  drivers/media/platform/s5p-g2d/g2d.c                     |    4 ++--
>  drivers/media/platform/s5p-jpeg/jpeg-core.c              |    4 ++--
>  drivers/media/platform/s5p-mfc/s5p_mfc.c                 |    4 ++--
>  drivers/media/platform/soc_camera/atmel-isi.c            |    2 +-
>  drivers/media/platform/soc_camera/mx2_camera.c           |    2 +-
>  drivers/media/platform/soc_camera/mx3_camera.c           |    2 +-
>  drivers/media/platform/soc_camera/rcar_vin.c             |    2 +-
>  drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |    2 +-
>  drivers/media/platform/ti-vpe/vpe.c                      |    4 ++--
>  drivers/media/platform/vivi.c                            |    2 +-
>  drivers/media/platform/vsp1/vsp1_video.c                 |    2 +-
>  drivers/media/usb/em28xx/em28xx-video.c                  |    4 ++--
>  drivers/media/usb/pwc/pwc-if.c                           |    2 +-
>  drivers/media/usb/stk1160/stk1160-v4l.c                  |    2 +-
>  drivers/media/usb/usbtv/usbtv-video.c                    |    2 +-
>  drivers/media/usb/uvc/uvc_queue.c                        |    2 +-
>  drivers/media/v4l2-core/videobuf2-core.c                 |    8 ++++----
>  include/media/videobuf2-core.h                           |    2 +-
>  32 files changed, 46 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
> index d12bd33..a0a6ee6 100644
> --- a/drivers/media/parport/bw-qcam.c
> +++ b/drivers/media/parport/bw-qcam.c
> @@ -965,7 +965,7 @@ static struct qcam *qcam_init(struct parport *port)
>  	q->drv_priv = qcam;
>  	q->ops = &qcam_video_qops;
>  	q->mem_ops = &vb2_vmalloc_memops;
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	err = vb2_queue_init(q);
>  	if (err < 0) {
>  		v4l2_err(v4l2_dev, "couldn't init vb2_queue for %s.\n", port->name);
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 2819165..200bec9 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -997,7 +997,7 @@ static int bcap_probe(struct platform_device *pdev)
>  	q->buf_struct_size = sizeof(struct bcap_buffer);
>  	q->ops = &bcap_video_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	ret = vb2_queue_init(q);
>  	if (ret)
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 61f3dbc..81b6f7b 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -2428,7 +2428,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	src_vq->ops = &coda_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
> -	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -2440,7 +2440,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	dst_vq->ops = &coda_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
> -	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index b02aba4..e512767 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -1415,7 +1415,7 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
>  	q->ops = &video_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct vpbe_disp_buffer);
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	ret = vb2_queue_init(q);
>  	if (ret) {
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 735ec47..cd6da8b 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1023,7 +1023,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
>  	q->ops = &video_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct vpif_cap_buffer);
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	ret = vb2_queue_init(q);
>  	if (ret) {
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index 9d115cd..fd68236 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -983,7 +983,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
>  	q->ops = &video_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct vpif_disp_buffer);
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	ret = vb2_queue_init(q);
>  	if (ret) {
> diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> index 810c3e1..6741025 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> @@ -590,7 +590,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->ops = &gsc_m2m_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> -	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -603,7 +603,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->ops = &gsc_m2m_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> -	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
> index 8a712ca..92ae812 100644
> --- a/drivers/media/platform/exynos4-is/fimc-capture.c
> +++ b/drivers/media/platform/exynos4-is/fimc-capture.c
> @@ -1782,7 +1782,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
>  	q->ops = &fimc_capture_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct fimc_vid_buffer);
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	q->lock = &fimc->lock;
>  
>  	ret = vb2_queue_init(q);
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
> index 1234734..2be4bb5 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> @@ -1313,7 +1313,7 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct flite_buffer);
>  	q->drv_priv = fimc;
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	q->lock = &fimc->lock;
>  
>  	ret = vb2_queue_init(q);
> diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
> index 9da95bd..bfc900d 100644
> --- a/drivers/media/platform/exynos4-is/fimc-m2m.c
> +++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
> @@ -557,7 +557,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->ops = &fimc_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> -	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	src_vq->lock = &ctx->fimc_dev->lock;
>  
>  	ret = vb2_queue_init(src_vq);
> @@ -570,7 +570,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->ops = &fimc_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> -	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	dst_vq->lock = &ctx->fimc_dev->lock;
>  
>  	return vb2_queue_init(dst_vq);
> diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
> index 6bb86b5..f3a9e24 100644
> --- a/drivers/media/platform/m2m-deinterlace.c
> +++ b/drivers/media/platform/m2m-deinterlace.c
> @@ -868,7 +868,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	src_vq->ops = &deinterlace_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
> -	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	q_data[V4L2_M2M_SRC].fmt = &formats[0];
>  	q_data[V4L2_M2M_SRC].width = 640;
>  	q_data[V4L2_M2M_SRC].height = 480;
> @@ -885,7 +885,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	dst_vq->ops = &deinterlace_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
> -	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	q_data[V4L2_M2M_DST].fmt = &formats[0];
>  	q_data[V4L2_M2M_DST].width = 640;
>  	q_data[V4L2_M2M_DST].height = 480;
> diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
> index 08e2437..02a40c5 100644
> --- a/drivers/media/platform/mem2mem_testdev.c
> +++ b/drivers/media/platform/mem2mem_testdev.c
> @@ -777,7 +777,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	src_vq->ops = &m2mtest_qops;
>  	src_vq->mem_ops = &vb2_vmalloc_memops;
> -	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	src_vq->lock = &ctx->dev->dev_mutex;
>  
>  	ret = vb2_queue_init(src_vq);
> @@ -790,7 +790,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	dst_vq->ops = &m2mtest_qops;
>  	dst_vq->mem_ops = &vb2_vmalloc_memops;
> -	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	dst_vq->lock = &ctx->dev->dev_mutex;
>  
>  	return vb2_queue_init(dst_vq);
> diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
> index c690435..af3e106 100644
> --- a/drivers/media/platform/mx2_emmaprp.c
> +++ b/drivers/media/platform/mx2_emmaprp.c
> @@ -766,7 +766,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	src_vq->ops = &emmaprp_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
> -	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -778,7 +778,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	dst_vq->ops = &emmaprp_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
> -	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
> index 5372111..4e4d163 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -1160,7 +1160,7 @@ int s3c_camif_register_video_node(struct camif_dev *camif, int idx)
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct camif_buffer);
>  	q->drv_priv = vp;
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	ret = vb2_queue_init(q);
>  	if (ret)
> diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
> index 0fcf7d7..bf7c9b3 100644
> --- a/drivers/media/platform/s5p-g2d/g2d.c
> +++ b/drivers/media/platform/s5p-g2d/g2d.c
> @@ -157,7 +157,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->ops = &g2d_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> -	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	src_vq->lock = &ctx->dev->mutex;
>  
>  	ret = vb2_queue_init(src_vq);
> @@ -170,7 +170,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->ops = &g2d_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> -	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	dst_vq->lock = &ctx->dev->mutex;
>  
>  	return vb2_queue_init(dst_vq);
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index a1c78c8..f5e9870 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1701,7 +1701,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	src_vq->ops = &s5p_jpeg_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
> -	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	src_vq->lock = &ctx->jpeg->lock;
>  
>  	ret = vb2_queue_init(src_vq);
> @@ -1714,7 +1714,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	dst_vq->ops = &s5p_jpeg_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
> -	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	dst_vq->lock = &ctx->jpeg->lock;
>  
>  	return vb2_queue_init(dst_vq);
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index e2aac59..0e8c171 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -794,7 +794,7 @@ static int s5p_mfc_open(struct file *file)
>  		goto err_queue_init;
>  	}
>  	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	ret = vb2_queue_init(q);
>  	if (ret) {
>  		mfc_err("Failed to initialize videobuf2 queue(capture)\n");
> @@ -816,7 +816,7 @@ static int s5p_mfc_open(struct file *file)
>  		goto err_queue_init;
>  	}
>  	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	ret = vb2_queue_init(q);
>  	if (ret) {
>  		mfc_err("Failed to initialize videobuf2 queue(output)\n");
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 4835173..f0b6c90 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -472,7 +472,7 @@ static int isi_camera_init_videobuf(struct vb2_queue *q,
>  	q->buf_struct_size = sizeof(struct frame_buffer);
>  	q->ops = &isi_video_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	return vb2_queue_init(q);
>  }
> diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
> index d73abca..3e84480 100644
> --- a/drivers/media/platform/soc_camera/mx2_camera.c
> +++ b/drivers/media/platform/soc_camera/mx2_camera.c
> @@ -794,7 +794,7 @@ static int mx2_camera_init_videobuf(struct vb2_queue *q,
>  	q->ops = &mx2_videobuf_ops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct mx2_buffer);
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	return vb2_queue_init(q);
>  }
> diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
> index f975b70..9ed81ac 100644
> --- a/drivers/media/platform/soc_camera/mx3_camera.c
> +++ b/drivers/media/platform/soc_camera/mx3_camera.c
> @@ -453,7 +453,7 @@ static int mx3_camera_init_videobuf(struct vb2_queue *q,
>  	q->ops = &mx3_videobuf_ops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct mx3_camera_buffer);
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	return vb2_queue_init(q);
>  }
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 3b1c05a..0ff5cfa 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1360,7 +1360,7 @@ static int rcar_vin_init_videobuf2(struct vb2_queue *vq,
>  	vq->ops = &rcar_vin_vb2_ops;
>  	vq->mem_ops = &vb2_dma_contig_memops;
>  	vq->buf_struct_size = sizeof(struct rcar_vin_buffer);
> -	vq->timestamp_type  = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	vq->timestamp_flags  = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	return vb2_queue_init(vq);
>  }
> diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> index 150bd4d..3e75a46 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> @@ -1665,7 +1665,7 @@ static int sh_mobile_ceu_init_videobuf(struct vb2_queue *q,
>  	q->ops = &sh_mobile_ceu_videobuf_ops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct sh_mobile_ceu_buffer);
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	return vb2_queue_init(q);
>  }
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 1296c53..8ea3b89 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -1770,7 +1770,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	src_vq->ops = &vpe_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
> -	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -1783,7 +1783,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	dst_vq->ops = &vpe_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
> -	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index e9cd96e..776015b 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -1429,7 +1429,7 @@ static int __init vivi_create_instance(int inst)
>  	q->buf_struct_size = sizeof(struct vivi_buffer);
>  	q->ops = &vivi_video_qops;
>  	q->mem_ops = &vb2_vmalloc_memops;
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	ret = vb2_queue_init(q);
>  	if (ret)
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index b4687a8..e41f07d 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -1051,7 +1051,7 @@ int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf)
>  	video->queue.buf_struct_size = sizeof(struct vsp1_video_buffer);
>  	video->queue.ops = &vsp1_video_queue_qops;
>  	video->queue.mem_ops = &vb2_dma_contig_memops;
> -	video->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	ret = vb2_queue_init(&video->queue);
>  	if (ret < 0) {
>  		dev_err(video->vsp1->dev, "failed to initialize vb2 queue\n");
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 2775c90..52c49cb 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1029,7 +1029,7 @@ static int em28xx_vb2_setup(struct em28xx *dev)
>  	q = &dev->vb_vidq;
>  	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	q->drv_priv = dev;
>  	q->buf_struct_size = sizeof(struct em28xx_buffer);
>  	q->ops = &em28xx_video_qops;
> @@ -1043,7 +1043,7 @@ static int em28xx_vb2_setup(struct em28xx *dev)
>  	q = &dev->vb_vbiq;
>  	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
>  	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	q->drv_priv = dev;
>  	q->buf_struct_size = sizeof(struct em28xx_buffer);
>  	q->ops = &em28xx_vbi_qops;
> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> index abf365a..8bef015 100644
> --- a/drivers/media/usb/pwc/pwc-if.c
> +++ b/drivers/media/usb/pwc/pwc-if.c
> @@ -1001,7 +1001,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
>  	pdev->vb_queue.buf_struct_size = sizeof(struct pwc_frame_buf);
>  	pdev->vb_queue.ops = &pwc_vb_queue_ops;
>  	pdev->vb_queue.mem_ops = &vb2_vmalloc_memops;
> -	pdev->vb_queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	pdev->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	rc = vb2_queue_init(&pdev->vb_queue);
>  	if (rc < 0) {
>  		PWC_ERROR("Oops, could not initialize vb2 queue.\n");
> diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
> index c45c988..37bc00f 100644
> --- a/drivers/media/usb/stk1160/stk1160-v4l.c
> +++ b/drivers/media/usb/stk1160/stk1160-v4l.c
> @@ -641,7 +641,7 @@ int stk1160_vb2_setup(struct stk1160 *dev)
>  	q->buf_struct_size = sizeof(struct stk1160_buffer);
>  	q->ops = &stk1160_video_qops;
>  	q->mem_ops = &vb2_vmalloc_memops;
> -	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  
>  	rc = vb2_queue_init(q);
>  	if (rc < 0)
> diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
> index 496bc2e..01ed1ec8 100644
> --- a/drivers/media/usb/usbtv/usbtv-video.c
> +++ b/drivers/media/usb/usbtv/usbtv-video.c
> @@ -679,7 +679,7 @@ int usbtv_video_init(struct usbtv *usbtv)
>  	usbtv->vb2q.buf_struct_size = sizeof(struct usbtv_buf);
>  	usbtv->vb2q.ops = &usbtv_vb2_ops;
>  	usbtv->vb2q.mem_ops = &vb2_vmalloc_memops;
> -	usbtv->vb2q.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	usbtv->vb2q.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	usbtv->vb2q.lock = &usbtv->vb2q_lock;
>  	ret = vb2_queue_init(&usbtv->vb2q);
>  	if (ret < 0) {
> diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
> index ff7be97..7c14616 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -151,7 +151,7 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
>  	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
>  	queue->queue.ops = &uvc_queue_qops;
>  	queue->queue.mem_ops = &vb2_vmalloc_memops;
> -	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	ret = vb2_queue_init(&queue->queue);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index edab3af..411429c 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -488,7 +488,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  	 * Clear any buffer state related flags.
>  	 */
>  	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
> -	b->flags |= q->timestamp_type;
> +	b->flags |= q->timestamp_flags;
>  
>  	switch (vb->state) {
>  	case VB2_BUF_STATE_QUEUED:
> @@ -1473,7 +1473,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  		 * For output buffers copy the timestamp if needed,
>  		 * and the timecode field and flag if needed.
>  		 */
> -		if (q->timestamp_type == V4L2_BUF_FLAG_TIMESTAMP_COPY)
> +		if (q->timestamp_flags == V4L2_BUF_FLAG_TIMESTAMP_COPY)
>  			vb->v4l2_buf.timestamp = b->timestamp;
>  		vb->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
>  		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
> @@ -2226,11 +2226,11 @@ int vb2_queue_init(struct vb2_queue *q)
>  	    WARN_ON(!q->io_modes)	  ||
>  	    WARN_ON(!q->ops->queue_setup) ||
>  	    WARN_ON(!q->ops->buf_queue)   ||
> -	    WARN_ON(q->timestamp_type & ~V4L2_BUF_FLAG_TIMESTAMP_MASK))
> +	    WARN_ON(q->timestamp_flags & ~V4L2_BUF_FLAG_TIMESTAMP_MASK))
>  		return -EINVAL;
>  
>  	/* Warn that the driver should choose an appropriate timestamp type */
> -	WARN_ON(q->timestamp_type == V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
> +	WARN_ON(q->timestamp_flags == V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
>  
>  	INIT_LIST_HEAD(&q->queued_list);
>  	INIT_LIST_HEAD(&q->done_list);
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index bef53ce..3770be6 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -342,7 +342,7 @@ struct vb2_queue {
>  	const struct vb2_mem_ops	*mem_ops;
>  	void				*drv_priv;
>  	unsigned int			buf_struct_size;
> -	u32				timestamp_type;
> +	u32				timestamp_flags;
>  	gfp_t				gfp_flags;
>  
>  /* private: internal use only */
> 
