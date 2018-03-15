Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:41153 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbeCOLDC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 07:03:02 -0400
Received: by mail-io0-f178.google.com with SMTP id m83so8056726ioi.8
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2018 04:03:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d9946822-cea1-f774-d6dc-94ec970b6694@gmail.com>
References: <20180309191144.1817-1-christian.koenig@amd.com>
 <20180309191144.1817-2-christian.koenig@amd.com> <20180312170710.GL8589@phenom.ffwll.local>
 <f3986703-75de-4ce3-a828-1687291bb618@gmail.com> <20180313151721.GH4788@phenom.ffwll.local>
 <2866813a-f2ab-0589-ee40-30935e59d3d7@gmail.com> <20180313160052.GK4788@phenom.ffwll.local>
 <052a6595-9fc3-48a6-9366-67ca2f2da17e@gmail.com> <20180315092013.GC25297@phenom.ffwll.local>
 <d9946822-cea1-f774-d6dc-94ec970b6694@gmail.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Thu, 15 Mar 2018 12:02:59 +0100
Message-ID: <CAKMK7uGrPRgLbd52RLoZsRA5qwCQV=xp4t_Tp8z-Qv06Yp7QNw@mail.gmail.com>
Subject: Re: [PATCH 1/4] dma-buf: add optional invalidate_mappings callback
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 15, 2018 at 10:56 AM, Christian K=C3=B6nig
<ckoenig.leichtzumerken@gmail.com> wrote:
> Am 15.03.2018 um 10:20 schrieb Daniel Vetter:
>>
>> On Tue, Mar 13, 2018 at 06:20:07PM +0100, Christian K=C3=B6nig wrote:
>> [SNIP]
>> Take a look at the DOT graphs for atomic I've done a while ago. I think =
we
>> could make a formidable competition for who's doing the worst diagrams :=
-)
>
>
> Thanks, going to give that a try.
>
>> [SNIP]
>> amdgpu: Expects that you never hold any of the heavywheight locks while
>> waiting for a fence (since gpu resets will need them).
>>
>> i915: Happily blocks on fences while holding all kinds of locks, expects
>> gpu reset to be able to recover even in this case.
>
>
> In this case I can comfort you, the looks amdgpu needs to grab during GPU
> reset are the reservation lock of the VM page tables. I have strong doubt
> that i915 will ever hold those.

Ah good, means that very likely there's at least no huge fundamental
design issue that we run into.

> Could be that we run into problems because Thread A hold lock 1 tries to
> take lock 2, then i915 holds 2 and our reset path needs 1.

Yeah that might happen, but lockdep will catch those, and generally
those cases can be fixed with slight reordering or re-annotating of
the code to avoid upsetting lockdep. As long as we don't have a
full-on functional dependency (which is what I've feared).

>> [SNIP]
>>>
>>> Yes, except for fallback paths and bootup self tests we simply never wa=
it
>>> for fences while holding locks.
>>
>> That's not what I meant with "are you sure". Did you enable the
>> cross-release stuff (after patching the bunch of leftover core kernel
>> issues still present), annotate dma_fence with the cross-release stuff,
>> run a bunch of multi-driver (amdgpu vs i915) dma-buf sharing tests and
>> weep?
>
>
> Ok, what exactly do you mean with cross-release checking?

Current lockdep doesn't spot deadlocks like the below:

thread A: holds mutex, waiting for completion.

thread B: acquires mutex before it will ever signal the completion A
is waiting for

->deadlock

cross-release lockdep support can catch these through new fancy
annotations. Similar waiter/signaller annotations exists for waiting
on workers and anything else, and it would be a perfect fit for
waiter/signaller code around dma_fence.

lwn has you covered a usual: https://lwn.net/Articles/709849/

Cheers, Daniel

>> I didn't do the full thing yet, but just within i915 we've found tons of
>> small little deadlocks we never really considered thanks to cross releas=
e,
>> and that wasn't even including the dma_fence annotation. Luckily nothing
>> that needed a full-on driver redesign.
>>
>> I guess I need to ping core kernel maintainers about cross-release again=
.
>> I'd much prefer if we could validate ->invalidate_mapping and the
>> locking/fence dependency issues using that, instead of me having to read
>> and understand all the drivers.
>
> [SNIP]
>>
>> I fear that with the ->invalidate_mapping callback (which inverts the
>> control flow between importer and exporter) and tying dma_fences into al=
l
>> this it will be a _lot_ worse. And I'm definitely too stupid to understa=
nd
>> all the dependency chains without the aid of lockdep and a full test sui=
te
>> (we have a bunch of amdgpu/i915 dma-buf tests in igt btw).
>
>
> Yes, that is also something I worry about.
>
> Regards,
> Christian.



--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
