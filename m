Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34437 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbcCGKWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 05:22:33 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] [media] cx231xx: fix memory leak
Date: Mon,  7 Mar 2016 15:52:23 +0530
Message-Id: <1457346143-9527-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When we returned on error we missed freeing p_current_fw and p_buffer.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/media/usb/cx231xx/cx231xx-417.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index c9320d6..3636d8d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -966,6 +966,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	p_buffer = vmalloc(4096);
 	if (p_buffer == NULL) {
 		dprintk(2, "FAIL!!!\n");
+		vfree(p_current_fw);
 		return -1;
 	}
 
@@ -989,6 +990,8 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	if (retval != 0) {
 		dev_err(dev->dev,
 			"%s: Error with mc417_register_write\n", __func__);
+		vfree(p_current_fw);
+		vfree(p_buffer);
 		return -1;
 	}
 
@@ -1001,6 +1004,8 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 			CX231xx_FIRM_IMAGE_NAME);
 		dev_err(dev->dev,
 			"Please fix your hotplug setup, the board will not work without firmware loaded!\n");
+		vfree(p_current_fw);
+		vfree(p_buffer);
 		return -1;
 	}
 
@@ -1009,6 +1014,8 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 			"ERROR: Firmware size mismatch (have %zd, expected %d)\n",
 			firmware->size, CX231xx_FIRM_IMAGE_SIZE);
 		release_firmware(firmware);
+		vfree(p_current_fw);
+		vfree(p_buffer);
 		return -1;
 	}
 
@@ -1016,6 +1023,8 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 		dev_err(dev->dev,
 			"ERROR: Firmware magic mismatch, wrong file?\n");
 		release_firmware(firmware);
+		vfree(p_current_fw);
+		vfree(p_buffer);
 		return -1;
 	}
 
-- 
1.9.1

