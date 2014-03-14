Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43395 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaCNRaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 13:30:00 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] af9033: Don't export functions for the hardware filter
Date: Fri, 14 Mar 2014 14:29:06 -0300
Message-Id: <1394818146-23111-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exporting functions for hardware filter is a bad idea, as it
breaks compilation if:
	CONFIG_DVB_USB_AF9035=y
	CONFIG_DVB_AF9033=m

Because the PID filter function calls would be hardcoded at
af9035.

The same doesn't happen with af9033_attach() because the
dvb_attach() doesn't hardcode it. Instead, it dynamically
links it at runtime.

However, calling dvb_attach() multiple times is problematic,
as it increments module kref.

So, the better is to pass one parameter for the af9033 module
to fill the hardware filters, and then use it inside af9035.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/af9033.c  | 14 +++++++++-----
 drivers/media/dvb-frontends/af9033.h  | 23 +++++++++++++++--------
 drivers/media/usb/dvb-usb-v2/af9035.c | 10 +++++++---
 drivers/media/usb/dvb-usb-v2/af9035.h |  2 ++
 4 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 5a1c508c7417..be4bec2a9640 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -989,7 +989,7 @@ err:
 	return ret;
 }
 
-int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
+static int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 {
 	struct af9033_state *state = fe->demodulator_priv;
 	int ret;
@@ -1007,9 +1007,8 @@ err:
 
 	return ret;
 }
-EXPORT_SYMBOL(af9033_pid_filter_ctrl);
 
-int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid, int onoff)
+static int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid, int onoff)
 {
 	struct af9033_state *state = fe->demodulator_priv;
 	int ret;
@@ -1040,12 +1039,12 @@ err:
 
 	return ret;
 }
-EXPORT_SYMBOL(af9033_pid_filter);
 
 static struct dvb_frontend_ops af9033_ops;
 
 struct dvb_frontend *af9033_attach(const struct af9033_config *config,
-		struct i2c_adapter *i2c)
+				   struct i2c_adapter *i2c,
+				   struct af9033_ops *ops)
 {
 	int ret;
 	struct af9033_state *state;
@@ -1120,6 +1119,11 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	memcpy(&state->fe.ops, &af9033_ops, sizeof(struct dvb_frontend_ops));
 	state->fe.demodulator_priv = state;
 
+	if (ops) {
+		ops->pid_filter = af9033_pid_filter;
+		ops->pid_filter_ctrl = af9033_pid_filter_ctrl;
+	}
+
 	return &state->fe;
 
 err:
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index de245f9adb65..539f4db678b8 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -78,17 +78,24 @@ struct af9033_config {
 };
 
 
-#if IS_ENABLED(CONFIG_DVB_AF9033)
-extern struct dvb_frontend *af9033_attach(const struct af9033_config *config,
-	struct i2c_adapter *i2c);
+struct af9033_ops {
+	int (*pid_filter_ctrl)(struct dvb_frontend *fe, int onoff);
+	int (*pid_filter)(struct dvb_frontend *fe, int index, u16 pid,
+			  int onoff);
+};
 
-extern int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff);
 
-extern int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
-	int onoff);
+#if IS_ENABLED(CONFIG_DVB_AF9033)
+extern
+struct dvb_frontend *af9033_attach(const struct af9033_config *config,
+				   struct i2c_adapter *i2c,
+				   struct af9033_ops *ops);
+
 #else
-static inline struct dvb_frontend *af9033_attach(
-	const struct af9033_config *config, struct i2c_adapter *i2c)
+static inline
+struct dvb_frontend *af9033_attach(const struct af9033_config *config,
+				   struct i2c_adapter *i2c,
+				   struct af9033_ops *ops)
 {
 	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 31d09a23c82e..021e4d35e4d7 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -963,7 +963,7 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 
 	/* attach demodulator */
 	adap->fe[0] = dvb_attach(af9033_attach, &state->af9033_config[adap->id],
-			&d->i2c_adap);
+			&d->i2c_adap, &state->ops);
 	if (adap->fe[0] == NULL) {
 		ret = -ENODEV;
 		goto err;
@@ -1373,13 +1373,17 @@ static int af9035_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
 
 static int af9035_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
-	return af9033_pid_filter_ctrl(adap->fe[0], onoff);
+	struct state *state = adap_to_priv(adap);
+
+	return state->ops.pid_filter_ctrl(adap->fe[0], onoff);
 }
 
 static int af9035_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 		int onoff)
 {
-	return af9033_pid_filter(adap->fe[0], index, pid, onoff);
+	struct state *state = adap_to_priv(adap);
+
+	return state->ops.pid_filter(adap->fe[0], index, pid, onoff);
 }
 
 static int af9035_probe(struct usb_interface *intf,
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index a1c68d829b8c..c21902fdd4c4 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -62,6 +62,8 @@ struct state {
 	u8 dual_mode:1;
 	u16 eeprom_addr;
 	struct af9033_config af9033_config[2];
+
+	struct af9033_ops ops;
 };
 
 static const u32 clock_lut_af9035[] = {
-- 
1.8.5.3

