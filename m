Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:51162 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbZJFIN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2009 04:13:27 -0400
Received: from epmmp2 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KR300EDA2SH99@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2009 17:12:17 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KR3000CZ2SCD5@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2009 17:12:17 +0900 (KST)
Date: Tue, 06 Oct 2009 10:10:45 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Global Video Buffers Pool - PMM and UPBuffer reference drivers
 [RFC]
In-reply-to: <200910021603.n92G3elB032227@chronolytics.com>
To: "'David F. Carlson'" <dave@chronolytics.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <002301ca465c$841cdca0$8c5695e0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C44B@bssrvexch01.BS.local>
 <200910021603.n92G3elB032227@chronolytics.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, October 02, 2009 6:04 PM David F. Carlson wrote:

> I am not a fan of the large and static driver based bootmem allocations in the
> samsung-ap-2.6 git.  This work at least addresses that issue.  Thanks.
> 
> Below are some comments.  Perhaps I am not "getting it".
> 
> According to Marek Szyprowski:
> >
> > algorithm itself would typically be changed to fit a usage pattern.
> >
> > In our solution all memory buffers are all allocated by user-space
> > applications, because only user applications have enough information
> > which devices will be used in the video processing pipeline. For
> > example:
> >
> > MFC video decoder -> Post Processor (scaler and color space converter)
> >  -> Frame Buffer memory.
> >
> > If such a translation succeeds the
> > physical memory region will be properly locked and is guaranteed to be
> > in the memory till the end of transaction. Each transaction must be
> > closed by the multimedia device driver explicitly.
> 
> Since this is a *physical* memory manager, I would never expect the memory
> to not be in memory...

The memory cannot be swapped to disk, but notice that PMM is also an allocator.
It must track which regions has been allocated and free them when are no
longer in use.

> > 2. Allocating a buffer from userspace
> >
> > PMM provides a /dev/pmm special device. Each time the application wants
> > to allocate a buffer it opens the /dev/pmm special file, calls
> > IOCTL_PMM_ALLOC ioctl and the mmaps it into its virtual memory. The
> > struct pmm_area_info parameter for IOCTL_PMM_ALLOC ioctl describes the
> > memory requirements for the buffer (please refer to
> > include/linux/s3c/pmm.h) - like buffer size, memory alignment, memory
> > type (PMM supports different memory types, although currently only one
> > is used) and cpu cache coherency rules (memory can be mapped as
> > cacheable or non-cacheable). The buffer is freed when the file
> > descriptor reference count reaches zero (so the file is closed, is
> > unmmaped from applications memory and released from multimedia devices).
> 
> I prefer using mmap semantics with a driver than messes with *my* address
> space.  Ioctls that mess with my address space gives me hives.
> 
> mmap is the call a user makes to map a memory/file object into its space.
> ioctl is for things that don't fit read/write/mmap.  :-)

Well, maybe I didn't write it clear enough. You allocate a buffer with
custom ioctl and then map it with mmap() call. So the sequence of the calls
is as follows:

struct pmm_mem_info info = {
	.magic = PMM_MAGIC,
	.size = BUFFER_SIZE,
	.type = PMM_MEM_GENERAL,
	.flags = PMM_NO_CACHE,
	.alignment = 0x1000,
};

fd = open(/dev/pmm);
ioctl(fd, IOCTL_PMM_ALLOC, &info);
mmap(0, BUFFER_SIZE, 0777, MAP_SHARED, fd, 0);
close(fd);

> 1.  memory alignment will be page size 4k (no?).  Or are you suggesting
> larger alignment requirements?  Are any of the target devices 24 bit dma
> clients?  (Crossing a 16MB boundary would then not work...)

You can set the alignment in pmm_mem_info structure.

> 2. Since these buffers will be dma sources/targets, cache will be off (no?)

You can control weather to use cache or not on the buffer region with special
flags provided to alloc ioctl. In case o cacheable mapping, the upbuffer
translation layer would do proper cache synchronization (flush/clean/invalidate)
basing on the type of operation that the driver wants to perform (please refer
to include/linux/s3c/upbuffer.h)

> Many CPUs ldr/stm memcpy do burst access to DDR so non-cached is still pretty
> zipping for non-bit banging apps.  Forcing non-cached makes much of the "sync"
> semantic you have "go away".
> 
> Is there a use-case for cached graphics controller memory that I am missing?

Yes, you may want to perform some of the gfx transformations by the cpu (in
case they are for example not available in the hardware). If the buffer is
mapped as non-cacheable then all cpu read opeations will be really slow.

> > 3. Buffer locking
> >
> > If user application performed a mmap call on some special device and a
> > driver mapped some physical memory into user address space (usually with
> > remap_pfn_range function), this will create a vm_area structure with
> > VM_PFNMAP flag set in user address space map. UPBuffer layer can easily
> > perform a reverse mapping (virtual address to physical memory address)
> > by simply reading the PTE values and checking if it is contiguous in
> > physical memory. The only problem is how to guarantee the security of
> > this solution. VM_PFNMAP-type areas do not have associated page
> > structures so that memory pages cannot be locked directly in page cache.
> > However such memory area would not be freed until the special file that
> > is behind it is still in use. We found that is can be correctly locked
> > by increasing reference counter of that special file (vm_area->vm_file).
> > This would lock the mapping from being freed if user would accidently do
> > something really nasty like unmapping that area.
> 
> I am still missing it.  Your /dev/pmm is allocating *physical memory* -- which
> it (the pmm) owns for all time (bootmem).  If the user unmaps it, it is still
> pmm's physical memory.
> 
> Now, returning the allocated memory to the pmm freelist
> requires both the source and target to relinquish.  That implies both drivers
> "know" to relinquish on last-close.  Otherwise, you leak like a sieve.
>
> Returning the pmm memory to the freelist when the user unmaps means that
> dma registers in HW still reference that memory.  Only the driver knows
> when it is "done".

Exactly this is addressed by the UPBuffer translation layer. If application
unmaps the buffer from its address space the region is not freed unless the
multimedia driver explicitly unlocks it after the transaction. That is that
I called the buffer locking. Multimedia driver must lock the buffer before
performing any DMA transactions on it.
 
> Re: configuration
> There are quite a few CONFIG variables.  Forcing s3c-mm drivers to use PMM
> would knock quite a few of them out.

This was presented only as a reference. Don't take it too strictly.

> You have presented a very flexible, general purpose bootmem allocator/mapper.
> (cache/uncached, bounce/pmm, etc.)
> 
> The problem you were trying to solve is a means to generalize multiple
> compile-time fixed bootmem allocations at runtime.
> 
> Perhaps this could be simplified to fix that problem by assuming that
> all users (including the s3c-fb driver) would use a simple non-cached
> pmm allocator so that all allocations would be pooled.

I don't get this, could you elaborate?

> I would advocate "hiding" pmm allocations within the s3c-mm drivers.
> Each driver could test user buffers for "isPMM()" trivially since the
> bootmem is physically contig.
> 
> What is the advantage in exporting the pmm API to user-space?

Only user applications know what buffers will be required for the
processing they are performing and which of them they want to reuse
with other drivers. We decided to remove all buffers from the drivers
and allocate them separately in user space. This way no memory is wasted
to fixed buffers. Please note that the ability of SHARING the same buffer
between different devices is the key feature of this solution.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


