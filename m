Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56778 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab3BQNj1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 08:39:27 -0500
Received: by mail-ee0-f46.google.com with SMTP id e49so2354965eek.33
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2013 05:39:26 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/2] bttv: make remote controls of devices with i2c ir decoder working
Date: Sun, 17 Feb 2013 14:40:05 +0100
Message-Id: <1361108405-3583-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Request module ir-kbd-i2c if an i2c ir decoder is detected.

Tested with device "Hauppauge WinTV Theatre" (model 37284 rev B421).

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-input.c |   22 +++++++++++++---------
 1 Datei geändert, 13 Zeilen hinzugefügt(+), 9 Zeilen entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index 04207a7..01c7121 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -375,6 +375,7 @@ void init_bttv_i2c_ir(struct bttv *btv)
 		I2C_CLIENT_END
 	};
 	struct i2c_board_info info;
+	struct i2c_client *i2c_dev;
 
 	if (0 != btv->i2c_rc)
 		return;
@@ -390,7 +391,12 @@ void init_bttv_i2c_ir(struct bttv *btv)
 		btv->init_data.ir_codes = RC_MAP_PV951;
 		info.addr = 0x4b;
 		break;
-	default:
+	}
+
+	if (btv->init_data.name) {
+		info.platform_data = &btv->init_data;
+		i2c_dev = i2c_new_device(&btv->c.i2c_adap, &info);
+	} else {
 		/*
 		 * The external IR receiver is at i2c address 0x34 (0x35 for
 		 * reads).  Future Hauppauge cards will have an internal
@@ -399,16 +405,14 @@ void init_bttv_i2c_ir(struct bttv *btv)
 		 * internal.
 		 * That's why we probe 0x1a (~0x34) first. CB
 		 */
-
-		i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list, NULL);
-		return;
+		i2c_dev = i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list, NULL);
 	}
+	if (NULL == i2c_dev)
+		return;
 
-	if (btv->init_data.name)
-		info.platform_data = &btv->init_data;
-	i2c_new_device(&btv->c.i2c_adap, &info);
-
-	return;
+#if defined(CONFIG_MODULES) && defined(MODULE)
+	request_module("ir-kbd-i2c");
+#endif
 }
 
 int fini_bttv_i2c(struct bttv *btv)
-- 
1.7.10.4

