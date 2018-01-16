Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41403 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeAPVHL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 16:07:11 -0500
Received: from avalon.bb.dnainternet.fi (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 02637208A5
        for <linux-media@vger.kernel.org>; Tue, 16 Jan 2018 22:06:16 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] uvcvideo: Use parentheses around sizeof operand
Date: Tue, 16 Jan 2018 23:07:07 +0200
Message-Id: <20180116210707.7727-5-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20180116210707.7727-1-laurent.pinchart@ideasonboard.com>
References: <20180116210707.7727-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the sizeof is an operator and not a function, the preferred coding
style in the kernel is to enclose its operand in parentheses. To avoid
mixing multiple coding styles in the driver, use parentheses around all
sizeof operands.

While at it replace a kmalloc() with a kmalloc_array() to silence a
checkpatch warning triggered by this patch.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c   |  6 ++---
 drivers/media/usb/uvc/uvc_driver.c | 53 +++++++++++++++++++-------------------
 drivers/media/usb/uvc/uvc_v4l2.c   | 12 ++++-----
 drivers/media/usb/uvc/uvc_video.c  |  2 +-
 4 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 723c517474fc..102594ec3e97 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1019,10 +1019,10 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	struct uvc_menu_info *menu;
 	unsigned int i;
 
-	memset(v4l2_ctrl, 0, sizeof *v4l2_ctrl);
+	memset(v4l2_ctrl, 0, sizeof(*v4l2_ctrl));
 	v4l2_ctrl->id = mapping->id;
 	v4l2_ctrl->type = mapping->v4l2_type;
-	strlcpy(v4l2_ctrl->name, mapping->name, sizeof v4l2_ctrl->name);
+	strlcpy(v4l2_ctrl->name, mapping->name, sizeof(v4l2_ctrl->name));
 	v4l2_ctrl->flags = 0;
 
 	if (!(ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR))
@@ -1182,7 +1182,7 @@ int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
 		}
 	}
 
-	strlcpy(query_menu->name, menu_info->name, sizeof query_menu->name);
+	strlcpy(query_menu->name, menu_info->name, sizeof(query_menu->name));
 
 done:
 	mutex_unlock(&chain->ctrl_mutex);
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 718c3fcde287..2469b49b2b30 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -274,7 +274,7 @@ void uvc_simplify_fraction(u32 *numerator, u32 *denominator,
 	u32 x, y, r;
 	unsigned int i, n;
 
-	an = kmalloc(n_terms * sizeof *an, GFP_KERNEL);
+	an = kmalloc_array(n_terms, sizeof(*an), GFP_KERNEL);
 	if (an == NULL)
 		return;
 
@@ -423,7 +423,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 
 		if (fmtdesc != NULL) {
 			strlcpy(format->name, fmtdesc->name,
-				sizeof format->name);
+				sizeof(format->name));
 			format->fcc = fmtdesc->fcc;
 		} else {
 			uvc_printk(KERN_INFO, "Unknown video format %pUl\n",
@@ -466,7 +466,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		strlcpy(format->name, "MJPEG", sizeof format->name);
+		strlcpy(format->name, "MJPEG", sizeof(format->name));
 		format->fcc = V4L2_PIX_FMT_MJPEG;
 		format->flags = UVC_FMT_FLAG_COMPRESSED;
 		format->bpp = 0;
@@ -484,13 +484,13 @@ static int uvc_parse_format(struct uvc_device *dev,
 
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
 			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
@@ -501,7 +501,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 		}
 
 		strlcat(format->name, buffer[8] & (1 << 7) ? " 60Hz" : " 50Hz",
-			sizeof format->name);
+			sizeof(format->name));
 
 		format->fcc = V4L2_PIX_FMT_DV;
 		format->flags = UVC_FMT_FLAG_COMPRESSED | UVC_FMT_FLAG_STREAM;
@@ -510,7 +510,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 
 		/* Create a dummy frame descriptor. */
 		frame = &format->frame[0];
-		memset(&format->frame[0], 0, sizeof format->frame[0]);
+		memset(&format->frame[0], 0, sizeof(format->frame[0]));
 		frame->bFrameIntervalType = 1;
 		frame->dwDefaultFrameInterval = 1;
 		frame->dwFrameInterval = *intervals;
@@ -677,7 +677,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		return -EINVAL;
 	}
 
-	streaming = kzalloc(sizeof *streaming, GFP_KERNEL);
+	streaming = kzalloc(sizeof(*streaming), GFP_KERNEL);
 	if (streaming == NULL) {
 		usb_driver_release_interface(&uvc_driver.driver, intf);
 		return -EINVAL;
@@ -827,8 +827,8 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		goto error;
 	}
 
-	size = nformats * sizeof *format + nframes * sizeof *frame
-	     + nintervals * sizeof *interval;
+	size = nformats * sizeof(*format) + nframes * sizeof(*frame)
+	     + nintervals * sizeof(*interval);
 	format = kzalloc(size, GFP_KERNEL);
 	if (format == NULL) {
 		ret = -ENOMEM;
@@ -1002,7 +1002,7 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 
 		if (buffer[24+p+2*n] != 0)
 			usb_string(udev, buffer[24+p+2*n], unit->name,
-				   sizeof unit->name);
+				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
@@ -1101,7 +1101,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA) {
 			term->camera.bControlSize = n;
-			term->camera.bmControls = (u8 *)term + sizeof *term;
+			term->camera.bmControls = (u8 *)term + sizeof(*term);
 			term->camera.wObjectiveFocalLengthMin =
 				get_unaligned_le16(&buffer[8]);
 			term->camera.wObjectiveFocalLengthMax =
@@ -1112,17 +1112,17 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		} else if (UVC_ENTITY_TYPE(term) ==
 			   UVC_ITT_MEDIA_TRANSPORT_INPUT) {
 			term->media.bControlSize = n;
-			term->media.bmControls = (u8 *)term + sizeof *term;
+			term->media.bmControls = (u8 *)term + sizeof(*term);
 			term->media.bTransportModeSize = p;
 			term->media.bmTransportModes = (u8 *)term
-						     + sizeof *term + n;
+						     + sizeof(*term) + n;
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
@@ -1162,7 +1162,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		if (buffer[8] != 0)
 			usb_string(udev, buffer[8], term->name,
-				   sizeof term->name);
+				   sizeof(term->name));
 		else
 			sprintf(term->name, "Output %u", buffer[3]);
 
@@ -1187,7 +1187,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		if (buffer[5+p] != 0)
 			usb_string(udev, buffer[5+p], unit->name,
-				   sizeof unit->name);
+				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Selector %u", buffer[3]);
 
@@ -1213,14 +1213,14 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		unit->processing.wMaxMultiplier =
 			get_unaligned_le16(&buffer[5]);
 		unit->processing.bControlSize = buffer[7];
-		unit->processing.bmControls = (u8 *)unit + sizeof *unit;
+		unit->processing.bmControls = (u8 *)unit + sizeof(*unit);
 		memcpy(unit->processing.bmControls, &buffer[8], n);
 		if (dev->uvc_version >= 0x0110)
 			unit->processing.bmVideoStandards = buffer[9+n];
 
 		if (buffer[8+n] != 0)
 			usb_string(udev, buffer[8+n], unit->name,
-				   sizeof unit->name);
+				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Processing %u", buffer[3]);
 
@@ -1246,12 +1246,12 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		unit->extension.bNumControls = buffer[20];
 		memcpy(unit->baSourceID, &buffer[22], p);
 		unit->extension.bControlSize = buffer[22+p];
-		unit->extension.bmControls = (u8 *)unit + sizeof *unit;
+		unit->extension.bmControls = (u8 *)unit + sizeof(*unit);
 		memcpy(unit->extension.bmControls, &buffer[23+p], n);
 
 		if (buffer[23+p+n] != 0)
 			usb_string(udev, buffer[23+p+n], unit->name,
-				   sizeof unit->name);
+				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
@@ -1936,7 +1936,7 @@ int uvc_register_video_device(struct uvc_device *dev,
 		break;
 	}
 
-	strlcpy(vdev->name, dev->name, sizeof vdev->name);
+	strlcpy(vdev->name, dev->name, sizeof(vdev->name));
 
 	/*
 	 * Set the driver data before calling video_register_device, otherwise
@@ -2070,7 +2070,8 @@ static int uvc_probe(struct usb_interface *intf,
 				udev->devpath);
 
 	/* Allocate memory for the device and initialize it. */
-	if ((dev = kzalloc(sizeof *dev, GFP_KERNEL)) == NULL)
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&dev->entities);
@@ -2089,9 +2090,9 @@ static int uvc_probe(struct usb_interface *intf,
 		dev->meta_format = info->meta_format;
 
 	if (udev->product != NULL)
-		strlcpy(dev->name, udev->product, sizeof dev->name);
+		strlcpy(dev->name, udev->product, sizeof(dev->name));
 	else
-		snprintf(dev->name, sizeof dev->name,
+		snprintf(dev->name, sizeof(dev->name),
 			 "UVC Camera (%04x:%04x)",
 			 le16_to_cpu(udev->descriptor.idVendor),
 			 le16_to_cpu(udev->descriptor.idProduct));
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index c70091db9c0c..a8b51aabc70b 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -40,13 +40,13 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 	unsigned int size;
 	int ret;
 
-	map = kzalloc(sizeof *map, GFP_KERNEL);
+	map = kzalloc(sizeof(*map), GFP_KERNEL);
 	if (map == NULL)
 		return -ENOMEM;
 
 	map->id = xmap->id;
-	memcpy(map->name, xmap->name, sizeof map->name);
-	memcpy(map->entity, xmap->entity, sizeof map->entity);
+	memcpy(map->name, xmap->name, sizeof(map->name));
+	memcpy(map->entity, xmap->entity, sizeof(map->entity));
 	map->selector = xmap->selector;
 	map->size = xmap->size;
 	map->offset = xmap->offset;
@@ -224,7 +224,7 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 		(100000000/interval)%10);
 
 	/* Set the format index, frame index and frame interval. */
-	memset(probe, 0, sizeof *probe);
+	memset(probe, 0, sizeof(*probe));
 	probe->bmHint = 1;	/* dwFrameInterval */
 	probe->bFormatIndex = format->index;
 	probe->bFrameIndex = frame->bFrameIndex;
@@ -348,7 +348,7 @@ static int uvc_v4l2_get_streamparm(struct uvc_streaming *stream,
 	denominator = 10000000;
 	uvc_simplify_fraction(&numerator, &denominator, 8, 333);
 
-	memset(parm, 0, sizeof *parm);
+	memset(parm, 0, sizeof(*parm));
 	parm->type = stream->type;
 
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
@@ -526,7 +526,7 @@ static int uvc_v4l2_open(struct file *file)
 		return ret;
 
 	/* Create the device handle. */
-	handle = kzalloc(sizeof *handle, GFP_KERNEL);
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
 	if (handle == NULL) {
 		usb_autopm_put_interface(stream->dev->intf);
 		return -ENOMEM;
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index dfe13c55a067..2ddb1367e195 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -191,7 +191,7 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 		uvc_warn_once(stream->dev, UVC_WARN_MINMAX, "UVC non "
 			"compliance - GET_MIN/MAX(PROBE) incorrectly "
 			"supported. Enabling workaround.\n");
-		memset(ctrl, 0, sizeof *ctrl);
+		memset(ctrl, 0, sizeof(*ctrl));
 		ctrl->wCompQuality = le16_to_cpup((__le16 *)data);
 		ret = 0;
 		goto out;
-- 
Regards,

Laurent Pinchart
