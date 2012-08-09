Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:47512 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2HIKMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 06:12:24 -0400
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8H009YNGC8K5X0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Aug 2012 19:12:22 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8H00MGUGCES850@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Aug 2012 19:12:22 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v4 0/4] Update MFC v4l2 driver to support MFC6.x
Date: Thu, 09 Aug 2012 15:58:26 +0530
Message-id: <1344508110-16945-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patchset adds support for MFCv6 firmware in s5p-mfc driver.
The first two patches will update the existing MFCv5 driver framework
for making it suitable for supporting co-existence with a newer
hardware version. The last two patches add support for MFCv6 firmware.
This patchset have to be applied on patches [1] and [2] posted
earlier which adds the required v4l2 controls.

Changelog:
- Separate patch for callback based architecture.
- Patches divided to enable incremental compilation.
- Working MFCv6 encoder and decoder.
- Addressed review comments given for v3 patchset.

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg48972.html
[2] http://www.mail-archive.com/linux-media@vger.kernel.org/msg48973.html

Arun Kumar K (1):
  [media] s5p-mfc: Update MFCv5 driver for callback based architecture

Jeongtae Park (3):
  [media] s5p-mfc: Add MFC variant data to device context
  [media] s5p-mfc: MFCv6 register definitions
  [media] s5p-mfc: Update MFC v4l2 driver to support MFC6.x

 drivers/media/video/Kconfig                  |    4 +-
 drivers/media/video/s5p-mfc/Makefile         |    7 +-
 drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  429 ++++++
 drivers/media/video/s5p-mfc/regs-mfc.h       |   29 +
 drivers/media/video/s5p-mfc/s5p_mfc.c        |  224 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |   98 +-
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   13 +
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c |  164 +++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h |   20 +
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |  155 ++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.h |   20 +
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  156 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  188 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  223 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  205 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   11 +-
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1405 ++-----------------
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  178 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c | 1761 +++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h |   85 ++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1944 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |   50 +
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |    3 +-
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   47 -
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   90 --
 28 files changed, 5645 insertions(+), 1867 deletions(-)
 create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h
 delete mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.c
 delete mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.h

