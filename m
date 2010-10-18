Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:20113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757828Ab0JRWzT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 18:55:19 -0400
Date: Mon, 18 Oct 2010 20:52:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, jarod@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] cx231xx: Only register USB interface 1
Message-ID: <20101018205259.171bd8ed@pedra>
In-Reply-To: <cover.1287442245.git.mchehab@redhat.com>
References: <cover.1287442245.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Interface 0 is used by IR. The current driver starts initializing
on it, finishing on interface 6. Change the logic to only handle
interface 1. This allows another driver (mceusb) to take care of
the IR interface.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 9c3a926..2db9856 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -843,13 +843,12 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	char *speed;
 	char descr[255] = "";
 	struct usb_interface *lif = NULL;
-	int skip_interface = 0;
 	struct usb_interface_assoc_descriptor *assoc_desc;
 
 	udev = usb_get_dev(interface_to_usbdev(interface));
 	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 
-	if (!ifnum) {
+	if (ifnum == 1) {
 		/*
 		 * Interface number 0 - IR interface
 		 */
@@ -936,13 +935,6 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		     le16_to_cpu(udev->descriptor.idVendor),
 		     le16_to_cpu(udev->descriptor.idProduct),
 		     dev->max_iad_interface_count);
-	} else {
-		/* Get dev structure first */
-		dev = usb_get_intfdata(udev->actconfig->interface[0]);
-		if (dev == NULL) {
-			cx231xx_err(DRIVER_NAME ": out of first interface!\n");
-			return -ENODEV;
-		}
 
 		/* store the interface 0 back */
 		lif = udev->actconfig->interface[0];
@@ -953,35 +945,21 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		/* get device number */
 		nr = dev->devno;
 
-		/*
-		 * set skip interface, for all interfaces but
-		 * interface 1 and the last one
-		 */
-		if ((ifnum != 1) && ((ifnum)
-				     != dev->max_iad_interface_count))
-			skip_interface = 1;
-
-		if (ifnum == 1) {
-			assoc_desc = udev->actconfig->intf_assoc[0];
-			if (assoc_desc->bFirstInterface != ifnum) {
-				cx231xx_err(DRIVER_NAME ": Not found "
-					    "matching IAD interface\n");
-				return -ENODEV;
-			}
+		assoc_desc = udev->actconfig->intf_assoc[0];
+		if (assoc_desc->bFirstInterface != ifnum) {
+			cx231xx_err(DRIVER_NAME ": Not found "
+				    "matching IAD interface\n");
+			return -ENODEV;
 		}
-	}
-
-	if (skip_interface)
+	} else {
 		return -ENODEV;
+	}
 
 	cx231xx_info("registering interface %d\n", ifnum);
 
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(lif, dev);
 
-	if ((ifnum) != dev->max_iad_interface_count)
-		return 0;
-
 	/*
 	 * AV device initialization - only done at the last interface
 	 */
-- 
1.7.1


