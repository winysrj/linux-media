Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34345 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933075AbcJUOLj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:11:39 -0400
Received: by mail-lf0-f68.google.com with SMTP id x23so5870818lfi.1
        for <linux-media@vger.kernel.org>; Fri, 21 Oct 2016 07:11:38 -0700 (PDT)
From: Tvrtko Ursulin <tursulin@ursulin.net>
To: Intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 0/5] Avoid pessimistic scatter-gather allocation
Date: Fri, 21 Oct 2016 15:11:18 +0100
Message-Id: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

We can decrease the i915 kernel memory usage by doing more sg list
coallescing and avoiding the pessimistic list allocation.

At the moment we got two places in our code, the main shmemfs backed
object allocator, and the userptr object allocator, which both can
allocate sg list size pessimistically, and in the latter case also do
not exploit entry coallescing when it is possible.

This results in between one to six megabytes of memory wasted on unused
sg list entries under some common workloads:

    * Logging into KDE there is 1-2 MiB of unused sg entries.
    * Running the T-Rex benchamrk aroun 3 Mib.
    * Similarly for Manhattan 5-6 MiB.

To remove this wastage this series starts with some cleanups in the
sg_alloc_table_from_pages implementation and then adds and exports a new
__sg_alloc_table_from_pages function.

This then gets used by the i915 driver to achieve the described savings.

Tvrtko Ursulin (5):
  lib/scatterlist: Fix offset type in sg_alloc_table_from_pages
  lib/scatterlist: Avoid potential scatterlist entry overflow
  lib/scatterlist: Introduce and export __sg_alloc_table_from_pages
  drm/i915: Use __sg_alloc_table_from_pages for allocating object
    backing store
  drm/i915: Use __sg_alloc_table_from_pages for userptr allocations

 drivers/gpu/drm/i915/i915_drv.h                |  9 +++
 drivers/gpu/drm/i915/i915_gem.c                | 77 +++++++++++--------------
 drivers/gpu/drm/i915/i915_gem_userptr.c        | 29 +++-------
 drivers/media/v4l2-core/videobuf2-dma-contig.c |  4 +-
 drivers/rapidio/devices/rio_mport_cdev.c       |  4 +-
 include/linux/scatterlist.h                    | 11 ++--
 lib/scatterlist.c                              | 78 ++++++++++++++++++++------
 7 files changed, 120 insertions(+), 92 deletions(-)

-- 
2.7.4

