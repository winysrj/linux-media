Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:61486 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661Ab2JCRGL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 13:06:11 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBB00K5CU699FC0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 02:06:09 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBB009RUU5VQI80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 02:06:09 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, arun.kk@samsung.com,
	joshi@samsung.com
Subject: [PATCH v10 0/7] Update MFC v4l2 driver to support MFC6.x
Date: Thu, 04 Oct 2012 06:49:04 +0530
Message-id: <1349313551-23368-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patchset adds support for MFCv6 firmware in s5p-mfc driver.
The patches are rebased to the latest media-tree.

Changelog v10
- Rebased onto latest media-tree 3.7 staging
- Split driver rearchitecture patch into two

Changelog v9
- Addressed review comments by Hans Verkuil
http://www.mail-archive.com/linux-media@vger.kernel.org/msg53016.html

Changelog v8
- Addressed review comments by Sylwester Nawrocki
http://www.mail-archive.com/linux-media@vger.kernel.org/msg52942.html

Changelog v7
- Removed unused macros from register files

Changelog v6
- Use s5p_mfc_hw_call macro to call all HW related ops and cmds
- Rebased onto latest media-tree
- Resending patches adding required v4l controls
- Addressed review comments of Patch v5

Changelog v5
- Modified ops mechanism for macro based function call
- Addressed all other review comments on Patch v4

Changelog v4
- Separate patch for callback based architecture.
- Patches divided to enable incremental compilation.
- Working MFCv6 encoder and decoder.
- Addressed review comments given for v3 patchset.

Changelog v3
- Supports MFCv5 and v6 co-existence.
- Tested for encoding & decoding in MFCv5.
- Supports only decoding in MFCv6 now.
- Can be compiled with kernel image and as module.
- Config macros for MFC version selection removed.
- All previous review comments addressed.

Changelog v2
- Addressed review comments received
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/45189

Changelog v1
- Fixed crash issue in Exynos4 SoCs running MFC 5.1
- Encoder not tested

Arun Kumar K (5):
  [media] v4l: Add fourcc definitions for new formats
  [media] v4l: Add control definitions for new H264 encoder features
  [media] s5p-mfc: Prepare driver for callback based re-architecture
  [media] s5p-mfc: Update MFCv5 driver for callback based architecture
  [media] s5p-mfc: Add MFC variant data to device context

Jeongtae Park (2):
  [media] s5p-mfc: MFCv6 register definitions
  [media] s5p-mfc: Update MFC v4l2 driver to support MFC6.x

 Documentation/DocBook/media/v4l/controls.xml     |  268 +++-
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml |   17 +-
 Documentation/DocBook/media/v4l/pixfmt.xml       |   10 +
 drivers/media/platform/Kconfig                   |    4 +-
 drivers/media/platform/s5p-mfc/Makefile          |    7 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h     |  408 +++++
 drivers/media/platform/s5p-mfc/regs-mfc.h        |   41 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c         |  293 +++--
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c     |  111 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h     |   17 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c  |  166 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h  |   20 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c  |  156 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h  |   20 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h  |  191 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c    |  202 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c     |  258 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.h     |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c     |  236 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.h     |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_intr.c    |   11 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c     | 1418 +----------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h     |  137 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c  | 1794 ++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.h  |   85 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c  | 1956 ++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h  |   50 +
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c      |    3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_shm.c     |   47 -
 drivers/media/platform/s5p-mfc/s5p_mfc_shm.h     |   90 -
 drivers/media/v4l2-core/v4l2-ctrls.c             |   42 +
 include/linux/v4l2-controls.h                    |   41 +
 include/linux/videodev2.h                        |    4 +
 34 files changed, 5981 insertions(+), 2125 deletions(-)
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

