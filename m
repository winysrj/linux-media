Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:26951 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757440AbcGKDst (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 23:48:49 -0400
Message-ID: <1468208921.3725.21.camel@mtksdaap41>
Subject: Re: [PATCH 1/2] mtk-vcodec: convert driver to use the new vb2_queue
 dev field
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 11 Jul 2016 11:48:41 +0800
In-Reply-To: <1468005079-28636-2-git-send-email-hverkuil@xs4all.nl>
References: <1468005079-28636-1-git-send-email-hverkuil@xs4all.nl>
	 <1468005079-28636-2-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


reviewed-by: Tiffany Lin <tiffany.lin@mediatek.com>


May I know why and how we use struct device *alloc_devs[] in queue_setup
callback function?


best regards,
Tiffany

On Fri, 2016-07-08 at 21:11 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The patch dropping the vb2_dma_contig_init_ctx() and _cleanup_ctx()
> functions was already applied before this driver was added. So convert
> this driver as well.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h     |  3 ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c     | 13 ++++++-------
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c | 12 ------------
>  3 files changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> index 78eee50..94f0a42 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> @@ -265,8 +265,6 @@ struct mtk_vcodec_ctx {
>   * @m2m_dev_enc: m2m device for encoder.
>   * @plat_dev: platform device
>   * @vpu_plat_dev: mtk vpu platform device
> - * @alloc_ctx: VB2 allocator context
> - *	       (for allocations without kernel mapping).
>   * @ctx_list: list of struct mtk_vcodec_ctx
>   * @irqlock: protect data access by irq handler and work thread
>   * @curr_ctx: The context that is waiting for codec hardware
> @@ -299,7 +297,6 @@ struct mtk_vcodec_dev {
>  	struct v4l2_m2m_dev *m2m_dev_enc;
>  	struct platform_device *plat_dev;
>  	struct platform_device *vpu_plat_dev;
> -	struct vb2_alloc_ctx *alloc_ctx;
>  	struct list_head ctx_list;
>  	spinlock_t irqlock;
>  	struct mtk_vcodec_ctx *curr_ctx;
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> index 6e72d73..6dcae0a 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> @@ -693,7 +693,8 @@ const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
>  static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
>  				   unsigned int *nbuffers,
>  				   unsigned int *nplanes,
> -				   unsigned int sizes[], void *alloc_ctxs[])
> +				   unsigned int sizes[],
> +				   struct device *alloc_devs[])
>  {
>  	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vq);
>  	struct mtk_q_data *q_data;
> @@ -705,17 +706,13 @@ static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
>  		return -EINVAL;
>  
>  	if (*nplanes) {
> -		for (i = 0; i < *nplanes; i++) {
> +		for (i = 0; i < *nplanes; i++)
>  			if (sizes[i] < q_data->sizeimage[i])
>  				return -EINVAL;
> -			alloc_ctxs[i] = ctx->dev->alloc_ctx;
> -		}
>  	} else {
>  		*nplanes = q_data->fmt->num_planes;
> -		for (i = 0; i < *nplanes; i++) {
> +		for (i = 0; i < *nplanes; i++)
>  			sizes[i] = q_data->sizeimage[i];
> -			alloc_ctxs[i] = ctx->dev->alloc_ctx;
> -		}
>  	}
>  
>  	return 0;
> @@ -1249,6 +1246,7 @@ int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->mem_ops		= &vb2_dma_contig_memops;
>  	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	src_vq->lock		= &ctx->dev->dev_mutex;
> +	src_vq->dev		= &ctx->dev->plat_dev->dev;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -1262,6 +1260,7 @@ int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->mem_ops		= &vb2_dma_contig_memops;
>  	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	dst_vq->lock		= &ctx->dev->dev_mutex;
> +	dst_vq->dev		= &ctx->dev->plat_dev->dev;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> index 06105e9..9c10cc2 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> @@ -357,14 +357,6 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
>  	dev->vfd_enc = vfd_enc;
>  	platform_set_drvdata(pdev, dev);
>  
> -	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> -	if (IS_ERR((__force void *)dev->alloc_ctx)) {
> -		mtk_v4l2_err("Failed to alloc vb2 dma context 0");
> -		ret = PTR_ERR((__force void *)dev->alloc_ctx);
> -		dev->alloc_ctx = NULL;
> -		goto err_vb2_ctx_init;
> -	}
> -
>  	dev->m2m_dev_enc = v4l2_m2m_init(&mtk_venc_m2m_ops);
>  	if (IS_ERR((__force void *)dev->m2m_dev_enc)) {
>  		mtk_v4l2_err("Failed to init mem2mem enc device");
> @@ -401,8 +393,6 @@ err_enc_reg:
>  err_event_workq:
>  	v4l2_m2m_release(dev->m2m_dev_enc);
>  err_enc_mem_init:
> -	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> -err_vb2_ctx_init:
>  	video_unregister_device(vfd_enc);
>  err_enc_alloc:
>  	v4l2_device_unregister(&dev->v4l2_dev);
> @@ -426,8 +416,6 @@ static int mtk_vcodec_enc_remove(struct platform_device *pdev)
>  	destroy_workqueue(dev->encode_workqueue);
>  	if (dev->m2m_dev_enc)
>  		v4l2_m2m_release(dev->m2m_dev_enc);
> -	if (dev->alloc_ctx)
> -		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>  
>  	if (dev->vfd_enc)
>  		video_unregister_device(dev->vfd_enc);


