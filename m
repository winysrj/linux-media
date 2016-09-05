Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55024 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933017AbcIEKcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:32:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 12/12] [media] tea5767: use module prefix on printed messages
Date: Mon,  5 Sep 2016 07:32:40 -0300
Message-Id: <feb1581b07d0d7160b84854419613503f9c6446c.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

use pr_fmt() & friends for error messages to output like:

[    9.651721] tea5767: Chip ID is not zero. It is not a TEA5767

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/tea5767.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/tea5767.c b/drivers/media/tuners/tea5767.c
index 36e85d81acb2..cd535cd4c071 100644
--- a/drivers/media/tuners/tea5767.c
+++ b/drivers/media/tuners/tea5767.c
@@ -10,6 +10,8 @@
  * from their contributions on DScaler.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -370,17 +372,18 @@ int tea5767_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr)
 {
 	struct tuner_i2c_props i2c = { .adap = i2c_adap, .addr = i2c_addr };
 	unsigned char buffer[7] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+
 	int rc;
 
 	if ((rc = tuner_i2c_xfer_recv(&i2c, buffer, 7))< 5) {
-		printk(KERN_WARNING "It is not a TEA5767. Received %i bytes.\n", rc);
+		pr_warn("It is not a TEA5767. Received %i bytes.\n", rc);
 		return -EINVAL;
 	}
 
 	/* If all bytes are the same then it's a TV tuner and not a tea5767 */
 	if (buffer[0] == buffer[1] && buffer[0] == buffer[2] &&
 	    buffer[0] == buffer[3] && buffer[0] == buffer[4]) {
-		printk(KERN_WARNING "All bytes are equal. It is not a TEA5767\n");
+		pr_warn("All bytes are equal. It is not a TEA5767\n");
 		return -EINVAL;
 	}
 
@@ -390,7 +393,7 @@ int tea5767_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr)
 	 *  Byte 5: bit 7:0 : == 0
 	 */
 	if (((buffer[3] & 0x0f) != 0x00) || (buffer[4] != 0x00)) {
-		printk(KERN_WARNING "Chip ID is not zero. It is not a TEA5767\n");
+		pr_warn("Chip ID is not zero. It is not a TEA5767\n");
 		return -EINVAL;
 	}
 
-- 
2.7.4


