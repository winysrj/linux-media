Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53307 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2A3Q3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 11:29:34 -0500
Received: by werb13 with SMTP id b13so3614007wer.19
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2012 08:29:33 -0800 (PST)
Date: Mon, 30 Jan 2012 17:29:31 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, rob@ti.com,
	patches@linaro.org
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Message-ID: <20120130162931.GA4360@phenom.ffwll.local>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
 <201201231154.21006.laurent.pinchart@ideasonboard.com>
 <20120124130322.GD3980@phenom.ffwll.local>
 <201201301544.22168.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201301544.22168.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 30, 2012 at 03:44:20PM +0100, Laurent Pinchart wrote:
> Hi Daniel,
> 
> On Tuesday 24 January 2012 14:03:22 Daniel Vetter wrote:
> > On Mon, Jan 23, 2012 at 11:54:20AM +0100, Laurent Pinchart wrote:
> > > On Monday 23 January 2012 11:35:01 Daniel Vetter wrote:
> > > > See my other mail, dma_buf v1 does not support cpu access.
> > > 
> > > v1 is in the kernel now, let's start discussing v2 ;-)
> > 
> > Ok, I'm in ;-)
> > 
> > I've thought a bit about this, and I think a reasonable next step would be
> > to enable cpu access from kernelspace. Userspace and mmap support is a hole
> > different beast altogether and I think we should postpone that until we've
> > got the kernel part hashed out.
> 
> Userspace access through mmap can already be handled by the subsystem that 
> exports the buffer, so I'm fine with postponing implementing this inside dma-
> buf.

Actually I think the interface for mmap won't be that horribly. If we add
a bit of magic clue so that the exporter can intercept pagefaults we
should be able to fake coherent mmaps in all cases. And hence avoid
exposing importers and userspace to a lot of ugly things.

> > I'm thinking about adding 3 pairs of function to dma_buf (not to
> > dma_buf_attachment).
> > 
> > dma_buf_get_backing_storage/put_backing_storage
> > This will be used before/after kernel cpu access to ensure that the
> > backing storage is in memory. E.g. gem objects can be swapped out, so
> > they need to be pinned before we can access them. For exporters with
> > static allocations this would be a no-op.
> > 
> > I think a start, length range would make sense, but the exporter is free
> > to just swap in the entire object unconditionally. The range is specified
> > in multiples of PAGE_SIZE - I don't think there's any usescase for a
> > get/put_backing_storage which deals in smaller units.
> > 
> > The get/put functions are allowed to block and grab all kinds of looks.
> > get is allowed to fail with e.g. -ENOMEM.
> > 
> > dma_buf_kmap/kunmap
> > This maps _one_ page into the kernels address space and out of it. This
> > function also flushes/invalidates any caches required. Importers are not
> > allowed to map more than 2 pages at the same time in total (to allow
> > copies). This is because at least for gem objects the backing storage can
> > be in high-mem.
> > 
> > Importers are allowed to sleep while holding such a kernel mapping.
> > 
> > These functions are not allowed to fail (like kmap/kunmap).
> > 
> > dma_buf_kmap_atomic/kunmap_atomic
> > For performance we want to also allow atomic mappigns. Only difference is
> > that importers are not allowed to sleep while holding an atomic mapping.
> > 
> > These functions are again not allowed to fail.
> > 
> > Comments, flames?
> 
> Before commenting (I don't plan on flaming :-)), I'd like to take a small step 
> back. Could you describe the use case(s) you think of for kernel mappings ?

One is simply for devices where the kernel has to shove around the data -
I've heard some complaints in the v4l dma_buf threads that this seems to
be dearly in need. E.g. when the v4l devices is attached to usb or behind
another slow(er) bus where direct dma is not possible.

The other is that currently importers are 2nd class citizens and can't do
any cpu access. Making kernel cpu access would be the first step
(afterswards getting mmap working for userspace cpu access). Now for some
simple use-case we can just say "use the access paths provided by the
exporter". But for gpu drivers this gets really ugly because the
upload/download paths aren't standardized within drm/* and they're all
highly optimized. So to make buffer sharing possible among gpu's we need
this - the current gem prime code just grabs the underlying struct page
with sg_page and horribly fails if that doesn't work ;-)

On my proposal itself I think I'll change get/put_backing_storage to
begin/end_cpu_access - these functions must also do any required flushing
to ensure coherency (besides actually grabbing the backing storage). So I
think that's a better name.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
