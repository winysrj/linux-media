Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46600 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3FZRTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 13:19:35 -0400
Date: Wed, 26 Jun 2013 18:18:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Vetter <daniel@ffwll.ch>
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
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
	framework
Message-ID: <20130626171849.GG2718@n2100.arm.linux.org.uk>
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com> <1371467722-665-1-git-send-email-inki.dae@samsung.com> <51BEF458.4090606@canonical.com> <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com> <20130617133109.GG2718@n2100.arm.linux.org.uk> <CAAQKjZO_t_kZkU46bUPTpoJs_oE1KkEqS2OTrTYjjJYZzBf+XA@mail.gmail.com> <20130617154237.GJ2718@n2100.arm.linux.org.uk> <CAKMK7uECS=eqNB-Ud6s=NvdYMPfxgJaGPbUx9hANfP6kb02j_w@mail.gmail.com> <20130618104613.GX2718@n2100.arm.linux.org.uk> <CAKMK7uEbkKWFcxu6zs+0P26S9aJrE5v2+b6Jzg7AhORsAg4+9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEbkKWFcxu6zs+0P26S9aJrE5v2+b6Jzg7AhORsAg4+9w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 25, 2013 at 11:23:21AM +0200, Daniel Vetter wrote:
> Just a quick question on your assertion that we need all four
> functions: Since we already have begin/end_cpu_access functions
> (intention here was to allow the dma_buf exporter to ensure the memory
> is pinned, e.g. for swapable gem objects, but also allow cpu cache
> flushing if required) do we still need the sync_sg_for_cpu?

Possibly not, but let's first look at that kind of scenario:

- It attaches to a dma_buf using dma_buf_attach()
- it maps the DMA buffer using dma_buf_map_attachment().  This does
  dma_map_sg().  This possibly incurs a cache flush depending on the
  coherence properties of the architecture.
- it then calls dma_buf_begin_cpu_access().  This presumably does a
  dma_sync_sg_for_cpu().  This possibly incurs another cache flush
  depending on the coherence properties of the architecture.
- then, presumably, it calls dma_buf_kmap_atomic() or dma_buf_kmap()
  to gain a pointer to the buffer.
- at some point, dma_buf_kunmap_atomic() or dma_buf_kunmap() gets
  called.  On certain cache architectures, kunmap_atomic() results in
  a cache flush.
- dma_buf_end_cpu_access() gets called, calling through presumably to
  dma_sync_sg_for_device().  Possibly incurs a cache flush.
- dma_buf_unmap_attachment()... another cache flush.

Out of those all of those five cache flushes, the only cache flush which is
really necessary out of all those would be the one in kunmap_atomic().  The
rest of them are completely irrelevant to the CPU access provided that there
is no DMA access by the device.  What's more is that you can't say "well,
the architecture should optimize them!" to which I'd respond "how does the
architecture know at dma_map_sg() time that there isn't going to be a
DMA access?"

Now, if we say that it's not necessary to call dma_buf_map_attachment()..
dma_buf_unmap_attachment() around the calls to dma_buf_begin_cpu_access()..
dma_buf_end_cpu_access(), then how does dma_buf_begin_cpu_access() know
whether the DMA buffer has been dma_map_sg()'d?  It's invalid to call
dma_sync_sg_for_cpu() on a buffer which has not been dma_map_sg()'d.
Bear in mind that dma_buf_begin_cpu_access() is passed only the
struct dma_buf and not the struct dma_buf_attachment *attach, there's
no hope for the begin_cpu_access() method to know which user of the
dma_buf is asking for this call, so you can't track any state there.

Thank you for pointing this out, I'm less impressed with this dma_buf
API now that I've looked deeper at those two interfaces, and even more
convinced it needs to be redesigned! :P
