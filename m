Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42212 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1K3VO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 16:14:58 -0500
Received: by mail-ey0-f174.google.com with SMTP id k14so1228007eaa.19
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 13:14:57 -0800 (PST)
Message-ID: <1322687687.2476.8.camel@tvbox>
Subject: [PATCH 1/3] [For 3.3] dvb-usb-it913x multi firmware loader.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Wed, 30 Nov 2011 21:14:47 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Multi firmware loader
 This uses scatter write firmware headers
 The firmware must start with 03 XX 00
 and be the extract firmware length.

 I have tried all available firmwares with this loader.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   43 ++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 394bbf4..c7bf03c 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -485,35 +485,40 @@ static int it913x_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return ret;
 }
 
-
 static int it913x_download_firmware(struct usb_device *udev,
 					const struct firmware *fw)
 {
-	int ret = 0, i;
-	u8 packet_size, dlen;
+	int ret = 0, i = 0, pos = 0;
+	u8 packet_size;
 	u8 *fw_data;
 
-	packet_size = 0x29;
-
 	ret = it913x_wr_reg(udev, DEV_0,  I2C_CLK, I2C_CLK_100);
 
 	info("FRM Starting Firmware Download");
-	/* This uses scatter write firmware headers follow */
-	/* 03 XX 00     XX = chip number? */ 
-
-	for (i = 0; i < fw->size; i += packet_size) {
-			if (i > 0)
-				packet_size = 0x39;
-			fw_data = (u8 *)(fw->data + i);
-			dlen = ((i + packet_size) > fw->size)
-				? (fw->size - i) : packet_size;
-			ret |= it913x_io(udev, WRITE_DATA, DEV_0,
-				CMD_SCATTER_WRITE, 0, 0, fw_data, dlen);
-			udelay(1000);
+
+	/* Multi firmware loader */
+	/* This uses scatter write firmware headers */
+	/* The firmware must start with 03 XX 00 */
+	/* and be the extact firmware length */
+
+	while (i <= fw->size) {
+		if (((fw->data[i] == 0x3) && (fw->data[i + 2] == 0x0))
+			|| (i == fw->size)) {
+			packet_size = i - pos;
+			if ((packet_size > 0x19) || (i == fw->size)) {
+				fw_data = (u8 *)(fw->data + pos);
+				pos += packet_size;
+				if (packet_size > 0)
+					ret |= it913x_io(udev, WRITE_DATA,
+						DEV_0, CMD_SCATTER_WRITE, 0,
+						0, fw_data, packet_size);
+				udelay(1000);
+			}
+		}
+		i++;
 	}
 
-	ret |= it913x_io(udev, WRITE_CMD, DEV_0,
-			CMD_BOOT, 0, 0, NULL, 0);
+	ret |= it913x_io(udev, WRITE_CMD, DEV_0, CMD_BOOT, 0, 0, NULL, 0);
 
 	msleep(100);
 
-- 
1.7.7.1



