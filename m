Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30188 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2JBQ6u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 12:58:50 -0400
Received: from eusync4.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MB900DJCZ6Y4470@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 17:59:22 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MB900L98Z5ZO6B0@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 17:58:47 +0100 (BST)
Message-id: <506B1D47.8040602@samsung.com>
Date: Tue, 02 Oct 2012 18:58:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR 3.7] Samsung Exynos MFC driver update
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 34a6b7d093d8fe738ada191b36648d00bc18b7eb:

  [media] v4l2-ctrls: add a filter function to v4l2_ctrl_add_handler
(2012-10-01 17:07:07 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-2.6-samsung v4l_mfc_for_mauro

for you to fetch changes up to 8312d9d2d254ab289a322fcfdba1d1ecf5e36256:

  s5p-mfc: Update MFC v4l2 driver to support MFC6.x (2012-10-02 15:28:42 +0200)

This is an update of the s5p-mfc driver and related V4L2 API additions
to support the Multi Format Codec device on the Exynos5 SoC series.

----------------------------------------------------------------
Arun Kumar K (4):
      v4l: Add fourcc definitions for new formats
      v4l: Add control definitions for new H264 encoder features
      s5p-mfc: Update MFCv5 driver for callback based architecture
      s5p-mfc: Add MFC variant data to device context

Jeongtae Park (2):
      s5p-mfc: MFCv6 register definitions
      s5p-mfc: Update MFC v4l2 driver to support MFC6.x

 Documentation/DocBook/media/v4l/controls.xml       |  268 ++-
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml   |   17 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         |   10 +
 drivers/media/platform/Kconfig                     |    4 +-
 drivers/media/platform/s5p-mfc/Makefile            |    7 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h       |  408 ++++
 drivers/media/platform/s5p-mfc/regs-mfc.h          |   41 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  296 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c       |  109 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h       |   15 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c    |  166 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h    |   20 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |  156 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h    |   20 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  191 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |  194 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h      |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  258 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.h       |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  239 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.h       |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_intr.c      |   11 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       | 1386 +-------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |  133 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    | 1763 ++++++++++++++++++
 .../s5p-mfc/{s5p_mfc_shm.h => s5p_mfc_opr_v5.h}    |   41 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    | 1956 ++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |   50 +
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |    3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_shm.c       |   47 -
 drivers/media/v4l2-core/v4l2-ctrls.c               |   42 +
 include/linux/v4l2-controls.h                      |   41 +
 include/linux/videodev2.h                          |    4 +
 33 files changed, 5873 insertions(+), 2026 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v6.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
 rename drivers/media/platform/s5p-mfc/{s5p_mfc_shm.h => s5p_mfc_opr_v5.h} (76%)
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
 delete mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_shm.c

---

Thank you,

Sylwester Nawrocki
Samsung Poland R&D Center
