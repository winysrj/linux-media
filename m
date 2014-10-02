Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34081 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaJBRIu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Oct 2014 13:08:50 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 00/10] CODA7 JPEG support
Date: Thu,  2 Oct 2014 19:08:25 +0200
Message-Id: <1412269715-28388-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

These patches add JPEG encoding and decoding support for CODA7541 (i.MX5).
I have merged the H.264/MPEG4 encoder video devices back together since v1,
so that there now are four video devices, with the JPEG encoder and decoder
separate from the default bitstream encoder and decoder. The video devices
only register relevant controls now.

regards
Philipp

Philipp Zabel (10):
  [media] coda: add support for planar YCbCr 4:2:2 (YUV422P) format
  [media] coda: identify platform device earlier
  [media] coda: add coda_video_device descriptors
  [media] coda: split out encoder control setup to specify controls per
    video device
  [media] coda: add JPEG register definitions for CODA7541
  [media] coda: add CODA7541 JPEG support
  [media] coda: store bitstream buffer position with buffer metadata
  [media] coda: pad input stream for JPEG decoder
  [media] coda: try to only queue a single JPEG into the bitstream
  [media] coda: allow userspace to set compressed buffer size in a
    certain range

 drivers/media/platform/coda/Makefile      |   2 +-
 drivers/media/platform/coda/coda-bit.c    | 204 +++++++----
 drivers/media/platform/coda/coda-common.c | 546 +++++++++++++++++++-----------
 drivers/media/platform/coda/coda-jpeg.c   | 225 ++++++++++++
 drivers/media/platform/coda/coda.h        |  21 +-
 drivers/media/platform/coda/coda_regs.h   |   7 +
 6 files changed, 743 insertions(+), 262 deletions(-)
 create mode 100644 drivers/media/platform/coda/coda-jpeg.c

-- 
2.1.0

