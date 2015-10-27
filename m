Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbbJ0LxP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 07:53:15 -0400
From: Oliver Neukum <oneukum@suse.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] usbvision fix overflow of interfaces array
Date: Tue, 27 Oct 2015 12:51:34 +0100
Message-Id: <1445946694-2931-1-git-send-email-oneukum@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the crash reported in:
http://seclists.org/bugtraq/2015/Oct/35
The interface number needs a sanity check.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index b693206..ad33d99 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1461,6 +1461,13 @@ static int usbvision_probe(struct usb_interface *intf,
 	printk(KERN_INFO "%s: %s found\n", __func__,
 				usbvision_device_data[model].model_string);
 
+	/*
+	 * this is a security check.
+	 * an exploit using an incorrect bInterfaceNumber is known
+	 */
+	if (ifnum >= USB_MAXINTERFACES || !dev->actconfig->interface[ifnum])
+		return -ENODEV;
+
 	if (usbvision_device_data[model].interface >= 0)
 		interface = &dev->actconfig->interface[usbvision_device_data[model].interface]->altsetting[0];
 	else
-- 
2.1.4

