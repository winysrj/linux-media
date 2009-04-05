Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110810.mail.gq1.yahoo.com ([67.195.13.233]:27019 "HELO
	web110810.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750759AbZDEMBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 08:01:03 -0400
Message-ID: <114303.97609.qm@web110810.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 05:01:00 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_17] Siano: smsusb - update header and indentation
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238759458 -10800
# Node ID 73c6299ef5f518beb07b6eb371402fe1be4e26ea
# Parent  c582116cfbb96671629143fced33e3f88c28b3c7
[PATCH] [0904_17] Siano: smsusb - update header and indentation

From: Uri Shkolnik <uris@siano-ms.com>

This patch does not introduce any implementation change.
It include modified license and included files list and
align indentation.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r c582116cfbb9 -r 73c6299ef5f5 linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Fri Apr 03 14:38:46 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Fri Apr 03 14:50:58 2009 +0300
@@ -1,35 +1,34 @@
-/*
- *  Driver for the Siano SMS1xxx USB dongle
- *
- *  author: Anatoly Greenblat
- *
- *  Copyright (c), 2005-2008 Siano Mobile Silicon, Inc.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation;
- *
- *  Software distributed under the License is distributed on an "AS IS"
- *  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
- *
- *  See the GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
+/****************************************************************
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2006-2008, Uri Shkolnik, Anatoly Greenblat
+
+This program is free software: you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation, either version 2 of the License, or
+(at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+****************************************************************/
 
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/firmware.h>
+#include <asm/byteorder.h>
 
 #include "smscoreapi.h"
 #include "sms-cards.h"
 
-static int sms_dbg;
-module_param_named(debug, sms_dbg, int, 0644);
-MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
+#include "smsendian.h"
 
 #define USB1_BUFFER_SIZE		0x1000
 #define USB2_BUFFER_SIZE		0x4000
@@ -41,7 +40,7 @@ struct smsusb_device_t;
 
 struct smsusb_urb_t {
 	struct smscore_buffer_t *cb;
-	struct smsusb_device_t	*dev;
+	struct smsusb_device_t *dev;
 
 	struct urb urb;
 };
@@ -50,10 +49,10 @@ struct smsusb_device_t {
 	struct usb_device *udev;
 	struct smscore_device_t *coredev;
 
-	struct smsusb_urb_t 	surbs[MAX_URBS];
+	struct smsusb_urb_t surbs[MAX_URBS];
 
-	int		response_alignment;
-	int		buffer_size;
+	int response_alignment;
+	int buffer_size;
 };
 
 static int smsusb_submit_urb(struct smsusb_device_t *dev,
@@ -75,7 +74,7 @@ static void smsusb_onresponse(struct urb
 	}
 
 	if (urb->actual_length > 0) {
-		struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) surb->cb->p;
+		struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *)surb->cb->p;
 
 		if (urb->actual_length >= phdr->msgLength) {
 			surb->cb->size = phdr->msgLength;
@@ -84,11 +83,11 @@ static void smsusb_onresponse(struct urb
 			    (phdr->msgFlags & MSG_HDR_FLAG_SPLIT_MSG)) {
 
 				surb->cb->offset =
-					dev->response_alignment +
-					((phdr->msgFlags >> 8) & 3);
+				    dev->response_alignment +
+				    ((phdr->msgFlags >> 8) & 3);
 
 				/* sanity check */
-				if (((int) phdr->msgLength +
+				if (((int)phdr->msgLength +
 				     surb->cb->offset) > urb->actual_length) {
 					sms_err("invalid response "
 						"msglen %d offset %d "
@@ -101,7 +100,7 @@ static void smsusb_onresponse(struct urb
 
 				/* move buffer pointer and
 				 * copy header to its new location */
-				memcpy((char *) phdr + surb->cb->offset,
+				memcpy((char *)phdr + surb->cb->offset,
 				       phdr, sizeof(struct SmsMsgHdr_ST));
 			} else
 				surb->cb->offset = 0;
@@ -177,7 +176,7 @@ static int smsusb_start_streaming(struct
 
 static int smsusb_sendrequest(void *context, void *buffer, size_t size)
 {
-	struct smsusb_device_t *dev = (struct smsusb_device_t *) context;
+	struct smsusb_device_t *dev = (struct smsusb_device_t *)context;
 	int dummy;
 
 	return usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 2),
@@ -251,7 +250,7 @@ static void smsusb1_detectmode(void *con
 static void smsusb1_detectmode(void *context, int *mode)
 {
 	char *product_string =
-		((struct smsusb_device_t *) context)->udev->product;
+	    ((struct smsusb_device_t *)context)->udev->product;
 
 	*mode = DEVICE_MODE_NONE;
 
@@ -286,7 +285,7 @@ static void smsusb_term_device(struct us
 static void smsusb_term_device(struct usb_interface *intf)
 {
 	struct smsusb_device_t *dev =
-		(struct smsusb_device_t *) usb_get_intfdata(intf);
+	    (struct smsusb_device_t *)usb_get_intfdata(intf);
 
 	if (dev) {
 		smsusb_stop_streaming(dev);
@@ -399,8 +398,9 @@ static int smsusb_probe(struct usb_inter
 	rc = usb_clear_halt(udev, usb_rcvbulkpipe(udev, 0x02));
 
 	if (intf->num_altsetting > 0) {
-		rc = usb_set_interface(
-			udev, intf->cur_altsetting->desc.bInterfaceNumber, 0);
+		rc = usb_set_interface(udev,
+				intf->cur_altsetting->desc.
+				bInterfaceNumber, 0);
 		if (rc < 0) {
 			sms_err("usb_set_interface failed, rc %d", rc);
 			return rc;
@@ -408,12 +408,13 @@ static int smsusb_probe(struct usb_inter
 	}
 
 	sms_info("smsusb_probe %d",
-	       intf->cur_altsetting->desc.bInterfaceNumber);
+		 intf->cur_altsetting->desc.bInterfaceNumber);
 	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++)
 		sms_info("endpoint %d %02x %02x %d", i,
-		       intf->cur_altsetting->endpoint[i].desc.bEndpointAddress,
-		       intf->cur_altsetting->endpoint[i].desc.bmAttributes,
-		       intf->cur_altsetting->endpoint[i].desc.wMaxPacketSize);
+			 intf->cur_altsetting->endpoint[i].desc.
+			 bEndpointAddress,
+			 intf->cur_altsetting->endpoint[i].desc.bmAttributes,
+			 intf->cur_altsetting->endpoint[i].desc.wMaxPacketSize);
 
 	if ((udev->actconfig->desc.bNumInterfaces == 2) &&
 	    (intf->cur_altsetting->desc.bInterfaceNumber == 0)) {
@@ -425,9 +426,9 @@ static int smsusb_probe(struct usb_inter
 		snprintf(devpath, sizeof(devpath), "usb\\%d-%s",
 			 udev->bus->busnum, udev->devpath);
 		sms_info("stellar device was found.");
-		return smsusb1_load_firmware(
-				udev, smscore_registry_getmode(devpath),
-				id->driver_info);
+		return smsusb1_load_firmware(udev,
+					     smscore_registry_getmode(devpath),
+					     id->driver_info);
 	}
 
 	rc = smsusb_init_device(intf, id->driver_info);
@@ -444,8 +445,8 @@ static int smsusb_suspend(struct usb_int
 static int smsusb_suspend(struct usb_interface *intf, pm_message_t msg)
 {
 	struct smsusb_device_t *dev =
-		(struct smsusb_device_t *)usb_get_intfdata(intf);
-	printk(KERN_INFO "%s: Entering status %d.\n", __func__, msg.event);
+	    (struct smsusb_device_t *)usb_get_intfdata(intf);
+	printk(KERN_INFO "%s  Entering status %d.\n", __func__, msg.event);
 	smsusb_stop_streaming(dev);
 	return 0;
 }
@@ -454,10 +455,10 @@ static int smsusb_resume(struct usb_inte
 {
 	int rc, i;
 	struct smsusb_device_t *dev =
-		(struct smsusb_device_t *)usb_get_intfdata(intf);
+	    (struct smsusb_device_t *)usb_get_intfdata(intf);
 	struct usb_device *udev = interface_to_usbdev(intf);
 
-	printk(KERN_INFO "%s: Entering.\n", __func__);
+	printk(KERN_INFO "%s  Entering.\n", __func__);
 	usb_clear_halt(udev, usb_rcvbulkpipe(udev, 0x81));
 	usb_clear_halt(udev, usb_rcvbulkpipe(udev, 0x02));
 
@@ -472,8 +473,9 @@ static int smsusb_resume(struct usb_inte
 				       intf->cur_altsetting->desc.
 				       bInterfaceNumber, 0);
 		if (rc < 0) {
-			printk(KERN_INFO "%s usb_set_interface failed, "
-			       "rc %d\n", __func__, rc);
+			printk(KERN_INFO
+			       "%s usb_set_interface failed, rc %d\n",
+			       __func__, rc);
 			return rc;
 		}
 	}



      
