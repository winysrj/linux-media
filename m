Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35811 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933620AbeCSQX0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 12:23:26 -0400
Received: by mail-wm0-f43.google.com with SMTP id r82so6304454wme.0
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2018 09:23:26 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 1/5] dma-buf: add optional invalidate_mappings callback v2
To: Chris Wilson <chris@chris-wilson.co.uk>, christian.koenig@amd.com,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
References: <20180316132049.1748-1-christian.koenig@amd.com>
 <20180316132049.1748-2-christian.koenig@amd.com>
 <152120831102.25315.4326885184264378830@mail.alporthouse.com>
 <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com>
 <152147480241.18954.4556582215766884582@mail.alporthouse.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
Date: Mon, 19 Mar 2018 17:23:23 +0100
MIME-Version: 1.0
In-Reply-To: <152147480241.18954.4556582215766884582@mail.alporthouse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 19.03.2018 um 16:53 schrieb Chris Wilson:
> Quoting Christian König (2018-03-16 14:22:32)
> [snip, probably lost too must context]
>> This allows for full grown pipelining, e.g. the exporter can say I need
>> to move the buffer for some operation. Then let the move operation wait
>> for all existing fences in the reservation object and install the fence
>> of the move operation as exclusive fence.
> Ok, the situation I have in mind is the non-pipelined case: revoking
> dma-buf for mmu_invalidate_range or shrink_slab. I would need a
> completion event that can be waited on the cpu for all the invalidate
> callbacks. (Essentially an atomic_t counter plus struct completion; a
> lighter version of dma_fence, I wonder where I've seen that before ;)

Actually that is harmless.

When you need to unmap a DMA-buf because of mmu_invalidate_range or 
shrink_slab you need to wait for it's reservation object anyway.

This needs to be done to make sure that the backing memory is now idle, 
it doesn't matter if the jobs where submitted by DMA-buf importers or 
your own driver.

The sg tables pointing to the now released memory might live a bit 
longer, but that is unproblematic and actually intended.

When we would try to destroy the sg tables in an mmu_invalidate_range or 
shrink_slab callback we would run into a lockdep horror.

Regards,
Christian.

>
> Even so, it basically means passing a fence object down to the async
> callbacks for them to signal when they are complete. Just to handle the
> non-pipelined version. :|
> -Chris
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
