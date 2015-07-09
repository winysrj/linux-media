Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37839 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbbGIKKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2015 06:10:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 01/10] [media] coda: clamp frame sequence counters to 16 bit
Date: Thu,  9 Jul 2015 12:10:12 +0200
Message-Id: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lucas Stach <l.stach@pengutronix.de>

This is already done for one side of the comparison with the expectation
that the HW counter rolls over at the 16 bit boundary. This is true when
decoding a h.264 stream, but doesn't hold for at least MJPEG. As we don't
know the exact wrap-around point for this format just clamp the HW counter
to the same 16 bits. This should be enough to detect most of the errors
and saves us from doing different comparisons based on the decoded format.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 109797b..9fbff24 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1902,7 +1902,14 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 			meta = list_first_entry(&ctx->buffer_meta_list,
 					      struct coda_buffer_meta, list);
 			list_del(&meta->list);
-			if (val != (meta->sequence & 0xffff)) {
+			/*
+			 * Clamp counters to 16 bits for comparison, as the HW
+			 * counter rolls over at this point for h.264. This
+			 * may be different for other formats, but using 16 bits
+			 * should be enough to detect most errors and saves us
+			 * from doing different things based on the format.
+			 */
+			if ((val & 0xffff) != (meta->sequence & 0xffff)) {
 				v4l2_err(&dev->v4l2_dev,
 					 "sequence number mismatch (%d(%d) != %d)\n",
 					 val, ctx->sequence_offset,
-- 
2.1.4

