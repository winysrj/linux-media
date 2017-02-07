Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60004 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754088AbdBGQ3n (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 11:29:43 -0500
Received: from axis700.grange ([81.173.166.100]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MRCCJ-1d0c710RSx-00UeuR for
 <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 17:29:40 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 2F0E68B111
        for <linux-media@vger.kernel.org>; Tue,  7 Feb 2017 17:29:37 +0100 (CET)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 1/4] uvcvideo: prepare to support compound controls
Date: Tue,  7 Feb 2017 17:29:33 +0100
Message-Id: <1486484976-17365-2-git-send-email-guennadi.liakhovetski@intel.com>
In-Reply-To: <1486484976-17365-1-git-send-email-guennadi.liakhovetski@intel.com>
References: <1486484976-17365-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not all V4L2 or UVC controls use arguments, that fit in 32 bits, some
occupy buffers of arbitrary size. To support them uvcvideo control
mapping .get() and .set() methods should take memory buffers as
arguments instead of 32-bit integers.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 143 +++++++++++++++++++++++++--------------
 drivers/media/usb/uvc/uvcvideo.h |   8 +--
 2 files changed, 98 insertions(+), 53 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c2ee6e3..6e33bd0 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -366,58 +366,82 @@
 	{ 8, "Aperture Priority Mode" },
 };
 
-static __s32 uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
-	__u8 query, const __u8 *data)
+static void uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
+	__u8 query, const __u8 *data, void *value, size_t size)
 {
 	__s8 zoom = (__s8)data[0];
+	__s32 *result = value;
+
+	if (unlikely(size != sizeof(*result))) {
+		/* At least make sure not to return random kernel bytes */
+		memset(value, 0, size);
+		return;
+	}
 
 	switch (query) {
 	case UVC_GET_CUR:
-		return (zoom == 0) ? 0 : (zoom > 0 ? data[2] : -data[2]);
-
+		*result = (zoom == 0) ? 0 : (zoom > 0 ? data[2] : -data[2]);
+		break;
 	case UVC_GET_MIN:
 	case UVC_GET_MAX:
 	case UVC_GET_RES:
 	case UVC_GET_DEF:
 	default:
-		return data[2];
+		*result = data[2];
 	}
 }
 
 static void uvc_ctrl_set_zoom(struct uvc_control_mapping *mapping,
-	__s32 value, __u8 *data)
+	__u8 *data, const void *value, size_t size)
 {
-	data[0] = value == 0 ? 0 : (value > 0) ? 1 : 0xff;
-	data[2] = min((int)abs(value), 0xff);
+	const __s32 *value32 = value;
+
+	if (unlikely(size != sizeof(*value32)))
+		return;
+
+	data[0] = *value32 == 0 ? 0 : (*value32 > 0) ? 1 : 0xff;
+	data[2] = min((int)abs(*value32), 0xff);
 }
 
-static __s32 uvc_ctrl_get_rel_speed(struct uvc_control_mapping *mapping,
-	__u8 query, const __u8 *data)
+static void uvc_ctrl_get_rel_speed(struct uvc_control_mapping *mapping,
+	__u8 query, const __u8 *data, void *value, size_t size)
 {
 	unsigned int first = mapping->offset / 8;
 	__s8 rel = (__s8)data[first];
+	__s32 *result = value;
+
+	if (unlikely(size != sizeof(*result))) {
+		memset(value, 0, size);
+		return;
+	}
 
 	switch (query) {
 	case UVC_GET_CUR:
-		return (rel == 0) ? 0 : (rel > 0 ? data[first+1]
+		*result = (rel == 0) ? 0 : (rel > 0 ? data[first+1]
 						 : -data[first+1]);
+		break;
 	case UVC_GET_MIN:
-		return -data[first+1];
+		*result = -data[first+1];
+		break;
 	case UVC_GET_MAX:
 	case UVC_GET_RES:
 	case UVC_GET_DEF:
 	default:
-		return data[first+1];
+		*result = data[first+1];
 	}
 }
 
 static void uvc_ctrl_set_rel_speed(struct uvc_control_mapping *mapping,
-	__s32 value, __u8 *data)
+	__u8 *data, const void *value, size_t size)
 {
+	const __s32 *value32 = value;
 	unsigned int first = mapping->offset / 8;
 
-	data[first] = value == 0 ? 0 : (value > 0) ? 1 : 0xff;
-	data[first+1] = min_t(int, abs(value), 0xff);
+	if (unlikely(size != sizeof(*value32)))
+		return;
+
+	data[first] = *value32 == 0 ? 0 : (*value32 > 0) ? 1 : 0xff;
+	data[first+1] = min_t(int, abs(*value32), 0xff);
 }
 
 static struct uvc_control_mapping uvc_ctrl_mappings[] = {
@@ -765,21 +789,27 @@ static inline void uvc_clear_bit(__u8 *data, int bit)
  * a signed 32bit integer. Sign extension will be performed if the mapping
  * references a signed data type.
  */
-static __s32 uvc_get_le_value(struct uvc_control_mapping *mapping,
-	__u8 query, const __u8 *data)
+static void uvc_get_le_value(struct uvc_control_mapping *mapping,
+	__u8 query, const __u8 *data, void *value, size_t size)
 {
 	int bits = mapping->size;
 	int offset = mapping->offset;
-	__s32 value = 0;
+	__s32 *result = value;
 	__u8 mask;
 
+	if (unlikely(size != sizeof(*result))) {
+		memset(value, 0, size);
+		return;
+	}
+
 	data += offset / 8;
 	offset &= 7;
 	mask = ((1LL << bits) - 1) << offset;
+	*result = 0;
 
 	for (; bits > 0; data++) {
 		__u8 byte = *data & mask;
-		value |= offset > 0 ? (byte >> offset) : (byte << (-offset));
+		*result |= offset > 0 ? (byte >> offset) : (byte << (-offset));
 		bits -= 8 - (offset > 0 ? offset : 0);
 		offset -= 8;
 		mask = (1 << bits) - 1;
@@ -787,36 +817,40 @@ static __s32 uvc_get_le_value(struct uvc_control_mapping *mapping,
 
 	/* Sign-extend the value if needed. */
 	if (mapping->data_type == UVC_CTRL_DATA_TYPE_SIGNED)
-		value |= -(value & (1 << (mapping->size - 1)));
-
-	return value;
+		*result |= -(*result & (1 << (mapping->size - 1)));
 }
 
 /* Set the bit string specified by mapping->offset and mapping->size
  * in the little-endian data stored at 'data' to the value 'value'.
  */
 static void uvc_set_le_value(struct uvc_control_mapping *mapping,
-	__s32 value, __u8 *data)
+	__u8 *data, const void *value, size_t size)
 {
 	int bits = mapping->size;
 	int offset = mapping->offset;
+	__s32 value32;
 	__u8 mask;
 
+	if (unlikely(size != sizeof(value32)))
+		return;
+
+	value32 = *(const __s32 *)value;
+
 	/* According to the v4l2 spec, writing any value to a button control
 	 * should result in the action belonging to the button control being
 	 * triggered. UVC devices however want to see a 1 written -> override
 	 * value.
 	 */
 	if (mapping->v4l2_type == V4L2_CTRL_TYPE_BUTTON)
-		value = -1;
+		value32 = -1;
 
 	data += offset / 8;
 	offset &= 7;
 
 	for (; bits > 0; data++) {
 		mask = ((1LL << bits) - 1) << offset;
-		*data = (*data & ~mask) | ((value << offset) & mask);
-		value >>= offset ? offset : 8;
+		*data = (*data & ~mask) | ((value32 << offset) & mask);
+		value32 >>= offset ? offset : 8;
 		bits -= 8 - offset;
 		offset = 0;
 	}
@@ -993,8 +1027,9 @@ static int __uvc_ctrl_get(struct uvc_video_chain *chain,
 		ctrl->loaded = 1;
 	}
 
-	*value = mapping->get(mapping, UVC_GET_CUR,
-		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
+	mapping->get(mapping, UVC_GET_CUR,
+		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+		value, sizeof(*value));
 
 	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
 		menu = mapping->menu_info;
@@ -1050,8 +1085,10 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	}
 
 	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_DEF) {
-		v4l2_ctrl->default_value = mapping->get(mapping, UVC_GET_DEF,
-				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_DEF));
+		mapping->get(mapping, UVC_GET_DEF,
+			     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_DEF),
+			     &v4l2_ctrl->default_value,
+			     sizeof(v4l2_ctrl->default_value));
 	}
 
 	switch (mapping->v4l2_type) {
@@ -1087,16 +1124,19 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	}
 
 	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_MIN)
-		v4l2_ctrl->minimum = mapping->get(mapping, UVC_GET_MIN,
-				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MIN));
+		mapping->get(mapping, UVC_GET_MIN,
+			     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MIN),
+			     &v4l2_ctrl->minimum, sizeof(v4l2_ctrl->minimum));
 
 	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_MAX)
-		v4l2_ctrl->maximum = mapping->get(mapping, UVC_GET_MAX,
-				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MAX));
+		mapping->get(mapping, UVC_GET_MAX,
+			     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MAX),
+			     &v4l2_ctrl->maximum, sizeof(v4l2_ctrl->maximum));
 
 	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_RES)
-		v4l2_ctrl->step = mapping->get(mapping, UVC_GET_RES,
-				  uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
+		mapping->get(mapping, UVC_GET_RES,
+			     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES),
+			     &v4l2_ctrl->step, sizeof(v4l2_ctrl->step));
 
 	return 0;
 }
@@ -1174,8 +1214,9 @@ int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
 				goto done;
 		}
 
-		bitmap = mapping->get(mapping, UVC_GET_RES,
-				      uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
+		mapping->get(mapping, UVC_GET_RES,
+			     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES),
+			     &bitmap, sizeof(bitmap));
 		if (!(bitmap & menu_info->value)) {
 			ret = -EINVAL;
 			goto done;
@@ -1498,12 +1539,15 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 				return ret;
 		}
 
-		min = mapping->get(mapping, UVC_GET_MIN,
-				   uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MIN));
-		max = mapping->get(mapping, UVC_GET_MAX,
-				   uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MAX));
-		step = mapping->get(mapping, UVC_GET_RES,
-				    uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
+		mapping->get(mapping, UVC_GET_MIN,
+			     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MIN),
+			     &min, sizeof(min));
+		mapping->get(mapping, UVC_GET_MAX,
+			     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MAX),
+			     &max, sizeof(max));
+		mapping->get(mapping, UVC_GET_RES,
+			     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES),
+			     &step, sizeof(step));
 		if (step == 0)
 			step = 1;
 
@@ -1537,8 +1581,9 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 					return ret;
 			}
 
-			step = mapping->get(mapping, UVC_GET_RES,
-					uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
+			mapping->get(mapping, UVC_GET_RES,
+				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES),
+				     &step, sizeof(step));
 			if (!(step & value))
 				return -EINVAL;
 		}
@@ -1578,8 +1623,8 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 		       ctrl->info.size);
 	}
 
-	mapping->set(mapping, value,
-		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
+	mapping->set(mapping, uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+		     &value, sizeof(value));
 
 	ctrl->dirty = 1;
 	ctrl->modified = 1;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 4205e7a..47a42f6 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -222,10 +222,10 @@ struct uvc_control_mapping {
 	__s32 master_manual;
 	__u32 slave_ids[2];
 
-	__s32 (*get) (struct uvc_control_mapping *mapping, __u8 query,
-		      const __u8 *data);
-	void (*set) (struct uvc_control_mapping *mapping, __s32 value,
-		     __u8 *data);
+	void (*get) (struct uvc_control_mapping *mapping, __u8 query,
+		     const __u8 *data, void *value, size_t size);
+	void (*set) (struct uvc_control_mapping *mapping,
+		     __u8 *data, const void *value, size_t size);
 };
 
 struct uvc_control {
-- 
1.9.3

