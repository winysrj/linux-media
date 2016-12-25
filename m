Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:51076 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751937AbcLYSfO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:35:14 -0500
Subject: [PATCH 05/19] [media] uvc_driver: Enclose 24 expressions for the
 sizeof operator by parentheses
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <1d99b8a4-9bba-8914-1bbc-311a0b71bd55@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:35:03 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 10:05:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

WARNING: sizeof … should be sizeof(…)

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 48 +++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 32d39404c1cb..c05ba4bdec2d 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -402,7 +402,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 
 		if (fmtdesc) {
 			strlcpy(format->name, fmtdesc->name,
-				sizeof format->name);
+				sizeof(format->name));
 			format->fcc = fmtdesc->fcc;
 		} else {
 			uvc_printk(KERN_INFO, "Unknown video format %pUl\n",
@@ -445,7 +445,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		strlcpy(format->name, "MJPEG", sizeof format->name);
+		strlcpy(format->name, "MJPEG", sizeof(format->name));
 		format->fcc = V4L2_PIX_FMT_MJPEG;
 		format->flags = UVC_FMT_FLAG_COMPRESSED;
 		format->bpp = 0;
@@ -463,13 +463,13 @@ static int uvc_parse_format(struct uvc_device *dev,
 
 		switch (buffer[8] & 0x7f) {
 		case 0:
-			strlcpy(format->name, "SD-DV", sizeof format->name);
+			strlcpy(format->name, "SD-DV", sizeof(format->name));
 			break;
 		case 1:
-			strlcpy(format->name, "SDL-DV", sizeof format->name);
+			strlcpy(format->name, "SDL-DV", sizeof(format->name));
 			break;
 		case 2:
-			strlcpy(format->name, "HD-DV", sizeof format->name);
+			strlcpy(format->name, "HD-DV", sizeof(format->name));
 			break;
 		default:
 			uvc_trace(UVC_TRACE_DESCR,
@@ -480,7 +480,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 		}
 
 		strlcat(format->name, buffer[8] & (1 << 7) ? " 60Hz" : " 50Hz",
-			sizeof format->name);
+			sizeof(format->name));
 
 		format->fcc = V4L2_PIX_FMT_DV;
 		format->flags = UVC_FMT_FLAG_COMPRESSED | UVC_FMT_FLAG_STREAM;
@@ -489,7 +489,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 
 		/* Create a dummy frame descriptor. */
 		frame = &format->frame[0];
-		memset(&format->frame[0], 0, sizeof format->frame[0]);
+		memset(&format->frame[0], 0, sizeof(format->frame[0]));
 		frame->bFrameIntervalType = 1;
 		frame->dwDefaultFrameInterval = 1;
 		frame->dwFrameInterval = *intervals;
@@ -660,7 +660,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		return -EINVAL;
 	}
 
-	streaming = kzalloc(sizeof *streaming, GFP_KERNEL);
+	streaming = kzalloc(sizeof(*streaming), GFP_KERNEL);
 	if (!streaming) {
 		usb_driver_release_interface(&uvc_driver.driver, intf);
 		return -EINVAL;
@@ -812,8 +812,8 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		goto error;
 	}
 
-	size = nformats * sizeof *format + nframes * sizeof *frame
-	     + nintervals * sizeof *interval;
+	size = nformats * sizeof(*format) + nframes * sizeof(*frame)
+	       + nintervals * sizeof(*interval);
 	format = kzalloc(size, GFP_KERNEL);
 	if (!format) {
 		ret = -ENOMEM;
@@ -989,7 +989,7 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 
 		if (buffer[24+p+2*n] != 0)
 			usb_string(udev, buffer[24+p+2*n], unit->name,
-				   sizeof unit->name);
+				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
@@ -1089,7 +1089,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA) {
 			term->camera.bControlSize = n;
-			term->camera.bmControls = (__u8 *)term + sizeof *term;
+			term->camera.bmControls = (__u8 *)term + sizeof(*term);
 			term->camera.wObjectiveFocalLengthMin =
 				get_unaligned_le16(&buffer[8]);
 			term->camera.wObjectiveFocalLengthMax =
@@ -1100,17 +1100,17 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		} else if (UVC_ENTITY_TYPE(term) ==
 			   UVC_ITT_MEDIA_TRANSPORT_INPUT) {
 			term->media.bControlSize = n;
-			term->media.bmControls = (__u8 *)term + sizeof *term;
+			term->media.bmControls = (__u8 *)term + sizeof(*term);
 			term->media.bTransportModeSize = p;
 			term->media.bmTransportModes = (__u8 *)term
-						     + sizeof *term + n;
+						       + sizeof(*term) + n;
 			memcpy(term->media.bmControls, &buffer[9], n);
 			memcpy(term->media.bmTransportModes, &buffer[10+n], p);
 		}
 
 		if (buffer[7] != 0)
 			usb_string(udev, buffer[7], term->name,
-				   sizeof term->name);
+				   sizeof(term->name));
 		else if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA)
 			sprintf(term->name, "Camera %u", buffer[3]);
 		else if (UVC_ENTITY_TYPE(term) == UVC_ITT_MEDIA_TRANSPORT_INPUT)
@@ -1152,7 +1152,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		if (buffer[8] != 0)
 			usb_string(udev, buffer[8], term->name,
-				   sizeof term->name);
+				   sizeof(term->name));
 		else
 			sprintf(term->name, "Output %u", buffer[3]);
 
@@ -1177,7 +1177,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		if (buffer[5+p] != 0)
 			usb_string(udev, buffer[5+p], unit->name,
-				   sizeof unit->name);
+				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Selector %u", buffer[3]);
 
@@ -1203,14 +1203,14 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		unit->processing.wMaxMultiplier =
 			get_unaligned_le16(&buffer[5]);
 		unit->processing.bControlSize = buffer[7];
-		unit->processing.bmControls = (__u8 *)unit + sizeof *unit;
+		unit->processing.bmControls = (__u8 *)unit + sizeof(*unit);
 		memcpy(unit->processing.bmControls, &buffer[8], n);
 		if (dev->uvc_version >= 0x0110)
 			unit->processing.bmVideoStandards = buffer[9+n];
 
 		if (buffer[8+n] != 0)
 			usb_string(udev, buffer[8+n], unit->name,
-				   sizeof unit->name);
+				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Processing %u", buffer[3]);
 
@@ -1236,12 +1236,12 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		unit->extension.bNumControls = buffer[20];
 		memcpy(unit->baSourceID, &buffer[22], p);
 		unit->extension.bControlSize = buffer[22+p];
-		unit->extension.bmControls = (__u8 *)unit + sizeof *unit;
+		unit->extension.bmControls = (__u8 *)unit + sizeof(*unit);
 		memcpy(unit->extension.bmControls, &buffer[23+p], n);
 
 		if (buffer[23+p+n] != 0)
 			usb_string(udev, buffer[23+p+n], unit->name,
-				   sizeof unit->name);
+				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
@@ -1932,7 +1932,7 @@ static int uvc_register_video(struct uvc_device *dev,
 	vdev->prio = &stream->chain->prio;
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		vdev->vfl_dir = VFL_DIR_TX;
-	strlcpy(vdev->name, dev->name, sizeof vdev->name);
+	strlcpy(vdev->name, dev->name, sizeof(vdev->name));
 
 	/* Set the driver data before calling video_register_device, otherwise
 	 * uvc_v4l2_open might race us.
@@ -2049,9 +2049,9 @@ static int uvc_probe(struct usb_interface *intf,
 		    ? id->driver_info : uvc_quirks_param;
 
 	if (udev->product)
-		strlcpy(dev->name, udev->product, sizeof dev->name);
+		strlcpy(dev->name, udev->product, sizeof(dev->name));
 	else
-		snprintf(dev->name, sizeof dev->name,
+		snprintf(dev->name, sizeof(dev->name),
 			"UVC Camera (%04x:%04x)",
 			le16_to_cpu(udev->descriptor.idVendor),
 			le16_to_cpu(udev->descriptor.idProduct));
-- 
2.11.0

