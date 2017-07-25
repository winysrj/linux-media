Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsmx011.vodafonemail.xion.oxcs.net ([153.92.174.89]:58765 "EHLO
        vsmx011.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751619AbdGYJLt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 05:11:49 -0400
Subject: Re: [PATCH] dma-buf: fix reservation_object_wait_timeout_rcu to wait
 correctly
To: Daniel Vetter <daniel@ffwll.ch>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
References: <1500654001-20899-1-git-send-email-deathsimple@vodafone.de>
 <20170724083359.j6wo5icln3faajn6@phenom.ffwll.local>
 <b3cb04f6-07c8-f5dd-3d7b-7f41f1d0dd81@vodafone.de>
 <CAKMK7uEC6BpYZeWZENk=Kt01yQuJXW=kgpp3acAMEdQBmD84FQ@mail.gmail.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <dd129079-91d3-7afe-0368-a267c2472484@vodafone.de>
Date: Tue, 25 Jul 2017 11:11:35 +0200
MIME-Version: 1.0
In-Reply-To: <CAKMK7uEC6BpYZeWZENk=Kt01yQuJXW=kgpp3acAMEdQBmD84FQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 24.07.2017 um 13:57 schrieb Daniel Vetter:
> On Mon, Jul 24, 2017 at 11:51 AM, Christian König
> <deathsimple@vodafone.de> wrote:
>> Am 24.07.2017 um 10:33 schrieb Daniel Vetter:
>>> On Fri, Jul 21, 2017 at 06:20:01PM +0200, Christian König wrote:
>>>> From: Christian König <christian.koenig@amd.com>
>>>>
>>>> With hardware resets in mind it is possible that all shared fences are
>>>> signaled, but the exlusive isn't. Fix waiting for everything in this
>>>> situation.
>>> How did you end up with both shared and exclusive fences on the same
>>> reservation object? At least I thought the point of exclusive was that
>>> it's exclusive (and has an implicit barrier on all previous shared
>>> fences). Same for shared fences, they need to wait for the exclusive one
>>> (and replace it).
>>>
>>> Is this fallout from the amdgpu trickery where by default you do all
>>> shared fences? I thought we've aligned semantics a while back ...
>>
>> No, that is perfectly normal even for other drivers. Take a look at the
>> reservation code.
>>
>> The exclusive fence replaces all shared fences, but adding a shared fence
>> doesn't replace the exclusive fence. That actually makes sense, cause when
>> you want to add move shared fences those need to wait for the last exclusive
>> fence as well.
> Hm right.
>
>> Now normally I would agree that when you have shared fences it is sufficient
>> to wait for all of them cause those operations can't start before the
>> exclusive one finishes. But with GPU reset and/or the ability to abort
>> already submitted operations it is perfectly possible that you end up with
>> an exclusive fence which isn't signaled and a shared fence which is signaled
>> in the same reservation object.
> How does that work? The batch(es) with the shared fence are all
> supposed to wait for the exclusive fence before they start, which
> means even if you gpu reset and restart/cancel certain things, they
> shouldn't be able to complete out of order.

Assume the following:
1. The exclusive fence is some move operation by the kernel which 
executes on a DMA engine.
2. The shared fence is a 3D operation submitted by userspace which 
executes on the 3D engine.

Now we found the 3D engine to be hung and needs a reset, all currently 
submitted jobs are aborted, marked with an error code and their fences 
put into the signaled state.

Since we only reset the 3D engine, the move operation (fortunately) 
isn't affected by this.

I think this applies to all drivers and isn't something amdgpu specific.

Regards,
Christian.

>
> If you outright cancel a fence then you're supposed to first call
> dma_fence_set_error(-EIO) and then complete it. Note that atm that
> part might be slightly overengineered and I'm not sure about how we
> expose stuff to userspace, e.g. dma_fence_set_error(-EAGAIN) is (or
> soon, has been) used by i915 for it's internal book-keeping, which
> might not be the best to leak to other consumers. But completing
> fences (at least exported ones, where userspace or other drivers can
> get at them) shouldn't be possible.
> -Daniel
