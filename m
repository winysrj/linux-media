Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45499 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaI3J52 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 05:57:28 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 00/10] CODA7 JPEG support
Date: Tue, 30 Sep 2014 11:57:01 +0200
Message-Id: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

These patches add JPEG encoding and decoding support for CODA7541 (i.MX5).
The encoder video device is split into one video device per codec, so that
each video device can register only the relevant controls. The H.264/MPEG4
decoder is kept as one video device, but the JPEG decoder video device is
separate because it supports more uncompressed formats (currently YUV422P,
in the future grayscale or YUV 4:4:4 support could be added).

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
 drivers/media/platform/coda/coda-bit.c    | 204 +++++++---
 drivers/media/platform/coda/coda-common.c | 608 +++++++++++++++++++-----------
 drivers/media/platform/coda/coda-jpeg.c   | 225 +++++++++++
 drivers/media/platform/coda/coda.h        |  21 +-
 drivers/media/platform/coda/coda_regs.h   |   7 +
 6 files changed, 785 insertions(+), 282 deletions(-)
 create mode 100644 drivers/media/platform/coda/coda-jpeg.c

-- 
2.1.0

