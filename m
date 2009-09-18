Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway10.websitewelcome.com ([67.18.1.14]:50984 "HELO
	gateway10.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752370AbZIRTXa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 15:23:30 -0400
Received: from [66.15.212.169] (port=30681 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1Moi7F-0002l0-2v
	for linux-media@vger.kernel.org; Fri, 18 Sep 2009 13:23:29 -0500
Subject: [PATCH 7/9] s2250-board: Implement brightness and contrast controls
From: Pete <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:23:33 -0700
Message-Id: <1253298213.4314.571.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The brightness and contrast controls were added to the Sensoray 2250 device.
A read register function was added to set the correct bit fields.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r bf8ee230f1a0 -r beaab56c3599 linux/drivers/staging/go7007/s2250-board.c
--- a/linux/drivers/staging/go7007/s2250-board.c	Fri Sep 18 10:39:03 2009 -0700
+++ b/linux/drivers/staging/go7007/s2250-board.c	Fri Sep 18 10:40:54 2009 -0700
@@ -112,7 +112,7 @@
 };
 
 struct s2250 {
-	int std;
+	v4l2_std_id std;
 	int input;
 	int brightness;
 	int contrast;
@@ -240,6 +240,45 @@
 	return 0;
 }
 
+static int read_reg_fp(struct i2c_client *client, u16 addr, u16 *val)
+{
+	struct go7007 *go = i2c_get_adapdata(client->adapter);
+	struct go7007_usb *usb;
+	u8 *buf;
+
+	if (go == NULL)
+		return -ENODEV;
+
+	if (go->status == STATUS_SHUTDOWN)
+		return -EBUSY;
+
+	buf = kzalloc(16, GFP_KERNEL);
+
+	if (buf == NULL)
+		return -ENOMEM;
+
+
+
+	memset(buf, 0xcd, 6);
+	usb = go->hpi_context;
+	if (down_interruptible(&usb->i2c_lock) != 0) {
+		printk(KERN_INFO "i2c lock failed\n");
+		kfree(buf);
+		return -EINTR;
+	}
+	if (go7007_usb_vendor_request(go, 0x58, addr, 0, buf, 16, 1) < 0) {
+		kfree(buf);
+		return -EFAULT;
+	}
+	up(&usb->i2c_lock);
+
+	*val = (buf[0] << 8) | buf[1];
+	kfree(buf);
+
+	return 0;
+}
+
+
 static int write_regs(struct i2c_client *client, u8 *regs)
 {
 	int i;
@@ -354,14 +393,42 @@
 	{
 		struct v4l2_control *ctrl = arg;
 		int value1;
+		u16 oldvalue;
 
 		switch (ctrl->id) {
 		case V4L2_CID_BRIGHTNESS:
-			printk(KERN_INFO "s2250: future setting\n");
-			return -EINVAL;
+			if (ctrl->value > 100)
+				dec->brightness = 100;
+			else if (ctrl->value < 0)
+				dec->brightness = 0;
+			else
+				dec->brightness = ctrl->value;
+			value1 = (dec->brightness - 50) * 255 / 100;
+			read_reg_fp(client, VPX322_ADDR_BRIGHTNESS0, &oldvalue);
+			write_reg_fp(client, VPX322_ADDR_BRIGHTNESS0,
+				     value1 | (oldvalue & ~0xff));
+			read_reg_fp(client, VPX322_ADDR_BRIGHTNESS1, &oldvalue);
+			write_reg_fp(client, VPX322_ADDR_BRIGHTNESS1,
+				     value1 | (oldvalue & ~0xff));
+			write_reg_fp(client, 0x140, 0x60);
+			break;
 		case V4L2_CID_CONTRAST:
-			printk(KERN_INFO "s2250: future setting\n");
-			return -EINVAL;
+			if (ctrl->value > 100)
+				dec->contrast = 100;
+			else if (ctrl->value < 0)
+				dec->contrast = 0;
+			else
+				dec->contrast = ctrl->value;
+			value1 = dec->contrast * 0x40 / 100;
+			if (value1 > 0x3f)
+				value1 = 0x3f; /* max */
+			read_reg_fp(client, VPX322_ADDR_CONTRAST0, &oldvalue);
+			write_reg_fp(client, VPX322_ADDR_CONTRAST0,
+				     value1 | (oldvalue & ~0x3f));
+			read_reg_fp(client, VPX322_ADDR_CONTRAST1, &oldvalue);
+			write_reg_fp(client, VPX322_ADDR_CONTRAST1,
+				     value1 | (oldvalue & ~0x3f));
+			write_reg_fp(client, 0x140, 0x60);
 			break;
 		case V4L2_CID_SATURATION:
 			if (ctrl->value > 127)


