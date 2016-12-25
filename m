Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:62144 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753345AbcLYSiJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:38:09 -0500
Subject: [PATCH 07/19] [media] uvc_driver: Rename a jump label in uvc_probe()
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <c30dc00f-467b-decc-6984-e504daba4128@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:37:59 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 10:54:15 +0100

Adjust jump labels according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 563b51d0b398..f91965d0da97 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2060,7 +2060,7 @@ static int uvc_probe(struct usb_interface *intf,
 	if (uvc_parse_control(dev) < 0) {
 		uvc_trace(UVC_TRACE_PROBE,
 			  "Unable to parse UVC descriptors.\n");
-		goto error;
+		goto unregister_video;
 	}
 
 	uvc_printk(KERN_INFO, "Found UVC %u.%02x device %s (%04x:%04x)\n",
@@ -2092,24 +2092,24 @@ static int uvc_probe(struct usb_interface *intf,
 	dev->vdev.mdev = &dev->mdev;
 #endif
 	if (v4l2_device_register(&intf->dev, &dev->vdev) < 0)
-		goto error;
+		goto unregister_video;
 
 	/* Initialize controls. */
 	if (uvc_ctrl_init_device(dev) < 0)
-		goto error;
+		goto unregister_video;
 
 	/* Scan the device for video chains. */
 	if (uvc_scan_device(dev) < 0)
-		goto error;
+		goto unregister_video;
 
 	/* Register video device nodes. */
 	if (uvc_register_chains(dev) < 0)
-		goto error;
+		goto unregister_video;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	/* Register the media device node */
 	if (media_device_register(&dev->mdev) < 0)
-		goto error;
+		goto unregister_video;
 #endif
 	/* Save our data pointer in the interface data. */
 	usb_set_intfdata(intf, dev);
@@ -2124,8 +2124,7 @@ static int uvc_probe(struct usb_interface *intf,
 	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
 	usb_enable_autosuspend(udev);
 	return 0;
-
-error:
+unregister_video:
 	uvc_unregister_video(dev);
 	return -ENODEV;
 }
-- 
2.11.0

