Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33119 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753207AbdGXL5D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 07:57:03 -0400
Received: by mail-io0-f193.google.com with SMTP id q64so1749175ioi.0
        for <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 04:57:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b3cb04f6-07c8-f5dd-3d7b-7f41f1d0dd81@vodafone.de>
References: <1500654001-20899-1-git-send-email-deathsimple@vodafone.de>
 <20170724083359.j6wo5icln3faajn6@phenom.ffwll.local> <b3cb04f6-07c8-f5dd-3d7b-7f41f1d0dd81@vodafone.de>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Mon, 24 Jul 2017 13:57:01 +0200
Message-ID: <CAKMK7uEC6BpYZeWZENk=Kt01yQuJXW=kgpp3acAMEdQBmD84FQ@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: fix reservation_object_wait_timeout_rcu to wait correctly
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 24, 2017 at 11:51 AM, Christian K=C3=B6nig
<deathsimple@vodafone.de> wrote:
> Am 24.07.2017 um 10:33 schrieb Daniel Vetter:
>>
>> On Fri, Jul 21, 2017 at 06:20:01PM +0200, Christian K=C3=B6nig wrote:
>>>
>>> From: Christian K=C3=B6nig <christian.koenig@amd.com>
>>>
>>> With hardware resets in mind it is possible that all shared fences are
>>> signaled, but the exlusive isn't. Fix waiting for everything in this
>>> situation.
>>
>> How did you end up with both shared and exclusive fences on the same
>> reservation object? At least I thought the point of exclusive was that
>> it's exclusive (and has an implicit barrier on all previous shared
>> fences). Same for shared fences, they need to wait for the exclusive one
>> (and replace it).
>>
>> Is this fallout from the amdgpu trickery where by default you do all
>> shared fences? I thought we've aligned semantics a while back ...
>
>
> No, that is perfectly normal even for other drivers. Take a look at the
> reservation code.
>
> The exclusive fence replaces all shared fences, but adding a shared fence
> doesn't replace the exclusive fence. That actually makes sense, cause whe=
n
> you want to add move shared fences those need to wait for the last exclus=
ive
> fence as well.

Hm right.

> Now normally I would agree that when you have shared fences it is suffici=
ent
> to wait for all of them cause those operations can't start before the
> exclusive one finishes. But with GPU reset and/or the ability to abort
> already submitted operations it is perfectly possible that you end up wit=
h
> an exclusive fence which isn't signaled and a shared fence which is signa=
led
> in the same reservation object.

How does that work? The batch(es) with the shared fence are all
supposed to wait for the exclusive fence before they start, which
means even if you gpu reset and restart/cancel certain things, they
shouldn't be able to complete out of order.

If you outright cancel a fence then you're supposed to first call
dma_fence_set_error(-EIO) and then complete it. Note that atm that
part might be slightly overengineered and I'm not sure about how we
expose stuff to userspace, e.g. dma_fence_set_error(-EAGAIN) is (or
soon, has been) used by i915 for it's internal book-keeping, which
might not be the best to leak to other consumers. But completing
fences (at least exported ones, where userspace or other drivers can
get at them) shouldn't be possible.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
