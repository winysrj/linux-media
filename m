Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45517 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaI3J5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 05:57:36 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 08/10] [media] coda: pad input stream for JPEG decoder
Date: Tue, 30 Sep 2014 11:57:09 +0200
Message-Id: <1412071031-32016-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
References: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before starting a PIC_RUN, pad the bitstream with 0xff until 256 bytes
past the next multiple of 256 bytes, if the buffer to be decoded is the
last buffer in the bitstream.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index d1ecda5..27e0764 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1625,6 +1625,26 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		coda_write(dev, ctx->iram_info.axi_sram_use,
 				CODA7_REG_BIT_AXI_SRAM_USE);
 
+	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG) {
+		struct coda_buffer_meta *meta;
+
+		/* If this is the last buffer in the bitstream, add padding */
+		meta = list_first_entry(&ctx->buffer_meta_list,
+				      struct coda_buffer_meta, list);
+		if (meta->end == (ctx->bitstream_fifo.kfifo.in &
+				  ctx->bitstream_fifo.kfifo.mask)) {
+			static unsigned char buf[512];
+			unsigned int pad;
+
+			/* Pad to multiple of 256 and then add 256 more */
+			pad = ((0 - meta->end) & 0xff) + 256;
+
+			memset(buf, 0xff, sizeof(buf));
+
+			kfifo_in(&ctx->bitstream_fifo, buf, pad);
+		}
+	}
+
 	coda_kfifo_sync_to_device_full(ctx);
 
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
-- 
2.1.0

