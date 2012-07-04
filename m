Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:16153 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2GDMRQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2012 08:17:16 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6M00MBCY4QSIQ0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Jul 2012 21:17:14 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M6M00BBUY4EBE00@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Jul 2012 21:17:14 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com, arun.kk@samsung.com
Subject: [PATCH v1] s5p-mfc: update MFC v4l2 driver to support MFC6.x
Date: Wed, 04 Jul 2012 18:00:43 +0530
Message-id: <1341405044-16051-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is re-worked version of the original patch posted
by Jeongtae Park for support of MFCv6.x
The comment given by Kamil Debski can be found here:
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/45189
The crash issue reported on MFC 5.1 on applying this patch has been fixed.
This is tested for decoding functionality on MFC 5.1 and MFC 6.5.
Encoder functionality is not tested on Exynos5 yet.

Jeongtae Park (1):
  [media] s5p-mfc: update MFC v4l2 driver to support MFC6.x

 drivers/media/video/Kconfig                  |   16 +-
 drivers/media/video/s5p-mfc/Makefile         |    7 +-
 drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  676 ++++++++++
 drivers/media/video/s5p-mfc/regs-mfc.h       |   29 +
 drivers/media/video/s5p-mfc/s5p_mfc.c        |  163 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |    6 +-
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |    3 +
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |   96 ++
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  123 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  160 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  210 +++-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  377 +++++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |    1 -
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |  282 +++--
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   25 +-
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1697 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |  140 +++
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |    6 +-
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   28 +-
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   13 +-
 23 files changed, 3661 insertions(+), 400 deletions(-)
 create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h

