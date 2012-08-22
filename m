Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2887 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab2HVLqN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 07:46:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv8 23/26] v4l: vb2: add support for DMA_ATTR_NO_KERNEL_MAPPING
Date: Wed, 22 Aug 2012 13:46:00 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de,
	dmitriyz@google.com, s.nawrocki@samsung.com, k.debski@samsung.com
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1344958496-9373-24-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1344958496-9373-24-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221346.00854.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue August 14 2012 17:34:53 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>

Please add some more information in the commit message. I've no idea what's
going on here or why :-)

Regards,

	Hans

> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/atmel-isi.c              |    2 +-
>  drivers/media/video/blackfin/bfin_capture.c  |    2 +-
>  drivers/media/video/marvell-ccic/mcam-core.c |    3 ++-
>  drivers/media/video/mx2_camera.c             |    2 +-
>  drivers/media/video/mx2_emmaprp.c            |    2 +-
>  drivers/media/video/mx3_camera.c             |    2 +-
>  drivers/media/video/s5p-fimc/fimc-core.c     |    2 +-
>  drivers/media/video/s5p-fimc/fimc-lite.c     |    2 +-
>  drivers/media/video/s5p-g2d/g2d.c            |    2 +-
>  drivers/media/video/s5p-jpeg/jpeg-core.c     |    2 +-
>  drivers/media/video/s5p-mfc/s5p_mfc.c        |    5 ++--
>  drivers/media/video/s5p-tv/mixer_video.c     |    2 +-
>  drivers/media/video/sh_mobile_ceu_camera.c   |    2 +-
>  drivers/media/video/videobuf2-dma-contig.c   |   33 +++++++++++++++++++-------
>  drivers/staging/media/dt3155v4l/dt3155v4l.c  |    2 +-
>  include/media/videobuf2-dma-contig.h         |    4 +++-
>  16 files changed, 44 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
> index 6274a91..9fb5283 100644
> --- a/drivers/media/video/atmel-isi.c
> +++ b/drivers/media/video/atmel-isi.c
> @@ -1000,7 +1000,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
>  		list_add(&isi->dma_desc[i].list, &isi->dma_desc_head);
>  	}
>  
> -	isi->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	isi->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev, 0);
>  	if (IS_ERR(isi->alloc_ctx)) {
>  		ret = PTR_ERR(isi->alloc_ctx);
>  		goto err_alloc_ctx;
> diff --git a/drivers/media/video/blackfin/bfin_capture.c b/drivers/media/video/blackfin/bfin_capture.c
> index 1677623..7e90b65 100644
> --- a/drivers/media/video/blackfin/bfin_capture.c
> +++ b/drivers/media/video/blackfin/bfin_capture.c
> @@ -893,7 +893,7 @@ static int __devinit bcap_probe(struct platform_device *pdev)
>  	}
>  	bcap_dev->ppi->priv = bcap_dev;
>  
> -	bcap_dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	bcap_dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev, 0);
>  	if (IS_ERR(bcap_dev->alloc_ctx)) {
>  		ret = PTR_ERR(bcap_dev->alloc_ctx);
>  		goto err_free_ppi;
> diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
> index ce2b7b4..10d4db5 100644
> --- a/drivers/media/video/marvell-ccic/mcam-core.c
> +++ b/drivers/media/video/marvell-ccic/mcam-core.c
> @@ -1111,7 +1111,8 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
>  #ifdef MCAM_MODE_DMA_CONTIG
>  		vq->ops = &mcam_vb2_ops;
>  		vq->mem_ops = &vb2_dma_contig_memops;
> -		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
> +		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev,
> +			VB2_CREATE_VADDR);
>  		vq->io_modes = VB2_MMAP | VB2_USERPTR;
>  		cam->dma_setup = mcam_ctlr_dma_contig;
>  		cam->frame_complete = mcam_dma_contig_done;
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 637bde8..5c30302 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -1766,7 +1766,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>  	if (cpu_is_mx25())
>  		pcdev->soc_host.capabilities = SOCAM_HOST_CAP_STRIDE;
>  
> -	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev, 0);
>  	if (IS_ERR(pcdev->alloc_ctx)) {
>  		err = PTR_ERR(pcdev->alloc_ctx);
>  		goto eallocctx;
> diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
> index 2810015..23c6c42 100644
> --- a/drivers/media/video/mx2_emmaprp.c
> +++ b/drivers/media/video/mx2_emmaprp.c
> @@ -962,7 +962,7 @@ static int emmaprp_probe(struct platform_device *pdev)
>  			     0, MEM2MEM_NAME, pcdev) < 0)
>  		goto rel_vdev;
>  
> -	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev, 0);
>  	if (IS_ERR(pcdev->alloc_ctx)) {
>  		v4l2_err(&pcdev->v4l2_dev, "Failed to alloc vb2 context\n");
>  		ret = PTR_ERR(pcdev->alloc_ctx);
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index f13643d..882026f 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -1227,7 +1227,7 @@ static int __devinit mx3_camera_probe(struct platform_device *pdev)
>  	soc_host->v4l2_dev.dev	= &pdev->dev;
>  	soc_host->nr		= pdev->id;
>  
> -	mx3_cam->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	mx3_cam->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev, 0);
>  	if (IS_ERR(mx3_cam->alloc_ctx)) {
>  		err = PTR_ERR(mx3_cam->alloc_ctx);
>  		goto eallocctx;
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
> index 1a44540..e1747f2 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -929,7 +929,7 @@ static int fimc_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto err_sd;
>  	/* Initialize contiguous memory allocator */
> -	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev, 0);
>  	if (IS_ERR(fimc->alloc_ctx)) {
>  		ret = PTR_ERR(fimc->alloc_ctx);
>  		goto err_pm;
> diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
> index c5b57e8..ccc70a0 100644
> --- a/drivers/media/video/s5p-fimc/fimc-lite.c
> +++ b/drivers/media/video/s5p-fimc/fimc-lite.c
> @@ -1459,7 +1459,7 @@ static int __devinit fimc_lite_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto err_sd;
>  
> -	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev, 0);
>  	if (IS_ERR(fimc->alloc_ctx)) {
>  		ret = PTR_ERR(fimc->alloc_ctx);
>  		goto err_pm;
> diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
> index 0edc2df..ad7837f 100644
> --- a/drivers/media/video/s5p-g2d/g2d.c
> +++ b/drivers/media/video/s5p-g2d/g2d.c
> @@ -756,7 +756,7 @@ static int g2d_probe(struct platform_device *pdev)
>  		goto put_clk_gate;
>  	}
>  
> -	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev, 0);
>  	if (IS_ERR(dev->alloc_ctx)) {
>  		ret = PTR_ERR(dev->alloc_ctx);
>  		goto unprep_clk_gate;
> diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
> index be04d58..900059e 100644
> --- a/drivers/media/video/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
> @@ -1372,7 +1372,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
>  		goto device_register_rollback;
>  	}
>  
> -	jpeg->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	jpeg->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev, VB2_CREATE_VADDR);
>  	if (IS_ERR(jpeg->alloc_ctx)) {
>  		v4l2_err(&jpeg->v4l2_dev, "Failed to init memory allocator\n");
>  		ret = PTR_ERR(jpeg->alloc_ctx);
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
> index e3e616d..9056a10 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
> @@ -1018,12 +1018,13 @@ static int s5p_mfc_probe(struct platform_device *pdev)
>  		goto err_res;
>  	}
>  
> -	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
> +	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l,
> +		VB2_CREATE_VADDR);
>  	if (IS_ERR_OR_NULL(dev->alloc_ctx[0])) {
>  		ret = PTR_ERR(dev->alloc_ctx[0]);
>  		goto err_res;
>  	}
> -	dev->alloc_ctx[1] = vb2_dma_contig_init_ctx(dev->mem_dev_r);
> +	dev->alloc_ctx[1] = vb2_dma_contig_init_ctx(dev->mem_dev_r, 0);
>  	if (IS_ERR_OR_NULL(dev->alloc_ctx[1])) {
>  		ret = PTR_ERR(dev->alloc_ctx[1]);
>  		goto err_mem_init_ctx_1;
> diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
> index da5b7a5..a7e3b53 100644
> --- a/drivers/media/video/s5p-tv/mixer_video.c
> +++ b/drivers/media/video/s5p-tv/mixer_video.c
> @@ -78,7 +78,7 @@ int __devinit mxr_acquire_video(struct mxr_device *mdev,
>  		goto fail;
>  	}
>  
> -	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
> +	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev, 0);
>  	if (IS_ERR_OR_NULL(mdev->alloc_ctx)) {
>  		mxr_err(mdev, "could not acquire vb2 allocator\n");
>  		goto fail_v4l2_dev;
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 0baaf94..e085c27 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -2158,7 +2158,7 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
>  	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
>  	pcdev->ici.capabilities = SOCAM_HOST_CAP_STRIDE;
>  
> -	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev, 0);
>  	if (IS_ERR(pcdev->alloc_ctx)) {
>  		err = PTR_ERR(pcdev->alloc_ctx);
>  		goto exit_free_clk;
> diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
> index 11f4a46..0729187 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -23,10 +23,12 @@
>  
>  struct vb2_dc_conf {
>  	struct device		*dev;
> +	unsigned int		flags;
>  };
>  
>  struct vb2_dc_buf {
>  	struct device			*dev;
> +	unsigned int			flags;
>  	void				*vaddr;
>  	unsigned long			size;
>  	dma_addr_t			dma_addr;
> @@ -34,6 +36,7 @@ struct vb2_dc_buf {
>  	struct sg_table			*dma_sgt;
>  
>  	/* MMAP related */
> +	struct dma_attrs		dma_attrs;
>  	struct vb2_vmarea_handler	handler;
>  	atomic_t			refcount;
>  	struct sg_table			*sgt_base;
> @@ -98,6 +101,9 @@ static void *vb2_dc_vaddr(void *buf_priv)
>  {
>  	struct vb2_dc_buf *buf = buf_priv;
>  
> +	if (WARN_ON(~buf->flags & VB2_CREATE_VADDR))
> +		return NULL;
> +
>  	return buf->vaddr;
>  }
>  
> @@ -147,7 +153,8 @@ static void vb2_dc_put(void *buf_priv)
>  		sg_free_table(buf->sgt_base);
>  		kfree(buf->sgt_base);
>  	}
> -	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
> +	dma_free_attrs(buf->dev, buf->size, buf->vaddr, buf->dma_addr,
> +		       &buf->dma_attrs);
>  	put_device(buf->dev);
>  	kfree(buf);
>  }
> @@ -165,7 +172,14 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
>  	/* prevent the device from release while the buffer is exported */
>  	get_device(dev);
>  
> -	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
> +	/* set up alloca attributes */
> +	init_dma_attrs(&buf->dma_attrs);
> +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &buf->dma_attrs);
> +	if (!(conf->flags & VB2_CREATE_VADDR))
> +		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &buf->dma_attrs);
> +
> +	buf->vaddr = dma_alloc_attrs(dev, size, &buf->dma_addr, GFP_KERNEL,
> +				     &buf->dma_attrs);
>  	if (!buf->vaddr) {
>  		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
>  		put_device(dev);
> @@ -174,6 +188,7 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
>  	}
>  
>  	buf->dev = dev;
> +	buf->flags = conf->flags;
>  	buf->size = size;
>  
>  	buf->handler.refcount = &buf->refcount;
> @@ -201,9 +216,8 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
>  	 */
>  	vma->vm_pgoff = 0;
>  
> -	ret = dma_mmap_coherent(buf->dev, vma, buf->vaddr,
> -		buf->dma_addr, buf->size);
> -
> +	ret = dma_mmap_attrs(buf->dev, vma, buf->vaddr, buf->dma_addr,
> +			     buf->size, &buf->dma_attrs);
>  	if (ret) {
>  		pr_err("Remapping memory failed, error: %d\n", ret);
>  		return ret;
> @@ -345,7 +359,7 @@ static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
>  {
>  	struct vb2_dc_buf *buf = dbuf->priv;
>  
> -	return buf->vaddr + pgnum * PAGE_SIZE;
> +	return buf->vaddr ? buf->vaddr + pgnum * PAGE_SIZE : NULL;
>  }
>  
>  static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
> @@ -385,8 +399,8 @@ static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
> -		buf->size);
> +	ret = dma_get_sgtable_attrs(buf->dev, sgt, buf->vaddr, buf->dma_addr,
> +		buf->size, &buf->dma_attrs);
>  	if (ret < 0) {
>  		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
>  		kfree(sgt);
> @@ -753,7 +767,7 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
>  };
>  EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
>  
> -void *vb2_dma_contig_init_ctx(struct device *dev)
> +void *vb2_dma_contig_init_ctx(struct device *dev, unsigned int flags)
>  {
>  	struct vb2_dc_conf *conf;
>  
> @@ -762,6 +776,7 @@ void *vb2_dma_contig_init_ctx(struct device *dev)
>  		return ERR_PTR(-ENOMEM);
>  
>  	conf->dev = dev;
> +	conf->flags = flags;
>  
>  	return conf;
>  }
> diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> index 2e7b711..3fcf15a 100644
> --- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
> +++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> @@ -232,7 +232,7 @@ dt3155_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
>  	sizes[0] = img_width * img_height;
>  	if (pd->q->alloc_ctx[0])
>  		return 0;
> -	ret = vb2_dma_contig_init_ctx(&pd->pdev->dev);
> +	ret = vb2_dma_contig_init_ctx(&pd->pdev->dev, VB2_CREATE_VADDR);
>  	if (IS_ERR(ret))
>  		return PTR_ERR(ret);
>  	pd->q->alloc_ctx[0] = ret;
> diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
> index 8197f87..8bf4b29 100644
> --- a/include/media/videobuf2-dma-contig.h
> +++ b/include/media/videobuf2-dma-contig.h
> @@ -24,7 +24,9 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>  	return *addr;
>  }
>  
> -void *vb2_dma_contig_init_ctx(struct device *dev);
> +#define VB2_CREATE_VADDR	(1 << 0)
> +
> +void *vb2_dma_contig_init_ctx(struct device *dev, unsigned int flags);
>  void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
>  
>  extern const struct vb2_mem_ops vb2_dma_contig_memops;
> 
