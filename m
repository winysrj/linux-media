Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43881 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbZJTIO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:57 -0400
Message-Id: <20091020011215.754611441@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:21 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 11/14] uvcvideo: Refactor chain scan
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=uvc-refactor-chain-scan.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't handle the first output terminal in a chain in a special way. Use
uvc_scan_chain_entity() like for all other entities, making the chain
scan code more generic.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvc_driver.c
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
@@ -1256,13 +1256,12 @@ static int uvc_scan_chain_entity(struct 
 		break;
 
 	case UVC_TT_STREAMING:
-		if (uvc_trace_param & UVC_TRACE_PROBE)
-			printk(" <- IT %d\n", entity->id);
-
-		if (!UVC_ENTITY_IS_ITERM(entity)) {
-			uvc_trace(UVC_TRACE_DESCR, "Unsupported input "
-				"terminal %u.\n", entity->id);
-			return -1;
+		if (UVC_ENTITY_IS_ITERM(entity)) {
+			if (uvc_trace_param & UVC_TRACE_PROBE)
+				printk(" <- IT %d\n", entity->id);
+		} else {
+			if (uvc_trace_param & UVC_TRACE_PROBE)
+				printk(" OT %d", entity->id);
 		}
 
 		break;
@@ -1342,10 +1341,11 @@ static int uvc_scan_chain_forward(struct
 }
 
 static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
-	struct uvc_entity *entity)
+	struct uvc_entity **_entity)
 {
+	struct uvc_entity *entity = *_entity;
 	struct uvc_entity *term;
-	int id = -1, i;
+	int id = -EINVAL, i;
 
 	switch (UVC_ENTITY_TYPE(entity)) {
 	case UVC_VC_EXTENSION_UNIT:
@@ -1389,34 +1389,49 @@ static int uvc_scan_chain_backward(struc
 
 		id = 0;
 		break;
+
+	case UVC_ITT_VENDOR_SPECIFIC:
+	case UVC_ITT_CAMERA:
+	case UVC_ITT_MEDIA_TRANSPORT_INPUT:
+	case UVC_OTT_VENDOR_SPECIFIC:
+	case UVC_OTT_DISPLAY:
+	case UVC_OTT_MEDIA_TRANSPORT_OUTPUT:
+	case UVC_TT_STREAMING:
+		id = UVC_ENTITY_IS_OTERM(entity) ? entity->output.bSourceID : 0;
+		break;
+	}
+
+	if (id <= 0) {
+		*_entity = NULL;
+		return id;
+	}
+
+	entity = uvc_entity_by_id(chain->dev, id);
+	if (entity == NULL) {
+		uvc_trace(UVC_TRACE_DESCR, "Found reference to "
+			"unknown entity %d.\n", id);
+		return -EINVAL;
 	}
 
-	return id;
+	*_entity = entity;
+	return 0;
 }
 
 static int uvc_scan_chain(struct uvc_video_chain *chain,
-			  struct uvc_entity *oterm)
+			  struct uvc_entity *term)
 {
 	struct uvc_entity *entity, *prev;
-	int id;
 
-	entity = oterm;
-	list_add_tail(&entity->chain, &chain->entities);
-	uvc_trace(UVC_TRACE_PROBE, "Scanning UVC chain: OT %d", entity->id);
+	uvc_trace(UVC_TRACE_PROBE, "Scanning UVC chain:");
 
-	id = entity->output.bSourceID;
-	while (id != 0) {
-		prev = entity;
-		entity = uvc_entity_by_id(chain->dev, id);
-		if (entity == NULL) {
-			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
-				"unknown entity %d.\n", id);
-			return -EINVAL;
-		}
+	entity = term;
+	prev = NULL;
 
+	while (entity != NULL) {
+		/* Entity must not be part of an existing chain */
 		if (entity->chain.next || entity->chain.prev) {
 			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
-				"entity %d already in chain.\n", id);
+				"entity %d already in chain.\n", entity->id);
 			return -EINVAL;
 		}
 
@@ -1428,14 +1443,10 @@ static int uvc_scan_chain(struct uvc_vid
 		if (uvc_scan_chain_forward(chain, entity, prev) < 0)
 			return -EINVAL;
 
-		/* Stop when a terminal is found. */
-		if (UVC_ENTITY_IS_TERM(entity))
-			break;
-
 		/* Backward scan */
-		id = uvc_scan_chain_backward(chain, entity);
-		if (id < 0)
-			return id;
+		prev = entity;
+		if (uvc_scan_chain_backward(chain, &entity) < 0)
+			return -EINVAL;
 	}
 
 	return 0;


