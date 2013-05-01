Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f179.google.com ([209.85.210.179]:61550 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759100Ab3EAK0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 May 2013 06:26:03 -0400
Received: by mail-ia0-f179.google.com with SMTP id p22so1231246iad.38
        for <linux-media@vger.kernel.org>; Wed, 01 May 2013 03:26:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51785024.40305@codeaurora.org>
References: <51785024.40305@codeaurora.org>
Date: Wed, 1 May 2013 12:26:01 +0200
Message-ID: <CAKMK7uE5HQs7JoyVp8HbOzQ4PM=mOW3=WpRtFUzvy3NJ49nYgQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] RFC: Unified DMA allocation algorithms
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	rob clark <robclark@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 24, 2013 at 11:35 PM, Laura Abbott <lauraa@codeaurora.org> wrote:
> Hi all,
>
> I've been looking at a better way to do custom dma allocation algorithms in
> a similar style to Ion heaps. Most drivers/clients have come up with a
> series of semi-standard ways to get memory (CMA, memblock_reserve,
> discontiguous pages etc.) . As these allocation schemes get more and more
> complex, there needs to be a since place where all clients (Ion based driver
> vs. DRM driver vs. ???)  can independently take advantage of any
> optimizations and call a single API for the backing allocations.
>
> The dma_map_ops take care of almost everything needed for abstraction
> but the question is where should new allocation algorithms be located?
> Most of the work has been added to either arm/mm/dma-mapping.c or
> dma-contiguous.c . My current thought:
>
> 1) split out the dma_map_ops currently in dma-mapping.c into separate files
> (dma-mapping-common.c, dma-mapping-iommu.c)
> 2) Extend dma-contiguous.c to support memblock_reserve memory
> 3) Place additional algorithms in either arch/arm/mm or
> drivers/base/dma-alloc/ as appropriate to the code. This is the part where
> I'm most unsure about the direction.
>
> I don't have anything written yet but I plan to draft some patches assuming
> the proposed approach sounds reasonable and no one else has started on
> something similar already.
>
> Thoughts? Opinions?

>From my (oblivious to all the arm madness) pov the big thing is
getting dma allocations working for more than one struct device. This
way we could get rid of to "where do I need to allocate buffers"
duplication between the kernel and userspace (which needs to know that
to pick the right ion heap), which is my main gripe with ion ;-)

Rob Clark sent out a quick rfc for that a while back:

http://lists.linaro.org/pipermail/linaro-mm-sig/2012-July/002250.html

But that's by far not good enough for arm, especially now that cma
gets tightly bound to individual devices with the dt bindings. Also,
no one really followed up on Rob's patches, and personally I don't
really care that much since x86 is a bit saner ... But it should be
good enough for contiguous allocations, which leaves only really crazy
stuff unsolved.

So I think when you want to rework the various algorithms for
allocating dma mem and consolidate them it should also solve this
little multi-dev issue.

Adding tons more people/lists who might be interested.

Cheers, Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
