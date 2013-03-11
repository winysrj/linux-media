Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2413 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3CKLzl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:55:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 19/42] s2250-loader: use usbv2_cypress_load_firmware
Date: Mon, 11 Mar 2013 12:45:57 +0100
Message-Id: <400666fef6bc62079f4ebd7122196c753039aaad.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v2 of this function doesn't do DMA to objects on the stack like
its predecessor does.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/Makefile       |    4 ++--
 drivers/staging/media/go7007/s2250-loader.c |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/go7007/Makefile b/drivers/staging/media/go7007/Makefile
index 5bed78b..f9c8e0f 100644
--- a/drivers/staging/media/go7007/Makefile
+++ b/drivers/staging/media/go7007/Makefile
@@ -11,8 +11,8 @@ s2250-y := s2250-board.o
 #obj-$(CONFIG_VIDEO_SAA7134) += saa7134-go7007.o
 #ccflags-$(CONFIG_VIDEO_SAA7134:m=y) += -Idrivers/media/video/saa7134 -DSAA7134_MPEG_GO7007=3
 
-# S2250 needs cypress ezusb loader from dvb-usb
-ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD:m=y) += -Idrivers/media/usb/dvb-usb
+# S2250 needs cypress ezusb loader from dvb-usb-v2
+ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD:m=y) += -Idrivers/media/usb/dvb-usb-v2
 
 ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/dvb-core
diff --git a/drivers/staging/media/go7007/s2250-loader.c b/drivers/staging/media/go7007/s2250-loader.c
index 72e5175..6453ec0 100644
--- a/drivers/staging/media/go7007/s2250-loader.c
+++ b/drivers/staging/media/go7007/s2250-loader.c
@@ -19,7 +19,8 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
-#include <dvb-usb.h>
+#include <linux/firmware.h>
+#include <cypress_firmware.h>
 
 #define S2250_LOADER_FIRMWARE	"s2250_loader.fw"
 #define S2250_FIRMWARE		"s2250.fw"
@@ -104,7 +105,7 @@ static int s2250loader_probe(struct usb_interface *interface,
 			S2250_LOADER_FIRMWARE);
 		goto failed2;
 	}
-	ret = usb_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
+	ret = usbv2_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
 	release_firmware(fw);
 	if (0 != ret) {
 		dev_err(&interface->dev, "loader download failed\n");
@@ -117,7 +118,7 @@ static int s2250loader_probe(struct usb_interface *interface,
 			S2250_FIRMWARE);
 		goto failed2;
 	}
-	ret = usb_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
+	ret = usbv2_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
 	release_firmware(fw);
 	if (0 != ret) {
 		dev_err(&interface->dev, "firmware_s2250 download failed\n");
-- 
1.7.10.4

