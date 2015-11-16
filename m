Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbbKPRzs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 12:55:48 -0500
From: Vladis Dronov <vdronov@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH 1/1] [media] usbvision: fix crash on detecting device with invalid configuration
Date: Mon, 16 Nov 2015 18:55:11 +0100
Message-Id: <1447696511-17704-2-git-send-email-vdronov@redhat.com>
In-Reply-To: <1447696511-17704-1-git-send-email-vdronov@redhat.com>
References: <1447696511-17704-1-git-send-email-vdronov@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The usbvision driver crashes when a specially crafted usb device with invalid
number of interfaces or endpoints is detected. This fix adds checks that the
device has proper configuration expected by the driver.

Reported-by: Ralf Spenneberg <ralf@spenneberg.net>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index b693206..d1dc1a1 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1463,9 +1463,23 @@ static int usbvision_probe(struct usb_interface *intf,
 
 	if (usbvision_device_data[model].interface >= 0)
 		interface = &dev->actconfig->interface[usbvision_device_data[model].interface]->altsetting[0];
-	else
+	else if (ifnum < dev->actconfig->desc.bNumInterfaces)
 		interface = &dev->actconfig->interface[ifnum]->altsetting[0];
+	else {
+		dev_err(&intf->dev, "interface %d is invalid, max is %d\n",
+		    ifnum, dev->actconfig->desc.bNumInterfaces - 1);
+		ret = -ENODEV;
+		goto err_usb;
+	}
+
+	if (interface->desc.bNumEndpoints < 2) {
+		dev_err(&intf->dev, "interface %d has %d endpoints, but must"
+		    " have minimum 2\n", ifnum, interface->desc.bNumEndpoints);
+		ret = -ENODEV;
+		goto err_usb;
+	}
 	endpoint = &interface->endpoint[1].desc;
+
 	if (!usb_endpoint_xfer_isoc(endpoint)) {
 		dev_err(&intf->dev, "%s: interface %d. has non-ISO endpoint!\n",
 		    __func__, ifnum);
-- 
2.6.2

