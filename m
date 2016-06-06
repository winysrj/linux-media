Return-path: <linux-media-owner@vger.kernel.org>
Received: from the.earth.li ([46.43.34.31]:39152 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbcFFNYC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2016 09:24:02 -0400
Date: Mon, 6 Jun 2016 14:23:59 +0100
From: Jonathan McDowell <noodles@earth.li>
To: linux-media@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove spurious blank lines in dw2101 kernel messages
Message-ID: <20160606132359.GE7616@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DW2102 DVB-S/S2 driver uses the info() logging function from
dvb-usb.h. This function already appends a newline to the provided log
message, causing the dmesg output from DW2102 to include blank lines.
Fix this by removing the newline in the calls to info().

Signed-off-by: Jonathan McDowell <noodles@earth.li>

-----
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 14ef25d..687f740 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -896,7 +896,7 @@ static int su3000_power_ctrl(struct dvb_usb_device *d, int i)
 	struct dw2102_state *state = (struct dw2102_state *)d->priv;
 	u8 obuf[] = {0xde, 0};
 
-	info("%s: %d, initialized %d\n", __func__, i, state->initialized);
+	info("%s: %d, initialized %d", __func__, i, state->initialized);
 
 	if (i && !state->initialized) {
 		state->initialized = 1;
@@ -943,7 +943,7 @@ static int su3000_identify_state(struct usb_device *udev,
 				 struct dvb_usb_device_description **desc,
 				 int *cold)
 {
-	info("%s\n", __func__);
+	info("%s", __func__);
 
 	*cold = 0;
 	return 0;
@@ -1197,7 +1197,7 @@ static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
 				tuner_ops->set_bandwidth = stb6100_set_bandw;
 				tuner_ops->get_bandwidth = stb6100_get_bandw;
 				d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
-				info("Attached STV0900+STB6100!\n");
+				info("Attached STV0900+STB6100!");
 				return 0;
 			}
 		}
@@ -1211,7 +1211,7 @@ static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
 					&dw2104_stv6110_config,
 					&d->dev->i2c_adap)) {
 				d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
-				info("Attached STV0900+STV6110A!\n");
+				info("Attached STV0900+STV6110A!");
 				return 0;
 			}
 		}
@@ -1222,7 +1222,7 @@ static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
 				&d->dev->i2c_adap);
 		if (d->fe_adap[0].fe != NULL) {
 			d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
-			info("Attached cx24116!\n");
+			info("Attached cx24116!");
 			return 0;
 		}
 	}
@@ -1233,7 +1233,7 @@ static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
 		dvb_attach(ts2020_attach, d->fe_adap[0].fe,
 			&dw2104_ts2020_config, &d->dev->i2c_adap);
 		d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
-		info("Attached DS3000!\n");
+		info("Attached DS3000!");
 		return 0;
 	}
 
@@ -1252,7 +1252,7 @@ static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
 					&d->dev->i2c_adap);
 		if (d->fe_adap[0].fe != NULL) {
 			d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
-			info("Attached si21xx!\n");
+			info("Attached si21xx!");
 			return 0;
 		}
 	}
@@ -1264,7 +1264,7 @@ static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
 			if (dvb_attach(stb6000_attach, d->fe_adap[0].fe, 0x61,
 					&d->dev->i2c_adap)) {
 				d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
-				info("Attached stv0288!\n");
+				info("Attached stv0288!");
 				return 0;
 			}
 		}
@@ -1276,7 +1276,7 @@ static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
 					&d->dev->i2c_adap);
 		if (d->fe_adap[0].fe != NULL) {
 			d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
-			info("Attached stv0299!\n");
+			info("Attached stv0299!");
 			return 0;
 		}
 	}
@@ -1288,7 +1288,7 @@ static int dw3101_frontend_attach(struct dvb_usb_adapter *d)
 	d->fe_adap[0].fe = dvb_attach(tda10023_attach, &dw3101_tda10023_config,
 				&d->dev->i2c_adap, 0x48);
 	if (d->fe_adap[0].fe != NULL) {
-		info("Attached tda10023!\n");
+		info("Attached tda10023!");
 		return 0;
 	}
 	return -EIO;
@@ -1302,7 +1302,7 @@ static int zl100313_frontend_attach(struct dvb_usb_adapter *d)
 		if (dvb_attach(zl10039_attach, d->fe_adap[0].fe, 0x60,
 				&d->dev->i2c_adap)) {
 			d->fe_adap[0].fe->ops.set_voltage = dw210x_set_voltage;
-			info("Attached zl100313+zl10039!\n");
+			info("Attached zl100313+zl10039!");
 			return 0;
 		}
 	}
@@ -1327,7 +1327,7 @@ static int stv0288_frontend_attach(struct dvb_usb_adapter *d)
 
 	dw210x_op_rw(d->dev->udev, 0x8a, 0, 0, obuf, 2, DW210X_WRITE_MSG);
 
-	info("Attached stv0288+stb6000!\n");
+	info("Attached stv0288+stb6000!");
 
 	return 0;
 
@@ -1352,7 +1352,7 @@ static int ds3000_frontend_attach(struct dvb_usb_adapter *d)
 
 	dw210x_op_rw(d->dev->udev, 0x8a, 0, 0, obuf, 2, DW210X_WRITE_MSG);
 
-	info("Attached ds3000+ts2020!\n");
+	info("Attached ds3000+ts2020!");
 
 	return 0;
 }
@@ -1370,7 +1370,7 @@ static int prof_7500_frontend_attach(struct dvb_usb_adapter *d)
 
 	dw210x_op_rw(d->dev->udev, 0x8a, 0, 0, obuf, 2, DW210X_WRITE_MSG);
 
-	info("Attached STV0900+STB6100A!\n");
+	info("Attached STV0900+STB6100A!");
 
 	return 0;
 }
@@ -1418,11 +1418,11 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
 	if (dvb_attach(ts2020_attach, d->fe_adap[0].fe,
 				&dw2104_ts2020_config,
 				&d->dev->i2c_adap)) {
-		info("Attached DS3000/TS2020!\n");
+		info("Attached DS3000/TS2020!");
 		return 0;
 	}
 
-	info("Failed to attach DS3000/TS2020!\n");
+	info("Failed to attach DS3000/TS2020!");
 	return -EIO;
 }
 
@@ -1467,12 +1467,12 @@ static int t220_frontend_attach(struct dvb_usb_adapter *d)
 	if (d->fe_adap[0].fe != NULL) {
 		if (dvb_attach(tda18271_attach, d->fe_adap[0].fe, 0x60,
 					&d->dev->i2c_adap, &tda18271_config)) {
-			info("Attached TDA18271HD/CXD2820R!\n");
+			info("Attached TDA18271HD/CXD2820R!");
 			return 0;
 		}
 	}
 
-	info("Failed to attach TDA18271HD/CXD2820R!\n");
+	info("Failed to attach TDA18271HD/CXD2820R!");
 	return -EIO;
 }
 
@@ -1493,11 +1493,11 @@ static int m88rs2000_frontend_attach(struct dvb_usb_adapter *d)
 	if (dvb_attach(ts2020_attach, d->fe_adap[0].fe,
 				&dw2104_ts2020_config,
 				&d->dev->i2c_adap)) {
-		info("Attached RS2000/TS2020!\n");
+		info("Attached RS2000/TS2020!");
 		return 0;
 	}
 
-	info("Failed to attach RS2000/TS2020!\n");
+	info("Failed to attach RS2000/TS2020!");
 	return -EIO;
 }
 
-----

J.

-- 
/-\                             |       Hats off to the insane.
|@/  Debian GNU/Linux Developer |
\-                              |
