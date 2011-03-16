Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1CPUQl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 16:16:41 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2GKGfLk023918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 16:16:41 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/2] hdpvr: i2c master enhancements
Date: Wed, 16 Mar 2011 16:16:34 -0400
Message-Id: <1300306595-19098-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Make the hdpvr's i2c master implementation more closely mirror that of
the pvrusb2 driver. Currently makes no significant difference in IR
reception behavior with ir-kbd-i2c (i.e., it still sucks).

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/video/hdpvr/hdpvr-i2c.c |   67 ++++++++++++++++++++++++--------
 1 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
index e53fa55..3e06587 100644
--- a/drivers/media/video/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
@@ -62,15 +62,25 @@ struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev)
 }
 
 static int hdpvr_i2c_read(struct hdpvr_device *dev, int bus,
-			  unsigned char addr, char *data, int len)
+			  unsigned char addr, char *wdata, int wlen,
+			  char *data, int len)
 {
 	int ret;
 
-	if (len > sizeof(dev->i2c_buf))
+	if ((len > sizeof(dev->i2c_buf)) || (wlen > sizeof(dev->i2c_buf)))
 		return -EINVAL;
 
-	ret = usb_control_msg(dev->udev,
-			      usb_rcvctrlpipe(dev->udev, 0),
+	if (wlen) {
+		memcpy(&dev->i2c_buf, wdata, wlen);
+		ret = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
+				      REQTYPE_I2C_WRITE, CTRL_WRITE_REQUEST,
+				      (bus << 8) | addr, 0, &dev->i2c_buf,
+				      wlen, 1000);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
 			      REQTYPE_I2C_READ, CTRL_READ_REQUEST,
 			      (bus << 8) | addr, 0, &dev->i2c_buf, len, 1000);
 
@@ -92,16 +102,14 @@ static int hdpvr_i2c_write(struct hdpvr_device *dev, int bus,
 		return -EINVAL;
 
 	memcpy(&dev->i2c_buf, data, len);
-	ret = usb_control_msg(dev->udev,
-			      usb_sndctrlpipe(dev->udev, 0),
+	ret = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
 			      REQTYPE_I2C_WRITE, CTRL_WRITE_REQUEST,
 			      (bus << 8) | addr, 0, &dev->i2c_buf, len, 1000);
 
 	if (ret < 0)
 		return ret;
 
-	ret = usb_control_msg(dev->udev,
-			      usb_rcvctrlpipe(dev->udev, 0),
+	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
 			      REQTYPE_I2C_WRITE_STATT, CTRL_READ_REQUEST,
 			      0, 0, &dev->i2c_buf, 2, 1000);
 
@@ -117,24 +125,49 @@ static int hdpvr_transfer(struct i2c_adapter *i2c_adapter, struct i2c_msg *msgs,
 			  int num)
 {
 	struct hdpvr_device *dev = i2c_get_adapdata(i2c_adapter);
-	int retval = 0, i, addr;
+	int retval = 0, addr;
 
 	if (num <= 0)
 		return 0;
 
 	mutex_lock(&dev->i2c_mutex);
 
-	for (i = 0; i < num && !retval; i++) {
-		addr = msgs[i].addr << 1;
+	addr = msgs[0].addr << 1;
 
-		if (msgs[i].flags & I2C_M_RD)
-			retval = hdpvr_i2c_read(dev, 1, addr, msgs[i].buf,
-						msgs[i].len);
+	if (num == 1) {
+		if (msgs[0].flags & I2C_M_RD)
+			retval = hdpvr_i2c_read(dev, 1, addr, NULL, 0,
+						msgs[0].buf, msgs[0].len);
 		else
-			retval = hdpvr_i2c_write(dev, 1, addr, msgs[i].buf,
-						 msgs[i].len);
+			retval = hdpvr_i2c_write(dev, 1, addr, msgs[0].buf,
+						 msgs[0].len);
+	} else if (num == 2) {
+		if (msgs[0].addr != msgs[1].addr) {
+			v4l2_warn(&dev->v4l2_dev, "refusing 2-phase i2c xfer "
+				  "with conflicting target addresses\n");
+			retval = -EINVAL;
+			goto out;
+		}
+
+		if ((msgs[0].flags & I2C_M_RD) || !(msgs[1].flags & I2C_M_RD)) {
+			v4l2_warn(&dev->v4l2_dev, "refusing complex xfer with "
+				  "r0=%d, r1=%d\n", msgs[0].flags & I2C_M_RD,
+				  msgs[1].flags & I2C_M_RD);
+			retval = -EINVAL;
+			goto out;
+		}
+
+		/*
+		 * Write followed by atomic read is the only complex xfer that
+		 * we actually support here.
+		 */
+		retval = hdpvr_i2c_read(dev, 1, addr, msgs[0].buf, msgs[0].len,
+					msgs[1].buf, msgs[1].len);
+	} else {
+		v4l2_warn(&dev->v4l2_dev, "refusing %d-phase i2c xfer\n", num);
 	}
 
+out:
 	mutex_unlock(&dev->i2c_mutex);
 
 	return retval ? retval : num;
@@ -162,7 +195,7 @@ static int hdpvr_activate_ir(struct hdpvr_device *dev)
 
 	mutex_lock(&dev->i2c_mutex);
 
-	hdpvr_i2c_read(dev, 0, 0x54, buffer, 1);
+	hdpvr_i2c_read(dev, 0, 0x54, NULL, 0, buffer, 1);
 
 	buffer[0] = 0;
 	buffer[1] = 0x8;
-- 
1.7.1

