Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33896 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaIXJER (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 05:04:17 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NCE00IIRENU3A40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Sep 2014 10:07:06 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0NCE00432EJ26640@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Sep 2014 10:04:15 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 3.18] mem2mem changes
Date: Wed, 24 Sep 2014 11:04:14 +0200
Message-id: <094e01cfd7d6$83e54e50$8bafeaf0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c0aaf696d45e2a72048a56441e81dad78659c698:

  [media] coda: coda-bit: Include "<linux/slab.h>" (2014-09-21 16:43:28
-0300)

are available in the git repository at:

  ssh://linuxtv/git/kdebski/media_tree_2.git for-v3.18-2

for you to fetch changes up to 242b5f7029ab613008a3c2bcc6a4ca181a64d0c9:

  coda: Improve runtime PM support (2014-09-23 16:08:08 +0200)

----------------------------------------------------------------
Kamil Debski (1):
      s5p-mfc: Fix sparse errors in the MFC driver

Sjoerd Simons (1):
      s5p-mfc: Use decode status instead of display status on MFCv5

Ulf Hansson (1):
      coda: Improve runtime PM support

Zhaowei Yuan (2):
      s5p_mfc: correct the loop condition
      s5p_mfc: unify variable naming style

ayaka (1):
      s5p-mfc: fix enum_fmt for s5p-mfc

 drivers/media/platform/coda/coda-common.c       |   55 +--
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   53 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |   16 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   46 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   50 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    8 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  471
+++++++++++------------
 8 files changed, 331 insertions(+), 374 deletions(-)

