Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26577 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0ASP27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 10:28:59 -0500
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KWI00F3B309HK@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2010 15:28:57 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KWI00DVX3080U@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2010 15:28:57 +0000 (GMT)
Date: Tue, 19 Jan 2010 16:28:48 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH/RFC v1 0/1] Buffer sync for non cache-coherent architectures
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1263914929-28211-1-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

this is the initial patch for buffer data synchronization for architectures
with non-coherent cache.


=====================
Rationale
=====================

Architectures with non-coherent CPU cache (e.g. ARM) require a sync both before
and after a hardware operation. Until now, videobuf could work properly for
cache-coherent memory areas only, which for ARM actually means no cache at all.
This is not only reduces functionality, but hinders performance.

We would like to add support for video buffers present in CPU-cached areas as
well, which is especially important for OUTPUT buffers, but valid for CAPTURE
buffers as well (see DMA_FROM_DEVICE below).


We have isolated 4 different types of sync operations. Three of them are the
ones defined in pci.h and dma-mapping.h (enum dma_data_direction):

- DMA_FROM_DEVICE - the buffer is to be used as a destination buffer, the
  data contained within before the operation is unimportant.

  Although the data in memory is not important, we have to prevent a possible
  future writeback to it resulting in an accidental overwrite of contents
  produced by hardware after an operation. This requires cache invalidation
  before the operation.

- DMA_TO_DEVICE - the data in buffer has been touched by (prepared using)
   the CPU and will be used as valid source for an operation. This data
   may still be in cache but not yet in memory. This requires a writeback.

- DMA_BIDIRECTIONAL - the buffer will be used as both source and destination.
  This requires both writeback and cache invalidation.

There is one more operation we are considering, although not really
cache-related:

- FINISH - the operation is finished and the data in buffer (put there by
  hardware) will be used further.

  Operations required here may include:
  * Making the memory pages involved in the operation dirty.
  * Copying data back from a bounce buffer.
  They are not strictly cache-related, but valid from the point of view
  of our proposed approach.



>From the point of view of the videobuf framework, the following scenarios can be
isolated, depending on when the sync has been called and current buffer type:

- before hardware operation
   - OUTPUT: DMA_TO_DEVICE
   - CAPTURE: DMA_FROM_DEVICE

- after hardware operation
   - OUTPUT: nothing
   - CAPTURE: FINISH

DMA_BIDIRECTIONAL would take place for OUTPUT+CAPTURE buffers, which are not
(yet?) used in videobuf.


=====================
sync() in videobuf
=====================

videobuf includes a sync operation, declared in struct videobuf_qtype_ops,
which can be implemented by each memory type-specific module. It is used for
different purposes than cache management though, namely for operations like
copying data back from bounce buffers after an operation.
Only videobuf-dma-sg does anything in its sync currently.

Operations required to be done before hardware operation is started are
currently performed in iolock(), but it is not usable for cache coherency
management. The reason for this is that iolock() is intended to be run once
per buffer, not once per each hardware operation. Cache coherency operations
have to be performed before every operation though, also on previously
iolock()ed buffers.

We believe that the existing videobuf sync() operation can be extended for cache
management. This requires adding sync() calls before each hardware operation
as well. It is left to the callee to determine the kind of sync requested,
taking into account the guidelines below.

No new flags/states/etc. have to be added to videobuf for it to support all
kinds of syncs mentioned above. Current sync type can be determined in
memory-specific code in two steps:

1. CAPTURE or OUTPUT - based on buffer type in struct videobuf_queue.
2. before or after operation - based on buffer state in struct videobuf_buffer:
    VIDEOBUF_DONE or VIDEOBUF_ERROR -> after, otherwise -> before.


Example (pseudo)code for a sync() operation:

#define is_sync_after(vb) \
        (vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)

int videobuf_foo_sync(struct videobuf_queue *q, struct videobuf_buffer *vb)
{
    /* ... */

    if (is_sync_after(vb) {
        /* Sync after operation */
        if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
            do_sync_finish();
        } else if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
            /* nothing, unless we are missing something */
        }
    } else {
        /* Sync before operation */
        if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
            do_sync_from_device();
        } else if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
            do_sync_to_device();
        }
    }

    /* ... */
}



=====================
About this patch
=====================

This is a very small patch, just a starting point for future, memory-specific
development. No existing functionality is changed. These are the only changes
that - in our opinion - are required in the core framework. Each memory-specific
videobuf submodule will have to implement (or ignore) additional sync
functionality depending on its memory type.

A small patch for dma-sg, which is the only type that has its own sync is
included. The only thing it does is recognizing whether the sync is a
"post-operation" one and in that case the same code as previously is called, so
the functionality remains unchanged.

We will be posting cache coherency patches for dma-contig in the near future.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
