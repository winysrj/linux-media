Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:36829 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753506AbdDFR6n (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 13:58:43 -0400
Received: by mail-qt0-f176.google.com with SMTP id r45so42768850qte.3
        for <linux-media@vger.kernel.org>; Thu, 06 Apr 2017 10:58:41 -0700 (PDT)
From: =?UTF-8?q?Peter=20Bostr=C3=B6m?= <pbos@google.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Peter=20Bostr=C3=B6m?= <pbos@google.com>
Subject: [PATCH] [media] uvcvideo: Add iFunction or iInterface to device names.
Date: Thu,  6 Apr 2017 13:58:25 -0400
Message-Id: <20170406175825.90406-1-pbos@google.com>
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
 drivers/media/usb/uvc/uvc_driver.c | 43 +++++++++++++++++++++++++++++++-------
 drivers/media/usb/uvc/uvcvideo.h   |  4 +++-
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 04bf35063c4c..66adf8a77e56 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1998,6 +1998,8 @@ static int uvc_probe(struct usb_interface *intf,
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct uvc_device *dev;
+	char additional_name_buf[UVC_DEVICE_NAME_SIZE];
+	const char *additional_name = NULL;
 	int ret;
 
 	if (id->idVendor && id->idProduct)
@@ -2025,13 +2027,40 @@ static int uvc_probe(struct usb_interface *intf,
 	dev->quirks = (uvc_quirks_param == -1)
 		    ? id->driver_info : uvc_quirks_param;
 
-	if (udev->product != NULL)
-		strlcpy(dev->name, udev->product, sizeof dev->name);
-	else
-		snprintf(dev->name, sizeof dev->name,
-			"UVC Camera (%04x:%04x)",
-			le16_to_cpu(udev->descriptor.idVendor),
-			le16_to_cpu(udev->descriptor.idProduct));
+	/*
+	 * Add iFunction or iInterface to names when available as additional
+	 * distinguishers between interfaces. iFunction is prioritized over
+	 * iInterface which matches Windows behavior at the point of writing.
+	 */
+	if (intf->intf_assoc && intf->intf_assoc->iFunction != 0) {
+		usb_string(udev, intf->intf_assoc->iFunction,
+			   additional_name_buf, sizeof(additional_name_buf));
+		additional_name = additional_name_buf;
+	} else if (intf->cur_altsetting->desc.iInterface != 0) {
+		usb_string(udev, intf->cur_altsetting->desc.iInterface,
+			   additional_name_buf, sizeof(additional_name_buf));
+		additional_name = additional_name_buf;
+	}
+
+	if (additional_name) {
+		if (udev->product) {
+			snprintf(dev->name, sizeof(dev->name), "%s: %s",
+				 udev->product, additional_name);
+		} else {
+			snprintf(dev->name, sizeof(dev->name),
+				 "UVC Camera: %s (%04x:%04x)",
+				 additional_name,
+				 le16_to_cpu(udev->descriptor.idVendor),
+				 le16_to_cpu(udev->descriptor.idProduct));
+		}
+	} else if (udev->product) {
+		strlcpy(dev->name, udev->product, sizeof(dev->name));
+	} else {
+		snprintf(dev->name, sizeof(dev->name),
+			 "UVC Camera (%04x:%04x)",
+			 le16_to_cpu(udev->descriptor.idVendor),
+			 le16_to_cpu(udev->descriptor.idProduct));
+	}
 
 	/* Parse the Video Class control descriptor. */
 	if (uvc_parse_control(dev) < 0) {
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 4205e7a423f0..0cbedaee6e19 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -541,13 +541,15 @@ struct uvc_streaming {
 	} clock;
 };
 
+#define UVC_DEVICE_NAME_SIZE	64
+
 struct uvc_device {
 	struct usb_device *udev;
 	struct usb_interface *intf;
 	unsigned long warnings;
 	__u32 quirks;
 	int intfnum;
-	char name[32];
+	char name[UVC_DEVICE_NAME_SIZE];
 
 	struct mutex lock;		/* Protects users */
 	unsigned int users;
-- 
2.12.2.715.g7642488e1d-goog
