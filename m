Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47155 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab2HHNfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 09:35:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	Pawel Osciak <pawel@osciak.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerome Glisse <jglisse@redhat.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Landley <rob@landley.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rob Clark <rob@ti.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: add reference counting for exporter module
Date: Wed, 08 Aug 2012 15:35:47 +0200
Message-ID: <1404275.atroogfRqe@avalon>
In-Reply-To: <50223CC5.9060007@samsung.com>
References: <50223CC5.9060007@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Wednesday 08 August 2012 12:17:41 Tomasz Stanislawski wrote:
> This patch adds reference counting on a module that exports dma-buf and
> implements its operations. This prevents the module from being unloaded
> while DMABUF file is in use.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  Documentation/dma-buf-sharing.txt          |    3 ++-
>  drivers/base/dma-buf.c                     |   10 +++++++++-
>  drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
>  drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
>  drivers/gpu/drm/nouveau/nouveau_prime.c    |    1 +
>  drivers/gpu/drm/radeon/radeon_prime.c      |    1 +
>  drivers/staging/omapdrm/omap_gem_dmabuf.c  |    1 +
>  include/linux/dma-buf.h                    |    2 ++
>  8 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/dma-buf-sharing.txt
> b/Documentation/dma-buf-sharing.txt index ad86fb8..2613057 100644
> --- a/Documentation/dma-buf-sharing.txt
> +++ b/Documentation/dma-buf-sharing.txt
> @@ -49,7 +49,8 @@ The dma_buf buffer sharing API usage contains the
> following steps: The buffer exporter announces its wish to export a buffer.
> In this, it connects its own private buffer data, provides implementation
> for operations that can be performed on the exported dma_buf, and flags for
> the file
> -   associated with this buffer.
> +   associated with this buffer. The operations structure has owner field.
> +   You should initialize this to THIS_MODULE in most cases.
> 
>     Interface:
>        struct dma_buf *dma_buf_export(void *priv, struct dma_buf_ops *ops,
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index c30f3e1..d14b2f5 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -27,6 +27,7 @@
>  #include <linux/dma-buf.h>
>  #include <linux/anon_inodes.h>
>  #include <linux/export.h>
> +#include <linux/module.h>
> 
>  static inline int is_dma_buf_file(struct file *);
> 
> @@ -40,6 +41,7 @@ static int dma_buf_release(struct inode *inode, struct
> file *file) dmabuf = file->private_data;
> 
>  	dmabuf->ops->release(dmabuf);
> +	module_put(dmabuf->ops->owner);
>  	kfree(dmabuf);
>  	return 0;
>  }
> @@ -96,6 +98,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct
> dma_buf_ops *ops, struct file *file;
> 
>  	if (WARN_ON(!priv || !ops
> +			  || !ops->owner

THIS_MODULE is defined as ((struct module *)0) when the driver is built-in, 
this check should thus be removed.

>  			  || !ops->map_dma_buf
>  			  || !ops->unmap_dma_buf
>  			  || !ops->release
> 
> @@ -105,9 +108,14 @@ struct dma_buf *dma_buf_export(void *priv, const struct
> dma_buf_ops *ops, return ERR_PTR(-EINVAL);
>  	}
> 
> +	if (!try_module_get(ops->owner))
> +		return ERR_PTR(-ENOENT);
> +
>  	dmabuf = kzalloc(sizeof(struct dma_buf), GFP_KERNEL);
> -	if (dmabuf == NULL)
> +	if (dmabuf == NULL) {
> +		module_put(ops->owner);
>  		return ERR_PTR(-ENOMEM);
> +	}
> 
>  	dmabuf->priv = priv;
>  	dmabuf->ops = ops;
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
> b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c index 613bf8a..cf3bc6d 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
> @@ -164,6 +164,7 @@ static void exynos_gem_dmabuf_kunmap(struct dma_buf
> *dma_buf, }
> 
>  static struct dma_buf_ops exynos_dmabuf_ops = {
> +	.owner			= THIS_MODULE,
>  	.map_dma_buf		= exynos_gem_map_dma_buf,
>  	.unmap_dma_buf		= exynos_gem_unmap_dma_buf,
>  	.kmap			= exynos_gem_dmabuf_kmap,
> diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> b/drivers/gpu/drm/i915/i915_gem_dmabuf.c index aa308e1..07ff03b 100644
> --- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> +++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> @@ -152,6 +152,7 @@ static int i915_gem_dmabuf_mmap(struct dma_buf *dma_buf,
> struct vm_area_struct * }
> 
>  static const struct dma_buf_ops i915_dmabuf_ops =  {
> +	.owner = THIS_MODULE,
>  	.map_dma_buf = i915_gem_map_dma_buf,
>  	.unmap_dma_buf = i915_gem_unmap_dma_buf,
>  	.release = i915_gem_dmabuf_release,
> diff --git a/drivers/gpu/drm/nouveau/nouveau_prime.c
> b/drivers/gpu/drm/nouveau/nouveau_prime.c index a25cf2c..8605033 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_prime.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
> @@ -127,6 +127,7 @@ static void nouveau_gem_prime_vunmap(struct dma_buf
> *dma_buf, void *vaddr) }
> 
>  static const struct dma_buf_ops nouveau_dmabuf_ops =  {
> +	.owner = THIS_MODULE,
>  	.map_dma_buf = nouveau_gem_map_dma_buf,
>  	.unmap_dma_buf = nouveau_gem_unmap_dma_buf,
>  	.release = nouveau_gem_dmabuf_release,
> diff --git a/drivers/gpu/drm/radeon/radeon_prime.c
> b/drivers/gpu/drm/radeon/radeon_prime.c index 6bef46a..4061fd3 100644
> --- a/drivers/gpu/drm/radeon/radeon_prime.c
> +++ b/drivers/gpu/drm/radeon/radeon_prime.c
> @@ -127,6 +127,7 @@ static void radeon_gem_prime_vunmap(struct dma_buf
> *dma_buf, void *vaddr) mutex_unlock(&dev->struct_mutex);
>  }
>  const static struct dma_buf_ops radeon_dmabuf_ops =  {
> +	.owner = THIS_MODULE,
>  	.map_dma_buf = radeon_gem_map_dma_buf,
>  	.unmap_dma_buf = radeon_gem_unmap_dma_buf,
>  	.release = radeon_gem_dmabuf_release,
> diff --git a/drivers/staging/omapdrm/omap_gem_dmabuf.c
> b/drivers/staging/omapdrm/omap_gem_dmabuf.c index 42728e0..6a4dd67 100644
> --- a/drivers/staging/omapdrm/omap_gem_dmabuf.c
> +++ b/drivers/staging/omapdrm/omap_gem_dmabuf.c
> @@ -179,6 +179,7 @@ out_unlock:
>  }
> 
>  struct dma_buf_ops omap_dmabuf_ops = {
> +		.owner = THIS_MODULE,
>  		.map_dma_buf = omap_gem_map_dma_buf,
>  		.unmap_dma_buf = omap_gem_unmap_dma_buf,
>  		.release = omap_gem_dmabuf_release,
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index eb48f38..22953de 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -37,6 +37,7 @@ struct dma_buf_attachment;
> 
>  /**
>   * struct dma_buf_ops - operations possible on struct dma_buf
> + * @owner: the module that implements dma_buf operations
>   * @attach: [optional] allows different devices to 'attach' themselves to
> the *	    given buffer. It might return -EBUSY to signal that backing
> storage *	    is already allocated and incompatible with the requirements
> @@ -70,6 +71,7 @@ struct dma_buf_attachment;
>   * @vunmap: [optional] unmaps a vmap from the buffer
>   */
>  struct dma_buf_ops {
> +	struct module *owner;
>  	int (*attach)(struct dma_buf *, struct device *,
>  			struct dma_buf_attachment *);

-- 
Regards,

Laurent Pinchart

