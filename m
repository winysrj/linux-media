Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29047 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaHFPUn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 11:20:43 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9W004J05AF7J60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Aug 2014 16:20:39 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0N9W00F5Y5AG0G20@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Aug 2014 16:20:40 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] mem2mem: coda driver changes
Date: Wed, 06 Aug 2014 17:20:44 +0200
Message-id: <0dd501cfb189$fe188750$fa4995f0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d1352f268415182f9bfc06b142fb50083e5f6479:

  Merge two fixes from branch 'patchwork' into to_next (2014-08-01 15:32:27
-0300)

are available in the git repository at:


  git://linuxtv.org/kdebski/media_tree_2.git for-v3.17-2

for you to fetch changes up to b22f1b734d206dde3790472e9e3ecb0f240f0812:

  coda: checkpatch cleanup (2014-08-06 14:29:24 +0200)

----------------------------------------------------------------
Michael Olbrich (2):
      coda: use CODA_MAX_FRAME_SIZE everywhere
      coda: delay coda_fill_bitstream()

Philipp Zabel (32):
      coda: fix CODA7541 hardware reset
      coda: initialize hardware on pm runtime resume only if firmware
available
      coda: remove CAPTURE and OUTPUT caps
      coda: remove VB2_USERPTR from queue io_modes
      coda: lock capture frame size to output frame size when streaming
      coda: split userspace interface into encoder and decoder device
      coda: split format enumeration for encoder end decoder device
      coda: default to h.264 decoder on invalid formats
      coda: mark constant structures as such
      coda: move coda driver into its own directory
      coda: move defines, enums, and structs into shared header
      coda: add context ops
      coda: move BIT processor command execution out of pic_run_work
      coda: add coda_bit_stream_set_flag helper
      coda: move per-instance buffer allocation and cleanup
      coda: move H.264 helper function into separate file
      coda: move BIT specific functions into separate file
      coda: include header for memcpy
      coda: remove unnecessary peek at next destination buffer from
coda_finish_decode
      coda: request BIT processor interrupt by name
      coda: dequeue buffers if start_streaming fails
      coda: dequeue buffers on streamoff
      coda: skip calling coda_find_codec in encoder try_fmt_vid_out
      coda: allow running coda without iram on mx6dl
      coda: increase max vertical frame size to 1088
      coda: add an intermediate debug level
      coda: improve allocation error messages
      coda: fix timestamp list handling
      coda: fix coda_s_fmt_vid_out
      coda: set capture frame size with output S_FMT
      coda: disable old cropping ioctls
      coda: checkpatch cleanup

 drivers/media/platform/Makefile                    |    2 +-
 drivers/media/platform/coda.c                      | 3933
--------------------
 drivers/media/platform/coda/Makefile               |    3 +
 drivers/media/platform/coda/coda-bit.c             | 1860 +++++++++
 drivers/media/platform/coda/coda-common.c          | 2065 ++++++++++
 drivers/media/platform/coda/coda-h264.c            |   37 +
 drivers/media/platform/coda/coda.h                 |  287 ++
 .../media/platform/{coda.h => coda/coda_regs.h}    |    0
 8 files changed, 4253 insertions(+), 3934 deletions(-)
 delete mode 100644 drivers/media/platform/coda.c
 create mode 100644 drivers/media/platform/coda/Makefile
 create mode 100644 drivers/media/platform/coda/coda-bit.c
 create mode 100644 drivers/media/platform/coda/coda-common.c
 create mode 100644 drivers/media/platform/coda/coda-h264.c
 create mode 100644 drivers/media/platform/coda/coda.h
 rename drivers/media/platform/{coda.h => coda/coda_regs.h} (100%)

