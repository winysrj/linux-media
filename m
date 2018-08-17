Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:37806 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbeHQMS7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 08:18:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: chf.fritz@googlemail.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Norbert Wesp <n.wesp@phytec.de>,
        Dirk Bender <D.bender@phytec.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] media: uvcvideo: Store device information pointer in struct uvc_device
Date: Fri, 17 Aug 2018 12:17:08 +0300
Message-Id: <20180817091708.17934-1-laurent.pinchart@ideasonboard.com>
In-Reply-To: <59022590.4QMSz7CzYA@avalon>
References: <59022590.4QMSz7CzYA@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device information structure is currently copied field by field in
the uvc_device structure. As we only have two fields at the moment this
isn't much of an issue, but it prevents easy addition of new info
fields.

Fix this by storing the uvc_device_info pointer in the uvc_device
structure. As a result the uvc_device meta_format field can be removed.
The quirks field, however, needs to stay as it can be modified through a
module parameter.

As not all device have an information structure, we declare a global
"NULL" info instance that is used as a fallback when the driver_info is
empty.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c   | 15 +++++----------
 drivers/media/usb/uvc/uvc_metadata.c |  7 ++++---
 drivers/media/usb/uvc/uvcvideo.h     |  8 +++++++-
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 21b0270067c1..232da625faad 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2040,10 +2040,7 @@ static int uvc_register_chains(struct uvc_device *dev)
  * USB probe, disconnect, suspend and resume
  */
 
-struct uvc_device_info {
-	u32	quirks;
-	u32	meta_format;
-};
+static const struct uvc_device_info uvc_quirk_none = { 0 };
 
 static int uvc_probe(struct usb_interface *intf,
 		     const struct usb_device_id *id)
@@ -2052,7 +2049,6 @@ static int uvc_probe(struct usb_interface *intf,
 	struct uvc_device *dev;
 	const struct uvc_device_info *info =
 		(const struct uvc_device_info *)id->driver_info;
-	u32 quirks = info ? info->quirks : 0;
 	int function;
 	int ret;
 
@@ -2079,10 +2075,9 @@ static int uvc_probe(struct usb_interface *intf,
 	dev->udev = usb_get_dev(udev);
 	dev->intf = usb_get_intf(intf);
 	dev->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
-	dev->quirks = (uvc_quirks_param == -1)
-		    ? quirks : uvc_quirks_param;
-	if (info)
-		dev->meta_format = info->meta_format;
+	dev->info = info ? info : &uvc_quirk_none;
+	dev->quirks = uvc_quirks_param == -1
+		    ? dev->info->quirks : uvc_quirks_param;
 
 	if (udev->product != NULL)
 		strlcpy(dev->name, udev->product, sizeof(dev->name));
@@ -2123,7 +2118,7 @@ static int uvc_probe(struct usb_interface *intf,
 		le16_to_cpu(udev->descriptor.idVendor),
 		le16_to_cpu(udev->descriptor.idProduct));
 
-	if (dev->quirks != quirks) {
+	if (dev->quirks != dev->info->quirks) {
 		uvc_printk(KERN_INFO, "Forcing device quirks to 0x%x by module "
 			"parameter for testing purpose.\n", dev->quirks);
 		uvc_printk(KERN_INFO, "Please report required quirks to the "
diff --git a/drivers/media/usb/uvc/uvc_metadata.c b/drivers/media/usb/uvc/uvc_metadata.c
index cd1aec19cc5b..ed0f0c0732cb 100644
--- a/drivers/media/usb/uvc/uvc_metadata.c
+++ b/drivers/media/usb/uvc/uvc_metadata.c
@@ -74,7 +74,8 @@ static int uvc_meta_v4l2_try_format(struct file *file, void *fh,
 
 	memset(fmt, 0, sizeof(*fmt));
 
-	fmt->dataformat = fmeta == dev->meta_format ? fmeta : V4L2_META_FMT_UVC;
+	fmt->dataformat = fmeta == dev->info->meta_format
+			? fmeta : V4L2_META_FMT_UVC;
 	fmt->buffersize = UVC_METATADA_BUF_SIZE;
 
 	return 0;
@@ -118,14 +119,14 @@ static int uvc_meta_v4l2_enum_formats(struct file *file, void *fh,
 	u32 index = fdesc->index;
 
 	if (fdesc->type != vfh->vdev->queue->type ||
-	    index > 1U || (index && !dev->meta_format))
+	    index > 1U || (index && !dev->info->meta_format))
 		return -EINVAL;
 
 	memset(fdesc, 0, sizeof(*fdesc));
 
 	fdesc->type = vfh->vdev->queue->type;
 	fdesc->index = index;
-	fdesc->pixelformat = index ? dev->meta_format : V4L2_META_FMT_UVC;
+	fdesc->pixelformat = index ? dev->info->meta_format : V4L2_META_FMT_UVC;
 
 	return 0;
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 59d66e5b8887..591eae3d0b0d 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -572,15 +572,21 @@ struct uvc_streaming {
 	} clock;
 };
 
+struct uvc_device_info {
+	u32	quirks;
+	u32	meta_format;
+};
+
 struct uvc_device {
 	struct usb_device *udev;
 	struct usb_interface *intf;
 	unsigned long warnings;
 	u32 quirks;
-	u32 meta_format;
 	int intfnum;
 	char name[32];
 
+	const struct uvc_device_info *info;
+
 	struct mutex lock;		/* Protects users */
 	unsigned int users;
 	atomic_t nmappings;
-- 
Regards,

Laurent Pinchart
