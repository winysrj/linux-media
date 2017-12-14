Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50645 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753376AbdLNRWC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:22:02 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 06/10] media: rc: iguanair: simplify tx loop
Date: Thu, 14 Dec 2017 17:21:57 +0000
Message-Id: <f3eeeabf7a312561732716ba5c9a5002f70d35a9.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 30e24da67226..7daac8bab83b 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -347,26 +347,23 @@ static int iguanair_set_tx_mask(struct rc_dev *dev, uint32_t mask)
 static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 {
 	struct iguanair *ir = dev->priv;
-	uint8_t space;
-	unsigned i, size, periods, bytes;
+	unsigned int i, size, p, periods;
 	int rc;
 
 	mutex_lock(&ir->lock);
 
 	/* convert from us to carrier periods */
-	for (i = space = size = 0; i < count; i++) {
+	for (i = size = 0; i < count; i++) {
 		periods = DIV_ROUND_CLOSEST(txbuf[i] * ir->carrier, 1000000);
-		bytes = DIV_ROUND_UP(periods, 127);
-		if (size + bytes > ir->bufsize) {
-			rc = -EINVAL;
-			goto out;
-		}
 		while (periods) {
-			unsigned p = min(periods, 127u);
-			ir->packet->payload[size++] = p | space;
+			p = min(periods, 127u);
+			if (size >= ir->bufsize) {
+				rc = -EINVAL;
+				goto out;
+			}
+			ir->packet->payload[size++] = p | ((i & 1) ? 0x80 : 0);
 			periods -= p;
 		}
-		space ^= 0x80;
 	}
 
 	ir->packet->header.start = 0;
-- 
2.14.3
