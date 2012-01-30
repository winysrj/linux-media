Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54000 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab2A3OoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 09:44:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Date: Mon, 30 Jan 2012 15:44:20 +0100
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, rob@ti.com,
	patches@linaro.org
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com> <201201231154.21006.laurent.pinchart@ideasonboard.com> <20120124130322.GD3980@phenom.ffwll.local>
In-Reply-To: <20120124130322.GD3980@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201301544.22168.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Tuesday 24 January 2012 14:03:22 Daniel Vetter wrote:
> On Mon, Jan 23, 2012 at 11:54:20AM +0100, Laurent Pinchart wrote:
> > On Monday 23 January 2012 11:35:01 Daniel Vetter wrote:
> > > See my other mail, dma_buf v1 does not support cpu access.
> > 
> > v1 is in the kernel now, let's start discussing v2 ;-)
> 
> Ok, I'm in ;-)
> 
> I've thought a bit about this, and I think a reasonable next step would be
> to enable cpu access from kernelspace. Userspace and mmap support is a hole
> different beast altogether and I think we should postpone that until we've
> got the kernel part hashed out.

Userspace access through mmap can already be handled by the subsystem that 
exports the buffer, so I'm fine with postponing implementing this inside dma-
buf.

> I'm thinking about adding 3 pairs of function to dma_buf (not to
> dma_buf_attachment).
> 
> dma_buf_get_backing_storage/put_backing_storage
> This will be used before/after kernel cpu access to ensure that the
> backing storage is in memory. E.g. gem objects can be swapped out, so
> they need to be pinned before we can access them. For exporters with
> static allocations this would be a no-op.
> 
> I think a start, length range would make sense, but the exporter is free
> to just swap in the entire object unconditionally. The range is specified
> in multiples of PAGE_SIZE - I don't think there's any usescase for a
> get/put_backing_storage which deals in smaller units.
> 
> The get/put functions are allowed to block and grab all kinds of looks.
> get is allowed to fail with e.g. -ENOMEM.
> 
> dma_buf_kmap/kunmap
> This maps _one_ page into the kernels address space and out of it. This
> function also flushes/invalidates any caches required. Importers are not
> allowed to map more than 2 pages at the same time in total (to allow
> copies). This is because at least for gem objects the backing storage can
> be in high-mem.
> 
> Importers are allowed to sleep while holding such a kernel mapping.
> 
> These functions are not allowed to fail (like kmap/kunmap).
> 
> dma_buf_kmap_atomic/kunmap_atomic
> For performance we want to also allow atomic mappigns. Only difference is
> that importers are not allowed to sleep while holding an atomic mapping.
> 
> These functions are again not allowed to fail.
> 
> Comments, flames?

Before commenting (I don't plan on flaming :-)), I'd like to take a small step 
back. Could you describe the use case(s) you think of for kernel mappings ?

> If this sounds sensible I'll throw together a quick rfc over the next few
> days.
> 
> Cheers, Daniel
> 
> PS: Imo the next step after this would be adding userspace mmap support.
> This has the funky requirement that the exporter needs to be able to shot
> down any ptes before it moves around the buffer. I think solving that nice
> little problem is a good exercise to prepare us for solving similar "get
> of this buffer, now" issues with permanent device address space mappings
> ...

-- 
Regards,

Laurent Pinchart
