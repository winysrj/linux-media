Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12998 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaICI6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 04:58:21 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBB00BNGIDUXC90@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Sep 2014 10:01:06 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0NBB00CS4I91P990@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Sep 2014 09:58:14 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Linux Media Mailing List' <linux-media@vger.kernel.org>
Subject: [GIT PULL for 3.18] mem2mem changes
Date: Wed, 03 Sep 2014 10:58:12 +0200
Message-id: <099901cfc755$31f4ad20$95de0760$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit b250392f7b5062cf026b1423e27265e278fd6b30:

  [media] media: ttpci: fix av7110 build to be compatible with
CONFIG_INPUT_EVDEV (2014-08-21 15:25:38 -0500)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-3.18

for you to fetch changes up to af26e239d419b5ab4ac49dd8ee585891f25a3e51:
z
  v4l: vsp1: fix driver dependencies (2014-09-03 10:33:25 +0200)

----------------------------------------------------------------
Bartlomiej Zolnierkiewicz (1):
      v4l: vsp1: fix driver dependencies

Jacek Anaszewski (4):
      s5p-jpeg: Avoid assigning readl result
      s5p-jpeg: remove stray call to readl
      s5p-jpeg: avoid overwriting JPEG_CNTL register settings
      s5p-jpeg: fix HUF_TBL_EN bit clearing path

Marek Szyprowski (1):
      media: s5p-mfc: rename special clock to sclk_mfc

Mauro Carvalho Chehab (5):
      s5p_mfc: don't use an external symbol called 'debug'
      s5p-jpeg: get rid of some warnings
      g2d: remove unused var
      s5p_mfc_ctrl: add missing s5p_mfc_ctrl.h header
      s5p_mfc: get rid of several warnings

Zhaowei Yuan (2):
      media: s5p_mfc: Release ctx->ctx if failed to allocate ctx->shm
      media: s5p-mfc: correct improper logs

 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/s5p-g2d/g2d.c               |    7 +++----
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    2 +-
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |    2 ++
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c  |    9 +++------
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c      |    6 ++----
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    6 ++----
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |    5 +++--
 drivers/media/platform/s5p-mfc/s5p_mfc_debug.h     |    6 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    7 ++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |    3 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |    2 +-
 15 files changed, 28 insertions(+), 34 deletions(-)

