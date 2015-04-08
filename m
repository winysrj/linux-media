Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30447 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbbDHKH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 06:07:59 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NMH003ROGBUIP80@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Apr 2015 11:11:54 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0NMH00I32G57DE90@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Apr 2015 11:07:55 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.1] mem2mem changes for 4.1
Date: Wed, 08 Apr 2015 12:07:54 +0200
Message-id: <02df01d071e3$e21c1330$a6543990$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c8c7c44b7cf5ef7163e4bd6aedbdeb6f6031ee3e:

  [media] s5p-jpeg: Remove some unused functions (2015-04-07 08:15:15 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-4.1-v2

for you to fetch changes up to 8dae02ffa32db8193513ee0a3c6dcd277e653954:

  coda: Add tracing support (2015-04-08 11:54:12 +0200)

----------------------------------------------------------------
Kamil Debski (4):
      vb2: split the io_flags member of vb2_queue into a bit field
      vb2: add allow_zero_bytesused flag to the vb2_queue struct
      coda: set allow_zero_bytesused flag for vb2_queue_init
      s5p-mfc: set allow_zero_bytesused flag for vb2_queue_init

Peter Seiderer (2):
      coda: check kasprintf return value in coda_open
      coda: fix double call to debugfs_remove

Philipp Zabel (16):
      v4l2-mem2mem: no need to initialize b in v4l2_m2m_next_buf and
v4l2_m2m_buf_remove
      gpu: ipu-v3: Add missing IDMAC channel names
      gpu: ipu-v3: Add mem2mem image conversion support to IC
      gpu: ipu-v3: Register scaler platform device
      coda: bitrate can only be set in kbps steps
      coda: bitstream payload is unsigned
      coda: use strlcpy instead of snprintf
      coda: allocate per-context buffers from REQBUFS
      coda: allocate bitstream buffer from REQBUFS, size depends on the
format
      coda: move parameter buffer in together with context buffer allocation
      coda: remove duplicate error messages for buffer allocations
      coda: fail to start streaming if userspace set invalid formats
      coda: call SEQ_END when the first queue is stopped
      coda: fix fill bitstream errors in nonstreaming case
      coda: drop dma_sync_single_for_device in coda_bitstream_queue
      coda: Add tracing support

Sascha Hauer (2):
      imx-ipu: Add ipu media common code
      imx-ipu: Add i.MX IPUv3 scaler driver

 drivers/gpu/ipu-v3/ipu-common.c             |    2 +
 drivers/gpu/ipu-v3/ipu-ic.c                 |  787 +++++++++++++++++++++++-
 drivers/media/platform/Kconfig              |    2 +
 drivers/media/platform/Makefile             |    1 +
 drivers/media/platform/coda/Makefile        |    2 +
 drivers/media/platform/coda/coda-bit.c      |  205 +++++--
 drivers/media/platform/coda/coda-common.c   |  113 ++--
 drivers/media/platform/coda/coda-jpeg.c     |    1 +
 drivers/media/platform/coda/coda.h          |   18 +-
 drivers/media/platform/coda/trace.h         |  203 +++++++
 drivers/media/platform/imx/Kconfig          |   11 +
 drivers/media/platform/imx/Makefile         |    2 +
 drivers/media/platform/imx/imx-ipu-scaler.c |  869
+++++++++++++++++++++++++++
 drivers/media/platform/imx/imx-ipu.c        |  313 ++++++++++
 drivers/media/platform/imx/imx-ipu.h        |   36 ++
 drivers/media/platform/s5p-mfc/s5p_mfc.c    |    7 +
 drivers/media/v4l2-core/v4l2-mem2mem.c      |    4 +-
 drivers/media/v4l2-core/videobuf2-core.c    |   56 +-
 include/media/videobuf2-core.h              |   20 +-
 include/video/imx-ipu-v3.h                  |   49 +-
 20 files changed, 2535 insertions(+), 166 deletions(-)
 create mode 100644 drivers/media/platform/coda/trace.h
 create mode 100644 drivers/media/platform/imx/Kconfig
 create mode 100644 drivers/media/platform/imx/Makefile
 create mode 100644 drivers/media/platform/imx/imx-ipu-scaler.c
 create mode 100644 drivers/media/platform/imx/imx-ipu.c
 create mode 100644 drivers/media/platform/imx/imx-ipu.h

