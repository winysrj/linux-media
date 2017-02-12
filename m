Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-out-2.rwth-aachen.de ([134.130.5.187]:34869 "EHLO
        mx-out-2.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdBLPCU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 10:02:20 -0500
From: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Subject: [PATCH v2] [media] dvb-usb-firmware: don't do DMA on stack
Date: Sun, 12 Feb 2017 16:02:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <e05acbe48ec14698a7e517d317b16168@rwthex-w2-b.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The buffer allocation for the firmware data was changed in
commit 43fab9793c1f ("dvb-usb: don't use stack for firmware load"),
but the same applies for the reset value.

Signed-off-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
---
This patch replaces the earlier submission conflicting with commit
43fab9793c1f, which was a subset of the submitted patch.

 drivers/media/usb/dvb-usb/dvb-usb-firmware.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
index 3271b3fee1f4..1f008f354282 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
@@ -36,16 +36,19 @@ static int usb_cypress_writemem(struct usb_device *udev,u16 addr,u8 *data, u8 le
 int usb_cypress_load_firmware(struct usb_device *udev, const struct firmware *fw, int type)
 {
 	struct hexline *hx;
-	u8 reset;
+	u8 *buf;
+	u8 *reset;
 	int ret,pos=0;
+	u16 cpu_cs_register = cypress[type].cpu_cs_register;
 
-	hx = kmalloc(sizeof(*hx), GFP_KERNEL);
-	if (!hx)
+	buf = kmalloc(sizeof(*hx), GFP_KERNEL);
+	if (!buf)
 		return -ENOMEM;
+	hx = (struct hexline *)buf;
 
 	/* stop the CPU */
-	reset = 1;
-	if ((ret = usb_cypress_writemem(udev,cypress[type].cpu_cs_register,&reset,1)) != 1)
+	buf[0] = 1;
+	if (usb_cypress_writemem(udev, cpu_cs_register, buf, 1) != 1)
 		err("could not stop the USB controller CPU.");
 
 	while ((ret = dvb_usb_get_hexline(fw, hx, &pos)) > 0) {
@@ -61,21 +64,21 @@ int usb_cypress_load_firmware(struct usb_device *udev, const struct firmware *fw
 	}
 	if (ret < 0) {
 		err("firmware download failed at %d with %d",pos,ret);
-		kfree(hx);
+		kfree(buf);
 		return ret;
 	}
 
 	if (ret == 0) {
 		/* restart the CPU */
-		reset = 0;
-		if (ret || usb_cypress_writemem(udev,cypress[type].cpu_cs_register,&reset,1) != 1) {
+		buf[0] = 0;
+		if (usb_cypress_writemem(udev, cpu_cs_register, buf, 1) != 1) {
 			err("could not restart the USB controller CPU.");
 			ret = -EINVAL;
 		}
 	} else
 		ret = -EIO;
 
-	kfree(hx);
+	kfree(buf);
 
 	return ret;
 }
-- 
2.11.0
