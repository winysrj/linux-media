Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55475 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2JAPLs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 11:11:48 -0400
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MB70079SZK7CZC0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Oct 2012 16:12:07 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MB700CZRZJMOS80@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Oct 2012 16:11:46 +0100 (BST)
Message-id: <5069B2B1.8060602@samsung.com>
Date: Mon, 01 Oct 2012 17:11:45 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR 3.7] Samsung S5P/Exynos SoC driver fixes/improvements
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 8928b6d1568eb9104cc9e2e6627d7086437b2fb3:

  [media] media: mx2_camera: use managed functions to clean up code (2012-09-27 15:56:47 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l_for_mauro

for you to fetch changes up to 5fe3854bf45656a790e9713d8851bb3953913b4e:

  s5p-tv: Report only multi-plane capabilities in vidioc_querycap (2012-10-01 16:16:26 +0200)

This series are mostly driver bug fixes, features include the transmission
errors logging in s5p-csis and end of stream handling in s5p-mfc driver. 
This series includes a few patches that were intended for 3.6, from that 
pull request http://patchwork.linuxtv.org/patch/14176.

Please pull for v3.7.

Thanks!
Sylwester

----------------------------------------------------------------
Andrzej Hajda (2):
      s5p-mfc: added support for end of stream handling in MFC encoder
      s5p-mfc: optimized code related to working contextes

Kamil Debski (1):
      s5p-mfc: Fix second memory bank alignment

Sachin Kamat (9):
      s5p-jpeg: Add missing braces around sizeof
      s5p-fimc: Replace asm/* headers with linux/*
      s5p-fimc: Add missing braces around sizeof
      s5p-mfc: Add missing braces around sizeof
      s5p-tv: Fix potential NULL pointer dereference error
      s5p-fimc: Fix incorrect condition in fimc_lite_reqbufs()
      exynos-gsc: Remove <linux/version.h> header file inclusion
      exynos-gsc: Add missing static storage class specifiers
      s5p-mfc: Fix misplaced return statement in s5p_mfc_suspend()

Sylwester Nawrocki (16):
      s5p-fimc: Enable FIMC-LITE driver only for SOC_EXYNOS4x12
      s5p-fimc: Don't allocate fimc-lite video device structure dynamically
      s5p-fimc: Don't allocate fimc-capture video device dynamically
      s5p-fimc: Don't allocate fimc-m2m video device dynamically
      m5mols: Add missing free_irq() on error path
      m5mols: Fix cast warnings from m5mols_[set/get]_ctrl_mode
      s5p-fimc: Fix setup of initial links to FIMC entities
      s5p-fimc: fimc-lite: Correct Bayer pixel format definitions
      s5p-fimc: fimc-lite: Propagate frame format on the subdev
      s5p-fimc: Add pipeline ops to separate FIMC-LITE module
      s5p-csis: Add transmission errors logging
      s5p-fimc: Keep local copy of sensors platform data
      m5mols: Remove unneeded control ops assignments
      m5mols: Protect driver data with a mutex
      s5k6aa: Fix possible NULL pointer dereference
      s5p-tv: Report only multi-plane capabilities in vidioc_querycap

 drivers/media/i2c/m5mols/m5mols.h               |  22 +++---
 drivers/media/i2c/m5mols/m5mols_controls.c      |   4 +-
 drivers/media/i2c/m5mols/m5mols_core.c          |  88 +++++++++++++--------
 drivers/media/i2c/s5k6aa.c                      |  11 +--
 drivers/media/platform/exynos-gsc/gsc-core.c    |   5 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c     |   5 +-
 drivers/media/platform/s5p-fimc/Kconfig         |   2 +-
 drivers/media/platform/s5p-fimc/fimc-capture.c  |  56 +++++++------
 drivers/media/platform/s5p-fimc/fimc-core.h     |   7 +-
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c |   8 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c     |  70 ++++++++---------
 drivers/media/platform/s5p-fimc/fimc-lite.h     |   6 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c      |  42 ++++------
 drivers/media/platform/s5p-fimc/fimc-mdevice.c  |  79 +++++++++++--------
 drivers/media/platform/s5p-fimc/fimc-mdevice.h  |  14 +---
 drivers/media/platform/s5p-fimc/fimc-reg.c      |   6 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c     | 160 +++++++++++++++++++++++++++++++++-----
 drivers/media/platform/s5p-jpeg/jpeg-core.c     |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 107 ++++++++++++++++++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  10 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |   8 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  32 +++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 140 ++++++++++++++++++++++-----------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |  48 +++++++++---
 drivers/media/platform/s5p-tv/mixer_drv.c       |   2 +-
 drivers/media/platform/s5p-tv/mixer_video.c     |   7 +-
 include/media/s5p_fimc.h                        |  18 +++++
 27 files changed, 622 insertions(+), 337 deletions(-)

-- 
Sylwester Nawrocki
Samsung Poland R&D Center
