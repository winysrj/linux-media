Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48906 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937789AbdD0M1N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 08:27:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/2] uvcvideo: Add iFunction or iInterface to device names.
Date: Thu, 27 Apr 2017 15:28:18 +0300
Message-Id: <20170427122818.13146-3-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20170427122818.13146-1-laurent.pinchart@ideasonboard.com>
References: <20170427122818.13146-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Boström <pbos@google.com>

Permits distinguishing between two /dev/videoX entries from the same
physical UVC device (that naturally share the same iProduct name).

This change matches current Windows behavior by prioritizing iFunction
over iInterface, but unlike Windows it displays both iProduct and
iFunction/iInterface strings when both are available.

Signed-off-by: Peter Boström <pbos@google.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 602256ffe14d..70842c5af05b 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2013,6 +2013,7 @@ static int uvc_probe(struct usb_interface *intf,
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct uvc_device *dev;
+	int function;
 	int ret;
 
 	if (id->idVendor && id->idProduct)
@@ -2044,9 +2045,27 @@ static int uvc_probe(struct usb_interface *intf,
 		strlcpy(dev->name, udev->product, sizeof dev->name);
 	else
 		snprintf(dev->name, sizeof dev->name,
-			"UVC Camera (%04x:%04x)",
-			le16_to_cpu(udev->descriptor.idVendor),
-			le16_to_cpu(udev->descriptor.idProduct));
+			 "UVC Camera (%04x:%04x)",
+			 le16_to_cpu(udev->descriptor.idVendor),
+			 le16_to_cpu(udev->descriptor.idProduct));
+
+	/*
+	 * Add iFunction or iInterface to names when available as additional
+	 * distinguishers between interfaces. iFunction is prioritized over
+	 * iInterface which matches Windows behavior at the point of writing.
+	 */
+	if (intf->intf_assoc && intf->intf_assoc->iFunction != 0)
+		function = intf->intf_assoc->iFunction;
+	else
+		function = intf->cur_altsetting->desc.iInterface;
+	if (function != 0) {
+		size_t len;
+
+		strlcat(dev->name, ": ", sizeof(dev->name));
+		len = strlen(dev->name);
+		usb_string(udev, function, dev->name + len,
+			   sizeof(dev->name) - len);
+	}
 
 	/* Parse the Video Class control descriptor. */
 	if (uvc_parse_control(dev) < 0) {
-- 
Regards,

Laurent Pinchart
