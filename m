Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60801 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966228Ab3E2ONu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:13:50 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNK00JX5CRXZ870@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 May 2013 15:13:48 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MNK000FMCUSVE60@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 May 2013 15:13:48 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] mem2mem fixes for 3.10
Date: Wed, 29 May 2013 16:13:39 +0200
Message-id: <022201ce5c76$b86eab80$294c0280$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 6719a4974600fdaa4a3ac2ea2aed819a35d06605:

  [media] staging/solo6x10: select the desired font (2013-05-27 09:38:57
-0300)

are available in the git repository at:

  git://git.linuxtv.org/kdebski/media.git fixes-for-3.10

for you to fetch changes up to d1b03ab0b4273bbe2c0680c2d66e984060ab501b:

  s5p-mfc: Add NULL check for allocated buffer (2013-05-29 16:06:14 +0200)

----------------------------------------------------------------
??? (2):
      media: vb2: return for polling if a buffer is available
      media: v4l2-mem2mem: return for polling if a buffer is available

Andrzej Hajda (3):
      s5p-mfc: separate encoder parameters for h264 and mpeg4
      s5p-mfc: v4l2 controls setup routine moved to initialization code
      s5p-mfc: added missing end-of-lines in debug messages

Arun Kumar K (2):
      s5p-mfc: Update v6 encoder buffer alloc
      s5p-mfc: Remove special clock usage in driver

John Sheu (1):
      v4l2: mem2mem: save irq flags correctly

Philipp Zabel (2):
      v4l2-mem2mem: add v4l2_m2m_create_bufs helper
      coda: v4l2-compliance fix: add VIDIOC_CREATE_BUFS support

Sachin Kamat (1):
      s5p-mfc: Add NULL check for allocated buffer

Sylwester Nawrocki (1):
      s5p-mfc: Remove unused s5p_mfc_get_decoded_status_v6() function

 drivers/media/platform/coda.c                   |    9 +++
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |    8 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_debug.h  |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   20 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   82
++++++++++++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   53 +++++----------
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     |   23 +------
 drivers/media/v4l2-core/v4l2-mem2mem.c          |   39 ++++++++---
 drivers/media/v4l2-core/videobuf2-core.c        |    3 +-
 include/media/v4l2-mem2mem.h                    |    2 +
 13 files changed, 136 insertions(+), 119 deletions(-)


