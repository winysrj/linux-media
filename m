Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47555 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751960AbdFODbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:35 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/15] af9015: fix and refactor i2c adapter algo logic
Date: Thu, 15 Jun 2017 06:30:59 +0300
Message-Id: <20170615033105.13517-9-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* fix write+read when write has more than one byte
* remove lock, not needed on that case
* remove useless i2c msg send loop, as we support only write, read and
write+read as one go and nothing more

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 153 ++++++++++++++++++----------------
 1 file changed, 79 insertions(+), 74 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 138416c..54c1d47 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -205,9 +205,9 @@ static int af9015_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct af9015_state *state = d_to_priv(d);
-	int ret = 0, i = 0;
+	int ret;
 	u16 addr;
-	u8 uninitialized_var(mbox), addr_len;
+	u8 mbox, addr_len;
 	struct req_t req;
 
 /*
@@ -232,84 +232,89 @@ Due to that the only way to select correct tuner is use demodulator I2C-gate.
 				| addr 0x3a  |                 |  addr 0xc6 |
 				|____________|                 |____________|
 */
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
 
-	while (i < num) {
-		if (msg[i].addr == state->af9013_config[0].i2c_addr ||
-		    msg[i].addr == state->af9013_config[1].i2c_addr) {
-			addr = msg[i].buf[0] << 8;
-			addr += msg[i].buf[1];
-			mbox = msg[i].buf[2];
-			addr_len = 3;
-		} else {
-			addr = msg[i].buf[0];
-			addr_len = 1;
-			/* mbox is don't care in that case */
-		}
+	if (msg[0].len == 0 || msg[0].flags & I2C_M_RD) {
+		addr = 0x0000;
+		mbox = 0;
+		addr_len = 0;
+	} else if (msg[0].len == 1) {
+		addr = msg[0].buf[0];
+		mbox = 0;
+		addr_len = 1;
+	} else if (msg[0].len == 2) {
+		addr = msg[0].buf[0] << 8|msg[0].buf[1] << 0;
+		mbox = 0;
+		addr_len = 2;
+	} else {
+		addr = msg[0].buf[0] << 8|msg[0].buf[1] << 0;
+		mbox = msg[0].buf[2];
+		addr_len = 3;
+	}
 
-		if (num > i + 1 && (msg[i+1].flags & I2C_M_RD)) {
-			if (msg[i].len > 3 || msg[i+1].len > 61) {
-				ret = -EOPNOTSUPP;
-				goto error;
-			}
-			if (msg[i].addr == state->af9013_config[0].i2c_addr)
-				req.cmd = READ_MEMORY;
-			else
-				req.cmd = READ_I2C;
-			req.i2c_addr = msg[i].addr;
-			req.addr = addr;
-			req.mbox = mbox;
-			req.addr_len = addr_len;
-			req.data_len = msg[i+1].len;
-			req.data = &msg[i+1].buf[0];
-			ret = af9015_ctrl_msg(d, &req);
-			i += 2;
-		} else if (msg[i].flags & I2C_M_RD) {
-			if (msg[i].len > 61) {
-				ret = -EOPNOTSUPP;
-				goto error;
-			}
-			if (msg[i].addr == state->af9013_config[0].i2c_addr) {
-				ret = -EINVAL;
-				goto error;
-			}
+	if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
+		/* i2c write */
+		if (msg[0].len > 21) {
+			ret = -EOPNOTSUPP;
+			goto err;
+		}
+		if (msg[0].addr == state->af9013_config[0].i2c_addr)
+			req.cmd = WRITE_MEMORY;
+		else
+			req.cmd = WRITE_I2C;
+		req.i2c_addr = msg[0].addr;
+		req.addr = addr;
+		req.mbox = mbox;
+		req.addr_len = addr_len;
+		req.data_len = msg[0].len-addr_len;
+		req.data = &msg[0].buf[addr_len];
+		ret = af9015_ctrl_msg(d, &req);
+	} else if (num == 2 && !(msg[0].flags & I2C_M_RD) &&
+		   (msg[1].flags & I2C_M_RD)) {
+		/* i2c write + read */
+		if (msg[0].len > 3 || msg[1].len > 61) {
+			ret = -EOPNOTSUPP;
+			goto err;
+		}
+		if (msg[0].addr == state->af9013_config[0].i2c_addr)
+			req.cmd = READ_MEMORY;
+		else
 			req.cmd = READ_I2C;
-			req.i2c_addr = msg[i].addr;
-			req.addr = addr;
-			req.mbox = mbox;
-			req.addr_len = addr_len;
-			req.data_len = msg[i].len;
-			req.data = &msg[i].buf[0];
-			ret = af9015_ctrl_msg(d, &req);
-			i += 1;
-		} else {
-			if (msg[i].len > 21) {
-				ret = -EOPNOTSUPP;
-				goto error;
-			}
-			if (msg[i].addr == state->af9013_config[0].i2c_addr)
-				req.cmd = WRITE_MEMORY;
-			else
-				req.cmd = WRITE_I2C;
-			req.i2c_addr = msg[i].addr;
-			req.addr = addr;
-			req.mbox = mbox;
-			req.addr_len = addr_len;
-			req.data_len = msg[i].len-addr_len;
-			req.data = &msg[i].buf[addr_len];
-			ret = af9015_ctrl_msg(d, &req);
-			i += 1;
+		req.i2c_addr = msg[0].addr;
+		req.addr = addr;
+		req.mbox = mbox;
+		req.addr_len = addr_len;
+		req.data_len = msg[1].len;
+		req.data = &msg[1].buf[0];
+		ret = af9015_ctrl_msg(d, &req);
+	} else if (num == 1 && (msg[0].flags & I2C_M_RD)) {
+		/* i2c read */
+		if (msg[0].len > 61) {
+			ret = -EOPNOTSUPP;
+			goto err;
 		}
-		if (ret)
-			goto error;
-
+		if (msg[0].addr == state->af9013_config[0].i2c_addr) {
+			ret = -EINVAL;
+			goto err;
+		}
+		req.cmd = READ_I2C;
+		req.i2c_addr = msg[0].addr;
+		req.addr = addr;
+		req.mbox = mbox;
+		req.addr_len = addr_len;
+		req.data_len = msg[0].len;
+		req.data = &msg[0].buf[0];
+		ret = af9015_ctrl_msg(d, &req);
+	} else {
+		ret = -EOPNOTSUPP;
+		dev_dbg(&d->udev->dev, "%s: unknown msg, num %u\n",
+			__func__, num);
 	}
-	ret = i;
-
-error:
-	mutex_unlock(&d->i2c_mutex);
+	if (ret)
+		goto err;
 
+	return num;
+err:
+	dev_dbg(&d->udev->dev, "%s: failed %d\n", __func__, ret);
 	return ret;
 }
 
-- 
http://palosaari.fi/
