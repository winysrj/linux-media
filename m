Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45878 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbbEYOf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 10:35:58 -0400
Message-ID: <55633347.9010001@xs4all.nl>
Date: Mon, 25 May 2015 16:35:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>
Subject: [GIT PULL FOR v4.2] Helper to abstract vma handling in media layer
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request merged Jan's vb2/mm patches to abstract vma handling.

See http://www.spinics.net/lists/linux-media/msg89653.html for more info.

Regards,

	Hans

The following changes since commit 2a80f296422a01178d0a993479369e94f5830127:

  [media] dvb-core: fix 32-bit overflow during bandwidth calculation (2015-05-20 14:01:46 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2m

for you to fetch changes up to a50e19d76fcff4d57b89e7bfea14565b1caeef13:

  drm/exynos: Convert g2d_userptr_get_dma_addr() to use get_vaddr_frames() (2015-05-25 16:28:05 +0200)

----------------------------------------------------------------
Jan Kara (8):
      mm: Provide new get_vaddr_frames() helper
      media: omap_vout: Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns()
      vb2: Provide helpers for mapping virtual addresses
      media: vb2: Convert vb2_dma_sg_get_userptr() to use frame vector
      media: vb2: Convert vb2_vmalloc_get_userptr() to use frame vector
      media: vb2: Convert vb2_dc_get_userptr() to use frame vector
      media: vb2: Remove unused functions
      drm/exynos: Convert g2d_userptr_get_dma_addr() to use get_vaddr_frames()

 drivers/gpu/drm/exynos/exynos_drm_g2d.c        |  91 ++++++++++---------------------
 drivers/gpu/drm/exynos/exynos_drm_gem.c        |  97 ---------------------------------
 drivers/media/platform/omap/omap_vout.c        |  69 +++++++++++-------------
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 214 ++++++++++++------------------------------------------------------------
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |  97 ++++++---------------------------
 drivers/media/v4l2-core/videobuf2-memops.c     | 148 ++++++++++++++++----------------------------------
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |  94 +++++++++++++-------------------
 include/linux/mm.h                             |  44 +++++++++++++++
 include/media/videobuf2-memops.h               |  11 ++--
 mm/gup.c                                       | 226 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 466 insertions(+), 625 deletions(-)
