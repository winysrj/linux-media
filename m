Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab0EXPBO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 11:01:14 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4OF1DYJ013692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 May 2010 11:01:14 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o4OF0kFU006174
	for <linux-media@vger.kernel.org>; Mon, 24 May 2010 11:00:53 -0400
Date: Mon, 24 May 2010 11:00:31 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR/imon: clean up usage of bools
Message-ID: <20100524150031.GA15850@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was a mix of 0/1 and false/true. Pick one convention and stick
with it (I picked false/true).

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |   48 +++++++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 5e20456..2bae9ba 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -385,7 +385,7 @@ static int display_open(struct inode *inode, struct file *file)
 		err("%s: display port is already open", __func__);
 		retval = -EBUSY;
 	} else {
-		ictx->display_isopen = 1;
+		ictx->display_isopen = true;
 		file->private_data = ictx;
 		dev_dbg(ictx->dev, "display port opened\n");
 	}
@@ -422,7 +422,7 @@ static int display_close(struct inode *inode, struct file *file)
 		err("%s: display is not open", __func__);
 		retval = -EIO;
 	} else {
-		ictx->display_isopen = 0;
+		ictx->display_isopen = false;
 		dev_dbg(ictx->dev, "display port closed\n");
 		if (!ictx->dev_present_intf0) {
 			/*
@@ -491,12 +491,12 @@ static int send_packet(struct imon_context *ictx)
 	}
 
 	init_completion(&ictx->tx.finished);
-	ictx->tx.busy = 1;
+	ictx->tx.busy = true;
 	smp_rmb(); /* ensure later readers know we're busy */
 
 	retval = usb_submit_urb(ictx->tx_urb, GFP_KERNEL);
 	if (retval) {
-		ictx->tx.busy = 0;
+		ictx->tx.busy = false;
 		smp_rmb(); /* ensure later readers know we're not busy */
 		err("%s: error submitting urb(%d)", __func__, retval);
 	} else {
@@ -682,7 +682,7 @@ static ssize_t store_associate_remote(struct device *d,
 		return -ENODEV;
 
 	mutex_lock(&ictx->lock);
-	ictx->rf_isassociating = 1;
+	ictx->rf_isassociating = true;
 	send_associate_24g(ictx);
 	mutex_unlock(&ictx->lock);
 
@@ -950,7 +950,7 @@ static void usb_tx_callback(struct urb *urb)
 	ictx->tx.status = urb->status;
 
 	/* notify waiters that write has finished */
-	ictx->tx.busy = 0;
+	ictx->tx.busy = false;
 	smp_rmb(); /* ensure later readers know we're not busy */
 	complete(&ictx->tx.finished);
 }
@@ -1215,7 +1215,7 @@ static bool imon_mouse_event(struct imon_context *ictx,
 {
 	char rel_x = 0x00, rel_y = 0x00;
 	u8 right_shift = 1;
-	bool mouse_input = 1;
+	bool mouse_input = true;
 	int dir = 0;
 
 	/* newer iMON device PAD or mouse button */
@@ -1246,7 +1246,7 @@ static bool imon_mouse_event(struct imon_context *ictx,
 	} else if (ictx->kc == KEY_CHANNELDOWN && (buf[2] & 0x40) != 0x40) {
 		dir = -1;
 	} else
-		mouse_input = 0;
+		mouse_input = false;
 
 	if (mouse_input) {
 		dev_dbg(ictx->dev, "sending mouse data via input subsystem\n");
@@ -1450,7 +1450,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	unsigned char *buf = urb->transfer_buffer;
 	struct device *dev = ictx->dev;
 	u32 kc;
-	bool norelease = 0;
+	bool norelease = false;
 	int i;
 	u64 temp_key;
 	u64 panel_key = 0;
@@ -1517,7 +1517,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	     !(buf[1] & 0x1 || buf[1] >> 2 & 0x1))) {
 		len = 8;
 		imon_pad_to_keys(ictx, buf);
-		norelease = 1;
+		norelease = true;
 	}
 
 	if (debug) {
@@ -1580,7 +1580,7 @@ not_input_data:
 	    (buf[6] == 0x5E && buf[7] == 0xDF))) {	/* DT */
 		dev_warn(dev, "%s: remote associated refid=%02X\n",
 			 __func__, buf[1]);
-		ictx->rf_isassociating = 0;
+		ictx->rf_isassociating = false;
 	}
 }
 
@@ -1790,9 +1790,9 @@ static bool imon_find_endpoints(struct imon_context *ictx,
 	int ifnum = iface_desc->desc.bInterfaceNumber;
 	int num_endpts = iface_desc->desc.bNumEndpoints;
 	int i, ep_dir, ep_type;
-	bool ir_ep_found = 0;
-	bool display_ep_found = 0;
-	bool tx_control = 0;
+	bool ir_ep_found = false;
+	bool display_ep_found = false;
+	bool tx_control = false;
 
 	/*
 	 * Scan the endpoint list and set:
@@ -1808,13 +1808,13 @@ static bool imon_find_endpoints(struct imon_context *ictx,
 		    ep_type == USB_ENDPOINT_XFER_INT) {
 
 			rx_endpoint = ep;
-			ir_ep_found = 1;
+			ir_ep_found = true;
 			dev_dbg(ictx->dev, "%s: found IR endpoint\n", __func__);
 
 		} else if (!display_ep_found && ep_dir == USB_DIR_OUT &&
 			   ep_type == USB_ENDPOINT_XFER_INT) {
 			tx_endpoint = ep;
-			display_ep_found = 1;
+			display_ep_found = true;
 			dev_dbg(ictx->dev, "%s: found display endpoint\n", __func__);
 		}
 	}
@@ -1835,8 +1835,8 @@ static bool imon_find_endpoints(struct imon_context *ictx,
 	 * newer iMON devices that use control urb instead of interrupt
 	 */
 	if (!display_ep_found) {
-		tx_control = 1;
-		display_ep_found = 1;
+		tx_control = true;
+		display_ep_found = true;
 		dev_dbg(ictx->dev, "%s: device uses control endpoint, not "
 			"interface OUT endpoint\n", __func__);
 	}
@@ -1847,7 +1847,7 @@ static bool imon_find_endpoints(struct imon_context *ictx,
 	 * and without... :\
 	 */
 	if (ictx->display_type == IMON_DISPLAY_TYPE_NONE) {
-		display_ep_found = 0;
+		display_ep_found = false;
 		dev_dbg(ictx->dev, "%s: device has no display\n", __func__);
 	}
 
@@ -1856,7 +1856,7 @@ static bool imon_find_endpoints(struct imon_context *ictx,
 	 * that refers to e.g. /dev/lcd0 (a character device LCD or VFD).
 	 */
 	if (ictx->display_type == IMON_DISPLAY_TYPE_VGA) {
-		display_ep_found = 0;
+		display_ep_found = false;
 		dev_dbg(ictx->dev, "%s: iMON Touch device found\n", __func__);
 	}
 
@@ -1905,7 +1905,7 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 
 	ictx->dev = dev;
 	ictx->usbdev_intf0 = usb_get_dev(interface_to_usbdev(intf));
-	ictx->dev_present_intf0 = 1;
+	ictx->dev_present_intf0 = true;
 	ictx->rx_urb_intf0 = rx_urb;
 	ictx->tx_urb = tx_urb;
 
@@ -1979,7 +1979,7 @@ static struct imon_context *imon_init_intf1(struct usb_interface *intf,
 	}
 
 	ictx->usbdev_intf1 = usb_get_dev(interface_to_usbdev(intf));
-	ictx->dev_present_intf1 = 1;
+	ictx->dev_present_intf1 = true;
 	ictx->rx_urb_intf1 = rx_urb;
 
 	ret = -ENODEV;
@@ -2297,7 +2297,7 @@ static void __devexit imon_disconnect(struct usb_interface *interface)
 	}
 
 	if (ifnum == 0) {
-		ictx->dev_present_intf0 = 0;
+		ictx->dev_present_intf0 = false;
 		usb_kill_urb(ictx->rx_urb_intf0);
 		input_unregister_device(ictx->idev);
 		if (ictx->display_supported) {
@@ -2307,7 +2307,7 @@ static void __devexit imon_disconnect(struct usb_interface *interface)
 				usb_deregister_dev(interface, &imon_vfd_class);
 		}
 	} else {
-		ictx->dev_present_intf1 = 0;
+		ictx->dev_present_intf1 = false;
 		usb_kill_urb(ictx->rx_urb_intf1);
 		if (ictx->display_type == IMON_DISPLAY_TYPE_VGA)
 			input_unregister_device(ictx->touch);

-- 
Jarod Wilson
jarod@redhat.com

