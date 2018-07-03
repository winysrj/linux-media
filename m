Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40216 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752215AbeGCLf3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 07:35:29 -0400
Received: by mail-wr0-f196.google.com with SMTP id t6-v6so1612800wrn.7
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 04:35:29 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 3/4] drm/amdgpu: add independent DMA-buf export v3
To: "Zhang, Jerry (Junwei)" <Jerry.Zhang@amd.com>, daniel@ffwll.ch,
        sumit.semwal@linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        intel-gfx@lists.freedesktop.org
References: <20180622141103.1787-1-christian.koenig@amd.com>
 <20180622141103.1787-4-christian.koenig@amd.com> <5B34B132.3060504@amd.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <5e0980eb-795b-b1af-2b79-f8116d5023a3@gmail.com>
Date: Tue, 3 Jul 2018 13:35:25 +0200
MIME-Version: 1.0
In-Reply-To: <5B34B132.3060504@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.06.2018 um 11:58 schrieb Zhang, Jerry (Junwei):
> On 06/22/2018 10:11 PM, Christian König wrote:
>> The caching of SGT's done by the DRM code is actually quite harmful and
>> should probably removed altogether in the long term.
>>
>> Start by providing a separate DMA-buf export implementation in 
>> amdgpu. This is
>> also a prerequisite of unpinned DMA-buf handling.
>>
>> v2: fix unintended recursion, remove debugging leftovers
>> v3: split out from unpinned DMA-buf work
>>
>> Signed-off-by: Christian König <christian.koenig@amd.com>
>> ---
>>   drivers/gpu/drm/amd/amdgpu/amdgpu.h       |  1 -
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c   |  1 -
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c | 94 
>> +++++++++++++------------------
>>   3 files changed, 39 insertions(+), 57 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h 
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
>> index d8e0cc08f9db..5e71af8dd3a7 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
>> @@ -373,7 +373,6 @@ int amdgpu_gem_object_open(struct drm_gem_object 
>> *obj,
>>   void amdgpu_gem_object_close(struct drm_gem_object *obj,
>>                   struct drm_file *file_priv);
>>   unsigned long amdgpu_gem_timeout(uint64_t timeout_ns);
>> -struct sg_table *amdgpu_gem_prime_get_sg_table(struct drm_gem_object 
>> *obj);
>>   struct drm_gem_object *
>>   amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
>>                    struct dma_buf_attachment *attach,
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c 
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
>> index a549483032b0..cdf0be85d361 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
>> @@ -919,7 +919,6 @@ static struct drm_driver kms_driver = {
>>       .gem_prime_export = amdgpu_gem_prime_export,
>>       .gem_prime_import = amdgpu_gem_prime_import,
>>       .gem_prime_res_obj = amdgpu_gem_prime_res_obj,
>> -    .gem_prime_get_sg_table = amdgpu_gem_prime_get_sg_table,
>
> I may miss some patches or important info.
>
> Even applied the series of patch, I still could find below code in 
> drm_gem_map_dma_buf().
> In this case, it will cause NULL pointer access. Please help me out of 
> here.
> {{{
> sgt = obj->dev->driver->gem_prime_get_sg_table(obj);
> }}}

Take a look at the change a bit further down.

>
> Jerry
>
>>       .gem_prime_import_sg_table = amdgpu_gem_prime_import_sg_table,
>>       .gem_prime_vmap = amdgpu_gem_prime_vmap,
>>       .gem_prime_vunmap = amdgpu_gem_prime_vunmap,
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c 
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
>> index b2286bc41aec..038a8c8488b7 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
>> @@ -40,22 +40,6 @@
>>
>>   static const struct dma_buf_ops amdgpu_dmabuf_ops;
>>
>> -/**
>> - * amdgpu_gem_prime_get_sg_table - &drm_driver.gem_prime_get_sg_table
>> - * implementation
>> - * @obj: GEM buffer object
>> - *
>> - * Returns:
>> - * A scatter/gather table for the pinned pages of the buffer 
>> object's memory.
>> - */
>> -struct sg_table *amdgpu_gem_prime_get_sg_table(struct drm_gem_object 
>> *obj)
>> -{
>> -    struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
>> -    int npages = bo->tbo.num_pages;
>> -
>> -    return drm_prime_pages_to_sg(bo->tbo.ttm->pages, npages);
>> -}
>> -
>>   /**
>>    * amdgpu_gem_prime_vmap - &dma_buf_ops.vmap implementation
>>    * @obj: GEM buffer object
>> @@ -189,35 +173,29 @@ amdgpu_gem_prime_import_sg_table(struct 
>> drm_device *dev,
>>   }
>>
>>   /**
>> - * amdgpu_gem_map_attach - &dma_buf_ops.attach implementation
>> - * @dma_buf: shared DMA buffer
>> - * @target_dev: target device
>> + * amdgpu_gem_map_dma_buf - &dma_buf_ops.map_dma_buf implementation
>>    * @attach: DMA-buf attachment
>> + * @dir: DMA direction
>>    *
>>    * Makes sure that the shared DMA buffer can be accessed by the 
>> target device.
>>    * For now, simply pins it to the GTT domain, where it should be 
>> accessible by
>>    * all DMA devices.
>>    *
>>    * Returns:
>> - * 0 on success or negative error code.
>> + * sg_table filled with the DMA addresses to use or ERR_PRT with 
>> negative error
>> + * code.
>>    */
>> -static int amdgpu_gem_map_attach(struct dma_buf *dma_buf,
>> -                 struct dma_buf_attachment *attach)
>> +static struct sg_table *
>> +amdgpu_gem_map_dma_buf(struct dma_buf_attachment *attach,
>> +               enum dma_data_direction dir)
>>   {
>> +    struct dma_buf *dma_buf = attach->dmabuf;
>>       struct drm_gem_object *obj = dma_buf->priv;
>>       struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
>>       struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
>> +    struct sg_table *sgt;
>>       long r;
>>
>> -    r = drm_gem_map_attach(dma_buf, attach);
>> -    if (r)
>> -        return r;
>> -
>> -    r = amdgpu_bo_reserve(bo, false);
>> -    if (unlikely(r != 0))
>> -        goto error_detach;
>> -
>> -
>>       if (attach->dev->driver != adev->dev->driver) {
>>           /*
>>            * Wait for all shared fences to complete before we switch 
>> to future
>> @@ -228,54 +206,62 @@ static int amdgpu_gem_map_attach(struct dma_buf 
>> *dma_buf,
>>                               MAX_SCHEDULE_TIMEOUT);
>>           if (unlikely(r < 0)) {
>>               DRM_DEBUG_PRIME("Fence wait failed: %li\n", r);
>> -            goto error_unreserve;
>> +            return ERR_PTR(r);
>>           }
>>       }
>>
>>       /* pin buffer into GTT */
>>       r = amdgpu_bo_pin(bo, AMDGPU_GEM_DOMAIN_GTT, NULL);
>>       if (r)
>> -        goto error_unreserve;
>> +        return ERR_PTR(r);
>> +
>> +    sgt = drm_prime_pages_to_sg(bo->tbo.ttm->pages, bo->tbo.num_pages);
>> +    if (IS_ERR(sgt))
>> +        return sgt;
>> +
>> +    if (!dma_map_sg_attrs(attach->dev, sgt->sgl, sgt->nents, dir,
>> +                  DMA_ATTR_SKIP_CPU_SYNC))
>> +        goto error_free;
>>
>>       if (attach->dev->driver != adev->dev->driver)
>>           bo->prime_shared_count++;
>>
>> -error_unreserve:
>> -    amdgpu_bo_unreserve(bo);
>> +    return sgt;
>>
>> -error_detach:
>> -    if (r)
>> -        drm_gem_map_detach(dma_buf, attach);
>> -    return r;
>> +error_free:
>> +    sg_free_table(sgt);
>> +    kfree(sgt);
>> +    return ERR_PTR(-ENOMEM);
>>   }
>>
>>   /**
>> - * amdgpu_gem_map_detach - &dma_buf_ops.detach implementation
>> - * @dma_buf: shared DMA buffer
>> + * amdgpu_gem_unmap_dma_buf - &dma_buf_ops.unmap_dma_buf implementation
>>    * @attach: DMA-buf attachment
>> + * @sgt: sg_table to unmap
>> + * @dir: DMA direction
>>    *
>>    * This is called when a shared DMA buffer no longer needs to be 
>> accessible by
>>    * the other device. For now, simply unpins the buffer from GTT.
>>    */
>> -static void amdgpu_gem_map_detach(struct dma_buf *dma_buf,
>> -                  struct dma_buf_attachment *attach)
>> +static void amdgpu_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
>> +                     struct sg_table *sgt,
>> +                     enum dma_data_direction dir)
>>   {
>> +    struct dma_buf *dma_buf = attach->dmabuf;
>>       struct drm_gem_object *obj = dma_buf->priv;
>>       struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
>>       struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
>> -    int ret = 0;
>> -
>> -    ret = amdgpu_bo_reserve(bo, true);
>> -    if (unlikely(ret != 0))
>> -        goto error;
>>
>>       amdgpu_bo_unpin(bo);
>> +
>>       if (attach->dev->driver != adev->dev->driver && 
>> bo->prime_shared_count)
>>           bo->prime_shared_count--;
>> -    amdgpu_bo_unreserve(bo);
>>
>> -error:
>> -    drm_gem_map_detach(dma_buf, attach);
>> +    if (sgt) {
>> +        dma_unmap_sg(attach->dev, sgt->sgl, sgt->nents, dir);
>> +        sg_free_table(sgt);
>> +        kfree(sgt);
>> +    }
>>   }
>>
>>   /**
>> @@ -333,10 +319,8 @@ static int amdgpu_gem_begin_cpu_access(struct 
>> dma_buf *dma_buf,
>>   }
>>
>>   static const struct dma_buf_ops amdgpu_dmabuf_ops = {
>> -    .attach = amdgpu_gem_map_attach,
>> -    .detach = amdgpu_gem_map_detach,
>> -    .map_dma_buf = drm_gem_map_dma_buf,
>> -    .unmap_dma_buf = drm_gem_unmap_dma_buf,

Here we are stopping to use drm_gem_map_dma_buf(), so we don't need 
amdgpu_gem_prime_get_sg_table() any more either.

Christian.

>> +    .map_dma_buf = amdgpu_gem_map_dma_buf,
>> +    .unmap_dma_buf = amdgpu_gem_unmap_dma_buf,
>>       .release = drm_gem_dmabuf_release,
>>       .begin_cpu_access = amdgpu_gem_begin_cpu_access,
>>       .map = drm_gem_dmabuf_kmap,
>>
