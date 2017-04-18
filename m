Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:34682 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753042AbdDRRZG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 13:25:06 -0400
Received: by mail-qt0-f182.google.com with SMTP id c45so131059039qtb.1
        for <linux-media@vger.kernel.org>; Tue, 18 Apr 2017 10:25:06 -0700 (PDT)
From: =?UTF-8?q?Peter=20Bostr=C3=B6m?= <pbos@google.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        =?UTF-8?q?Peter=20Bostr=C3=B6m?= <pbos@google.com>
Subject: [PATCH v3] [media] uvcvideo: Add iFunction or iInterface to device names.
Date: Tue, 18 Apr 2017 13:24:54 -0400
Message-Id: <20170418172454.24465-1-pbos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Permits distinguishing between two /dev/videoX entries from the same
physical UVC device (that naturally share the same iProduct name).

This change matches current Windows behavior by prioritizing iFunction
over iInterface, but unlike Windows it displays both iProduct and
iFunction/iInterface strings when both are available.

Signed-off-by: Peter Boström <pbos@google.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 04bf35063c4c..5676d916933d 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1998,6 +1998,7 @@ static int uvc_probe(struct usb_interface *intf,
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct uvc_device *dev;
+	int additional_name;
 	int ret;
 
 	if (id->idVendor && id->idProduct)
@@ -2029,9 +2030,26 @@ static int uvc_probe(struct usb_interface *intf,
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
+	additional_name = intf->cur_altsetting->desc.iInterface;
+	if (intf->intf_assoc && intf->intf_assoc->iFunction != 0)
+		additional_name = intf->intf_assoc->iFunction;
+	if (additional_name != 0) {
+		size_t len;
+
+		strlcat(dev->name, ": ", sizeof(dev->name));
+		len = strlen(dev->name);
+		usb_string(udev, additional_name, dev->name + len,
+			   sizeof(dev->name) - len);
+	}
 
 	/* Parse the Video Class control descriptor. */
 	if (uvc_parse_control(dev) < 0) {
-- 
2.12.2.816.g2cccc81164-goog
