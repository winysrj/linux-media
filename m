Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:46485 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbeCULyX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 07:54:23 -0400
Received: by mail-wr0-f194.google.com with SMTP id s10so4879815wra.13
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2018 04:54:22 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
To: Daniel Vetter <daniel@ffwll.ch>, christian.koenig@amd.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
References: <20180316132049.1748-1-christian.koenig@amd.com>
 <20180316132049.1748-2-christian.koenig@amd.com>
 <152120831102.25315.4326885184264378830@mail.alporthouse.com>
 <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com>
 <152147480241.18954.4556582215766884582@mail.alporthouse.com>
 <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
 <CAKMK7uH3xNkx3UFBMdcJ415F2WsC7s_D+CDAjLAh1p-xo5RfSA@mail.gmail.com>
 <19ed21a5-805d-271f-9120-49e0c00f510f@amd.com>
 <20180320140810.GU14155@phenom.ffwll.local>
 <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
 <20180321082839.GA14155@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <327c4bc1-5813-16e8-62fc-4301b19a1a22@gmail.com>
Date: Wed, 21 Mar 2018 12:54:20 +0100
MIME-Version: 1.0
In-Reply-To: <20180321082839.GA14155@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 21.03.2018 um 09:28 schrieb Daniel Vetter:
> On Tue, Mar 20, 2018 at 06:47:57PM +0100, Christian König wrote:
>> Am 20.03.2018 um 15:08 schrieb Daniel Vetter:
>>> [SNIP]
>>> For the in-driver reservation path (CS) having a slow-path that grabs a
>>> temporary reference, drops the vram lock and then locks the reservation
>>> normally (using the acquire context used already for the entire CS) is a
>>> bit tricky, but totally feasible. Ttm doesn't do that though.
>> That is exactly what we do in amdgpu as well, it's just not very efficient
>> nor reliable to retry getting the right pages for a submission over and over
>> again.
> Out of curiosity, where's that code? I did read the ttm eviction code way
> back, and that one definitely didn't do that. Would be interesting to
> update my understanding.

That is in amdgpu_cs.c. amdgpu_cs_parser_bos() does a horrible dance 
with grabbing, releasing and regrabbing locks in a loop.

Then in amdgpu_cs_submit() we grab an lock preventing page table updates 
and check if all pages are still the one we want to have:
>         amdgpu_mn_lock(p->mn);
>         if (p->bo_list) {
>                 for (i = p->bo_list->first_userptr;
>                      i < p->bo_list->num_entries; ++i) {
>                         struct amdgpu_bo *bo = p->bo_list->array[i].robj;
>
>                         if 
> (amdgpu_ttm_tt_userptr_needs_pages(bo->tbo.ttm)) {
>                                 amdgpu_mn_unlock(p->mn);
>                                 return -ERESTARTSYS;
>                         }
>                 }
>         }

If anything changed on the page tables we restart the whole IOCTL using 
-ERESTARTSYS and try again.

Regards,
Christian.

> -Daniel
