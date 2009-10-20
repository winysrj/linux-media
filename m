Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43921 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbZJTIO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:58 -0400
Message-Id: <20091020011215.854718685@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:22 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 12/14] uvcvideo: Factorize common field in uvc_entity structure
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=uvc-factor-entity-source.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bNrInPins and baSourceID fields are common among all entities (some
of use bSourceID but this is conceptually the same). Move those two
fields out of entity type-specific unions into the uvc_entity structure
top level.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvc_driver.c
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
@@ -248,29 +248,9 @@ static struct uvc_entity *uvc_entity_by_
 		entity = list_entry(&dev->entities, struct uvc_entity, list);
 
 	list_for_each_entry_continue(entity, &dev->entities, list) {
-		switch (UVC_ENTITY_TYPE(entity)) {
-		case UVC_TT_STREAMING:
-			if (entity->output.bSourceID == id)
+		for (i = 0; i < entity->bNrInPins; ++i)
+			if (entity->baSourceID[i] == id)
 				return entity;
-			break;
-
-		case UVC_VC_PROCESSING_UNIT:
-			if (entity->processing.bSourceID == id)
-				return entity;
-			break;
-
-		case UVC_VC_SELECTOR_UNIT:
-			for (i = 0; i < entity->selector.bNrInPins; ++i)
-				if (entity->selector.baSourceID[i] == id)
-					return entity;
-			break;
-
-		case UVC_VC_EXTENSION_UNIT:
-			for (i = 0; i < entity->extension.bNrInPins; ++i)
-				if (entity->extension.baSourceID[i] == id)
-					return entity;
-			break;
-		}
 	}
 
 	return NULL;
@@ -776,6 +756,28 @@ error:
 	return ret;
 }
 
+static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
+		unsigned int num_pads, unsigned int extra_size)
+{
+	struct uvc_entity *entity;
+	unsigned int num_inputs;
+	unsigned int size;
+
+	num_inputs = (type & UVC_TERM_OUTPUT) ? num_pads : num_pads - 1;
+	size = sizeof(*entity) + extra_size + num_inputs;
+	entity = kzalloc(size, GFP_KERNEL);
+	if (entity == NULL)
+		return NULL;
+
+	entity->id = id;
+	entity->type = type;
+
+	entity->bNrInPins = num_inputs;
+	entity->baSourceID = ((__u8 *)entity) + sizeof(*entity) + extra_size;
+
+	return entity;
+}
+
 /* Parse vendor-specific extensions. */
 static int uvc_parse_vendor_control(struct uvc_device *dev,
 	const unsigned char *buffer, int buflen)
@@ -827,21 +829,18 @@ static int uvc_parse_vendor_control(stru
 			break;
 		}
 
-		unit = kzalloc(sizeof *unit + p + 2*n, GFP_KERNEL);
+		unit = uvc_alloc_entity(UVC_VC_EXTENSION_UNIT, buffer[3],
+					p + 1, 2*n);
 		if (unit == NULL)
 			return -ENOMEM;
 
-		unit->id = buffer[3];
-		unit->type = UVC_VC_EXTENSION_UNIT;
 		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
 		unit->extension.bNumControls = buffer[20];
-		unit->extension.bNrInPins = buffer[21];
-		unit->extension.baSourceID = (__u8 *)unit + sizeof *unit;
-		memcpy(unit->extension.baSourceID, &buffer[22], p);
+		memcpy(unit->baSourceID, &buffer[22], p);
 		unit->extension.bControlSize = buffer[22+p];
-		unit->extension.bmControls = (__u8 *)unit + sizeof *unit + p;
-		unit->extension.bmControlsType = (__u8 *)unit + sizeof *unit
-					       + p + n;
+		unit->extension.bmControls = (__u8 *)unit + sizeof(*unit);
+		unit->extension.bmControlsType = (__u8 *)unit + sizeof(*unit)
+					       + n;
 		memcpy(unit->extension.bmControls, &buffer[23+p], 2*n);
 
 		if (buffer[24+p+2*n] != 0)
@@ -938,13 +937,11 @@ static int uvc_parse_standard_control(st
 			return -EINVAL;
 		}
 
-		term = kzalloc(sizeof *term + n + p, GFP_KERNEL);
+		term = uvc_alloc_entity(type | UVC_TERM_INPUT, buffer[3],
+					1, n + p);
 		if (term == NULL)
 			return -ENOMEM;
 
-		term->id = buffer[3];
-		term->type = type | UVC_TERM_INPUT;
-
 		if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA) {
 			term->camera.bControlSize = n;
 			term->camera.bmControls = (__u8 *)term + sizeof *term;
@@ -999,13 +996,12 @@ static int uvc_parse_standard_control(st
 			return 0;
 		}
 
-		term = kzalloc(sizeof *term, GFP_KERNEL);
+		term = uvc_alloc_entity(type | UVC_TERM_OUTPUT, buffer[3],
+					1, 0);
 		if (term == NULL)
 			return -ENOMEM;
 
-		term->id = buffer[3];
-		term->type = type | UVC_TERM_OUTPUT;
-		term->output.bSourceID = buffer[7];
+		memcpy(term->baSourceID, &buffer[7], 1);
 
 		if (buffer[8] != 0)
 			usb_string(udev, buffer[8], term->name,
@@ -1026,15 +1022,11 @@ static int uvc_parse_standard_control(st
 			return -EINVAL;
 		}
 
-		unit = kzalloc(sizeof *unit + p, GFP_KERNEL);
+		unit = uvc_alloc_entity(buffer[2], buffer[3], p + 1, 0);
 		if (unit == NULL)
 			return -ENOMEM;
 
-		unit->id = buffer[3];
-		unit->type = buffer[2];
-		unit->selector.bNrInPins = buffer[4];
-		unit->selector.baSourceID = (__u8 *)unit + sizeof *unit;
-		memcpy(unit->selector.baSourceID, &buffer[5], p);
+		memcpy(unit->baSourceID, &buffer[5], p);
 
 		if (buffer[5+p] != 0)
 			usb_string(udev, buffer[5+p], unit->name,
@@ -1056,13 +1048,11 @@ static int uvc_parse_standard_control(st
 			return -EINVAL;
 		}
 
-		unit = kzalloc(sizeof *unit + n, GFP_KERNEL);
+		unit = uvc_alloc_entity(buffer[2], buffer[3], 2, n);
 		if (unit == NULL)
 			return -ENOMEM;
 
-		unit->id = buffer[3];
-		unit->type = buffer[2];
-		unit->processing.bSourceID = buffer[4];
+		memcpy(unit->baSourceID, &buffer[4], 1);
 		unit->processing.wMaxMultiplier =
 			get_unaligned_le16(&buffer[5]);
 		unit->processing.bControlSize = buffer[7];
@@ -1091,19 +1081,15 @@ static int uvc_parse_standard_control(st
 			return -EINVAL;
 		}
 
-		unit = kzalloc(sizeof *unit + p + n, GFP_KERNEL);
+		unit = uvc_alloc_entity(buffer[2], buffer[3], p + 1, n);
 		if (unit == NULL)
 			return -ENOMEM;
 
-		unit->id = buffer[3];
-		unit->type = buffer[2];
 		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
 		unit->extension.bNumControls = buffer[20];
-		unit->extension.bNrInPins = buffer[21];
-		unit->extension.baSourceID = (__u8 *)unit + sizeof *unit;
-		memcpy(unit->extension.baSourceID, &buffer[22], p);
+		memcpy(unit->baSourceID, &buffer[22], p);
 		unit->extension.bControlSize = buffer[22+p];
-		unit->extension.bmControls = (__u8 *)unit + sizeof *unit + p;
+		unit->extension.bmControls = (__u8 *)unit + sizeof *unit;
 		memcpy(unit->extension.bmControls, &buffer[23+p], n);
 
 		if (buffer[23+p+n] != 0)
@@ -1209,7 +1195,7 @@ static int uvc_scan_chain_entity(struct 
 		if (uvc_trace_param & UVC_TRACE_PROBE)
 			printk(" <- XU %d", entity->id);
 
-		if (entity->extension.bNrInPins != 1) {
+		if (entity->bNrInPins != 1) {
 			uvc_trace(UVC_TRACE_DESCR, "Extension unit %d has more "
 				"than 1 input pin.\n", entity->id);
 			return -1;
@@ -1235,7 +1221,7 @@ static int uvc_scan_chain_entity(struct 
 			printk(" <- SU %d", entity->id);
 
 		/* Single-input selector units are ignored. */
-		if (entity->selector.bNrInPins == 1)
+		if (entity->bNrInPins == 1)
 			break;
 
 		if (chain->selector != NULL) {
@@ -1296,7 +1282,7 @@ static int uvc_scan_chain_forward(struct
 
 		switch (UVC_ENTITY_TYPE(forward)) {
 		case UVC_VC_EXTENSION_UNIT:
-			if (forward->extension.bNrInPins != 1) {
+			if (forward->bNrInPins != 1) {
 				uvc_trace(UVC_TRACE_DESCR, "Extension unit %d "
 					  "has more than 1 input pin.\n",
 					  entity->id);
@@ -1349,17 +1335,14 @@ static int uvc_scan_chain_backward(struc
 
 	switch (UVC_ENTITY_TYPE(entity)) {
 	case UVC_VC_EXTENSION_UNIT:
-		id = entity->extension.baSourceID[0];
-		break;
-
 	case UVC_VC_PROCESSING_UNIT:
-		id = entity->processing.bSourceID;
+		id = entity->baSourceID[0];
 		break;
 
 	case UVC_VC_SELECTOR_UNIT:
 		/* Single-input selector units are ignored. */
-		if (entity->selector.bNrInPins == 1) {
-			id = entity->selector.baSourceID[0];
+		if (entity->bNrInPins == 1) {
+			id = entity->baSourceID[0];
 			break;
 		}
 
@@ -1367,8 +1350,8 @@ static int uvc_scan_chain_backward(struc
 			printk(" <- IT");
 
 		chain->selector = entity;
-		for (i = 0; i < entity->selector.bNrInPins; ++i) {
-			id = entity->selector.baSourceID[i];
+		for (i = 0; i < entity->bNrInPins; ++i) {
+			id = entity->baSourceID[i];
 			term = uvc_entity_by_id(chain->dev, id);
 			if (term == NULL || !UVC_ENTITY_IS_ITERM(term)) {
 				uvc_trace(UVC_TRACE_DESCR, "Selector unit %d "
@@ -1397,7 +1380,7 @@ static int uvc_scan_chain_backward(struc
 	case UVC_OTT_DISPLAY:
 	case UVC_OTT_MEDIA_TRANSPORT_OUTPUT:
 	case UVC_TT_STREAMING:
-		id = UVC_ENTITY_IS_OTERM(entity) ? entity->output.bSourceID : 0;
+		id = UVC_ENTITY_IS_OTERM(entity) ? entity->baSourceID[0] : 0;
 		break;
 	}
 
Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_v4l2.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvc_v4l2.c
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_v4l2.c
@@ -633,8 +633,8 @@ static long uvc_v4l2_do_ioctl(struct fil
 					break;
 			}
 			pin = iterm->id;
-		} else if (pin < selector->selector.bNrInPins) {
-			pin = selector->selector.baSourceID[index];
+		} else if (pin < selector->bNrInPins) {
+			pin = selector->baSourceID[index];
 			list_for_each_entry(iterm, &chain->entities, chain) {
 				if (!UVC_ENTITY_IS_ITERM(iterm))
 					continue;
@@ -688,7 +688,7 @@ static long uvc_v4l2_do_ioctl(struct fil
 			break;
 		}
 
-		if (input == 0 || input > chain->selector->selector.bNrInPins)
+		if (input == 0 || input > chain->selector->bNrInPins)
 			return -EINVAL;
 
 		return uvc_query_ctrl(chain->dev, UVC_SET_CUR,
Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvcvideo.h
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvcvideo.h
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvcvideo.h
@@ -294,11 +294,9 @@ struct uvc_entity {
 		} media;
 
 		struct {
-			__u8  bSourceID;
 		} output;
 
 		struct {
-			__u8  bSourceID;
 			__u16 wMaxMultiplier;
 			__u8  bControlSize;
 			__u8  *bmControls;
@@ -306,21 +304,20 @@ struct uvc_entity {
 		} processing;
 
 		struct {
-			__u8  bNrInPins;
-			__u8  *baSourceID;
 		} selector;
 
 		struct {
 			__u8  guidExtensionCode[16];
 			__u8  bNumControls;
-			__u8  bNrInPins;
-			__u8  *baSourceID;
 			__u8  bControlSize;
 			__u8  *bmControls;
 			__u8  *bmControlsType;
 		} extension;
 	};
 
+	__u8 bNrInPins;
+	__u8 *baSourceID;
+
 	unsigned int ncontrols;
 	struct uvc_control *controls;
 };


