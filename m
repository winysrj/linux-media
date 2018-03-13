Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:40301 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932841AbeCMXkR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:17 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 17/18] af9015: convert to regmap api
Date: Wed, 14 Mar 2018 01:39:43 +0200
Message-Id: <20180313233944.7234-17-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use regmap for chip register access.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Kconfig  |   1 +
 drivers/media/usb/dvb-usb-v2/af9015.c | 209 ++++++++++++++++++----------------
 drivers/media/usb/dvb-usb-v2/af9015.h |   2 +
 3 files changed, 115 insertions(+), 97 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 0e4944b2b0f4..09a52aae299a 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -16,6 +16,7 @@ config DVB_USB_V2
 config DVB_USB_AF9015
 	tristate "Afatech AF9015 DVB-T USB2.0 support"
 	depends on DVB_USB_V2
+	select REGMAP
 	select DVB_AF9013
 	select DVB_PLL              if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2060   if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 99e3b14d493e..8379ef164fad 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -117,31 +117,6 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 	return ret;
 }
 
-static int af9015_write_regs(struct dvb_usb_device *d, u16 addr, u8 *val,
-	u8 len)
-{
-	struct req_t req = {WRITE_MEMORY, AF9015_I2C_DEMOD, addr, 0, 0, len,
-		val};
-	return af9015_ctrl_msg(d, &req);
-}
-
-static int af9015_read_regs(struct dvb_usb_device *d, u16 addr, u8 *val, u8 len)
-{
-	struct req_t req = {READ_MEMORY, AF9015_I2C_DEMOD, addr, 0, 0, len,
-		val};
-	return af9015_ctrl_msg(d, &req);
-}
-
-static int af9015_write_reg(struct dvb_usb_device *d, u16 addr, u8 val)
-{
-	return af9015_write_regs(d, addr, &val, 1);
-}
-
-static int af9015_read_reg(struct dvb_usb_device *d, u16 addr, u8 *val)
-{
-	return af9015_read_regs(d, addr, val, 1);
-}
-
 static int af9015_write_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
 	u8 val)
 {
@@ -168,38 +143,6 @@ static int af9015_read_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
 	return af9015_ctrl_msg(d, &req);
 }
 
-static int af9015_do_reg_bit(struct dvb_usb_device *d, u16 addr, u8 bit, u8 op)
-{
-	int ret;
-	u8 val, mask = 0x01;
-
-	ret = af9015_read_reg(d, addr, &val);
-	if (ret)
-		return ret;
-
-	mask <<= bit;
-	if (op) {
-		/* set bit */
-		val |= mask;
-	} else {
-		/* clear bit */
-		mask ^= 0xff;
-		val &= mask;
-	}
-
-	return af9015_write_reg(d, addr, val);
-}
-
-static int af9015_set_reg_bit(struct dvb_usb_device *d, u16 addr, u8 bit)
-{
-	return af9015_do_reg_bit(d, addr, bit, 1);
-}
-
-static int af9015_clear_reg_bit(struct dvb_usb_device *d, u16 addr, u8 bit)
-{
-	return af9015_do_reg_bit(d, addr, bit, 0);
-}
-
 static int af9015_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	int num)
 {
@@ -642,76 +585,73 @@ static int af9015_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 			reg1 = 0xdd8a;
 			reg2 = 0xdd0d;
 		}
-
-		ret = af9015_write_regs(d, reg1, buf, 2);
+		ret = regmap_bulk_write(state->regmap, reg1, buf, 2);
 		if (ret)
 			goto err;
-		ret = af9015_write_reg(d, reg2, utmp2);
+		ret = regmap_write(state->regmap, reg2, utmp2);
 		if (ret)
 			goto err;
 
 		/* TS IF settings */
 		if (state->dual_mode) {
-			ret = af9015_set_reg_bit(d, 0xd50b, 0);
-			if (ret)
-				goto err;
-			ret = af9015_set_reg_bit(d, 0xd520, 4);
-			if (ret)
-				goto err;
+			utmp1 = 0x01;
+			utmp2 = 0x10;
 		} else {
-			ret = af9015_clear_reg_bit(d, 0xd50b, 0);
-			if (ret)
-				goto err;
-			ret = af9015_clear_reg_bit(d, 0xd520, 4);
-			if (ret)
-				goto err;
+			utmp1 = 0x00;
+			utmp2 = 0x00;
 		}
+		ret = regmap_update_bits(state->regmap, 0xd50b, 0x01, utmp1);
+		if (ret)
+			goto err;
+		ret = regmap_update_bits(state->regmap, 0xd520, 0x10, utmp2);
+		if (ret)
+			goto err;
 
 		state->usb_ts_if_configured[adap_id] = true;
 	}
 
 	if (adap_id == 0 && onoff) {
 		/* Adapter 0 stream on. EP4: clear NAK, enable, clear reset */
-		ret = af9015_clear_reg_bit(d, 0xdd13, 5);
+		ret = regmap_update_bits(state->regmap, 0xdd13, 0x20, 0x00);
 		if (ret)
 			goto err;
-		ret = af9015_set_reg_bit(d, 0xdd11, 5);
+		ret = regmap_update_bits(state->regmap, 0xdd11, 0x20, 0x20);
 		if (ret)
 			goto err;
-		ret = af9015_clear_reg_bit(d, 0xd507, 2);
+		ret = regmap_update_bits(state->regmap, 0xd507, 0x04, 0x00);
 		if (ret)
 			goto err;
 	} else if (adap_id == 1 && onoff) {
 		/* Adapter 1 stream on. EP5: clear NAK, enable, clear reset */
-		ret = af9015_clear_reg_bit(d, 0xdd13, 6);
+		ret = regmap_update_bits(state->regmap, 0xdd13, 0x40, 0x00);
 		if (ret)
 			goto err;
-		ret = af9015_set_reg_bit(d, 0xdd11, 6);
+		ret = regmap_update_bits(state->regmap, 0xdd11, 0x40, 0x40);
 		if (ret)
 			goto err;
-		ret = af9015_clear_reg_bit(d, 0xd50b, 1);
+		ret = regmap_update_bits(state->regmap, 0xd50b, 0x02, 0x00);
 		if (ret)
 			goto err;
 	} else if (adap_id == 0 && !onoff) {
 		/* Adapter 0 stream off. EP4: set reset, disable, set NAK */
-		ret = af9015_set_reg_bit(d, 0xd507, 2);
+		ret = regmap_update_bits(state->regmap, 0xd507, 0x04, 0x04);
 		if (ret)
 			goto err;
-		ret = af9015_clear_reg_bit(d, 0xdd11, 5);
+		ret = regmap_update_bits(state->regmap, 0xdd11, 0x20, 0x00);
 		if (ret)
 			goto err;
-		ret = af9015_set_reg_bit(d, 0xdd13, 5);
+		ret = regmap_update_bits(state->regmap, 0xdd13, 0x20, 0x20);
 		if (ret)
 			goto err;
 	} else if (adap_id == 1 && !onoff) {
 		/* Adapter 1 stream off. EP5: set reset, disable, set NAK */
-		ret = af9015_set_reg_bit(d, 0xd50b, 1);
+		ret = regmap_update_bits(state->regmap, 0xd50b, 0x02, 0x02);
 		if (ret)
 			goto err;
-		ret = af9015_clear_reg_bit(d, 0xdd11, 6);
+		ret = regmap_update_bits(state->regmap, 0xdd11, 0x40, 0x00);
 		if (ret)
 			goto err;
-		ret = af9015_set_reg_bit(d, 0xdd13, 6);
+		ret = regmap_update_bits(state->regmap, 0xdd13, 0x40, 0x40);
 		if (ret)
 			goto err;
 	}
@@ -852,7 +792,7 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 		return 0;
 
 	/* Set i2c clock to 625kHz to speed up firmware copy */
-	ret = af9015_write_reg(d, 0xd416, 0x04);
+	ret = regmap_write(state->regmap, 0xd416, 0x04);
 	if (ret)
 		goto err;
 
@@ -864,7 +804,7 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	}
 
 	/* Set i2c clock to 125kHz */
-	ret = af9015_write_reg(d, 0xd416, 0x14);
+	ret = regmap_write(state->regmap, 0xd416, 0x14);
 	if (ret)
 		goto err;
 
@@ -1182,7 +1122,7 @@ static int af9015_init(struct dvb_usb_device *d)
 	mutex_init(&state->fe_mutex);
 
 	/* init RC canary */
-	ret = af9015_write_reg(d, 0x98e9, 0xff);
+	ret = regmap_write(state->regmap, 0x98e9, 0xff);
 	if (ret)
 		goto error;
 
@@ -1230,7 +1170,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 	u8 buf[17];
 
 	/* read registers needed to detect remote controller code */
-	ret = af9015_read_regs(d, 0x98d9, buf, sizeof(buf));
+	ret = regmap_bulk_read(state->regmap, 0x98d9, buf, sizeof(buf));
 	if (ret)
 		goto error;
 
@@ -1255,7 +1195,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 		dev_dbg(&intf->dev, "key pressed %*ph\n", 4, buf + 12);
 
 		/* Reset the canary */
-		ret = af9015_write_reg(d, 0x98e9, 0xff);
+		ret = regmap_write(state->regmap, 0x98e9, 0xff);
 		if (ret)
 			goto error;
 
@@ -1359,15 +1299,68 @@ static int af9015_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	#define af9015_get_rc_config NULL
 #endif
 
-static int af9015_probe(struct usb_interface *intf,
-		const struct usb_device_id *id)
+static int af9015_regmap_write(void *context, const void *data, size_t count)
+{
+	struct dvb_usb_device *d = context;
+	struct usb_interface *intf = d->intf;
+	int ret;
+	u16 reg = ((u8 *)data)[0] << 8 | ((u8 *)data)[1] << 0;
+	u8 *val = &((u8 *)data)[2];
+	const unsigned int len = count - 2;
+	struct req_t req = {WRITE_MEMORY, 0, reg, 0, 0, len, val};
+
+	ret = af9015_ctrl_msg(d, &req);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed %d\n", ret);
+	return ret;
+}
+
+static int af9015_regmap_read(void *context, const void *reg_buf,
+			      size_t reg_size, void *val_buf, size_t val_size)
+{
+	struct dvb_usb_device *d = context;
+	struct usb_interface *intf = d->intf;
+	int ret;
+	u16 reg = ((u8 *)reg_buf)[0] << 8 | ((u8 *)reg_buf)[1] << 0;
+	u8 *val = &((u8 *)val_buf)[0];
+	const unsigned int len = val_size;
+	struct req_t req = {READ_MEMORY, 0, reg, 0, 0, len, val};
+
+	ret = af9015_ctrl_msg(d, &req);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed %d\n", ret);
+	return ret;
+}
+
+static int af9015_probe(struct dvb_usb_device *d)
 {
+	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	struct usb_device *udev = interface_to_usbdev(intf);
+	int ret;
 	char manufacturer[sizeof("ITE Technologies, Inc.")];
+	static const struct regmap_config regmap_config = {
+		.reg_bits    =  16,
+		.val_bits    =  8,
+	};
+	static const struct regmap_bus regmap_bus = {
+		.read = af9015_regmap_read,
+		.write = af9015_regmap_write,
+	};
+
+	dev_dbg(&intf->dev, "\n");
 
 	memset(manufacturer, 0, sizeof(manufacturer));
 	usb_string(udev, udev->descriptor.iManufacturer,
-			manufacturer, sizeof(manufacturer));
+		   manufacturer, sizeof(manufacturer));
 	/*
 	 * There is two devices having same ID but different chipset. One uses
 	 * AF9015 and the other IT9135 chipset. Only difference seen on lsusb
@@ -1386,19 +1379,39 @@ static int af9015_probe(struct usb_interface *intf,
 	 * iProduct                2 DVB-T TV Stick
 	 */
 	if ((le16_to_cpu(udev->descriptor.idVendor) == USB_VID_TERRATEC) &&
-			(le16_to_cpu(udev->descriptor.idProduct) == 0x0099)) {
+	    (le16_to_cpu(udev->descriptor.idProduct) == 0x0099)) {
 		if (!strcmp("ITE Technologies, Inc.", manufacturer)) {
+			ret = -ENODEV;
 			dev_dbg(&intf->dev, "rejecting device\n");
-			return -ENODEV;
+			goto err;
 		}
 	}
 
-	return dvb_usbv2_probe(intf, id);
+	state->regmap = regmap_init(&intf->dev, &regmap_bus, d, &regmap_config);
+	if (IS_ERR(state->regmap)) {
+		ret = PTR_ERR(state->regmap);
+		goto err;
+	}
+
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed %d\n", ret);
+	return ret;
+}
+
+static void af9015_disconnect(struct dvb_usb_device *d)
+{
+	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
+
+	dev_dbg(&intf->dev, "\n");
+
+	regmap_exit(state->regmap);
 }
 
 /* interface 0 is used by DVB-T receiver and
    interface 1 is for remote controller (HID) */
-static struct dvb_usb_device_properties af9015_props = {
+static const struct dvb_usb_device_properties af9015_props = {
 	.driver_name = KBUILD_MODNAME,
 	.owner = THIS_MODULE,
 	.adapter_nr = adapter_nr,
@@ -1407,6 +1420,8 @@ static struct dvb_usb_device_properties af9015_props = {
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe = af9015_probe,
+	.disconnect = af9015_disconnect,
 	.identify_state = af9015_identify_state,
 	.firmware = AF9015_FIRMWARE,
 	.download_firmware = af9015_download_firmware,
@@ -1529,7 +1544,7 @@ MODULE_DEVICE_TABLE(usb, af9015_id_table);
 static struct usb_driver af9015_usb_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = af9015_id_table,
-	.probe = af9015_probe,
+	.probe = dvb_usbv2_probe,
 	.disconnect = dvb_usbv2_disconnect,
 	.suspend = dvb_usbv2_suspend,
 	.resume = dvb_usbv2_resume,
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.h b/drivers/media/usb/dvb-usb-v2/af9015.h
index 28710aaf058a..ad2b045cc39c 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.h
+++ b/drivers/media/usb/dvb-usb-v2/af9015.h
@@ -21,6 +21,7 @@
 #define AF9015_H
 
 #include <linux/hash.h>
+#include <linux/regmap.h>
 #include "dvb_usb.h"
 #include "af9013.h"
 #include "dvb-pll.h"
@@ -100,6 +101,7 @@ enum af9015_ir_mode {
 
 #define BUF_LEN 63
 struct af9015_state {
+	struct regmap *regmap;
 	u8 buf[BUF_LEN]; /* bulk USB control message */
 	u8 ir_mode;
 	u8 rc_repeat;
-- 
2.14.3
