Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:60188 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab2GWMOU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 08:14:20 -0400
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7M000KH4NTVZR0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jul 2012 21:14:18 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M7M006154NPVNB0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jul 2012 21:14:18 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v3 0/4] update MFC v4l2 driver to support MFC6.x
Date: Mon, 23 Jul 2012 17:59:13 +0530
Message-id: <1343046557-25353-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patchset adds support for MFCv6 firmware in s5p-mfc driver.
The original patch is split into 4 patches for easy review.
This patchset have to be applied on patches [1] and [2] posted
earlier which adds the required v4l2 controls.

Changelog
- Supports MFCv5 and v6 co-existence.
- Tested for encoding & decoding in MFCv5.
- Supports only decoding in MFCv6 now.
- Can be compiled with kernel image and as module.
- Config macros for MFC version selection removed.
- All previous review comments addressed.

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg48972.html
[2] http://www.mail-archive.com/linux-media@vger.kernel.org/msg48973.html

Jeongtae Park (4):
  [media] s5p-mfc: update MFC v4l2 driver to support MFC6.x
  [media] s5p-mfc: Decoder and encoder common files
  [media] s5p-mfc: Modified command and opr files for MFCv5
  [media] s5p-mfc: New files for MFCv6 support

 drivers/media/video/Kconfig                  |    4 +-
 drivers/media/video/s5p-mfc/Makefile         |    7 +-
 drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  392 ++++++
 drivers/media/video/s5p-mfc/regs-mfc.h       |   33 +-
 drivers/media/video/s5p-mfc/s5p_mfc.c        |  225 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |   98 +--
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   13 +
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c |  164 +++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h |   22 +
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |  155 +++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.h |   22 +
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  153 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  198 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  223 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  200 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   11 +-
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1402 ++-----------------
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  179 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c | 1767 +++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h |   85 ++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1921 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |   50 +
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |    8 +-
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   47 -
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   90 --
 28 files changed, 5605 insertions(+), 1867 deletions(-)
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

