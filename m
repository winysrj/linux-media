Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.data-modul.de ([212.184.205.171]:43149 "EHLO
	mail2.data-modul.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752539AbbHCL5r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2015 07:57:47 -0400
From: Zahari Doychev <zahari.doychev@linux.com>
To: p.zabel@pengutronix.de
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com, hans.verkuil@cisco.com, kamil@wypas.org,
	Zahari Doychev <zahari.doychev@linux.com>
Subject: [PATCH] [media] coda: drop zero payload bitstream buffers
Date: Mon,  3 Aug 2015 13:57:19 +0200
Message-Id: <7e7708ca44f36fe97ad032aa1eea0d64ff84665d.1438602940.git.zahari.doychev@linux.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The buffers with zero payload are now dumped in coda_fill_bitstream and not
passed to coda_bitstream_queue. This avoids unnecessary fifo addition and
buffer sequence counter increment.

Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
---
 drivers/media/platform/coda/coda-bit.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 3d434a4..fd7819d 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -256,6 +256,13 @@ void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 			continue;
 		}
 
+		/* Dump empty buffers */
+		if (!vb2_get_plane_payload(src_buf, 0)) {
+			src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+			continue;
+		}
+
 		/* Buffer start position */
 		start = ctx->bitstream_fifo.kfifo.in &
 			ctx->bitstream_fifo.kfifo.mask;
-- 
2.4.6

