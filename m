Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34898 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751753AbeCVJ67 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 05:58:59 -0400
Received: by mail-wm0-f52.google.com with SMTP id r82so14965309wme.0
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2018 02:58:58 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
To: Daniel Vetter <daniel@ffwll.ch>, christian.koenig@amd.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
References: <152120831102.25315.4326885184264378830@mail.alporthouse.com>
 <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com>
 <152147480241.18954.4556582215766884582@mail.alporthouse.com>
 <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
 <CAKMK7uH3xNkx3UFBMdcJ415F2WsC7s_D+CDAjLAh1p-xo5RfSA@mail.gmail.com>
 <19ed21a5-805d-271f-9120-49e0c00f510f@amd.com>
 <20180320140810.GU14155@phenom.ffwll.local>
 <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
 <20180321082839.GA14155@phenom.ffwll.local>
 <327c4bc1-5813-16e8-62fc-4301b19a1a22@gmail.com>
 <20180322071804.GH14155@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <ef9fa9a2-c368-1fca-a8ac-8ee8d522b6ab@gmail.com>
Date: Thu, 22 Mar 2018 10:58:55 +0100
MIME-Version: 1.0
In-Reply-To: <20180322071804.GH14155@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 22.03.2018 um 08:18 schrieb Daniel Vetter:
> On Wed, Mar 21, 2018 at 12:54:20PM +0100, Christian König wrote:
>> Am 21.03.2018 um 09:28 schrieb Daniel Vetter:
>>> On Tue, Mar 20, 2018 at 06:47:57PM +0100, Christian König wrote:
>>>> Am 20.03.2018 um 15:08 schrieb Daniel Vetter:
>>>>> [SNIP]
>>>>> For the in-driver reservation path (CS) having a slow-path that grabs a
>>>>> temporary reference, drops the vram lock and then locks the reservation
>>>>> normally (using the acquire context used already for the entire CS) is a
>>>>> bit tricky, but totally feasible. Ttm doesn't do that though.
>>>> That is exactly what we do in amdgpu as well, it's just not very efficient
>>>> nor reliable to retry getting the right pages for a submission over and over
>>>> again.
>>> Out of curiosity, where's that code? I did read the ttm eviction code way
>>> back, and that one definitely didn't do that. Would be interesting to
>>> update my understanding.
>> That is in amdgpu_cs.c. amdgpu_cs_parser_bos() does a horrible dance with
>> grabbing, releasing and regrabbing locks in a loop.
>>
>> Then in amdgpu_cs_submit() we grab an lock preventing page table updates and
>> check if all pages are still the one we want to have:
>>>          amdgpu_mn_lock(p->mn);
>>>          if (p->bo_list) {
>>>                  for (i = p->bo_list->first_userptr;
>>>                       i < p->bo_list->num_entries; ++i) {
>>>                          struct amdgpu_bo *bo = p->bo_list->array[i].robj;
>>>
>>>                          if
>>> (amdgpu_ttm_tt_userptr_needs_pages(bo->tbo.ttm)) {
>>>                                  amdgpu_mn_unlock(p->mn);
>>>                                  return -ERESTARTSYS;
>>>                          }
>>>                  }
>>>          }
>> If anything changed on the page tables we restart the whole IOCTL using
>> -ERESTARTSYS and try again.
> I'm not talking about userptr here, but general bo eviction. Sorry for the
> confusion.
>
> The reason I'm dragging all the general bo management into this
> discussions is because we do seem to have fairly fundamental difference in
> how that's done, with resulting consequences for the locking hierarchy.
>
> And if this invalidate_mapping stuff should work, together with userptr
> and everything else, I think we're required to agree on how this is all
> supposed to nest, and how exactly we should back off for the other side
> that needs to break the locking circle.
>
> That aside, I don't entirely understand why you need to restart so much. I
> figured that get_user_pages is ordered correctly against mmu
> invalidations, but I get the impression you think that's not the case. How
> does that happen?

Correct. I've had the same assumption, but both Jerome as well as our 
internal tests proved me wrong on that.

Key take away from that was that you can't take any locks from neither 
the MMU notifier nor the shrinker you also take while calling kmalloc 
(or simpler speaking get_user_pages()).

Additional to that in the MMU or shrinker callback all different kinds 
of locks might be held, so you basically can't assume that you do thinks 
like recursive page table walks or call dma_unmap_anything.

Thinking a moment about that it actually seems to make perfect sense.

So it doesn't matter what order you got between the mmap_sem and your 
buffer or allocation lock, it will simply be incorrect with other locks 
in the system anyway.

The only solution to that problem we have found is the dance we have in 
amdgpu now:

1. Inside invalidate_range_start you grab a recursive read side lock.
2. Wait for all GPU operation on that pages to finish.
3. Then mark all pages as dirty and accessed.
4. Inside invalidate_range_end you release your recursive read side lock 
again.

Then during command submission you do the following:

1. Take the locks Figure out all the userptr BOs which needs new pages.
2. Drop the locks again call get_user_pages().
3. Install the new page arrays and reiterate with #1
4. As soon as everybody has pages update your page tables and prepare 
all command submission.
5. Take the write side of our recursive lock.
6. Check if all pages are still valid, if not restart the whole IOCTL.
7. Submit the job to the hardware.
8. Drop the write side of our recursive lock.

Regards,
Christian.

> -Daniel
