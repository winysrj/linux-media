Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50577 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbdHZUvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 16:51:00 -0400
Subject: [PATCH 2/3] [media] usbvision: Adjust eight checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Johan Hovold <johan@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f72f836e-6cab-8b79-9d87-a79bd62be174@users.sourceforge.net>
Message-ID: <0a1d8712-5b0d-d453-88a1-b39556c9d09d@users.sourceforge.net>
Date: Sat, 26 Aug 2017 22:50:34 +0200
MIME-Version: 1.0
In-Reply-To: <f72f836e-6cab-8b79-9d87-a79bd62be174@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 26 Aug 2017 22:16:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/usbvision/usbvision-video.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index b74fb2dcb6f5..e6807bad9792 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -904,7 +904,7 @@ static ssize_t usbvision_read(struct file *file, char __user *buf,
 	PDEBUG(DBG_IO, "%s: %ld bytes, noblock=%d", __func__,
 	       (unsigned long)count, noblock);
 
-	if (!USBVISION_IS_OPERATIONAL(usbvision) || (buf == NULL))
+	if (!USBVISION_IS_OPERATIONAL(usbvision) || !buf)
 		return -EFAULT;
 
 	/* This entry point is compatible with the mmap routines
@@ -1234,7 +1234,7 @@ static void usbvision_vdev_init(struct usb_usbvision *usbvision,
 {
 	struct usb_device *usb_dev = usbvision->dev;
 
-	if (usb_dev == NULL) {
+	if (!usb_dev) {
 		dev_err(&usbvision->dev->dev,
 			"%s: usbvision->dev is not set\n", __func__);
 		return;
@@ -1323,4 +1323,4 @@ static struct usb_usbvision *usbvision_alloc(struct usb_device *dev,
-	if (usbvision == NULL)
+	if (!usbvision)
 		return NULL;
 
 	usbvision->dev = dev;
@@ -1334,7 +1334,7 @@ static struct usb_usbvision *usbvision_alloc(struct usb_device *dev,
 
 	/* prepare control urb for control messages during interrupts */
 	usbvision->ctrl_urb = usb_alloc_urb(USBVISION_URB_FRAMES, GFP_KERNEL);
-	if (usbvision->ctrl_urb == NULL)
+	if (!usbvision->ctrl_urb)
 		goto err_unreg;
 
 	return usbvision;
@@ -1380,7 +1380,7 @@ static void usbvision_configure_video(struct usb_usbvision *usbvision)
 {
 	int model;
 
-	if (usbvision == NULL)
+	if (!usbvision)
 		return;
 
 	model = usbvision->dev_model;
@@ -1474,7 +1474,7 @@ static int usbvision_probe(struct usb_interface *intf,
 	}
 
 	usbvision = usbvision_alloc(dev, intf);
-	if (usbvision == NULL) {
+	if (!usbvision) {
 		dev_err(&intf->dev, "%s: couldn't allocate USBVision struct\n", __func__);
 		ret = -ENOMEM;
 		goto err_usb;
@@ -1494,5 +1494,5 @@ static int usbvision_probe(struct usb_interface *intf,
 	usbvision->num_alt = uif->num_altsetting;
 	PDEBUG(DBG_PROBE, "Alternate settings: %i", usbvision->num_alt);
 	usbvision->alt_max_pkt_size = kmalloc(32 * usbvision->num_alt, GFP_KERNEL);
-	if (usbvision->alt_max_pkt_size == NULL) {
+	if (!usbvision->alt_max_pkt_size) {
 		ret = -ENOMEM;
@@ -1565,7 +1565,7 @@ static void usbvision_disconnect(struct usb_interface *intf)
 
 	PDEBUG(DBG_PROBE, "");
 
-	if (usbvision == NULL) {
+	if (!usbvision) {
 		pr_err("%s: usb_get_intfdata() failed\n", __func__);
 		return;
 	}
-- 
2.14.0
