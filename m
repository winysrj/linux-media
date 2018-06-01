Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:42678 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbeFAMLz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 08:11:55 -0400
Received: by mail-wr0-f194.google.com with SMTP id w10-v6so36139779wrk.9
        for <linux-media@vger.kernel.org>; Fri, 01 Jun 2018 05:11:54 -0700 (PDT)
Subject: Re: [PATCH 1/5] dma_buf: remove device parameter from attach callback
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Cc: sumit.semwal@linaro.org
References: <20180601120020.11520-1-christian.koenig@amd.com>
Message-ID: <651a24e0-ac58-e5cb-d95f-c9a88bf552dc@gmail.com>
Date: Fri, 1 Jun 2018 14:11:52 +0200
MIME-Version: 1.0
In-Reply-To: <20180601120020.11520-1-christian.koenig@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, accidentally send this series without a cover letter.

This is a cleanup to the DMA-buf interface, which is also a prerequisite 
to unpinned DMA-buf operation.

Patch #1 and #2 just remove unused functionality and clean up callback 
parameters.

Patch #3 and #4 introduce taking the reservation lock during 
mapping/unmapping of DMA-bufs.

This introduces a common lock where both exporter as well as importer 
can then use in the future for unpinned DMA-buf operation.

This of course means that exporters should now not take this reservation 
lock manually any more. The DRM drivers don't seem to actually do that, 
but I'm not 100% sure about other implementations.

Patch #5 then makes use of the new lock to simplify the DMA-buf import 
handling in amdgpu.

Please review and or comment,
Christian.

Am 01.06.2018 um 14:00 schrieb Christian König:
> The device parameter is completely unused because it is available in the
> attachment structure as well.
>
> Signed-off-by: Christian König <christian.koenig@amd.com>
> ---
>   drivers/dma-buf/dma-buf.c                             | 2 +-
>   drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c             | 3 +--
>   drivers/gpu/drm/drm_prime.c                           | 3 +--
>   drivers/gpu/drm/udl/udl_dmabuf.c                      | 1 -
>   drivers/gpu/drm/vmwgfx/vmwgfx_prime.c                 | 1 -
>   drivers/media/common/videobuf2/videobuf2-dma-contig.c | 2 +-
>   drivers/media/common/videobuf2/videobuf2-dma-sg.c     | 2 +-
>   drivers/media/common/videobuf2/videobuf2-vmalloc.c    | 2 +-
>   include/drm/drm_prime.h                               | 2 +-
>   include/linux/dma-buf.h                               | 3 +--
>   10 files changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index d78d5fc173dc..e99a8d19991b 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -568,7 +568,7 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
>   	mutex_lock(&dmabuf->lock);
>   
>   	if (dmabuf->ops->attach) {
> -		ret = dmabuf->ops->attach(dmabuf, dev, attach);
> +		ret = dmabuf->ops->attach(dmabuf, attach);
>   		if (ret)
>   			goto err_attach;
>   	}
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
> index 4683626b065f..f1500f1ec0f5 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
> @@ -133,7 +133,6 @@ amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
>   }
>   
>   static int amdgpu_gem_map_attach(struct dma_buf *dma_buf,
> -				 struct device *target_dev,
>   				 struct dma_buf_attachment *attach)
>   {
>   	struct drm_gem_object *obj = dma_buf->priv;
> @@ -141,7 +140,7 @@ static int amdgpu_gem_map_attach(struct dma_buf *dma_buf,
>   	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
>   	long r;
>   
> -	r = drm_gem_map_attach(dma_buf, target_dev, attach);
> +	r = drm_gem_map_attach(dma_buf, attach);
>   	if (r)
>   		return r;
>   
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 7856a9b3f8a8..4a3a232fea67 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -186,7 +186,6 @@ static int drm_prime_lookup_buf_handle(struct drm_prime_file_private *prime_fpri
>   /**
>    * drm_gem_map_attach - dma_buf attach implementation for GEM
>    * @dma_buf: buffer to attach device to
> - * @target_dev: not used
>    * @attach: buffer attachment data
>    *
>    * Allocates &drm_prime_attachment and calls &drm_driver.gem_prime_pin for
> @@ -195,7 +194,7 @@ static int drm_prime_lookup_buf_handle(struct drm_prime_file_private *prime_fpri
>    *
>    * Returns 0 on success, negative error code on failure.
>    */
> -int drm_gem_map_attach(struct dma_buf *dma_buf, struct device *target_dev,
> +int drm_gem_map_attach(struct dma_buf *dma_buf,
>   		       struct dma_buf_attachment *attach)
>   {
>   	struct drm_prime_attachment *prime_attach;
> diff --git a/drivers/gpu/drm/udl/udl_dmabuf.c b/drivers/gpu/drm/udl/udl_dmabuf.c
> index 2867ed155ff6..5fdc8bdc2026 100644
> --- a/drivers/gpu/drm/udl/udl_dmabuf.c
> +++ b/drivers/gpu/drm/udl/udl_dmabuf.c
> @@ -29,7 +29,6 @@ struct udl_drm_dmabuf_attachment {
>   };
>   
>   static int udl_attach_dma_buf(struct dma_buf *dmabuf,
> -			      struct device *dev,
>   			      struct dma_buf_attachment *attach)
>   {
>   	struct udl_drm_dmabuf_attachment *udl_attach;
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
> index 0d42a46521fc..fbffb37ccf42 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
> @@ -40,7 +40,6 @@
>    */
>   
>   static int vmw_prime_map_attach(struct dma_buf *dma_buf,
> -				struct device *target_dev,
>   				struct dma_buf_attachment *attach)
>   {
>   	return -ENOSYS;
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> index f1178f6f434d..12d0072c52c2 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> @@ -222,7 +222,7 @@ struct vb2_dc_attachment {
>   	enum dma_data_direction dma_dir;
>   };
>   
> -static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
> +static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf,
>   	struct dma_buf_attachment *dbuf_attach)
>   {
>   	struct vb2_dc_attachment *attach;
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> index 753ed3138dcc..cf94765e593f 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> @@ -371,7 +371,7 @@ struct vb2_dma_sg_attachment {
>   	enum dma_data_direction dma_dir;
>   };
>   
> -static int vb2_dma_sg_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
> +static int vb2_dma_sg_dmabuf_ops_attach(struct dma_buf *dbuf,
>   	struct dma_buf_attachment *dbuf_attach)
>   {
>   	struct vb2_dma_sg_attachment *attach;
> diff --git a/drivers/media/common/videobuf2/videobuf2-vmalloc.c b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> index 3a7c80cd1a17..298ffb9ecdae 100644
> --- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> +++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> @@ -209,7 +209,7 @@ struct vb2_vmalloc_attachment {
>   	enum dma_data_direction dma_dir;
>   };
>   
> -static int vb2_vmalloc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
> +static int vb2_vmalloc_dmabuf_ops_attach(struct dma_buf *dbuf,
>   	struct dma_buf_attachment *dbuf_attach)
>   {
>   	struct vb2_vmalloc_attachment *attach;
> diff --git a/include/drm/drm_prime.h b/include/drm/drm_prime.h
> index 4d5f5d6cf6a6..ef338151cea8 100644
> --- a/include/drm/drm_prime.h
> +++ b/include/drm/drm_prime.h
> @@ -82,7 +82,7 @@ int drm_gem_prime_fd_to_handle(struct drm_device *dev,
>   struct dma_buf *drm_gem_dmabuf_export(struct drm_device *dev,
>   				      struct dma_buf_export_info *exp_info);
>   void drm_gem_dmabuf_release(struct dma_buf *dma_buf);
> -int drm_gem_map_attach(struct dma_buf *dma_buf, struct device *target_dev,
> +int drm_gem_map_attach(struct dma_buf *dma_buf,
>   		       struct dma_buf_attachment *attach);
>   void drm_gem_map_detach(struct dma_buf *dma_buf,
>   			struct dma_buf_attachment *attach);
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 085db2fee2d7..346caf77937f 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -77,8 +77,7 @@ struct dma_buf_ops {
>   	 * to signal that backing storage is already allocated and incompatible
>   	 * with the requirements of requesting device.
>   	 */
> -	int (*attach)(struct dma_buf *, struct device *,
> -		      struct dma_buf_attachment *);
> +	int (*attach)(struct dma_buf *, struct dma_buf_attachment *);
>   
>   	/**
>   	 * @detach:
