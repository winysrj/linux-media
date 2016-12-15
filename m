Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:36518 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752959AbcLOAIK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 19:08:10 -0500
Received: by mail-qt0-f174.google.com with SMTP id w33so41649578qtc.3
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2016 16:07:49 -0800 (PST)
From: Laura Abbott <labbott@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com
Cc: Laura Abbott <labbott@redhat.com>, romlem@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Bryan Huntsman <bryanh@codeaurora.org>, pratikp@codeaurora.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>
Subject: [RFC PATCH 0/4] Ion caching (yet again) proof of concept
Date: Wed, 14 Dec 2016 16:07:39 -0800
Message-Id: <1481760463-3515-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I've been (once again) looking at alternate caching models for Ion. Part of
this work is also to make Ion fit better in to the dma_buf model.

Ion is a bit unusual for dma_buf. Most drivers that support dma_buf have two
parts: exporting buffers that a driver allocates and importing buffers
allocated elsewhere for use by the driver. Ion is basically designed to export
only and not import buffers from other drivers (the need for import is also
on my TODO list) Even more unusual, there is no actual 'driver' to map into.
Ion currently does nothing except pass back the same sg_table each time without
calling dma_map.

The description of the .map_dma_buf function in dma_buf_ops

 * @map_dma_buf: returns list of scatter pages allocated, increases usecount
 *               of the buffer. Requires atleast one attach to be called
 *               before. Returned sg list should already be mapped into
 *               _device_ address space. This call may sleep. May also return
 *               -EINTR. Should return -EINVAL if attach hasn't been called yet.


So Ion is definitely not doing this correctly. This ties back into correcting
the caching model. If we call dma_map_sg/dma_unmap_sg with begin_cpu_access,
this should be enough to allow the caches to always be properly synchronized
and means we can drop the various dma_sync calls floating around. This is going
to violate one of the big fat comments in ion_buffer_create

        /*
         * this will set up dma addresses for the sglist -- it is not
         * technically correct as per the dma api -- a specific
         * device isn't really taking ownership here.  However, in practice on
         * our systems the only dma_address space is physical addresses.
         * Additionally, we can't afford the overhead of invalidating every
         * allocation via dma_map_sg. The implicit contract here is that
         * memory coming from the heaps is ready for dma, ie if it has a
         * cached mapping that mapping has been invalidated
         */
        for_each_sg(buffer->sg_table->sgl, sg, buffer->sg_table->nents, i) {
                sg_dma_address(sg) = sg_phys(sg);
                sg_dma_len(sg) = sg->length;
        }


The overhead of invalidating is a valid concern. I'm hoping that the
architecture has either evolved such that this won't be a problem or we can
figure out some clever use of DMA_ATTR_SKIP_CPU_SYNC.

As part of this, I'm considering dropping the fault synchronization. If we have
explicit use begin_cpu_access and use of the dma_buf sync ioctls, I don't think
it should be necessary.

I have a 'pre-RFC' tree at https://pagure.io/kernel-ion/branch/ion_cache_proof_dec14
Yes, the patches are not bisectable and there is more to be done. These have
been compile tested only and haven't been hooked up to anything to actually run
(another actually big TODO). I'm mostly looking for feedback if this looks like
the right direction and if there are going to be major problems with this
approach. I don't actually anticipate this getting merged into
drivers/staging/android/ion but this is the easiest way to continue discussion.

Thanks,
Laura

Laura Abbott (4):
  staging: android: ion: Some cleanup
  staging: android: ion: Duplicate sg_table
  staging: android: ion: Remove page faulting support
  staging: android: ion: Call dma_map_sg for syncing and mapping

 drivers/staging/android/ion/ion-ioctl.c         |   6 -
 drivers/staging/android/ion/ion.c               | 251 ++++++++----------------
 drivers/staging/android/ion/ion.h               |   5 +-
 drivers/staging/android/ion/ion_carveout_heap.c |  16 +-
 drivers/staging/android/ion/ion_chunk_heap.c    |  15 +-
 drivers/staging/android/ion/ion_cma_heap.c      |   5 +-
 drivers/staging/android/ion/ion_page_pool.c     |   3 -
 drivers/staging/android/ion/ion_priv.h          |   4 +-
 drivers/staging/android/ion/ion_system_heap.c   |  14 +-
 9 files changed, 90 insertions(+), 229 deletions(-)

-- 
2.7.4

