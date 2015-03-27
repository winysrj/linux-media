Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:34203 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbbC0L5d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 07:57:33 -0400
Received: by lagg8 with SMTP id g8so68396817lag.1
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2015 04:57:31 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/5] saa7164: add support for i2c read
Date: Fri, 27 Mar 2015 13:57:15 +0200
Message-Id: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for pure I2C reads. Needed by si2157 tuner driver.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/saa7164/saa7164-i2c.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-i2c.c b/drivers/media/pci/saa7164/saa7164-i2c.c
index 4f7e3b4..e30e206 100644
--- a/drivers/media/pci/saa7164/saa7164-i2c.c
+++ b/drivers/media/pci/saa7164/saa7164-i2c.c
@@ -39,9 +39,12 @@ static int i2c_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs, int num)
 		dprintk(DBGLVL_I2C, "%s(num = %d) addr = 0x%02x  len = 0x%x\n",
 			__func__, num, msgs[i].addr, msgs[i].len);
 		if (msgs[i].flags & I2C_M_RD) {
-			/* Unsupported - Yet*/
-			printk(KERN_ERR "%s() Unsupported - Yet\n", __func__);
-			continue;
+			/* dummy write before read */
+			retval = saa7164_api_i2c_read(bus, msgs[i].addr,
+				0, NULL, msgs[i].len, msgs[i].buf);
+
+			if (retval < 0)
+				goto err;
 		} else if (i + 1 < num && (msgs[i + 1].flags & I2C_M_RD) &&
 			   msgs[i].addr == msgs[i + 1].addr) {
 			/* write then read from same address */
-- 
1.9.1

