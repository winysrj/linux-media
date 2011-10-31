Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58562 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab1JaQZo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:44 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444327eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:44 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 07/17] staging: as102: Fix CodingStyle errors in file as102_usb_drv.c
Date: Mon, 31 Oct 2011 17:24:45 +0100
Message-Id: <1320078295-3379-8-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Fix Linux kernel coding style (whitespace and indentation) errors
in file as102_usb_drv.c. No functional changes.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_usb_drv.c |  118 ++++++++++++++++-----------
 drivers/staging/media/as102/as102_usb_drv.h |    3 +-
 2 files changed, 72 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index ee99396..6e79719 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -1,6 +1,7 @@
 /*
  * Abilis Systems Single DVB-T Receiver
  * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -49,7 +50,7 @@ struct usb_driver as102_usb_driver = {
 	.id_table   =  as102_usb_id_table
 };
 
-struct file_operations as102_dev_fops = {
+static const struct file_operations as102_dev_fops = {
 	.owner   = THIS_MODULE,
 	.open    = as102_open,
 	.release = as102_release,
@@ -63,46 +64,48 @@ static struct usb_class_driver as102_usb_class_driver = {
 
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
@@ -119,18 +122,19 @@ static int as102_usb_xfer_cmd(struct as102_bus_adapter_t *bus_adap,
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
@@ -139,21 +143,22 @@ static int as102_send_ep1(struct as102_bus_adapter_t *bus_adap,
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
@@ -169,7 +174,8 @@ struct as102_priv_ops_t as102_priv_ops = {
 	.stop_stream	= as102_usb_stop_stream,
 };
 
-static int as102_submit_urb_stream(struct as102_dev_t *dev, struct urb *urb) {
+static int as102_submit_urb_stream(struct as102_dev_t *dev, struct urb *urb)
+{
 	int err;
 
 	usb_fill_bulk_urb(urb,
@@ -180,8 +186,9 @@ static int as102_submit_urb_stream(struct as102_dev_t *dev, struct urb *urb) {
 			  as102_urb_stream_irq,
 			  dev);
 
-	if ((err = usb_submit_urb(urb, GFP_ATOMIC)))
-		dprintk(debug, "%s: usb_submit_urb failed\n", __FUNCTION__);
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err)
+		dprintk(debug, "%s: usb_submit_urb failed\n", __func__);
 
 	return err;
 }
@@ -203,7 +210,7 @@ void as102_urb_stream_irq(struct urb *urb)
 		/* do nothing ? */
 #endif
 	} else {
-		if(urb->actual_length == 0)
+		if (urb->actual_length == 0)
 			memset(urb->transfer_buffer, 0, AS102_USB_BUF_SIZE);
 	}
 
@@ -212,7 +219,8 @@ void as102_urb_stream_irq(struct urb *urb)
 		as102_submit_urb_stream(as102_dev, urb);
 }
 
-static void as102_free_usb_stream_buffer(struct as102_dev_t *dev) {
+static void as102_free_usb_stream_buffer(struct as102_dev_t *dev)
+{
 	int i;
 
 	ENTER();
@@ -227,7 +235,8 @@ static void as102_free_usb_stream_buffer(struct as102_dev_t *dev) {
 	LEAVE();
 }
 
-static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev) {
+static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
+{
 	int i, ret = 0;
 
 	ENTER();
@@ -237,7 +246,7 @@ static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev) {
 				       GFP_KERNEL,
 				       &dev->dma_addr);
 	if (!dev->stream) {
-		dprintk(debug, "%s: usb_buffer_alloc failed\n", __FUNCTION__);
+		dprintk(debug, "%s: usb_buffer_alloc failed\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -247,8 +256,9 @@ static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev) {
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
@@ -262,18 +272,21 @@ static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev) {
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
@@ -282,7 +295,8 @@ static int as102_usb_start_stream(struct as102_dev_t *dev) {
 	return 0;
 }
 
-static void as102_usb_release(struct kref *kref) {
+static void as102_usb_release(struct kref *kref)
+{
 	struct as102_dev_t *as102_dev;
 
 	ENTER();
@@ -296,7 +310,8 @@ static void as102_usb_release(struct kref *kref) {
 	LEAVE();
 }
 
-static void as102_usb_disconnect(struct usb_interface *intf) {
+static void as102_usb_disconnect(struct usb_interface *intf)
+{
 	struct as102_dev_t *as102_dev;
 
 	ENTER();
@@ -324,14 +339,16 @@ static void as102_usb_disconnect(struct usb_interface *intf) {
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
 
@@ -352,17 +369,19 @@ static int as102_usb_probe(struct usb_interface *intf,
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
@@ -377,7 +396,8 @@ failed:
 	return ret;
 }
 
-static int as102_open(struct inode *inode, struct file *file) {
+static int as102_open(struct inode *inode, struct file *file)
+{
 	int ret = 0, minor = 0;
 	struct usb_interface *intf = NULL;
 	struct as102_dev_t *dev = NULL;
@@ -388,15 +408,17 @@ static int as102_open(struct inode *inode, struct file *file) {
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
@@ -412,13 +434,15 @@ exit:
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
diff --git a/drivers/staging/media/as102/as102_usb_drv.h b/drivers/staging/media/as102/as102_usb_drv.h
index abb858e..3abab6c 100644
--- a/drivers/staging/media/as102/as102_usb_drv.h
+++ b/drivers/staging/media/as102/as102_usb_drv.h
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
-- 
1.7.4.1

