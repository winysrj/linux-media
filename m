Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64839 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050AbbLRRWP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 12:22:15 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NZK00E14DL13WB0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 18 Dec 2015 17:22:13 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: "'open list:ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC)...'"
	<linux-media@vger.kernel.org>
Cc: kamil@wypas.org
Subject: [GIT PULL] mem2mem changes
Date: Fri, 18 Dec 2015 18:22:11 +0100
Message-id: <009201d139b8$a1ac14b0$e5043e10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ecc2fe20e63a21b7db23065ff061b66fbc08e08b:

  [media] cx23885: video instead of vbi register used (2015-12-18 13:37:12
-0200)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-4.5

for you to fetch changes up to 64d8dc83df6bbd58e1782670d6adaf2ff6be9141:

  coda: enable MPEG-2 ES decoding (2015-12-18 17:31:03 +0100)

----------------------------------------------------------------
Andrzej Hajda (6):
      s5p-mfc: use one implementation of s5p_mfc_get_new_ctx
      s5p-mfc: make queue cleanup code common
      s5p-mfc: remove unnecessary callbacks
      s5p-mfc: use spinlock to protect MFC context
      s5p-mfc: merge together s5p_mfc_hw_call and s5p_mfc_hw_call_void
      s5p-mfc: remove volatile attribute from MFC register addresses

Julia Lawall (1):
      s5p-mfc: constify s5p_mfc_codec_ops structures

Philipp Zabel (5):
      coda: make to_coda_video_device static
      coda: relax coda_jpeg_check_buffer for trailing bytes
      coda: hook up vidioc_prepare_buf
      coda: don't start streaming without queued buffers
      coda: enable MPEG-2 ES decoding

 drivers/media/platform/coda/coda-bit.c          |   2 +-
 drivers/media/platform/coda/coda-common.c       |  21 +-
 drivers/media/platform/coda/coda-jpeg.c         |  26 +-
 drivers/media/platform/coda/coda.h              |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  99 +++--
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  14 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |  16 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  35 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.h    |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  44 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.h    |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    | 507
++++++++++++------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  94 -----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 121 +-----
 14 files changed, 390 insertions(+), 595 deletions(-)

