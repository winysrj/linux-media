Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36074 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbcELKrQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2016 06:47:16 -0400
Received: by mail-wm0-f68.google.com with SMTP id w143so15136330wmw.3
        for <linux-media@vger.kernel.org>; Thu, 12 May 2016 03:47:15 -0700 (PDT)
From: Alessandro Radicati <alessandro@radicati.net>
To: crope@iki.fi, areguero@telefonica.net
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2] [media] af9035: fix for MXL5007T devices with I2C read issues
Date: Thu, 12 May 2016 12:47:12 +0200
Message-Id: <1463050032-16771-1-git-send-email-alessandro@radicati.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MXL5007T tuner will lock-up on some devices after an I2C
read transaction.  This patch works around this issue by inhibiting such
operations and emulating a 0x00 response.  The workaround is only applied to
USB devices known to exhibit this flaw.

Signed-off-by: Alessandro Radicati <alessandro@radicati.net>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 21 +++++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/af9035.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 2638e32..06e300e 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -348,6 +348,9 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 
 			ret = af9035_rd_regs(d, reg, &msg[1].buf[0],
 					msg[1].len);
+		} else if (state->no_read) {
+			memset(msg[1].buf, 0, msg[1].len);
+			ret = 0;
 		} else {
 			/* I2C write + read */
 			u8 buf[MAX_XFER_SIZE];
@@ -421,6 +424,9 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 		if (msg[0].len > 40) {
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
+		} else if (state->no_read) {
+			memset(msg[0].buf, 0, msg[0].len);
+			ret = 0;
 		} else {
 			/* I2C read */
 			u8 buf[5];
@@ -962,6 +968,21 @@ skip_eeprom:
 			state->af9033_config[i].clock = clock_lut_af9035[tmp];
 	}
 
+	state->no_read = false;
+	/* Some MXL5007T devices cannot properly handle tuner I2C read ops. */
+	if (state->af9033_config[0].tuner == AF9033_TUNER_MXL5007T &&
+		le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA)
+
+		switch (le16_to_cpu(d->udev->descriptor.idProduct)) {
+		case USB_PID_AVERMEDIA_A867:
+		case USB_PID_AVERMEDIA_TWINSTAR:
+			dev_info(&d->udev->dev,
+				"%s: Device may have issues with I2C read operations. Enabling fix.\n",
+				KBUILD_MODNAME);
+			state->no_read = true;
+			break;
+		}
+
 	return 0;
 
 err:
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 89e629a..c91d1a3 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -62,6 +62,7 @@ struct state {
 	u8 chip_version;
 	u16 chip_type;
 	u8 dual_mode:1;
+	u8 no_read:1;
 	u16 eeprom_addr;
 	u8 af9033_i2c_addr[2];
 	struct af9033_config af9033_config[2];
-- 
2.7.4

