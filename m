Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55117 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab1IAIPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 04:15:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQU00BU0499U530@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Sep 2011 09:15:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQU00FYI498CP@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Sep 2011 09:15:09 +0100 (BST)
Date: Thu, 01 Sep 2011 10:14:54 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] Videobuf2 & FIMC fixes
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <1314864894-24469-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

I've collected all the separate patches for VideoBuf2 and FIMC to a
single branch. Please pull them to your media tree.

The following changes since commit 69d232ae8e95a229e7544989d6014e875deeb121:

  [media] omap3isp: ccdc: Use generic frame sync event instead of private HS_VS event (2011-08-29 12:38:51 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung for_mauro

Andrzej Pietrasiewicz (1):
      media: mem2mem: eliminate possible NULL pointer dereference

Marek Szyprowski (5):
      media: vb2: add a check if queued userptr buffer is large enough
      media: vb2: fix handling MAPPED buffer flag
      media: vb2: change plane sizes array to unsigned int[]
      media: vb2: dma contig allocator: use dma_addr instread of paddr
      media: vb2: change queue initialization order

Sylwester Nawrocki (3):
      s5p-fimc: Add runtime PM support in the mem-to-mem driver
      s5p-csis: Handle all available power supplies
      s5p-csis: Rework the system suspend/resume helpers

Tomasz Stanislawski (1):
      media: v4l: remove single to multiplane conversion

Yu Tang (1):
      media: vb2: fix userptr VMA release seq

 drivers/media/video/Kconfig                  |    2 +-
 drivers/media/video/atmel-isi.c              |   24 ++-
 drivers/media/video/marvell-ccic/mcam-core.c |   12 +-
 drivers/media/video/mem2mem_testdev.c        |    2 +-
 drivers/media/video/mx3_camera.c             |    4 +-
 drivers/media/video/pwc/pwc-if.c             |    4 +-
 drivers/media/video/s5p-fimc/fimc-capture.c  |   85 ++++++---
 drivers/media/video/s5p-fimc/fimc-core.c     |  287 +++++++++++++++++++-------
 drivers/media/video/s5p-fimc/fimc-core.h     |   16 +-
 drivers/media/video/s5p-fimc/fimc-reg.c      |    2 +-
 drivers/media/video/s5p-fimc/mipi-csis.c     |   90 +++++----
 drivers/media/video/s5p-mfc/s5p_mfc.c        |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |   14 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |   34 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |   14 +-
 drivers/media/video/s5p-tv/mixer.h           |    2 -
 drivers/media/video/s5p-tv/mixer_grp_layer.c |    2 +-
 drivers/media/video/s5p-tv/mixer_video.c     |   24 +-
 drivers/media/video/s5p-tv/mixer_vp_layer.c  |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c   |    6 +-
 drivers/media/video/v4l2-ioctl.c             |  250 +---------------------
 drivers/media/video/v4l2-mem2mem.c           |   18 +-
 drivers/media/video/videobuf2-core.c         |  205 ++++++++++---------
 drivers/media/video/videobuf2-dma-contig.c   |   16 +-
 drivers/media/video/videobuf2-memops.c       |    6 +-
 drivers/media/video/vivi.c                   |    4 +-
 include/media/videobuf2-core.h               |   23 ++-
 include/media/videobuf2-dma-contig.h         |    6 +-
 28 files changed, 567 insertions(+), 593 deletions(-)
