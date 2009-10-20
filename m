Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43881 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbZJTIO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:56 -0400
Message-Id: <20091020011215.545464039@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:19 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 09/14] uvcvideo: Merge iterms, oterms and extensions linked lists
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=uvc-rename-extensions-to-units.patch
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All terminals and units are now added to a single linked list of
entities per chain. This makes terminals and units handling code more
generic.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_ctrl.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvc_ctrl.c
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_ctrl.c
@@ -744,17 +744,7 @@ struct uvc_control *uvc_find_control(str
 	v4l2_id &= V4L2_CTRL_ID_MASK;
 
 	/* Find the control. */
-	__uvc_find_control(chain->processing, v4l2_id, mapping, &ctrl, next);
-	if (ctrl && !next)
-		return ctrl;
-
-	list_for_each_entry(entity, &chain->iterms, chain) {
-		__uvc_find_control(entity, v4l2_id, mapping, &ctrl, next);
-		if (ctrl && !next)
-			return ctrl;
-	}
-
-	list_for_each_entry(entity, &chain->extensions, chain) {
+	list_for_each_entry(entity, &chain->entities, chain) {
 		__uvc_find_control(entity, v4l2_id, mapping, &ctrl, next);
 		if (ctrl && !next)
 			return ctrl;
@@ -946,17 +936,7 @@ int __uvc_ctrl_commit(struct uvc_video_c
 	int ret = 0;
 
 	/* Find the control. */
-	ret = uvc_ctrl_commit_entity(chain->dev, chain->processing, rollback);
-	if (ret < 0)
-		goto done;
-
-	list_for_each_entry(entity, &chain->iterms, chain) {
-		ret = uvc_ctrl_commit_entity(chain->dev, entity, rollback);
-		if (ret < 0)
-			goto done;
-	}
-
-	list_for_each_entry(entity, &chain->extensions, chain) {
+	list_for_each_entry(entity, &chain->entities, chain) {
 		ret = uvc_ctrl_commit_entity(chain->dev, entity, rollback);
 		if (ret < 0)
 			goto done;
@@ -1070,8 +1050,9 @@ int uvc_xu_ctrl_query(struct uvc_video_c
 	int ret;
 
 	/* Find the extension unit. */
-	list_for_each_entry(entity, &chain->extensions, chain) {
-		if (entity->id == xctrl->unit)
+	list_for_each_entry(entity, &chain->entities, chain) {
+		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT &&
+		    entity->id == xctrl->unit)
 			break;
 	}
 
Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvc_driver.c
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
@@ -1215,7 +1215,6 @@ static int uvc_scan_chain_entity(struct 
 			return -1;
 		}
 
-		list_add_tail(&entity->chain, &chain->extensions);
 		break;
 
 	case UVC_VC_PROCESSING_UNIT:
@@ -1254,7 +1253,6 @@ static int uvc_scan_chain_entity(struct 
 		if (uvc_trace_param & UVC_TRACE_PROBE)
 			printk(" <- IT %d\n", entity->id);
 
-		list_add_tail(&entity->chain, &chain->iterms);
 		break;
 
 	case UVC_TT_STREAMING:
@@ -1267,7 +1265,6 @@ static int uvc_scan_chain_entity(struct 
 			return -1;
 		}
 
-		list_add_tail(&entity->chain, &chain->iterms);
 		break;
 
 	default:
@@ -1276,6 +1273,7 @@ static int uvc_scan_chain_entity(struct 
 		return -1;
 	}
 
+	list_add_tail(&entity->chain, &chain->entities);
 	return 0;
 }
 
@@ -1306,7 +1304,7 @@ static int uvc_scan_chain_forward(struct
 				return -EINVAL;
 			}
 
-			list_add_tail(&forward->chain, &chain->extensions);
+			list_add_tail(&forward->chain, &chain->entities);
 			if (uvc_trace_param & UVC_TRACE_PROBE) {
 				if (!found)
 					printk(" (->");
@@ -1326,7 +1324,7 @@ static int uvc_scan_chain_forward(struct
 				return -EINVAL;
 			}
 
-			list_add_tail(&forward->chain, &chain->oterms);
+			list_add_tail(&forward->chain, &chain->entities);
 			if (uvc_trace_param & UVC_TRACE_PROBE) {
 				if (!found)
 					printk(" (->");
@@ -1382,7 +1380,7 @@ static int uvc_scan_chain_backward(struc
 			if (uvc_trace_param & UVC_TRACE_PROBE)
 				printk(" %d", term->id);
 
-			list_add_tail(&term->chain, &chain->iterms);
+			list_add_tail(&term->chain, &chain->entities);
 			uvc_scan_chain_forward(chain, term, entity);
 		}
 
@@ -1403,7 +1401,7 @@ static int uvc_scan_chain(struct uvc_vid
 	int id;
 
 	entity = oterm;
-	list_add_tail(&entity->chain, &chain->oterms);
+	list_add_tail(&entity->chain, &chain->entities);
 	uvc_trace(UVC_TRACE_PROBE, "Scanning UVC chain: OT %d", entity->id);
 
 	id = entity->output.bSourceID;
@@ -1443,21 +1441,25 @@ static int uvc_scan_chain(struct uvc_vid
 	return 0;
 }
 
-static unsigned int uvc_print_terms(struct list_head *terms, char *buffer)
+static unsigned int uvc_print_terms(struct list_head *terms, u16 dir,
+		char *buffer)
 {
 	struct uvc_entity *term;
 	unsigned int nterms = 0;
 	char *p = buffer;
 
 	list_for_each_entry(term, terms, chain) {
-		p += sprintf(p, "%u", term->id);
-		if (term->chain.next != terms) {
+		if (!UVC_ENTITY_IS_TERM(term) ||
+		    UVC_TERM_DIRECTION(term) != dir)
+			continue;
+
+		if (nterms)
 			p += sprintf(p, ",");
-			if (++nterms >= 4) {
-				p += sprintf(p, "...");
-				break;
-			}
+		if (++nterms >= 4) {
+			p += sprintf(p, "...");
+			break;
 		}
+		p += sprintf(p, "%u", term->id);
 	}
 
 	return p - buffer;
@@ -1468,9 +1470,9 @@ static const char *uvc_print_chain(struc
 	static char buffer[43];
 	char *p = buffer;
 
-	p += uvc_print_terms(&chain->iterms, p);
+	p += uvc_print_terms(&chain->entities, UVC_TERM_INPUT, p);
 	p += sprintf(p, " -> ");
-	uvc_print_terms(&chain->oterms, p);
+	uvc_print_terms(&chain->entities, UVC_TERM_OUTPUT, p);
 
 	return buffer;
 }
@@ -1501,9 +1503,7 @@ static int uvc_scan_device(struct uvc_de
 		if (chain == NULL)
 			return -ENOMEM;
 
-		INIT_LIST_HEAD(&chain->iterms);
-		INIT_LIST_HEAD(&chain->oterms);
-		INIT_LIST_HEAD(&chain->extensions);
+		INIT_LIST_HEAD(&chain->entities);
 		mutex_init(&chain->ctrl_mutex);
 		chain->dev = dev;
 
@@ -1676,13 +1676,13 @@ static int uvc_register_video(struct uvc
  * Register all video devices in all chains.
  */
 static int uvc_register_terms(struct uvc_device *dev,
-	struct uvc_video_chain *chain, struct list_head *terms)
+	struct uvc_video_chain *chain)
 {
 	struct uvc_streaming *stream;
 	struct uvc_entity *term;
 	int ret;
 
-	list_for_each_entry(term, terms, chain) {
+	list_for_each_entry(term, &chain->entities, chain) {
 		if (UVC_ENTITY_TYPE(term) != UVC_TT_STREAMING)
 			continue;
 
@@ -1708,11 +1708,7 @@ static int uvc_register_chains(struct uv
 	int ret;
 
 	list_for_each_entry(chain, &dev->chains, list) {
-		ret = uvc_register_terms(dev, chain, &chain->iterms);
-		if (ret < 0)
-			return ret;
-
-		ret = uvc_register_terms(dev, chain, &chain->oterms);
+		ret = uvc_register_terms(dev, chain);
 		if (ret < 0)
 			return ret;
 	}
Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvcvideo.h
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvcvideo.h
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvcvideo.h
@@ -76,6 +76,7 @@ struct uvc_xu_control {
 
 #define UVC_TERM_INPUT			0x0000
 #define UVC_TERM_OUTPUT			0x8000
+#define UVC_TERM_DIRECTION(term)	((term)->type & 0x8000)
 
 #define UVC_ENTITY_TYPE(entity)		((entity)->type & 0x7fff)
 #define UVC_ENTITY_IS_UNIT(entity)	(((entity)->type & 0xff00) == 0)
@@ -409,11 +410,9 @@ struct uvc_video_chain {
 	struct uvc_device *dev;
 	struct list_head list;
 
-	struct list_head iterms;		/* Input terminals */
-	struct list_head oterms;		/* Output terminals */
+	struct list_head entities;		/* All entities */
 	struct uvc_entity *processing;		/* Processing unit */
 	struct uvc_entity *selector;		/* Selector unit */
-	struct list_head extensions;		/* Extension units */
 
 	struct mutex ctrl_mutex;
 };
Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_v4l2.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvc_v4l2.c
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_v4l2.c
@@ -628,12 +628,16 @@ static long uvc_v4l2_do_ioctl(struct fil
 		    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
 			if (index != 0)
 				return -EINVAL;
-			iterm = list_first_entry(&chain->iterms,
-					struct uvc_entity, chain);
+			list_for_each_entry(iterm, &chain->entities, chain) {
+				if (UVC_ENTITY_IS_ITERM(iterm))
+					break;
+			}
 			pin = iterm->id;
 		} else if (pin < selector->selector.bNrInPins) {
 			pin = selector->selector.baSourceID[index];
-			list_for_each_entry(iterm, chain->iterms.next, chain) {
+			list_for_each_entry(iterm, &chain->entities, chain) {
+				if (!UVC_ENTITY_IS_ITERM(iterm))
+					continue;
 				if (iterm->id == pin)
 					break;
 			}


