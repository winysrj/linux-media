Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36777 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbeF1PoP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 11:44:15 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH] media: coda: fix encoder source stride
Date: Thu, 28 Jun 2018 17:44:12 +0200
Message-Id: <20180628154412.24381-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The encoder picture run command takes a picture source stride parameter.
This must be set to the output queue's bytesperline, not width.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 68ed2a564ad1..a585b80ca3ac 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1362,7 +1362,8 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 
 	if (dev->devtype->product == CODA_960) {
 		coda_write(dev, 4/*FIXME: 0*/, CODA9_CMD_ENC_PIC_SRC_INDEX);
-		coda_write(dev, q_data_src->width, CODA9_CMD_ENC_PIC_SRC_STRIDE);
+		coda_write(dev, q_data_src->bytesperline,
+			   CODA9_CMD_ENC_PIC_SRC_STRIDE);
 		coda_write(dev, 0, CODA9_CMD_ENC_PIC_SUB_FRAME_SYNC);
 
 		reg = CODA9_CMD_ENC_PIC_SRC_ADDR_Y;
-- 
2.17.1
