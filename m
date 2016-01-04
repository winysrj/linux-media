Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46385 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbcADTa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 14:30:27 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] coda: fix first encoded frame payload
Date: Mon,  4 Jan 2016 20:30:09 +0100
Message-Id: <1451935809-29554-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the recent vb2_buffer restructuring, the calculation of the
buffer payload reported to userspace was accidentally broken for the
first encoded frame, counting only the length of the headers.
This patch re-adds the length of the actual frame data.

Fixes: 2d7007153f0c ("[media] media: videobuf2: Restructure vb2_buffer")
Reported-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Jan Luebbe <jlu@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 654e964..d76511c 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1342,7 +1342,7 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 
 	/* Calculate bytesused field */
 	if (dst_buf->sequence == 0) {
-		vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, wr_ptr - start_ptr +
 					ctx->vpu_header_size[0] +
 					ctx->vpu_header_size[1] +
 					ctx->vpu_header_size[2]);
-- 
2.6.2

