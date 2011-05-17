Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:62560 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277Ab1EQTA6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 15:00:58 -0400
Message-ID: <4DD2C6A1.50505@maxwell.research.nokia.com>
Date: Tue, 17 May 2011 22:04:01 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Subject: Notes on the Linaro memory management mini-summit, V4L2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Here are my own notes from the Linaro memory management mini-summit in
Budapest. I've written them from my own point of view, which is mostly
V4L2 in embedded devices and camera related use cases. I attempted to
summarise the discussion mostly concentrating into parts which I've
considered important and ignored the rest.


So please do not consider this as the generic notes of the mini-summit.
:-) I still felt like sharing this since it might be found useful by
those who are working with similar systems with similar problems.


Memory buffer management --- the future
=======================================

The memory buffer management can be split to following sub-problems
which may have dependencies, both in implementation and possibly in
the APIs as well:

- Fulfilling buffer allocation requirements
- API to allocate buffers
- Sharing buffers among kernel subsystems (e.g. V4L2, DRM, FB)
- Sharing buffers between processes
- Cache coherency

What has been agreed that we need kernel to recognise a DMA buffer
which may be passed between user processes and different kernel subsystems.

Fulfilling buffer allocation requirements
-----------------------------------------

APIs, as well as devices, have different requirements on the buffers.
It is difficult to come up with generic requirements for buffer
allocation, and to keep the solution future-proof is challenging as
well. In principle the user is interested in being able to share
buffers between subsystems without knowing the exact requirements of
the devices, which makes it possible to keep the requirement handling
internal to the kernel. Whether this is the way to go or not, will be
seen in the future. The buffer allocation remains a problem to be
resolved in the future.

Majority of the devices' requirements could be filled using a few
allocators; one for physically continugous memory and the other for
physically non-contiguous memory of single page allocations. Being
able to allocate large pages would also be beneficial in many cases.

API to allocate buffers
-----------------------

It was agreed there was a need to have a generic interface for buffer
object creation. This could be either a new system call which would be
supported by all devices supporting such buffers in subsystem APIs
(such as V4L2), or a new dedicated character device.

Different subsystems have different ways of describing the properties
of the buffers, such as how the data in the buffer should be
interpreted. The V4L2 has width, height, bytesperline and pixel
format, for example. The generic buffers should not recognise such
properties since this is very subsystem specific information. Instead,
the user which is aware of the different subsystems must come with
matching set of buffer properties using the subsystem specific
interfaces.

Sharing buffers among kernel subsystems
---------------------------------------

There was discussion on how to refer to generic DMA buffers, and the
audience was first mostly split between using buffer IDs to refer to
the buffers and using file handles for the purpose. Using file handles
have pros and cons compared to the numeric IDs:

+ Easy life cycle management. Deallocation of buffers no longer in use
is trivial.
+ Access control for files exists already. Passing file descriptors
between processes is possible throught Unix sockets.
- Allocating extremely large number of buffers would require as many
file descriptors. This is not likely to be an important issue.

Before the day ended, it was felt that the file handles are the right
way to go.

The generic DMA buffers further need to be associated to the subsystem
buffers. This is up to the subsystem APIs. In V4L2, this would most
likely mean that there will be a new buffer type for the generic DMA
buffers.

Sharing buffers between processes
---------------------------------

Numeric IDs can be easily shared between processes while sharing file
handles is more difficult. However, it can be done using the Unix
sockets between any two processes. This also gives automatically
the same access control mechanism as every other file. Access control
mechanisms are mandatory when making the buffer shareable between
processes.

Cache coherency
---------------

Cache coherency is seen largely orthogonal to any other sub-problems
in memory buffer management. In few cases this might have something in
common with buffer allocation. Some architectures, ARM in particular, do
not have coherent caches, meaning that the operating system must know
when to invalidate or clean various parts of the cache. There are two
ways to approach the issue, independently of the cache implementation:

1. Allocate non-cacheable memory, or

2. invalidate or clean (or flush) the cache when necessary.

Allocating non-cacheable memory is a valid solution to cache coherency
handling in some situations, but mostly only when the buffer is only
partially accessed by the CPU or at least not multiple times. In other
cases, invalidating or cleaning the cache is the way to go.

The exact circumstances in which using non-cacheable memory gives a
performance benefit over invalidating or cleaning the cache when
necessary are very system and use case dependent. This should be
selectable from the user space.

The cache invalidation or cleaning can be either on the whole (data)
cache or a particular memory area. Performing the operation on a
particular memory area may be difficult since it should be done to all
mappings of the memory in the system. Also, there is a limit beyond
which performing invalidation or clean for an area is always more
expensive than a full cache flush: on many machines the cache line
size is 64 bytes, and the invalidate/clean must be performed for the
whole buffer, which in cameras could be tens of megabytes in size, per
every cache line.

Mapping buffers to application memory is not always necessary --- the
buffers may only be used by the devices, in which case a scatterlist
of the pages in the buffer is necessary to map the buffer to the IOMMU.


More (impartial :-)) information can be found here:

<URL:http://summit.ubuntu.com/uds-o/meeting/linaro-graphics-memory-management-summit-1/>
<URL:http://summit.ubuntu.com/uds-o/meeting/linaro-graphics-memory-management-summit-2/>
<URL:http://summit.ubuntu.com/uds-o/meeting/linaro-graphics-memory-management-summit-3/>


Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
