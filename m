Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38594 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbcDOPhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 11:37:31 -0400
Received: by mail-wm0-f41.google.com with SMTP id u206so37899041wme.1
        for <linux-media@vger.kernel.org>; Fri, 15 Apr 2016 08:37:30 -0700 (PDT)
From: Alessandro Radicati <alessandro@radicati.net>
To: crope@iki.fi, areguero@telefonica.net
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] af9035: fix for MXL5007T devices with I2C read issues
Date: Fri, 15 Apr 2016 17:37:27 +0200
Message-Id: <1460734647-8941-1-git-send-email-alessandro@radicati.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MXL5007T tuner will lock-up on some devices after an I2C read
transaction.  This patch adds a kernel module parameter "no_read" to work
around this issue by inhibiting such operations and emulating a 0x00
response.  The workaround is applied automatically to USB product IDs known
to exhibit this flaw, unless the kernel module parameter is specified.

Signed-off-by: Alessandro Radicati <alessandro@radicati.net>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 27 +++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/af9035.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 2638e32..8225403 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -24,6 +24,10 @@
 /* Max transfer size done by I2C transfer functions */
 #define MAX_XFER_SIZE  64
 
+static int dvb_usb_af9035_no_read = -1;
+module_param_named(no_read, dvb_usb_af9035_no_read, int, 0644);
+MODULE_PARM_DESC(no_read, "Emulate I2C reads for devices that do not support them.");
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static u16 af9035_checksum(const u8 *buf, size_t len)
@@ -348,6 +352,9 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 
 			ret = af9035_rd_regs(d, reg, &msg[1].buf[0],
 					msg[1].len);
+		} else if (state->no_read) {
+			memset(msg[1].buf, 0, msg[1].len);
+			ret = 0;
 		} else {
 			/* I2C write + read */
 			u8 buf[MAX_XFER_SIZE];
@@ -421,6 +428,9 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 		if (msg[0].len > 40) {
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
+		} else if (state->no_read) {
+			memset(msg[0].buf, 0, msg[0].len);
+			ret = 0;
 		} else {
 			/* I2C read */
 			u8 buf[5];
@@ -962,6 +972,23 @@ skip_eeprom:
 			state->af9033_config[i].clock = clock_lut_af9035[tmp];
 	}
 
+	/* Some MXL5007T devices cannot properly handle tuner I2C read ops. */
+	if (dvb_usb_af9035_no_read != -1) { /* Override with module param */
+		state->no_read = dvb_usb_af9035_no_read == 0 ? false : true;
+	} else {
+		switch (le16_to_cpu(d->udev->descriptor.idProduct)) {
+		case USB_PID_AVERMEDIA_A867:
+		case USB_PID_AVERMEDIA_TWINSTAR:
+			dev_info(&d->udev->dev,
+				"%s: Device may have issues with I2C read operations. Enabling fix.\n",
+				KBUILD_MODNAME);
+			state->no_read = true;
+			break;
+		default:
+			state->no_read = false;
+		}
+	}
+
 	return 0;
 
 err:
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index df22001..a76dafa 100644
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
2.5.0

