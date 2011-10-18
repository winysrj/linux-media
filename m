Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:53999 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab1JRJPu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 05:15:50 -0400
Date: Tue, 18 Oct 2011 11:12:13 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 7/14] staging/media/as102: checkpatch fixes
Message-Id: <20111018111213.0b4c0ec8.chmooreck@poczta.onet.pl>
In-Reply-To: <20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

Original source and comment:
# HG changeset patch
# User Devin Heitmueller <dheitmueller@kernellabs.com>
# Date 1267318867 18000
# Node ID 152825226bec049f947a844bea2c530fc9269ae5
# Parent  5916edd6739e9b8e02ff8a1e93161c4d23b50b3e
as102: checkpatch fixes

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Fix make checkpatch issues reported against as102_usb_drv.c.

Priority: normal

Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>

diff --git linux/drivers/staging/media/as102/as102_usb_drv.c linuxb/drivers/media/dvb/as102/as102_usb_drv.c
--- linux/drivers/staging/media/as102/as102_usb_drv.c
+++ linuxb/drivers/staging/media/as102/as102_usb_drv.c
@@ -1,6 +1,7 @@
 /*
  * Abilis Systems Single DVB-T Receiver
  * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -49,7 +50,7 @@
 	.id_table   =  as102_usb_id_table
 };
 
-struct file_operations as102_dev_fops = {
+static const struct file_operations as102_dev_fops = {
 	.owner   = THIS_MODULE,
 	.open    = as102_open,
 	.release = as102_release,
@@ -63,46 +64,48 @@
 
 static int as102_usb_xfer_cmd(struct as102_bus_adapter_t *bus_adap,
 			      unsigned char *send_buf, int send_buf_len,
-			      unsigned char *recv_buf, int recv_buf_len) {
-
+			      unsigned char *recv_buf, int recv_buf_len)
+{
 	int ret = 0;
 	ENTER();
 
-	if(send_buf != NULL) {
+	if (send_buf != NULL) {
 		ret = usb_control_msg(bus_adap->usb_dev,
 				      usb_sndctrlpipe(bus_adap->usb_dev, 0),
 				      AS102_USB_DEVICE_TX_CTRL_CMD,
-				      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+				      USB_DIR_OUT | USB_TYPE_VENDOR |
+				      USB_RECIP_DEVICE,
 				      bus_adap->cmd_xid, /* value */
 				      0, /* index */
 				      send_buf, send_buf_len,
 				      USB_CTRL_SET_TIMEOUT /* 200 */);
-		if(ret < 0) {
+		if (ret < 0) {
 			dprintk(debug, "usb_control_msg(send) failed, err %i\n",
 					ret);
 			return ret;
 		}
 
-		if(ret != send_buf_len) {
+		if (ret != send_buf_len) {
 			dprintk(debug, "only wrote %d of %d bytes\n",
 					ret, send_buf_len);
 			return -1;
 		}
 	}
 
-	if(recv_buf != NULL) {
+	if (recv_buf != NULL) {
 #ifdef TRACE
 		dprintk(debug, "want to read: %d bytes\n", recv_buf_len);
 #endif
 		ret = usb_control_msg(bus_adap->usb_dev,
 				      usb_rcvctrlpipe(bus_adap->usb_dev, 0),
 				      AS102_USB_DEVICE_RX_CTRL_CMD,
-				      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+				      USB_DIR_IN | USB_TYPE_VENDOR |
+				      USB_RECIP_DEVICE,
 				      bus_adap->cmd_xid, /* value */
 				      0, /* index */
 				      recv_buf, recv_buf_len,
 				      USB_CTRL_GET_TIMEOUT /* 200 */);
-		if(ret < 0) {
+		if (ret < 0) {
 			dprintk(debug, "usb_control_msg(recv) failed, err %i\n",
 					ret);
 			return ret;
@@ -119,18 +122,19 @@
 static int as102_send_ep1(struct as102_bus_adapter_t *bus_adap,
 			  unsigned char *send_buf,
 			  int send_buf_len,
-			  int swap32) {
-
+			  int swap32)
+{
 	int ret = 0, actual_len;
 
-	ret = usb_bulk_msg(bus_adap->usb_dev, usb_sndbulkpipe(bus_adap->usb_dev, 1),
+	ret = usb_bulk_msg(bus_adap->usb_dev,
+			   usb_sndbulkpipe(bus_adap->usb_dev, 1),
 			   send_buf, send_buf_len, &actual_len, 200);
-	if(ret) {
+	if (ret) {
 		dprintk(debug, "usb_bulk_msg(send) failed, err %i\n", ret);
 		return ret;
 	}
 
-	if(actual_len != send_buf_len) {
+	if (actual_len != send_buf_len) {
 		dprintk(debug, "only wrote %d of %d bytes\n",
 				actual_len, send_buf_len);
 		return -1;
@@ -139,21 +143,22 @@
 }
 
 static int as102_read_ep2(struct as102_bus_adapter_t *bus_adap,
-		   unsigned char *recv_buf, int recv_buf_len) {
-
+		   unsigned char *recv_buf, int recv_buf_len)
+{
 	int ret = 0, actual_len;
 
-	if(recv_buf == NULL)
+	if (recv_buf == NULL)
 		return -EINVAL;
 
-	ret = usb_bulk_msg(bus_adap->usb_dev, usb_rcvbulkpipe(bus_adap->usb_dev, 2),
+	ret = usb_bulk_msg(bus_adap->usb_dev,
+			   usb_rcvbulkpipe(bus_adap->usb_dev, 2),
 			   recv_buf, recv_buf_len, &actual_len, 200);
-	if(ret) {
+	if (ret) {
 		dprintk(debug, "usb_bulk_msg(recv) failed, err %i\n", ret);
 		return ret;
 	}
 
-	if(actual_len != recv_buf_len) {
+	if (actual_len != recv_buf_len) {
 		dprintk(debug, "only read %d of %d bytes\n",
 				actual_len, recv_buf_len);
 		return -1;
@@ -169,7 +174,8 @@
 	.stop_stream	= as102_usb_stop_stream,
 };
 
-static int as102_submit_urb_stream(struct as102_dev_t *dev, struct urb *urb) {
+static int as102_submit_urb_stream(struct as102_dev_t *dev, struct urb *urb)
+{
 	int err;
 
 	usb_fill_bulk_urb(urb,
@@ -180,8 +186,9 @@
 			  as102_urb_stream_irq,
 			  dev);
 
-	if ((err = usb_submit_urb(urb, GFP_ATOMIC)))
-		dprintk(debug, "%s: usb_submit_urb failed\n", __FUNCTION__);
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err)
+		dprintk(debug, "%s: usb_submit_urb failed\n", __func__);
 
 	return err;
 }
@@ -203,7 +210,7 @@
 		/* do nothing ? */
 #endif
 	} else {
-		if(urb->actual_length == 0)
+		if (urb->actual_length == 0)
 			memset(urb->transfer_buffer, 0, AS102_USB_BUF_SIZE);
 	}
 
@@ -212,7 +219,8 @@
 		as102_submit_urb_stream(as102_dev, urb);
 }
 
-static void as102_free_usb_stream_buffer(struct as102_dev_t *dev) {
+static void as102_free_usb_stream_buffer(struct as102_dev_t *dev)
+{
 	int i;
 
 	ENTER();
@@ -227,7 +235,8 @@
 	LEAVE();
 }
 
-static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev) {
+static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
+{
 	int i, ret = 0;
 
 	ENTER();
@@ -237,7 +246,7 @@
 				       GFP_KERNEL,
 				       &dev->dma_addr);
 	if (!dev->stream) {
-		dprintk(debug, "%s: usb_buffer_alloc failed\n", __FUNCTION__);
+		dprintk(debug, "%s: usb_buffer_alloc failed\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -247,8 +256,9 @@
 	for (i = 0; i < MAX_STREAM_URB; i++) {
 		struct urb *urb;
 
-		if (!(urb = usb_alloc_urb(0, GFP_ATOMIC))) {
-			dprintk(debug, "%s: usb_alloc_urb failed\n", __FUNCTION__);
+		urb = usb_alloc_urb(0, GFP_ATOMIC);
+		if (urb == NULL) {
+			dprintk(debug, "%s: usb_alloc_urb failed\n", __func__);
 			as102_free_usb_stream_buffer(dev);
 			return -ENOMEM;
 		}
@@ -262,18 +272,21 @@
 	return ret;
 }
 
-static void as102_usb_stop_stream(struct as102_dev_t *dev) {
+static void as102_usb_stop_stream(struct as102_dev_t *dev)
+{
 	int i;
 
 	for (i = 0; i < MAX_STREAM_URB; i++)
 		usb_kill_urb(dev->stream_urb[i]);
 }
 
-static int as102_usb_start_stream(struct as102_dev_t *dev) {
+static int as102_usb_start_stream(struct as102_dev_t *dev)
+{
 	int i, ret = 0;
 
 	for (i = 0; i < MAX_STREAM_URB; i++) {
-		if ((ret = as102_submit_urb_stream(dev, dev->stream_urb[i]))) {
+		ret = as102_submit_urb_stream(dev, dev->stream_urb[i]);
+		if (ret) {
 			as102_usb_stop_stream(dev);
 			return ret;
 		}
@@ -282,7 +295,8 @@
 	return 0;
 }
 
-static void as102_usb_release(struct kref *kref) {
+static void as102_usb_release(struct kref *kref)
+{
 	struct as102_dev_t *as102_dev;
 
 	ENTER();
@@ -296,7 +310,8 @@
 	LEAVE();
 }
 
-static void as102_usb_disconnect(struct usb_interface *intf) {
+static void as102_usb_disconnect(struct usb_interface *intf)
+{
 	struct as102_dev_t *as102_dev;
 
 	ENTER();
@@ -324,14 +339,16 @@
 }
 
 static int as102_usb_probe(struct usb_interface *intf,
-			   const struct usb_device_id *id) {
+			   const struct usb_device_id *id)
+{
 	int ret;
 	struct as102_dev_t *as102_dev;
 
 	ENTER();
 
-	if(!(as102_dev = kzalloc(sizeof(struct as102_dev_t), GFP_KERNEL))) {
-		err("%s: kzalloc failed", __FUNCTION__);
+	as102_dev = kzalloc(sizeof(struct as102_dev_t), GFP_KERNEL);
+	if (as102_dev == NULL) {
+		err("%s: kzalloc failed", __func__);
 		return -ENOMEM;
 	}
 
@@ -352,17 +369,19 @@
 	as102_dev->bus_adap.usb_dev = usb_get_dev(interface_to_usbdev(intf));
 
 	/* we can register the device now, as it is ready */
-	if((ret = usb_register_dev(intf, &as102_usb_class_driver)) < 0) {;
+	ret = usb_register_dev(intf, &as102_usb_class_driver);
+	if (ret < 0) {
 		/* something prevented us from registering this driver */
 		err("%s: usb_register_dev() failed (errno = %d)",
-		    __FUNCTION__, ret);
+		    __func__, ret);
 		goto failed;
 	}
 
 	printk(KERN_INFO "%s: device has been detected\n", DRIVER_NAME);
 
 	/* request buffer allocation for streaming */
-	if ((ret = as102_alloc_usb_stream_buffer(as102_dev)) != 0)
+	ret = as102_alloc_usb_stream_buffer(as102_dev);
+	if (ret != 0)
 		goto failed;
 
 	/* register dvb layer */
@@ -377,7 +396,8 @@
 	return ret;
 }
 
-static int as102_open(struct inode *inode, struct file *file) {
+static int as102_open(struct inode *inode, struct file *file)
+{
 	int ret = 0, minor = 0;
 	struct usb_interface *intf = NULL;
 	struct as102_dev_t *dev = NULL;
@@ -388,15 +408,17 @@
 	minor = iminor(inode);
 
 	/* fetch device from usb interface */
-	if((intf = usb_find_interface(&as102_usb_driver, minor)) == NULL) {
+	intf = usb_find_interface(&as102_usb_driver, minor);
+	if (intf == NULL) {
 		printk(KERN_ERR "%s: can't find device for minor %d\n",
-				__FUNCTION__, minor);
+				__func__, minor);
 		ret = -ENODEV;
 		goto exit;
 	}
 
 	/* get our device */
-	if((dev = usb_get_intfdata(intf)) == NULL) {
+	dev = usb_get_intfdata(intf);
+	if (dev == NULL) {
 		ret = -EFAULT;
 		goto exit;
 	}
@@ -412,13 +434,15 @@
 	return ret;
 }
 
-static int as102_release(struct inode *inode, struct file *file) {
+static int as102_release(struct inode *inode, struct file *file)
+{
 	int ret = 0;
 	struct as102_dev_t *dev = NULL;
 
 	ENTER();
 
-	if((dev = file->private_data) != NULL ) {
+	dev = file->private_data;
+	if (dev != NULL) {
 		/* decrement the count on our device */
 		kref_put(&dev->kref, as102_usb_release);
 	}
diff --git linux/drivers/staging/media/as102/as102_usb_drv.h linuxb/drivers/media/dvb/as102/as102_usb_drv.h
--- linux/drivers/staging/media/as102/as102_usb_drv.h
+++ linuxb/drivers/staging/media/as102/as102_usb_drv.h
@@ -1,6 +1,7 @@
 /*
  * Abilis Systems Single DVB-T Receiver
  * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -35,8 +36,6 @@
 #define PCTV_74E_USB_VID		0x2013
 #define PCTV_74E_USB_PID		0x0246
 
-extern struct file_operations as102_dev_fops;
-
 #if (LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 18))
 void as102_urb_stream_irq(struct urb *urb, struct pt_regs *regs);
 #else
