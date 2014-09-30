Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45501 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaI3J53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 05:57:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 09/10] [media] coda: try to only queue a single JPEG into the bitstream
Date: Tue, 30 Sep 2014 11:57:10 +0200
Message-Id: <1412071031-32016-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
References: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With bitstream padding, it is possible to decode a single JPEG in the bitstream
immediately. This allows us to only ever queue a single JPEG into the bitstream
buffer, except to increase payload over 512 bytes or to back out of hold state.
This is a measure to decrease JPEG decoder latency.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 27e0764..2a6810e 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -221,6 +221,14 @@ void coda_fill_bitstream(struct coda_ctx *ctx)
 	u32 start;
 
 	while (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) > 0) {
+		/*
+		 * Only queue a single JPEG into the bitstream buffer, except
+		 * to increase payload over 512 bytes or if in hold state.
+		 */
+		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG &&
+		    (coda_get_bitstream_payload(ctx) >= 512) && !ctx->hold)
+			break;
+
 		src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
 		/* Buffer start position */
-- 
2.1.0

