Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40804 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2DAPyD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:54:03 -0400
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@samfundet.no>
Subject: [PATCH 04/11] Show timeouts on I2C transfers.
Date: Sun,  1 Apr 2012 17:53:44 +0200
Message-Id: <1333295631-31866-4-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <20120401155330.GA31901@uio.no>
References: <20120401155330.GA31901@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Steinar H. Gunderson" <sesse@samfundet.no>

On I2C reads and writes, show if we had any timeouts in the debug output.

Signed-off-by: Steinar H. Gunderson <sesse@samfundet.no>
---
 drivers/media/dvb/mantis/mantis_i2c.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_i2c.c b/drivers/media/dvb/mantis/mantis_i2c.c
index e779451..ddd1922 100644
--- a/drivers/media/dvb/mantis/mantis_i2c.c
+++ b/drivers/media/dvb/mantis/mantis_i2c.c
@@ -38,6 +38,7 @@
 static int mantis_i2c_read(struct mantis_pci *mantis, const struct i2c_msg *msg)
 {
 	u32 rxd, i, stat, trials;
+	u32 timeouts = 0;
 
 	dprintk(MANTIS_INFO, 0, "        %s:  Address=[0x%02x] <R>[ ",
 		__func__, msg->addr);
@@ -60,6 +61,9 @@ static int mantis_i2c_read(struct mantis_pci *mantis, const struct i2c_msg *msg)
 			if (stat & MANTIS_INT_I2CDONE)
 				break;
 		}
+		if (trials == TRIALS) {
+			++timeouts;
+		}
 
 		dprintk(MANTIS_TMG, 0, "I2CDONE: trials=%d\n", trials);
 
@@ -69,6 +73,9 @@ static int mantis_i2c_read(struct mantis_pci *mantis, const struct i2c_msg *msg)
 			if (stat & MANTIS_INT_I2CRACK)
 				break;
 		}
+		if (trials == TRIALS) {
+			++timeouts;
+		}
 
 		dprintk(MANTIS_TMG, 0, "I2CRACK: trials=%d\n", trials);
 
@@ -76,7 +83,11 @@ static int mantis_i2c_read(struct mantis_pci *mantis, const struct i2c_msg *msg)
 		msg->buf[i] = (u8)((rxd >> 8) & 0xFF);
 		dprintk(MANTIS_INFO, 0, "%02x ", msg->buf[i]);
 	}
-	dprintk(MANTIS_INFO, 0, "]\n");
+	if (timeouts) {
+		dprintk(MANTIS_INFO, 0, "] %d timeouts\n", timeouts);
+	} else {
+		dprintk(MANTIS_INFO, 0, "]\n");
+	}
 
 	return 0;
 }
@@ -85,6 +96,7 @@ static int mantis_i2c_write(struct mantis_pci *mantis, const struct i2c_msg *msg
 {
 	int i;
 	u32 txd = 0, stat, trials;
+	u32 timeouts = 0;
 
 	dprintk(MANTIS_INFO, 0, "        %s: Address=[0x%02x] <W>[ ",
 		__func__, msg->addr);
@@ -108,6 +120,9 @@ static int mantis_i2c_write(struct mantis_pci *mantis, const struct i2c_msg *msg
 			if (stat & MANTIS_INT_I2CDONE)
 				break;
 		}
+		if (trials == TRIALS) {
+			++timeouts;
+		}
 
 		dprintk(MANTIS_TMG, 0, "I2CDONE: trials=%d\n", trials);
 
@@ -117,10 +132,17 @@ static int mantis_i2c_write(struct mantis_pci *mantis, const struct i2c_msg *msg
 			if (stat & MANTIS_INT_I2CRACK)
 				break;
 		}
+		if (trials == TRIALS) {
+			++timeouts;
+		}
 
 		dprintk(MANTIS_TMG, 0, "I2CRACK: trials=%d\n", trials);
 	}
-	dprintk(MANTIS_INFO, 0, "]\n");
+	if (timeouts) {
+		dprintk(MANTIS_INFO, 0, "] %d timeouts\n", timeouts);
+	} else {
+		dprintk(MANTIS_INFO, 0, "]\n");
+	}
 
 	return 0;
 }
-- 
1.7.9.5

