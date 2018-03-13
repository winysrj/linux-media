Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:56497 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932839AbeCMXkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/18] af9015: refactor copy firmware to slave demod
Date: Wed, 14 Mar 2018 01:39:40 +0200
Message-Id: <20180313233944.7234-14-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Small improvements.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 88 +++++++++++++++++------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index ffd4b225e439..1f352307a00a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -720,79 +720,79 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	struct af9015_state *state = d_to_priv(d);
 	struct usb_interface *intf = d->intf;
 	int ret;
-	u8 fw_params[4];
-	u8 val, i;
-	struct req_t req = {COPY_FIRMWARE, 0, 0x5100, 0, 0, sizeof(fw_params),
-		fw_params };
+	unsigned long timeout;
+	u8 val, firmware_info[4];
+	struct req_t req = {COPY_FIRMWARE, 0, 0x5100, 0, 0, 4, firmware_info};
 
 	dev_dbg(&intf->dev, "\n");
 
-	fw_params[0] = state->firmware_size >> 8;
-	fw_params[1] = state->firmware_size & 0xff;
-	fw_params[2] = state->firmware_checksum >> 8;
-	fw_params[3] = state->firmware_checksum & 0xff;
+	firmware_info[0] = (state->firmware_size >> 8) & 0xff;
+	firmware_info[1] = (state->firmware_size >> 0) & 0xff;
+	firmware_info[2] = (state->firmware_checksum >> 8) & 0xff;
+	firmware_info[3] = (state->firmware_checksum >> 0) & 0xff;
 
-	ret = af9015_read_reg_i2c(d, state->af9013_i2c_addr[1],
-			0x98be, &val);
+	/* Check whether firmware is already running */
+	ret = af9015_read_reg_i2c(d, state->af9013_i2c_addr[1], 0x98be, &val);
 	if (ret)
-		goto error;
-	else
-		dev_dbg(&intf->dev, "firmware status %02x\n", val);
+		goto err;
 
-	if (val == 0x0c) /* fw is running, no need for download */
-		goto exit;
+	dev_dbg(&intf->dev, "firmware status %02x\n", val);
 
-	/* set I2C master clock to fast (to speed up firmware copy) */
-	ret = af9015_write_reg(d, 0xd416, 0x04); /* 0x04 * 400ns */
-	if (ret)
-		goto error;
+	if (val == 0x0c)
+		return 0;
 
-	msleep(50);
+	/* Set i2c clock to 625kHz to speed up firmware copy */
+	ret = af9015_write_reg(d, 0xd416, 0x04);
+	if (ret)
+		goto err;
 
-	/* copy firmware */
+	/* Copy firmware from master demod to slave demod */
 	ret = af9015_ctrl_msg(d, &req);
-	if (ret)
+	if (ret) {
 		dev_err(&intf->dev, "firmware copy cmd failed %d\n", ret);
+		goto err;
+	}
 
-	dev_dbg(&intf->dev, "firmware copy done\n");
-
-	/* set I2C master clock back to normal */
-	ret = af9015_write_reg(d, 0xd416, 0x14); /* 0x14 * 400ns */
+	/* Set i2c clock to 125kHz */
+	ret = af9015_write_reg(d, 0xd416, 0x14);
 	if (ret)
-		goto error;
+		goto err;
 
-	/* request boot firmware */
-	ret = af9015_write_reg_i2c(d, state->af9013_i2c_addr[1],
-			0xe205, 1);
-	dev_dbg(&intf->dev, "firmware boot cmd status %d\n", ret);
+	/* Boot firmware */
+	ret = af9015_write_reg_i2c(d, state->af9013_i2c_addr[1], 0xe205, 0x01);
 	if (ret)
-		goto error;
+		goto err;
 
-	for (i = 0; i < 15; i++) {
-		msleep(100);
+	/* Poll firmware ready */
+	for (val = 0x00, timeout = jiffies + msecs_to_jiffies(1000);
+	     !time_after(jiffies, timeout) && val != 0x0c && val != 0x04;) {
+		msleep(20);
 
-		/* check firmware status */
+		/* Check firmware status. 0c=OK, 04=fail */
 		ret = af9015_read_reg_i2c(d, state->af9013_i2c_addr[1],
-				0x98be, &val);
-		dev_dbg(&intf->dev, "firmware status cmd status %d, firmware status %02x\n",
-			ret, val);
+					  0x98be, &val);
 		if (ret)
-			goto error;
+			goto err;
 
-		if (val == 0x0c || val == 0x04) /* success or fail */
-			break;
+		dev_dbg(&intf->dev, "firmware status %02x\n", val);
 	}
 
+	dev_dbg(&intf->dev, "firmware boot took %u ms\n",
+		jiffies_to_msecs(jiffies) - (jiffies_to_msecs(timeout) - 1000));
+
 	if (val == 0x04) {
-		ret = -ETIMEDOUT;
+		ret = -ENODEV;
 		dev_err(&intf->dev, "firmware did not run\n");
+		goto err;
 	} else if (val != 0x0c) {
 		ret = -ETIMEDOUT;
 		dev_err(&intf->dev, "firmware boot timeout\n");
+		goto err;
 	}
 
-error:
-exit:
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed %d\n", ret);
 	return ret;
 }
 
-- 
2.14.3
