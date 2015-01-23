Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60792 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbbAWQvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:38 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 00/21] CODA fixes and vmalloc input
Date: Fri, 23 Jan 2015 17:51:14 +0100
Message-Id: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is a series of various fixes that should increase stability
in the face of broken streams and just general use of the CODA driver.
They range from crash fixes to issues uncovered by v4l2-compliance.
The CODA9 subsampling buffers patch fixes encoder image corruption.

Also, the BIT decoder input queue is switched to vmalloc memory, and the
bitstream buffer and sequence end work are made optional for future
CODA9 JPEG support.

regards
Philipp

Lucas Stach (1):
  [media] coda: adjust sequence offset after unexpected decoded frame

Markus Pargmann (1):
  [media] coda: fix width validity check when starting to decode

Philipp Zabel (19):
  [media] coda: fix encoder rate control parameter masks
  [media] coda: bitrate can only be set in kbps steps
  [media] coda: remove context debugfs entry last
  [media] coda: move meta out of padding
  [media] coda: fix job_ready debug reporting for bitstream decoding
  [media] coda: fix try_fmt_vid_out colorspace setting
  [media] coda: properly clear f_cap in coda_s_fmt_vid_out
  [media] coda: initialize SRAM on probe
  [media] coda: clear RET_DEC_PIC_SUCCESS flag in prepare_decode
  [media] coda: remove unused isequence, reset qsequence in
    stop_streaming
  [media] coda: issue seq_end_work during stop_streaming
  [media] coda: don't ever use subsampling ping-pong buffers as
    reconstructed reference buffers
  [media] coda: add coda_estimate_sizeimage and use it in set_defaults
  [media] coda: switch BIT decoder source queue to vmalloc
  [media] coda: make seq_end_work optional
  [media] coda: free context buffers under buffer mutex
  [media] coda: add support for contexts that do not use the BIT
    processor
  [media] coda: allocate bitstream ringbuffer only for BIT decoder
  [media] coda: simplify check in coda_buf_queue

 drivers/media/platform/Kconfig            |   1 +
 drivers/media/platform/coda/coda-bit.c    |  25 +++--
 drivers/media/platform/coda/coda-common.c | 161 ++++++++++++++++++++----------
 drivers/media/platform/coda/coda.h        |   2 +-
 drivers/media/platform/coda/coda_regs.h   |   4 +-
 5 files changed, 130 insertions(+), 63 deletions(-)

-- 
2.1.4

