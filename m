Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50825 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZGVSAG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 14:00:06 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] uvcvideo: Multiple streaming interfaces support
Date: Wed, 22 Jul 2009 20:00:06 +0200
Cc: linux-uvc-devel@lists.berlios.de,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200907221958.12027.laurent.pinchart@skynet.be>
In-Reply-To: <200907221958.12027.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907222000.06959.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Restructure the UVC descriptors parsing code to handle multiple streaming
interfaces. The driver now creates a uvc_video_chain instance for each chain
detected in the UVC control interface descriptors, and tries to register one
video device per streaming endpoint.

Priority: normal

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>

diff -r ecc9128d8b6f linux/drivers/media/video/uvc/uvc_ctrl.c
--- a/linux/drivers/media/video/uvc/uvc_ctrl.c	Sun Jun 28 13:37:50 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvc_ctrl.c	Wed Jul 22 19:40:03 2009 +0200
@@ -731,7 +731,7 @@
 	}
 }
 
-struct uvc_control *uvc_find_control(struct uvc_video_device *video,
+struct uvc_control *uvc_find_control(struct uvc_video_chain *chain,
 	__u32 v4l2_id, struct uvc_control_mapping **mapping)
 {
 	struct uvc_control *ctrl = NULL;
@@ -744,17 +744,17 @@
 	v4l2_id &= V4L2_CTRL_ID_MASK;
 
 	/* Find the control. */
-	__uvc_find_control(video->processing, v4l2_id, mapping, &ctrl, next);
+	__uvc_find_control(chain->processing, v4l2_id, mapping, &ctrl, next);
 	if (ctrl && !next)
 		return ctrl;
 
-	list_for_each_entry(entity, &video->iterms, chain) {
+	list_for_each_entry(entity, &chain->iterms, chain) {
 		__uvc_find_control(entity, v4l2_id, mapping, &ctrl, next);
 		if (ctrl && !next)
 			return ctrl;
 	}
 
-	list_for_each_entry(entity, &video->extensions, chain) {
+	list_for_each_entry(entity, &chain->extensions, chain) {
 		__uvc_find_control(entity, v4l2_id, mapping, &ctrl, next);
 		if (ctrl && !next)
 			return ctrl;
@@ -767,7 +767,7 @@
 	return ctrl;
 }
 
-int uvc_query_v4l2_ctrl(struct uvc_video_device *video,
+int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	struct v4l2_queryctrl *v4l2_ctrl)
 {
 	struct uvc_control *ctrl;
@@ -777,7 +777,7 @@
 	__u8 *data;
 	int ret;
 
-	ctrl = uvc_find_control(video, v4l2_ctrl->id, &mapping);
+	ctrl = uvc_find_control(chain, v4l2_ctrl->id, &mapping);
 	if (ctrl == NULL)
 		return -EINVAL;
 
@@ -795,9 +795,9 @@
 		v4l2_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	if (ctrl->info->flags & UVC_CONTROL_GET_DEF) {
-		ret = uvc_query_ctrl(video->dev, UVC_GET_DEF, ctrl->entity->id,
-				video->dev->intfnum, ctrl->info->selector, data,
-				ctrl->info->size);
+		ret = uvc_query_ctrl(chain->dev, UVC_GET_DEF, ctrl->entity->id,
+				     chain->dev->intfnum, ctrl->info->selector,
+				     data, ctrl->info->size);
 		if (ret < 0)
 			goto out;
 		v4l2_ctrl->default_value =
@@ -833,25 +833,25 @@
 	}
 
 	if (ctrl->info->flags & UVC_CONTROL_GET_MIN) {
-		ret = uvc_query_ctrl(video->dev, UVC_GET_MIN, ctrl->entity->id,
-				video->dev->intfnum, ctrl->info->selector, data,
-				ctrl->info->size);
+		ret = uvc_query_ctrl(chain->dev, UVC_GET_MIN, ctrl->entity->id,
+				     chain->dev->intfnum, ctrl->info->selector,
+				     data, ctrl->info->size);
 		if (ret < 0)
 			goto out;
 		v4l2_ctrl->minimum = mapping->get(mapping, UVC_GET_MIN, data);
 	}
 	if (ctrl->info->flags & UVC_CONTROL_GET_MAX) {
-		ret = uvc_query_ctrl(video->dev, UVC_GET_MAX, ctrl->entity->id,
-				video->dev->intfnum, ctrl->info->selector, data,
-				ctrl->info->size);
+		ret = uvc_query_ctrl(chain->dev, UVC_GET_MAX, ctrl->entity->id,
+				     chain->dev->intfnum, ctrl->info->selector,
+				     data, ctrl->info->size);
 		if (ret < 0)
 			goto out;
 		v4l2_ctrl->maximum = mapping->get(mapping, UVC_GET_MAX, data);
 	}
 	if (ctrl->info->flags & UVC_CONTROL_GET_RES) {
-		ret = uvc_query_ctrl(video->dev, UVC_GET_RES, ctrl->entity->id,
-				video->dev->intfnum, ctrl->info->selector, data,
-				ctrl->info->size);
+		ret = uvc_query_ctrl(chain->dev, UVC_GET_RES, ctrl->entity->id,
+				     chain->dev->intfnum, ctrl->info->selector,
+				     data, ctrl->info->size);
 		if (ret < 0)
 			goto out;
 		v4l2_ctrl->step = mapping->get(mapping, UVC_GET_RES, data);
@@ -888,9 +888,9 @@
  * (UVC_CTRL_DATA_BACKUP) for all dirty controls. Both functions release the
  * control lock.
  */
-int uvc_ctrl_begin(struct uvc_video_device *video)
+int uvc_ctrl_begin(struct uvc_video_chain *chain)
 {
-	return mutex_lock_interruptible(&video->ctrl_mutex) ? -ERESTARTSYS : 0;
+	return mutex_lock_interruptible(&chain->ctrl_mutex) ? -ERESTARTSYS : 0;
 }
 
 static int uvc_ctrl_commit_entity(struct uvc_device *dev,
@@ -940,34 +940,34 @@
 	return 0;
 }
 
-int __uvc_ctrl_commit(struct uvc_video_device *video, int rollback)
+int __uvc_ctrl_commit(struct uvc_video_chain *chain, int rollback)
 {
 	struct uvc_entity *entity;
 	int ret = 0;
 
 	/* Find the control. */
-	ret = uvc_ctrl_commit_entity(video->dev, video->processing, rollback);
+	ret = uvc_ctrl_commit_entity(chain->dev, chain->processing, rollback);
 	if (ret < 0)
 		goto done;
 
-	list_for_each_entry(entity, &video->iterms, chain) {
-		ret = uvc_ctrl_commit_entity(video->dev, entity, rollback);
+	list_for_each_entry(entity, &chain->iterms, chain) {
+		ret = uvc_ctrl_commit_entity(chain->dev, entity, rollback);
 		if (ret < 0)
 			goto done;
 	}
 
-	list_for_each_entry(entity, &video->extensions, chain) {
-		ret = uvc_ctrl_commit_entity(video->dev, entity, rollback);
+	list_for_each_entry(entity, &chain->extensions, chain) {
+		ret = uvc_ctrl_commit_entity(chain->dev, entity, rollback);
 		if (ret < 0)
 			goto done;
 	}
 
 done:
-	mutex_unlock(&video->ctrl_mutex);
+	mutex_unlock(&chain->ctrl_mutex);
 	return ret;
 }
 
-int uvc_ctrl_get(struct uvc_video_device *video,
+int uvc_ctrl_get(struct uvc_video_chain *chain,
 	struct v4l2_ext_control *xctrl)
 {
 	struct uvc_control *ctrl;
@@ -976,13 +976,13 @@
 	unsigned int i;
 	int ret;
 
-	ctrl = uvc_find_control(video, xctrl->id, &mapping);
+	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
 	if (ctrl == NULL || (ctrl->info->flags & UVC_CONTROL_GET_CUR) == 0)
 		return -EINVAL;
 
 	if (!ctrl->loaded) {
-		ret = uvc_query_ctrl(video->dev, UVC_GET_CUR, ctrl->entity->id,
-				video->dev->intfnum, ctrl->info->selector,
+		ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, ctrl->entity->id,
+				chain->dev->intfnum, ctrl->info->selector,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 				ctrl->info->size);
 		if (ret < 0)
@@ -1007,7 +1007,7 @@
 	return 0;
 }
 
-int uvc_ctrl_set(struct uvc_video_device *video,
+int uvc_ctrl_set(struct uvc_video_chain *chain,
 	struct v4l2_ext_control *xctrl)
 {
 	struct uvc_control *ctrl;
@@ -1015,7 +1015,7 @@
 	s32 value = xctrl->value;
 	int ret;
 
-	ctrl = uvc_find_control(video, xctrl->id, &mapping);
+	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
 	if (ctrl == NULL || (ctrl->info->flags & UVC_CONTROL_SET_CUR) == 0)
 		return -EINVAL;
 
@@ -1030,8 +1030,8 @@
 			memset(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 				0, ctrl->info->size);
 		} else {
-			ret = uvc_query_ctrl(video->dev, UVC_GET_CUR,
-				ctrl->entity->id, video->dev->intfnum,
+			ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR,
+				ctrl->entity->id, chain->dev->intfnum,
 				ctrl->info->selector,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 				ctrl->info->size);
@@ -1060,7 +1060,7 @@
  * Dynamic controls
  */
 
-int uvc_xu_ctrl_query(struct uvc_video_device *video,
+int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 	struct uvc_xu_control *xctrl, int set)
 {
 	struct uvc_entity *entity;
@@ -1070,7 +1070,7 @@
 	int ret;
 
 	/* Find the extension unit. */
-	list_for_each_entry(entity, &video->extensions, chain) {
+	list_for_each_entry(entity, &chain->extensions, chain) {
 		if (entity->id == xctrl->unit)
 			break;
 	}
@@ -1109,7 +1109,7 @@
 	    (!set && !(ctrl->info->flags & UVC_CONTROL_GET_CUR)))
 		return -EINVAL;
 
-	if (mutex_lock_interruptible(&video->ctrl_mutex))
+	if (mutex_lock_interruptible(&chain->ctrl_mutex))
 		return -ERESTARTSYS;
 
 	memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
@@ -1122,8 +1122,8 @@
 		goto out;
 	}
 
-	ret = uvc_query_ctrl(video->dev, set ? UVC_SET_CUR : UVC_GET_CUR,
-			     xctrl->unit, video->dev->intfnum, xctrl->selector,
+	ret = uvc_query_ctrl(chain->dev, set ? UVC_SET_CUR : UVC_GET_CUR,
+			     xctrl->unit, chain->dev->intfnum, xctrl->selector,
 			     data, xctrl->size);
 	if (ret < 0)
 		goto out;
@@ -1139,7 +1139,7 @@
 		       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
 		       xctrl->size);
 
-	mutex_unlock(&video->ctrl_mutex);
+	mutex_unlock(&chain->ctrl_mutex);
 	return ret;
 }
 
diff -r ecc9128d8b6f linux/drivers/media/video/uvc/uvc_driver.c
--- a/linux/drivers/media/video/uvc/uvc_driver.c	Sun Jun 28 13:37:50 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvc_driver.c	Wed Jul 22 19:40:03 2009 +0200
@@ -276,8 +276,20 @@
 	return NULL;
 }
 
+static struct uvc_streaming *uvc_stream_by_id(struct uvc_device *dev, int id)
+{
+	struct uvc_streaming *stream;
+
+	list_for_each_entry(stream, &dev->streams, list) {
+		if (stream->header.bTerminalLink == id)
+			return stream;
+	}
+
+	return NULL;
+}
+
 /* ------------------------------------------------------------------------
- * Descriptors handling
+ * Descriptors parsing
  */
 
 static int uvc_parse_format(struct uvc_device *dev,
@@ -1160,101 +1172,36 @@
 }
 
 /* ------------------------------------------------------------------------
- * USB probe and disconnect
+ * UVC device scan
  */
 
 /*
- * Unregister the video devices.
- */
-static void uvc_unregister_video(struct uvc_device *dev)
-{
-	struct uvc_streaming *streaming;
-
-	list_for_each_entry(streaming, &dev->streams, list) {
-		if (streaming->vdev == NULL)
-			continue;
-
-		if (streaming->vdev->minor == -1)
-			video_device_release(streaming->vdev);
-		else
-			video_unregister_device(streaming->vdev);
-		streaming->vdev = NULL;
-	}
-}
-
-static int uvc_register_video(struct uvc_device *dev,
-		struct uvc_streaming *stream)
-{
-	struct video_device *vdev;
-	struct uvc_entity *term;
-	int ret;
-
-	if (uvc_trace_param & UVC_TRACE_PROBE) {
-		uvc_printk(KERN_INFO, "Found a valid video chain (");
-		list_for_each_entry(term, &dev->video.iterms, chain) {
-			printk("%d", term->id);
-			if (term->chain.next != &dev->video.iterms)
-				printk(",");
-		}
-		printk(" -> %d).\n", dev->video.oterm->id);
-	}
-
-	/* Initialize the streaming interface with default streaming
-	 * parameters.
-	 */
-	ret = uvc_video_init(stream);
-	if (ret < 0) {
-		uvc_printk(KERN_ERR, "Failed to initialize the device "
-			"(%d).\n", ret);
-		return ret;
-	}
-
-	/* Register the device with V4L. */
-	vdev = video_device_alloc();
-	if (vdev == NULL)
-		return -1;
-
-	/* We already hold a reference to dev->udev. The video device will be
-	 * unregistered before the reference is released, so we don't need to
-	 * get another one.
-	 */
-	vdev->parent = &dev->intf->dev;
-	vdev->minor = -1;
-	vdev->fops = &uvc_fops;
-	vdev->release = video_device_release;
-	strlcpy(vdev->name, dev->name, sizeof vdev->name);
-
-	/* Set the driver data before calling video_register_device, otherwise
-	 * uvc_v4l2_open might race us.
-	 */
-	stream->vdev = vdev;
-	video_set_drvdata(vdev, stream);
-
-	if (video_register_device(vdev, VFL_TYPE_GRABBER, -1) < 0) {
-		stream->vdev = NULL;
-		video_device_release(vdev);
-		return -1;
-	}
-
-	return 0;
-}
-
-/*
  * Scan the UVC descriptors to locate a chain starting at an Output Terminal
  * and containing the following units:
  *
- * - one Output Terminal (USB Streaming or Display)
+ * - one or more Output Terminals (USB Streaming or Display)
  * - zero or one Processing Unit
- * - zero, one or mode single-input Selector Units
+ * - zero, one or more single-input Selector Units
  * - zero or one multiple-input Selector Units, provided all inputs are
  *   connected to input terminals
  * - zero, one or mode single-input Extension Units
  * - one or more Input Terminals (Camera, External or USB Streaming)
  *
- * A side forward scan is made on each detected entity to check for additional
- * extension units.
+ * The terminal and units must match on of the following structures:
+ *
+ * ITT_*(0) -> +---------+    +---------+    +---------+ -> TT_STREAMING(0)
+ * ...         | SU{0,1} | -> | PU{0,1} | -> | XU{0,n} |    ...
+ * ITT_*(n) -> +---------+    +---------+    +---------+ -> TT_STREAMING(n)
+ *
+ *                 +---------+    +---------+ -> OTT_*(0)
+ * TT_STREAMING -> | PU{0,1} | -> | XU{0,n} |    ...
+ *                 +---------+    +---------+ -> OTT_*(n)
+ *
+ * The Processing Unit and Extension Units can be in any order. Additional
+ * Extension Units connected to the main chain as single-unit branches are
+ * also supported. Single-input Selector Units are ignored.
  */
-static int uvc_scan_chain_entity(struct uvc_video_device *video,
+static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 	struct uvc_entity *entity)
 {
 	switch (UVC_ENTITY_TYPE(entity)) {
@@ -1268,20 +1215,20 @@
 			return -1;
 		}
 
-		list_add_tail(&entity->chain, &video->extensions);
+		list_add_tail(&entity->chain, &chain->extensions);
 		break;
 
 	case UVC_VC_PROCESSING_UNIT:
 		if (uvc_trace_param & UVC_TRACE_PROBE)
 			printk(" <- PU %d", entity->id);
 
-		if (video->processing != NULL) {
+		if (chain->processing != NULL) {
 			uvc_trace(UVC_TRACE_DESCR, "Found multiple "
 				"Processing Units in chain.\n");
 			return -1;
 		}
 
-		video->processing = entity;
+		chain->processing = entity;
 		break;
 
 	case UVC_VC_SELECTOR_UNIT:
@@ -1292,13 +1239,13 @@
 		if (entity->selector.bNrInPins == 1)
 			break;
 
-		if (video->selector != NULL) {
+		if (chain->selector != NULL) {
 			uvc_trace(UVC_TRACE_DESCR, "Found multiple Selector "
 				"Units in chain.\n");
 			return -1;
 		}
 
-		video->selector = entity;
+		chain->selector = entity;
 		break;
 
 	case UVC_ITT_VENDOR_SPECIFIC:
@@ -1307,7 +1254,7 @@
 		if (uvc_trace_param & UVC_TRACE_PROBE)
 			printk(" <- IT %d\n", entity->id);
 
-		list_add_tail(&entity->chain, &video->iterms);
+		list_add_tail(&entity->chain, &chain->iterms);
 		break;
 
 	case UVC_TT_STREAMING:
@@ -1320,14 +1267,7 @@
 			return -1;
 		}
 
-		if (video->sterm != NULL) {
-			uvc_trace(UVC_TRACE_DESCR, "Found multiple streaming "
-				"entities in chain.\n");
-			return -1;
-		}
-
-		list_add_tail(&entity->chain, &video->iterms);
-		video->sterm = entity;
+		list_add_tail(&entity->chain, &chain->iterms);
 		break;
 
 	default:
@@ -1339,7 +1279,7 @@
 	return 0;
 }
 
-static int uvc_scan_chain_forward(struct uvc_video_device *video,
+static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
 	struct uvc_entity *entity, struct uvc_entity *prev)
 {
 	struct uvc_entity *forward;
@@ -1350,28 +1290,51 @@
 	found = 0;
 
 	while (1) {
-		forward = uvc_entity_by_reference(video->dev, entity->id,
+		forward = uvc_entity_by_reference(chain->dev, entity->id,
 			forward);
 		if (forward == NULL)
 			break;
-
-		if (UVC_ENTITY_TYPE(forward) != UVC_VC_EXTENSION_UNIT ||
-		    forward == prev)
+		if (forward == prev)
 			continue;
 
-		if (forward->extension.bNrInPins != 1) {
-			uvc_trace(UVC_TRACE_DESCR, "Extension unit %d has "
-				"more than 1 input pin.\n", entity->id);
-			return -1;
-		}
+		switch (UVC_ENTITY_TYPE(forward)) {
+		case UVC_VC_EXTENSION_UNIT:
+			if (forward->extension.bNrInPins != 1) {
+				uvc_trace(UVC_TRACE_DESCR, "Extension unit %d "
+					  "has more than 1 input pin.\n",
+					  entity->id);
+				return -EINVAL;
+			}
 
-		list_add_tail(&forward->chain, &video->extensions);
-		if (uvc_trace_param & UVC_TRACE_PROBE) {
-			if (!found)
-				printk(" (-> XU");
+			list_add_tail(&forward->chain, &chain->extensions);
+			if (uvc_trace_param & UVC_TRACE_PROBE) {
+				if (!found)
+					printk(" (->");
 
-			printk(" %d", forward->id);
-			found = 1;
+				printk(" XU %d", forward->id);
+				found = 1;
+			}
+			break;
+
+		case UVC_OTT_VENDOR_SPECIFIC:
+		case UVC_OTT_DISPLAY:
+		case UVC_OTT_MEDIA_TRANSPORT_OUTPUT:
+		case UVC_TT_STREAMING:
+			if (UVC_ENTITY_IS_ITERM(forward)) {
+				uvc_trace(UVC_TRACE_DESCR, "Unsupported input "
+					"terminal %u.\n", forward->id);
+				return -EINVAL;
+			}
+
+			list_add_tail(&forward->chain, &chain->oterms);
+			if (uvc_trace_param & UVC_TRACE_PROBE) {
+				if (!found)
+					printk(" (->");
+
+				printk(" OT %d", forward->id);
+				found = 1;
+			}
+			break;
 		}
 	}
 	if (found)
@@ -1380,7 +1343,7 @@
 	return 0;
 }
 
-static int uvc_scan_chain_backward(struct uvc_video_device *video,
+static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
 	struct uvc_entity *entity)
 {
 	struct uvc_entity *term;
@@ -1405,10 +1368,10 @@
 		if (uvc_trace_param & UVC_TRACE_PROBE)
 			printk(" <- IT");
 
-		video->selector = entity;
+		chain->selector = entity;
 		for (i = 0; i < entity->selector.bNrInPins; ++i) {
 			id = entity->selector.baSourceID[i];
-			term = uvc_entity_by_id(video->dev, id);
+			term = uvc_entity_by_id(chain->dev, id);
 			if (term == NULL || !UVC_ENTITY_IS_ITERM(term)) {
 				uvc_trace(UVC_TRACE_DESCR, "Selector unit %d "
 					"input %d isn't connected to an "
@@ -1419,8 +1382,8 @@
 			if (uvc_trace_param & UVC_TRACE_PROBE)
 				printk(" %d", term->id);
 
-			list_add_tail(&term->chain, &video->iterms);
-			uvc_scan_chain_forward(video, term, entity);
+			list_add_tail(&term->chain, &chain->iterms);
+			uvc_scan_chain_forward(chain, term, entity);
 		}
 
 		if (uvc_trace_param & UVC_TRACE_PROBE)
@@ -1433,108 +1396,264 @@
 	return id;
 }
 
-static int uvc_scan_chain(struct uvc_video_device *video)
+static int uvc_scan_chain(struct uvc_video_chain *chain,
+			  struct uvc_entity *oterm)
 {
 	struct uvc_entity *entity, *prev;
 	int id;
 
-	entity = video->oterm;
+	entity = oterm;
+	list_add_tail(&entity->chain, &chain->oterms);
 	uvc_trace(UVC_TRACE_PROBE, "Scanning UVC chain: OT %d", entity->id);
 
-	if (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
-		video->sterm = entity;
-
 	id = entity->output.bSourceID;
 	while (id != 0) {
 		prev = entity;
-		entity = uvc_entity_by_id(video->dev, id);
+		entity = uvc_entity_by_id(chain->dev, id);
 		if (entity == NULL) {
 			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
 				"unknown entity %d.\n", id);
-			return -1;
+			return -EINVAL;
+		}
+
+		if (entity->chain.next || entity->chain.prev) {
+			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
+				"entity %d already in chain.\n", id);
+			return -EINVAL;
 		}
 
 		/* Process entity */
-		if (uvc_scan_chain_entity(video, entity) < 0)
-			return -1;
+		if (uvc_scan_chain_entity(chain, entity) < 0)
+			return -EINVAL;
 
 		/* Forward scan */
-		if (uvc_scan_chain_forward(video, entity, prev) < 0)
-			return -1;
+		if (uvc_scan_chain_forward(chain, entity, prev) < 0)
+			return -EINVAL;
 
 		/* Stop when a terminal is found. */
-		if (!UVC_ENTITY_IS_UNIT(entity))
+		if (UVC_ENTITY_IS_TERM(entity))
 			break;
 
 		/* Backward scan */
-		id = uvc_scan_chain_backward(video, entity);
+		id = uvc_scan_chain_backward(chain, entity);
 		if (id < 0)
 			return id;
 	}
 
-	if (video->sterm == NULL) {
-		uvc_trace(UVC_TRACE_DESCR, "No streaming entity found in "
-			"chain.\n");
+	return 0;
+}
+
+static unsigned int uvc_print_terms(struct list_head *terms, char *buffer)
+{
+	struct uvc_entity *term;
+	unsigned int nterms = 0;
+	char *p = buffer;
+
+	list_for_each_entry(term, terms, chain) {
+		p += sprintf(p, "%u", term->id);
+		if (term->chain.next != terms) {
+			p += sprintf(p, ",");
+			if (++nterms >= 4) {
+				p += sprintf(p, "...");
+				break;
+			}
+		}
+	}
+
+	return p - buffer;
+}
+
+static const char *uvc_print_chain(struct uvc_video_chain *chain)
+{
+	static char buffer[43];
+	char *p = buffer;
+
+	p += uvc_print_terms(&chain->iterms, p);
+	p += sprintf(p, " -> ");
+	uvc_print_terms(&chain->oterms, p);
+
+	return buffer;
+}
+
+/*
+ * Scan the device for video chains and register video devices.
+ *
+ * Chains are scanned starting at their output terminals and walked backwards.
+ */
+static int uvc_scan_device(struct uvc_device *dev)
+{
+	struct uvc_video_chain *chain;
+	struct uvc_entity *term;
+
+	list_for_each_entry(term, &dev->entities, list) {
+		if (!UVC_ENTITY_IS_OTERM(term))
+			continue;
+
+		/* If the terminal is already included in a chain, skip it.
+		 * This can happen for chains that have multiple output
+		 * terminals, where all output terminals beside the first one
+		 * will be inserted in the chain in forward scans.
+		 */
+		if (term->chain.next || term->chain.prev)
+			continue;
+
+		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
+		if (chain == NULL)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&chain->iterms);
+		INIT_LIST_HEAD(&chain->oterms);
+		INIT_LIST_HEAD(&chain->extensions);
+		mutex_init(&chain->ctrl_mutex);
+		chain->dev = dev;
+
+		if (uvc_scan_chain(chain, term) < 0) {
+			kfree(chain);
+			continue;
+		}
+
+		uvc_trace(UVC_TRACE_PROBE, "Found a valid video chain (%s).\n",
+			  uvc_print_chain(chain));
+
+		list_add_tail(&chain->list, &dev->chains);
+	}
+
+	if (list_empty(&dev->chains)) {
+		uvc_printk(KERN_INFO, "No valid video chain found.\n");
 		return -1;
 	}
 
 	return 0;
 }
 
+/* ------------------------------------------------------------------------
+ * Video device registration and unregistration
+ */
+
 /*
- * Scan the device for video chains and register video devices.
- *
- * The driver currently supports a single video device per control interface
- * only. The terminal and units must match the following structure:
- *
- * ITT_* -> VC_PROCESSING_UNIT -> VC_EXTENSION_UNIT{0,n} -> TT_STREAMING
- * TT_STREAMING -> VC_PROCESSING_UNIT -> VC_EXTENSION_UNIT{0,n} -> OTT_*
- *
- * The Extension Units, if present, must have a single input pin. The
- * Processing Unit and Extension Units can be in any order. Additional
- * Extension Units connected to the main chain as single-unit branches are
- * also supported.
+ * Unregister the video devices.
  */
-static int uvc_scan_device(struct uvc_device *dev)
+static void uvc_unregister_video(struct uvc_device *dev)
 {
-	struct uvc_entity *term;
-	int found = 0;
+	struct uvc_streaming *stream;
 
-	/* Check if the control interface matches the structure we expect. */
-	list_for_each_entry(term, &dev->entities, list) {
-		struct uvc_streaming *stream;
-
-		if (!UVC_ENTITY_IS_TERM(term) || !UVC_ENTITY_IS_OTERM(term))
+	list_for_each_entry(stream, &dev->streams, list) {
+		if (stream->vdev == NULL)
 			continue;
 
-		memset(&dev->video, 0, sizeof dev->video);
-		mutex_init(&dev->video.ctrl_mutex);
-		INIT_LIST_HEAD(&dev->video.iterms);
-		INIT_LIST_HEAD(&dev->video.extensions);
-		dev->video.oterm = term;
-		dev->video.dev = dev;
-		if (uvc_scan_chain(&dev->video) < 0)
-			continue;
+		if (stream->vdev->minor == -1)
+			video_device_release(stream->vdev);
+		else
+			video_unregister_device(stream->vdev);
+		stream->vdev = NULL;
+	}
+}
 
-		list_for_each_entry(stream, &dev->streams, list) {
-			if (stream->header.bTerminalLink ==
-			    dev->video.sterm->id) {
-				uvc_register_video(dev, stream);
-				found = 1;
-				break;
-			}
-		}
+static int uvc_register_video(struct uvc_device *dev,
+		struct uvc_streaming *stream)
+{
+	struct video_device *vdev;
+	int ret;
+
+	/* Initialize the streaming interface with default streaming
+	 * parameters.
+	 */
+	ret = uvc_video_init(stream);
+	if (ret < 0) {
+		uvc_printk(KERN_ERR, "Failed to initialize the device "
+			"(%d).\n", ret);
+		return ret;
 	}
 
-	if (!found) {
-		uvc_printk(KERN_INFO, "No valid video chain found.\n");
-		return -1;
+	/* Register the device with V4L. */
+	vdev = video_device_alloc();
+	if (vdev == NULL) {
+		uvc_printk(KERN_ERR, "Failed to allocate video device (%d).\n",
+			   ret);
+		return -ENOMEM;
+	}
+
+	/* We already hold a reference to dev->udev. The video device will be
+	 * unregistered before the reference is released, so we don't need to
+	 * get another one.
+	 */
+	vdev->parent = &dev->intf->dev;
+	vdev->minor = -1;
+	vdev->fops = &uvc_fops;
+	vdev->release = video_device_release;
+	strlcpy(vdev->name, dev->name, sizeof vdev->name);
+
+	/* Set the driver data before calling video_register_device, otherwise
+	 * uvc_v4l2_open might race us.
+	 */
+	stream->vdev = vdev;
+	video_set_drvdata(vdev, stream);
+
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		uvc_printk(KERN_ERR, "Failed to register video device (%d).\n",
+			   ret);
+		stream->vdev = NULL;
+		video_device_release(vdev);
+		return ret;
 	}
 
 	return 0;
 }
 
 /*
+ * Register all video devices in all chains.
+ */
+static int uvc_register_terms(struct uvc_device *dev,
+	struct uvc_video_chain *chain, struct list_head *terms)
+{
+	struct uvc_streaming *stream;
+	struct uvc_entity *term;
+	int ret;
+
+	list_for_each_entry(term, terms, chain) {
+		if (UVC_ENTITY_TYPE(term) != UVC_TT_STREAMING)
+			continue;
+
+		stream = uvc_stream_by_id(dev, term->id);
+		if (stream == NULL) {
+			uvc_printk(KERN_INFO, "No streaming interface found "
+				   "for terminal %u.", term->id);
+			continue;
+		}
+
+		stream->chain = chain;
+		ret = uvc_register_video(dev, stream);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int uvc_register_chains(struct uvc_device *dev)
+{
+	struct uvc_video_chain *chain;
+	int ret;
+
+	list_for_each_entry(chain, &dev->chains, list) {
+		ret = uvc_register_terms(dev, chain, &chain->iterms);
+		if (ret < 0)
+			return ret;
+
+		ret = uvc_register_terms(dev, chain, &chain->oterms);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* ------------------------------------------------------------------------
+ * USB probe, disconnect, suspend and resume
+ */
+
+/*
  * Delete the UVC device.
  *
  * Called by the kernel when the last reference to the uvc_device structure
@@ -1555,7 +1674,7 @@
 	struct uvc_device *dev = container_of(kref, struct uvc_device, kref);
 	struct list_head *p, *n;
 
-	/* Unregister the video device. */
+	/* Unregister the video devices. */
 	uvc_unregister_video(dev);
 	usb_put_intf(dev->intf);
 	usb_put_dev(dev->udev);
@@ -1563,6 +1682,12 @@
 	uvc_status_cleanup(dev);
 	uvc_ctrl_cleanup_device(dev);
 
+	list_for_each_safe(p, n, &dev->chains) {
+		struct uvc_video_chain *chain;
+		chain = list_entry(p, struct uvc_video_chain, list);
+		kfree(chain);
+	}
+
 	list_for_each_safe(p, n, &dev->entities) {
 		struct uvc_entity *entity;
 		entity = list_entry(p, struct uvc_entity, list);
@@ -1603,6 +1728,7 @@
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&dev->entities);
+	INIT_LIST_HEAD(&dev->chains);
 	INIT_LIST_HEAD(&dev->streams);
 	kref_init(&dev->kref);
 	atomic_set(&dev->users, 0);
@@ -1644,10 +1770,14 @@
 	if (uvc_ctrl_init_device(dev) < 0)
 		goto error;
 
-	/* Scan the device for video chains and register video devices. */
+	/* Scan the device for video chains. */
 	if (uvc_scan_device(dev) < 0)
 		goto error;
 
+	/* Register video devices. */
+	if (uvc_register_chains(dev) < 0)
+		goto error;
+
 	/* Save our data pointer in the interface data. */
 	usb_set_intfdata(intf, dev);
 
diff -r ecc9128d8b6f linux/drivers/media/video/uvc/uvc_v4l2.c
--- a/linux/drivers/media/video/uvc/uvc_v4l2.c	Sun Jun 28 13:37:50 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvc_v4l2.c	Wed Jul 22 19:40:03 2009 +0200
@@ -40,7 +40,7 @@
  * table for the controls that can be mapped directly, and handle the others
  * manually.
  */
-static int uvc_v4l2_query_menu(struct uvc_video_device *video,
+static int uvc_v4l2_query_menu(struct uvc_video_chain *chain,
 	struct v4l2_querymenu *query_menu)
 {
 	struct uvc_menu_info *menu_info;
@@ -49,7 +49,7 @@
 	u32 index = query_menu->index;
 	u32 id = query_menu->id;
 
-	ctrl = uvc_find_control(video, query_menu->id, &mapping);
+	ctrl = uvc_find_control(chain, query_menu->id, &mapping);
 	if (ctrl == NULL || mapping->v4l2_type != V4L2_CTRL_TYPE_MENU)
 		return -EINVAL;
 
@@ -457,7 +457,7 @@
 		}
 	}
 
-	handle->video = &stream->dev->video;
+	handle->chain = stream->chain;
 	handle->stream = stream;
 	handle->state = UVC_HANDLE_PASSIVE;
 	file->private_data = handle;
@@ -506,7 +506,7 @@
 {
 	struct video_device *vdev = video_devdata(file);
 	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
-	struct uvc_video_device *video = handle->video;
+	struct uvc_video_chain *chain = handle->chain;
 	struct uvc_streaming *stream = handle->stream;
 	long ret = 0;
 
@@ -533,7 +533,7 @@
 
 	/* Get, Set & Query control */
 	case VIDIOC_QUERYCTRL:
-		return uvc_query_v4l2_ctrl(video, arg);
+		return uvc_query_v4l2_ctrl(chain, arg);
 
 	case VIDIOC_G_CTRL:
 	{
@@ -543,12 +543,12 @@
 		memset(&xctrl, 0, sizeof xctrl);
 		xctrl.id = ctrl->id;
 
-	       ret = uvc_ctrl_begin(video);
-	       if (ret < 0)
+		ret = uvc_ctrl_begin(chain);
+		if (ret < 0)
 			return ret;
 
-		ret = uvc_ctrl_get(video, &xctrl);
-		uvc_ctrl_rollback(video);
+		ret = uvc_ctrl_get(chain, &xctrl);
+		uvc_ctrl_rollback(chain);
 		if (ret >= 0)
 			ctrl->value = xctrl.value;
 		break;
@@ -563,21 +563,21 @@
 		xctrl.id = ctrl->id;
 		xctrl.value = ctrl->value;
 
-	       ret = uvc_ctrl_begin(video);
-	       if (ret < 0)
+		uvc_ctrl_begin(chain);
+		if (ret < 0)
 			return ret;
 
-		ret = uvc_ctrl_set(video, &xctrl);
+		ret = uvc_ctrl_set(chain, &xctrl);
 		if (ret < 0) {
-			uvc_ctrl_rollback(video);
+			uvc_ctrl_rollback(chain);
 			return ret;
 		}
-		ret = uvc_ctrl_commit(video);
+		ret = uvc_ctrl_commit(chain);
 		break;
 	}
 
 	case VIDIOC_QUERYMENU:
-		return uvc_v4l2_query_menu(video, arg);
+		return uvc_v4l2_query_menu(chain, arg);
 
 	case VIDIOC_G_EXT_CTRLS:
 	{
@@ -585,20 +585,20 @@
 		struct v4l2_ext_control *ctrl = ctrls->controls;
 		unsigned int i;
 
-	       ret = uvc_ctrl_begin(video);
-	       if (ret < 0)
+		ret = uvc_ctrl_begin(chain);
+		if (ret < 0)
 			return ret;
 
 		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
-			ret = uvc_ctrl_get(video, ctrl);
+			ret = uvc_ctrl_get(chain, ctrl);
 			if (ret < 0) {
-				uvc_ctrl_rollback(video);
+				uvc_ctrl_rollback(chain);
 				ctrls->error_idx = i;
 				return ret;
 			}
 		}
 		ctrls->error_idx = 0;
-		ret = uvc_ctrl_rollback(video);
+		ret = uvc_ctrl_rollback(chain);
 		break;
 	}
 
@@ -609,14 +609,14 @@
 		struct v4l2_ext_control *ctrl = ctrls->controls;
 		unsigned int i;
 
-		ret = uvc_ctrl_begin(video);
+		ret = uvc_ctrl_begin(chain);
 		if (ret < 0)
 			return ret;
 
 		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
-			ret = uvc_ctrl_set(video, ctrl);
+			ret = uvc_ctrl_set(chain, ctrl);
 			if (ret < 0) {
-				uvc_ctrl_rollback(video);
+				uvc_ctrl_rollback(chain);
 				ctrls->error_idx = i;
 				return ret;
 			}
@@ -625,31 +625,31 @@
 		ctrls->error_idx = 0;
 
 		if (cmd == VIDIOC_S_EXT_CTRLS)
-			ret = uvc_ctrl_commit(video);
+			ret = uvc_ctrl_commit(chain);
 		else
-			ret = uvc_ctrl_rollback(video);
+			ret = uvc_ctrl_rollback(chain);
 		break;
 	}
 
 	/* Get, Set & Enum input */
 	case VIDIOC_ENUMINPUT:
 	{
-		const struct uvc_entity *selector = video->selector;
+		const struct uvc_entity *selector = chain->selector;
 		struct v4l2_input *input = arg;
 		struct uvc_entity *iterm = NULL;
 		u32 index = input->index;
 		int pin = 0;
 
 		if (selector == NULL ||
-		    (video->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
+		    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
 			if (index != 0)
 				return -EINVAL;
-			iterm = list_first_entry(&video->iterms,
+			iterm = list_first_entry(&chain->iterms,
 					struct uvc_entity, chain);
 			pin = iterm->id;
 		} else if (pin < selector->selector.bNrInPins) {
 			pin = selector->selector.baSourceID[index];
-			list_for_each_entry(iterm, video->iterms.next, chain) {
+			list_for_each_entry(iterm, chain->iterms.next, chain) {
 				if (iterm->id == pin)
 					break;
 			}
@@ -670,14 +670,14 @@
 	{
 		u8 input;
 
-		if (video->selector == NULL ||
-		    (video->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
+		if (chain->selector == NULL ||
+		    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
 			*(int *)arg = 0;
 			break;
 		}
 
-		ret = uvc_query_ctrl(video->dev, UVC_GET_CUR,
-			video->selector->id, video->dev->intfnum,
+		ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR,
+			chain->selector->id, chain->dev->intfnum,
 			UVC_SU_INPUT_SELECT_CONTROL, &input, 1);
 		if (ret < 0)
 			return ret;
@@ -693,18 +693,18 @@
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
-		if (video->selector == NULL ||
-		    (video->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
+		if (chain->selector == NULL ||
+		    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
 			if (input != 1)
 				return -EINVAL;
 			break;
 		}
 
-		if (input == 0 || input > video->selector->selector.bNrInPins)
+		if (input == 0 || input > chain->selector->selector.bNrInPins)
 			return -EINVAL;
 
-		return uvc_query_ctrl(video->dev, UVC_SET_CUR,
-			video->selector->id, video->dev->intfnum,
+		return uvc_query_ctrl(chain->dev, UVC_SET_CUR,
+			chain->selector->id, chain->dev->intfnum,
 			UVC_SU_INPUT_SELECT_CONTROL, &input, 1);
 	}
 
@@ -1027,10 +1027,10 @@
 	}
 
 	case UVCIOC_CTRL_GET:
-		return uvc_xu_ctrl_query(video, arg, 0);
+		return uvc_xu_ctrl_query(chain, arg, 0);
 
 	case UVCIOC_CTRL_SET:
-		return uvc_xu_ctrl_query(video, arg, 1);
+		return uvc_xu_ctrl_query(chain, arg, 1);
 
 	default:
 		if ((ret = v4l_compat_translate_ioctl(file, cmd, arg,
diff -r ecc9128d8b6f linux/drivers/media/video/uvc/uvc_video.c
--- a/linux/drivers/media/video/uvc/uvc_video.c	Sun Jun 28 13:37:50 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvc_video.c	Wed Jul 22 19:40:03 2009 +0200
@@ -128,7 +128,7 @@
 	if (data == NULL)
 		return -ENOMEM;
 
-	if ((video->dev->quirks & UVC_QUIRK_PROBE_DEF) && query == UVC_GET_DEF)
+	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) && query == UVC_GET_DEF)
 		return -EIO;
 
 	ret = __uvc_query_ctrl(stream->dev, query, 0, stream->intfnum,
diff -r ecc9128d8b6f linux/drivers/media/video/uvc/uvcvideo.h
--- a/linux/drivers/media/video/uvc/uvcvideo.h	Sun Jun 28 13:37:50 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvcvideo.h	Wed Jul 22 19:40:03 2009 +0200
@@ -81,9 +81,11 @@
 #define UVC_ENTITY_IS_UNIT(entity)	(((entity)->type & 0xff00) == 0)
 #define UVC_ENTITY_IS_TERM(entity)	(((entity)->type & 0xff00) != 0)
 #define UVC_ENTITY_IS_ITERM(entity) \
-	(((entity)->type & 0x8000) == UVC_TERM_INPUT)
+	(UVC_ENTITY_IS_TERM(entity) && \
+	((entity)->type & 0x8000) == UVC_TERM_INPUT)
 #define UVC_ENTITY_IS_OTERM(entity) \
-	(((entity)->type & 0x8000) == UVC_TERM_OUTPUT)
+	(UVC_ENTITY_IS_TERM(entity) && \
+	((entity)->type & 0x8000) == UVC_TERM_OUTPUT)
 
 
 /* ------------------------------------------------------------------------
@@ -403,10 +405,24 @@
 	struct list_head irqqueue;
 };
 
+struct uvc_video_chain {
+	struct uvc_device *dev;
+	struct list_head list;
+
+	struct list_head iterms;		/* Input terminals */
+	struct list_head oterms;		/* Output terminals */
+	struct uvc_entity *processing;		/* Processing unit */
+	struct uvc_entity *selector;		/* Selector unit */
+	struct list_head extensions;		/* Extension units */
+
+	struct mutex ctrl_mutex;
+};
+
 struct uvc_streaming {
 	struct list_head list;
 	struct uvc_device *dev;
 	struct video_device *vdev;
+	struct uvc_video_chain *chain;
 	atomic_t active;
 
 	struct usb_interface *intf;
@@ -447,18 +463,6 @@
 	__u8 last_fid;
 };
 
-struct uvc_video_device {
-	struct uvc_device *dev;
-
-	struct list_head iterms;		/* Input terminals */
-	struct uvc_entity *oterm;		/* Output terminal */
-	struct uvc_entity *sterm;		/* USB streaming terminal */
-	struct uvc_entity *processing;
-	struct uvc_entity *selector;
-	struct list_head extensions;
-	struct mutex ctrl_mutex;
-};
-
 enum uvc_device_state {
 	UVC_DEV_DISCONNECTED = 1,
 };
@@ -481,8 +485,7 @@
 	__u32 clock_frequency;
 
 	struct list_head entities;
-
-	struct uvc_video_device video;
+	struct list_head chains;
 
 	/* Video Streaming interfaces */
 	struct list_head streams;
@@ -501,7 +504,7 @@
 };
 
 struct uvc_fh {
-	struct uvc_video_device *video;
+	struct uvc_video_chain *chain;
 	struct uvc_streaming *stream;
 	enum uvc_handle_state state;
 };
@@ -619,9 +622,9 @@
 extern int uvc_status_resume(struct uvc_device *dev);
 
 /* Controls */
-extern struct uvc_control *uvc_find_control(struct uvc_video_device *video,
+extern struct uvc_control *uvc_find_control(struct uvc_video_chain *chain,
 		__u32 v4l2_id, struct uvc_control_mapping **mapping);
-extern int uvc_query_v4l2_ctrl(struct uvc_video_device *video,
+extern int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		struct v4l2_queryctrl *v4l2_ctrl);
 
 extern int uvc_ctrl_add_info(struct uvc_control_info *info);
@@ -631,23 +634,23 @@
 extern int uvc_ctrl_resume_device(struct uvc_device *dev);
 extern void uvc_ctrl_init(void);
 
-extern int uvc_ctrl_begin(struct uvc_video_device *video);
-extern int __uvc_ctrl_commit(struct uvc_video_device *video, int rollback);
-static inline int uvc_ctrl_commit(struct uvc_video_device *video)
+extern int uvc_ctrl_begin(struct uvc_video_chain *chain);
+extern int __uvc_ctrl_commit(struct uvc_video_chain *chain, int rollback);
+static inline int uvc_ctrl_commit(struct uvc_video_chain *chain)
 {
-	return __uvc_ctrl_commit(video, 0);
+	return __uvc_ctrl_commit(chain, 0);
 }
-static inline int uvc_ctrl_rollback(struct uvc_video_device *video)
+static inline int uvc_ctrl_rollback(struct uvc_video_chain *chain)
 {
-	return __uvc_ctrl_commit(video, 1);
+	return __uvc_ctrl_commit(chain, 1);
 }
 
-extern int uvc_ctrl_get(struct uvc_video_device *video,
+extern int uvc_ctrl_get(struct uvc_video_chain *chain,
 		struct v4l2_ext_control *xctrl);
-extern int uvc_ctrl_set(struct uvc_video_device *video,
+extern int uvc_ctrl_set(struct uvc_video_chain *chain,
 		struct v4l2_ext_control *xctrl);
 
-extern int uvc_xu_ctrl_query(struct uvc_video_device *video,
+extern int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		struct uvc_xu_control *ctrl, int set);
 
 /* Utility functions */

