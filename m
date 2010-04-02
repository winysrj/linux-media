Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:54224 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754615Ab0DBQyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Apr 2010 12:54:06 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 1/2] tm6000: request labeling board version check
Date: Fri,  2 Apr 2010 18:52:49 +0200
Message-Id: <1270227170-4879-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

request labeling board version check


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    4 ++--
 drivers/staging/tm6000/tm6000-core.c  |   18 ++++++++++++++++--
 drivers/staging/tm6000/tm6000.h       |    1 +
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 2f0274d..f795a3e 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -480,9 +480,9 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 		}
 
 		if (!i) {
-			rc = tm6000_get_reg16(dev, 0x40, 0, 0);
+			rc = tm6000_get_reg32(dev, REQ_40_GET_VERSION, 0, 0);
 			if (rc >= 0)
-				printk(KERN_DEBUG "board=%d\n", rc);
+				printk(KERN_DEBUG "board=0x%08x\n", rc);
 		}
 	}
 
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index d9cade0..0b4dc64 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -139,6 +139,20 @@ int tm6000_get_reg16 (struct tm6000_core *dev, u8 req, u16 value, u16 index)
 	return buf[1]|buf[0]<<8;
 }
 
+int tm6000_get_reg32 (struct tm6000_core *dev, u8 req, u16 value, u16 index)
+{
+	int rc;
+	u8 buf[4];
+
+	rc=tm6000_read_write_usb (dev, USB_DIR_IN | USB_TYPE_VENDOR, req,
+				       value, index, buf, 4);
+
+	if (rc<0)
+		return rc;
+
+	return buf[3] | buf[2] << 8 | buf[1] << 16 | buf[0] << 24;
+}
+
 void tm6000_set_fourcc_format(struct tm6000_core *dev)
 {
 	if (dev->dev_type == TM6010) {
@@ -455,9 +469,9 @@ int tm6000_init (struct tm6000_core *dev)
 	msleep(5); /* Just to be conservative */
 
 	/* Check board version - maybe 10Moons specific */
-	board=tm6000_get_reg16 (dev, 0x40, 0, 0);
+	board=tm6000_get_reg32 (dev, REQ_40_GET_VERSION, 0, 0);
 	if (board >=0) {
-		printk (KERN_INFO "Board version = 0x%04x\n",board);
+		printk (KERN_INFO "Board version = 0x%08x\n",board);
 	} else {
 		printk (KERN_ERR "Error %i while retrieving board version\n",board);
 	}
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 172f7d7..d9d076b 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -224,6 +224,7 @@ int tm6000_read_write_usb (struct tm6000_core *dev, u8 reqtype, u8 req,
 			   u16 value, u16 index, u8 *buf, u16 len);
 int tm6000_get_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_get_reg16(struct tm6000_core *dev, u8 req, u16 value, u16 index);
+int tm6000_get_reg32(struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_set_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_init (struct tm6000_core *dev);
 
-- 
1.6.6.1

