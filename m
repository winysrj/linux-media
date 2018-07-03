Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr700079.outbound.protection.outlook.com ([40.107.70.79]:23680
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752961AbeGCNCX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jul 2018 09:02:23 -0400
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
 <2ebff18b-414d-c971-1b7f-f6a21aacf196@gmail.com>
 <20180703125235.GB3891@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <35187534-cc89-3e31-5428-2700c3f8a90b@amd.com>
Date: Tue, 3 Jul 2018 15:02:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180703125235.GB3891@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 03.07.2018 um 14:52 schrieb Daniel Vetter:
> On Tue, Jul 03, 2018 at 01:46:44PM +0200, Christian König wrote:
>> Am 25.06.2018 um 11:12 schrieb Daniel Vetter:
>>> On Mon, Jun 25, 2018 at 10:22:31AM +0200, Daniel Vetter wrote:
>>>> On Fri, Jun 22, 2018 at 04:11:01PM +0200, Christian König wrote:
>>>>> First step towards unpinned DMA buf operation.
>>>>>
>>>>> I've checked the DRM drivers to potential locking of the reservation
>>>>> object, but essentially we need to audit all implementations of the
>>>>> dma_buf _ops for this to work.
>>>>>
>>>>> v2: reordered
>>>>>
>>>>> Signed-off-by: Christian König <christian.koenig@amd.com>
>>>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>> Ok I did review drivers a bit, but apparently not well enough by far. i915
>>> CI is unhappy:
>>>
>>> https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_9400/fi-whl-u/igt@gem_mmap_gtt@basic-small-bo-tiledx.html
>>>
>>> So yeah inserting that lock in there isn't the most trivial thing :-/
>>>
>>> I kinda assume that other drivers will have similar issues, e.g. omapdrm's
>>> use of dev->struct_mutex also very much looks like it'll result in a new
>>> locking inversion.
>> Ah, crap. Already feared that this wouldn't be easy, but yeah that it is as
>> bad as this is rather disappointing.
>>
>> Thanks for the info, going to keep thinking about how to solve those issues.
> Side note: We want to make sure that drivers don't get the reservation_obj
> locking hierarchy wrong in other places (using dev->struct_mutex is kinda
> a pre-existing mis-use that we can't wish away retroactively
> unfortunately). One really important thing is that shrinker vs resv_obj
> must work with trylocks in the shrinker, so that you can allocate memory
> while holding reservation objects.
>
> One neat trick to teach lockdep about this would be to have a dummy
>
> if (IS_ENABLED(CONFIG_PROVE_LOCKING)) {
> 	ww_mutex_lock(dma_buf->resv_obj);
> 	fs_reclaim_acquire(GFP_KERNEL);
> 	fs_reclaim_release(GFP_KERNEL);
> 	ww_mutex_unlock(dma_buf->resv_obj);
> }
>
> in dma_buf_init(). We're using the fs_reclaim_acquire/release check very
> successfully to improve our igt test coverage for i915.ko in other areas.
>
> Totally unrelated to dev->struct_mutex, but thoughts? Well for
> dev->struct_mutex we could at least decide on one true way to nest
> resv_obj vs. dev->struct_mutex as maybe an interim step, but not sure how
> much that would help.

I don't think that would help. As far as I can see we only have two choices:

1. Either have a big patch which fixes all DMA-buf implementations to 
allow the reservation lock to be held during map/unmap (unrealistic).

2. Add a flag to at least in the mid term tell the DMA-buf helper 
functions what to do. E.g. create the mapping without the reservation 
lock held.


How about moving the SGL caching from the DRM layer into the DMA-buf 
layer and add a flag if the exporter wants/needs this caching?

Then only the implementations which can deal with dynamic invalidation 
disable SGL caching and with it enable creating the sgl with the 
reservation object locked.

This way we can kill two birds with one stone by both avoiding the SGL 
caching in the DRM layer as well as having a sane handling for the locking.

Thoughts?

Christian.


> -Daniel
