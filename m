Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:38794 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbeCOJ4b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 05:56:31 -0400
Received: by mail-wr0-f178.google.com with SMTP id l8so7598100wrg.5
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2018 02:56:31 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 1/4] dma-buf: add optional invalidate_mappings callback
To: Daniel Vetter <daniel@ffwll.ch>, christian.koenig@amd.com
Cc: linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20180309191144.1817-1-christian.koenig@amd.com>
 <20180309191144.1817-2-christian.koenig@amd.com>
 <20180312170710.GL8589@phenom.ffwll.local>
 <f3986703-75de-4ce3-a828-1687291bb618@gmail.com>
 <20180313151721.GH4788@phenom.ffwll.local>
 <2866813a-f2ab-0589-ee40-30935e59d3d7@gmail.com>
 <20180313160052.GK4788@phenom.ffwll.local>
 <052a6595-9fc3-48a6-9366-67ca2f2da17e@gmail.com>
 <20180315092013.GC25297@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <d9946822-cea1-f774-d6dc-94ec970b6694@gmail.com>
Date: Thu, 15 Mar 2018 10:56:28 +0100
MIME-Version: 1.0
In-Reply-To: <20180315092013.GC25297@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 15.03.2018 um 10:20 schrieb Daniel Vetter:
> On Tue, Mar 13, 2018 at 06:20:07PM +0100, Christian König wrote:
> [SNIP]
> Take a look at the DOT graphs for atomic I've done a while ago. I think we
> could make a formidable competition for who's doing the worst diagrams :-)

Thanks, going to give that a try.

> [SNIP]
> amdgpu: Expects that you never hold any of the heavywheight locks while
> waiting for a fence (since gpu resets will need them).
>
> i915: Happily blocks on fences while holding all kinds of locks, expects
> gpu reset to be able to recover even in this case.

In this case I can comfort you, the looks amdgpu needs to grab during 
GPU reset are the reservation lock of the VM page tables. I have strong 
doubt that i915 will ever hold those.

Could be that we run into problems because Thread A hold lock 1 tries to 
take lock 2, then i915 holds 2 and our reset path needs 1.

> [SNIP]
>> Yes, except for fallback paths and bootup self tests we simply never wait
>> for fences while holding locks.
> That's not what I meant with "are you sure". Did you enable the
> cross-release stuff (after patching the bunch of leftover core kernel
> issues still present), annotate dma_fence with the cross-release stuff,
> run a bunch of multi-driver (amdgpu vs i915) dma-buf sharing tests and
> weep?

Ok, what exactly do you mean with cross-release checking?

> I didn't do the full thing yet, but just within i915 we've found tons of
> small little deadlocks we never really considered thanks to cross release,
> and that wasn't even including the dma_fence annotation. Luckily nothing
> that needed a full-on driver redesign.
>
> I guess I need to ping core kernel maintainers about cross-release again.
> I'd much prefer if we could validate ->invalidate_mapping and the
> locking/fence dependency issues using that, instead of me having to read
> and understand all the drivers.
[SNIP]
> I fear that with the ->invalidate_mapping callback (which inverts the
> control flow between importer and exporter) and tying dma_fences into all
> this it will be a _lot_ worse. And I'm definitely too stupid to understand
> all the dependency chains without the aid of lockdep and a full test suite
> (we have a bunch of amdgpu/i915 dma-buf tests in igt btw).

Yes, that is also something I worry about.

Regards,
Christian.
