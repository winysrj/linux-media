Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:59128 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751937AbcLYScW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:32:22 -0500
Subject: [PATCH 03/19] [media] uvc_driver: Adjust three function calls
 together with a variable assignment
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5d6e7fac-d464-687b-ef87-d813d707911f@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:32:12 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 08:05:58 +0100

The script "checkpatch.pl" pointed information out like the following.

ERROR: do not use assignment in if condition

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 7c42be2414ea..bddaf98ef828 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1275,7 +1275,8 @@ static int uvc_parse_control(struct uvc_device *dev)
 		    buffer[1] != USB_DT_CS_INTERFACE)
 			goto next_descriptor;
 
-		if ((ret = uvc_parse_standard_control(dev, buffer, buflen)) < 0)
+		ret = uvc_parse_standard_control(dev, buffer, buflen);
+		if (ret < 0)
 			return ret;
 
 next_descriptor:
@@ -2030,7 +2031,8 @@ static int uvc_probe(struct usb_interface *intf,
 				udev->devpath);
 
 	/* Allocate memory for the device and initialize it. */
-	if ((dev = kzalloc(sizeof *dev, GFP_KERNEL)) == NULL)
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&dev->entities);
@@ -2113,11 +2115,11 @@ static int uvc_probe(struct usb_interface *intf,
 	usb_set_intfdata(intf, dev);
 
 	/* Initialize the interrupt URB. */
-	if ((ret = uvc_status_init(dev)) < 0) {
+	ret = uvc_status_init(dev);
+	if (ret < 0)
 		uvc_printk(KERN_INFO,
 			   "Unable to initialize the status endpoint (%d), status interrupt will not be supported.\n",
 			   ret);
-	}
 
 	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
 	usb_enable_autosuspend(udev);
-- 
2.11.0

