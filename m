Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:11642 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab2H0JNb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Aug 2012 05:13:31 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9E00GKOPLYA1L0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Aug 2012 18:13:30 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M9E008UBPLLV3D0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Aug 2012 18:13:30 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v5 0/4] Update MFC v4l2 driver to support MFC6.x
Date: Mon, 27 Aug 2012 17:27:59 +0530
Message-id: <1346068683-31610-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patchset adds support for MFCv6 firmware in s5p-mfc driver.
The first two patches will update the existing MFCv5 driver framework
for making it suitable for supporting co-existence with a newer
hardware version. The last two patches add support for MFCv6 firmware.
This patchset have to be applied on patches [1] and [2] posted
earlier which adds the required v4l2 controls.

Changelog:
- Modified ops mechanism for macro based function call
- Addressed all other review comments on Patch v4

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
 drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  440 ++++++
 drivers/media/video/s5p-mfc/regs-mfc.h       |   49 +
 drivers/media/video/s5p-mfc/s5p_mfc.c        |  229 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |   98 +-
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   13 +
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c |  164 +++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h |   20 +
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |  155 ++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.h |   20 +
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  174 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  188 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  226 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  208 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   11 +-
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1407 ++-----------------
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  178 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c | 1759 +++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h |   85 ++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1945 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |   50 +
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |    3 +-
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   47 -
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   90 --
 28 files changed, 5700 insertions(+), 1873 deletions(-)
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

