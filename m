Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50265 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762661AbbA3OpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2015 09:45:04 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NIZ00GLVVTQ6J80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Jan 2015 14:49:02 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0NIZ00IDCVN06U10@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Jan 2015 14:45:01 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] mem2mem changes
Date: Fri, 30 Jan 2015 15:45:00 +0100
Message-id: <035d01d03c9b$535b8a90$fa129fb0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a5f43c18fceb2b96ec9fddb4348f5282a71cf2b0:

  [media] Documentation/video4linux: remove obsolete text files (2015-01-29
19:16:30 -0200)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-3.20-a

for you to fetch changes up to 403655cc66ee4497cdd7045d71bf1376e88c5909:

  coda: simplify check in coda_buf_queue (2015-01-30 15:14:55 +0100)

----------------------------------------------------------------
Fabian Frederick (2):
      s5p-g2d: remove unnecessary version.h inclusion
      s5p-mfc: remove unnecessary version.h inclusion

Lucas Stach (1):
      coda: adjust sequence offset after unexpected decoded frame

Markus Pargmann (1):
      coda: fix width validity check when starting to decode

Nicolas Dufresne (3):
      s5p-mfc-v6+: Use display_delay_enable CID
      s5p-mfc-dec: Don't use encoder stop command
      media-doc: Fix MFC display delay control doc

Philipp Zabel (18):
      coda: fix encoder rate control parameter masks
      coda: remove context debugfs entry last
      coda: move meta out of padding
      coda: fix job_ready debug reporting for bitstream decoding
      coda: fix try_fmt_vid_out colorspace setting
      coda: properly clear f_cap in coda_s_fmt_vid_out
      coda: initialize SRAM on probe
      coda: clear RET_DEC_PIC_SUCCESS flag in prepare_decode
      coda: remove unused isequence, reset qsequence in stop_streaming
      coda: issue seq_end_work during stop_streaming
      coda: don't ever use subsampling ping-pong buffers as reconstructed
reference buffers
      coda: add coda_estimate_sizeimage and use it in set_defaults
      coda: switch BIT decoder source queue to vmalloc
      coda: make seq_end_work optional
      coda: free context buffers under buffer mutex
      coda: add support for contexts that do not use the BIT processor
      coda: allocate bitstream ringbuffer only for BIT decoder
      coda: simplify check in coda_buf_queue

 Documentation/DocBook/media/v4l/controls.xml    |   11 +-
 drivers/media/platform/Kconfig                  |    1 +
 drivers/media/platform/coda/coda-bit.c          |   25 +++-
 drivers/media/platform/coda/coda-common.c       |  159
+++++++++++++++--------
 drivers/media/platform/coda/coda.h              |    2 +-
 drivers/media/platform/coda/coda_regs.h         |    4 +-
 drivers/media/platform/s5p-g2d/g2d.c            |    1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |    3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |    1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    6 +-
 10 files changed, 136 insertions(+), 77 deletions(-)

