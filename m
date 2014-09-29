Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40061 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaI2MyI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 08:54:08 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 0/6] CODA fixes and NV12 support
Date: Mon, 29 Sep 2014 14:53:41 +0200
Message-Id: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this series fixes restarting of streams, cleans up a superfluous error message,
unifies the YUV buffer base pointer setup, disables the encoder rotator unit
when copying input buffers into the internal frame memory if not needed,
simplifies the frame memory control register handling (no need to clear magic
bits if we wrote 0 in the first place), and adds support for the NV12 pixel
format.

regards
Philipp

Philipp Zabel (6):
  [media] coda: clear aborting flag in stop_streaming
  [media] coda: remove superfluous error message on devm_kzalloc failure
  [media] coda: add coda_write_base helper
  [media] coda: disable rotator if not needed
  [media] coda: simplify frame memory control register handling
  [media] coda: add support for partial interleaved YCbCr 4:2:0 (NV12)
    format

 drivers/media/platform/coda/coda-bit.c    | 108 ++++++++++++------------------
 drivers/media/platform/coda/coda-common.c |  43 ++++++++++--
 drivers/media/platform/coda/coda.h        |   2 +
 3 files changed, 82 insertions(+), 71 deletions(-)

-- 
2.1.0

