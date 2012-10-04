Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58505 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965609Ab2JDPSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 11:18:55 -0400
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBD00091JW4WZ40@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:19:17 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MBD00GO5JVHZ340@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:18:53 +0100 (BST)
Message-id: <506DA8DC.1000504@samsung.com>
Date: Thu, 04 Oct 2012 17:18:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: 'Arun Kumar K' <arun.kk@samsung.com>
Subject: [GIT PULL v2 FOR v3.7] Samsung Exynos MFC driver update
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4:

  em28xx: regression fix: use DRX-K sync firmware requests on em28xx
(2012-10-02 17:15:22 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l_mfc_for_mauro

for you to fetch changes up to e2b0cbe5e32bfbbd68773c90411a9e1309df7ec3:

  s5p-mfc: Set vfl_dir for encoder (2012-10-04 14:52:29 +0200)

I ensured this time it's rebased onto latest staging/for_v3.7 branch.
Additionally the patch
"[media] s5p-mfc: Update MFCv5 driver for callback based architecture"
has been split in two and there is also included one patch adding
missing vfl_dir flag for the codec device (s5p-mfc: Set vfl_dir for
encoder).

----------------------------------------------------------------
Arun Kumar K (6):
      v4l: Add fourcc definitions for new formats
      v4l: Add control definitions for new H264 encoder features
      s5p-mfc: Prepare driver for callback based re-architecture
      s5p-mfc: Update MFCv5 driver for callback based architecture
      s5p-mfc: Add MFC variant data to device context
      s5p-mfc: Set vfl_dir for encoder

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
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  294 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c       |  111 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h       |   17 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c    |  166 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h    |   20 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |  156 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h    |   20 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  191 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |  202 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h      |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  258 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.h       |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  236 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.h       |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_intr.c      |   11 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       | 1418 +-------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |  137 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    | 1794 ++++++++++++++++++
 .../s5p-mfc/{s5p_mfc_shm.h => s5p_mfc_opr_v5.h}    |   41 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    | 1956 ++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |   50 +
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |    3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_shm.c       |   47 -
 drivers/media/v4l2-core/v4l2-ctrls.c               |   42 +
 include/linux/v4l2-controls.h                      |   41 +
 include/linux/videodev2.h                          |    4 +
 33 files changed, 5915 insertions(+), 2058 deletions(-)
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

Regards,
Sylwester
