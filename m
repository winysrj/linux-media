Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:38963 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725751AbeJSGgF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 02:36:05 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: imon_raw: use fls rather than loop per bit
Date: Thu, 18 Oct 2018 23:32:57 +0100
Message-Id: <20181018223257.15528-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, the code would loop for each of the 40 bits. Now it will
branch for each edge in the IR, which will be much less.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/imon_raw.c | 47 ++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/media/rc/imon_raw.c b/drivers/media/rc/imon_raw.c
index 7796098d9c30..25e56c5b13c0 100644
--- a/drivers/media/rc/imon_raw.c
+++ b/drivers/media/rc/imon_raw.c
@@ -14,51 +14,50 @@ struct imon {
 	struct device *dev;
 	struct urb *ir_urb;
 	struct rc_dev *rcdev;
-	u8 ir_buf[8];
+	u8 ir_buf[8] __aligned(__alignof__(u64));
 	char phys[64];
 };
 
 /*
- * ffs/find_next_bit() searches in the wrong direction, so open-code our own.
+ * The first 5 bytes of data represent IR pulse or space. Each bit, starting
+ * from highest bit in the first byte, represents 250µs of data. It is 1
+ * for space and 0 for pulse.
+ *
+ * The station sends 10 packets, and the 7th byte will be number 1 to 10, so
+ * when we receive 10 we assume all the data has arrived.
  */
-static inline int is_bit_set(const u8 *buf, int bit)
-{
-	return buf[bit / 8] & (0x80 >> (bit & 7));
-}
-
 static void imon_ir_data(struct imon *imon)
 {
 	struct ir_raw_event rawir = {};
-	int offset = 0, size = 5 * 8;
+	u64 d = be64_to_cpup((__be64 *)imon->ir_buf) >> 24;
+	int offset = 40;
 	int bit;
 
 	dev_dbg(imon->dev, "data: %*ph", 8, imon->ir_buf);
 
-	while (offset < size) {
-		bit = offset;
-		while (!is_bit_set(imon->ir_buf, bit) && bit < size)
-			bit++;
-		dev_dbg(imon->dev, "pulse: %d bits", bit - offset);
-		if (bit > offset) {
+	do {
+		bit = fls64(d & (BIT_ULL(offset) - 1));
+		if (bit < offset) {
+			dev_dbg(imon->dev, "pulse: %d bits", offset - bit);
 			rawir.pulse = true;
-			rawir.duration = (bit - offset) * BIT_DURATION;
+			rawir.duration = (offset - bit) * BIT_DURATION;
 			ir_raw_event_store_with_filter(imon->rcdev, &rawir);
-		}
 
-		if (bit >= size)
-			break;
+			if (bit == 0)
+				break;
 
-		offset = bit;
-		while (is_bit_set(imon->ir_buf, bit) && bit < size)
-			bit++;
-		dev_dbg(imon->dev, "space: %d bits", bit - offset);
+			offset = bit;
+		}
+
+		bit = fls64(~d & (BIT_ULL(offset) - 1));
+		dev_dbg(imon->dev, "space: %d bits", offset - bit);
 
 		rawir.pulse = false;
-		rawir.duration = (bit - offset) * BIT_DURATION;
+		rawir.duration = (offset - bit) * BIT_DURATION;
 		ir_raw_event_store_with_filter(imon->rcdev, &rawir);
 
 		offset = bit;
-	}
+	} while (offset > 0);
 
 	if (imon->ir_buf[7] == 0x0a) {
 		ir_raw_event_set_idle(imon->rcdev, true);
-- 
2.17.2
