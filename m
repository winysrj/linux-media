Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0080.outbound.protection.outlook.com ([104.47.32.80]:55428
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750746AbdGYHQQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 03:16:16 -0400
Message-ID: <5976F00B.1020605@amd.com>
Date: Tue, 25 Jul 2017 15:15:23 +0800
From: zhoucm1 <david1.zhou@amd.com>
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dma-buf: fix reservation_object_wait_timeout_rcu to wait
 correctly
References: <1500654001-20899-1-git-send-email-deathsimple@vodafone.de> <20170724083359.j6wo5icln3faajn6@phenom.ffwll.local> <b3cb04f6-07c8-f5dd-3d7b-7f41f1d0dd81@vodafone.de> <CAKMK7uEC6BpYZeWZENk=Kt01yQuJXW=kgpp3acAMEdQBmD84FQ@mail.gmail.com> <5976E257.4080701@amd.com> <20170725065027.jdwbpyqfs7ir7tyn@phenom.ffwll.local> <5976EB52.6020008@amd.com> <20170725070236.yjn526srw5ki7onh@phenom.ffwll.local>
In-Reply-To: <20170725070236.yjn526srw5ki7onh@phenom.ffwll.local>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2017年07月25日 15:02, Daniel Vetter wrote:
> On Tue, Jul 25, 2017 at 02:55:14PM +0800, zhoucm1 wrote:
>>
>> On 2017年07月25日 14:50, Daniel Vetter wrote:
>>> On Tue, Jul 25, 2017 at 02:16:55PM +0800, zhoucm1 wrote:
>>>> On 2017年07月24日 19:57, Daniel Vetter wrote:
>>>>> On Mon, Jul 24, 2017 at 11:51 AM, Christian König
>>>>> <deathsimple@vodafone.de> wrote:
>>>>>> Am 24.07.2017 um 10:33 schrieb Daniel Vetter:
>>>>>>> On Fri, Jul 21, 2017 at 06:20:01PM +0200, Christian König wrote:
>>>>>>>> From: Christian König <christian.koenig@amd.com>
>>>>>>>>
>>>>>>>> With hardware resets in mind it is possible that all shared fences are
>>>>>>>> signaled, but the exlusive isn't. Fix waiting for everything in this
>>>>>>>> situation.
>>>>>>> How did you end up with both shared and exclusive fences on the same
>>>>>>> reservation object? At least I thought the point of exclusive was that
>>>>>>> it's exclusive (and has an implicit barrier on all previous shared
>>>>>>> fences). Same for shared fences, they need to wait for the exclusive one
>>>>>>> (and replace it).
>>>>>>>
>>>>>>> Is this fallout from the amdgpu trickery where by default you do all
>>>>>>> shared fences? I thought we've aligned semantics a while back ...
>>>>>> No, that is perfectly normal even for other drivers. Take a look at the
>>>>>> reservation code.
>>>>>>
>>>>>> The exclusive fence replaces all shared fences, but adding a shared fence
>>>>>> doesn't replace the exclusive fence. That actually makes sense, cause when
>>>>>> you want to add move shared fences those need to wait for the last exclusive
>>>>>> fence as well.
>>>>> Hm right.
>>>>>
>>>>>> Now normally I would agree that when you have shared fences it is sufficient
>>>>>> to wait for all of them cause those operations can't start before the
>>>>>> exclusive one finishes. But with GPU reset and/or the ability to abort
>>>>>> already submitted operations it is perfectly possible that you end up with
>>>>>> an exclusive fence which isn't signaled and a shared fence which is signaled
>>>>>> in the same reservation object.
>>>>> How does that work? The batch(es) with the shared fence are all
>>>>> supposed to wait for the exclusive fence before they start, which
>>>>> means even if you gpu reset and restart/cancel certain things, they
>>>>> shouldn't be able to complete out of order.
>>>> Hi Daniel,
>>>>
>>>> Do you mean exclusive fence must be signalled before any shared fence? Where
>>>> could I find this restriction?
>>> Yes, Christian also described it above. Could be that we should have
>>> better kerneldoc to document this ...
>> Is that a known assumption? if that way, it doesn't matter even that we
>> always wait exclusive fence, right? Just one more line checking.
> The problem is that amdgpu breaks that assumption over gpu reset, and that
> might have implications _everywhere_, not just in this code here. Are you
> sure this case won't pull the i915 driver over the table when sharing
> dma-bufs with it?
Ah, I finally got your mean. So as you mentioned before, we at least 
should have better describe for this assumption, the best place is 
comments in reservation.c, every newer would know it when reading code 
first time.

Thanks,
David Zhou
> Did you audit the code (plus all the other drivers too
> ofc).
> -Daniel
