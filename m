Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-out-2.rwth-aachen.de ([134.130.5.187]:36955 "EHLO
        mx-out-2.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbdBEPIC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2017 10:08:02 -0500
From: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Subject: [PATCH 2/2] [media] dvb-usb-firmware: don't do DMA on stack
Date: Sun, 5 Feb 2017 15:58:00 +0100
In-Reply-To: <20170205145800.3561-1-stefan.bruens@rwth-aachen.de>
References: <20170205145800.3561-1-stefan.bruens@rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <cfae2a63a36641bcab2ec298b21b5b06@rwthex-w2-b.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Signed-off-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
---
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c | 30 ++++++++++++++++------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
index dd048a7c461c..189b6725edd0 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
@@ -35,41 +35,45 @@ static int usb_cypress_writemem(struct usb_device *udev,u16 addr,u8 *data, u8 le
 
 int usb_cypress_load_firmware(struct usb_device *udev, const struct firmware *fw, int type)
 {
-	struct hexline hx;
-	u8 reset;
-	int ret,pos=0;
+	u8 *buf = kmalloc(sizeof(struct hexline), GFP_KERNEL);
+	struct hexline *hx = (struct hexline *)buf;
+	int ret, pos = 0;
+	u16 cpu_cs_register = cypress[type].cpu_cs_register;
 
 	/* stop the CPU */
-	reset = 1;
-	if ((ret = usb_cypress_writemem(udev,cypress[type].cpu_cs_register,&reset,1)) != 1)
+	buf[0] = 1;
+	if (usb_cypress_writemem(udev, cpu_cs_register, buf, 1) != 1)
 		err("could not stop the USB controller CPU.");
 
-	while ((ret = dvb_usb_get_hexline(fw,&hx,&pos)) > 0) {
-		deb_fw("writing to address 0x%04x (buffer: 0x%02x %02x)\n",hx.addr,hx.len,hx.chk);
-		ret = usb_cypress_writemem(udev,hx.addr,hx.data,hx.len);
+	while ((ret = dvb_usb_get_hexline(fw, hx, &pos)) > 0) {
+		deb_fw("writing to address 0x%04x (buffer: 0x%02x %02x)\n",
+		       hx->addr, hx->len, hx->chk);
+		ret = usb_cypress_writemem(udev, hx->addr, hx->data, hx->len);
 
-		if (ret != hx.len) {
+		if (ret != hx->len) {
 			err("error while transferring firmware "
 				"(transferred size: %d, block size: %d)",
-				ret,hx.len);
+				ret, hx->len);
 			ret = -EINVAL;
 			break;
 		}
 	}
 	if (ret < 0) {
-		err("firmware download failed at %d with %d",pos,ret);
+		err("firmware download failed at %d with %d", pos, ret);
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
+	kfree(buf);
 
 	return ret;
 }
-- 
2.11.0

