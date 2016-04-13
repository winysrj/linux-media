Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbcDMUFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 16:05:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Insu Yun <wuninsu@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] [media] cx231xx: return proper error codes at cx231xx-417.c
Date: Wed, 13 Apr 2016 17:04:33 -0300
Message-Id: <ccc5429f7bf9c78d64f1bb03c578f1641ca72fe4.1460577868.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of returning -1, return valid error codes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 3636d8d0abd3..00da024b47a6 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -360,7 +360,7 @@ static int wait_for_mci_complete(struct cx231xx *dev)
 
 		if (count++ > 100) {
 			dprintk(3, "ERROR: Timeout - gpio=%x\n", gpio);
-			return -1;
+			return -EIO;
 		}
 	}
 	return 0;
@@ -856,7 +856,7 @@ static int cx231xx_find_mailbox(struct cx231xx *dev)
 		}
 	}
 	dprintk(3, "Mailbox signature values not found!\n");
-	return -1;
+	return -EIO;
 }
 
 static void mci_write_memory_to_gpio(struct cx231xx *dev, u32 address, u32 value,
@@ -960,14 +960,14 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	p_fw = p_current_fw;
 	if (p_current_fw == NULL) {
 		dprintk(2, "FAIL!!!\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	p_buffer = vmalloc(4096);
 	if (p_buffer == NULL) {
 		dprintk(2, "FAIL!!!\n");
 		vfree(p_current_fw);
-		return -1;
+		return -ENOMEM;
 	}
 
 	dprintk(2, "%s()\n", __func__);
@@ -992,7 +992,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 			"%s: Error with mc417_register_write\n", __func__);
 		vfree(p_current_fw);
 		vfree(p_buffer);
-		return -1;
+		return retval;
 	}
 
 	retval = request_firmware(&firmware, CX231xx_FIRM_IMAGE_NAME,
@@ -1006,7 +1006,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 			"Please fix your hotplug setup, the board will not work without firmware loaded!\n");
 		vfree(p_current_fw);
 		vfree(p_buffer);
-		return -1;
+		return retval;
 	}
 
 	if (firmware->size != CX231xx_FIRM_IMAGE_SIZE) {
@@ -1016,7 +1016,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 		release_firmware(firmware);
 		vfree(p_current_fw);
 		vfree(p_buffer);
-		return -1;
+		return -EINVAL;
 	}
 
 	if (0 != memcmp(firmware->data, magic, 8)) {
@@ -1025,7 +1025,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 		release_firmware(firmware);
 		vfree(p_current_fw);
 		vfree(p_buffer);
-		return -1;
+		return -EINVAL;
 	}
 
 	initGPIO(dev);
@@ -1140,21 +1140,21 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 		if (retval < 0) {
 			dev_err(dev->dev, "%s: mailbox < 0, error\n",
 				__func__);
-			return -1;
+			return retval;
 		}
 		dev->cx23417_mailbox = retval;
 		retval = cx231xx_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0);
 		if (retval < 0) {
 			dev_err(dev->dev,
 				"ERROR: cx23417 firmware ping failed!\n");
-			return -1;
+			return retval;
 		}
 		retval = cx231xx_api_cmd(dev, CX2341X_ENC_GET_VERSION, 0, 1,
 			&version);
 		if (retval < 0) {
 			dev_err(dev->dev,
 				"ERROR: cx23417 firmware get encoder: version failed!\n");
-			return -1;
+			return retval;
 		}
 		dprintk(1, "cx23417 firmware version is 0x%08x\n", version);
 		msleep(200);
-- 
2.5.5

