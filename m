Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm1.telefonica.net ([213.4.138.17]:18369 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429Ab1IRL7e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 07:59:34 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] TT CT-3650 CI support
Date: Sun, 18 Sep 2011 13:59:05 +0200
Cc: Martin Dauskardt <martin.dauskardt@gmx.de>
References: <201109010147.33030.jareguero@telefonica.net>
In-Reply-To: <201109010147.33030.jareguero@telefonica.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_K0ddOQ+TBXTqvMz"
Message-Id: <201109181359.06501.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_K0ddOQ+TBXTqvMz
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Jueves, 1 de Septiembre de 2011 01:47:32 Jose Alberto Reguero escribi=C3=
=B3:
> From:
>=20
> http://www.spinics.net/lists/linux-media/msg20440.html
>=20
> This patch add support for the CI of the TT CT-3650.
>=20
> Jose Alberto
>=20
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Second version with changes suggested by Mauro in:

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/208=
11

Jose Alberto

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

--Boundary-00=_K0ddOQ+TBXTqvMz
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ttusb2-ci-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ttusb2-ci-2.diff"

diff -ur linux/drivers/media/dvb/dvb-usb/ttusb2.c linux.new/drivers/media/dvb/dvb-usb/ttusb2.c
--- linux/drivers/media/dvb/dvb-usb/ttusb2.c	2011-08-28 05:45:24.000000000 +0200
+++ linux.new/drivers/media/dvb/dvb-usb/ttusb2.c	2011-09-18 02:06:00.211411451 +0200
@@ -33,16 +33,40 @@
 #include "tda10048.h"
 #include "tda827x.h"
 #include "lnbp21.h"
+/* CA */
+#include "dvb_ca_en50221.h"
 
 /* debug */
 static int dvb_usb_ttusb2_debug;
 #define deb_info(args...)   dprintk(dvb_usb_ttusb2_debug,0x01,args)
 module_param_named(debug,dvb_usb_ttusb2_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able))." DVB_USB_DEBUG_STATUS);
+static int dvb_usb_ttusb2_debug_ci;
+module_param_named(debug_ci,dvb_usb_ttusb2_debug_ci, int, 0644);
+MODULE_PARM_DESC(debug_ci, "set debugging ci." DVB_USB_DEBUG_STATUS);
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
+#define ci_dbg(format, arg...)                \
+do {                                          \
+	if (dvb_usb_ttusb2_debug_ci)                                    \
+		printk(KERN_DEBUG DVB_USB_LOG_PREFIX \
+			": %s " format "\n" , __func__, ## arg);       \
+} while (0)
+
+enum {
+	TT3650_CMD_CI_TEST = 0x40,
+	TT3650_CMD_CI_RD_CTRL,
+	TT3650_CMD_CI_WR_CTRL,
+	TT3650_CMD_CI_RD_ATTR,
+	TT3650_CMD_CI_WR_ATTR,
+	TT3650_CMD_CI_RESET,
+	TT3650_CMD_CI_SET_VIDEO_PORT
+};
+
 struct ttusb2_state {
+	struct dvb_ca_en50221 ca;
+	struct mutex ca_mutex;
 	u8 id;
 	u16 last_rc_key;
 };
@@ -79,6 +103,255 @@
 	return 0;
 }
 
+/* ci */
+static int tt3650_ci_msg(struct dvb_usb_device *d, u8 cmd, u8 *data, unsigned int write_len, unsigned int read_len)
+{
+	int ret;
+	u8 rx[60];/* (64 -4) */
+	ret = ttusb2_msg(d, cmd, data, write_len, rx, read_len);
+	if (!ret)
+		memcpy(data, rx, read_len);
+	return ret;
+}
+
+static int tt3650_ci_msg_locked(struct dvb_ca_en50221 *ca, u8 cmd, u8 *data, unsigned int write_len, unsigned int read_len)
+{
+	struct dvb_usb_device *d = ca->data;
+	struct ttusb2_state *state = d->priv;
+	int ret;
+
+	mutex_lock(&state->ca_mutex);
+	ret = tt3650_ci_msg(d, cmd, data, write_len, read_len);
+	mutex_unlock(&state->ca_mutex);
+
+	return ret;
+}
+
+static int tt3650_ci_read_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int address)
+{
+	u8 buf[3];
+	int ret = 0;
+
+	if (slot)
+		return -EINVAL;
+
+	buf[0] = (address >> 8) & 0x0F;
+	buf[1] = address;
+
+
+	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_RD_ATTR, buf, 2, 3);
+
+	ci_dbg("%04x -> %d 0x%02x", address, ret, buf[2]);
+
+	if (ret < 0)
+		return ret;
+
+	return buf[2];
+}
+
+static int tt3650_ci_write_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int address, u8 value)
+{
+	u8 buf[3];
+
+	ci_dbg("%d 0x%04x 0x%02x", slot, address, value);
+
+	if (slot)
+		return -EINVAL;
+
+	buf[0] = (address >> 8) & 0x0F;
+	buf[1] = address;
+	buf[2] = value;
+
+	return tt3650_ci_msg_locked(ca, TT3650_CMD_CI_WR_ATTR, buf, 3, 3);
+}
+
+static int tt3650_ci_read_cam_control(struct dvb_ca_en50221 *ca, int slot, u8 address)
+{
+	u8 buf[2];
+	int ret;
+
+	if (slot)
+		return -EINVAL;
+
+	buf[0] = address & 3;
+
+	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_RD_CTRL, buf, 1, 2);
+
+	ci_dbg("0x%02x -> %d 0x%02x", address, ret, buf[1]);
+
+	if (ret < 0)
+		return ret;
+
+	return buf[1];
+}
+
+static int tt3650_ci_write_cam_control(struct dvb_ca_en50221 *ca, int slot, u8 address, u8 value)
+{
+	u8 buf[2];
+
+	ci_dbg("%d 0x%02x 0x%02x", slot, address, value);
+
+	if (slot)
+		return -EINVAL;
+
+	buf[0] = address;
+	buf[1] = value;
+
+	return tt3650_ci_msg_locked(ca, TT3650_CMD_CI_WR_CTRL, buf, 2, 2);
+}
+
+static int tt3650_ci_set_video_port(struct dvb_ca_en50221 *ca, int slot, int enable)
+{
+	u8 buf[1];
+	int ret;
+
+	ci_dbg("%d %d", slot, enable);
+
+	if (slot)
+		return -EINVAL;
+
+	buf[0] = enable;
+
+	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_SET_VIDEO_PORT, buf, 1, 1);
+	if (ret < 0)
+		return ret;
+
+	if (enable != buf[0]) {
+		err("CI not %sabled.", enable ? "en" : "dis");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int tt3650_ci_slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
+{
+	return tt3650_ci_set_video_port(ca, slot, 0);
+}
+
+static int tt3650_ci_slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
+{
+	return tt3650_ci_set_video_port(ca, slot, 1);
+}
+
+static int tt3650_ci_slot_reset(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct dvb_usb_device *d = ca->data;
+	struct ttusb2_state *state = d->priv;
+	u8 buf[1];
+	int ret;
+
+	ci_dbg("%d", slot);
+
+	if (slot)
+		return -EINVAL;
+
+	buf[0] = 0;
+
+	mutex_lock(&state->ca_mutex);
+
+	ret = tt3650_ci_msg(d, TT3650_CMD_CI_RESET, buf, 1, 1);
+	if (ret)
+		goto failed;
+
+	msleep(500);
+
+	buf[0] = 1;
+
+	ret = tt3650_ci_msg(d, TT3650_CMD_CI_RESET, buf, 1, 1);
+	if (ret)
+		goto failed;
+
+	msleep(500);
+
+	buf[0] = 0; /* FTA */
+
+	ret = tt3650_ci_msg(d, TT3650_CMD_CI_SET_VIDEO_PORT, buf, 1, 1);
+
+	msleep(1100);
+
+ failed:
+	mutex_unlock(&state->ca_mutex);
+
+	return ret;
+}
+
+static int tt3650_ci_poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)
+{
+	u8 buf[1];
+	int ret;
+
+	if (slot)
+		return -EINVAL;
+
+	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_TEST, buf, 0, 1);
+	if (ret)
+		return ret;
+
+	if (1 == buf[0]) {
+		return DVB_CA_EN50221_POLL_CAM_PRESENT |
+			DVB_CA_EN50221_POLL_CAM_READY;
+	}
+	return 0;
+}
+
+static void tt3650_ci_uninit(struct dvb_usb_device *d)
+{
+	struct ttusb2_state *state;
+
+	ci_dbg("");
+
+	if (NULL == d)
+		return;
+
+	state = d->priv;
+	if (NULL == state)
+		return;
+
+	if (NULL == state->ca.data)
+		return;
+
+	dvb_ca_en50221_release(&state->ca);
+
+	memset(&state->ca, 0, sizeof(state->ca));
+}
+
+static int tt3650_ci_init(struct dvb_usb_adapter *a)
+{
+	struct dvb_usb_device *d = a->dev;
+	struct ttusb2_state *state = d->priv;
+	int ret;
+
+	ci_dbg("");
+
+	mutex_init(&state->ca_mutex);
+
+	state->ca.owner = THIS_MODULE;
+	state->ca.read_attribute_mem = tt3650_ci_read_attribute_mem;
+	state->ca.write_attribute_mem = tt3650_ci_write_attribute_mem;
+	state->ca.read_cam_control = tt3650_ci_read_cam_control;
+	state->ca.write_cam_control = tt3650_ci_write_cam_control;
+	state->ca.slot_reset = tt3650_ci_slot_reset;
+	state->ca.slot_shutdown = tt3650_ci_slot_shutdown;
+	state->ca.slot_ts_enable = tt3650_ci_slot_ts_enable;
+	state->ca.poll_slot_status = tt3650_ci_poll_slot_status;
+	state->ca.data = d;
+
+	ret = dvb_ca_en50221_init(&a->dvb_adap,
+				  &state->ca,
+				  /* flags */ 0,
+				  /* n_slots */ 1);
+	if (ret) {
+		err("Cannot initialize CI: Error %d.", ret);
+		memset(&state->ca, 0, sizeof(state->ca));
+		return ret;
+	}
+
+	info("CI initialized.");
+
+	return 0;
+}
+
 static int ttusb2_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
@@ -251,6 +524,7 @@
 			deb_info("TDA10023 attach failed\n");
 			return -ENODEV;
 		}
+		tt3650_ci_init(adap);
 	} else {
 		adap->fe[1] = dvb_attach(tda10048_attach,
 			&tda10048_config, &adap->dev->i2c_adap);
@@ -305,6 +579,14 @@
 static struct dvb_usb_device_properties ttusb2_properties_s2400;
 static struct dvb_usb_device_properties ttusb2_properties_ct3650;
 
+static void ttusb2_usb_disconnect(struct usb_interface *intf)
+{
+	struct dvb_usb_device *d = usb_get_intfdata(intf);
+
+	tt3650_ci_uninit(d);
+	dvb_usb_device_exit(intf);
+}
+
 static int ttusb2_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
@@ -486,7 +768,7 @@
 static struct usb_driver ttusb2_driver = {
 	.name		= "dvb_usb_ttusb2",
 	.probe		= ttusb2_probe,
-	.disconnect = dvb_usb_device_exit,
+	.disconnect	= ttusb2_usb_disconnect,
 	.id_table	= ttusb2_table,
 };
 

--Boundary-00=_K0ddOQ+TBXTqvMz--
