Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32551 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964938AbcKPLMs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 06:12:48 -0500
Date: Wed, 16 Nov 2016 14:11:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] [media] stk-webcam: fix an endian bug in
 stk_camera_read_reg()
Message-ID: <20161116111154.GA27862@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115094808.GA15424@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We pass an int pointer to stk_camera_read_reg() but only write to the
highest byte.  It's a bug on big endian systems and generally a nasty
thing to do and doesn't match the write function either.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: I forgot to update stk-sensor.c in version 1.

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.h b/drivers/media/usb/stkwebcam/stk-webcam.h
index 9bbfa3d..92bb48e 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.h
+++ b/drivers/media/usb/stkwebcam/stk-webcam.h
@@ -129,7 +129,7 @@ struct stk_camera {
 #define vdev_to_camera(d) container_of(d, struct stk_camera, vdev)
 
 int stk_camera_write_reg(struct stk_camera *, u16, u8);
-int stk_camera_read_reg(struct stk_camera *, u16, int *);
+int stk_camera_read_reg(struct stk_camera *, u16, u8 *);
 
 int stk_sensor_init(struct stk_camera *);
 int stk_sensor_configure(struct stk_camera *);
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 22a9aae..1c48f2f 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -144,7 +144,7 @@ int stk_camera_write_reg(struct stk_camera *dev, u16 index, u8 value)
 		return 0;
 }
 
-int stk_camera_read_reg(struct stk_camera *dev, u16 index, int *value)
+int stk_camera_read_reg(struct stk_camera *dev, u16 index, u8 *value)
 {
 	struct usb_device *udev = dev->udev;
 	unsigned char *buf;
@@ -163,7 +163,7 @@ int stk_camera_read_reg(struct stk_camera *dev, u16 index, int *value)
 			sizeof(u8),
 			500);
 	if (ret >= 0)
-		memcpy(value, buf, sizeof(u8));
+		*value = *buf;
 
 	kfree(buf);
 	return ret;
@@ -171,9 +171,10 @@ int stk_camera_read_reg(struct stk_camera *dev, u16 index, int *value)
 
 static int stk_start_stream(struct stk_camera *dev)
 {
-	int value;
+	u8 value;
 	int i, ret;
-	int value_116, value_117;
+	u8 value_116, value_117;
+
 
 	if (!is_present(dev))
 		return -ENODEV;
@@ -213,7 +214,7 @@ static int stk_start_stream(struct stk_camera *dev)
 
 static int stk_stop_stream(struct stk_camera *dev)
 {
-	int value;
+	u8 value;
 	int i;
 	if (is_present(dev)) {
 		stk_camera_read_reg(dev, 0x0100, &value);
diff --git a/drivers/media/usb/stkwebcam/stk-sensor.c b/drivers/media/usb/stkwebcam/stk-sensor.c
index e546b01..2dcc8d0 100644
--- a/drivers/media/usb/stkwebcam/stk-sensor.c
+++ b/drivers/media/usb/stkwebcam/stk-sensor.c
@@ -228,7 +228,7 @@
 static int stk_sensor_outb(struct stk_camera *dev, u8 reg, u8 val)
 {
 	int i = 0;
-	int tmpval = 0;
+	u8 tmpval = 0;
 
 	if (stk_camera_write_reg(dev, STK_IIC_TX_INDEX, reg))
 		return 1;
@@ -253,7 +253,7 @@ static int stk_sensor_outb(struct stk_camera *dev, u8 reg, u8 val)
 static int stk_sensor_inb(struct stk_camera *dev, u8 reg, u8 *val)
 {
 	int i = 0;
-	int tmpval = 0;
+	u8 tmpval = 0;
 
 	if (stk_camera_write_reg(dev, STK_IIC_RX_INDEX, reg))
 		return 1;
@@ -274,7 +274,7 @@ static int stk_sensor_inb(struct stk_camera *dev, u8 reg, u8 *val)
 	if (stk_camera_read_reg(dev, STK_IIC_RX_VALUE, &tmpval))
 		return 1;
 
-	*val = (u8) tmpval;
+	*val = tmpval;
 	return 0;
 }
 
