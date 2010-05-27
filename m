Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27683 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab0E0IiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 04:38:17 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Date: Thu, 27 May 2010 16:37:32 +0800
Subject: RE: [RFC] Memory allocation requirements, videobuf integration,
 pluggable allocators
Message-ID: <33AB447FBD802F4E932063B962385B351E9975EE@shsmsx501.ccr.corp.intel.com>
References: <003501cafc06$894f0120$9bed0360$%osciak@samsung.com>
 <19F8576C6E063C45BE387C64729E7394044E616AD4@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044E616AD4@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looking forward to the proposal. Indeed,  Intel Moorestown is suffered from the videobuf framework limitation. 

Xiaolin

-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Hiremath, Vaibhav
Sent: Wednesday, May 26, 2010 1:06 PM
To: Pawel Osciak; linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com; 'Marek Szyprowski'
Subject: RE: [RFC] Memory allocation requirements, videobuf integration, pluggable allocators


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Pawel Osciak
> Sent: Tuesday, May 25, 2010 6:04 PM
> To: linux-media@vger.kernel.org
> Cc: kyungmin.park@samsung.com; 'Marek Szyprowski'
> Subject: [RFC] Memory allocation requirements, videobuf integration,
> pluggable allocators
> 
> Hello,
> 
> this RFC concerns video buffer allocation in videobuf, as well as in V4L in
> general.
> 
> Its main purpose is to discuss issues, gather comments and specific
> requirements, proposals and ideas for allocation mechanisms from
> interested parties.
> 
[Hiremath, Vaibhav] Thanks Pawel for summarizing VideoBuf need into RFC.

> Background
> ======================
> V4L drivers use memory buffers for storing video/media data, such as video
> frames. There are many different ways to acquire such memory and devices may
> have special requirements for it. Further handling of it also differs
> between
> drivers.
> 
> Typical ways of acquiring memory for media devices include:
> - allocating a number of non-contiguous pages (e.g. alloc_page)
> - acquiring a number of physically contiguous pages:
>   * bootmem allocation
>   * other custom solutions?
> - allocating virtually contiguous memory (vmalloc)
> - device-specific/private/on-board memory
> - others?
> 
> The above examples are quite standard, but just to give you an idea of more
> exotic cases:
> - allocation of memory from specific memory banks
> - allocation of buffers in a particular arrangement
> - allocation with specific CPU flags, etc.
> 
> If the above sounds too unrealistic/too abstract to you: these are the
> actual
> requirements for our (Samsung) devices.
> 
> Furthermore, there might be some additional considerations:
> - VM_PFNMAP memory - may need additional refcounting
> - how to handle problems with remapping memory with different flags
> - others?
> 
[Hiremath, Vaibhav] We do have similar requirement for OMAP devices.

> Of course, freeing can also be handled in a plethora of ways.
> 
> Moreover, related to the above are specific operations that may have to be
> performed, such as syncing caches, page pinning, etc.
> 
> 
> Motivation
> ======================
> Videobuf framework memory-type code (videobuf-vmalloc, videobuf-dma-sg,
> videobuf-dma-contig) has been created to help developers in some of the
> above-mentioned case. Unfortunately, I see the following main, inherent
> problems with it:
> 
> - memory allocation is performed in videobuf code in a fixed way. There is
>   no way for drivers to override this; e.g., dma_alloc_coherent is used for
>   dma-contig memory,
> 
> - it is performed during mmap (dma-contig, vmalloc) or even on VM fault
>   sometimes (dma-sg); this does not conform to the V4L2 API, which states
>   that allocation should be done on REQBUFS call,
> 
> - freeing is not centralized (it is also performed on STREAMOFF, which is
>   really bad, but this is a topic for a separate RFC)
> 
> This prevents driver developers from using videobuf, sometimes they just use
> parts of it, add custom/incompatible modifications, or are, as a matter of
> fact,
> "forced" to duplicate parts of its code. Some drivers are dependent on
> boot-time allocation mechanisms. Examples include (apologies to the authors
> if I am mistaken here):
> 
> - Intel Moorestown
> - OMAP
[Hiremath, Vaibhav] Let me explain V4L2 Display allocation schema here,

We have defined module parameters, to specify buffer size and number of buffers which user can configure through boot argument or during module insert time.

Driver always keep this specified number of buffers until removed from system. That means we are not freeing memory (allocated during boot time) neither in streamoff nor in close API.

Since driver manages buffer allocation we are not using video-buf mmap_mapper function here, we have our own mmap_mapper function.

> - multimedia devices in Samsung SoCs- drivers are not yet posted for the
> sole
>   reason that we need a bootmem-based allocator mechanism, which is hard to
> have
>   accepted. Custom allocators in kernel for every platform/device are not
>   received well, for good reasons.
> - others?
> 
> From various discussions I believe that there are more parties interested in
> having custom memory allocation mechanisms. Moreover, the current situation
> in
> videobuf calls for fixing (e.g. allocation should be performed on REQBUFS).
> 
> 
> 
> A request for requirements, ideas and comments
> ================================================
> We would like to change this situation. Before proposing anything, we would
> like
> to first gather:
> 
> - device-specific requirements and, possibly, peculiarities,
> - more general ideas and requirements for a generic allocator framework
>   for media devices,
> - a list of devices that would benefit from this,
[Hiremath, Vaibhav] You can safely consider/add following TI devices,

OMAP2/3/4 (OMAP3/OAMP4) series of devices
Davinci series of devices
AM/DM37x series of devices 
Some future devices in this segment...

> - a list of drivers that do not use videobuf because of problems with
> adapting
>   to its memory allocation scheme.
[Hiremath, Vaibhav] As I mentioned we do use Video-Buf partially.
> 
> They do not have to be videobuf-specific, although we would like to
> integrate
> the resulting solution with either the current videobuf, or its future
> rework.
> 
> To clarify, I am mainly trying to gather requirements for videobuf or
> similar
> frameworks to introduce a generic interface for plugging-in custom memory
> allocation mechanisms, not really trying to implement a solving-world-hunger
> memory allocator.
> 
> There is also the topic of a video buffer pool, discussed last year. How it
> relates to this topic and its integration (in any form) with videobuf could
> also be of interest here.
> 
> 
> I will be grateful for any comments, thoughts or ideas. Thank you!
> 
> 
> =========================
> 
> Below is a (hopefully complete) list of required features for Samsung
> multimedia
> devices, related to memory allocation:
> 
> - physically contiguous memory buffers of different sizes (up to several
>   megabytes)
> - memory allocation from particular memory banks (ranges of physical
> addresses)
> - partitioning areas of memory into custom zones and an ability to allocate
> from
>   a chosen zone
> - an ability to share memory buffers across different devices in a pipeline
> - automatic video buffer allocation from videobuf is the main use case, but
>   direct access to the memory allocator from drivers (for temporary buffers,
>   firmware etc.) is also required
> - ability to pre-configure allocator behavior by drivers
> 
[Hiremath, Vaibhav] If you have anything in mind readily available on this, then I would suggest you to propose here in this forum for discussion.

Below are some suggestions or my opinions -
-------------------------------

1) Irrespective of this RFC, I think we should change the Video-Buf behavior where buffer allocation must happen in VIDIOC_REQBUF and not in MMAP.

2) It would be really nice if Video-Buf checks whether buffer is allocated by driver or not before allocating it, providing flexibility to driver to handle buffer allocation on his own.

3) I am thinking of thin layer which takes boot time argument specifying total buffer size for Video-Buf layer which is taken away from Linux kernel. Allocation will happen in VIDIOC_REQBUF and will be released either in streamoff/close API.

videobuf_size=40M

Video-buf layer will take away 40M from Linux kernel during boot time itself, then Video-buf layer manages/uses this pool for memory allocation.

Note: There are other issues which still need to be discussed as mentioned by Pawel in RFC like, cache, multiple drivers request with different sizes and stuff which defines complexity of this thin layer.

-------------------------------


Atleast from OMAP2/3 Display driver point of view, points 1 & 2 are important and will help driver to use completely standard Video-Buf API's.


Thanks,
Vaibhav

> Some nice-to-have features:
> 
> - pluggable memory allocation strategies
> - cacheable/non-cacheable buffers
> - CPU cache synchronization for non-coherent areas
> - support for VM_PFNMAP memory, such as framebuffer memory, etc.
> (alternative
>   methods of reference counting required)
> - shared memory (shmem) support, zero-copy X server interoperability
> - support for contiguous memory allocated by userspace, including contiguity
>   checks and (maybe) bounce buffers
> - usage/fragmentation statistics
> 
> Best regards
> --
> Pawel Osciak
> Linux Platform Group
> Samsung Poland R&D Center
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
