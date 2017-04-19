Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0053.outbound.protection.outlook.com ([104.47.33.53]:4512
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S967076AbdDSQx5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 12:53:57 -0400
Date: Wed, 19 Apr 2017 09:53:43 -0700
From: Sinclair Yeh <syeh@vmware.com>
To: Logan Gunthorpe <logang@deltatee.com>
CC: <linux-kernel@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Christoph Hellwig <hch@lst.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        VMware Graphics <linux-graphics-maintainer@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Riley Andrews <riandrews@android.com>
Subject: Re: [PATCH] dma-buf: Rename dma-ops to prevent conflict with
 kunmap_atomic macro
Message-ID: <20170419165342.GB69079@syeh-m02.local>
References: <1492561021-9533-1-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1492561021-9533-1-git-send-email-logang@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Minor nits, otherwise the vmwgfx part,
  Reviewed-by: Sinclair Yeh <syeh@vmware.com>

On Tue, Apr 18, 2017 at 06:17:00PM -0600, Logan Gunthorpe wrote:
> Seeing the kunmap_atomic dma_buf_op shares the same name with a macro
                                    s^

> in higmem.h, the former can be aliased if any dma-buf user includes
       h^
> that header.
> 
> I'm personally trying to include highmem.h inside scatterlist.h and this
> breaks the dma-buf code proper.
> 
> Christoph Hellwig suggested [1] renaming it and pushing this patch ASAP.
> 
> To maintain consistency I've renamed all four of kmap* and kunmap* to be
> map* and unmap*. (Even though only kmap_atomic presently conflicts.)
> 
> [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_lists_target-2Ddevel_msg15070.html&d=DwIBAg&c=uilaK90D4TOVoH58JNXRgQ&r=HaJ2a6NYExoV0cntAYcoqA&m=QP_jolGTC4ofBnHRnAs0tFIXHnVWaTT0AdMyCL9SM64&s=un2hxBL1283iOTtJeJnvyyvtAu1d5Imyh5Q7AzljrfQ&e= 
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  drivers/dma-buf/dma-buf.c                      | 16 ++++++++--------
>  drivers/gpu/drm/armada/armada_gem.c            |  8 ++++----
>  drivers/gpu/drm/drm_prime.c                    |  8 ++++----
>  drivers/gpu/drm/i915/i915_gem_dmabuf.c         |  8 ++++----
>  drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c      |  8 ++++----
>  drivers/gpu/drm/tegra/gem.c                    |  4 ++--
>  drivers/gpu/drm/udl/udl_dmabuf.c               |  8 ++++----
>  drivers/gpu/drm/vmwgfx/vmwgfx_prime.c          |  8 ++++----
>  drivers/media/v4l2-core/videobuf2-dma-contig.c |  4 ++--
>  drivers/media/v4l2-core/videobuf2-dma-sg.c     |  4 ++--
>  drivers/media/v4l2-core/videobuf2-vmalloc.c    |  4 ++--
>  drivers/staging/android/ion/ion.c              |  8 ++++----
>  include/linux/dma-buf.h                        | 22 +++++++++++-----------
>  13 files changed, 55 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 0007b79..7cc2bfe 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -405,8 +405,8 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>  			  || !exp_info->ops->map_dma_buf
>  			  || !exp_info->ops->unmap_dma_buf
>  			  || !exp_info->ops->release
> -			  || !exp_info->ops->kmap_atomic
> -			  || !exp_info->ops->kmap
> +			  || !exp_info->ops->map_atomic
> +			  || !exp_info->ops->map
>  			  || !exp_info->ops->mmap)) {
>  		return ERR_PTR(-EINVAL);
>  	}
> @@ -872,7 +872,7 @@ void *dma_buf_kmap_atomic(struct dma_buf *dmabuf, unsigned long page_num)
>  {
>  	WARN_ON(!dmabuf);
>  
> -	return dmabuf->ops->kmap_atomic(dmabuf, page_num);
> +	return dmabuf->ops->map_atomic(dmabuf, page_num);
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_kmap_atomic);
>  
> @@ -889,8 +889,8 @@ void dma_buf_kunmap_atomic(struct dma_buf *dmabuf, unsigned long page_num,
>  {
>  	WARN_ON(!dmabuf);
>  
> -	if (dmabuf->ops->kunmap_atomic)
> -		dmabuf->ops->kunmap_atomic(dmabuf, page_num, vaddr);
> +	if (dmabuf->ops->unmap_atomic)
> +		dmabuf->ops->unmap_atomic(dmabuf, page_num, vaddr);
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_kunmap_atomic);
>  
> @@ -907,7 +907,7 @@ void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned long page_num)
>  {
>  	WARN_ON(!dmabuf);
>  
> -	return dmabuf->ops->kmap(dmabuf, page_num);
> +	return dmabuf->ops->map(dmabuf, page_num);
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_kmap);
>  
> @@ -924,8 +924,8 @@ void dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long page_num,
>  {
>  	WARN_ON(!dmabuf);
>  
> -	if (dmabuf->ops->kunmap)
> -		dmabuf->ops->kunmap(dmabuf, page_num, vaddr);
> +	if (dmabuf->ops->unmap)
> +		dmabuf->ops->unmap(dmabuf, page_num, vaddr);
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_kunmap);
>  
> diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
> index 1597458..d6c2a5d 100644
> --- a/drivers/gpu/drm/armada/armada_gem.c
> +++ b/drivers/gpu/drm/armada/armada_gem.c
> @@ -529,10 +529,10 @@ static const struct dma_buf_ops armada_gem_prime_dmabuf_ops = {
>  	.map_dma_buf	= armada_gem_prime_map_dma_buf,
>  	.unmap_dma_buf	= armada_gem_prime_unmap_dma_buf,
>  	.release	= drm_gem_dmabuf_release,
> -	.kmap_atomic	= armada_gem_dmabuf_no_kmap,
> -	.kunmap_atomic	= armada_gem_dmabuf_no_kunmap,
> -	.kmap		= armada_gem_dmabuf_no_kmap,
> -	.kunmap		= armada_gem_dmabuf_no_kunmap,
> +	.map_atomic	= armada_gem_dmabuf_no_kmap,
> +	.unmap_atomic	= armada_gem_dmabuf_no_kunmap,
> +	.map		= armada_gem_dmabuf_no_kmap,
> +	.unmap		= armada_gem_dmabuf_no_kunmap,
>  	.mmap		= armada_gem_dmabuf_mmap,
>  };
>  
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 25aa455..48ffd25 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -402,10 +402,10 @@ static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
>  	.map_dma_buf = drm_gem_map_dma_buf,
>  	.unmap_dma_buf = drm_gem_unmap_dma_buf,
>  	.release = drm_gem_dmabuf_release,
> -	.kmap = drm_gem_dmabuf_kmap,
> -	.kmap_atomic = drm_gem_dmabuf_kmap_atomic,
> -	.kunmap = drm_gem_dmabuf_kunmap,
> -	.kunmap_atomic = drm_gem_dmabuf_kunmap_atomic,
> +	.map = drm_gem_dmabuf_kmap,
> +	.map_atomic = drm_gem_dmabuf_kmap_atomic,
> +	.unmap = drm_gem_dmabuf_kunmap,
> +	.unmap_atomic = drm_gem_dmabuf_kunmap_atomic,
>  	.mmap = drm_gem_dmabuf_mmap,
>  	.vmap = drm_gem_dmabuf_vmap,
>  	.vunmap = drm_gem_dmabuf_vunmap,
> diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> index 29bb801..6f3d674 100644
> --- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> +++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> @@ -200,10 +200,10 @@ static const struct dma_buf_ops i915_dmabuf_ops =  {
>  	.map_dma_buf = i915_gem_map_dma_buf,
>  	.unmap_dma_buf = i915_gem_unmap_dma_buf,
>  	.release = drm_gem_dmabuf_release,
> -	.kmap = i915_gem_dmabuf_kmap,
> -	.kmap_atomic = i915_gem_dmabuf_kmap_atomic,
> -	.kunmap = i915_gem_dmabuf_kunmap,
> -	.kunmap_atomic = i915_gem_dmabuf_kunmap_atomic,
> +	.map = i915_gem_dmabuf_kmap,
> +	.map_atomic = i915_gem_dmabuf_kmap_atomic,
> +	.unmap = i915_gem_dmabuf_kunmap,
> +	.unmap_atomic = i915_gem_dmabuf_kunmap_atomic,
>  	.mmap = i915_gem_dmabuf_mmap,
>  	.vmap = i915_gem_dmabuf_vmap,
>  	.vunmap = i915_gem_dmabuf_vunmap,
> diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> index ee5883f..0dbe030 100644
> --- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> +++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> @@ -160,10 +160,10 @@ static struct dma_buf_ops omap_dmabuf_ops = {
>  	.release = omap_gem_dmabuf_release,
>  	.begin_cpu_access = omap_gem_dmabuf_begin_cpu_access,
>  	.end_cpu_access = omap_gem_dmabuf_end_cpu_access,
> -	.kmap_atomic = omap_gem_dmabuf_kmap_atomic,
> -	.kunmap_atomic = omap_gem_dmabuf_kunmap_atomic,
> -	.kmap = omap_gem_dmabuf_kmap,
> -	.kunmap = omap_gem_dmabuf_kunmap,
> +	.map_atomic = omap_gem_dmabuf_kmap_atomic,
> +	.unmap_atomic = omap_gem_dmabuf_kunmap_atomic,
> +	.map = omap_gem_dmabuf_kmap,
> +	.unmap = omap_gem_dmabuf_kunmap,
>  	.mmap = omap_gem_dmabuf_mmap,
>  };
>  
> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
> index 17e62ec..1788b14 100644
> --- a/drivers/gpu/drm/tegra/gem.c
> +++ b/drivers/gpu/drm/tegra/gem.c
> @@ -112,8 +112,8 @@ static const struct host1x_bo_ops tegra_bo_ops = {
>  	.unpin = tegra_bo_unpin,
>  	.mmap = tegra_bo_mmap,
>  	.munmap = tegra_bo_munmap,
> -	.kmap = tegra_bo_kmap,
> -	.kunmap = tegra_bo_kunmap,
> +	.map = tegra_bo_kmap,
> +	.unmap = tegra_bo_kunmap,
>  };
>  
>  static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
> diff --git a/drivers/gpu/drm/udl/udl_dmabuf.c b/drivers/gpu/drm/udl/udl_dmabuf.c
> index ac90ffd..ed0e636 100644
> --- a/drivers/gpu/drm/udl/udl_dmabuf.c
> +++ b/drivers/gpu/drm/udl/udl_dmabuf.c
> @@ -191,10 +191,10 @@ static struct dma_buf_ops udl_dmabuf_ops = {
>  	.detach			= udl_detach_dma_buf,
>  	.map_dma_buf		= udl_map_dma_buf,
>  	.unmap_dma_buf		= udl_unmap_dma_buf,
> -	.kmap			= udl_dmabuf_kmap,
> -	.kmap_atomic		= udl_dmabuf_kmap_atomic,
> -	.kunmap			= udl_dmabuf_kunmap,
> -	.kunmap_atomic		= udl_dmabuf_kunmap_atomic,
> +	.map			= udl_dmabuf_kmap,
> +	.map_atomic		= udl_dmabuf_kmap_atomic,
> +	.unmap			= udl_dmabuf_kunmap,
> +	.unmap_atomic		= udl_dmabuf_kunmap_atomic,
>  	.mmap			= udl_dmabuf_mmap,
>  	.release		= drm_gem_dmabuf_release,
>  };
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
> index 31fe32d..0d42a46 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
> @@ -108,10 +108,10 @@ const struct dma_buf_ops vmw_prime_dmabuf_ops =  {
>  	.map_dma_buf = vmw_prime_map_dma_buf,
>  	.unmap_dma_buf = vmw_prime_unmap_dma_buf,
>  	.release = NULL,
> -	.kmap = vmw_prime_dmabuf_kmap,
> -	.kmap_atomic = vmw_prime_dmabuf_kmap_atomic,
> -	.kunmap = vmw_prime_dmabuf_kunmap,
> -	.kunmap_atomic = vmw_prime_dmabuf_kunmap_atomic,
> +	.map = vmw_prime_dmabuf_kmap,
> +	.map_atomic = vmw_prime_dmabuf_kmap_atomic,
> +	.unmap = vmw_prime_dmabuf_kunmap,
> +	.unmap_atomic = vmw_prime_dmabuf_kunmap_atomic,
>  	.mmap = vmw_prime_dmabuf_mmap,
>  	.vmap = vmw_prime_dmabuf_vmap,
>  	.vunmap = vmw_prime_dmabuf_vunmap,
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index fb6a177..2db0413 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -356,8 +356,8 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
>  	.detach = vb2_dc_dmabuf_ops_detach,
>  	.map_dma_buf = vb2_dc_dmabuf_ops_map,
>  	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
> -	.kmap = vb2_dc_dmabuf_ops_kmap,
> -	.kmap_atomic = vb2_dc_dmabuf_ops_kmap,
> +	.map = vb2_dc_dmabuf_ops_kmap,
> +	.map_atomic = vb2_dc_dmabuf_ops_kmap,
>  	.vmap = vb2_dc_dmabuf_ops_vmap,
>  	.mmap = vb2_dc_dmabuf_ops_mmap,
>  	.release = vb2_dc_dmabuf_ops_release,
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index ecff8f4..6fd1343 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -504,8 +504,8 @@ static struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
>  	.detach = vb2_dma_sg_dmabuf_ops_detach,
>  	.map_dma_buf = vb2_dma_sg_dmabuf_ops_map,
>  	.unmap_dma_buf = vb2_dma_sg_dmabuf_ops_unmap,
> -	.kmap = vb2_dma_sg_dmabuf_ops_kmap,
> -	.kmap_atomic = vb2_dma_sg_dmabuf_ops_kmap,
> +	.map = vb2_dma_sg_dmabuf_ops_kmap,
> +	.map_atomic = vb2_dma_sg_dmabuf_ops_kmap,
>  	.vmap = vb2_dma_sg_dmabuf_ops_vmap,
>  	.mmap = vb2_dma_sg_dmabuf_ops_mmap,
>  	.release = vb2_dma_sg_dmabuf_ops_release,
> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> index 3f77814..27d1db3 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -342,8 +342,8 @@ static struct dma_buf_ops vb2_vmalloc_dmabuf_ops = {
>  	.detach = vb2_vmalloc_dmabuf_ops_detach,
>  	.map_dma_buf = vb2_vmalloc_dmabuf_ops_map,
>  	.unmap_dma_buf = vb2_vmalloc_dmabuf_ops_unmap,
> -	.kmap = vb2_vmalloc_dmabuf_ops_kmap,
> -	.kmap_atomic = vb2_vmalloc_dmabuf_ops_kmap,
> +	.map = vb2_vmalloc_dmabuf_ops_kmap,
> +	.map_atomic = vb2_vmalloc_dmabuf_ops_kmap,
>  	.vmap = vb2_vmalloc_dmabuf_ops_vmap,
>  	.mmap = vb2_vmalloc_dmabuf_ops_mmap,
>  	.release = vb2_vmalloc_dmabuf_ops_release,
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index f45115f..95a7f16 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -1020,10 +1020,10 @@ static const struct dma_buf_ops dma_buf_ops = {
>  	.release = ion_dma_buf_release,
>  	.begin_cpu_access = ion_dma_buf_begin_cpu_access,
>  	.end_cpu_access = ion_dma_buf_end_cpu_access,
> -	.kmap_atomic = ion_dma_buf_kmap,
> -	.kunmap_atomic = ion_dma_buf_kunmap,
> -	.kmap = ion_dma_buf_kmap,
> -	.kunmap = ion_dma_buf_kunmap,
> +	.map_atomic = ion_dma_buf_kmap,
> +	.unmap_atomic = ion_dma_buf_kunmap,
> +	.map = ion_dma_buf_kmap,
> +	.unmap = ion_dma_buf_kunmap,
>  };
>  
>  struct dma_buf *ion_share_dma_buf(struct ion_client *client,
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index bfb3704..79f27d6 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -39,13 +39,13 @@ struct dma_buf_attachment;
>  
>  /**
>   * struct dma_buf_ops - operations possible on struct dma_buf
> - * @kmap_atomic: maps a page from the buffer into kernel address
> - * 		 space, users may not block until the subsequent unmap call.
> - * 		 This callback must not sleep.
> - * @kunmap_atomic: [optional] unmaps a atomically mapped page from the buffer.
> - * 		   This Callback must not sleep.
> - * @kmap: maps a page from the buffer into kernel address space.
> - * @kunmap: [optional] unmaps a page from the buffer.
> + * @map_atomic: maps a page from the buffer into kernel address
> + *		space, users may not block until the subsequent unmap call.
> + *		This callback must not sleep.
> + * @unmap_atomic: [optional] unmaps a atomically mapped page from the buffer.
> + *		  This Callback must not sleep.
> + * @map: maps a page from the buffer into kernel address space.
> + * @unmap: [optional] unmaps a page from the buffer.
>   * @vmap: [optional] creates a virtual mapping for the buffer into kernel
>   *	  address space. Same restrictions as for vmap and friends apply.
>   * @vunmap: [optional] unmaps a vmap from the buffer
> @@ -206,10 +206,10 @@ struct dma_buf_ops {
>  	 * to be restarted.
>  	 */
>  	int (*end_cpu_access)(struct dma_buf *, enum dma_data_direction);
> -	void *(*kmap_atomic)(struct dma_buf *, unsigned long);
> -	void (*kunmap_atomic)(struct dma_buf *, unsigned long, void *);
> -	void *(*kmap)(struct dma_buf *, unsigned long);
> -	void (*kunmap)(struct dma_buf *, unsigned long, void *);
> +	void *(*map_atomic)(struct dma_buf *, unsigned long);
> +	void (*unmap_atomic)(struct dma_buf *, unsigned long, void *);
> +	void *(*map)(struct dma_buf *, unsigned long);
> +	void (*unmap)(struct dma_buf *, unsigned long, void *);
>  
>  	/**
>  	 * @mmap:
> -- 
> 2.1.4
> 
