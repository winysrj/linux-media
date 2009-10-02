Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57112 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbZJBQGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 12:06:51 -0400
From: "David F. Carlson" <dave@chronolytics.com>
Message-Id: <200910021603.n92G3elB032227@chronolytics.com>
Subject: Re: Global Video Buffers Pool - PMM and UPBuffer reference drivers [RFC]
To: m.szyprowski@samsung.com (Marek Szyprowski)
Date: Fri, 2 Oct 2009 12:03:40 -0400 (EDT)
Cc: linux-media@vger.kernel.org (linux-media@vger.kernel.org),
	linux-arm-kernel@lists.infradead.org (linux-arm-kernel@lists.infradead.org),
	kyungmin.park@samsung.com (kyungmin.park@samsung.com),
	t.fujak@samsung.com (Tomasz Fujak)
In-Reply-To: <E4D3F24EA6C9E54F817833EAE0D912AC077151C44B@bssrvexch01.BS.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I am not a fan of the large and static driver based bootmem allocations in the 
samsung-ap-2.6 git.  This work at least addresses that issue.  Thanks.

Below are some comments.  Perhaps I am not "getting it".

According to Marek Szyprowski:
> 
> algorithm itself would typically be changed to fit a usage pattern.
> 
> In our solution all memory buffers are all allocated by user-space
> applications, because only user applications have enough information
> which devices will be used in the video processing pipeline. For
> example:
> 
> MFC video decoder -> Post Processor (scaler and color space converter)
>  -> Frame Buffer memory.
> 
> If such a translation succeeds the
> physical memory region will be properly locked and is guaranteed to be
> in the memory till the end of transaction. Each transaction must be
> closed by the multimedia device driver explicitly.

Since this is a *physical* memory manager, I would never expect the memory
to not be in memory... 

> 
> 
> Technical details
> -----------------
> 
> 1. Physical memory allocation
> 
> PMM reserves the contiguous physical memory with bootmem kernel
> allocator. A boot parameter is used to provide information how much
> memory should be allocated, for example: adding a 'pmm=32M' parameter
> would reserve 32MiB of system memory on system boot.
> 
> 2. Allocating a buffer from userspace
> 
> PMM provides a /dev/pmm special device. Each time the application wants
> to allocate a buffer it opens the /dev/pmm special file, calls
> IOCTL_PMM_ALLOC ioctl and the mmaps it into its virtual memory. The
> struct pmm_area_info parameter for IOCTL_PMM_ALLOC ioctl describes the
> memory requirements for the buffer (please refer to
> include/linux/s3c/pmm.h) - like buffer size, memory alignment, memory
> type (PMM supports different memory types, although currently only one
> is used) and cpu cache coherency rules (memory can be mapped as
> cacheable or non-cacheable). The buffer is freed when the file
> descriptor reference count reaches zero (so the file is closed, is
> unmmaped from applications memory and released from multimedia devices).

I prefer using mmap semantics with a driver than messes with *my* address
space.  Ioctls that mess with my address space gives me hives.  

mmap is the call a user makes to map a memory/file object into its space.
ioctl is for things that don't fit read/write/mmap.  :-)

1.  memory alignment will be page size 4k (no?).  Or are you suggesting
larger alignment requirements?  Are any of the target devices 24 bit dma
clients?  (Crossing a 16MB boundary would then not work...)

2. Since these buffers will be dma sources/targets, cache will be off (no?)

Many CPUs ldr/stm memcpy do burst access to DDR so non-cached is still pretty 
zipping for non-bit banging apps.  Forcing non-cached makes much of the "sync" 
semantic you have "go away".

Is there a use-case for cached graphics controller memory that I am missing?


> 3. Buffer locking
> 
> If user application performed a mmap call on some special device and a
> driver mapped some physical memory into user address space (usually with
> remap_pfn_range function), this will create a vm_area structure with
> VM_PFNMAP flag set in user address space map. UPBuffer layer can easily
> perform a reverse mapping (virtual address to physical memory address)
> by simply reading the PTE values and checking if it is contiguous in
> physical memory. The only problem is how to guarantee the security of
> this solution. VM_PFNMAP-type areas do not have associated page
> structures so that memory pages cannot be locked directly in page cache.
> However such memory area would not be freed until the special file that
> is behind it is still in use. We found that is can be correctly locked
> by increasing reference counter of that special file (vm_area->vm_file).
> This would lock the mapping from being freed if user would accidently do
> something really nasty like unmapping that area.

I am still missing it.  Your /dev/pmm is allocating *physical memory* -- which
it (the pmm) owns for all time (bootmem).  If the user unmaps it, it is still 
pmm's physical memory.  

Now, returning the allocated memory to the pmm freelist
requires both the source and target to relinquish.  That implies both drivers 
"know" to relinquish on last-close.  Otherwise, you leak like a sieve.

Returning the pmm memory to the freelist when the user unmaps means that 
dma registers in HW still reference that memory.  Only the driver knows 
when it is "done".

Drivers "own" the PMM lifecycle.  Users get transient mappings.


> 7. SYSV SHM integration
> 
SysV shm is a nice touch.  Good job.

Re: configuration
There are quite a few CONFIG variables.  Forcing s3c-mm drivers to use PMM
would knock quite a few of them out.

You have presented a very flexible, general purpose bootmem allocator/mapper.
(cache/uncached, bounce/pmm, etc.)

The problem you were trying to solve is a means to generalize multiple 
compile-time fixed bootmem allocations at runtime.

Perhaps this could be simplified to fix that problem by assuming that 
all users (including the s3c-fb driver) would use a simple non-cached 
pmm allocator so that all allocations would be pooled.

I would advocate "hiding" pmm allocations within the s3c-mm drivers.  
Each driver could test user buffers for "isPMM()" trivially since the 
bootmem is physically contig.

What is the advantage in exporting the pmm API to user-space?

David F. Carlson    Chronolytics, Inc.  Rochester, NY
mailto:dave@chronolytics.com            http://www.chronolytics.com

"The faster I go, the behinder I get." --Lewis Carroll
