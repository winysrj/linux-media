Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44034 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3HFKKo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 06:10:44 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MR300FENTLQMR60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Aug 2013 11:10:42 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MR3009CSTLTX700@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Aug 2013 11:10:42 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] New features for 3.12
Date: Tue, 06 Aug 2013 12:10:41 +0200
Message-id: <030c01ce928d$3564b700$a02e2500$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit b43ea8068d2090cb1e44632c8a938ab40d2c7419:

  [media] cx23885: Fix TeVii S471 regression since introduction of ts2020
(2013-07-30 17:23:24 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media.git new-for-3.12-2nd

for you to fetch changes up to 8f55301a822a27f9c30c87284ff1d9e13aa1ea31:

  s5p-mfc: Add support for VP8 encoder (2013-08-01 11:57:56 +0200)

----------------------------------------------------------------
Arun Kumar K (7):
      s5p-mfc: Update v6 encoder buffer sizes
      s5p-mfc: Rename IS_MFCV6 macro
      s5p-mfc: Add register definition file for MFC v7
      s5p-mfc: Core support for MFC v7
      s5p-mfc: Update driver for v7 firmware
      V4L: Add VP8 encoder controls
      s5p-mfc: Add support for VP8 encoder

Sylwester Nawrocki (1):
      V4L: Add support for integer menu controls with standard menu items

 Documentation/DocBook/media/v4l/controls.xml       |  168
+++++++++++++++++++-
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

