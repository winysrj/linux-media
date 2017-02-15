Return-path: <linux-media-owner@vger.kernel.org>
Received: from the.earth.li ([46.43.34.31]:55077 "EHLO the.earth.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750719AbdBOTaI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 14:30:08 -0500
Date: Wed, 15 Feb 2017 19:18:51 +0000
From: Jonathan McDowell <noodles@earth.li>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] [media] dw2102: don't do DMA on stack
Message-ID: <20170215191851.GH17650@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I upgraded my media box today from 4.4.48 to 4.9.10 and hit WARNINGs in
the dw2102 driver for my TechnoTrend TT-connect S2-4600, one in
su3000_power_ctrl() and the other in tt_s2_4600_frontend_attach(). Both
were due to the use of buffers on the stack as parameters to
dvb_usb_generic_rw() and the resulting attempt to do DMA with them.

Patch below switches this driver over to using a buffer within the
device state structure, as has been done with other DVB-USB drivers.
Tested against 4.9.10 but applies to Linus' master cleanly.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
Cc: <stable@vger.kernel.org>

-----
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 2c720cb..1dde34f 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -68,6 +68,8 @@
 struct dw2102_state {
 	u8 initialized;
 	u8 last_lock;
+	u8 data[MAX_XFER_SIZE + 4];
+	struct mutex buf_mutex;
 	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
 
@@ -662,62 +664,69 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 								int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	u8 obuf[0x40], ibuf[0x40];
+	struct dw2102_state *state = (struct dw2102_state *)d->priv;
 
 	if (!d)
 		return -ENODEV;
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
+	if (mutex_lock_interruptible(&d->data_mutex) < 0) {
+		mutex_unlock(&d->i2c_mutex);
+		return -EAGAIN;
+	}
 
 	switch (num) {
 	case 1:
 		switch (msg[0].addr) {
 		case SU3000_STREAM_CTRL:
-			obuf[0] = msg[0].buf[0] + 0x36;
-			obuf[1] = 3;
-			obuf[2] = 0;
-			if (dvb_usb_generic_rw(d, obuf, 3, ibuf, 0, 0) < 0)
+			state->data[0] = msg[0].buf[0] + 0x36;
+			state->data[1] = 3;
+			state->data[2] = 0;
+			if (dvb_usb_generic_rw(d, state->data, 3,
+					state->data, 0, 0) < 0)
 				err("i2c transfer failed.");
 			break;
 		case DW2102_RC_QUERY:
-			obuf[0] = 0x10;
-			if (dvb_usb_generic_rw(d, obuf, 1, ibuf, 2, 0) < 0)
+			state->data[0] = 0x10;
+			if (dvb_usb_generic_rw(d, state->data, 1,
+					state->data, 2, 0) < 0)
 				err("i2c transfer failed.");
-			msg[0].buf[1] = ibuf[0];
-			msg[0].buf[0] = ibuf[1];
+			msg[0].buf[1] = state->data[0];
+			msg[0].buf[0] = state->data[1];
 			break;
 		default:
 			/* always i2c write*/
-			obuf[0] = 0x08;
-			obuf[1] = msg[0].addr;
-			obuf[2] = msg[0].len;
+			state->data[0] = 0x08;
+			state->data[1] = msg[0].addr;
+			state->data[2] = msg[0].len;
 
-			memcpy(&obuf[3], msg[0].buf, msg[0].len);
+			memcpy(&state->data[3], msg[0].buf, msg[0].len);
 
-			if (dvb_usb_generic_rw(d, obuf, msg[0].len + 3,
-						ibuf, 1, 0) < 0)
+			if (dvb_usb_generic_rw(d, state->data, msg[0].len + 3,
+						state->data, 1, 0) < 0)
 				err("i2c transfer failed.");
 
 		}
 		break;
 	case 2:
 		/* always i2c read */
-		obuf[0] = 0x09;
-		obuf[1] = msg[0].len;
-		obuf[2] = msg[1].len;
-		obuf[3] = msg[0].addr;
-		memcpy(&obuf[4], msg[0].buf, msg[0].len);
-
-		if (dvb_usb_generic_rw(d, obuf, msg[0].len + 4,
-					ibuf, msg[1].len + 1, 0) < 0)
+		state->data[0] = 0x09;
+		state->data[1] = msg[0].len;
+		state->data[2] = msg[1].len;
+		state->data[3] = msg[0].addr;
+		memcpy(&state->data[4], msg[0].buf, msg[0].len);
+
+		if (dvb_usb_generic_rw(d, state->data, msg[0].len + 4,
+					state->data, msg[1].len + 1, 0) < 0)
 			err("i2c transfer failed.");
 
-		memcpy(msg[1].buf, &ibuf[1], msg[1].len);
+		memcpy(msg[1].buf, &state->data[1], msg[1].len);
 		break;
 	default:
 		warn("more than 2 i2c messages at a time is not handled yet.");
 		break;
 	}
+	mutex_unlock(&d->data_mutex);
 	mutex_unlock(&d->i2c_mutex);
 	return num;
 }
@@ -845,17 +854,23 @@ static int su3000_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 static int su3000_power_ctrl(struct dvb_usb_device *d, int i)
 {
 	struct dw2102_state *state = (struct dw2102_state *)d->priv;
-	u8 obuf[] = {0xde, 0};
+	int ret = 0;
 
 	info("%s: %d, initialized %d", __func__, i, state->initialized);
 
 	if (i && !state->initialized) {
+		mutex_lock(&d->data_mutex);
+
+		state->data[0] = 0xde;
+		state->data[1] = 0;
+
 		state->initialized = 1;
 		/* reset board */
-		return dvb_usb_generic_rw(d, obuf, 2, NULL, 0, 0);
+		ret = dvb_usb_generic_rw(d, state->data, 2, NULL, 0, 0);
+		mutex_unlock(&d->data_mutex);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int su3000_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
@@ -1310,49 +1325,57 @@ static int prof_7500_frontend_attach(struct dvb_usb_adapter *d)
 	return 0;
 }
 
-static int su3000_frontend_attach(struct dvb_usb_adapter *d)
+static int su3000_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	u8 obuf[3] = { 0xe, 0x80, 0 };
-	u8 ibuf[] = { 0 };
+	struct dvb_usb_device *d = adap->dev;
+	struct dw2102_state *state = d->priv;
+
+	mutex_lock(&d->data_mutex);
 
-	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+	state->data[0] = 0xe;
+	state->data[1] = 0x80;
+	state->data[2] = 0;
+
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
-	obuf[0] = 0xe;
-	obuf[1] = 0x02;
-	obuf[2] = 1;
+	state->data[0] = 0xe;
+	state->data[1] = 0x02;
+	state->data[2] = 1;
 
-	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 	msleep(300);
 
-	obuf[0] = 0xe;
-	obuf[1] = 0x83;
-	obuf[2] = 0;
+	state->data[0] = 0xe;
+	state->data[1] = 0x83;
+	state->data[2] = 0;
 
-	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
-	obuf[0] = 0xe;
-	obuf[1] = 0x83;
-	obuf[2] = 1;
+	state->data[0] = 0xe;
+	state->data[1] = 0x83;
+	state->data[2] = 1;
 
-	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
-	obuf[0] = 0x51;
+	state->data[0] = 0x51;
 
-	if (dvb_usb_generic_rw(d->dev, obuf, 1, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 1, state->data, 1, 0) < 0)
 		err("command 0x51 transfer failed.");
 
-	d->fe_adap[0].fe = dvb_attach(ds3000_attach, &su3000_ds3000_config,
-					&d->dev->i2c_adap);
-	if (d->fe_adap[0].fe == NULL)
+	mutex_unlock(&d->data_mutex);
+
+	adap->fe_adap[0].fe = dvb_attach(ds3000_attach, &su3000_ds3000_config,
+					&d->i2c_adap);
+	if (adap->fe_adap[0].fe == NULL)
 		return -EIO;
 
-	if (dvb_attach(ts2020_attach, d->fe_adap[0].fe,
+	if (dvb_attach(ts2020_attach, adap->fe_adap[0].fe,
 				&dw2104_ts2020_config,
-				&d->dev->i2c_adap)) {
+				&d->i2c_adap)) {
 		info("Attached DS3000/TS2020!");
 		return 0;
 	}
@@ -1361,47 +1384,55 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
 	return -EIO;
 }
 
-static int t220_frontend_attach(struct dvb_usb_adapter *d)
+static int t220_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	u8 obuf[3] = { 0xe, 0x87, 0 };
-	u8 ibuf[] = { 0 };
+	struct dvb_usb_device *d = adap->dev;
+	struct dw2102_state *state = d->priv;
+
+	mutex_lock(&d->data_mutex);
 
-	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+	state->data[0] = 0xe;
+	state->data[1] = 0x87;
+	state->data[2] = 0x0;
+
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
-	obuf[0] = 0xe;
-	obuf[1] = 0x86;
-	obuf[2] = 1;
+	state->data[0] = 0xe;
+	state->data[1] = 0x86;
+	state->data[2] = 1;
 
-	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
-	obuf[0] = 0xe;
-	obuf[1] = 0x80;
-	obuf[2] = 0;
+	state->data[0] = 0xe;
+	state->data[1] = 0x80;
+	state->data[2] = 0;
 
-	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
 	msleep(50);
 
-	obuf[0] = 0xe;
-	obuf[1] = 0x80;
-	obuf[2] = 1;
+	state->data[0] = 0xe;
+	state->data[1] = 0x80;
+	state->data[2] = 1;
 
-	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
-	obuf[0] = 0x51;
+	state->data[0] = 0x51;
 
-	if (dvb_usb_generic_rw(d->dev, obuf, 1, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 1, state->data, 1, 0) < 0)
 		err("command 0x51 transfer failed.");
 
-	d->fe_adap[0].fe = dvb_attach(cxd2820r_attach, &cxd2820r_config,
-					&d->dev->i2c_adap, NULL);
-	if (d->fe_adap[0].fe != NULL) {
-		if (dvb_attach(tda18271_attach, d->fe_adap[0].fe, 0x60,
-					&d->dev->i2c_adap, &tda18271_config)) {
+	mutex_unlock(&d->data_mutex);
+
+	adap->fe_adap[0].fe = dvb_attach(cxd2820r_attach, &cxd2820r_config,
+					&d->i2c_adap, NULL);
+	if (adap->fe_adap[0].fe != NULL) {
+		if (dvb_attach(tda18271_attach, adap->fe_adap[0].fe, 0x60,
+					&d->i2c_adap, &tda18271_config)) {
 			info("Attached TDA18271HD/CXD2820R!");
 			return 0;
 		}
@@ -1411,23 +1442,30 @@ static int t220_frontend_attach(struct dvb_usb_adapter *d)
 	return -EIO;
 }
 
-static int m88rs2000_frontend_attach(struct dvb_usb_adapter *d)
+static int m88rs2000_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	u8 obuf[] = { 0x51 };
-	u8 ibuf[] = { 0 };
+	struct dvb_usb_device *d = adap->dev;
+	struct dw2102_state *state = d->priv;
+
+	mutex_lock(&d->data_mutex);
 
-	if (dvb_usb_generic_rw(d->dev, obuf, 1, ibuf, 1, 0) < 0)
+	state->data[0] = 0x51;
+
+	if (dvb_usb_generic_rw(d, state->data, 1, state->data, 1, 0) < 0)
 		err("command 0x51 transfer failed.");
 
-	d->fe_adap[0].fe = dvb_attach(m88rs2000_attach, &s421_m88rs2000_config,
-					&d->dev->i2c_adap);
+	mutex_unlock(&d->data_mutex);
 
-	if (d->fe_adap[0].fe == NULL)
+	adap->fe_adap[0].fe = dvb_attach(m88rs2000_attach,
+					&s421_m88rs2000_config,
+					&d->i2c_adap);
+
+	if (adap->fe_adap[0].fe == NULL)
 		return -EIO;
 
-	if (dvb_attach(ts2020_attach, d->fe_adap[0].fe,
+	if (dvb_attach(ts2020_attach, adap->fe_adap[0].fe,
 				&dw2104_ts2020_config,
-				&d->dev->i2c_adap)) {
+				&d->i2c_adap)) {
 		info("Attached RS2000/TS2020!");
 		return 0;
 	}
@@ -1440,44 +1478,50 @@ static int tt_s2_4600_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap->dev;
 	struct dw2102_state *state = d->priv;
-	u8 obuf[3] = { 0xe, 0x80, 0 };
-	u8 ibuf[] = { 0 };
 	struct i2c_adapter *i2c_adapter;
 	struct i2c_client *client;
 	struct i2c_board_info board_info;
 	struct m88ds3103_platform_data m88ds3103_pdata = {};
 	struct ts2020_config ts2020_config = {};
 
-	if (dvb_usb_generic_rw(d, obuf, 3, ibuf, 1, 0) < 0)
+	mutex_lock(&d->data_mutex);
+
+	state->data[0] = 0xe;
+	state->data[1] = 0x80;
+	state->data[2] = 0x0;
+
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
-	obuf[0] = 0xe;
-	obuf[1] = 0x02;
-	obuf[2] = 1;
+	state->data[0] = 0xe;
+	state->data[1] = 0x02;
+	state->data[2] = 1;
 
-	if (dvb_usb_generic_rw(d, obuf, 3, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 	msleep(300);
 
-	obuf[0] = 0xe;
-	obuf[1] = 0x83;
-	obuf[2] = 0;
+	state->data[0] = 0xe;
+	state->data[1] = 0x83;
+	state->data[2] = 0;
 
-	if (dvb_usb_generic_rw(d, obuf, 3, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
-	obuf[0] = 0xe;
-	obuf[1] = 0x83;
-	obuf[2] = 1;
+	state->data[0] = 0xe;
+	state->data[1] = 0x83;
+	state->data[2] = 1;
 
-	if (dvb_usb_generic_rw(d, obuf, 3, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 3, state->data, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
-	obuf[0] = 0x51;
+	state->data[0] = 0x51;
 
-	if (dvb_usb_generic_rw(d, obuf, 1, ibuf, 1, 0) < 0)
+	if (dvb_usb_generic_rw(d, state->data, 1, state->data, 1, 0) < 0)
 		err("command 0x51 transfer failed.");
 
+	mutex_unlock(&d->data_mutex);
+
 	/* attach demod */
 	m88ds3103_pdata.clk = 27000000;
 	m88ds3103_pdata.i2c_wr_max = 33;
-----

J.

-- 
Revd Jonathan McDowell, ULC | Stand by stomach, here comes banana...
