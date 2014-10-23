Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27748 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaJWKcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 06:32:09 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDW006UE82CSB60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Oct 2014 11:35:00 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0NDW00C3B7XHMW20@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Oct 2014 11:32:06 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 3.19] mem2mem patches
Date: Thu, 23 Oct 2014 12:32:05 +0200
Message-id: <0d8c01cfeeac$97a2acc0$c6e80640$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 1ef24960ab78554fe7e8e77d8fc86524fbd60d3c:

  Merge tag 'v3.18-rc1' into patchwork (2014-10-21 08:32:51 -0200)

are available in the git repository at:


  http://git.linuxtv.org/cgit.cgi/kdebski/media_tree_2.git for-3.19

for you to fetch changes up to 85ec8ff4c39d8b56ca66e0f91bcfa0787e8f0342:

  s5p-mfc: correct the formats info for encoder (2014-10-23 11:33:03 +0200)

----------------------------------------------------------------
Arun Mankuzhi (2):
      s5p-mfc: modify mfc wakeup sequence for V8
      s5p-mfc: De-init MFC when watchdog kicks in

Ilja Friedel (1):
      s5p-mfc: Only set timestamp/timecode for new frames.

Kiran AVND (4):
      s5p-mfc: support MIN_BUFFERS query for encoder
      s5p-mfc: keep RISC ON during reset for V7/V8
      s5p-mfc: check mfc bus ctrl before reset
      s5p-mfc: flush dpbs when resolution changes

Pawel Osciak (5):
      s5p-mfc: Fix REQBUFS(0) for encoder.
      s5p-mfc: Don't crash the kernel if the watchdog kicks in.
      s5p-mfc: Remove unused alloc field from private buffer struct.
      s5p-mfc: fix V4L2_CID_MIN_BUFFERS_FOR_CAPTURE on resolution change.
      s5p-mfc: fix a race in interrupt flags handling

Philipp Zabel (19):
      coda: clear aborting flag in stop_streaming
      coda: remove superfluous error message on devm_kzalloc failure
      coda: add coda_write_base helper
      coda: disable rotator if not needed
      coda: simplify frame memory control register handling
      coda: add support for partial interleaved YCbCr 4:2:0 (NV12) format
      coda: add support for planar YCbCr 4:2:2 (YUV422P) format
      coda: identify platform device earlier
      coda: add coda_video_device descriptors
      coda: split out encoder control setup to specify controls per video
device
      coda: add JPEG register definitions for CODA7541
      coda: add CODA7541 JPEG support
      coda: store bitstream buffer position with buffer metadata
      coda: pad input stream for JPEG decoder
      coda: try to only queue a single JPEG into the bitstream
      coda: allow userspace to set compressed buffer size in a certain range
      coda: set bitstream end flag in coda_release
      coda: drop JPEG buffers not framed by SOI and EOI markers
      coda: re-queue buffers if start_streaming fails

Prathyush K (1):
      s5p-mfc: clear 'enter_suspend' flag if suspend fails

ayaka (1):
      s5p-mfc: correct the formats info for encoder

 drivers/media/platform/coda/Makefile            |    2 +-
 drivers/media/platform/coda/coda-bit.c          |  322 +++++++-----
 drivers/media/platform/coda/coda-common.c       |  594
+++++++++++++++--------
 drivers/media/platform/coda/coda-jpeg.c         |  238 +++++++++
 drivers/media/platform/coda/coda.h              |   24 +-
 drivers/media/platform/coda/coda_regs.h         |    7 +
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   45 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |  122 ++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   59 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |   13 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   32 +-
 14 files changed, 1043 insertions(+), 426 deletions(-)
 create mode 100644 drivers/media/platform/coda/coda-jpeg.c

