Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39271 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758299Ab2IUXIm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 19:08:42 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] cypress_firmware: refactor firmware downloading
Date: Sat, 22 Sep 2012 02:08:11 +0300
Message-Id: <1348268891-15511-2-git-send-email-crope@iki.fi>
In-Reply-To: <1348268891-15511-1-git-send-email-crope@iki.fi>
References: <1348268891-15511-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor firmware download function. It also should fix one bug
coming from usb_control_msg() message buffers. Taking buffers from
the stack for usb_control_msg() is not allowed as it does not work
on all architectures. Allocate buffers using kmalloc().

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/cypress_firmware.c | 80 +++++++++++++------------
 1 file changed, 43 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/cypress_firmware.c b/drivers/media/usb/dvb-usb-v2/cypress_firmware.c
index bb21eee..211df54 100644
--- a/drivers/media/usb/dvb-usb-v2/cypress_firmware.c
+++ b/drivers/media/usb/dvb-usb-v2/cypress_firmware.c
@@ -40,48 +40,59 @@ static int usb_cypress_writemem(struct usb_device *udev, u16 addr, u8 *data,
 int usbv2_cypress_load_firmware(struct usb_device *udev,
 		const struct firmware *fw, int type)
 {
-	struct hexline hx;
-	u8 reset;
+	struct hexline *hx;
 	int ret, pos = 0;
 
+	hx = kmalloc(sizeof(struct hexline), GFP_KERNEL);
+	if (!hx) {
+		dev_err(&udev->dev, "%s: kmalloc() failed\n", KBUILD_MODNAME);
+		return -ENOMEM;
+	}
+
 	/* stop the CPU */
-	reset = 1;
-	ret = usb_cypress_writemem(udev, cypress[type].cs_reg, &reset, 1);
-	if (ret != 1)
-		dev_err(&udev->dev,
-				"%s: could not stop the USB controller CPU\n",
-				KBUILD_MODNAME);
-
-	while ((ret = dvb_usbv2_get_hexline(fw, &hx, &pos)) > 0) {
-		ret = usb_cypress_writemem(udev, hx.addr, hx.data, hx.len);
-		if (ret != hx.len) {
+	hx->data[0] = 1;
+	ret = usb_cypress_writemem(udev, cypress[type].cs_reg, hx->data, 1);
+	if (ret != 1) {
+		dev_err(&udev->dev, "%s: CPU stop failed=%d\n",
+				KBUILD_MODNAME, ret);
+		ret = -EIO;
+		goto err_kfree;
+	}
+
+	/* write firmware to memory */
+	for (;;) {
+		ret = dvb_usbv2_get_hexline(fw, hx, &pos);
+		if (ret < 0)
+			goto err_kfree;
+		else if (ret == 0)
+			break;
+
+		ret = usb_cypress_writemem(udev, hx->addr, hx->data, hx->len);
+		if (ret < 0) {
+			goto err_kfree;
+		} else if (ret != hx->len) {
 			dev_err(&udev->dev, "%s: error while transferring " \
 					"firmware (transferred size=%d, " \
 					"block size=%d)\n",
-					KBUILD_MODNAME, ret, hx.len);
-			ret = -EINVAL;
-			break;
+					KBUILD_MODNAME, ret, hx->len);
+			ret = -EIO;
+			goto err_kfree;
 		}
 	}
-	if (ret < 0) {
-		dev_err(&udev->dev,
-				"%s: firmware download failed at %d with %d\n",
-				KBUILD_MODNAME, pos, ret);
-		return ret;
-	}
 
-	if (ret == 0) {
-		/* restart the CPU */
-		reset = 0;
-		if (ret || usb_cypress_writemem(
-				udev, cypress[type].cs_reg, &reset, 1) != 1) {
-			dev_err(&udev->dev, "%s: could not restart the USB " \
-					"controller CPU\n", KBUILD_MODNAME);
-			ret = -EINVAL;
-		}
-	} else
+	/* start the CPU */
+	hx->data[0] = 0;
+	ret = usb_cypress_writemem(udev, cypress[type].cs_reg, hx->data, 1);
+	if (ret != 1) {
+		dev_err(&udev->dev, "%s: CPU start failed=%d\n",
+				KBUILD_MODNAME, ret);
 		ret = -EIO;
+		goto err_kfree;
+	}
 
+	ret = 0;
+err_kfree:
+	kfree(hx);
 	return ret;
 }
 EXPORT_SYMBOL(usbv2_cypress_load_firmware);
@@ -96,7 +107,6 @@ int dvb_usbv2_get_hexline(const struct firmware *fw, struct hexline *hx,
 		return 0;
 
 	memset(hx, 0, sizeof(struct hexline));
-
 	hx->len = b[0];
 
 	if ((*pos + hx->len + 4) >= fw->size)
@@ -109,14 +119,10 @@ int dvb_usbv2_get_hexline(const struct firmware *fw, struct hexline *hx,
 		/* b[4] and b[5] are the Extended linear address record data
 		 * field */
 		hx->addr |= (b[4] << 24) | (b[5] << 16);
-		/*
-		hx->len -= 2;
-		data_offs += 2;
-		*/
 	}
+
 	memcpy(hx->data, &b[data_offs], hx->len);
 	hx->chk = b[hx->len + data_offs];
-
 	*pos += hx->len + 5;
 
 	return *pos;
-- 
1.7.11.4

