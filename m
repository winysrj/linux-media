Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:24853 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GFNqi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 09:46:38 -0400
Received: from epcpsbgm2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6Q00FTIRLNIX00@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 06 Jul 2012 22:46:37 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M6Q00L9JRLECT00@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 06 Jul 2012 22:46:37 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com, hans.verkuil@cisco.com,
	mchehab@infradead.org
Subject: [PATCH v2 0/2] update MFC v4l2 driver to support MFC6.x
Date: Fri, 06 Jul 2012 19:30:15 +0530
Message-id: <1341583217-11305-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the v2 series of patches for adding support for MFC v6.x.
In this the new v4l controls added in patch [1] are removed. These can be
added as a separate patch later for providing extra encoder controls for
MFC v6. This also incorporates the review comments received for the original
patch and fixed for backward compatibility with MFC v5.

[1] http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/45190/

Jeongtae Park (2):
  [media] v4l: add fourcc definitions for new formats
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
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  191 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |    1 -
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |  278 +++--
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   25 +-
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1697 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |  140 +++
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |    6 +-
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   28 +-
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   13 +-
 drivers/media/video/v4l2-ctrls.c             |    1 -
 include/linux/videodev2.h                    |    4 +
 25 files changed, 3480 insertions(+), 396 deletions(-)
 create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h

