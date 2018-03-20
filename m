Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:56119 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbeCTHoi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 03:44:38 -0400
Received: by mail-it0-f49.google.com with SMTP id e195-v6so1172647ita.5
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 00:44:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
References: <20180316132049.1748-1-christian.koenig@amd.com>
 <20180316132049.1748-2-christian.koenig@amd.com> <152120831102.25315.4326885184264378830@mail.alporthouse.com>
 <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com> <152147480241.18954.4556582215766884582@mail.alporthouse.com>
 <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Tue, 20 Mar 2018 08:44:37 +0100
Message-ID: <CAKMK7uH3xNkx3UFBMdcJ415F2WsC7s_D+CDAjLAh1p-xo5RfSA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 19, 2018 at 5:23 PM, Christian K=C3=B6nig
<ckoenig.leichtzumerken@gmail.com> wrote:
> Am 19.03.2018 um 16:53 schrieb Chris Wilson:
>>
>> Quoting Christian K=C3=B6nig (2018-03-16 14:22:32)
>> [snip, probably lost too must context]
>>>
>>> This allows for full grown pipelining, e.g. the exporter can say I need
>>> to move the buffer for some operation. Then let the move operation wait
>>> for all existing fences in the reservation object and install the fence
>>> of the move operation as exclusive fence.
>>
>> Ok, the situation I have in mind is the non-pipelined case: revoking
>> dma-buf for mmu_invalidate_range or shrink_slab. I would need a
>> completion event that can be waited on the cpu for all the invalidate
>> callbacks. (Essentially an atomic_t counter plus struct completion; a
>> lighter version of dma_fence, I wonder where I've seen that before ;)
>
>
> Actually that is harmless.
>
> When you need to unmap a DMA-buf because of mmu_invalidate_range or
> shrink_slab you need to wait for it's reservation object anyway.

reservation_object only prevents adding new fences, you still have to
wait for all the current ones to signal. Also, we have dma-access
without fences in i915. "I hold the reservation_object" does not imply
you can just go and nuke the backing storage.

> This needs to be done to make sure that the backing memory is now idle, i=
t
> doesn't matter if the jobs where submitted by DMA-buf importers or your o=
wn
> driver.
>
> The sg tables pointing to the now released memory might live a bit longer=
,
> but that is unproblematic and actually intended.

I think that's very problematic. One reason for an IOMMU is that you
have device access isolation, and a broken device can't access memory
it shouldn't be able to access. From that security-in-depth point of
view it's not cool that there's some sg tables hanging around still
that a broken GPU could use. And let's not pretend hw is perfect,
especially GPUs :-)

> When we would try to destroy the sg tables in an mmu_invalidate_range or
> shrink_slab callback we would run into a lockdep horror.

So I'm no expert on this, but I think this is exactly what we're doing
in i915. Kinda no other way to actually free the memory without
throwing all the nice isolation aspects of an IOMMU into the wind. Can
you please paste the lockdeps you've seen with amdgpu when trying to
do that?
-Daniel

>
> Regards,
> Christian.
>
>>
>> Even so, it basically means passing a fence object down to the async
>> callbacks for them to signal when they are complete. Just to handle the
>> non-pipelined version. :|
>> -Chris
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>
>
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> https://lists.linaro.org/mailman/listinfo/linaro-mm-sig



--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
