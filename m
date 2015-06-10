Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562AbbFJJVV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 05:21:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/9] Helper to abstract vma handling in media layer
Date: Wed, 10 Jun 2015 06:20:43 -0300
Message-Id: <cover.1433927458.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrew,

I received this patch series with a new set of helper functions for
mm, together with changes for media and DRM drivers.

As this stuff is actually mm code, I prefer if this got merged via
your tree.

Could you please handle it? Please notice that patch 8 actually changes
the exynos DRM driver, but it misses ack from DRM people.

Regards,
Mauro

Jan Kara (9):
  mm: Provide new get_vaddr_frames() helper
  [media] media: omap_vout: Convert omap_vout_uservirt_to_phys() to use
    get_vaddr_pfns()
  [media] vb2: Provide helpers for mapping virtual addresses
  [media] media: vb2: Convert vb2_dma_sg_get_userptr() to use frame
    vector
  [media] media: vb2: Convert vb2_vmalloc_get_userptr() to use frame
    vector
  [media] media: vb2: Convert vb2_dc_get_userptr() to use frame vector
  [media] media: vb2: Remove unused functions
  [media] drm/exynos: Convert g2d_userptr_get_dma_addr() to use
    get_vaddr_frames()
  [media] mm: Move get_vaddr_frames() behind a config option

 drivers/gpu/drm/exynos/Kconfig                 |   1 +
 drivers/gpu/drm/exynos/exynos_drm_g2d.c        |  95 ++++------
 drivers/gpu/drm/exynos/exynos_drm_gem.c        |  97 -----------
 drivers/media/platform/omap/Kconfig            |   1 +
 drivers/media/platform/omap/omap_vout.c        |  69 ++++----
 drivers/media/v4l2-core/Kconfig                |   1 +
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 214 ++++-------------------
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |  99 ++---------
 drivers/media/v4l2-core/videobuf2-memops.c     | 156 ++++++-----------
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |  92 ++++------
 include/linux/mm.h                             |  44 +++++
 include/media/videobuf2-memops.h               |  11 +-
 mm/Kconfig                                     |   3 +
 mm/Makefile                                    |   1 +
 mm/frame_vector.c                              | 232 +++++++++++++++++++++++++
 mm/gup.c                                       |   1 +
 16 files changed, 486 insertions(+), 631 deletions(-)
 create mode 100644 mm/frame_vector.c

-- 
2.4.2

