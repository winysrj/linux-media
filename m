Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:63630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab1BUJIP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 04:08:15 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 1E21A189B7F
	for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 10:08:13 +0100 (CET)
Date: Mon, 21 Feb 2011 10:08:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC] video-buffer management optimizations
Message-ID: <Pine.LNX.4.64.1102210940110.26977@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Agenda:
=======

User-space applications need more flexibility in managing their video-
(multimedia-) buffers to achieve their goals. A popular example is a photo-
camera with a preview. Currently the application has to first enter the
preview mode:

* set the preview format
* allocate buffers (if they are allocated in the kernel, i.e., per MMAP, their
  size will be calculated, based on frame size and pixel format). If the READ or
  the USERPTR method is used, the buffer allocation task is handled in the user-
  space.
* queue buffers
* start streaming

Then, at some point during the running preview, the user presses the release
button, at which time the application has to

* stop streaming
* free the queue (REQBUFS with .count = 0)
* set the still image format
* allocate buffers
* queue buffers
* start streaming

The above switching takes a long time. A part of it comes from having to wait
for the current frame completion. A reasonable preview can be expected to run
at 25 / 30fps, i.e., spend 40 / 33ms per frame. The second component,
contributing to the delay, is the memory management. Depending on the type of
memory used and the camera resolution and the data format, it can take hundreds
of milliseconds to switch to a new buffer queue.

Another popular use-case is passing buffers between hardware entities with
or without intermediate data processing in the user-space. Depending, whether
CPU processing is required or not, caches do or do not have to be invalidated.
In this case buffers have to either be allocated from a globally-accessible pool
(buffer pool), or USERPTR or READ has to be used. Presently, no such global pool
solution exists in the kernel, and allocating buffers in user-space does not
normally support specifying caching requirements.

Further, in some cases performance can be critical for the applpication, in
others it might be essential to try to save memory.

Goals:
======

Minimize the delay by eliminating expansive memory allocation and cache
invalidation operations.

Possible memory configurations and requirements:
================================================

Currently there are three videobuffer management algorithms in the kernel:

* VMALLOC
* DMA_CONTIG
* DMA_SG

in videobuf version 1 and 2. Both DMA_* helpers are, logically, used, when DMA
is used to fill buffers. DMA_SG buffers are allocated with a page-size
granularity, which makes their reuse simple. DMA_CONTIG buffers are more
difficult to allocate (without an IOMMU) and to re-use for different frame sizes
due to likely memory fragmentation.

Further, there are three ways in which data can be retrieved by applications:

* using mmap(2) with buffers of type V4L2_MEMORY_MMAP
* using user-space buffers of type V4L2_MEMORY_USERPTR
* using read(2) with generic user-space memory

Finally, the obtained data can be used in one of the following two ways:

* using CPU once to read out the data
* using CPU multiple times to process the data in-place
* passing them further to other bus-masters for hardware processing / output

If the cpu-access is required, cache has to be invalidated before passing
buffers back to the user per DQBUF or upon queuing them per QBUF. If the buffers
have to be accessed only ones by the CPU, it might be better to allocate buffers
in uncached memory and let applications try to compensate uncached access by
implementing some low-level optimizations. OTOH, even in this case applications
can benefit from pre-fetching the data a cache-line at a time. Generally,
using non-coherent DMA-able contiguous memory and implementing a suitable cache
management seems to be preferable over using coherent memory.

Use-cases:
==========

The most interesting case for us, is when the buffers are allocated in the V4L
driver context, i.e., the V4L2_MEMORY_MMAP method is used.

Example 1:
----------

MMAP, DMA-Contiguous, CPU access required, optimize for performance.

Best result is achieved by pre-allocating and pre-queuing two buffer sizes.
Pre-queuing them eliminates the expensive cache invalidation when switching to
the still image mode. Switching is then performed in the following steps:

* stop streaming
* switch to the big-buffer queue
* set the still image format
* start streaming

Required extensions:

1. allocate multiple queues per device
2. switch between queues
3. specify buffer size explicitly, before the image format is known to the
   driver

Example 2:
----------

MMAP, DMA-Contiguous, CPU access required, optimize for memory.

In this case we can sacrifice some performance, by taking the cache-invalidation
hit, but save memory by re-using the buffers. The easiest case - allocate a huge
chunk of memory, use it either for smaller, or for bigger buffers. CMA can be
useful for this. The advantage is, that new buffers do not have to be allocated,
only the same chunk of memory shall be split into differently sized buffers. A
single buffer queue shall be used.

Required extensions:

REQBUFS shall be extended to take a "persistent" flag. If set, the following
REQBUFS(0) will not release buffers, but keep the memory for a possible
re-use with the new format. If impossible, then it shall free the old buffers
and allocate new ones. If supported by the specific driver, it can also decide
to use CMA.

Example 3:
----------

MMAP, DMA-Contiguous, no CPU access required, optimize for performance.

Since no CPU access is required, and therefore no cache invalidation, persistent
buffers can be used without a major performance hit. So, either of the above two
schemes - with a single or with multiple queues - can be used. Additionally,
the driver has to be instructed to skip cache-invalidation.

Required extensions:

It has to be possible, to tell the driver to skip cache-invalidation

Example 4:
----------

MMAP, DMA-Contiguous, no CPU access required, optimize for memory.

Skip cache-invalidation, if possible - re-use buffers, otherwise re-allocate
them, single queue.

Example 5:
----------

MMAP, DMA-SG.

Cache-invalidation and multiple queues can be used exactly as with contiguous
buffers, depending on the use-pattern. Memory re-use becomes easier even
without CMA, due to smaller single buffers.

Example 6:
----------

MMAP, VMALLOC.

VMALLOC is usually used either by virtual drivers like vivi.c, or by USB camera
drivers, in which case the actual memory, used to transfer the data from the
camera is managed by the USB layer, and the V4L driver uses the CPU to possibly
process the data and copy it into the buffers. Performance can be improved by
avoiding buffer re-allocation during the switch by either using two queues or
re-using the memory.

Example 7:
----------

USERPTR.

The "skip cache-invalidate" flag and multiple queues can be used to improve
performance. CMA and other kinds of memory re-use can only be used on modules,
where the memory has originally been allocated.

Example 8:
----------

READ.

Only the "skip cache-invalidate" flag makes sense.

Conclusion.
===========

The following functionality is required to support optimizations, described
above:

1. multiple video-buffer queues per device / filehandle: their allocation and
   switching between them.
2. either the above queue-alloc method, or for the VIDIOC_REQBUFS ioctl() has to
   accept an explicit "buffer-size" parameter
3. a "skip-cache-invalidate" flag for the above queue-alloc method, or for the
   VIDIOC_REQBUFS ioctl()
4. a "persistent" flag for VIDIOC_REQBUFS for buffer re-use

References.
===========

An earlier RFC [1] addresses some of the issues described here, but attacks them
from a slightly different angle. None the less, "global video buffers pools,"
described there, can be used, e.g., as a backing solution for some of the
proposed extensions.

The Contiguous Memory Allocator has last been submitted in v8 on 15 December
2010 [2].

[1] http://lwn.net/Articles/353043/
[2] http://thread.gmane.org/gmane.linux.kernel.mm/56855

Please, comment.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
