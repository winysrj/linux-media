Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:39492 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbeCLTlj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 15:41:39 -0400
Received: by mail-io0-f179.google.com with SMTP id v10so6220234iob.6
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2018 12:41:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e4b847f4-f6e7-6284-eaec-6bd3e1945c2d@gmail.com>
References: <20180309191144.1817-1-christian.koenig@amd.com>
 <20180312172401.GM8589@phenom.ffwll.local> <e4b847f4-f6e7-6284-eaec-6bd3e1945c2d@gmail.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Mon, 12 Mar 2018 20:41:37 +0100
Message-ID: <CAKMK7uEiCxze-D6h=DuS5VXjNskbsSt3chM4=eN_JODsL407OA@mail.gmail.com>
Subject: Re: RFC: unpinned DMA-buf exporting
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 12, 2018 at 8:15 PM, Christian K=C3=B6nig
<ckoenig.leichtzumerken@gmail.com> wrote:
> Am 12.03.2018 um 18:24 schrieb Daniel Vetter:
>>
>> On Fri, Mar 09, 2018 at 08:11:40PM +0100, Christian K??nig wrote:
>>>
>>> This set of patches adds an option invalidate_mappings callback to each
>>> DMA-buf attachment which can be filled in by the importer.
>>>
>>> This callback allows the exporter to provided the DMA-buf content
>>> without pinning it. The reservation objects lock acts as synchronizatio=
n
>>> point for buffer moves and creating mappings.
>>>
>>> This set includes an implementation for amdgpu which should be rather
>>> easily portable to other DRM drivers.
>>
>> Bunch of higher level comments, and one I've forgotten in reply to patch
>> 1:
>>
>> - What happens when a dma-buf is pinned (e.g. i915 loves to pin buffers
>>    for scanout)?
>
>
> When you need to pin an imported DMA-buf you need to detach and reattach
> without the invalidate_mappings callback.

I think that must both be better documented, and also somehow enforced
with checks. Atm nothing makes sure you actually manage to unmap if
you claim to be able to do so.

I think a helper to switch from pinned to unpinned would be lovely
(just need to clear/reset the ->invalidate_mapping pointer while
holding the reservation). Or do you expect to map buffers differently
depending whether you can move them or not? At least for i915 we'd
need to rework our driver quite a bit if you expect us to throw the
mapping away just to be able to pin it. Atm pinning requires that it's
mapped already (and depending upon platform the gpu might be using
that exact mapping to render, so unmapping for pinning is a bad idea
for us).

>> - pulling the dma-buf implementations into amdgpu makes sense, that's
>>    kinda how it was meant to be anyway. The gem prime helpers are a bit
>> too
>>    much midlayer for my taste (mostly because nvidia wanted to bypass th=
e
>>    EXPORT_SYMBOL_GPL of core dma-buf, hooray for legal bs). We can alway=
s
>>    extract more helpers once there's more ttm based drivers doing this.
>
>
> Yeah, I though to abstract that similar to the AGP backend.
>
> Just moving some callbacks around in TTM should be sufficient to de-midla=
yer
> the whole thing.

Yeah TTM has all the abstractions needed to handle dma-bufs
"properly", it's just sometimes at the wrong level or can't be
overriden. At least per my understanding of TTM (which is most likely
... confused).
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
