Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab0EXPCW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 11:02:22 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4OF2L0E011762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 May 2010 11:02:21 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o4OF2Lip007025
	for <linux-media@vger.kernel.org>; Mon, 24 May 2010 11:02:21 -0400
Date: Mon, 24 May 2010 11:02:05 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR/imon: add auto-config for 0xffdc rf device
Message-ID: <20100524150205.GA15860@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add auto-config support for iMON 2.4G LT RF device, based on
debug output from Giulio Amodeo in Red Hat bugzilla #572288.

Also flips the switch on only setting up the rf associate sysfs
attr only if we think we're looking at an RF device, vs. previously,
setting up the attr for all 0xffdc devices, so its possible (but a bit
unlikely) there's another iMON RF device we'll have to fix up.

Nb: should be applied after "IR/imon: clean up usage of bools", or there
will be a slight contextual mismatch.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 5e20456..0e43795 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -94,6 +94,7 @@ struct imon_context {
 
 	bool display_supported;		/* not all controllers do */
 	bool display_isopen;		/* display port has been opened */
+	bool rf_device;			/* true if iMON 2.4G LT/DT RF device */
 	bool rf_isassociating;		/* RF remote associating */
 	bool dev_present_intf0;		/* USB device presence, interface 0 */
 	bool dev_present_intf1;		/* USB device presence, interface 1 */
@@ -1465,7 +1466,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	idev = ictx->idev;
 
 	/* filter out junk data on the older 0xffdc imon devices */
-	if ((buf[0] == 0xff) && (buf[7] == 0xff))
+	if ((buf[0] == 0xff) && (buf[1] == 0xff) && (buf[2] == 0xff))
 		return;
 
 	/* Figure out what key was pressed */
@@ -1908,6 +1909,7 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 	ictx->dev_present_intf0 = true;
 	ictx->rx_urb_intf0 = rx_urb;
 	ictx->tx_urb = tx_urb;
+	ictx->rf_device = false;
 
 	ictx->vendor  = le16_to_cpu(ictx->usbdev_intf0->descriptor.idVendor);
 	ictx->product = le16_to_cpu(ictx->usbdev_intf0->descriptor.idProduct);
@@ -2047,6 +2049,12 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 		dev_info(ictx->dev, "0xffdc iMON Knob, iMON IR");
 		ictx->display_supported = false;
 		break;
+	/* iMON 2.4G LT (usb stick), no display, iMON RF */
+	case 0x4e:
+		dev_info(ictx->dev, "0xffdc iMON 2.4G LT, iMON RF");
+		ictx->display_supported = false;
+		ictx->rf_device = true;
+		break;
 	/* iMON VFD, no IR (does have vol knob tho) */
 	case 0x35:
 		dev_info(ictx->dev, "0xffdc iMON VFD + knob, no IR");
@@ -2197,15 +2205,6 @@ static int __devinit imon_probe(struct usb_interface *interface,
 			goto fail;
 		}
 
-		if (product == 0xffdc) {
-			/* RF products *also* use 0xffdc... sigh... */
-			sysfs_err = sysfs_create_group(&interface->dev.kobj,
-						       &imon_rf_attribute_group);
-			if (sysfs_err)
-				err("%s: Could not create RF sysfs entries(%d)",
-				    __func__, sysfs_err);
-		}
-
 	} else {
 	/* this is the secondary interface on the device */
 		ictx = imon_init_intf1(interface, first_if_ctx);
@@ -2233,6 +2232,14 @@ static int __devinit imon_probe(struct usb_interface *interface,
 
 		imon_set_display_type(ictx, interface);
 
+		if (product == 0xffdc && ictx->rf_device) {
+			sysfs_err = sysfs_create_group(&interface->dev.kobj,
+						       &imon_rf_attribute_group);
+			if (sysfs_err)
+				err("%s: Could not create RF sysfs entries(%d)",
+				    __func__, sysfs_err);
+		}
+
 		if (ictx->display_supported)
 			imon_init_display(ictx, interface);
 	}

-- 
Jarod Wilson
jarod@redhat.com

