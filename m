Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42811 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbbBWPU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:20:27 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 00/12] CODA fixes and buffer allocation in REQBUFS
Date: Mon, 23 Feb 2015 16:20:01 +0100
Message-Id: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is a series of various fixes and a move of the per-context buffer
allocation into the REQBUFS call. Allocating the bitstream buffer only
after S_FMT allows at the same time to guarantee that the bitstream buffer
is always large enough to contain two worst-case compressed frames and
doesn't waste memory if a small format is selected.

Peter Seiderer (3):
  [media] coda: check kasprintf return value in coda_open
  [media] coda: fix double call to debugfs_remove
  [media] coda: free decoder bitstream buffer

Philipp Zabel (9):
  [media] coda: bitstream payload is unsigned
  [media] coda: use strlcpy instead of snprintf
  [media] coda: allocate per-context buffers from REQBUFS
  [media] coda: allocate bitstream buffer from REQBUFS, size depends on
    the format
  [media] coda: move parameter buffer in together with context buffer
    allocation
  [media] coda: remove duplicate error messages for buffer allocations
  [media] coda: fail to start streaming if userspace set invalid formats
  [media] coda: call SEQ_END when the first queue is stopped
  [media] coda: fix fill bitstream errors in nonstreaming case

 drivers/media/platform/coda/coda-bit.c    | 177 +++++++++++++++++++++---------
 drivers/media/platform/coda/coda-common.c | 104 +++++++++---------
 drivers/media/platform/coda/coda.h        |  13 +--
 3 files changed, 180 insertions(+), 114 deletions(-)

-- 
2.1.4

