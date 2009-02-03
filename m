Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:59514
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbZBCXNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2009 18:13:21 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: [PATCH] Make sure gspca cleans up USB resources during disconnect
Date: Tue, 3 Feb 2009 23:13:17 +0000
Cc: kilgota@banach.math.auburn.edu,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032313.17538.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a device using the gspca framework is unplugged while it is still streaming
then the call that is used to free the URBs that have been allocated occurs
after the pointer it uses becomes invalid at the end of gspca_disconnect.
Make another cleanup call in gspca_disconnect while the pointer is still
valid (multiple calls are OK as destroy_urbs checks for pointers already
being NULL.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>

---
diff -r 4d0827823ebc linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Tue Feb 03 10:42:28 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Tue Feb 03 23:07:34 2009 +0000
@@ -434,6 +434,7 @@ static void destroy_urbs(struct gspca_de
 		if (urb == NULL)
 			break;
 
+		BUG_ON(!gspca_dev->dev);
 		gspca_dev->urb[i] = NULL;
 		if (gspca_dev->present)
 			usb_kill_urb(urb);
@@ -1953,8 +1954,12 @@ void gspca_disconnect(struct usb_interfa
 {
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
 
+	mutex_lock(&gspca_dev->usb_lock);
 	gspca_dev->present = 0;
+	mutex_unlock(&gspca_dev->usb_lock);
 
+	destroy_urbs(gspca_dev);
+	gspca_dev->dev = NULL;
 	usb_set_intfdata(intf, NULL);
 
 	/* release the device */
