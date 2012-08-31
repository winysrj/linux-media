Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:18129 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2HaNqp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 09:46:45 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9M00M9NGMFMO80@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Aug 2012 22:46:44 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M9M00K7JGWALLB0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Aug 2012 22:46:43 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com, kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v6 0/6] Update MFC v4l2 driver to support MFC6.x
Date: Fri, 31 Aug 2012 22:37:36 +0530
Message-id: <1346432862-14242-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patchset adds support for MFCv6 firmware in s5p-mfc driver.
The first two patches which adds the necessary v4l controls are
resend after rebasing on latest media-tree.

Changelog:
- Use s5p_mfc_hw_call macro to call all HW related ops and cmds
- Rebased onto latest media-tree
- Resending patches adding required v4l controls
- Addressed review comments of Patch v5

Arun Kumar K (1):
  [media] s5p-mfc: Update MFCv5 driver for callback based architecture

Jeongtae Park (5):
  [media] v4l: Add fourcc definitions for new formats
  [media] v4l: Add control definitions for new H264 encoder features
  [media] s5p-mfc: Add MFC variant data to device context
  [media] s5p-mfc: MFCv6 register definitions
  [media] s5p-mfc: Update MFC v4l2 driver to support MFC6.x

 Documentation/DocBook/media/v4l/controls.xml     |  268 +++-
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml |   17 +-
 Documentation/DocBook/media/v4l/pixfmt.xml       |   10 +
 drivers/media/platform/Kconfig                   |    4 +-
 drivers/media/platform/s5p-mfc/Makefile          |    7 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h     |  440 +++++
 drivers/media/platform/s5p-mfc/regs-mfc.h        |   49 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c         |  296 +++--
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c     |  109 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h     |   15 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c  |  166 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h  |   20 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c  |  156 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h  |   20 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h  |  191 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c    |  194 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c     |  258 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.h     |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c     |  239 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.h     |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_intr.c    |   11 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c     | 1386 +---------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h     |  133 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c  | 1763 +++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.h  |   85 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c  | 1956 ++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h  |   50 +
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c      |    3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_shm.c     |   47 -
 drivers/media/platform/s5p-mfc/s5p_mfc_shm.h     |   90 -
 drivers/media/v4l2-core/v4l2-ctrls.c             |   42 +
 include/linux/videodev2.h                        |   45 +
 33 files changed, 5980 insertions(+), 2093 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v6.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
 delete mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_shm.c
 delete mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_shm.h

