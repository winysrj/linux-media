Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:53079 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbeGCLqs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 07:46:48 -0400
Received: by mail-wm0-f68.google.com with SMTP id w16-v6so1993095wmc.2
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 04:46:47 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 2/4] dma-buf: lock the reservation object during
 (un)map_dma_buf v2
To: Daniel Vetter <daniel@ffwll.ch>
Cc: sumit.semwal@linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        intel-gfx@lists.freedesktop.org
References: <20180622141103.1787-1-christian.koenig@amd.com>
 <20180622141103.1787-3-christian.koenig@amd.com>
 <20180625082231.GM2958@phenom.ffwll.local>
 <20180625091217.GO2958@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <2ebff18b-414d-c971-1b7f-f6a21aacf196@gmail.com>
Date: Tue, 3 Jul 2018 13:46:44 +0200
MIME-Version: 1.0
In-Reply-To: <20180625091217.GO2958@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 25.06.2018 um 11:12 schrieb Daniel Vetter:
> On Mon, Jun 25, 2018 at 10:22:31AM +0200, Daniel Vetter wrote:
>> On Fri, Jun 22, 2018 at 04:11:01PM +0200, Christian König wrote:
>>> First step towards unpinned DMA buf operation.
>>>
>>> I've checked the DRM drivers to potential locking of the reservation
>>> object, but essentially we need to audit all implementations of the
>>> dma_buf _ops for this to work.
>>>
>>> v2: reordered
>>>
>>> Signed-off-by: Christian König <christian.koenig@amd.com>
>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Ok I did review drivers a bit, but apparently not well enough by far. i915
> CI is unhappy:
>
> https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_9400/fi-whl-u/igt@gem_mmap_gtt@basic-small-bo-tiledx.html
>
> So yeah inserting that lock in there isn't the most trivial thing :-/
>
> I kinda assume that other drivers will have similar issues, e.g. omapdrm's
> use of dev->struct_mutex also very much looks like it'll result in a new
> locking inversion.

Ah, crap. Already feared that this wouldn't be easy, but yeah that it is 
as bad as this is rather disappointing.

Thanks for the info, going to keep thinking about how to solve those issues.

Christian.

> -Daniel
>
>>> ---
>>>   drivers/dma-buf/dma-buf.c | 9 ++++++---
>>>   include/linux/dma-buf.h   | 4 ++++
>>>   2 files changed, 10 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>>> index dc94e76e2e2a..49f23b791eb8 100644
>>> --- a/drivers/dma-buf/dma-buf.c
>>> +++ b/drivers/dma-buf/dma-buf.c
>>> @@ -665,7 +665,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>>>   	if (WARN_ON(!attach || !attach->dmabuf))
>>>   		return ERR_PTR(-EINVAL);
>>>   
>>> -	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
>>> +	reservation_object_lock(attach->dmabuf->resv, NULL);
>>> +	sg_table = dma_buf_map_attachment_locked(attach, direction);
>>> +	reservation_object_unlock(attach->dmabuf->resv);
>>>   	if (!sg_table)
>>>   		sg_table = ERR_PTR(-ENOMEM);
>>>   
>>> @@ -715,8 +717,9 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>>>   	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
>>>   		return;
>>>   
>>> -	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table,
>>> -						direction);
>>> +	reservation_object_lock(attach->dmabuf->resv, NULL);
>>> +	dma_buf_unmap_attachment_locked(attach, sg_table, direction);
>>> +	reservation_object_unlock(attach->dmabuf->resv);
>>>   }
>>>   EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
>>>   
>>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>>> index a25e754ae2f7..024658d1f22e 100644
>>> --- a/include/linux/dma-buf.h
>>> +++ b/include/linux/dma-buf.h
>>> @@ -118,6 +118,8 @@ struct dma_buf_ops {
>>>   	 * any other kind of sharing that the exporter might wish to make
>>>   	 * available to buffer-users.
>>>   	 *
>>> +	 * This is called with the dmabuf->resv object locked.
>>> +	 *
>>>   	 * Returns:
>>>   	 *
>>>   	 * A &sg_table scatter list of or the backing storage of the DMA buffer,
>>> @@ -138,6 +140,8 @@ struct dma_buf_ops {
>>>   	 * It should also unpin the backing storage if this is the last mapping
>>>   	 * of the DMA buffer, it the exporter supports backing storage
>>>   	 * migration.
>>> +	 *
>>> +	 * This is called with the dmabuf->resv object locked.
>>>   	 */
>>>   	void (*unmap_dma_buf)(struct dma_buf_attachment *,
>>>   			      struct sg_table *,
>>> -- 
>>> 2.14.1
>>>
>> -- 
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> http://blog.ffwll.ch
