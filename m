Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35795 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbeC0HfX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 03:35:23 -0400
Received: by mail-wm0-f41.google.com with SMTP id r82so19863551wme.0
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 00:35:22 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
To: Jerome Glisse <j.glisse@gmail.com>, Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        christian.koenig@amd.com,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
References: <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
 <CAKMK7uH3xNkx3UFBMdcJ415F2WsC7s_D+CDAjLAh1p-xo5RfSA@mail.gmail.com>
 <19ed21a5-805d-271f-9120-49e0c00f510f@amd.com>
 <20180320140810.GU14155@phenom.ffwll.local>
 <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
 <20180321082839.GA14155@phenom.ffwll.local>
 <327c4bc1-5813-16e8-62fc-4301b19a1a22@gmail.com>
 <20180322071804.GH14155@phenom.ffwll.local>
 <ef9fa9a2-c368-1fca-a8ac-8ee8d522b6ab@gmail.com>
 <20180326080121.GO14155@phenom.ffwll.local>
 <20180326154224.GA11930@gmail.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <f8ff3993-6605-4f8e-5ac2-c40f0450c1c6@gmail.com>
Date: Tue, 27 Mar 2018 09:35:17 +0200
MIME-Version: 1.0
In-Reply-To: <20180326154224.GA11930@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 26.03.2018 um 17:42 schrieb Jerome Glisse:
> On Mon, Mar 26, 2018 at 10:01:21AM +0200, Daniel Vetter wrote:
>> On Thu, Mar 22, 2018 at 10:58:55AM +0100, Christian König wrote:
>>> Am 22.03.2018 um 08:18 schrieb Daniel Vetter:
>>> [SNIP]
>>> Key take away from that was that you can't take any locks from neither the
>>> MMU notifier nor the shrinker you also take while calling kmalloc (or
>>> simpler speaking get_user_pages()).
>>>
>>> Additional to that in the MMU or shrinker callback all different kinds of
>>> locks might be held, so you basically can't assume that you do thinks like
>>> recursive page table walks or call dma_unmap_anything.
>> That sounds like a design bug in mmu_notifiers, since it would render them
>> useless for KVM. And they were developed for that originally. I think I'll
>> chat with Jerome to understand this, since it's all rather confusing.
> Doing dma_unmap() during mmu_notifier callback should be fine, it was last
> time i check. However there is no formal contract that it is ok to do so.

As I said before dma_unmap() isn't the real problem here.

The issues is more that you can't take a lock in the MMU notifier which 
you would also take while allocating memory without GFP_NOIO.

That makes it rather tricky to do any command submission, e.g. you need 
to grab all the pages/memory/resources prehand, then make sure that you 
don't have a MMU notifier running concurrently and do the submission.

If any of the prerequisites isn't fulfilled we need to restart the 
operation.

> [SNIP]
> A slightly better solution is using atomic counter:
>    driver_range_start() {
>      atomic_inc(&mydev->notifier_count);
...

Yeah, that is exactly what amdgpu is doing now. Sorry if my description 
didn't made that clear.

> I would like to see driver using same code, as it means one place to fix
> issues. I had for a long time on my TODO list doing the above conversion
> to amd or radeon kernel driver. I am pushing up my todo list hopefully in
> next few weeks i can send an rfc so people can have a real sense of how
> it can look.

Certainly a good idea, but I think we might have that separate to HMM.

TTM suffered really from feature overload, e.g. trying to do everything 
in a single subsystem. And it would be rather nice to have coherent 
userptr handling for GPUs as separate feature.

Regards,
Christian.
