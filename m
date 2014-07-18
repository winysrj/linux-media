Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35157 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761394AbaGRKXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 06:23:00 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 05/11] [media] coda: use CODA_MAX_FRAME_SIZE everywhere
Date: Fri, 18 Jul 2014 12:22:39 +0200
Message-Id: <1405678965-10473-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
References: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Olbrich <m.olbrich@pengutronix.de>

Without this changing CODA_MAX_FRAME_SIZE to anything other than 0x100000
can break the bitstram handling

Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 917727e..141ec29 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3106,7 +3106,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	 * by up to 512 bytes
 	 */
 	if (ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) {
-		if (coda_get_bitstream_payload(ctx) >= 0x100000 - 512)
+		if (coda_get_bitstream_payload(ctx) >= CODA_MAX_FRAME_SIZE - 512)
 			kfifo_init(&ctx->bitstream_fifo,
 				ctx->bitstream.vaddr, ctx->bitstream.size);
 	}
-- 
2.0.1

