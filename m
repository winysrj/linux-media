Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1ANVJZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 16:09:25 -0500
Date: Fri, 14 Jan 2011 16:08:38 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>, Janne Grunau <j@jannau.net>,
	Jean Delvare <khali@linux-fr.org>
Subject: [PATCH v2] hdpvr: reduce latency of i2c read/write w/recycled buffer
Message-ID: <20110114210838.GE9849@redhat.com>
References: <20110114200109.GB9849@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114200109.GB9849@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The current hdpvr code kmalloc's a new buffer for every i2c read and
write. Rather than do that, lets allocate a buffer in the driver's
device struct and just use that every time.

The size I've chosen for the buffer is the maximum size I could
ascertain might be used by either ir-kbd-i2c or lirc_zilog, plus a bit
of padding (lirc_zilog may use up to 100 bytes on tx, rounded that up
to 128).

Note that this might also remedy user reports of very sluggish behavior
of IR receive with hdpvr hardware.

v2: make sure (len <= (dev->i2c_buf)) [Jean Delvare]

Reported-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---

Nb: This patch was done atop my prior patch 'hdpvr: enable IR part',
and serves no purpose if that patch isn't applied first.

 drivers/media/video/hdpvr/hdpvr-i2c.c |   30 +++++++++++++-----------------
 drivers/media/video/hdpvr/hdpvr.h     |    3 +++
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
index c0696c3..2adfe90 100644
--- a/drivers/media/video/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
@@ -57,23 +57,21 @@ static int hdpvr_i2c_read(struct hdpvr_device *dev, int bus,
 			  unsigned char addr, char *data, int len)
 {
 	int ret;
-	char *buf = kmalloc(len, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+
+	if (len > sizeof(dev->i2c_buf))
+		return -EINVAL;
 
 	ret = usb_control_msg(dev->udev,
 			      usb_rcvctrlpipe(dev->udev, 0),
 			      REQTYPE_I2C_READ, CTRL_READ_REQUEST,
-			      (bus << 8) | addr, 0, buf, len, 1000);
+			      (bus << 8) | addr, 0, &dev->i2c_buf, len, 1000);
 
 	if (ret == len) {
-		memcpy(data, buf, len);
+		memcpy(data, &dev->i2c_buf, len);
 		ret = 0;
 	} else if (ret >= 0)
 		ret = -EIO;
 
-	kfree(buf);
-
 	return ret;
 }
 
@@ -81,31 +79,29 @@ static int hdpvr_i2c_write(struct hdpvr_device *dev, int bus,
 			   unsigned char addr, char *data, int len)
 {
 	int ret;
-	char *buf = kmalloc(len, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
 
-	memcpy(buf, data, len);
+	if (len > sizeof(dev->i2c_buf))
+		return -EINVAL;
+
+	memcpy(&dev->i2c_buf, data, len);
 	ret = usb_control_msg(dev->udev,
 			      usb_sndctrlpipe(dev->udev, 0),
 			      REQTYPE_I2C_WRITE, CTRL_WRITE_REQUEST,
-			      (bus << 8) | addr, 0, buf, len, 1000);
+			      (bus << 8) | addr, 0, &dev->i2c_buf, len, 1000);
 
 	if (ret < 0)
-		goto error;
+		return ret;
 
 	ret = usb_control_msg(dev->udev,
 			      usb_rcvctrlpipe(dev->udev, 0),
 			      REQTYPE_I2C_WRITE_STATT, CTRL_READ_REQUEST,
-			      0, 0, buf, 2, 1000);
+			      0, 0, &dev->i2c_buf, 2, 1000);
 
-	if ((ret == 2) && (buf[1] == (len - 1)))
+	if ((ret == 2) && (dev->i2c_buf[1] == (len - 1)))
 		ret = 0;
 	else if (ret >= 0)
 		ret = -EIO;
 
-error:
-	kfree(buf);
 	return ret;
 }
 
diff --git a/drivers/media/video/hdpvr/hdpvr.h b/drivers/media/video/hdpvr/hdpvr.h
index 29f7426..ee74e3b 100644
--- a/drivers/media/video/hdpvr/hdpvr.h
+++ b/drivers/media/video/hdpvr/hdpvr.h
@@ -25,6 +25,7 @@
 	KERNEL_VERSION(HDPVR_MAJOR_VERSION, HDPVR_MINOR_VERSION, HDPVR_RELEASE)
 
 #define HDPVR_MAX 8
+#define HDPVR_I2C_MAX_SIZE 128
 
 /* Define these values to match your devices */
 #define HD_PVR_VENDOR_ID	0x2040
@@ -109,6 +110,8 @@ struct hdpvr_device {
 	struct i2c_adapter	i2c_adapter;
 	/* I2C lock */
 	struct mutex		i2c_mutex;
+	/* I2C message buffer space */
+	char			i2c_buf[HDPVR_I2C_MAX_SIZE];
 
 	/* For passing data to ir-kbd-i2c */
 	struct IR_i2c_init_data	ir_i2c_init_data;
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

