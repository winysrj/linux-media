Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58635 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaEUI3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 04:29:11 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5X002U80WIMB30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 May 2014 09:29:06 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0N5X00ASD0WGTQ80@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 May 2014 09:29:05 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.16] mem2mem patches
Date: Wed, 21 May 2014 10:29:04 +0200
Message-id: <06ad01cf74ce$ba830f30$2f892d90$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 61b2123701c3568fcf8a07e69fe1c2854f640a4e:

  v4l: ti-vpe: Rename csc memory resource name (2014-05-14 15:53:39 +0200)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-3.16-3

for you to fetch changes up to a48bcde914d311835ead01d81d25d304a913b718:

  s5p-mfc: Core support for v8 encoder (2014-05-20 15:19:41 +0200)

----------------------------------------------------------------
Alexander Shiyan (2):
      media: mx2-emmaprp: Cleanup internal structure
      media: mx2-emmaprp: Add missing mutex_destroy()

Arun Kumar K (3):
      s5p-mfc: Update scratch buffer size for MPEG4
      s5p-mfc: Move INIT_BUFFER_OPTIONS from v7 to v6
      s5p-mfc: Rename IS_MFCV7 macro

John Sheu (1):
      s5p-mfc: fix encoder crash after VIDIOC_STREAMOFF

Kamil Debski (2):
      v4l: s5p-mfc: Fix default pixel format selection for decoder
      v4l: s5p-mfc: Limit enum_fmt to output formats of current version

Kiran AVND (4):
      s5p-mfc: Update scratch buffer size for VP8 encoder
      s5p-mfc: Add variants to access mfc registers
      s5p-mfc: Core support to add v8 decoder
      s5p-mfc: Core support for v8 encoder

Pawel Osciak (5):
      s5p-mfc: Copy timestamps only when a frame is produced.
      s5p-mfc: Fixes for decode REQBUFS.
      s5p-mfc: Extract open/close MFC instance commands.
      s5p-mfc: Don't allocate codec buffers on STREAMON.
      s5p-mfc: Don't try to resubmit VP8 bitstream buffer for decode.

 .../devicetree/bindings/media/s5p-mfc.txt          |    3 +-
 drivers/media/platform/mx2_emmaprp.c               |   37 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h       |    4 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h       |    5 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |  124 +++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   71 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   15 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   62 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h      |    3 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  285 ++++---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   93 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       |    6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |  254 ++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  842
+++++++++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |    7 +-
 15 files changed, 1300 insertions(+), 511 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v8.h

