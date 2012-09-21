Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40919 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758295Ab2IUXIk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 19:08:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] cypress_firmware: use Kernel dev_foo() logging
Date: Sat, 22 Sep 2012 02:08:10 +0300
Message-Id: <1348268891-15511-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/cypress_firmware.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/cypress_firmware.c b/drivers/media/usb/dvb-usb-v2/cypress_firmware.c
index 9f7c970..bb21eee 100644
--- a/drivers/media/usb/dvb-usb-v2/cypress_firmware.c
+++ b/drivers/media/usb/dvb-usb-v2/cypress_firmware.c
@@ -30,6 +30,9 @@ static const struct usb_cypress_controller cypress[] = {
 static int usb_cypress_writemem(struct usb_device *udev, u16 addr, u8 *data,
 		u8 len)
 {
+	dvb_usb_dbg_usb_control_msg(udev,
+			0xa0, USB_TYPE_VENDOR, addr, 0x00, data, len);
+
 	return usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			0xa0, USB_TYPE_VENDOR, addr, 0x00, data, len, 5000);
 }
@@ -45,24 +48,24 @@ int usbv2_cypress_load_firmware(struct usb_device *udev,
 	reset = 1;
 	ret = usb_cypress_writemem(udev, cypress[type].cs_reg, &reset, 1);
 	if (ret != 1)
-		pr_err("%s: could not stop the USB controller CPU",
+		dev_err(&udev->dev,
+				"%s: could not stop the USB controller CPU\n",
 				KBUILD_MODNAME);
 
 	while ((ret = dvb_usbv2_get_hexline(fw, &hx, &pos)) > 0) {
-		pr_debug("%s: writing to address %04x (buffer: %02x %02x)\n",
-				__func__, hx.addr, hx.len, hx.chk);
-
 		ret = usb_cypress_writemem(udev, hx.addr, hx.data, hx.len);
 		if (ret != hx.len) {
-			pr_err("%s: error while transferring firmware " \
-					"(transferred size=%d, block size=%d)",
+			dev_err(&udev->dev, "%s: error while transferring " \
+					"firmware (transferred size=%d, " \
+					"block size=%d)\n",
 					KBUILD_MODNAME, ret, hx.len);
 			ret = -EINVAL;
 			break;
 		}
 	}
 	if (ret < 0) {
-		pr_err("%s: firmware download failed at %d with %d",
+		dev_err(&udev->dev,
+				"%s: firmware download failed at %d with %d\n",
 				KBUILD_MODNAME, pos, ret);
 		return ret;
 	}
@@ -72,8 +75,8 @@ int usbv2_cypress_load_firmware(struct usb_device *udev,
 		reset = 0;
 		if (ret || usb_cypress_writemem(
 				udev, cypress[type].cs_reg, &reset, 1) != 1) {
-			pr_err("%s: could not restart the USB controller CPU",
-					KBUILD_MODNAME);
+			dev_err(&udev->dev, "%s: could not restart the USB " \
+					"controller CPU\n", KBUILD_MODNAME);
 			ret = -EINVAL;
 		}
 	} else
-- 
1.7.11.4

