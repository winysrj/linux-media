Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54144 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652Ab2BAW1u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 17:27:50 -0500
Received: by werb13 with SMTP id b13so1370700wer.19
        for <linux-media@vger.kernel.org>; Wed, 01 Feb 2012 14:27:49 -0800 (PST)
Message-ID: <1328135262.2552.18.camel@tvbox>
Subject: [PATCH 1/2] it913x v1.25 support different for remotes.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Wed, 01 Feb 2012 22:27:42 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for different types of remote.

ITE remotes share common device IDs with differently assigned keys.

Two versions of remote maps have been created there are likely to be more.
v1 for all other IDs
v2 for USB_PID_ITETECH_IT9135_9005.

This patch also separates the configuration parts from it913x_identify_state function.

TODO
remotes for HID interfaces.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |  104 ++++++++++++++++++++++++++++--------
 1 files changed, 82 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index c80098a..2560652 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -429,24 +429,74 @@ static int ite_firmware_select(struct usb_device *udev,
 	return 0;
 }
 
+static void it913x_select_remote(struct usb_device *udev,
+	struct dvb_usb_device_properties *props)
+{
+	switch (le16_to_cpu(udev->descriptor.idProduct)) {
+	case USB_PID_ITETECH_IT9135_9005:
+		props->rc.core.rc_codes = RC_MAP_IT913X_V2;
+		return;
+	default:
+		props->rc.core.rc_codes = RC_MAP_IT913X_V1;
+	}
+	return;
+}
+
 #define TS_MPEG_PKT_SIZE	188
 #define EP_LOW			21
 #define TS_BUFFER_SIZE_PID	(EP_LOW*TS_MPEG_PKT_SIZE)
 #define EP_HIGH			348
 #define TS_BUFFER_SIZE_MAX	(EP_HIGH*TS_MPEG_PKT_SIZE)
 
-static int it913x_identify_state(struct usb_device *udev,
-		struct dvb_usb_device_properties *props,
-		struct dvb_usb_device_description **desc,
-		int *cold)
+static int it913x_select_config(struct usb_device *udev,
+	struct dvb_usb_device_properties *props)
 {
-	int ret = 0, firm_no;
-	u8 reg, remote;
+	int ret = 0, reg;
+	bool proprietary_ir = false;
 
-	firm_no = it913x_return_status(udev);
+	if (it913x_config.chip_ver == 0x02
+			&& it913x_config.chip_type == 0x9135)
+		reg = it913x_read_reg(udev, 0x461d);
+	else
+		reg = it913x_read_reg(udev, 0x461b);
+
+	if (reg < 0)
+		return reg;
+
+	if (reg == 0) {
+		it913x_config.dual_mode = 0;
+		it913x_config.tuner_id_0 = IT9135_38;
+		proprietary_ir = true;
+	} else {
+		/* TS mode */
+		reg =  it913x_read_reg(udev, 0x49c5);
+		if (reg < 0)
+			return reg;
+		it913x_config.dual_mode = reg;
+
+		/* IR mode type */
+		reg = it913x_read_reg(udev, 0x49ac);
+		if (reg < 0)
+			return reg;
+		if (reg == 5) {
+			info("Remote propriety (raw) mode");
+			proprietary_ir = true;
+		} else if (reg == 1) {
+			info("Remote HID mode NOT SUPPORTED");
+			proprietary_ir = false;
+			props->rc.core.rc_codes = NULL;
+		} else
+			props->rc.core.rc_codes = NULL;
+
+		/* Tuner_id */
+		reg = it913x_read_reg(udev, 0x49d0);
+		if (reg < 0)
+			return reg;
+		it913x_config.tuner_id_0 = reg;
+	}
 
-	/* checnk for dual mode */
-	it913x_config.dual_mode =  it913x_read_reg(udev, 0x49c5);
+	if (proprietary_ir)
+		it913x_select_remote(udev, props);
 
 	if (udev->speed != USB_SPEED_HIGH) {
 		props->adapter[0].fe[0].pid_filter_count = 5;
@@ -461,17 +511,6 @@ static int it913x_identify_state(struct usb_device *udev,
 		if(props->adapter[0].fe[0].pid_filter_count == 5)
 			props->adapter[0].fe[0].pid_filter_count = 31;
 
-	/* TODO different remotes */
-	remote = it913x_read_reg(udev, 0x49ac); /* Remote */
-	if (remote == 0)
-		props->rc.core.rc_codes = NULL;
-
-	/* TODO at the moment tuner_id is always assigned to 0x38 */
-	it913x_config.tuner_id_0 = it913x_read_reg(udev, 0x49d0);
-
-	info("Dual mode=%x Remote=%x Tuner Type=%x", it913x_config.dual_mode
-		, remote, it913x_config.tuner_id_0);
-
 	/* Select Stream Buffer Size and pid filter option*/
 	if (pid_filter) {
 		props->adapter[0].fe[0].stream.u.bulk.buffersize =
@@ -492,8 +531,29 @@ static int it913x_identify_state(struct usb_device *udev,
 	} else
 		props->num_adapters = 1;
 
+	info("Dual mode=%x Tuner Type=%x", it913x_config.dual_mode,
+		it913x_config.tuner_id_0);
+
 	ret = ite_firmware_select(udev, props);
 
+	return ret;
+}
+
+static int it913x_identify_state(struct usb_device *udev,
+		struct dvb_usb_device_properties *props,
+		struct dvb_usb_device_description **desc,
+		int *cold)
+{
+	int ret = 0, firm_no;
+	u8 reg;
+
+	firm_no = it913x_return_status(udev);
+
+	/* Read and select config */
+	ret = it913x_select_config(udev, props);
+	if (ret < 0)
+		return ret;
+
 	if (firm_no > 0) {
 		*cold = 0;
 		return 0;
@@ -791,7 +851,7 @@ static struct dvb_usb_device_properties it913x_properties = {
 		.rc_query	= it913x_rc_query,
 		.rc_interval	= IT913X_POLL,
 		.allowed_protos	= RC_TYPE_NEC,
-		.rc_codes	= RC_MAP_MSI_DIGIVOX_III,
+		.rc_codes	= RC_MAP_IT913X_V1,
 	},
 	.i2c_algo         = &it913x_i2c_algo,
 	.num_device_descs = 5,
@@ -825,5 +885,5 @@ module_usb_driver(it913x_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.24");
+MODULE_VERSION("1.25");
 MODULE_LICENSE("GPL");
-- 
1.7.8.3




