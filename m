Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51758 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3GIFBh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 01:01:37 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MPN00HAEKLEDNI0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Jul 2013 14:01:30 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v5 0/8] Add support for MFC v7 firmware
Date: Tue, 09 Jul 2013 10:54:34 +0530
Message-id: <1373347482-9264-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds MFC v7 firmware support to the Exynos
MFC driver. MFC v7 is present in 5420 SoC which has support
for VP8 encoding and many other features.

Changes from v4:
- Addressed review comments from Hans and added ack
http://www.mail-archive.com/linux-media@vger.kernel.org/msg64101.html

Changes from v3:
- Addressed review comments from Hans
http://www.mail-archive.com/linux-media@vger.kernel.org/msg63893.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg63905.html
- Addressed comments from Kamil
http://www.mail-archive.com/linux-media@vger.kernel.org/msg63747.html

Changes from v2:
- Addressed review comments from Sylwester
http://www.mail-archive.com/linux-media@vger.kernel.org/msg63676.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg63677.html

Changes from v1:
- Addressed review comments from Hans and Sylwester
http://www.mail-archive.com/linux-media@vger.kernel.org/msg63148.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg63311.html
- Modified IS_MFCV6 macro to IS_MFCV6_PLUS to include v7 also

Arun Kumar K (7):
  [media] s5p-mfc: Update v6 encoder buffer sizes
  [media] s5p-mfc: Rename IS_MFCV6 macro
  [media] s5p-mfc: Add register definition file for MFC v7
  [media] s5p-mfc: Core support for MFC v7
  [media] s5p-mfc: Update driver for v7 firmware
  [media] V4L: Add VP8 encoder controls
  [media] s5p-mfc: Add support for VP8 encoder

Sylwester Nawrocki (1):
  [media] V4L: Add support for integer menu controls with standard menu
    items

 Documentation/DocBook/media/v4l/controls.xml       |  168 +++++++++++++++++++-
 .../devicetree/bindings/media/s5p-mfc.txt          |    1 +
 Documentation/video4linux/v4l2-controls.txt        |   21 +--
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h       |    4 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h       |   61 +++++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   32 ++++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |    3 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   23 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   18 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  107 ++++++++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  149 +++++++++++++++--
 drivers/media/v4l2-core/v4l2-ctrls.c               |   67 +++++++-
 include/uapi/linux/v4l2-controls.h                 |   29 ++++
 16 files changed, 642 insertions(+), 57 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v7.h

-- 
1.7.9.5

