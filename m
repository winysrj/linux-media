Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38382 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab0EYMeh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 08:34:37 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L2Z009UV6XNLB@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 May 2010 13:34:35 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L2Z000JK6XMXT@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 May 2010 13:34:34 +0100 (BST)
Date: Tue, 25 May 2010 14:33:53 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [RFC] Memory allocation requirements, videobuf integration,
 pluggable allocators
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Message-id: <003501cafc06$894f0120$9bed0360$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this RFC concerns video buffer allocation in videobuf, as well as in V4L in
general.

Its main purpose is to discuss issues, gather comments and specific
requirements, proposals and ideas for allocation mechanisms from
interested parties.

Background
======================
V4L drivers use memory buffers for storing video/media data, such as video
frames. There are many different ways to acquire such memory and devices may
have special requirements for it. Further handling of it also differs between
drivers.

Typical ways of acquiring memory for media devices include:
- allocating a number of non-contiguous pages (e.g. alloc_page)
- acquiring a number of physically contiguous pages:
  * bootmem allocation
  * other custom solutions?
- allocating virtually contiguous memory (vmalloc)
- device-specific/private/on-board memory
- others?

The above examples are quite standard, but just to give you an idea of more
exotic cases:
- allocation of memory from specific memory banks
- allocation of buffers in a particular arrangement
- allocation with specific CPU flags, etc.

If the above sounds too unrealistic/too abstract to you: these are the actual
requirements for our (Samsung) devices.

Furthermore, there might be some additional considerations:
- VM_PFNMAP memory - may need additional refcounting
- how to handle problems with remapping memory with different flags
- others?

Of course, freeing can also be handled in a plethora of ways.

Moreover, related to the above are specific operations that may have to be
performed, such as syncing caches, page pinning, etc.


Motivation
======================
Videobuf framework memory-type code (videobuf-vmalloc, videobuf-dma-sg,
videobuf-dma-contig) has been created to help developers in some of the
above-mentioned case. Unfortunately, I see the following main, inherent
problems with it:

- memory allocation is performed in videobuf code in a fixed way. There is
  no way for drivers to override this; e.g., dma_alloc_coherent is used for
  dma-contig memory,

- it is performed during mmap (dma-contig, vmalloc) or even on VM fault
  sometimes (dma-sg); this does not conform to the V4L2 API, which states
  that allocation should be done on REQBUFS call,

- freeing is not centralized (it is also performed on STREAMOFF, which is
  really bad, but this is a topic for a separate RFC)

This prevents driver developers from using videobuf, sometimes they just use
parts of it, add custom/incompatible modifications, or are, as a matter of fact,
"forced" to duplicate parts of its code. Some drivers are dependent on
boot-time allocation mechanisms. Examples include (apologies to the authors
if I am mistaken here):

- Intel Moorestown
- OMAP
- multimedia devices in Samsung SoCs- drivers are not yet posted for the sole
  reason that we need a bootmem-based allocator mechanism, which is hard to have
  accepted. Custom allocators in kernel for every platform/device are not
  received well, for good reasons.
- others?

>From various discussions I believe that there are more parties interested in
having custom memory allocation mechanisms. Moreover, the current situation in
videobuf calls for fixing (e.g. allocation should be performed on REQBUFS).



A request for requirements, ideas and comments
================================================
We would like to change this situation. Before proposing anything, we would like
to first gather:

- device-specific requirements and, possibly, peculiarities,
- more general ideas and requirements for a generic allocator framework
  for media devices,
- a list of devices that would benefit from this,
- a list of drivers that do not use videobuf because of problems with adapting
  to its memory allocation scheme.

They do not have to be videobuf-specific, although we would like to integrate
the resulting solution with either the current videobuf, or its future rework.

To clarify, I am mainly trying to gather requirements for videobuf or similar
frameworks to introduce a generic interface for plugging-in custom memory
allocation mechanisms, not really trying to implement a solving-world-hunger
memory allocator.

There is also the topic of a video buffer pool, discussed last year. How it
relates to this topic and its integration (in any form) with videobuf could
also be of interest here.


I will be grateful for any comments, thoughts or ideas. Thank you!


=========================

Below is a (hopefully complete) list of required features for Samsung multimedia
devices, related to memory allocation:

- physically contiguous memory buffers of different sizes (up to several
  megabytes)
- memory allocation from particular memory banks (ranges of physical addresses)
- partitioning areas of memory into custom zones and an ability to allocate from
  a chosen zone
- an ability to share memory buffers across different devices in a pipeline
- automatic video buffer allocation from videobuf is the main use case, but
  direct access to the memory allocator from drivers (for temporary buffers,
  firmware etc.) is also required
- ability to pre-configure allocator behavior by drivers

Some nice-to-have features:

- pluggable memory allocation strategies
- cacheable/non-cacheable buffers
- CPU cache synchronization for non-coherent areas
- support for VM_PFNMAP memory, such as framebuffer memory, etc. (alternative
  methods of reference counting required)
- shared memory (shmem) support, zero-copy X server interoperability
- support for contiguous memory allocated by userspace, including contiguity
  checks and (maybe) bounce buffers
- usage/fragmentation statistics

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center




