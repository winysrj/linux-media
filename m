Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab2HEDaY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Aug 2012 23:30:24 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/5] [media] az6007: convert it to use dvb-usb-v2
Date: Sun,  5 Aug 2012 00:30:09 -0300
Message-Id: <1344137411-27948-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344137411-27948-1-git-send-email-mchehab@redhat.com>
References: <1344137411-27948-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change it to use dvb-usb-v2. The driver should be working as before.
The only functional changes should be at the driver debug logs.

This driver needs the cypress firmware load, so, auto-selects it.

Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb-v2/Kconfig               |   9 +
 drivers/media/dvb/dvb-usb-v2/Makefile              |   3 +
 drivers/media/dvb/{dvb-usb => dvb-usb-v2}/az6007.c | 382 +++++++++------------
 drivers/media/dvb/dvb-usb/Kconfig                  |   8 -
 drivers/media/dvb/dvb-usb/Makefile                 |   3 -
 5 files changed, 174 insertions(+), 231 deletions(-)
 rename drivers/media/dvb/{dvb-usb => dvb-usb-v2}/az6007.c (65%)

diff --git a/drivers/media/dvb/dvb-usb-v2/Kconfig b/drivers/media/dvb/dvb-usb-v2/Kconfig
index 98b8fb5..e7ff148 100644
--- a/drivers/media/dvb/dvb-usb-v2/Kconfig
+++ b/drivers/media/dvb/dvb-usb-v2/Kconfig
@@ -68,6 +68,15 @@ config DVB_USB_AU6610
 	help
 	  Say Y here to support the Sigmatek DVB-110 DVB-T USB2.0 receiver.
 
+config DVB_USB_AZ6007
+	tristate "AzureWave 6007 and clones DVB-T/C USB2.0 support"
+	depends on DVB_USB_V2
+	select DVB_USB_CYPRESS_FIRMWARE
+	select DVB_DRXK if !DVB_FE_CUSTOMISE
+	select MEDIA_TUNER_MT2063 if !DVB_FE_CUSTOMISE
+	help
+	  Say Y here to support the AZ6007 receivers like Terratec H7.
+
 config DVB_USB_CE6230
 	tristate "Intel CE6230 DVB-T USB2.0 support"
 	depends on DVB_USB_V2
diff --git a/drivers/media/dvb/dvb-usb-v2/Makefile b/drivers/media/dvb/dvb-usb-v2/Makefile
index 4438dcd..a784bf4 100644
--- a/drivers/media/dvb/dvb-usb-v2/Makefile
+++ b/drivers/media/dvb/dvb-usb-v2/Makefile
@@ -16,6 +16,9 @@ obj-$(CONFIG_DVB_USB_ANYSEE) += dvb-usb-anysee.o
 dvb-usb-au6610-objs = au6610.o
 obj-$(CONFIG_DVB_USB_AU6610) += dvb-usb-au6610.o
 
+dvb-usb-az6007-objs = az6007.o
+obj-$(CONFIG_DVB_USB_AZ6007) += dvb-usb-az6007.o
+
 dvb-usb-ce6230-objs = ce6230.o
 obj-$(CONFIG_DVB_USB_CE6230) += dvb-usb-ce6230.o
 
diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb-v2/az6007.c
similarity index 65%
rename from drivers/media/dvb/dvb-usb/az6007.c
rename to drivers/media/dvb/dvb-usb-v2/az6007.c
index 86861e6..9d2ad49 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb-v2/az6007.c
@@ -24,20 +24,14 @@
 #include "drxk.h"
 #include "mt2063.h"
 #include "dvb_ca_en50221.h"
+#include "dvb_usb.h"
+#include "cypress_firmware.h"
 
-#define DVB_USB_LOG_PREFIX "az6007"
-#include "dvb-usb.h"
+#define AZ6007_FIRMWARE "dvb-usb-terratec-h7-az6007.fw"
 
-/* debug */
-int dvb_usb_az6007_debug;
-module_param_named(debug, dvb_usb_az6007_debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))."
-		 DVB_USB_DEBUG_STATUS);
-
-#define deb_info(args...) dprintk(dvb_usb_az6007_debug, 0x01, args)
-#define deb_xfer(args...) dprintk(dvb_usb_az6007_debug, 0x02, args)
-#define deb_rc(args...)   dprintk(dvb_usb_az6007_debug, 0x04, args)
-#define deb_fe(args...)   dprintk(dvb_usb_az6007_debug, 0x08, args)
+static int az6007_xfer_debug;
+module_param_named(xfer_debug, az6007_xfer_debug, int, 0644);
+MODULE_PARM_DESC(xfer_debug, "Enable xfer debug");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -75,18 +69,13 @@ static struct drxk_config terratec_h7_drxk = {
 
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
+	struct az6007_device_state *st = fe_to_priv(fe);
 	struct dvb_usb_adapter *adap = fe->sec_priv;
-	struct az6007_device_state *st;
 	int status = 0;
 
-	deb_info("%s: %s\n", __func__, enable ? "enable" : "disable");
-
-	if (!adap)
-		return -EINVAL;
-
-	st = adap->dev->priv;
+	pr_debug("%s: %s\n", __func__, enable ? "enable" : "disable");
 
-	if (!st)
+	if (!adap || !st)
 		return -EINVAL;
 
 	if (enable)
@@ -113,13 +102,16 @@ static int __az6007_read(struct usb_device *udev, u8 req, u16 value,
 			      USB_TYPE_VENDOR | USB_DIR_IN,
 			      value, index, b, blen, 5000);
 	if (ret < 0) {
-		warn("usb read operation failed. (%d)", ret);
+		pr_warn("usb read operation failed. (%d)\n", ret);
 		return -EIO;
 	}
 
-	deb_xfer("in: req. %02x, val: %04x, ind: %04x, buffer: ", req, value,
-		 index);
-	debug_dump(b, blen, deb_xfer);
+	if (az6007_xfer_debug) {
+		printk(KERN_DEBUG "az6007: IN  req: %02x, value: %04x, index: %04x\n",
+		       req, value, index);
+		print_hex_dump_bytes("az6007: payload: ",
+				     DUMP_PREFIX_NONE, b, blen);
+	}
 
 	return ret;
 }
@@ -145,13 +137,16 @@ static int __az6007_write(struct usb_device *udev, u8 req, u16 value,
 {
 	int ret;
 
-	deb_xfer("out: req. %02x, val: %04x, ind: %04x, buffer: ", req, value,
-		 index);
-	debug_dump(b, blen, deb_xfer);
+	if (az6007_xfer_debug) {
+		printk(KERN_DEBUG "az6007: OUT req: %02x, value: %04x, index: %04x\n",
+		       req, value, index);
+		print_hex_dump_bytes("az6007: payload: ",
+				     DUMP_PREFIX_NONE, b, blen);
+	}
 
 	if (blen > 64) {
-		err("az6007: tried to write %d bytes, but I2C max size is 64 bytes\n",
-		    blen);
+		pr_err("az6007: tried to write %d bytes, but I2C max size is 64 bytes\n",
+		       blen);
 		return -EOPNOTSUPP;
 	}
 
@@ -161,7 +156,7 @@ static int __az6007_write(struct usb_device *udev, u8 req, u16 value,
 			      USB_TYPE_VENDOR | USB_DIR_OUT,
 			      value, index, b, blen, 5000);
 	if (ret != blen) {
-		err("usb write operation failed. (%d)", ret);
+		pr_err("usb write operation failed. (%d)\n", ret);
 		return -EIO;
 	}
 
@@ -184,11 +179,11 @@ static int az6007_write(struct dvb_usb_device *d, u8 req, u16 value,
 	return ret;
 }
 
-static int az6007_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
+static int az6007_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 {
-	struct dvb_usb_device *d = adap->dev;
+	struct dvb_usb_device *d = fe_to_d(fe);
 
-	deb_info("%s: %s", __func__, onoff ? "enable" : "disable");
+	pr_debug("%s: %s\n", __func__, onoff ? "enable" : "disable");
 
 	return az6007_write(d, 0xbc, onoff, 0, NULL, 0);
 }
@@ -196,7 +191,7 @@ static int az6007_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 /* remote control stuff (does not work with my box) */
 static int az6007_rc_query(struct dvb_usb_device *d)
 {
-	struct az6007_device_state *st = d->priv;
+	struct az6007_device_state *st = d_to_priv(d);
 	unsigned code = 0;
 
 	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
@@ -224,7 +219,7 @@ static int az6007_ci_read_attribute_mem(struct dvb_ca_en50221 *ca,
 					int address)
 {
 	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
-	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+	struct az6007_device_state *state = d_to_priv(d);
 
 	int ret;
 	u8 req;
@@ -249,7 +244,7 @@ static int az6007_ci_read_attribute_mem(struct dvb_ca_en50221 *ca,
 
 	ret = az6007_read(d, req, value, index, b, blen);
 	if (ret < 0) {
-		warn("usb in operation failed. (%d)", ret);
+		pr_warn("usb in operation failed. (%d)\n", ret);
 		ret = -EINVAL;
 	} else {
 		ret = b[0];
@@ -266,7 +261,7 @@ static int az6007_ci_write_attribute_mem(struct dvb_ca_en50221 *ca,
 					 u8 value)
 {
 	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
-	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+	struct az6007_device_state *state = d_to_priv(d);
 
 	int ret;
 	u8 req;
@@ -274,7 +269,7 @@ static int az6007_ci_write_attribute_mem(struct dvb_ca_en50221 *ca,
 	u16 index;
 	int blen;
 
-	deb_info("%s %d", __func__, slot);
+	pr_debug("%s(), slot %d\n", __func__, slot);
 	if (slot != 0)
 		return -EINVAL;
 
@@ -286,7 +281,7 @@ static int az6007_ci_write_attribute_mem(struct dvb_ca_en50221 *ca,
 
 	ret = az6007_write(d, req, value1, index, NULL, blen);
 	if (ret != 0)
-		warn("usb out operation failed. (%d)", ret);
+		pr_warn("usb out operation failed. (%d)\n", ret);
 
 	mutex_unlock(&state->ca_mutex);
 	return ret;
@@ -297,7 +292,7 @@ static int az6007_ci_read_cam_control(struct dvb_ca_en50221 *ca,
 				      u8 address)
 {
 	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
-	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+	struct az6007_device_state *state = d_to_priv(d);
 
 	int ret;
 	u8 req;
@@ -322,14 +317,14 @@ static int az6007_ci_read_cam_control(struct dvb_ca_en50221 *ca,
 
 	ret = az6007_read(d, req, value, index, b, blen);
 	if (ret < 0) {
-		warn("usb in operation failed. (%d)", ret);
+		pr_warn("usb in operation failed. (%d)\n", ret);
 		ret = -EINVAL;
 	} else {
 		if (b[0] == 0)
-			warn("Read CI IO error");
+			pr_warn("Read CI IO error\n");
 
 		ret = b[1];
-		deb_info("read cam data = %x from 0x%x", b[1], value);
+		pr_debug("read cam data = %x from 0x%x\n", b[1], value);
 	}
 
 	mutex_unlock(&state->ca_mutex);
@@ -343,7 +338,7 @@ static int az6007_ci_write_cam_control(struct dvb_ca_en50221 *ca,
 				       u8 value)
 {
 	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
-	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+	struct az6007_device_state *state = d_to_priv(d);
 
 	int ret;
 	u8 req;
@@ -362,7 +357,7 @@ static int az6007_ci_write_cam_control(struct dvb_ca_en50221 *ca,
 
 	ret = az6007_write(d, req, value1, index, NULL, blen);
 	if (ret != 0) {
-		warn("usb out operation failed. (%d)", ret);
+		pr_warn("usb out operation failed. (%d)\n", ret);
 		goto failed;
 	}
 
@@ -393,7 +388,7 @@ static int CI_CamReady(struct dvb_ca_en50221 *ca, int slot)
 
 	ret = az6007_read(d, req, value, index, b, blen);
 	if (ret < 0) {
-		warn("usb in operation failed. (%d)", ret);
+		pr_warn("usb in operation failed. (%d)\n", ret);
 		ret = -EIO;
 	} else{
 		ret = b[0];
@@ -405,7 +400,7 @@ static int CI_CamReady(struct dvb_ca_en50221 *ca, int slot)
 static int az6007_ci_slot_reset(struct dvb_ca_en50221 *ca, int slot)
 {
 	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
-	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+	struct az6007_device_state *state = d_to_priv(d);
 
 	int ret, i;
 	u8 req;
@@ -422,7 +417,7 @@ static int az6007_ci_slot_reset(struct dvb_ca_en50221 *ca, int slot)
 
 	ret = az6007_write(d, req, value, index, NULL, blen);
 	if (ret != 0) {
-		warn("usb out operation failed. (%d)", ret);
+		pr_warn("usb out operation failed. (%d)\n", ret);
 		goto failed;
 	}
 
@@ -434,7 +429,7 @@ static int az6007_ci_slot_reset(struct dvb_ca_en50221 *ca, int slot)
 
 	ret = az6007_write(d, req, value, index, NULL, blen);
 	if (ret != 0) {
-		warn("usb out operation failed. (%d)", ret);
+		pr_warn("usb out operation failed. (%d)\n", ret);
 		goto failed;
 	}
 
@@ -442,7 +437,7 @@ static int az6007_ci_slot_reset(struct dvb_ca_en50221 *ca, int slot)
 		msleep(100);
 
 		if (CI_CamReady(ca, slot)) {
-			deb_info("CAM Ready");
+			pr_debug("CAM Ready\n");
 			break;
 		}
 	}
@@ -461,7 +456,7 @@ static int az6007_ci_slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
 static int az6007_ci_slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
 {
 	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
-	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+	struct az6007_device_state *state = d_to_priv(d);
 
 	int ret;
 	u8 req;
@@ -469,7 +464,7 @@ static int az6007_ci_slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
 	u16 index;
 	int blen;
 
-	deb_info("%s", __func__);
+	pr_debug("%s()\n", __func__);
 	mutex_lock(&state->ca_mutex);
 	req = 0xC7;
 	value = 1;
@@ -478,7 +473,7 @@ static int az6007_ci_slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
 
 	ret = az6007_write(d, req, value, index, NULL, blen);
 	if (ret != 0) {
-		warn("usb out operation failed. (%d)", ret);
+		pr_warn("usb out operation failed. (%d)\n", ret);
 		goto failed;
 	}
 
@@ -490,7 +485,7 @@ failed:
 static int az6007_ci_poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)
 {
 	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
-	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+	struct az6007_device_state *state = d_to_priv(d);
 	int ret;
 	u8 req;
 	u16 value;
@@ -510,7 +505,7 @@ static int az6007_ci_poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int o
 
 	ret = az6007_read(d, req, value, index, b, blen);
 	if (ret < 0) {
-		warn("usb in operation failed. (%d)", ret);
+		pr_warn("usb in operation failed. (%d)\n", ret);
 		ret = -EIO;
 	} else
 		ret = 0;
@@ -530,12 +525,12 @@ static void az6007_ci_uninit(struct dvb_usb_device *d)
 {
 	struct az6007_device_state *state;
 
-	deb_info("%s", __func__);
+	pr_debug("%s()\n", __func__);
 
 	if (NULL == d)
 		return;
 
-	state = (struct az6007_device_state *)d->priv;
+	state = d_to_priv(d);
 	if (NULL == state)
 		return;
 
@@ -548,16 +543,15 @@ static void az6007_ci_uninit(struct dvb_usb_device *d)
 }
 
 
-static int az6007_ci_init(struct dvb_usb_adapter *a)
+static int az6007_ci_init(struct dvb_usb_adapter *adap)
 {
-	struct dvb_usb_device *d = a->dev;
-	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct az6007_device_state *state = adap_to_priv(adap);
 	int ret;
 
-	deb_info("%s", __func__);
+	pr_debug("%s()\n", __func__);
 
 	mutex_init(&state->ca_mutex);
-
 	state->ca.owner			= THIS_MODULE;
 	state->ca.read_attribute_mem	= az6007_ci_read_attribute_mem;
 	state->ca.write_attribute_mem	= az6007_ci_write_attribute_mem;
@@ -569,49 +563,51 @@ static int az6007_ci_init(struct dvb_usb_adapter *a)
 	state->ca.poll_slot_status	= az6007_ci_poll_slot_status;
 	state->ca.data			= d;
 
-	ret = dvb_ca_en50221_init(&a->dvb_adap,
+	ret = dvb_ca_en50221_init(&adap->dvb_adap,
 				  &state->ca,
 				  0, /* flags */
 				  1);/* n_slots */
 	if (ret != 0) {
-		err("Cannot initialize CI: Error %d.", ret);
+		pr_err("Cannot initialize CI: Error %d.\n", ret);
 		memset(&state->ca, 0, sizeof(state->ca));
 		return ret;
 	}
 
-	deb_info("CI initialized.");
+	pr_debug("CI initialized.\n");
 
 	return 0;
 }
 
-static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
+static int az6007_read_mac_addr(struct dvb_usb_adapter *adap, u8 mac[6])
 {
-	struct az6007_device_state *st = d->priv;
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct az6007_device_state *st = adap_to_priv(adap);
 	int ret;
 
 	ret = az6007_read(d, AZ6007_READ_DATA, 6, 0, st->data, 6);
 	memcpy(mac, st->data, 6);
 
 	if (ret > 0)
-		deb_info("%s: mac is %pM\n", __func__, mac);
+		pr_debug("%s: mac is %pM\n", __func__, mac);
 
 	return ret;
 }
 
 static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	struct az6007_device_state *st = adap->dev->priv;
+	struct az6007_device_state *st = adap_to_priv(adap);
+	struct dvb_usb_device *d = adap_to_d(adap);
 
-	deb_info("attaching demod drxk");
+	pr_debug("attaching demod drxk\n");
 
-	adap->fe_adap[0].fe = dvb_attach(drxk_attach, &terratec_h7_drxk,
-					 &adap->dev->i2c_adap);
-	if (!adap->fe_adap[0].fe)
+	adap->fe[0] = dvb_attach(drxk_attach, &terratec_h7_drxk,
+				 &d->i2c_adap);
+	if (!adap->fe[0])
 		return -EINVAL;
 
-	adap->fe_adap[0].fe->sec_priv = adap;
-	st->gate_ctrl = adap->fe_adap[0].fe->ops.i2c_gate_ctrl;
-	adap->fe_adap[0].fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
+	adap->fe[0]->sec_priv = adap;
+	st->gate_ctrl = adap->fe[0]->ops.i2c_gate_ctrl;
+	adap->fe[0]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
 
 	az6007_ci_init(adap);
 
@@ -620,28 +616,30 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 
 static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	deb_info("attaching tuner mt2063");
+	struct dvb_usb_device *d = adap_to_d(adap);
+
+	pr_debug("attaching tuner mt2063\n");
 
 	/* Attach mt2063 to DVB-C frontend */
-	if (adap->fe_adap[0].fe->ops.i2c_gate_ctrl)
-		adap->fe_adap[0].fe->ops.i2c_gate_ctrl(adap->fe_adap[0].fe, 1);
-	if (!dvb_attach(mt2063_attach, adap->fe_adap[0].fe,
+	if (adap->fe[0]->ops.i2c_gate_ctrl)
+		adap->fe[0]->ops.i2c_gate_ctrl(adap->fe[0], 1);
+	if (!dvb_attach(mt2063_attach, adap->fe[0],
 			&az6007_mt2063_config,
-			&adap->dev->i2c_adap))
+			&d->i2c_adap))
 		return -EINVAL;
 
-	if (adap->fe_adap[0].fe->ops.i2c_gate_ctrl)
-		adap->fe_adap[0].fe->ops.i2c_gate_ctrl(adap->fe_adap[0].fe, 0);
+	if (adap->fe[0]->ops.i2c_gate_ctrl)
+		adap->fe[0]->ops.i2c_gate_ctrl(adap->fe[0], 0);
 
 	return 0;
 }
 
 int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
-	struct az6007_device_state *st = d->priv;
+	struct az6007_device_state *st = d_to_priv(d);
 	int ret;
 
-	deb_info("%s()\n", __func__);
+	pr_debug("%s()\n", __func__);
 
 	if (!st->warm) {
 		mutex_init(&st->mutex);
@@ -694,7 +692,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			   int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	struct az6007_device_state *st = d->priv;
+	struct az6007_device_state *st = d_to_priv(d);
 	int i, j, len;
 	int ret = 0;
 	u16 index;
@@ -717,9 +715,8 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			 * the first xfer has just 1 byte length.
 			 * Need to join both into one operation
 			 */
-			if (dvb_usb_az6007_debug & 2)
-				printk(KERN_DEBUG
-				       "az6007 I2C xfer write+read addr=0x%x len=%d/%d: ",
+			if (az6007_xfer_debug)
+				printk(KERN_DEBUG "az6007: I2C W/R addr=0x%x len=%d/%d\n",
 				       addr, msgs[i].len, msgs[i + 1].len);
 			req = AZ6007_I2C_RD;
 			index = msgs[i].buf[0];
@@ -729,42 +726,29 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			ret = __az6007_read(d->udev, req, value, index,
 					    st->data, length);
 			if (ret >= len) {
-				for (j = 0; j < len; j++) {
+				for (j = 0; j < len; j++)
 					msgs[i + 1].buf[j] = st->data[j + 5];
-					if (dvb_usb_az6007_debug & 2)
-						printk(KERN_CONT
-						       "0x%02x ",
-						       msgs[i + 1].buf[j]);
-				}
 			} else
 				ret = -EIO;
 			i++;
 		} else if (!(msgs[i].flags & I2C_M_RD)) {
 			/* write bytes */
-			if (dvb_usb_az6007_debug & 2)
-				printk(KERN_DEBUG
-				       "az6007 I2C xfer write addr=0x%x len=%d: ",
+			if (az6007_xfer_debug)
+				printk(KERN_DEBUG "az6007: I2C W addr=0x%x len=%d\n",
 				       addr, msgs[i].len);
 			req = AZ6007_I2C_WR;
 			index = msgs[i].buf[0];
 			value = addr | (1 << 8);
 			length = msgs[i].len - 1;
 			len = msgs[i].len - 1;
-			if (dvb_usb_az6007_debug & 2)
-				printk(KERN_CONT "(0x%02x) ", msgs[i].buf[0]);
-			for (j = 0; j < len; j++) {
+			for (j = 0; j < len; j++)
 				st->data[j] = msgs[i].buf[j + 1];
-				if (dvb_usb_az6007_debug & 2)
-					printk(KERN_CONT "0x%02x ",
-					       st->data[j]);
-			}
 			ret =  __az6007_write(d->udev, req, value, index,
 					      st->data, length);
 		} else {
 			/* read bytes */
-			if (dvb_usb_az6007_debug & 2)
-				printk(KERN_DEBUG
-				       "az6007 I2C xfer read addr=0x%x len=%d: ",
+			if (az6007_xfer_debug)
+				printk(KERN_DEBUG "az6007: I2C R addr=0x%x len=%d\n",
 				       addr, msgs[i].len);
 			req = AZ6007_I2C_RD;
 			index = msgs[i].buf[0];
@@ -773,15 +757,9 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			len = msgs[i].len;
 			ret = __az6007_read(d->udev, req, value, index,
 					    st->data, length);
-			for (j = 0; j < len; j++) {
+			for (j = 0; j < len; j++)
 				msgs[i].buf[j] = st->data[j + 5];
-				if (dvb_usb_az6007_debug & 2)
-					printk(KERN_CONT
-					       "0x%02x ", st->data[j + 5]);
-			}
 		}
-		if (dvb_usb_az6007_debug & 2)
-			printk(KERN_CONT "\n");
 		if (ret < 0)
 			goto err;
 	}
@@ -789,7 +767,7 @@ err:
 	mutex_unlock(&st->mutex);
 
 	if (ret < 0) {
-		info("%s ERROR: %i", __func__, ret);
+		pr_info("%s ERROR: %i\n", __func__, ret);
 		return ret;
 	}
 	return num;
@@ -805,151 +783,115 @@ static struct i2c_algorithm az6007_i2c_algo = {
 	.functionality = az6007_i2c_func,
 };
 
-int az6007_identify_state(struct usb_device *udev,
-			  struct dvb_usb_device_properties *props,
-			  struct dvb_usb_device_description **desc, int *cold)
+int az6007_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	int ret;
 	u8 *mac;
 
+	pr_debug("Identifying az6007 state\n");
+
 	mac = kmalloc(6, GFP_ATOMIC);
 	if (!mac)
 		return -ENOMEM;
 
 	/* Try to read the mac address */
-	ret = __az6007_read(udev, AZ6007_READ_DATA, 6, 0, mac, 6);
+	ret = __az6007_read(d->udev, AZ6007_READ_DATA, 6, 0, mac, 6);
 	if (ret == 6)
-		*cold = 0;
+		ret = WARM;
 	else
-		*cold = 1;
+		ret = COLD;
 
 	kfree(mac);
 
-	if (*cold) {
-		__az6007_write(udev, 0x09, 1, 0, NULL, 0);
-		__az6007_write(udev, 0x00, 0, 0, NULL, 0);
-		__az6007_write(udev, 0x00, 0, 0, NULL, 0);
+	if (ret == COLD) {
+		__az6007_write(d->udev, 0x09, 1, 0, NULL, 0);
+		__az6007_write(d->udev, 0x00, 0, 0, NULL, 0);
+		__az6007_write(d->udev, 0x00, 0, 0, NULL, 0);
 	}
 
-	deb_info("Device is on %s state\n", *cold ? "warm" : "cold");
-	return 0;
+	pr_debug("Device is on %s state\n",
+		 ret == WARM ? "warm" : "cold");
+	return ret;
 }
 
-static struct dvb_usb_device_properties az6007_properties;
-
 static void az6007_usb_disconnect(struct usb_interface *intf)
 {
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
 	az6007_ci_uninit(d);
-	dvb_usb_device_exit(intf);
+	dvb_usbv2_disconnect(intf);
 }
 
-static int az6007_usb_probe(struct usb_interface *intf,
-			    const struct usb_device_id *id)
+static int az6007_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 {
-	return dvb_usb_device_init(intf, &az6007_properties,
-				   THIS_MODULE, NULL, adapter_nr);
+	pr_debug("Getting az6007 Remote Control properties\n");
+
+	rc->allowed_protos = RC_TYPE_NEC;
+	rc->query          = az6007_rc_query;
+	rc->interval       = 400;
+
+	return 0;
 }
 
-static struct usb_device_id az6007_usb_table[] = {
-	{USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_6007)},
-	{USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7)},
-	{USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7_2)},
-	{0},
-};
+static int az6007_download_firmware(struct dvb_usb_device *d,
+	const struct firmware *fw)
+{
+	pr_debug("Loading az6007 firmware\n");
 
-MODULE_DEVICE_TABLE(usb, az6007_usb_table);
+	return usbv2_cypress_load_firmware(d->udev, fw, CYPRESS_FX2);
+}
 
-static struct dvb_usb_device_properties az6007_properties = {
-	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
-	.usb_ctrl = CYPRESS_FX2,
-	.firmware            = "dvb-usb-terratec-h7-az6007.fw",
-	.no_reconnect        = 1,
+/* DVB USB Driver stuff */
+static struct dvb_usb_device_properties az6007_props = {
+	.driver_name         = KBUILD_MODNAME,
+	.owner               = THIS_MODULE,
+	.firmware            = AZ6007_FIRMWARE,
+
+	.adapter_nr          = adapter_nr,
 	.size_of_priv        = sizeof(struct az6007_device_state),
+	.i2c_algo            = &az6007_i2c_algo,
+	.tuner_attach        = az6007_tuner_attach,
+	.frontend_attach     = az6007_frontend_attach,
+	.streaming_ctrl      = az6007_streaming_ctrl,
+	.get_rc_config       = az6007_get_rc_config,
+	.read_mac_address    = az6007_read_mac_addr,
+	.download_firmware   = az6007_download_firmware,
 	.identify_state	     = az6007_identify_state,
-	.num_adapters = 1,
-	.adapter = {
-		{
-		.num_frontends = 1,
-		.fe = {{
-			.streaming_ctrl   = az6007_streaming_ctrl,
-			.tuner_attach     = az6007_tuner_attach,
-			.frontend_attach  = az6007_frontend_attach,
-
-			/* parameter for the MPEG2-data transfer */
-			.stream = {
-				.type = USB_BULK,
-				.count = 10,
-				.endpoint = 0x02,
-				.u = {
-					.bulk = {
-						.buffersize = 4096,
-					}
-				}
-			},
-		} }
-	} },
-	.power_ctrl       = az6007_power_ctrl,
-	.read_mac_address = az6007_read_mac_addr,
-
-	.rc.core = {
-		.rc_interval      = 400,
-		.rc_codes         = RC_MAP_NEC_TERRATEC_CINERGY_XS,
-		.module_name	  = "az6007",
-		.rc_query         = az6007_rc_query,
-		.allowed_protos   = RC_TYPE_NEC,
-	},
-	.i2c_algo         = &az6007_i2c_algo,
-
-	.num_device_descs = 2,
-	.devices = {
-		{ .name = "AzureWave DTV StarBox DVB-T/C USB2.0 (az6007)",
-		  .cold_ids = { &az6007_usb_table[0], NULL },
-		  .warm_ids = { NULL },
-		},
-		{ .name = "TerraTec DTV StarBox DVB-T/C USB2.0 (az6007)",
-		  .cold_ids = { &az6007_usb_table[1], &az6007_usb_table[2], NULL },
-		  .warm_ids = { NULL },
-		},
-		{ NULL },
+	.power_ctrl          = az6007_power_ctrl,
+	.num_adapters        = 1,
+	.adapter             = {
+		{ .stream = DVB_USB_STREAM_BULK(0x02, 10, 4096), }
 	}
 };
 
+static struct usb_device_id az6007_usb_table[] = {
+	{DVB_USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_6007,
+		&az6007_props, "Azurewave 6007", RC_MAP_EMPTY)},
+	{DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7,
+		&az6007_props, "Terratec H7", RC_MAP_NEC_TERRATEC_CINERGY_XS)},
+	{DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7_2,
+		&az6007_props, "Terratec H7", RC_MAP_NEC_TERRATEC_CINERGY_XS)},
+	{0},
+};
+
+MODULE_DEVICE_TABLE(usb, az6007_usb_table);
+
 /* usb specific object needed to register this driver with the usb subsystem */
 static struct usb_driver az6007_usb_driver = {
-	.name		= "dvb_usb_az6007",
-	.probe		= az6007_usb_probe,
-	.disconnect	= az6007_usb_disconnect,
+	.name		= KBUILD_MODNAME,
 	.id_table	= az6007_usb_table,
+	.probe		= dvb_usbv2_probe,
+	.disconnect	= az6007_usb_disconnect,
+	.suspend	= dvb_usbv2_suspend,
+	.resume		= dvb_usbv2_resume,
+	.no_dynamic_id	= 1,
+	.soft_unbind	= 1,
 };
 
-/* module stuff */
-static int __init az6007_usb_module_init(void)
-{
-	int result;
-	deb_info("az6007 usb module init\n");
-
-	result = usb_register(&az6007_usb_driver);
-	if (result) {
-		err("usb_register failed. (%d)", result);
-		return result;
-	}
-
-	return 0;
-}
-
-static void __exit az6007_usb_module_exit(void)
-{
-	/* deregister this driver from the USB subsystem */
-	deb_info("az6007 usb module exit\n");
-	usb_deregister(&az6007_usb_driver);
-}
-
-module_init(az6007_usb_module_init);
-module_exit(az6007_usb_module_exit);
+module_usb_driver(az6007_usb_driver);
 
 MODULE_AUTHOR("Henry Wang <Henry.wang@AzureWave.com>");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
 MODULE_DESCRIPTION("Driver for AzureWave 6007 DVB-C/T USB2.0 and clones");
-MODULE_VERSION("1.1");
+MODULE_VERSION("2.0");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(AZ6007_FIRMWARE);
diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 67b91b7..29bba9a 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -296,14 +296,6 @@ config DVB_USB_FRIIO
 	help
 	  Say Y here to support the Japanese DTV receiver Friio.
 
-config DVB_USB_AZ6007
-	tristate "AzureWave 6007 and clones DVB-T/C USB2.0 support"
-	depends on DVB_USB
-	select DVB_DRXK if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_MT2063 if !DVB_FE_CUSTOMISE
-	help
-	  Say Y here to support theAfatech AF9005 based DVB-T/DVB-C receivers.
-
 config DVB_USB_AZ6027
 	tristate "Azurewave DVB-S/S2 USB2.0 AZ6027 support"
 	depends on DVB_USB
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 29fa0f0..8059075 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -69,9 +69,6 @@ obj-$(CONFIG_DVB_USB_CINERGY_T2) += dvb-usb-cinergyT2.o
 dvb-usb-friio-objs = friio.o friio-fe.o
 obj-$(CONFIG_DVB_USB_FRIIO) += dvb-usb-friio.o
 
-dvb-usb-az6007-objs = az6007.o
-obj-$(CONFIG_DVB_USB_AZ6007) += dvb-usb-az6007.o
-
 dvb-usb-az6027-objs = az6027.o
 obj-$(CONFIG_DVB_USB_AZ6027) += dvb-usb-az6027.o
 
-- 
1.7.11.2

