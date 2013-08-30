Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:41771 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3H3CRi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:38 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so1222326pbb.6
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:37 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 06/19] uvcvideo: Recognize UVC 1.5 encoding units.
Date: Fri, 30 Aug 2013 11:17:05 +0900
Message-Id: <1377829038-4726-7-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add encoding unit definitions and descriptor parsing code and allow them to
be added to chains.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c   | 37 ++++++++++++++++++---
 drivers/media/usb/uvc/uvc_driver.c | 67 +++++++++++++++++++++++++++++++++-----
 drivers/media/usb/uvc/uvcvideo.h   | 14 +++++++-
 include/uapi/linux/usb/video.h     |  1 +
 4 files changed, 105 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index ba159a4..72d6724 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -777,6 +777,7 @@ static const __u8 uvc_processing_guid[16] = UVC_GUID_UVC_PROCESSING;
 static const __u8 uvc_camera_guid[16] = UVC_GUID_UVC_CAMERA;
 static const __u8 uvc_media_transport_input_guid[16] =
 	UVC_GUID_UVC_MEDIA_TRANSPORT_INPUT;
+static const __u8 uvc_encoding_guid[16] = UVC_GUID_UVC_ENCODING;
 
 static int uvc_entity_match_guid(const struct uvc_entity *entity,
 	const __u8 guid[16])
@@ -795,6 +796,9 @@ static int uvc_entity_match_guid(const struct uvc_entity *entity,
 		return memcmp(entity->extension.guidExtensionCode,
 			      guid, 16) == 0;
 
+	case UVC_VC_ENCODING_UNIT:
+		return memcmp(uvc_encoding_guid, guid, 16) == 0;
+
 	default:
 		return 0;
 	}
@@ -2105,12 +2109,13 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 {
 	struct uvc_entity *entity;
 	unsigned int i;
+	int num_found;
 
 	/* Walk the entities list and instantiate controls */
 	list_for_each_entry(entity, &dev->entities, list) {
 		struct uvc_control *ctrl;
-		unsigned int bControlSize = 0, ncontrols;
-		__u8 *bmControls = NULL;
+		unsigned int bControlSize = 0, ncontrols = 0;
+		__u8 *bmControls = NULL, *bmControlsRuntime = NULL;
 
 		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
 			bmControls = entity->extension.bmControls;
@@ -2121,13 +2126,25 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 		} else if (UVC_ENTITY_TYPE(entity) == UVC_ITT_CAMERA) {
 			bmControls = entity->camera.bmControls;
 			bControlSize = entity->camera.bControlSize;
+		} else if (UVC_ENTITY_TYPE(entity) == UVC_VC_ENCODING_UNIT) {
+			bmControls = entity->encoding.bmControls;
+			bmControlsRuntime = entity->encoding.bmControlsRuntime;
+			bControlSize = entity->encoding.bControlSize;
 		}
 
 		/* Remove bogus/blacklisted controls */
 		uvc_ctrl_prune_entity(dev, entity);
 
 		/* Count supported controls and allocate the controls array */
-		ncontrols = memweight(bmControls, bControlSize);
+		for (i = 0; i < bControlSize; ++i) {
+			if (bmControlsRuntime) {
+				ncontrols += hweight8(bmControls[i]
+						      | bmControlsRuntime[i]);
+			} else {
+				ncontrols += hweight8(bmControls[i]);
+			}
+		}
+
 		if (ncontrols == 0)
 			continue;
 
@@ -2139,8 +2156,17 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 
 		/* Initialize all supported controls */
 		ctrl = entity->controls;
-		for (i = 0; i < bControlSize * 8; ++i) {
-			if (uvc_test_bit(bmControls, i) == 0)
+		for (i = 0, num_found = 0;
+			i < bControlSize * 8 && num_found < ncontrols; ++i) {
+			if (uvc_test_bit(bmControls, i) == 1)
+				ctrl->on_init = 1;
+			if (bmControlsRuntime &&
+				uvc_test_bit(bmControlsRuntime, i) == 1)
+				ctrl->in_runtime = 1;
+			else if (!bmControlsRuntime)
+				ctrl->in_runtime = ctrl->on_init;
+
+			if (ctrl->on_init == 0 && ctrl->in_runtime == 0)
 				continue;
 
 			ctrl->entity = entity;
@@ -2148,6 +2174,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 
 			uvc_ctrl_init_ctrl(dev, ctrl);
 			ctrl++;
+			num_found++;
 		}
 	}
 
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index d7ff707..d950b40 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1155,6 +1155,37 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		list_add_tail(&unit->list, &dev->entities);
 		break;
 
+	case UVC_VC_ENCODING_UNIT:
+		n = buflen >= 7 ? buffer[6] : 0;
+
+		if (buflen < 7 + 2 * n) {
+			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
+				"interface %d ENCODING_UNIT error\n",
+				udev->devnum, alts->desc.bInterfaceNumber);
+			return -EINVAL;
+		}
+
+		unit = uvc_alloc_entity(buffer[2], buffer[3], 2, 2 * n);
+		if (unit == NULL)
+			return -ENOMEM;
+
+		memcpy(unit->baSourceID, &buffer[4], 1);
+		unit->encoding.bControlSize = buffer[6];
+		unit->encoding.bmControls = (__u8 *)unit + sizeof(*unit);
+		memcpy(unit->encoding.bmControls, &buffer[7], n);
+		unit->encoding.bmControlsRuntime = unit->encoding.bmControls
+						 + n;
+		memcpy(unit->encoding.bmControlsRuntime, &buffer[7 + n], n);
+
+		if (buffer[5] != 0)
+			usb_string(udev, buffer[5], unit->name,
+				   sizeof(unit->name));
+		else
+			sprintf(unit->name, "encoding %u", buffer[3]);
+
+		list_add_tail(&unit->list, &dev->entities);
+		break;
+
 	default:
 		uvc_trace(UVC_TRACE_DESCR, "Found an unknown CS_INTERFACE "
 			"descriptor (%u)\n", buffer[2]);
@@ -1251,25 +1282,31 @@ static void uvc_delete_chain(struct uvc_video_chain *chain)
  *
  * - one or more Output Terminals (USB Streaming or Display)
  * - zero or one Processing Unit
+ * - zero or one Encoding Unit
  * - zero, one or more single-input Selector Units
  * - zero or one multiple-input Selector Units, provided all inputs are
  *   connected to input terminals
- * - zero, one or mode single-input Extension Units
+ * - zero, one or more single-input Extension Units
  * - one or more Input Terminals (Camera, External or USB Streaming)
  *
- * The terminal and units must match on of the following structures:
+ * The terminal and units must match one of the following structures:
  *
- * ITT_*(0) -> +---------+    +---------+    +---------+ -> TT_STREAMING(0)
- * ...         | SU{0,1} | -> | PU{0,1} | -> | XU{0,n} |    ...
- * ITT_*(n) -> +---------+    +---------+    +---------+ -> TT_STREAMING(n)
+ * ITT_*(0) -> +---------+                        -> TT_STREAMING(0)
+ * ...         | SU{0,1} | ->        (...)           ...
+ * ITT_*(n) -> +---------+                        -> TT_STREAMING(n)
+ *
+ *    Where (...), in any order:
+ *             +---------+    +---------+    +---------+
+ *             | PU{0,1} | -> | XU{0,n} | -> | EU{0,1} |
+ *             +---------+    +---------+    +---------+
  *
  *                 +---------+    +---------+ -> OTT_*(0)
  * TT_STREAMING -> | PU{0,1} | -> | XU{0,n} |    ...
  *                 +---------+    +---------+ -> OTT_*(n)
  *
- * The Processing Unit and Extension Units can be in any order. Additional
- * Extension Units connected to the main chain as single-unit branches are
- * also supported. Single-input Selector Units are ignored.
+ * The Processing Unit, the Encoding Unit and Extension Units can be in any
+ * order. Additional Extension Units connected to the main chain as single-unit
+ * branches are also supported. Single-input Selector Units are ignored.
  */
 static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 	struct uvc_entity *entity)
@@ -1317,6 +1354,19 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 		chain->selector = entity;
 		break;
 
+	case UVC_VC_ENCODING_UNIT:
+		if (uvc_trace_param & UVC_TRACE_PROBE)
+			printk(" <- EU %d", entity->id);
+
+		if (chain->encoding != NULL) {
+			uvc_trace(UVC_TRACE_DESCR, "Found multiple "
+				"Encoding Units in chain.\n");
+			return -1;
+		}
+
+		chain->encoding = entity;
+		break;
+
 	case UVC_ITT_VENDOR_SPECIFIC:
 	case UVC_ITT_CAMERA:
 	case UVC_ITT_MEDIA_TRANSPORT_INPUT:
@@ -1364,6 +1414,7 @@ static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
 	switch (UVC_ENTITY_TYPE(entity)) {
 	case UVC_VC_EXTENSION_UNIT:
 	case UVC_VC_PROCESSING_UNIT:
+	case UVC_VC_ENCODING_UNIT:
 		id = entity->baSourceID[0];
 		break;
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 731b378..109c0a2 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -54,6 +54,9 @@
 #define UVC_GUID_UVC_SELECTOR \
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02}
+#define UVC_GUID_UVC_ENCODING \
+	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
+	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03}
 
 #define UVC_GUID_FORMAT_MJPEG \
 	{ 'M',  'J',  'P',  'G', 0x00, 0x00, 0x10, 0x00, \
@@ -199,7 +202,9 @@ struct uvc_control {
 	     loaded:1,
 	     modified:1,
 	     cached:1,
-	     initialized:1;
+	     initialized:1,
+	     on_init:1, /* supported during initialization */
+	     in_runtime:1; /* supported in runtime */
 
 	__u8 *uvc_data;
 };
@@ -281,6 +286,12 @@ struct uvc_entity {
 			__u8  *bmControls;
 			__u8  *bmControlsType;
 		} extension;
+
+		struct {
+			__u8  bControlSize;
+			__u8  *bmControls;
+			__u8  *bmControlsRuntime;
+		} encoding;
 	};
 
 	__u8 bNrInPins;
@@ -386,6 +397,7 @@ struct uvc_video_chain {
 	struct list_head entities;		/* All entities */
 	struct uvc_entity *processing;		/* Processing unit */
 	struct uvc_entity *selector;		/* Selector unit */
+	struct uvc_entity *encoding;		/* Encoding unit */
 
 	struct uvc_video_pipeline *pipeline;    /* Pipeline this chain
 						   belongs to */
diff --git a/include/uapi/linux/usb/video.h b/include/uapi/linux/usb/video.h
index 331c071..eb48ba8 100644
--- a/include/uapi/linux/usb/video.h
+++ b/include/uapi/linux/usb/video.h
@@ -37,6 +37,7 @@
 #define UVC_VC_SELECTOR_UNIT				0x04
 #define UVC_VC_PROCESSING_UNIT				0x05
 #define UVC_VC_EXTENSION_UNIT				0x06
+#define UVC_VC_ENCODING_UNIT				0x07
 
 /* A.6. Video Class-Specific VS Interface Descriptor Subtypes */
 #define UVC_VS_UNDEFINED				0x00
-- 
1.8.4

