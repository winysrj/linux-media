Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:59310 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751807AbdIQUYo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 16:24:44 -0400
Subject: [PATCH 8/8] [media] cx231xx: Use common error handling code in
 cx231xx_load_firmware()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Johan Hovold <johan@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Message-ID: <57f0d209-1b87-690c-589a-bff8e0ffe24f@users.sourceforge.net>
Date: Sun, 17 Sep 2017 22:24:16 +0200
MIME-Version: 1.0
In-Reply-To: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 21:07:39 +0200

Add jump targets so that a bit of exception handling can be better reused
at the end of this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/cx231xx/cx231xx-417.c | 61 ++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index d43345593172..88aac129b678 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -954,16 +954,13 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 
 	p_current_fw = vmalloc(1884180 * 4);
 	p_fw = p_current_fw;
-	if (!p_current_fw) {
-		dprintk(2, "FAIL!!!\n");
-		return -ENOMEM;
-	}
+	if (!p_current_fw)
+		goto e_nomem;
 
 	p_buffer = vmalloc(4096);
 	if (!p_buffer) {
-		dprintk(2, "FAIL!!!\n");
 		vfree(p_current_fw);
-		return -ENOMEM;
+		goto e_nomem;
 	}
 
 	dprintk(2, "%s()\n", __func__);
@@ -986,9 +983,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	if (retval != 0) {
 		dev_err(dev->dev,
 			"%s: Error with mc417_register_write\n", __func__);
-		vfree(p_current_fw);
-		vfree(p_buffer);
-		return retval;
+		goto free_fw;
 	}
 
 	retval = request_firmware(&firmware, CX231xx_FIRM_IMAGE_NAME,
@@ -1000,28 +995,20 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 			CX231xx_FIRM_IMAGE_NAME);
 		dev_err(dev->dev,
 			"Please fix your hotplug setup, the board will not work without firmware loaded!\n");
-		vfree(p_current_fw);
-		vfree(p_buffer);
-		return retval;
+		goto free_fw;
 	}
 
 	if (firmware->size != CX231xx_FIRM_IMAGE_SIZE) {
 		dev_err(dev->dev,
 			"ERROR: Firmware size mismatch (have %zd, expected %d)\n",
 			firmware->size, CX231xx_FIRM_IMAGE_SIZE);
-		release_firmware(firmware);
-		vfree(p_current_fw);
-		vfree(p_buffer);
-		return -EINVAL;
+		goto e_inval;
 	}
 
 	if (0 != memcmp(firmware->data, magic, 8)) {
 		dev_err(dev->dev,
 			"ERROR: Firmware magic mismatch, wrong file?\n");
-		release_firmware(firmware);
-		vfree(p_current_fw);
-		vfree(p_buffer);
-		return -EINVAL;
+		goto e_inval;
 	}
 
 	initGPIO(dev);
@@ -1065,26 +1052,36 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 
 	retval |= mc417_register_write(dev, IVTV_REG_HW_BLOCKS,
 		IVTV_CMD_HW_BLOCKS_RST);
-	if (retval < 0) {
-		dev_err(dev->dev,
-			"%s: Error with mc417_register_write\n",
-			__func__);
-		return retval;
-	}
+	if (retval < 0)
+		goto report_write_failure;
+
 	/* F/W power up disturbs the GPIOs, restore state */
 	retval |= mc417_register_write(dev, 0x9020, gpio_output);
 	retval |= mc417_register_write(dev, 0x900C, value);
 
 	retval |= mc417_register_read(dev, IVTV_REG_VPU, &value);
 	retval |= mc417_register_write(dev, IVTV_REG_VPU, value & 0xFFFFFFE8);
+	if (retval < 0)
+		goto report_write_failure;
 
-	if (retval < 0) {
-		dev_err(dev->dev,
-			"%s: Error with mc417_register_write\n",
-			__func__);
-		return retval;
-	}
 	return 0;
+
+e_nomem:
+	dprintk(2, "FAIL!!!\n");
+	return -ENOMEM;
+
+e_inval:
+	retval = -EINVAL;
+	release_firmware(firmware);
+
+free_fw:
+	vfree(p_current_fw);
+	vfree(p_buffer);
+	return retval;
+
+report_write_failure:
+	dev_err(dev->dev, "%s: Error with mc417_register_write\n", __func__);
+	return retval;
 }
 
 static void cx231xx_417_check_encoder(struct cx231xx *dev)
-- 
2.14.1
