Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:34681 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753810AbdDQXF4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 19:05:56 -0400
Received: by mail-qt0-f180.google.com with SMTP id c45so112495558qtb.1
        for <linux-media@vger.kernel.org>; Mon, 17 Apr 2017 16:05:56 -0700 (PDT)
From: =?UTF-8?q?Peter=20Bostr=C3=B6m?= <pbos@google.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        =?UTF-8?q?Peter=20Bostr=C3=B6m?= <pbos@google.com>
Subject: [PATCH v2] [media] uvcvideo: Add iFunction or iInterface to device names.
Date: Mon, 17 Apr 2017 19:05:42 -0400
Message-Id: <20170417230542.3724-1-pbos@google.com>
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
 drivers/media/usb/uvc/uvc_driver.c | 37 ++++++++++++++++++++++++++++++-------
 drivers/media/usb/uvc/uvcvideo.h   |  2 +-
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 04bf35063c4c..3a00313772a0 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1998,6 +1998,7 @@ static int uvc_probe(struct usb_interface *intf,
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct uvc_device *dev;
+	int additional_name;
 	int ret;
 
 	if (id->idVendor && id->idProduct)
@@ -2025,13 +2026,35 @@ static int uvc_probe(struct usb_interface *intf,
 	dev->quirks = (uvc_quirks_param == -1)
 		    ? id->driver_info : uvc_quirks_param;
 
-	if (udev->product != NULL)
-		strlcpy(dev->name, udev->product, sizeof dev->name);
-	else
-		snprintf(dev->name, sizeof dev->name,
-			"UVC Camera (%04x:%04x)",
-			le16_to_cpu(udev->descriptor.idVendor),
-			le16_to_cpu(udev->descriptor.idProduct));
+	strlcpy(dev->name, udev->product ? udev->product : "UVC Camera",
+		sizeof(dev->name));
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
+
+	/* Append descriptors to unknown UVC products. */
+	if (!udev->product) {
+		size_t len = strlen(dev->name);
+
+		snprintf(dev->name + len, sizeof(dev->name) - len,
+			 " (%04x:%04x)",
+			 le16_to_cpu(udev->descriptor.idVendor),
+			 le16_to_cpu(udev->descriptor.idProduct));
+	}
 
 	/* Parse the Video Class control descriptor. */
 	if (uvc_parse_control(dev) < 0) {
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 4205e7a423f0..905e40a90fa2 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -547,7 +547,7 @@ struct uvc_device {
 	unsigned long warnings;
 	__u32 quirks;
 	int intfnum;
-	char name[32];
+	char name[64];
 
 	struct mutex lock;		/* Protects users */
 	unsigned int users;
-- 
2.12.2.762.g0e3151a226-goog
