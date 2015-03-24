Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60117 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbbCXRbC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 13:31:02 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 03/11] [media] coda: bitstream payload is unsigned
Date: Tue, 24 Mar 2015 18:30:49 +0100
Message-Id: <1427218257-1507-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427218257-1507-1-git-send-email-p.zabel@pengutronix.de>
References: <1427218257-1507-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kfifo_len is unsigned int, return it as such.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 0c35cd5..499049f 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -284,7 +284,7 @@ const char *coda_product_name(int product);
 
 int coda_check_firmware(struct coda_dev *dev);
 
-static inline int coda_get_bitstream_payload(struct coda_ctx *ctx)
+static inline unsigned int coda_get_bitstream_payload(struct coda_ctx *ctx)
 {
 	return kfifo_len(&ctx->bitstream_fifo);
 }
-- 
2.1.4

