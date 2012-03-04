Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm2.telefonica.net ([213.4.138.18]:30679 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754718Ab2CDX3Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2012 18:29:24 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Roger =?ISO-8859-1?Q?M=E5rtensson?= <roger.martensson@gmail.com>
Subject: [PATCH] Add CI support to az6007 driver
Date: Mon, 05 Mar 2012 00:22:05 +0100
Message-ID: <1577059.kW45pXQ20M@jar7.dominio>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart9380156.50rHb5ZLcn"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart9380156.50rHb5ZLcn
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

This patch add CI support to az6007 driver.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
--nextPart9380156.50rHb5ZLcn
Content-Disposition: attachment; filename="az6007-ci.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="az6007-ci.diff"

diff -urN linux/drivers/media/dvb/dvb-usb/az6007.c linux.new/drivers/media/dvb/dvb-usb/az6007.c
--- linux/drivers/media/dvb/dvb-usb/az6007.c	2012-01-22 02:53:17.000000000 +0100
+++ linux.new/drivers/media/dvb/dvb-usb/az6007.c	2012-02-11 00:32:35.534490502 +0100
@@ -54,6 +54,7 @@
 
 struct az6007_device_state {
 	struct mutex		mutex;
+	struct mutex		ca_mutex;
 	struct dvb_ca_en50221	ca;
 	unsigned		warm:1;
 	int			(*gate_ctrl) (struct dvb_frontend *, int);
@@ -218,6 +219,371 @@
 	return 0;
 }
 
+static int az6007_ci_read_attribute_mem(struct dvb_ca_en50221 *ca,
+					int slot,
+					int address)
+{
+	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
+	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+
+	int ret;
+	u8 req;
+	u16 value;
+	u16 index;
+	int blen;
+	u8 *b;
+
+	if (slot != 0)
+		return -EINVAL;
+
+	b = kmalloc(12, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	mutex_lock(&state->ca_mutex);
+
+	req = 0xC1;
+	value = address;
+	index = 0;
+	blen = 1;
+
+	ret = az6007_read(d, req, value, index, b, blen);
+	if (ret < 0) {
+		warn("usb in operation failed. (%d)", ret);
+		ret = -EINVAL;
+	} else {
+		ret = b[0];
+	}
+
+	mutex_unlock(&state->ca_mutex);
+	kfree(b);
+	return ret;
+}
+
+static int az6007_ci_write_attribute_mem(struct dvb_ca_en50221 *ca,
+					 int slot,
+					 int address,
+					 u8 value)
+{
+	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
+	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+
+	int ret;
+	u8 req;
+	u16 value1;
+	u16 index;
+	int blen;
+
+	deb_info("%s %d", __func__, slot);
+	if (slot != 0)
+		return -EINVAL;
+
+	mutex_lock(&state->ca_mutex);
+	req = 0xC2;
+	value1 = address;
+	index = value;
+	blen = 0;
+
+	ret = az6007_write(d, req, value1, index, NULL, blen);
+	if (ret != 0)
+		warn("usb out operation failed. (%d)", ret);
+
+	mutex_unlock(&state->ca_mutex);
+	return ret;
+}
+
+static int az6007_ci_read_cam_control(struct dvb_ca_en50221 *ca,
+				      int slot,
+				      u8 address)
+{
+	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
+	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+
+	int ret;
+	u8 req;
+	u16 value;
+	u16 index;
+	int blen;
+	u8 *b;
+
+	if (slot != 0)
+		return -EINVAL;
+
+	b = kmalloc(12, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	mutex_lock(&state->ca_mutex);
+
+	req = 0xC3;
+	value = address;
+	index = 0;
+	blen = 2;
+
+	ret = az6007_read(d, req, value, index, b, blen);
+	if (ret < 0) {
+		warn("usb in operation failed. (%d)", ret);
+		ret = -EINVAL;
+	} else {
+		if (b[0] == 0)
+			warn("Read CI IO error");
+
+		ret = b[1];
+		deb_info("read cam data = %x from 0x%x", b[1], value);
+	}
+
+	mutex_unlock(&state->ca_mutex);
+	kfree(b);
+	return ret;
+}
+
+static int az6007_ci_write_cam_control(struct dvb_ca_en50221 *ca,
+				       int slot,
+				       u8 address,
+				       u8 value)
+{
+	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
+	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+
+	int ret;
+	u8 req;
+	u16 value1;
+	u16 index;
+	int blen;
+
+	if (slot != 0)
+		return -EINVAL;
+
+	mutex_lock(&state->ca_mutex);
+	req = 0xC4;
+	value1 = address;
+	index = value;
+	blen = 0;
+
+	ret = az6007_write(d, req, value1, index, NULL, blen);
+	if (ret != 0) {
+		warn("usb out operation failed. (%d)", ret);
+		goto failed;
+	}
+
+failed:
+	mutex_unlock(&state->ca_mutex);
+	return ret;
+}
+
+static int CI_CamReady(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
+
+	int ret;
+	u8 req;
+	u16 value;
+	u16 index;
+	int blen;
+	u8 *b;
+
+	b = kmalloc(12, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	req = 0xC8;
+	value = 0;
+	index = 0;
+	blen = 1;
+
+	ret = az6007_read(d, req, value, index, b, blen);
+	if (ret < 0) {
+		warn("usb in operation failed. (%d)", ret);
+		ret = -EIO;
+	} else{
+		ret = b[0];
+	}
+	kfree(b);
+	return ret;
+}
+
+static int az6007_ci_slot_reset(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
+	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+
+	int ret, i;
+	u8 req;
+	u16 value;
+	u16 index;
+	int blen;
+
+	mutex_lock(&state->ca_mutex);
+
+	req = 0xC6;
+	value = 1;
+	index = 0;
+	blen = 0;
+
+	ret = az6007_write(d, req, value, index, NULL, blen);
+	if (ret != 0) {
+		warn("usb out operation failed. (%d)", ret);
+		goto failed;
+	}
+
+	msleep(500);
+	req = 0xC6;
+	value = 0;
+	index = 0;
+	blen = 0;
+
+	ret = az6007_write(d, req, value, index, NULL, blen);
+	if (ret != 0) {
+		warn("usb out operation failed. (%d)", ret);
+		goto failed;
+	}
+
+	for (i = 0; i < 15; i++) {
+		msleep(100);
+
+		if (CI_CamReady(ca, slot)) {
+			deb_info("CAM Ready");
+			break;
+		}
+	}
+	msleep(5000);
+
+failed:
+	mutex_unlock(&state->ca_mutex);
+	return ret;
+}
+
+static int az6007_ci_slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
+{
+	return 0;
+}
+
+static int az6007_ci_slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
+	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+
+	int ret;
+	u8 req;
+	u16 value;
+	u16 index;
+	int blen;
+
+	deb_info("%s", __func__);
+	mutex_lock(&state->ca_mutex);
+	req = 0xC7;
+	value = 1;
+	index = 0;
+	blen = 0;
+
+	ret = az6007_write(d, req, value, index, NULL, blen);
+	if (ret != 0) {
+		warn("usb out operation failed. (%d)", ret);
+		goto failed;
+	}
+
+failed:
+	mutex_unlock(&state->ca_mutex);
+	return ret;
+}
+
+static int az6007_ci_poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)
+{
+	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
+	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+	int ret;
+	u8 req;
+	u16 value;
+	u16 index;
+	int blen;
+	u8 *b;
+
+	b = kmalloc(12, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+	mutex_lock(&state->ca_mutex);
+
+	req = 0xC5;
+	value = 0;
+	index = 0;
+	blen = 1;
+
+	ret = az6007_read(d, req, value, index, b, blen);
+	if (ret < 0) {
+		warn("usb in operation failed. (%d)", ret);
+		ret = -EIO;
+	} else
+		ret = 0;
+
+	if (!ret && b[0] == 1) {
+		ret = DVB_CA_EN50221_POLL_CAM_PRESENT |
+		      DVB_CA_EN50221_POLL_CAM_READY;
+	}
+
+	mutex_unlock(&state->ca_mutex);
+	kfree(b);
+	return ret;
+}
+
+
+static void az6007_ci_uninit(struct dvb_usb_device *d)
+{
+	struct az6007_device_state *state;
+
+	deb_info("%s", __func__);
+
+	if (NULL == d)
+		return;
+
+	state = (struct az6007_device_state *)d->priv;
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
+
+static int az6007_ci_init(struct dvb_usb_adapter *a)
+{
+	struct dvb_usb_device *d = a->dev;
+	struct az6007_device_state *state = (struct az6007_device_state *)d->priv;
+	int ret;
+
+	deb_info("%s", __func__);
+
+	mutex_init(&state->ca_mutex);
+
+	state->ca.owner			= THIS_MODULE;
+	state->ca.read_attribute_mem	= az6007_ci_read_attribute_mem;
+	state->ca.write_attribute_mem	= az6007_ci_write_attribute_mem;
+	state->ca.read_cam_control	= az6007_ci_read_cam_control;
+	state->ca.write_cam_control	= az6007_ci_write_cam_control;
+	state->ca.slot_reset		= az6007_ci_slot_reset;
+	state->ca.slot_shutdown		= az6007_ci_slot_shutdown;
+	state->ca.slot_ts_enable	= az6007_ci_slot_ts_enable;
+	state->ca.poll_slot_status	= az6007_ci_poll_slot_status;
+	state->ca.data			= d;
+
+	ret = dvb_ca_en50221_init(&a->dvb_adap,
+				  &state->ca,
+				  0, /* flags */
+				  1);/* n_slots */
+	if (ret != 0) {
+		err("Cannot initialize CI: Error %d.", ret);
+		memset(&state->ca, 0, sizeof(state->ca));
+		return ret;
+	}
+
+	deb_info("CI initialized.");
+
+	return 0;
+}
+
 static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 {
 	struct az6007_device_state *st = d->priv;
@@ -249,6 +615,8 @@
 	st->gate_ctrl = adap->fe_adap[0].fe->ops.i2c_gate_ctrl;
 	adap->fe_adap[0].fe->ops.i2c_gate_ctrl = drxk_gate_ctrl;
 
+	az6007_ci_init(adap);
+
 	return 0;
 }
 
@@ -471,6 +839,13 @@
 
 static struct dvb_usb_device_properties az6007_properties;
 
+static void az6007_usb_disconnect(struct usb_interface *intf)
+{
+        struct dvb_usb_device *d = usb_get_intfdata(intf);
+        az6007_ci_uninit(d);
+        dvb_usb_device_exit(intf);
+}
+
 static int az6007_usb_probe(struct usb_interface *intf,
 			    const struct usb_device_id *id)
 {
@@ -545,7 +922,7 @@
 static struct usb_driver az6007_usb_driver = {
 	.name		= "dvb_usb_az6007",
 	.probe		= az6007_usb_probe,
-	.disconnect = dvb_usb_device_exit,
+	.disconnect	= az6007_usb_disconnect,
 	.id_table	= az6007_usb_table,
 };
 

--nextPart9380156.50rHb5ZLcn--

