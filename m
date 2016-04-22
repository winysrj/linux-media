Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:41962 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753874AbcDVIzA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 04:55:00 -0400
Message-ID: <1461315299.4047.20.camel@pengutronix.de>
Subject: Re: [PATCHv3 06/12] media/platform: convert drivers to use the new
 vb2_queue dev field
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Date: Fri, 22 Apr 2016 10:54:59 +0200
In-Reply-To: <1461314299-36126-7-git-send-email-hverkuil@xs4all.nl>
References: <1461314299-36126-1-git-send-email-hverkuil@xs4all.nl>
	 <1461314299-36126-7-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 22.04.2016, 10:38 +0200 schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Stop using alloc_ctx and just fill in the device pointer.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>

coda-wise
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

> ---
>  drivers/media/platform/am437x/am437x-vpfe.c    | 10 +---------
>  drivers/media/platform/am437x/am437x-vpfe.h    |  2 --
>  drivers/media/platform/blackfin/bfin_capture.c | 15 ++-------------
>  drivers/media/platform/coda/coda-common.c      | 16 ++--------------
>  drivers/media/platform/coda/coda.h             |  1 -
>  drivers/media/platform/davinci/vpbe_display.c  | 12 +-----------
>  drivers/media/platform/davinci/vpif_capture.c  | 11 +----------
>  drivers/media/platform/davinci/vpif_capture.h  |  2 --
>  drivers/media/platform/davinci/vpif_display.c  | 11 +----------
>  drivers/media/platform/davinci/vpif_display.h  |  2 --
>  include/media/davinci/vpbe_display.h           |  2 --
>  11 files changed, 8 insertions(+), 76 deletions(-)
[...]
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 133ab9f..3d57c35 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1151,9 +1151,6 @@ static int coda_queue_setup(struct vb2_queue *vq,
>  	*nplanes = 1;
>  	sizes[0] = size;
>  
> -	/* Set to vb2-dma-contig allocator context, ignored by vb2-vmalloc */
> -	alloc_ctxs[0] = ctx->dev->alloc_ctx;
> -
>  	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>  		 "get %d buffer(s) of size %d each.\n", *nbuffers, size);
>  
> @@ -1599,6 +1596,7 @@ static int coda_queue_init(struct coda_ctx *ctx, struct vb2_queue *vq)
>  	 * that videobuf2 will keep the value of bytesused intact.
>  	 */
>  	vq->allow_zero_bytesused = 1;
> +	vq->dev = &ctx->dev->plat_dev->dev;
>  
>  	return vb2_queue_init(vq);
>  }
> @@ -2040,16 +2038,10 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
>  	if (ret < 0)
>  		goto put_pm;
>  
> -	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> -	if (IS_ERR(dev->alloc_ctx)) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
> -		goto put_pm;
> -	}
> -
>  	dev->m2m_dev = v4l2_m2m_init(&coda_m2m_ops);
>  	if (IS_ERR(dev->m2m_dev)) {
>  		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
> -		goto rel_ctx;
> +		goto put_pm;
>  	}
>  
>  	for (i = 0; i < dev->devtype->num_vdevs; i++) {
> @@ -2072,8 +2064,6 @@ rel_vfd:
>  	while (--i >= 0)
>  		video_unregister_device(&dev->vfd[i]);
>  	v4l2_m2m_release(dev->m2m_dev);
> -rel_ctx:
> -	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>  put_pm:
>  	pm_runtime_put_sync(&pdev->dev);
>  }
> @@ -2324,8 +2314,6 @@ static int coda_remove(struct platform_device *pdev)
>  	if (dev->m2m_dev)
>  		v4l2_m2m_release(dev->m2m_dev);
>  	pm_runtime_disable(&pdev->dev);
> -	if (dev->alloc_ctx)
> -		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  	destroy_workqueue(dev->workqueue);
>  	if (dev->iram.vaddr)
> diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
> index 8f2c71e..53f9666 100644
> --- a/drivers/media/platform/coda/coda.h
> +++ b/drivers/media/platform/coda/coda.h
> @@ -92,7 +92,6 @@ struct coda_dev {
>  	struct mutex		coda_mutex;
>  	struct workqueue_struct	*workqueue;
>  	struct v4l2_m2m_dev	*m2m_dev;
> -	struct vb2_alloc_ctx	*alloc_ctx;
>  	struct list_head	instances;
>  	unsigned long		instance_mask;
>  	struct dentry		*debugfs_root;
[...]

regards
Philipp

