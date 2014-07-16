Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57484 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbaGPMRp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jul 2014 08:17:45 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8T003S20TA9CA0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Jul 2014 13:17:34 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0N8T00C930TIZA30@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Jul 2014 13:17:42 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 3.17] mem2mem changes
Date: Wed, 16 Jul 2014 14:17:43 +0200
Message-id: <095801cfa0ef$f2b882c0$d8298840$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks
(2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-3.17

for you to fetch changes up to 3c3fe0e7e3d8702680b8a7dd2e3f11d7c6ebe798:

  s5p-mfc: limit the size of the CPB (2014-07-16 12:16:40 +0200)

----------------------------------------------------------------
Jacek Anaszewski (1):
      s5p-mfc: Fix selective sclk_mfc init

Maurizio Lombardi (1):
      s5p: fix error code path when failing to allocate DMA memory

Michael Olbrich (2):
      v4l2-mem2mem: export v4l2_m2m_try_schedule
      coda: try to schedule a decode run after a stop command

Philipp Zabel (30):
      coda: fix decoder I/P/B frame detection
      coda: fix readback of CODA_RET_DEC_SEQ_FRAME_NEED
      coda: fix h.264 quantization parameter range
      coda: fix internal framebuffer allocation size
      coda: simplify IRAM setup
      coda: Add encoder/decoder support for CODA960
      coda: remove BUG() in get_q_data
      coda: add selection API support for h.264 decoder
      coda: add workqueue to serialize hardware commands
      coda: Use mem-to-mem ioctl helpers
      coda: use ctx->fh.m2m_ctx instead of ctx->m2m_ctx
      coda: Add runtime pm support
      coda: split firmware version check out of coda_hw_init
      coda: select GENERIC_ALLOCATOR
      coda: add h.264 min/max qp controls
      coda: add h.264 deblocking filter controls
      coda: add cyclic intra refresh control
      coda: add decoder timestamp queue
      coda: alert userspace about macroblock errors
      coda: add sequence counter offset
      coda: rename prescan_failed to hold and stop stream after timeout
      coda: add reset control support
      coda: add bytesperline to queue data
      coda: allow odd width, but still round up bytesperline
      coda: round up internal frames to multiples of macroblock size for
h.264
      coda: increase frame stride to 16 for h.264
      coda: export auxiliary buffers via debugfs
      coda: store per-context work buffer size in struct coda_devtype
      coda: store global temporary buffer size in struct coda_devtype
      coda: store IRAM size in struct coda_devtype

panpan liu (1):
      s5p-mfc: limit the size of the CPB

 drivers/media/platform/Kconfig                |    1 +
 drivers/media/platform/coda.c                 | 1505
+++++++++++++++++--------
 drivers/media/platform/coda.h                 |  115 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |    5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |    9 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c   |   24 +
 drivers/media/v4l2-core/v4l2-mem2mem.c        |    3 +-
 include/media/v4l2-mem2mem.h                  |    2 +
 8 files changed, 1195 insertions(+), 469 deletions(-)

