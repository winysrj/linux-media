Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab1HDHOY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:24 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 05/21] [staging] tm6000: Implement I2C flush callback.
Date: Thu,  4 Aug 2011 09:14:03 +0200
Message-Id: <1312442059-23935-6-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/staging/tm6000/tm6000-cards.c |    5 +++++
 drivers/staging/tm6000/tm6000-i2c.c   |    5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 202f454..c3b84c9 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -781,6 +781,11 @@ int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 			rc = tm6000_i2c_reset(dev, 100);
 			break;
 		}
+		break;
+	case XC2028_I2C_FLUSH:
+		tm6000_set_reg(dev, REQ_50_SET_START, 0, 0);
+		tm6000_set_reg(dev, REQ_51_SET_STOP, 0, 0);
+		break;
 	}
 	return rc;
 }
diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 8828c12..21cd9f8 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -219,11 +219,6 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 					printk(" %02x", msgs[i].buf[byte]);
 			rc = tm6000_i2c_send_regs(dev, addr, msgs[i].buf[0],
 				msgs[i].buf + 1, msgs[i].len - 1);
-
-			if (addr == dev->tuner_addr  << 1) {
-				tm6000_set_reg(dev, REQ_50_SET_START, 0, 0);
-				tm6000_set_reg(dev, REQ_51_SET_STOP, 0, 0);
-			}
 		}
 		if (i2c_debug >= 2)
 			printk("\n");
-- 
1.7.6

