Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35885 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3FYJXW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 05:23:22 -0400
Received: by mail-ie0-f181.google.com with SMTP id x12so27521616ief.12
        for <linux-media@vger.kernel.org>; Tue, 25 Jun 2013 02:23:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130618104613.GX2718@n2100.arm.linux.org.uk>
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com>
	<1371467722-665-1-git-send-email-inki.dae@samsung.com>
	<51BEF458.4090606@canonical.com>
	<012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com>
	<20130617133109.GG2718@n2100.arm.linux.org.uk>
	<CAAQKjZO_t_kZkU46bUPTpoJs_oE1KkEqS2OTrTYjjJYZzBf+XA@mail.gmail.com>
	<20130617154237.GJ2718@n2100.arm.linux.org.uk>
	<CAKMK7uECS=eqNB-Ud6s=NvdYMPfxgJaGPbUx9hANfP6kb02j_w@mail.gmail.com>
	<20130618104613.GX2718@n2100.arm.linux.org.uk>
Date: Tue, 25 Jun 2013 11:23:21 +0200
Message-ID: <CAKMK7uEbkKWFcxu6zs+0P26S9aJrE5v2+b6Jzg7AhORsAg4+9w@mail.gmail.com>
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization framework
From: Daniel Vetter <daniel@ffwll.ch>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Inki Dae <daeinki@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Rob Clark <robdclark@gmail.com>,
	"myungjoo.ham" <myungjoo.ham@samsung.com>,
	YoungJun Cho <yj44.cho@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 18, 2013 at 12:46 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>> > Note: the existing stuff does have the nice side effect of being able
>> > to pass buffers which do not have a struct page * associated with them
>> > through the dma_buf API - I think we can still preserve that by having
>> > dma_buf provide a couple of new APIs to do the SG list map/sync/unmap,
>> > but in any case we need to fix the existing API so that:
>> >
>> > dma_buf_map_attachment() becomes dma_buf_get_sg()
>> > dma_buf_unmap_attachment() becomes dma_buf_put_sg()
>> >
>> > both getting rid of the DMA direction argument, and then we have four
>> > new dma_buf calls:
>> >
>> > dma_buf_map_sg()
>> > dma_buf_unmap_sg()
>> > dma_buf_sync_sg_for_cpu()
>> > dma_buf_sync_sg_for_device()
>> >
>> > which do the actual sg map/unmap via the DMA API *at the appropriate
>> > time for DMA*.
>>
>> Hm, my idea was to just add a dma_buf_sync_attchment for the device side
>> syncing, since the cpu access stuff is already bracketed with the
>> begin/end cpu access stuff. We might need a sync_for_cpu or so for mmap,
>> but imo mmap support for dma_buf is a bit insane anyway, so I don't care
>> too much about it.
>>
>> Since such dma mappings would be really longstanding in most cases anyway
>> drivers could just map with BIDIRECTIONAL and do all the real flushing
>> with the new sync stuff.
>
> Note that the DMA API debug doesn't allow you to change the direction
> argument on an existing mapping (neither should it, again this is
> documented in the DMA API stuff in Documentation/).  This is where you
> would need the complete set of four functions I mention above which
> reflect the functionality of the DMA API.

[Been travelling a bit, hence the delay.]

Just a quick question on your assertion that we need all four
functions: Since we already have begin/end_cpu_access functions
(intention here was to allow the dma_buf exporter to ensure the memory
is pinned, e.g. for swapable gem objects, but also allow cpu cache
flushing if required) do we still need the sync_sg_for_cpu? At least
with i915 as the exporter we currently hide the cflushing behind our
begin_cpu_access callback. For device dma we currently punt on it due
to lack of the dma_buf_sync_sg_for_device interface.

Aside: I know that i915 doing the clflushing dance itself is a bit
ugly, but thus far we've been the only guys on the x86 block with
non-coherent dma. But it sounds like a bunch of other blocks on Atom
SoCs have similar needs, so I guess it would make sense to move that
into the dma layer.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
