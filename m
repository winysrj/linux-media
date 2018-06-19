Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr680089.outbound.protection.outlook.com ([40.107.68.89]:63936
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756829AbeFSOr3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 10:47:29 -0400
Subject: Re: [PATCH 2/5] dma-buf: remove kmap_atomic interface
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
References: <20180601120020.11520-1-christian.koenig@amd.com>
 <20180601120020.11520-2-christian.koenig@amd.com>
 <20180618081845.GV3438@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <2bcb34c3-b729-e3ea-fb8c-2471e4ed56d6@amd.com>
Date: Tue, 19 Jun 2018 16:47:14 +0200
MIME-Version: 1.0
In-Reply-To: <20180618081845.GV3438@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.06.2018 um 10:18 schrieb Daniel Vetter:
> On Fri, Jun 01, 2018 at 02:00:17PM +0200, Christian König wrote:
>> Neither used nor correctly implemented anywhere. Just completely remove
>> the interface.
>>
>> Signed-off-by: Christian König <christian.koenig@amd.com>
> I wonder whether we can nuke the normal kmap stuff too ... everyone seems
> to want/use the vmap stuff for kernel-internal mapping needs.
>
> Anyway, this looks good.
>> ---
>>   drivers/dma-buf/dma-buf.c                          | 44 ----------------------
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c          |  2 -
>>   drivers/gpu/drm/armada/armada_gem.c                |  2 -
>>   drivers/gpu/drm/drm_prime.c                        | 26 -------------
>>   drivers/gpu/drm/i915/i915_gem_dmabuf.c             | 11 ------
>>   drivers/gpu/drm/i915/selftests/mock_dmabuf.c       |  2 -
>>   drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c          |  2 -
>>   drivers/gpu/drm/tegra/gem.c                        | 14 -------
>>   drivers/gpu/drm/udl/udl_dmabuf.c                   | 17 ---------
>>   drivers/gpu/drm/vmwgfx/vmwgfx_prime.c              | 13 -------
>>   .../media/common/videobuf2/videobuf2-dma-contig.c  |  1 -
>>   drivers/media/common/videobuf2/videobuf2-dma-sg.c  |  1 -
>>   drivers/media/common/videobuf2/videobuf2-vmalloc.c |  1 -
>>   drivers/staging/android/ion/ion.c                  |  2 -
>>   drivers/tee/tee_shm.c                              |  6 ---
>>   include/drm/drm_prime.h                            |  4 --
>>   include/linux/dma-buf.h                            |  4 --
>>   17 files changed, 152 deletions(-)
>>
>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>> index e99a8d19991b..e4c657d9fad7 100644
>> --- a/drivers/dma-buf/dma-buf.c
>> +++ b/drivers/dma-buf/dma-buf.c
>> @@ -405,7 +405,6 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>>   			  || !exp_info->ops->map_dma_buf
>>   			  || !exp_info->ops->unmap_dma_buf
>>   			  || !exp_info->ops->release
>> -			  || !exp_info->ops->map_atomic
>>   			  || !exp_info->ops->map
>>   			  || !exp_info->ops->mmap)) {
>>   		return ERR_PTR(-EINVAL);
>> @@ -687,14 +686,6 @@ EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
>>    *      void \*dma_buf_kmap(struct dma_buf \*, unsigned long);
>>    *      void dma_buf_kunmap(struct dma_buf \*, unsigned long, void \*);
>>    *
>> - *   There are also atomic variants of these interfaces. Like for kmap they
>> - *   facilitate non-blocking fast-paths. Neither the importer nor the exporter
>> - *   (in the callback) is allowed to block when using these.
>> - *
>> - *   Interfaces::
>> - *      void \*dma_buf_kmap_atomic(struct dma_buf \*, unsigned long);
>> - *      void dma_buf_kunmap_atomic(struct dma_buf \*, unsigned long, void \*);
>> - *
>>    *   For importers all the restrictions of using kmap apply, like the limited
>>    *   supply of kmap_atomic slots. Hence an importer shall only hold onto at
>>    *   max 2 atomic dma_buf kmaps at the same time (in any given process context).
> This is also about atomic kmap ...
>
> And the subsequent language around "Note that these calls need to always
> succeed." is also not true, might be good to update that stating that kmap
> is optional (like we say already for vmap).
>
> With those docs nits addressed:
>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I've fixed up patch #1 and #2 and added your Reviewed-by tag.

Since I finally had time to install dim do you have any objections that 
I now run "dim push drm-misc-next" with those two applied?

Regards,
Christian.

>
>> @@ -859,41 +850,6 @@ int dma_buf_end_cpu_access(struct dma_buf *dmabuf,
>>   }
>>   EXPORT_SYMBOL_GPL(dma_buf_end_cpu_access);
>>   
>> -/**
>> - * dma_buf_kmap_atomic - Map a page of the buffer object into kernel address
>> - * space. The same restrictions as for kmap_atomic and friends apply.
>> - * @dmabuf:	[in]	buffer to map page from.
>> - * @page_num:	[in]	page in PAGE_SIZE units to map.
>> - *
>> - * This call must always succeed, any necessary preparations that might fail
>> - * need to be done in begin_cpu_access.
>> - */
>> -void *dma_buf_kmap_atomic(struct dma_buf *dmabuf, unsigned long page_num)
>> -{
>> -	WARN_ON(!dmabuf);
>> -
>> -	return dmabuf->ops->map_atomic(dmabuf, page_num);
>> -}
>> -EXPORT_SYMBOL_GPL(dma_buf_kmap_atomic);
>> -
>> -/**
>> - * dma_buf_kunmap_atomic - Unmap a page obtained by dma_buf_kmap_atomic.
>> - * @dmabuf:	[in]	buffer to unmap page from.
>> - * @page_num:	[in]	page in PAGE_SIZE units to unmap.
>> - * @vaddr:	[in]	kernel space pointer obtained from dma_buf_kmap_atomic.
>> - *
>> - * This call must always succeed.
>> - */
>> -void dma_buf_kunmap_atomic(struct dma_buf *dmabuf, unsigned long page_num,
>> -			   void *vaddr)
>> -{
>> -	WARN_ON(!dmabuf);
>> -
>> -	if (dmabuf->ops->unmap_atomic)
>> -		dmabuf->ops->unmap_atomic(dmabuf, page_num, vaddr);
>> -}
>> -EXPORT_SYMBOL_GPL(dma_buf_kunmap_atomic);
>> -
>>   /**
>>    * dma_buf_kmap - Map a page of the buffer object into kernel address space. The
>>    * same restrictions as for kmap and friends apply.
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
>> index f1500f1ec0f5..a156b3891a3f 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
>> @@ -244,9 +244,7 @@ static const struct dma_buf_ops amdgpu_dmabuf_ops = {
>>   	.release = drm_gem_dmabuf_release,
>>   	.begin_cpu_access = amdgpu_gem_begin_cpu_access,
>>   	.map = drm_gem_dmabuf_kmap,
>> -	.map_atomic = drm_gem_dmabuf_kmap_atomic,
>>   	.unmap = drm_gem_dmabuf_kunmap,
>> -	.unmap_atomic = drm_gem_dmabuf_kunmap_atomic,
>>   	.mmap = drm_gem_dmabuf_mmap,
>>   	.vmap = drm_gem_dmabuf_vmap,
>>   	.vunmap = drm_gem_dmabuf_vunmap,
>> diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
>> index a97f509743a5..3fb37c75c065 100644
>> --- a/drivers/gpu/drm/armada/armada_gem.c
>> +++ b/drivers/gpu/drm/armada/armada_gem.c
>> @@ -490,8 +490,6 @@ static const struct dma_buf_ops armada_gem_prime_dmabuf_ops = {
>>   	.map_dma_buf	= armada_gem_prime_map_dma_buf,
>>   	.unmap_dma_buf	= armada_gem_prime_unmap_dma_buf,
>>   	.release	= drm_gem_dmabuf_release,
>> -	.map_atomic	= armada_gem_dmabuf_no_kmap,
>> -	.unmap_atomic	= armada_gem_dmabuf_no_kunmap,
>>   	.map		= armada_gem_dmabuf_no_kmap,
>>   	.unmap		= armada_gem_dmabuf_no_kunmap,
>>   	.mmap		= armada_gem_dmabuf_mmap,
>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
>> index 4a3a232fea67..b28fa8f44c8b 100644
>> --- a/drivers/gpu/drm/drm_prime.c
>> +++ b/drivers/gpu/drm/drm_prime.c
>> @@ -426,30 +426,6 @@ void drm_gem_dmabuf_vunmap(struct dma_buf *dma_buf, void *vaddr)
>>   }
>>   EXPORT_SYMBOL(drm_gem_dmabuf_vunmap);
>>   
>> -/**
>> - * drm_gem_dmabuf_kmap_atomic - map_atomic implementation for GEM
>> - *
>> - * Not implemented. This can be used as the &dma_buf_ops.map_atomic callback.
>> - */
>> -void *drm_gem_dmabuf_kmap_atomic(struct dma_buf *dma_buf,
>> -				 unsigned long page_num)
>> -{
>> -	return NULL;
>> -}
>> -EXPORT_SYMBOL(drm_gem_dmabuf_kmap_atomic);
>> -
>> -/**
>> - * drm_gem_dmabuf_kunmap_atomic - unmap_atomic implementation for GEM
>> - *
>> - * Not implemented. This can be used as the &dma_buf_ops.unmap_atomic callback.
>> - */
>> -void drm_gem_dmabuf_kunmap_atomic(struct dma_buf *dma_buf,
>> -				  unsigned long page_num, void *addr)
>> -{
>> -
>> -}
>> -EXPORT_SYMBOL(drm_gem_dmabuf_kunmap_atomic);
>> -
>>   /**
>>    * drm_gem_dmabuf_kmap - map implementation for GEM
>>    *
>> @@ -502,9 +478,7 @@ static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
>>   	.unmap_dma_buf = drm_gem_unmap_dma_buf,
>>   	.release = drm_gem_dmabuf_release,
>>   	.map = drm_gem_dmabuf_kmap,
>> -	.map_atomic = drm_gem_dmabuf_kmap_atomic,
>>   	.unmap = drm_gem_dmabuf_kunmap,
>> -	.unmap_atomic = drm_gem_dmabuf_kunmap_atomic,
>>   	.mmap = drm_gem_dmabuf_mmap,
>>   	.vmap = drm_gem_dmabuf_vmap,
>>   	.vunmap = drm_gem_dmabuf_vunmap,
>> diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
>> index 69a7aec49e84..82e2ca17a441 100644
>> --- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
>> +++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
>> @@ -111,15 +111,6 @@ static void i915_gem_dmabuf_vunmap(struct dma_buf *dma_buf, void *vaddr)
>>   	i915_gem_object_unpin_map(obj);
>>   }
>>   
>> -static void *i915_gem_dmabuf_kmap_atomic(struct dma_buf *dma_buf, unsigned long page_num)
>> -{
>> -	return NULL;
>> -}
>> -
>> -static void i915_gem_dmabuf_kunmap_atomic(struct dma_buf *dma_buf, unsigned long page_num, void *addr)
>> -{
>> -
>> -}
>>   static void *i915_gem_dmabuf_kmap(struct dma_buf *dma_buf, unsigned long page_num)
>>   {
>>   	struct drm_i915_gem_object *obj = dma_buf_to_obj(dma_buf);
>> @@ -225,9 +216,7 @@ static const struct dma_buf_ops i915_dmabuf_ops =  {
>>   	.unmap_dma_buf = i915_gem_unmap_dma_buf,
>>   	.release = drm_gem_dmabuf_release,
>>   	.map = i915_gem_dmabuf_kmap,
>> -	.map_atomic = i915_gem_dmabuf_kmap_atomic,
>>   	.unmap = i915_gem_dmabuf_kunmap,
>> -	.unmap_atomic = i915_gem_dmabuf_kunmap_atomic,
>>   	.mmap = i915_gem_dmabuf_mmap,
>>   	.vmap = i915_gem_dmabuf_vmap,
>>   	.vunmap = i915_gem_dmabuf_vunmap,
>> diff --git a/drivers/gpu/drm/i915/selftests/mock_dmabuf.c b/drivers/gpu/drm/i915/selftests/mock_dmabuf.c
>> index 302f7d103635..f81fda8ea45e 100644
>> --- a/drivers/gpu/drm/i915/selftests/mock_dmabuf.c
>> +++ b/drivers/gpu/drm/i915/selftests/mock_dmabuf.c
>> @@ -130,9 +130,7 @@ static const struct dma_buf_ops mock_dmabuf_ops =  {
>>   	.unmap_dma_buf = mock_unmap_dma_buf,
>>   	.release = mock_dmabuf_release,
>>   	.map = mock_dmabuf_kmap,
>> -	.map_atomic = mock_dmabuf_kmap_atomic,
>>   	.unmap = mock_dmabuf_kunmap,
>> -	.unmap_atomic = mock_dmabuf_kunmap_atomic,
>>   	.mmap = mock_dmabuf_mmap,
>>   	.vmap = mock_dmabuf_vmap,
>>   	.vunmap = mock_dmabuf_vunmap,
>> diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
>> index 8e41d649e248..1a073f9b2834 100644
>> --- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
>> +++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
>> @@ -148,8 +148,6 @@ static const struct dma_buf_ops omap_dmabuf_ops = {
>>   	.release = drm_gem_dmabuf_release,
>>   	.begin_cpu_access = omap_gem_dmabuf_begin_cpu_access,
>>   	.end_cpu_access = omap_gem_dmabuf_end_cpu_access,
>> -	.map_atomic = omap_gem_dmabuf_kmap_atomic,
>> -	.unmap_atomic = omap_gem_dmabuf_kunmap_atomic,
>>   	.map = omap_gem_dmabuf_kmap,
>>   	.unmap = omap_gem_dmabuf_kunmap,
>>   	.mmap = omap_gem_dmabuf_mmap,
>> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
>> index 8b0b4ff64bb4..d7661702c11c 100644
>> --- a/drivers/gpu/drm/tegra/gem.c
>> +++ b/drivers/gpu/drm/tegra/gem.c
>> @@ -596,18 +596,6 @@ static int tegra_gem_prime_end_cpu_access(struct dma_buf *buf,
>>   	return 0;
>>   }
>>   
>> -static void *tegra_gem_prime_kmap_atomic(struct dma_buf *buf,
>> -					 unsigned long page)
>> -{
>> -	return NULL;
>> -}
>> -
>> -static void tegra_gem_prime_kunmap_atomic(struct dma_buf *buf,
>> -					  unsigned long page,
>> -					  void *addr)
>> -{
>> -}
>> -
>>   static void *tegra_gem_prime_kmap(struct dma_buf *buf, unsigned long page)
>>   {
>>   	return NULL;
>> @@ -648,8 +636,6 @@ static const struct dma_buf_ops tegra_gem_prime_dmabuf_ops = {
>>   	.release = tegra_gem_prime_release,
>>   	.begin_cpu_access = tegra_gem_prime_begin_cpu_access,
>>   	.end_cpu_access = tegra_gem_prime_end_cpu_access,
>> -	.map_atomic = tegra_gem_prime_kmap_atomic,
>> -	.unmap_atomic = tegra_gem_prime_kunmap_atomic,
>>   	.map = tegra_gem_prime_kmap,
>>   	.unmap = tegra_gem_prime_kunmap,
>>   	.mmap = tegra_gem_prime_mmap,
>> diff --git a/drivers/gpu/drm/udl/udl_dmabuf.c b/drivers/gpu/drm/udl/udl_dmabuf.c
>> index 5fdc8bdc2026..ae7225dedc30 100644
>> --- a/drivers/gpu/drm/udl/udl_dmabuf.c
>> +++ b/drivers/gpu/drm/udl/udl_dmabuf.c
>> @@ -156,27 +156,12 @@ static void *udl_dmabuf_kmap(struct dma_buf *dma_buf, unsigned long page_num)
>>   	return NULL;
>>   }
>>   
>> -static void *udl_dmabuf_kmap_atomic(struct dma_buf *dma_buf,
>> -				    unsigned long page_num)
>> -{
>> -	/* TODO */
>> -
>> -	return NULL;
>> -}
>> -
>>   static void udl_dmabuf_kunmap(struct dma_buf *dma_buf,
>>   			      unsigned long page_num, void *addr)
>>   {
>>   	/* TODO */
>>   }
>>   
>> -static void udl_dmabuf_kunmap_atomic(struct dma_buf *dma_buf,
>> -				     unsigned long page_num,
>> -				     void *addr)
>> -{
>> -	/* TODO */
>> -}
>> -
>>   static int udl_dmabuf_mmap(struct dma_buf *dma_buf,
>>   			   struct vm_area_struct *vma)
>>   {
>> @@ -191,9 +176,7 @@ static const struct dma_buf_ops udl_dmabuf_ops = {
>>   	.map_dma_buf		= udl_map_dma_buf,
>>   	.unmap_dma_buf		= udl_unmap_dma_buf,
>>   	.map			= udl_dmabuf_kmap,
>> -	.map_atomic		= udl_dmabuf_kmap_atomic,
>>   	.unmap			= udl_dmabuf_kunmap,
>> -	.unmap_atomic		= udl_dmabuf_kunmap_atomic,
>>   	.mmap			= udl_dmabuf_mmap,
>>   	.release		= drm_gem_dmabuf_release,
>>   };
>> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
>> index fbffb37ccf42..373bc6da2f84 100644
>> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
>> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
>> @@ -71,17 +71,6 @@ static void vmw_prime_dmabuf_vunmap(struct dma_buf *dma_buf, void *vaddr)
>>   {
>>   }
>>   
>> -static void *vmw_prime_dmabuf_kmap_atomic(struct dma_buf *dma_buf,
>> -		unsigned long page_num)
>> -{
>> -	return NULL;
>> -}
>> -
>> -static void vmw_prime_dmabuf_kunmap_atomic(struct dma_buf *dma_buf,
>> -		unsigned long page_num, void *addr)
>> -{
>> -
>> -}
>>   static void *vmw_prime_dmabuf_kmap(struct dma_buf *dma_buf,
>>   		unsigned long page_num)
>>   {
>> @@ -108,9 +97,7 @@ const struct dma_buf_ops vmw_prime_dmabuf_ops =  {
>>   	.unmap_dma_buf = vmw_prime_unmap_dma_buf,
>>   	.release = NULL,
>>   	.map = vmw_prime_dmabuf_kmap,
>> -	.map_atomic = vmw_prime_dmabuf_kmap_atomic,
>>   	.unmap = vmw_prime_dmabuf_kunmap,
>> -	.unmap_atomic = vmw_prime_dmabuf_kunmap_atomic,
>>   	.mmap = vmw_prime_dmabuf_mmap,
>>   	.vmap = vmw_prime_dmabuf_vmap,
>>   	.vunmap = vmw_prime_dmabuf_vunmap,
>> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
>> index 12d0072c52c2..aff0ab7bf83d 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
>> @@ -358,7 +358,6 @@ static const struct dma_buf_ops vb2_dc_dmabuf_ops = {
>>   	.map_dma_buf = vb2_dc_dmabuf_ops_map,
>>   	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
>>   	.map = vb2_dc_dmabuf_ops_kmap,
>> -	.map_atomic = vb2_dc_dmabuf_ops_kmap,
>>   	.vmap = vb2_dc_dmabuf_ops_vmap,
>>   	.mmap = vb2_dc_dmabuf_ops_mmap,
>>   	.release = vb2_dc_dmabuf_ops_release,
>> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
>> index cf94765e593f..015e737095cd 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
>> @@ -507,7 +507,6 @@ static const struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
>>   	.map_dma_buf = vb2_dma_sg_dmabuf_ops_map,
>>   	.unmap_dma_buf = vb2_dma_sg_dmabuf_ops_unmap,
>>   	.map = vb2_dma_sg_dmabuf_ops_kmap,
>> -	.map_atomic = vb2_dma_sg_dmabuf_ops_kmap,
>>   	.vmap = vb2_dma_sg_dmabuf_ops_vmap,
>>   	.mmap = vb2_dma_sg_dmabuf_ops_mmap,
>>   	.release = vb2_dma_sg_dmabuf_ops_release,
>> diff --git a/drivers/media/common/videobuf2/videobuf2-vmalloc.c b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
>> index 298ffb9ecdae..467a4005164b 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
>> @@ -346,7 +346,6 @@ static const struct dma_buf_ops vb2_vmalloc_dmabuf_ops = {
>>   	.map_dma_buf = vb2_vmalloc_dmabuf_ops_map,
>>   	.unmap_dma_buf = vb2_vmalloc_dmabuf_ops_unmap,
>>   	.map = vb2_vmalloc_dmabuf_ops_kmap,
>> -	.map_atomic = vb2_vmalloc_dmabuf_ops_kmap,
>>   	.vmap = vb2_vmalloc_dmabuf_ops_vmap,
>>   	.mmap = vb2_vmalloc_dmabuf_ops_mmap,
>>   	.release = vb2_vmalloc_dmabuf_ops_release,
>> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
>> index 57e0d8035b2e..a46219ff5e16 100644
>> --- a/drivers/staging/android/ion/ion.c
>> +++ b/drivers/staging/android/ion/ion.c
>> @@ -374,8 +374,6 @@ static const struct dma_buf_ops dma_buf_ops = {
>>   	.detach = ion_dma_buf_detatch,
>>   	.begin_cpu_access = ion_dma_buf_begin_cpu_access,
>>   	.end_cpu_access = ion_dma_buf_end_cpu_access,
>> -	.map_atomic = ion_dma_buf_kmap,
>> -	.unmap_atomic = ion_dma_buf_kunmap,
>>   	.map = ion_dma_buf_kmap,
>>   	.unmap = ion_dma_buf_kunmap,
>>   };
>> diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
>> index 556960a1bab3..df4a1553b78b 100644
>> --- a/drivers/tee/tee_shm.c
>> +++ b/drivers/tee/tee_shm.c
>> @@ -80,11 +80,6 @@ static void tee_shm_op_release(struct dma_buf *dmabuf)
>>   	tee_shm_release(shm);
>>   }
>>   
>> -static void *tee_shm_op_map_atomic(struct dma_buf *dmabuf, unsigned long pgnum)
>> -{
>> -	return NULL;
>> -}
>> -
>>   static void *tee_shm_op_map(struct dma_buf *dmabuf, unsigned long pgnum)
>>   {
>>   	return NULL;
>> @@ -107,7 +102,6 @@ static const struct dma_buf_ops tee_shm_dma_buf_ops = {
>>   	.map_dma_buf = tee_shm_op_map_dma_buf,
>>   	.unmap_dma_buf = tee_shm_op_unmap_dma_buf,
>>   	.release = tee_shm_op_release,
>> -	.map_atomic = tee_shm_op_map_atomic,
>>   	.map = tee_shm_op_map,
>>   	.mmap = tee_shm_op_mmap,
>>   };
>> diff --git a/include/drm/drm_prime.h b/include/drm/drm_prime.h
>> index ef338151cea8..d716d653b096 100644
>> --- a/include/drm/drm_prime.h
>> +++ b/include/drm/drm_prime.h
>> @@ -93,10 +93,6 @@ void drm_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
>>   			   enum dma_data_direction dir);
>>   void *drm_gem_dmabuf_vmap(struct dma_buf *dma_buf);
>>   void drm_gem_dmabuf_vunmap(struct dma_buf *dma_buf, void *vaddr);
>> -void *drm_gem_dmabuf_kmap_atomic(struct dma_buf *dma_buf,
>> -				 unsigned long page_num);
>> -void drm_gem_dmabuf_kunmap_atomic(struct dma_buf *dma_buf,
>> -				  unsigned long page_num, void *addr);
>>   void *drm_gem_dmabuf_kmap(struct dma_buf *dma_buf, unsigned long page_num);
>>   void drm_gem_dmabuf_kunmap(struct dma_buf *dma_buf, unsigned long page_num,
>>   			   void *addr);
>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>> index 346caf77937f..d17cadd76802 100644
>> --- a/include/linux/dma-buf.h
>> +++ b/include/linux/dma-buf.h
>> @@ -205,8 +205,6 @@ struct dma_buf_ops {
>>   	 * to be restarted.
>>   	 */
>>   	int (*end_cpu_access)(struct dma_buf *, enum dma_data_direction);
>> -	void *(*map_atomic)(struct dma_buf *, unsigned long);
>> -	void (*unmap_atomic)(struct dma_buf *, unsigned long, void *);
>>   	void *(*map)(struct dma_buf *, unsigned long);
>>   	void (*unmap)(struct dma_buf *, unsigned long, void *);
>>   
>> @@ -394,8 +392,6 @@ int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
>>   			     enum dma_data_direction dir);
>>   int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
>>   			   enum dma_data_direction dir);
>> -void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long);
>> -void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
>>   void *dma_buf_kmap(struct dma_buf *, unsigned long);
>>   void dma_buf_kunmap(struct dma_buf *, unsigned long, void *);
>>   
>> -- 
>> 2.14.1
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
