Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55830 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbbGXH4P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 03:56:15 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 76FFE2A00AA
	for <linux-media@vger.kernel.org>; Fri, 24 Jul 2015 09:54:57 +0200 (CEST)
Message-ID: <55B1EF51.70900@xs4all.nl>
Date: Fri, 24 Jul 2015 09:54:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] Helper to abstract vma handling in media layer
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From Jan Kara's cover letter:

I'm sending the seventh version of my patch series to abstract vma handling
from the various media drivers. Since the previous version there are just
minor cleanups and fixes (see detailed changelog at the end of the email).

After this patch set drivers have to know much less details about vmas, their
types, and locking. Also quite some code is removed from them. As a bonus
drivers get automatically VM_FAULT_RETRY handling. The primary motivation for
this series is to remove knowledge about mmap_sem locking from as many places a
possible so that we can change it with reasonable effort.

The core of the series is the new helper get_vaddr_frames() which is given a
virtual address and it fills in PFNs / struct page pointers (depending on VMA
type) into the provided array. If PFNs correspond to normal pages it also grabs
references to these pages. The difference from get_user_pages() is that this
function can also deal with pfnmap, and io mappings which is what the media
drivers need.

I have tested the patches with vivid driver so at least vb2 code got some
exposure. Conversion of other drivers was just compile-tested (for x86 so e.g.
exynos driver which is only for Samsung platform is completely untested).

The following changes since commit 4dc102b2f53d63207fa12a6ad49c7b6448bc3301:

  [media] dvb_core: Replace memset with eth_zero_addr (2015-07-22 13:32:21 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vaddr

for you to fetch changes up to 1b63887b50f2643c2cd9e1b8e370d5fd62579901:

  drm/exynos: Convert g2d_userptr_get_dma_addr() to use get_vaddr_frames() (2015-07-24 09:52:18 +0200)

----------------------------------------------------------------
Jan Kara (9):
      vb2: Push mmap_sem down to memops
      mm: Provide new get_vaddr_frames() helper
      media: omap_vout: Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns()
      vb2: Provide helpers for mapping virtual addresses
      media: vb2: Convert vb2_dma_sg_get_userptr() to use frame vector
      media: vb2: Convert vb2_vmalloc_get_userptr() to use frame vector
      media: vb2: Convert vb2_dc_get_userptr() to use frame vector
      media: vb2: Remove unused functions
      drm/exynos: Convert g2d_userptr_get_dma_addr() to use get_vaddr_frames()

 drivers/gpu/drm/exynos/Kconfig                 |   1 +
 drivers/gpu/drm/exynos/exynos_drm_g2d.c        |  89 ++++++++++--------------------
 drivers/gpu/drm/exynos/exynos_drm_gem.c        |  97 ---------------------------------
 drivers/media/platform/omap/Kconfig            |   1 +
 drivers/media/platform/omap/omap_vout.c        |  69 +++++++++++------------
 drivers/media/v4l2-core/Kconfig                |   1 +
 drivers/media/v4l2-core/videobuf2-core.c       |   2 -
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 207 ++++++++++++---------------------------------------------------------
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |  91 +++++--------------------------
 drivers/media/v4l2-core/videobuf2-memops.c     | 148 ++++++++++++++++---------------------------------
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |  90 ++++++++++++------------------
 include/linux/mm.h                             |  44 +++++++++++++++
 include/media/videobuf2-memops.h               |  11 ++--
 mm/Kconfig                                     |   3 +
 mm/Makefile                                    |   1 +
 mm/frame_vector.c                              | 230 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 16 files changed, 477 insertions(+), 608 deletions(-)
 create mode 100644 mm/frame_vector.c
