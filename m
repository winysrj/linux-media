Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38797 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab3AXMvQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 07:51:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, verkuil@xs4all.nl, m.szyprowski@samsung.com,
	pawel@osciak.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 3/3 v2] v4l: Set proper timestamp type in selected drivers which use videobuf2
Date: Thu, 24 Jan 2013 13:51:15 +0100
Message-ID: <1751468.SnZ1UQG0Bu@avalon>
In-Reply-To: <1359030907-9883-4-git-send-email-k.debski@samsung.com>
References: <1359030907-9883-1-git-send-email-k.debski@samsung.com> <1359030907-9883-4-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Thanks for the patch.

On Thursday 24 January 2013 13:35:07 Kamil Debski wrote:
> Set proper timestamp type in drivers that I am sure that use either
> MONOTONIC or COPY timestamps. Other drivers will correctly report
> UNKNOWN timestamp type instead of assuming that all drivers use monotonic
> timestamps.

I've replied to 2/3 before seeing this patch, sorry (although the reply is 
still valid from a bisection point of view).

Do you have a list of those other drivers using vb2 that will report an 
unknown timestamp type ?

> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/blackfin/bfin_capture.c     |    1 +
>  drivers/media/platform/davinci/vpbe_display.c      |    1 +
>  drivers/media/platform/davinci/vpif_capture.c      |    1 +
>  drivers/media/platform/davinci/vpif_display.c      |    1 +
>  drivers/media/platform/s3c-camif/camif-capture.c   |    1 +
>  drivers/media/platform/s5p-fimc/fimc-capture.c     |    1 +
>  drivers/media/platform/s5p-fimc/fimc-lite.c        |    1 +
>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 ++
>  drivers/media/platform/soc_camera/atmel-isi.c      |    1 +
>  drivers/media/platform/soc_camera/mx2_camera.c     |    1 +
>  drivers/media/platform/soc_camera/mx3_camera.c     |    1 +
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |    1 +
>  drivers/media/platform/vivi.c                      |    1 +
>  drivers/media/usb/pwc/pwc-if.c                     |    1 +
>  drivers/media/usb/stk1160/stk1160-v4l.c            |    1 +
>  drivers/media/usb/uvc/uvc_queue.c                  |    1 +
>  16 files changed, 17 insertions(+)
> 
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c
> b/drivers/media/platform/blackfin/bfin_capture.c index d422d3c..365d6ef
> 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -939,6 +939,7 @@ static int __devinit bcap_probe(struct platform_device
> *pdev) q->buf_struct_size = sizeof(struct bcap_buffer);
>  	q->ops = &bcap_video_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	vb2_queue_init(q);
> 
> diff --git a/drivers/media/platform/davinci/vpbe_display.c
> b/drivers/media/platform/davinci/vpbe_display.c index 2bfde79..fa03482
> 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -1405,6 +1405,7 @@ static int vpbe_display_reqbufs(struct file *file,
> void *priv, q->ops = &video_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct vpbe_disp_buffer);
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	ret = vb2_queue_init(q);
>  	if (ret) {
> diff --git a/drivers/media/platform/davinci/vpif_capture.c
> b/drivers/media/platform/davinci/vpif_capture.c index 5892d2b..1943e41
> 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1035,6 +1035,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
> q->ops = &video_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct vpif_cap_buffer);
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	ret = vb2_queue_init(q);
>  	if (ret) {
> diff --git a/drivers/media/platform/davinci/vpif_display.c
> b/drivers/media/platform/davinci/vpif_display.c index dd249c9..5477c2c
> 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -1001,6 +1001,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
> q->ops = &video_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct vpif_disp_buffer);
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	ret = vb2_queue_init(q);
>  	if (ret) {
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c
> b/drivers/media/platform/s3c-camif/camif-capture.c index a55793c..e91f350
> 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -1153,6 +1153,7 @@ int s3c_camif_register_video_node(struct camif_dev
> *camif, int idx) q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct camif_buffer);
>  	q->drv_priv = vp;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	ret = vb2_queue_init(q);
>  	if (ret)
> diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c
> b/drivers/media/platform/s5p-fimc/fimc-capture.c index ddd689b..02cfb2b
> 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-capture.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
> @@ -1747,6 +1747,7 @@ static int fimc_register_capture_device(struct
> fimc_dev *fimc, q->ops = &fimc_capture_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct fimc_vid_buffer);
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	ret = vb2_queue_init(q);
>  	if (ret)
> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c
> b/drivers/media/platform/s5p-fimc/fimc-lite.c index 1b309a7..39ea893 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-lite.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
> @@ -1251,6 +1251,7 @@ static int fimc_lite_subdev_registered(struct
> v4l2_subdev *sd) q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct flite_buffer);
>  	q->drv_priv = fimc;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	ret = vb2_queue_init(q);
>  	if (ret < 0)
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c index a527f85..30b4d15 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -807,6 +807,7 @@ static int s5p_mfc_open(struct file *file)
>  		goto err_queue_init;
>  	}
>  	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	ret = vb2_queue_init(q);
>  	if (ret) {
>  		mfc_err("Failed to initialize videobuf2 queue(capture)\n");
> @@ -828,6 +829,7 @@ static int s5p_mfc_open(struct file *file)
>  		goto err_queue_init;
>  	}
>  	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	ret = vb2_queue_init(q);
>  	if (ret) {
>  		mfc_err("Failed to initialize videobuf2 queue(output)\n");
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> b/drivers/media/platform/soc_camera/atmel-isi.c index c8d748a..e531b82
> 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -514,6 +514,7 @@ static int isi_camera_init_videobuf(struct vb2_queue *q,
> q->buf_struct_size = sizeof(struct frame_buffer);
>  	q->ops = &isi_video_qops;
>  	q->mem_ops = &vb2_dma_contig_memops;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	return vb2_queue_init(q);
>  }
> diff --git a/drivers/media/platform/soc_camera/mx2_camera.c
> b/drivers/media/platform/soc_camera/mx2_camera.c index 5fbac4f..5ff6a5d
> 100644
> --- a/drivers/media/platform/soc_camera/mx2_camera.c
> +++ b/drivers/media/platform/soc_camera/mx2_camera.c
> @@ -1022,6 +1022,7 @@ static int mx2_camera_init_videobuf(struct vb2_queue
> *q, q->ops = &mx2_videobuf_ops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct mx2_buffer);
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	return vb2_queue_init(q);
>  }
> diff --git a/drivers/media/platform/soc_camera/mx3_camera.c
> b/drivers/media/platform/soc_camera/mx3_camera.c index 574d125..abe9db6
> 100644
> --- a/drivers/media/platform/soc_camera/mx3_camera.c
> +++ b/drivers/media/platform/soc_camera/mx3_camera.c
> @@ -455,6 +455,7 @@ static int mx3_camera_init_videobuf(struct vb2_queue *q,
> q->ops = &mx3_videobuf_ops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct mx3_camera_buffer);
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	return vb2_queue_init(q);
>  }
> diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c index
> 8a6d58d..b6c1c97 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> @@ -2026,6 +2026,7 @@ static int sh_mobile_ceu_init_videobuf(struct
> vb2_queue *q, q->ops = &sh_mobile_ceu_videobuf_ops;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->buf_struct_size = sizeof(struct sh_mobile_ceu_buffer);
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	return vb2_queue_init(q);
>  }
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index c2f424f..86a5432 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -1305,6 +1305,7 @@ static int __init vivi_create_instance(int inst)
>  	q->buf_struct_size = sizeof(struct vivi_buffer);
>  	q->ops = &vivi_video_qops;
>  	q->mem_ops = &vb2_vmalloc_memops;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	ret = vb2_queue_init(q);
>  	if (ret)
> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> index 21c1523..1b65e0c 100644
> --- a/drivers/media/usb/pwc/pwc-if.c
> +++ b/drivers/media/usb/pwc/pwc-if.c
> @@ -1001,6 +1001,7 @@ static int usb_pwc_probe(struct usb_interface *intf,
> const struct usb_device_id pdev->vb_queue.buf_struct_size = sizeof(struct
> pwc_frame_buf);
>  	pdev->vb_queue.ops = &pwc_vb_queue_ops;
>  	pdev->vb_queue.mem_ops = &vb2_vmalloc_memops;
> +	pdev->vb_queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	rc = vb2_queue_init(&pdev->vb_queue);
>  	if (rc < 0) {
>  		PWC_ERROR("Oops, could not initialize vb2 queue.\n");
> diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c
> b/drivers/media/usb/stk1160/stk1160-v4l.c index 6694f9e..5307a63 100644
> --- a/drivers/media/usb/stk1160/stk1160-v4l.c
> +++ b/drivers/media/usb/stk1160/stk1160-v4l.c
> @@ -687,6 +687,7 @@ int stk1160_vb2_setup(struct stk1160 *dev)
>  	q->buf_struct_size = sizeof(struct stk1160_buffer);
>  	q->ops = &stk1160_video_qops;
>  	q->mem_ops = &vb2_vmalloc_memops;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
>  	rc = vb2_queue_init(q);
>  	if (rc < 0)
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index 778addc..82d01d8 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -133,6 +133,7 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum
> v4l2_buf_type type, queue->queue.buf_struct_size = sizeof(struct
> uvc_buffer);
>  	queue->queue.ops = &uvc_queue_qops;
>  	queue->queue.mem_ops = &vb2_vmalloc_memops;
> +	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	ret = vb2_queue_init(&queue->queue);
>  	if (ret)
>  		return ret;
-- 
Regards,

Laurent Pinchart

