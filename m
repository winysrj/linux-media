Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36231 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965150AbeFRI3B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 04:29:01 -0400
Received: by mail-wm0-f66.google.com with SMTP id v131-v6so13843392wma.1
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2018 01:29:01 -0700 (PDT)
Date: Mon, 18 Jun 2018 10:28:57 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?=
        <ckoenig.leichtzumerken@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH 5/5] drm/amdgpu: add independent DMA-buf export v3
Message-ID: <20180618082857.GY3438@phenom.ffwll.local>
References: <20180601120020.11520-1-christian.koenig@amd.com>
 <20180601120020.11520-5-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180601120020.11520-5-christian.koenig@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 01, 2018 at 02:00:20PM +0200, Christian K�nig wrote:
> The caching of SGT's done by the DRM code is actually quite harmful and
> should probably removed altogether in the long term.

Hm, why is it harmful? We've done it because it's expensive, and people
started screaming about the overhead ... hence the caching. Doing an
amdgpu copypasta seems like working around issues in shared code.
-Daniel

> 
> Start by providing a separate DMA-buf export implementation in amdgpu. This is
> also a prerequisite of unpinned DMA-buf handling.
> 
> v2: fix unintended recursion, remove debugging leftovers
> v3: split out from unpinned DMA-buf work
> 
> Signed-off-by: Christian K�nig <christian.koenig@amd.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu.h       |  1 -
>  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c   |  1 -
>  drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c | 73 ++++++++++++++-----------------
>  3 files changed, 32 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
> index 2d7500921c0b..93dc57d74fc2 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
> @@ -373,7 +373,6 @@ int amdgpu_gem_object_open(struct drm_gem_object *obj,
>  void amdgpu_gem_object_close(struct drm_gem_object *obj,
>  				struct drm_file *file_priv);
>  unsigned long amdgpu_gem_timeout(uint64_t timeout_ns);
> -struct sg_table *amdgpu_gem_prime_get_sg_table(struct drm_gem_object *obj);
>  struct drm_gem_object *
>  amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
>  				 struct dma_buf_attachment *attach,
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> index b0bf2f24da48..270b8ad927ea 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
> @@ -907,7 +907,6 @@ static struct drm_driver kms_driver = {
>  	.gem_prime_export = amdgpu_gem_prime_export,
>  	.gem_prime_import = amdgpu_gem_prime_import,
>  	.gem_prime_res_obj = amdgpu_gem_prime_res_obj,
> -	.gem_prime_get_sg_table = amdgpu_gem_prime_get_sg_table,
>  	.gem_prime_import_sg_table = amdgpu_gem_prime_import_sg_table,
>  	.gem_prime_vmap = amdgpu_gem_prime_vmap,
>  	.gem_prime_vunmap = amdgpu_gem_prime_vunmap,
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
> index a156b3891a3f..0c5a75b06648 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
> @@ -32,14 +32,6 @@
>  
>  static const struct dma_buf_ops amdgpu_dmabuf_ops;
>  
> -struct sg_table *amdgpu_gem_prime_get_sg_table(struct drm_gem_object *obj)
> -{
> -	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
> -	int npages = bo->tbo.num_pages;
> -
> -	return drm_prime_pages_to_sg(bo->tbo.ttm->pages, npages);
> -}
> -
>  void *amdgpu_gem_prime_vmap(struct drm_gem_object *obj)
>  {
>  	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
> @@ -132,23 +124,17 @@ amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
>  	return ERR_PTR(ret);
>  }
>  
> -static int amdgpu_gem_map_attach(struct dma_buf *dma_buf,
> -				 struct dma_buf_attachment *attach)
> +static struct sg_table *
> +amdgpu_gem_map_dma_buf(struct dma_buf_attachment *attach,
> +		       enum dma_data_direction dir)
>  {
> +	struct dma_buf *dma_buf = attach->dmabuf;
>  	struct drm_gem_object *obj = dma_buf->priv;
>  	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
>  	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
> +	struct sg_table *sgt;
>  	long r;
>  
> -	r = drm_gem_map_attach(dma_buf, attach);
> -	if (r)
> -		return r;
> -
> -	r = amdgpu_bo_reserve(bo, false);
> -	if (unlikely(r != 0))
> -		goto error_detach;
> -
> -
>  	if (attach->dev->driver != adev->dev->driver) {
>  		/*
>  		 * Wait for all shared fences to complete before we switch to future
> @@ -159,46 +145,53 @@ static int amdgpu_gem_map_attach(struct dma_buf *dma_buf,
>  							MAX_SCHEDULE_TIMEOUT);
>  		if (unlikely(r < 0)) {
>  			DRM_DEBUG_PRIME("Fence wait failed: %li\n", r);
> -			goto error_unreserve;
> +			return ERR_PTR(r);
>  		}
>  	}
>  
>  	/* pin buffer into GTT */
>  	r = amdgpu_bo_pin(bo, AMDGPU_GEM_DOMAIN_GTT, NULL);
>  	if (r)
> -		goto error_unreserve;
> +		return ERR_PTR(r);
> +
> +	sgt = drm_prime_pages_to_sg(bo->tbo.ttm->pages, bo->tbo.num_pages);
> +	if (IS_ERR(sgt))
> +		return sgt;
> +
> +	if (!dma_map_sg_attrs(attach->dev, sgt->sgl, sgt->nents, dir,
> +			      DMA_ATTR_SKIP_CPU_SYNC))
> +		goto error_free;
>  
>  	if (attach->dev->driver != adev->dev->driver)
>  		bo->prime_shared_count++;
>  
> -error_unreserve:
> -	amdgpu_bo_unreserve(bo);
> +	return sgt;
>  
> -error_detach:
> -	if (r)
> -		drm_gem_map_detach(dma_buf, attach);
> -	return r;
> +error_free:
> +	sg_free_table(sgt);
> +	kfree(sgt);
> +	return ERR_PTR(-ENOMEM);
>  }
>  
> -static void amdgpu_gem_map_detach(struct dma_buf *dma_buf,
> -				  struct dma_buf_attachment *attach)
> +static void amdgpu_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
> +				     struct sg_table *sgt,
> +				     enum dma_data_direction dir)
>  {
> +	struct dma_buf *dma_buf = attach->dmabuf;
>  	struct drm_gem_object *obj = dma_buf->priv;
>  	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
>  	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
> -	int ret = 0;
> -
> -	ret = amdgpu_bo_reserve(bo, true);
> -	if (unlikely(ret != 0))
> -		goto error;
>  
>  	amdgpu_bo_unpin(bo);
> +
>  	if (attach->dev->driver != adev->dev->driver && bo->prime_shared_count)
>  		bo->prime_shared_count--;
> -	amdgpu_bo_unreserve(bo);
>  
> -error:
> -	drm_gem_map_detach(dma_buf, attach);
> +	if (sgt) {
> +		dma_unmap_sg(attach->dev, sgt->sgl, sgt->nents, dir);
> +		sg_free_table(sgt);
> +		kfree(sgt);
> +	}
>  }
>  
>  struct reservation_object *amdgpu_gem_prime_res_obj(struct drm_gem_object *obj)
> @@ -237,10 +230,8 @@ static int amdgpu_gem_begin_cpu_access(struct dma_buf *dma_buf,
>  }
>  
>  static const struct dma_buf_ops amdgpu_dmabuf_ops = {
> -	.attach = amdgpu_gem_map_attach,
> -	.detach = amdgpu_gem_map_detach,
> -	.map_dma_buf = drm_gem_map_dma_buf,
> -	.unmap_dma_buf = drm_gem_unmap_dma_buf,
> +	.map_dma_buf = amdgpu_gem_map_dma_buf,
> +	.unmap_dma_buf = amdgpu_gem_unmap_dma_buf,
>  	.release = drm_gem_dmabuf_release,
>  	.begin_cpu_access = amdgpu_gem_begin_cpu_access,
>  	.map = drm_gem_dmabuf_kmap,
> -- 
> 2.14.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
