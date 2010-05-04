Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56685 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab0EDMOl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 08:14:41 -0400
Date: Tue, 4 May 2010 14:14:29 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Adams.xu@azwave.com.cn, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch -next 1/2] media/az6027: doing dma on the stack
Message-ID: <20100504121429.GW29093@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I changed the dma buffers to use allocated memory instead of stack
memory.

The reason for this is documented in Documentation/DMA-API-HOWTO.txt
under the section:  "What memory is DMA'able?"  That document was only
added a couple weeks ago and there are still lots of modules which
haven't been corrected yet.  Btw. Smatch includes a pretty good test to
find places which use stack memory as a dma buffer.  That's how I found
these.  (http://smatch.sf.net).

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index 8934788..baaa301 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -417,11 +417,15 @@ static int az6027_ci_read_attribute_mem(struct dvb_ca_en50221 *ca,
 	u16 value;
 	u16 index;
 	int blen;
-	u8 b[12];
+	u8 *b;
 
 	if (slot != 0)
 		return -EINVAL;
 
+	b = kmalloc(12, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
 	mutex_lock(&state->ca_mutex);
 
 	req = 0xC1;
@@ -438,6 +442,7 @@ static int az6027_ci_read_attribute_mem(struct dvb_ca_en50221 *ca,
 	}
 
 	mutex_unlock(&state->ca_mutex);
+	kfree(b);
 	return ret;
 }
 
@@ -485,11 +490,15 @@ static int az6027_ci_read_cam_control(struct dvb_ca_en50221 *ca,
 	u16 value;
 	u16 index;
 	int blen;
-	u8 b[12];
+	u8 *b;
 
 	if (slot != 0)
 		return -EINVAL;
 
+	b = kmalloc(12, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
 	mutex_lock(&state->ca_mutex);
 
 	req = 0xC3;
@@ -510,6 +519,7 @@ static int az6027_ci_read_cam_control(struct dvb_ca_en50221 *ca,
 	}
 
 	mutex_unlock(&state->ca_mutex);
+	kfree(b);
 	return ret;
 }
 
@@ -556,7 +566,11 @@ static int CI_CamReady(struct dvb_ca_en50221 *ca, int slot)
 	u16 value;
 	u16 index;
 	int blen;
-	u8 b[12];
+	u8 *b;
+
+	b = kmalloc(12, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
 
 	req = 0xC8;
 	value = 0;
@@ -570,6 +584,7 @@ static int CI_CamReady(struct dvb_ca_en50221 *ca, int slot)
 	} else{
 		ret = b[0];
 	}
+	kfree(b);
 	return ret;
 }
 
@@ -667,8 +682,11 @@ static int az6027_ci_poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int o
 	u16 value;
 	u16 index;
 	int blen;
-	u8 b[12];
+	u8 *b;
 
+	b = kmalloc(12, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
 	mutex_lock(&state->ca_mutex);
 
 	req = 0xC5;
@@ -692,6 +710,7 @@ static int az6027_ci_poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int o
 	}
 
 	mutex_unlock(&state->ca_mutex);
+	kfree(b);
 	return ret;
 }
 
@@ -943,10 +962,16 @@ static int az6027_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int n
 	u16 value;
 	int length;
 	u8 req;
-	u8 data[256];
+	u8 *data;
+
+	data = kmalloc(256, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0) {
+		kfree(data);
 		return -EAGAIN;
+	}
 
 	if (num > 2)
 		warn("more than 2 i2c messages at a time is not handled yet. TODO.");
@@ -1016,6 +1041,7 @@ static int az6027_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int n
 		}
 	}
 	mutex_unlock(&d->i2c_mutex);
+	kfree(data);
 
 	return i;
 }
@@ -1036,8 +1062,14 @@ int az6027_identify_state(struct usb_device *udev,
 			  struct dvb_usb_device_description **desc,
 			  int *cold)
 {
-	u8 b[16];
-	s16 ret = usb_control_msg(udev,
+	u8 *b;
+	s16 ret;
+
+	b = kmalloc(16, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	ret = usb_control_msg(udev,
 				  usb_rcvctrlpipe(udev, 0),
 				  0xb7,
 				  USB_TYPE_VENDOR | USB_DIR_IN,
@@ -1048,7 +1080,7 @@ int az6027_identify_state(struct usb_device *udev,
 				  USB_CTRL_GET_TIMEOUT);
 
 	*cold = ret <= 0;
-
+	kfree(b);
 	deb_info("cold: %d\n", *cold);
 	return 0;
 }
