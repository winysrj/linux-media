Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:57080 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422953AbbFEPHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 11:07:25 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5929A2A0085
	for <linux-media@vger.kernel.org>; Fri,  5 Jun 2015 17:07:13 +0200 (CEST)
Message-ID: <5571BB21.2050200@xs4all.nl>
Date: Fri, 05 Jun 2015 17:07:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Helper to abstract vma handling in media layer
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request merged Jan's vb2/mm patches to abstract vma handling.

See http://www.spinics.net/lists/linux-media/msg89653.html for more info.

It's the same pull request as from May 25th, but with an additional patch that
puts get_vaddr_frames() behind a config option (requested by Andrew Morton).

Regards,

	Hans

The following changes since commit 64d5702229d86deacf42a43bc893a981f72d4908:

  [media] vivid.txt: update the vivid documentation (2015-06-05 11:52:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2m

for you to fetch changes up to 1382dd5a8f783f368f8b1dd687ee0bf0a93ed899:

  mm: Move get_vaddr_frames() behind a config option (2015-06-05 17:01:17 +0200)

----------------------------------------------------------------
Jan Kara (9):
      mm: Provide new get_vaddr_frames() helper
      media: omap_vout: Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns()
      vb2: Provide helpers for mapping virtual addresses
      media: vb2: Convert vb2_dma_sg_get_userptr() to use frame vector
      media: vb2: Convert vb2_vmalloc_get_userptr() to use frame vector
      media: vb2: Convert vb2_dc_get_userptr() to use frame vector
      media: vb2: Remove unused functions
      drm/exynos: Convert g2d_userptr_get_dma_addr() to use get_vaddr_frames()
      mm: Move get_vaddr_frames() behind a config option

 drivers/gpu/drm/exynos/Kconfig                 |   1 +
 drivers/gpu/drm/exynos/exynos_drm_g2d.c        |  91 ++++++++++--------------------
 drivers/gpu/drm/exynos/exynos_drm_gem.c        |  97 --------------------------------
 drivers/media/platform/omap/Kconfig            |   1 +
 drivers/media/platform/omap/omap_vout.c        |  69 +++++++++++------------
 drivers/media/v4l2-core/Kconfig                |   1 +
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 214 ++++++++++++-----------------------------------------------------------
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |  97 +++++---------------------------
 drivers/media/v4l2-core/videobuf2-memops.c     | 148 ++++++++++++++++---------------------------------
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |  94 ++++++++++++-------------------
 include/linux/mm.h                             |  44 +++++++++++++++
 include/media/videobuf2-memops.h               |  11 ++--
 mm/Kconfig                                     |   3 +
 mm/Makefile                                    |   1 +
 mm/frame_vector.c                              | 232 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/gup.c                                       |   1 +
 16 files changed, 480 insertions(+), 625 deletions(-)
 create mode 100644 mm/frame_vector.c
