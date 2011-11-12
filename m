Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58521 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1KLPzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:55:33 -0500
Received: by wyh15 with SMTP id 15so4693278wyh.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 07:55:32 -0800 (PST)
Message-ID: <4ebe96f4.6359b40a.5cac.3970@mx.google.com>
Subject: [PATCH 3/7] af9015/af9013 full pid filtering
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 12 Nov 2011 15:55:26 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allowing the pid to be enabled seems to suppress corrupted stream packets
from the first frontend.  This is mainly caused by other high speed devices
on the usb bus.

Full pid filtering on all frontends.
no_pid is defaulted to on.
TS frame size it limited to 21, this because if we are only filtering
pid 0000, it takes too long to fill up the buffer when tuning or
scanning.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/af9015.c |   82 ++++++++++++++++++++++++++++++------
 1 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index eb464c8..c9da2aa 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -41,6 +41,9 @@ static int dvb_usb_af9015_remote;
 module_param_named(remote, dvb_usb_af9015_remote, int, 0644);
 MODULE_PARM_DESC(remote, "select remote");
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+static int no_pid_filter;
+module_param_named(no_pid, no_pid_filter, int, 0644);
+MODULE_PARM_DESC(no_pid, "set default 0=on 1=off");
 
 static DEFINE_MUTEX(af9015_usb_mutex);
 
@@ -223,6 +226,25 @@ static int af9015_write_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
 	return af9015_ctrl_msg(d, &req);
 }
 
+static int af9015_write_fe(struct dvb_usb_device *d, u8 adap, u16 reg,
+	u8 val)
+{
+	int ret;
+	u8 addr1 = af9015_af9013_config[1].demod_address;
+
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
+	if (adap == 0)
+		ret = af9015_write_reg(d, reg, val);
+	else
+		ret = af9015_write_reg_i2c(d, addr1, reg, val);
+
+
+	mutex_unlock(&d->i2c_mutex);
+	return ret;
+}
+
 static int af9015_read_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
 	u8 *val)
 {
@@ -407,6 +429,9 @@ static int af9015_init_endpoint(struct dvb_usb_device *d)
 #define TS_USB20_PACKET_COUNT      87
 #define TS_USB20_FRAME_SIZE       (TS_PACKET_SIZE*TS_USB20_PACKET_COUNT)
 
+#define TS_PID_PACKET_COUNT	21
+#define TS_PID_FRAME_SIZE	(TS_PACKET_SIZE*TS_PID_PACKET_COUNT)
+
 #define TS_USB11_PACKET_COUNT       5
 #define TS_USB11_FRAME_SIZE       (TS_PACKET_SIZE*TS_USB11_PACKET_COUNT)
 
@@ -420,6 +445,8 @@ static int af9015_init_endpoint(struct dvb_usb_device *d)
 		frame_size = TS_USB20_FRAME_SIZE/4;
 		packet_size = TS_USB20_MAX_PACKET_SIZE/4;
 	}
+	if (!no_pid_filter)
+		frame_size = TS_PID_FRAME_SIZE/4;
 
 	ret = af9015_set_reg_bit(d, 0xd507, 2); /* assert EP4 reset */
 	if (ret)
@@ -635,9 +662,9 @@ static int af9015_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	deb_info("%s: onoff:%d\n", __func__, onoff);
 
 	if (onoff)
-		ret = af9015_set_reg_bit(adap->dev, 0xd503, 0);
+		ret = af9015_write_fe(adap->dev, adap->id, 0xd503, 0x1);
 	else
-		ret = af9015_clear_reg_bit(adap->dev, 0xd503, 0);
+		ret = af9015_write_fe(adap->dev, adap->id, 0xd503, 0x0);
 
 	return ret;
 }
@@ -651,16 +678,15 @@ static int af9015_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 	deb_info("%s: set pid filter, index %d, pid %x, onoff %d\n",
 		__func__, index, pid, onoff);
 
-	ret = af9015_write_reg(adap->dev, 0xd505, (pid & 0xff));
+	ret = af9015_write_fe(adap->dev, adap->id, 0xd505, (pid & 0xff));
 	if (ret)
 		goto error;
-
-	ret = af9015_write_reg(adap->dev, 0xd506, (pid >> 8));
+	ret = af9015_write_fe(adap->dev, adap->id, 0xd506, (pid >> 8));
 	if (ret)
 		goto error;
 
 	idx = ((index & 0x1f) | (1 << 5));
-	ret = af9015_write_reg(adap->dev, 0xd504, idx);
+	ret = af9015_write_fe(adap->dev, adap->id, 0xd504, idx);
 
 error:
 	return ret;
@@ -859,15 +885,20 @@ static int af9015_read_config(struct usb_device *udev,
 	/* Set adapter0 buffer size according to USB port speed, adapter1 buffer
 	   size can be static because it is enabled only USB2.0 */
 	/* USB1.1 set smaller buffersize and disable 2nd adapter */
-	if (udev->speed == USB_SPEED_FULL) {
-		props->adapter[0].fe[0].stream.u.bulk.buffersize
-			= TS_USB11_FRAME_SIZE;
+	for (i = 0; i < props->num_adapters; i++) {
+		if (udev->speed == USB_SPEED_FULL) {
+			props->adapter[i].fe[0].stream.u.bulk.buffersize
+				= TS_USB11_FRAME_SIZE;
 		/* disable 2nd adapter because we don't have
 			   PID-filters */
 		af9015_config.dual_mode = 0;
-	} else {
-		props->adapter[0].fe[0].stream.u.bulk.buffersize
-			= TS_USB20_FRAME_SIZE;
+		break;
+		} else if (!no_pid_filter)
+			props->adapter[i].fe[0].stream.u.bulk.buffersize
+				= TS_PID_FRAME_SIZE;
+		else
+			props->adapter[i].fe[0].stream.u.bulk.buffersize
+				= TS_USB20_FRAME_SIZE;
 	}
 
 	if (af9015_config.dual_mode) {
@@ -1001,7 +1032,7 @@ static int af9015_identify_state(struct usb_device *udev,
 				 struct dvb_usb_device_description **desc,
 				 int *cold)
 {
-	int ret;
+	int ret, i;
 	u8 reply;
 	struct req_t req = {GET_CONFIG, 0, 0, 0, 0, 1, &reply};
 
@@ -1019,6 +1050,12 @@ static int af9015_identify_state(struct usb_device *udev,
 	else
 		*cold = 1;
 
+	for (i = 0; i < props->num_adapters; i++) {
+		if (!no_pid_filter)
+			props->adapter[i].fe[0].caps |=
+				DVB_USB_ADAP_NEED_PID_FILTERING;
+	}
+
 	return ret;
 }
 
@@ -1324,6 +1361,12 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 			{
 			.num_frontends = 1,
 			.fe = {{
+				.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+				.pid_filter_count = 32,
+				.pid_filter       = af9015_pid_filter,
+				.pid_filter_ctrl  = af9015_pid_filter_ctrl,
 				.frontend_attach =
 					af9015_af9013_frontend_attach,
 				.tuner_attach    = af9015_tuner_attach,
@@ -1458,6 +1501,12 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 			{
 			.num_frontends = 1,
 			.fe = {{
+				.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+				.pid_filter_count = 32,
+				.pid_filter       = af9015_pid_filter,
+				.pid_filter_ctrl  = af9015_pid_filter_ctrl,
 				.frontend_attach =
 					af9015_af9013_frontend_attach,
 				.tuner_attach    = af9015_tuner_attach,
@@ -1581,6 +1630,13 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 			{
 			.num_frontends = 1,
 			.fe = {{
+				.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+				.pid_filter_count = 32,
+				.pid_filter       = af9015_pid_filter,
+				.pid_filter_ctrl  = af9015_pid_filter_ctrl,
+
 				.frontend_attach =
 					af9015_af9013_frontend_attach,
 				.tuner_attach    = af9015_tuner_attach,
-- 
1.7.5.4




