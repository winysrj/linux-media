Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14617 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128Ab0JTGl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 02:41:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LAK009ATT8ZUS20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Oct 2010 07:41:24 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LAK00KKFT8YAC@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Oct 2010 07:41:23 +0100 (BST)
Date: Wed, 20 Oct 2010 08:41:06 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH/RFC v3 0/7] Videobuf2 framework
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com
Message-id: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

As I promissed I continue the development of the VideoBuf2 at Samsung
until Pawel finds some spare time to help us. This is a third version of
the framework. Besides the minor bugfixes here and there I've added a
complete read() callback emulator. This emulator provides 2 types of
read() operation - 'streaming' and 'one shot'. It is suitable to replace
both videobuf_read_stream() and videobuf_read_one() methods from the old
videobuf.

Taking into account the size of the patches and the number of lines I've
changed, I've decided to keep the Pawel signed-off attribute and
authorship to correctly credit him. If this is against kernel rules,
feel free to let me know.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


Changes since V2:
=================
- added read() emulator (see patch #5/7)
- fixed lack of parentheses in macro definitions (caused side effects
  in some places)
- added a separate check for VM_READ or VM_WRITE in vb2_mmap()
- added vb2_is_streaming(), vb2_lock and vb2_unlock inlines
- updated vivi driver with the new read() emulator 

Changes since V1:
=================
- removed drv_lock, added start_streaming and stop_streaming callbacks


Here is the original Videobuf2 introduction prepared by Pawel:
=======================================================================

These patches add a new driver framework for Video for Linux 2 driver
- Videobuf2.

Videobuf2 is intended as a replacement for videobuf, the current driver
framework, which will be referred to as "videobuf1" for the remainder
of this document.

================================
What is videobuf2?
================================
Videobuf2 is a Video for Linux 2 API-compatible driver framework for
multimedia devices. It acts as an intermediate layer between userspace
applications and device drivers. It also provides low-level, modular
memory management functions for drivers.

Videobuf2 eases driver development, reduces drivers' code size and aids in
proper and consistent implementation of V4L2 API in drivers.

Videobuf2 memory management backend is fully modular. This allows custom
memory management routines for devices and platforms with non-standard
memory management requirements to be plugged in, without changing the
high-level buffer management functions and API.

The framework provides:
- implementations of streaming I/O V4L2 ioctls and file operations
- high-level video buffer, video queue and state management functions
- video buffer memory allocation and management

================================
Why a new framework?
================================
There have been many discussions in the V4L2 community about the feasibility
of writing a new framework, as opposed to fixing the existing one. It has been
agreed though that:
- videobuf1 has major flaws and an attempt to fix it would end up in rewriting
most of the code
- many drivers depend on videobuf1 and since the changes would be major,
an effort to adapt and test them all would not be realistically possible

Due to the problems with videobuf most new drivers cannot use it. This leads
to code replication and overcomplicated drivers.

================================
What is wrong with videobuf1?
================================
There are many problems with the current videobuf implementation. During a V4L2
mini-summit in Helsinki in June 2010, two presentations were delivered
on this topic:
- Laurent Pinchart "videobuf - the good, the bad and the ugly"
http://linuxtv.org/downloads/presentations/summit_jun_2010/20100614-v4l2_summit-videobuf.pdf
- Pawel Osciak "Future of the videobuf framework"
http://linuxtv.org/downloads/presentations/summit_jun_2010/Videobuf_Helsinki_June2010.pdf

These presentations highlighted many problems with videobuf. The most prominent
include:

- V4L2 API violations and wrong memory management design
  - it is impossible to pause streaming (buffers are freed on streamoff)
  - VIDIOC_REQBUFS(0) does not free memory
  - it is impossible to reallocate memory with VIDIOC_REQBUFS
  - video memory is allocated on mmap, qbuf or even on page fault,
    freed on unmap, streamoff or explicitly by drivers
  - per-buffer waitqueues
- not extensible enough and thus not ready for new platforms and uses,
  especially considering embedded multimedia devices
  - very hard to add new memory handling routines and custom memory allocators
  - no or poor support for handling cache coherency, IOMMUs, 
  - poor flexibility - only one do-it-all function for handling memory pinning,
    cache, sg-list creation, etc...
- unused fields, code duplication, vague/inconsistent naming, obscure usage in
  some places...

Many driver authors expressed their frustration with videobuf. Developers
acknowledge its merits and would like to use it, but due mostly to its
inflexible memory allocation schemes they are unable to do so.

================================
Main goals of the redesign
================================
- correct V4L2 API implementation, fixing videobuf1 problems and shortcomings
- full separation between queue management and memory management
- fully flexible, pluggable memory allocators and memory handling routines
- more specialized driver callbacks, called at different points
- support for new V4L2 API extensions, such as multi-planar video buffers

================================
Driver callbacks
================================
Driver callbacks have been redesigned for symmetry:
- buf_init - called once, after memory is allocated or after a new USERPTR
  buffer is queued; can be used e.g. to pin pages, verify contiguity, set up
  IOMMU mappings, etc.
- buf_prepare - called on each QBUF; can be used e.g. for cache sync, copying
  to bounce buffers, etc.
- buf_finish - called on each DQBUF; can be used e.g. for cache sync, copying
  back from bounce buffers, etc.
- buf_cleanup - called before freeing/releasing memory; can be used e.g. for
  unmapping memory, etc.

The remaining driver callbacks have been slightly redesigned:
- queue_negotiate - now incorporates multi-planar extensions; drivers return
  required number of buffers and planes per buffer
- plane_setup - drivers return plane sizes
Those two callbacks replace the old buf_setup.

- buf_queue - basically stays the same

================================
Memory allocators and handling
================================
Memory handling has been designed to allow more customization than in the
original videobuf. For this memory allocation ops have been slightly redesigned,
and have become fully replaceable and an allocator context struct have been
introduced.

Allocator context is intended to provide memory operations to videobuf and also
for storing allocator private data, if required, although simpler allocators
do not have to use this feature. Private data can be added by embedding the
context struct inside their own structures:

struct vb2_alloc_ctx {
        const struct vb2_mem_ops        *mem_ops;
};

struct vb2_foo_alloc_conf {
        struct vb2_alloc_ctx    alloc_ctx;                          
	/* Allocator private data here */
};

Moreover, a buffer context structure concept has been introduced. Allocators
return their own, custom, per-buffer structures on every allocation. This
structure is then used as a "cookie" and passed to other memory handling
methods called for its corresponding buffer.

Memory operations, stored in the allocator context, can be replaced if
needed by drivers on a per-function basis and functions from other allocators
or drivers can be reused as well. A full list with documentation can be found
in the videobuf2-core.h file.

It is also possible, although not required, to assign different contexts per
plane. This may be useful for drivers that need to use different memory types
for different planes. An example may be a driver that stores video data in the
first plane, which has to be allocated from a device-accessible memory area,
and metadata in the second plane, which does not have to be stored in
a device-accessible memory.

An good example of integrating a more advanced allocator, the recently discussed
on this list CMA (contiguous memory allocator), can be found in videobuf2-cma.*.

================================
Other changes
================================
The changes described above are the main changes in videobuf2. Most of the core
API has remained the same or very similar, although its implementation has been
fully rewritten. Some more visible changes include:

- Memory is now properly allocated on REQBUFS and can be freed and reallocated
  there as well.
- It is now possible to pause and resume streaming with streamon/streamoff,
  without freeing the buffers.
- V4L2 API-related, userspace-visible metadata, such as inputs, timestamps, etc.
  are no longer stored in videobuf buffer structure, but in an actual
  v4l2_buffer struct (idea borrowed from Laurent Pinchart). I felt that driver
  authors would prefer to use V4L2 API-based structures of videobuf custom
  structures where possible. It also eases copying v4l2_buffer-related data
  from/to userspace.
- Buffers do not include waitqueues anymore. One, global, per-queue waitqueue
  for done buffers has been introduced instead. Per-buffer waitqueues were not
  very useful and introduced additional complications in code.
  With this, drivers have gained the ability of dequeuing buffers out-of-order
  as well.
- Buffer states are not handled jointly by both videobuf and driver anymore,
  I felt it was not required and confusing for driver authors
- Some fields that were less useful have been removed and naming of others
  have been changed to better reflect their function.
- Other then reqbufs, ioctl implementations have remained almost the same
  and behave in the same way, 
  

Please see documentation in videobuf2-core.c and videobuf2-core.h for more
details and the patch porting vivi to videobuf2 for how to port existing
drivers to videobuf2.

This is a preliminary version intended for review, but has already been tested
for multiple drivers and different memory handling implementations. DMA-SG
implementation is not included yet.

The CMA allocator patches are attached for reference, to show how a more
complicated allocator can be integrated into the framework.

Any comments will be very much appreciated!

Best regards,
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center 

=======================================================================

Patch summary:

Pawel Osciak (6):
  v4l: add videobuf2 Video for Linux 2 driver framework
  v4l: videobuf2: add generic memory handling routines
  v4l: videobuf2: add vmalloc allocator
  v4l: videobuf2: add DMA coherent allocator
  v4l: vivi: port to videobuf2
  v4l: videobuf2: add CMA allocator

Marek Szyprowski (1):
  v4l: videobuf2: add read() emulator

 drivers/media/video/Kconfig                  |   23 +-
 drivers/media/video/Makefile                 |    6 +
 drivers/media/video/videobuf2-cma.c          |  250 ++++
 drivers/media/video/videobuf2-core.c         | 1726 ++++++++++++++++++++++++++
 drivers/media/video/videobuf2-dma-coherent.c |  208 ++++
 drivers/media/video/videobuf2-memops.c       |  199 +++
 drivers/media/video/videobuf2-vmalloc.c      |  177 +++
 drivers/media/video/vivi.c                   |  348 +++---
 include/media/videobuf2-cma.h                |   25 +
 include/media/videobuf2-core.h               |  392 ++++++
 include/media/videobuf2-dma-coherent.h       |   21 +
 include/media/videobuf2-memops.h             |   31 +
 include/media/videobuf2-vmalloc.h            |   16 +
 13 files changed, 3258 insertions(+), 164 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-cma.c
 create mode 100644 drivers/media/video/videobuf2-core.c
 create mode 100644 drivers/media/video/videobuf2-dma-coherent.c
 create mode 100644 drivers/media/video/videobuf2-memops.c
 create mode 100644 drivers/media/video/videobuf2-vmalloc.c
 create mode 100644 include/media/videobuf2-cma.h
 create mode 100644 include/media/videobuf2-core.h
 create mode 100644 include/media/videobuf2-dma-coherent.h
 create mode 100644 include/media/videobuf2-memops.h
 create mode 100644 include/media/videobuf2-vmalloc.h

-- 
1.7.1.569.g6f426

