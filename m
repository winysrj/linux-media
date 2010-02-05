Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:44577 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933950Ab0BEW5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 17:57:49 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 4/12] tm6000: adding special usb request to quiting tuner transfer
Date: Fri,  5 Feb 2010 23:57:04 +0100
Message-Id: <1265410631-11955-4-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265410631-11955-3-git-send-email-stefan.ringel@arcor.de>
References: <1265410631-11955-1-git-send-email-stefan.ringel@arcor.de>
 <1265410631-11955-2-git-send-email-stefan.ringel@arcor.de>
 <1265410631-11955-3-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-i2c.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 4da10f5..3e43ad7 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -86,6 +86,11 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 				msgs[i].len == 1 ? 0 : msgs[i].buf[1],
 				msgs[i + 1].buf, msgs[i + 1].len);
 			i++;
+			
+			if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
+				tm6000_set_reg(dev, 0x32, 0,0);
+				tm6000_set_reg(dev, 0x33, 0,0);
+			}
 			if (i2c_debug >= 2)
 				for (byte = 0; byte < msgs[i].len; byte++)
 					printk(" %02x", msgs[i].buf[byte]);
@@ -99,6 +104,12 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 				REQ_16_SET_GET_I2C_WR1_RDN,
 				addr | msgs[i].buf[0] << 8, 0,
 				msgs[i].buf + 1, msgs[i].len - 1);
+				
+			
+			if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
+				tm6000_set_reg(dev, 0x32, 0,0);
+				tm6000_set_reg(dev, 0x33, 0,0);
+			}
 		}
 		if (i2c_debug >= 2)
 			printk("\n");
@@ -198,7 +209,7 @@ static struct i2c_algorithm tm6000_algo = {
 
 static struct i2c_adapter tm6000_adap_template = {
 	.owner = THIS_MODULE,
-	.class = I2C_CLASS_TV_ANALOG,
+	.class = I2C_CLASS_TV_ANALOG | I2C_CLASS_TV_DIGITAL,
 	.name = "tm6000",
 	.id = I2C_HW_B_TM6000,
 	.algo = &tm6000_algo,
-- 
1.6.4.2

