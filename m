Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41404 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbeAPVHK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 16:07:10 -0500
Received: from avalon.bb.dnainternet.fi (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id AB66D204BB
        for <linux-media@vger.kernel.org>; Tue, 16 Jan 2018 22:06:16 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] uvcvideo: Use internal kernel integer types
Date: Tue, 16 Jan 2018 23:07:06 +0200
Message-Id: <20180116210707.7727-4-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20180116210707.7727-1-laurent.pinchart@ideasonboard.com>
References: <20180116210707.7727-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the __[su]{8,16,32} variant of integer types with the
non-underscored types as the code is internal to the driver, not exposed
to userspace.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c   |  56 ++++++------
 drivers/media/usb/uvc/uvc_driver.c |  36 ++++----
 drivers/media/usb/uvc/uvc_isight.c |   6 +-
 drivers/media/usb/uvc/uvc_status.c |   4 +-
 drivers/media/usb/uvc/uvc_v4l2.c   |  62 ++++++-------
 drivers/media/usb/uvc/uvc_video.c  |  40 ++++----
 drivers/media/usb/uvc/uvcvideo.h   | 182 ++++++++++++++++++-------------------
 7 files changed, 193 insertions(+), 193 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 586f0e94061b..723c517474fc 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -366,10 +366,10 @@ static struct uvc_menu_info exposure_auto_controls[] = {
 	{ 8, "Aperture Priority Mode" },
 };
 
-static __s32 uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
-	__u8 query, const __u8 *data)
+static s32 uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
+	u8 query, const u8 *data)
 {
-	__s8 zoom = (__s8)data[0];
+	s8 zoom = (s8)data[0];
 
 	switch (query) {
 	case UVC_GET_CUR:
@@ -385,17 +385,17 @@ static __s32 uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
 }
 
 static void uvc_ctrl_set_zoom(struct uvc_control_mapping *mapping,
-	__s32 value, __u8 *data)
+	s32 value, u8 *data)
 {
 	data[0] = value == 0 ? 0 : (value > 0) ? 1 : 0xff;
 	data[2] = min((int)abs(value), 0xff);
 }
 
-static __s32 uvc_ctrl_get_rel_speed(struct uvc_control_mapping *mapping,
-	__u8 query, const __u8 *data)
+static s32 uvc_ctrl_get_rel_speed(struct uvc_control_mapping *mapping,
+	u8 query, const u8 *data)
 {
 	unsigned int first = mapping->offset / 8;
-	__s8 rel = (__s8)data[first];
+	s8 rel = (s8)data[first];
 
 	switch (query) {
 	case UVC_GET_CUR:
@@ -412,7 +412,7 @@ static __s32 uvc_ctrl_get_rel_speed(struct uvc_control_mapping *mapping,
 }
 
 static void uvc_ctrl_set_rel_speed(struct uvc_control_mapping *mapping,
-	__s32 value, __u8 *data)
+	s32 value, u8 *data)
 {
 	unsigned int first = mapping->offset / 8;
 
@@ -745,17 +745,17 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
  * Utility functions
  */
 
-static inline __u8 *uvc_ctrl_data(struct uvc_control *ctrl, int id)
+static inline u8 *uvc_ctrl_data(struct uvc_control *ctrl, int id)
 {
 	return ctrl->uvc_data + id * ctrl->info.size;
 }
 
-static inline int uvc_test_bit(const __u8 *data, int bit)
+static inline int uvc_test_bit(const u8 *data, int bit)
 {
 	return (data[bit >> 3] >> (bit & 7)) & 1;
 }
 
-static inline void uvc_clear_bit(__u8 *data, int bit)
+static inline void uvc_clear_bit(u8 *data, int bit)
 {
 	data[bit >> 3] &= ~(1 << (bit & 7));
 }
@@ -765,20 +765,20 @@ static inline void uvc_clear_bit(__u8 *data, int bit)
  * a signed 32bit integer. Sign extension will be performed if the mapping
  * references a signed data type.
  */
-static __s32 uvc_get_le_value(struct uvc_control_mapping *mapping,
-	__u8 query, const __u8 *data)
+static s32 uvc_get_le_value(struct uvc_control_mapping *mapping,
+	u8 query, const u8 *data)
 {
 	int bits = mapping->size;
 	int offset = mapping->offset;
-	__s32 value = 0;
-	__u8 mask;
+	s32 value = 0;
+	u8 mask;
 
 	data += offset / 8;
 	offset &= 7;
 	mask = ((1LL << bits) - 1) << offset;
 
 	for (; bits > 0; data++) {
-		__u8 byte = *data & mask;
+		u8 byte = *data & mask;
 		value |= offset > 0 ? (byte >> offset) : (byte << (-offset));
 		bits -= 8 - (offset > 0 ? offset : 0);
 		offset -= 8;
@@ -796,11 +796,11 @@ static __s32 uvc_get_le_value(struct uvc_control_mapping *mapping,
  * in the little-endian data stored at 'data' to the value 'value'.
  */
 static void uvc_set_le_value(struct uvc_control_mapping *mapping,
-	__s32 value, __u8 *data)
+	s32 value, u8 *data)
 {
 	int bits = mapping->size;
 	int offset = mapping->offset;
-	__u8 mask;
+	u8 mask;
 
 	/* According to the v4l2 spec, writing any value to a button control
 	 * should result in the action belonging to the button control being
@@ -826,13 +826,13 @@ static void uvc_set_le_value(struct uvc_control_mapping *mapping,
  * Terminal and unit management
  */
 
-static const __u8 uvc_processing_guid[16] = UVC_GUID_UVC_PROCESSING;
-static const __u8 uvc_camera_guid[16] = UVC_GUID_UVC_CAMERA;
-static const __u8 uvc_media_transport_input_guid[16] =
+static const u8 uvc_processing_guid[16] = UVC_GUID_UVC_PROCESSING;
+static const u8 uvc_camera_guid[16] = UVC_GUID_UVC_CAMERA;
+static const u8 uvc_media_transport_input_guid[16] =
 	UVC_GUID_UVC_MEDIA_TRANSPORT_INPUT;
 
 static int uvc_entity_match_guid(const struct uvc_entity *entity,
-	const __u8 guid[16])
+	const u8 guid[16])
 {
 	switch (UVC_ENTITY_TYPE(entity)) {
 	case UVC_ITT_CAMERA:
@@ -857,7 +857,7 @@ static int uvc_entity_match_guid(const struct uvc_entity *entity,
  * UVC Controls
  */
 
-static void __uvc_find_control(struct uvc_entity *entity, __u32 v4l2_id,
+static void __uvc_find_control(struct uvc_entity *entity, u32 v4l2_id,
 	struct uvc_control_mapping **mapping, struct uvc_control **control,
 	int next)
 {
@@ -890,7 +890,7 @@ static void __uvc_find_control(struct uvc_entity *entity, __u32 v4l2_id,
 }
 
 static struct uvc_control *uvc_find_control(struct uvc_video_chain *chain,
-	__u32 v4l2_id, struct uvc_control_mapping **mapping)
+	u32 v4l2_id, struct uvc_control_mapping **mapping)
 {
 	struct uvc_control *ctrl = NULL;
 	struct uvc_entity *entity;
@@ -1742,9 +1742,9 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 	struct uvc_entity *entity;
 	struct uvc_control *ctrl;
 	unsigned int i, found = 0;
-	__u32 reqflags;
-	__u16 size;
-	__u8 *data = NULL;
+	u32 reqflags;
+	u16 size;
+	u8 *data = NULL;
 	int ret;
 
 	/* Find the extension unit. */
@@ -2176,7 +2176,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 	list_for_each_entry(entity, &dev->entities, list) {
 		struct uvc_control *ctrl;
 		unsigned int bControlSize = 0, ncontrols;
-		__u8 *bmControls = NULL;
+		u8 *bmControls = NULL;
 
 		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
 			bmControls = entity->extension.bmControls;
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 56d906dd7044..718c3fcde287 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -216,7 +216,7 @@ static struct uvc_format_desc uvc_fmts[] = {
  */
 
 struct usb_host_endpoint *uvc_find_endpoint(struct usb_host_interface *alts,
-		__u8 epaddr)
+		u8 epaddr)
 {
 	struct usb_host_endpoint *ep;
 	unsigned int i;
@@ -230,7 +230,7 @@ struct usb_host_endpoint *uvc_find_endpoint(struct usb_host_interface *alts,
 	return NULL;
 }
 
-static struct uvc_format_desc *uvc_format_by_guid(const __u8 guid[16])
+static struct uvc_format_desc *uvc_format_by_guid(const u8 guid[16])
 {
 	unsigned int len = ARRAY_SIZE(uvc_fmts);
 	unsigned int i;
@@ -243,9 +243,9 @@ static struct uvc_format_desc *uvc_format_by_guid(const __u8 guid[16])
 	return NULL;
 }
 
-static __u32 uvc_colorspace(const __u8 primaries)
+static u32 uvc_colorspace(const u8 primaries)
 {
-	static const __u8 colorprimaries[] = {
+	static const u8 colorprimaries[] = {
 		0,
 		V4L2_COLORSPACE_SRGB,
 		V4L2_COLORSPACE_470_SYSTEM_M,
@@ -391,7 +391,7 @@ static struct uvc_streaming *uvc_stream_by_id(struct uvc_device *dev, int id)
 
 static int uvc_parse_format(struct uvc_device *dev,
 	struct uvc_streaming *streaming, struct uvc_format *format,
-	__u32 **intervals, unsigned char *buffer, int buflen)
+	u32 **intervals, unsigned char *buffer, int buflen)
 {
 	struct usb_interface *intf = streaming->intf;
 	struct usb_host_interface *alts = intf->cur_altsetting;
@@ -401,7 +401,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 	unsigned int width_multiplier = 1;
 	unsigned int interval;
 	unsigned int i, n;
-	__u8 ftype;
+	u8 ftype;
 
 	format->type = buffer[2];
 	format->index = buffer[3];
@@ -658,8 +658,8 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	int _buflen, buflen = alts->extralen;
 	unsigned int nformats = 0, nframes = 0, nintervals = 0;
 	unsigned int size, i, n, p;
-	__u32 *interval;
-	__u16 psize;
+	u32 *interval;
+	u16 psize;
 	int ret = -EINVAL;
 
 	if (intf->cur_altsetting->desc.bInterfaceSubClass
@@ -836,7 +836,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	}
 
 	frame = (struct uvc_frame *)&format[nformats];
-	interval = (__u32 *)&frame[nframes];
+	interval = (u32 *)&frame[nframes];
 
 	streaming->format = format;
 	streaming->nformats = nformats;
@@ -930,7 +930,7 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 		entity->pads[num_pads-1].flags = MEDIA_PAD_FL_SOURCE;
 
 	entity->bNrInPins = num_inputs;
-	entity->baSourceID = (__u8 *)(&entity->pads[num_pads]);
+	entity->baSourceID = (u8 *)(&entity->pads[num_pads]);
 
 	return entity;
 }
@@ -995,8 +995,8 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 		unit->extension.bNumControls = buffer[20];
 		memcpy(unit->baSourceID, &buffer[22], p);
 		unit->extension.bControlSize = buffer[22+p];
-		unit->extension.bmControls = (__u8 *)unit + sizeof(*unit);
-		unit->extension.bmControlsType = (__u8 *)unit + sizeof(*unit)
+		unit->extension.bmControls = (u8 *)unit + sizeof(*unit);
+		unit->extension.bmControlsType = (u8 *)unit + sizeof(*unit)
 					       + n;
 		memcpy(unit->extension.bmControls, &buffer[23+p], 2*n);
 
@@ -1022,7 +1022,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 	struct usb_interface *intf;
 	struct usb_host_interface *alts = dev->intf->cur_altsetting;
 	unsigned int i, n, p, len;
-	__u16 type;
+	u16 type;
 
 	switch (buffer[2]) {
 	case UVC_VC_HEADER:
@@ -1101,7 +1101,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA) {
 			term->camera.bControlSize = n;
-			term->camera.bmControls = (__u8 *)term + sizeof *term;
+			term->camera.bmControls = (u8 *)term + sizeof *term;
 			term->camera.wObjectiveFocalLengthMin =
 				get_unaligned_le16(&buffer[8]);
 			term->camera.wObjectiveFocalLengthMax =
@@ -1112,9 +1112,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		} else if (UVC_ENTITY_TYPE(term) ==
 			   UVC_ITT_MEDIA_TRANSPORT_INPUT) {
 			term->media.bControlSize = n;
-			term->media.bmControls = (__u8 *)term + sizeof *term;
+			term->media.bmControls = (u8 *)term + sizeof *term;
 			term->media.bTransportModeSize = p;
-			term->media.bmTransportModes = (__u8 *)term
+			term->media.bmTransportModes = (u8 *)term
 						     + sizeof *term + n;
 			memcpy(term->media.bmControls, &buffer[9], n);
 			memcpy(term->media.bmTransportModes, &buffer[10+n], p);
@@ -1213,7 +1213,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		unit->processing.wMaxMultiplier =
 			get_unaligned_le16(&buffer[5]);
 		unit->processing.bControlSize = buffer[7];
-		unit->processing.bmControls = (__u8 *)unit + sizeof *unit;
+		unit->processing.bmControls = (u8 *)unit + sizeof *unit;
 		memcpy(unit->processing.bmControls, &buffer[8], n);
 		if (dev->uvc_version >= 0x0110)
 			unit->processing.bmVideoStandards = buffer[9+n];
@@ -1246,7 +1246,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		unit->extension.bNumControls = buffer[20];
 		memcpy(unit->baSourceID, &buffer[22], p);
 		unit->extension.bControlSize = buffer[22+p];
-		unit->extension.bmControls = (__u8 *)unit + sizeof *unit;
+		unit->extension.bmControls = (u8 *)unit + sizeof *unit;
 		memcpy(unit->extension.bmControls, &buffer[23+p], n);
 
 		if (buffer[23+p+n] != 0)
diff --git a/drivers/media/usb/uvc/uvc_isight.c b/drivers/media/usb/uvc/uvc_isight.c
index 5059fbf41020..81e6f2187bfb 100644
--- a/drivers/media/usb/uvc/uvc_isight.c
+++ b/drivers/media/usb/uvc/uvc_isight.c
@@ -37,16 +37,16 @@
  */
 
 static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
-		const __u8 *data, unsigned int len)
+		const u8 *data, unsigned int len)
 {
-	static const __u8 hdr[] = {
+	static const u8 hdr[] = {
 		0x11, 0x22, 0x33, 0x44,
 		0xde, 0xad, 0xbe, 0xef,
 		0xde, 0xad, 0xfa, 0xce
 	};
 
 	unsigned int maxlen, nbytes;
-	__u8 *mem;
+	u8 *mem;
 	int is_header = 0;
 
 	if (buf == NULL)
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 1ef20e74b7ac..7b710410584a 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -78,7 +78,7 @@ static void uvc_input_report_key(struct uvc_device *dev, unsigned int code,
 /* --------------------------------------------------------------------------
  * Status interrupt endpoint
  */
-static void uvc_event_streaming(struct uvc_device *dev, __u8 *data, int len)
+static void uvc_event_streaming(struct uvc_device *dev, u8 *data, int len)
 {
 	if (len < 3) {
 		uvc_trace(UVC_TRACE_STATUS, "Invalid streaming status event "
@@ -99,7 +99,7 @@ static void uvc_event_streaming(struct uvc_device *dev, __u8 *data, int len)
 	}
 }
 
-static void uvc_event_control(struct uvc_device *dev, __u8 *data, int len)
+static void uvc_event_control(struct uvc_device *dev, u8 *data, int len)
 {
 	char *attrs[3] = { "value", "info", "failure" };
 
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 784796f9f2e1..c70091db9c0c 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -105,12 +105,12 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
  * the Video Probe and Commit negotiation, but some hardware don't implement
  * that feature.
  */
-static __u32 uvc_try_frame_interval(struct uvc_frame *frame, __u32 interval)
+static u32 uvc_try_frame_interval(struct uvc_frame *frame, u32 interval)
 {
 	unsigned int i;
 
 	if (frame->bFrameIntervalType) {
-		__u32 best = -1, dist;
+		u32 best = -1, dist;
 
 		for (i = 0; i < frame->bFrameIntervalType; ++i) {
 			dist = interval > frame->dwFrameInterval[i]
@@ -125,9 +125,9 @@ static __u32 uvc_try_frame_interval(struct uvc_frame *frame, __u32 interval)
 
 		interval = frame->dwFrameInterval[i-1];
 	} else {
-		const __u32 min = frame->dwFrameInterval[0];
-		const __u32 max = frame->dwFrameInterval[1];
-		const __u32 step = frame->dwFrameInterval[2];
+		const u32 min = frame->dwFrameInterval[0];
+		const u32 max = frame->dwFrameInterval[1];
+		const u32 step = frame->dwFrameInterval[2];
 
 		interval = min + (interval - min + step/2) / step * step;
 		if (interval > max)
@@ -137,7 +137,7 @@ static __u32 uvc_try_frame_interval(struct uvc_frame *frame, __u32 interval)
 	return interval;
 }
 
-static __u32 uvc_v4l2_get_bytesperline(const struct uvc_format *format,
+static u32 uvc_v4l2_get_bytesperline(const struct uvc_format *format,
 	const struct uvc_frame *frame)
 {
 	switch (format->fcc) {
@@ -158,17 +158,17 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 {
 	struct uvc_format *format = NULL;
 	struct uvc_frame *frame = NULL;
-	__u16 rw, rh;
+	u16 rw, rh;
 	unsigned int d, maxd;
 	unsigned int i;
-	__u32 interval;
+	u32 interval;
 	int ret = 0;
-	__u8 *fcc;
+	u8 *fcc;
 
 	if (fmt->type != stream->type)
 		return -EINVAL;
 
-	fcc = (__u8 *)&fmt->fmt.pix.pixelformat;
+	fcc = (u8 *)&fmt->fmt.pix.pixelformat;
 	uvc_trace(UVC_TRACE_FORMAT, "Trying format 0x%08x (%c%c%c%c): %ux%u.\n",
 			fmt->fmt.pix.pixelformat,
 			fcc[0], fcc[1], fcc[2], fcc[3],
@@ -197,8 +197,8 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 	maxd = (unsigned int)-1;
 
 	for (i = 0; i < format->nframes; ++i) {
-		__u16 w = format->frame[i].wWidth;
-		__u16 h = format->frame[i].wHeight;
+		u16 w = format->frame[i].wWidth;
+		u16 h = format->frame[i].wHeight;
 
 		d = min(w, rw) * min(h, rh);
 		d = w*h + rw*rh - 2*d;
@@ -375,7 +375,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 	struct v4l2_fract timeperframe;
 	struct uvc_format *format;
 	struct uvc_frame *frame;
-	__u32 interval, maxd;
+	u32 interval, maxd;
 	unsigned int i;
 	int ret;
 
@@ -403,11 +403,11 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 	frame = stream->cur_frame;
 	probe = stream->ctrl;
 	probe.dwFrameInterval = uvc_try_frame_interval(frame, interval);
-	maxd = abs((__s32)probe.dwFrameInterval - interval);
+	maxd = abs((s32)probe.dwFrameInterval - interval);
 
 	/* Try frames with matching size to find the best frame interval. */
 	for (i = 0; i < format->nframes && maxd != 0; i++) {
-		__u32 d, ival;
+		u32 d, ival;
 
 		if (&format->frame[i] == stream->cur_frame)
 			continue;
@@ -417,7 +417,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 			continue;
 
 		ival = uvc_try_frame_interval(&format->frame[i], interval);
-		d = abs((__s32)ival - interval);
+		d = abs((s32)ival - interval);
 		if (d >= maxd)
 			continue;
 
@@ -605,7 +605,7 @@ static int uvc_ioctl_enum_fmt(struct uvc_streaming *stream,
 {
 	struct uvc_format *format;
 	enum v4l2_buf_type type = fmt->type;
-	__u32 index = fmt->index;
+	u32 index = fmt->index;
 
 	if (fmt->type != stream->type || fmt->index >= stream->nformats)
 		return -EINVAL;
@@ -1300,20 +1300,20 @@ static long uvc_ioctl_default(struct file *file, void *fh, bool valid_prio,
 
 #ifdef CONFIG_COMPAT
 struct uvc_xu_control_mapping32 {
-	__u32 id;
-	__u8 name[32];
-	__u8 entity[16];
-	__u8 selector;
+	u32 id;
+	u8 name[32];
+	u8 entity[16];
+	u8 selector;
 
-	__u8 size;
-	__u8 offset;
-	__u32 v4l2_type;
-	__u32 data_type;
+	u8 size;
+	u8 offset;
+	u32 v4l2_type;
+	u32 data_type;
 
 	compat_caddr_t menu_info;
-	__u32 menu_count;
+	u32 menu_count;
 
-	__u32 reserved[4];
+	u32 reserved[4];
 };
 
 static int uvc_v4l2_get_xu_mapping(struct uvc_xu_control_mapping *kp,
@@ -1355,10 +1355,10 @@ static int uvc_v4l2_put_xu_mapping(const struct uvc_xu_control_mapping *kp,
 }
 
 struct uvc_xu_control_query32 {
-	__u8 unit;
-	__u8 selector;
-	__u8 query;
-	__u16 size;
+	u8 unit;
+	u8 selector;
+	u8 query;
+	u16 size;
 	compat_caddr_t data;
 };
 
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 5441553f74e1..dfe13c55a067 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -30,11 +30,11 @@
  * UVC Controls
  */
 
-static int __uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
-			__u8 intfnum, __u8 cs, void *data, __u16 size,
+static int __uvc_query_ctrl(struct uvc_device *dev, u8 query, u8 unit,
+			u8 intfnum, u8 cs, void *data, u16 size,
 			int timeout)
 {
-	__u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE;
+	u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE;
 	unsigned int pipe;
 
 	pipe = (query & 0x80) ? usb_rcvctrlpipe(dev->udev, 0)
@@ -45,7 +45,7 @@ static int __uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 			unit << 8 | intfnum, data, size, timeout);
 }
 
-static const char *uvc_query_name(__u8 query)
+static const char *uvc_query_name(u8 query)
 {
 	switch (query) {
 	case UVC_SET_CUR:
@@ -69,8 +69,8 @@ static const char *uvc_query_name(__u8 query)
 	}
 }
 
-int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
-			__u8 intfnum, __u8 cs, void *data, __u16 size)
+int uvc_query_ctrl(struct uvc_device *dev, u8 query, u8 unit,
+			u8 intfnum, u8 cs, void *data, u16 size)
 {
 	int ret;
 
@@ -164,10 +164,10 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 }
 
 static int uvc_get_video_ctrl(struct uvc_streaming *stream,
-	struct uvc_streaming_control *ctrl, int probe, __u8 query)
+	struct uvc_streaming_control *ctrl, int probe, u8 query)
 {
-	__u8 *data;
-	__u16 size;
+	u8 *data;
+	u16 size;
 	int ret;
 
 	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
@@ -254,8 +254,8 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl, int probe)
 {
-	__u8 *data;
-	__u16 size;
+	u8 *data;
+	u16 size;
 	int ret;
 
 	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
@@ -301,7 +301,7 @@ int uvc_probe_video(struct uvc_streaming *stream,
 	struct uvc_streaming_control *probe)
 {
 	struct uvc_streaming_control probe_min, probe_max;
-	__u16 bandwidth;
+	u16 bandwidth;
 	unsigned int i;
 	int ret;
 
@@ -379,7 +379,7 @@ static inline ktime_t uvc_video_get_time(void)
 
 static void
 uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
-		       const __u8 *data, int len)
+		       const u8 *data, int len)
 {
 	struct uvc_clock_sample *sample;
 	unsigned int header_size;
@@ -705,7 +705,7 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
  */
 
 static void uvc_video_stats_decode(struct uvc_streaming *stream,
-		const __u8 *data, int len)
+		const u8 *data, int len)
 {
 	unsigned int header_size;
 	bool has_pts = false;
@@ -946,9 +946,9 @@ static void uvc_video_stats_stop(struct uvc_streaming *stream)
  * uvc_video_decode_end will never be called with a NULL buffer.
  */
 static int uvc_video_decode_start(struct uvc_streaming *stream,
-		struct uvc_buffer *buf, const __u8 *data, int len)
+		struct uvc_buffer *buf, const u8 *data, int len)
 {
-	__u8 fid;
+	u8 fid;
 
 	/* Sanity checks:
 	 * - packet must be at least 2 bytes long
@@ -1043,7 +1043,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 }
 
 static void uvc_video_decode_data(struct uvc_streaming *stream,
-		struct uvc_buffer *buf, const __u8 *data, int len)
+		struct uvc_buffer *buf, const u8 *data, int len)
 {
 	unsigned int maxlen, nbytes;
 	void *mem;
@@ -1067,7 +1067,7 @@ static void uvc_video_decode_data(struct uvc_streaming *stream,
 }
 
 static void uvc_video_decode_end(struct uvc_streaming *stream,
-		struct uvc_buffer *buf, const __u8 *data, int len)
+		struct uvc_buffer *buf, const u8 *data, int len)
 {
 	/* Mark the buffer as done if the EOF marker is set. */
 	if (data[1] & UVC_STREAM_EOF && buf->bytesused != 0) {
@@ -1092,7 +1092,7 @@ static void uvc_video_decode_end(struct uvc_streaming *stream,
  * video buffer to the transfer buffer.
  */
 static int uvc_video_encode_header(struct uvc_streaming *stream,
-		struct uvc_buffer *buf, __u8 *data, int len)
+		struct uvc_buffer *buf, u8 *data, int len)
 {
 	data[0] = 2;	/* Header length */
 	data[1] = UVC_STREAM_EOH | UVC_STREAM_EOF
@@ -1101,7 +1101,7 @@ static int uvc_video_encode_header(struct uvc_streaming *stream,
 }
 
 static int uvc_video_encode_data(struct uvc_streaming *stream,
-		struct uvc_buffer *buf, __u8 *data, int len)
+		struct uvc_buffer *buf, u8 *data, int len)
 {
 	struct uvc_video_queue *queue = &stream->queue;
 	unsigned int nbytes;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 394c6dcdc85b..6b16892a1874 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -208,60 +208,60 @@ struct uvc_device;
 struct uvc_control_info {
 	struct list_head mappings;
 
-	__u8 entity[16];
-	__u8 index;	/* Bit index in bmControls */
-	__u8 selector;
+	u8 entity[16];
+	u8 index;	/* Bit index in bmControls */
+	u8 selector;
 
-	__u16 size;
-	__u32 flags;
+	u16 size;
+	u32 flags;
 };
 
 struct uvc_control_mapping {
 	struct list_head list;
 	struct list_head ev_subs;
 
-	__u32 id;
-	__u8 name[32];
-	__u8 entity[16];
-	__u8 selector;
+	u32 id;
+	u8 name[32];
+	u8 entity[16];
+	u8 selector;
 
-	__u8 size;
-	__u8 offset;
+	u8 size;
+	u8 offset;
 	enum v4l2_ctrl_type v4l2_type;
-	__u32 data_type;
+	u32 data_type;
 
 	struct uvc_menu_info *menu_info;
-	__u32 menu_count;
+	u32 menu_count;
 
-	__u32 master_id;
-	__s32 master_manual;
-	__u32 slave_ids[2];
+	u32 master_id;
+	s32 master_manual;
+	u32 slave_ids[2];
 
-	__s32 (*get) (struct uvc_control_mapping *mapping, __u8 query,
-		      const __u8 *data);
-	void (*set) (struct uvc_control_mapping *mapping, __s32 value,
-		     __u8 *data);
+	s32 (*get)(struct uvc_control_mapping *mapping, u8 query,
+		   const u8 *data);
+	void (*set)(struct uvc_control_mapping *mapping, s32 value,
+		    u8 *data);
 };
 
 struct uvc_control {
 	struct uvc_entity *entity;
 	struct uvc_control_info info;
 
-	__u8 index;	/* Used to match the uvc_control entry with a
+	u8 index;	/* Used to match the uvc_control entry with a
 			   uvc_control_info. */
-	__u8 dirty:1,
-	     loaded:1,
-	     modified:1,
-	     cached:1,
-	     initialized:1;
+	u8 dirty:1,
+	   loaded:1,
+	   modified:1,
+	   cached:1,
+	   initialized:1;
 
-	__u8 *uvc_data;
+	u8 *uvc_data;
 };
 
 struct uvc_format_desc {
 	char *name;
-	__u8 guid[16];
-	__u32 fcc;
+	u8 guid[16];
+	u32 fcc;
 };
 
 /* The term 'entity' refers to both UVC units and UVC terminals.
@@ -287,8 +287,8 @@ struct uvc_entity {
 					 * chain. */
 	unsigned int flags;
 
-	__u8 id;
-	__u16 type;
+	u8 id;
+	u16 type;
 	char name[64];
 
 	/* Media controller-related fields. */
@@ -300,69 +300,69 @@ struct uvc_entity {
 
 	union {
 		struct {
-			__u16 wObjectiveFocalLengthMin;
-			__u16 wObjectiveFocalLengthMax;
-			__u16 wOcularFocalLength;
-			__u8  bControlSize;
-			__u8  *bmControls;
+			u16 wObjectiveFocalLengthMin;
+			u16 wObjectiveFocalLengthMax;
+			u16 wOcularFocalLength;
+			u8  bControlSize;
+			u8  *bmControls;
 		} camera;
 
 		struct {
-			__u8  bControlSize;
-			__u8  *bmControls;
-			__u8  bTransportModeSize;
-			__u8  *bmTransportModes;
+			u8  bControlSize;
+			u8  *bmControls;
+			u8  bTransportModeSize;
+			u8  *bmTransportModes;
 		} media;
 
 		struct {
 		} output;
 
 		struct {
-			__u16 wMaxMultiplier;
-			__u8  bControlSize;
-			__u8  *bmControls;
-			__u8  bmVideoStandards;
+			u16 wMaxMultiplier;
+			u8  bControlSize;
+			u8  *bmControls;
+			u8  bmVideoStandards;
 		} processing;
 
 		struct {
 		} selector;
 
 		struct {
-			__u8  guidExtensionCode[16];
-			__u8  bNumControls;
-			__u8  bControlSize;
-			__u8  *bmControls;
-			__u8  *bmControlsType;
+			u8  guidExtensionCode[16];
+			u8  bNumControls;
+			u8  bControlSize;
+			u8  *bmControls;
+			u8  *bmControlsType;
 		} extension;
 	};
 
-	__u8 bNrInPins;
-	__u8 *baSourceID;
+	u8 bNrInPins;
+	u8 *baSourceID;
 
 	unsigned int ncontrols;
 	struct uvc_control *controls;
 };
 
 struct uvc_frame {
-	__u8  bFrameIndex;
-	__u8  bmCapabilities;
-	__u16 wWidth;
-	__u16 wHeight;
-	__u32 dwMinBitRate;
-	__u32 dwMaxBitRate;
-	__u32 dwMaxVideoFrameBufferSize;
-	__u8  bFrameIntervalType;
-	__u32 dwDefaultFrameInterval;
-	__u32 *dwFrameInterval;
+	u8  bFrameIndex;
+	u8  bmCapabilities;
+	u16 wWidth;
+	u16 wHeight;
+	u32 dwMinBitRate;
+	u32 dwMaxBitRate;
+	u32 dwMaxVideoFrameBufferSize;
+	u8  bFrameIntervalType;
+	u32 dwDefaultFrameInterval;
+	u32 *dwFrameInterval;
 };
 
 struct uvc_format {
-	__u8 type;
-	__u8 index;
-	__u8 bpp;
-	__u8 colorspace;
-	__u32 fcc;
-	__u32 flags;
+	u8 type;
+	u8 index;
+	u8 bpp;
+	u8 colorspace;
+	u32 fcc;
+	u32 flags;
 
 	char name[32];
 
@@ -371,16 +371,16 @@ struct uvc_format {
 };
 
 struct uvc_streaming_header {
-	__u8 bNumFormats;
-	__u8 bEndpointAddress;
-	__u8 bTerminalLink;
-	__u8 bControlSize;
-	__u8 *bmaControls;
+	u8 bNumFormats;
+	u8 bEndpointAddress;
+	u8 bTerminalLink;
+	u8 bControlSize;
+	u8 *bmaControls;
 	/* The following fields are used by input headers only. */
-	__u8 bmInfo;
-	__u8 bStillCaptureMethod;
-	__u8 bTriggerSupport;
-	__u8 bTriggerUsage;
+	u8 bmInfo;
+	u8 bStillCaptureMethod;
+	u8 bTriggerSupport;
+	u8 bTriggerUsage;
 };
 
 enum uvc_buffer_state {
@@ -490,7 +490,7 @@ struct uvc_streaming {
 
 	struct usb_interface *intf;
 	int intfnum;
-	__u16 maxpsize;
+	u16 maxpsize;
 
 	struct uvc_streaming_header header;
 	enum v4l2_buf_type type;
@@ -517,16 +517,16 @@ struct uvc_streaming {
 	struct {
 		struct video_device vdev;
 		struct uvc_video_queue queue;
-		__u32 format;
+		u32 format;
 	} meta;
 
 	/* Context data used by the bulk completion handler. */
 	struct {
-		__u8 header[256];
+		u8 header[256];
 		unsigned int header_size;
 		int skip_payload;
-		__u32 payload_size;
-		__u32 max_payload_size;
+		u32 payload_size;
+		u32 max_payload_size;
 	} bulk;
 
 	struct urb *urb[UVC_URBS];
@@ -534,8 +534,8 @@ struct uvc_streaming {
 	dma_addr_t urb_dma[UVC_URBS];
 	unsigned int urb_size;
 
-	__u32 sequence;
-	__u8 last_fid;
+	u32 sequence;
+	u8 last_fid;
 
 	/* debugfs */
 	struct dentry *debugfs_dir;
@@ -570,8 +570,8 @@ struct uvc_device {
 	struct usb_device *udev;
 	struct usb_interface *intf;
 	unsigned long warnings;
-	__u32 quirks;
-	__u32 meta_format;
+	u32 quirks;
+	u32 meta_format;
 	int intfnum;
 	char name[32];
 
@@ -584,8 +584,8 @@ struct uvc_device {
 	struct media_device mdev;
 #endif
 	struct v4l2_device vdev;
-	__u16 uvc_version;
-	__u32 clock_frequency;
+	u16 uvc_version;
+	u32 clock_frequency;
 
 	struct list_head entities;
 	struct list_head chains;
@@ -597,7 +597,7 @@ struct uvc_device {
 	/* Status Interrupt Endpoint */
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
-	__u8 *status;
+	u8 *status;
 	struct input_dev *input;
 	char input_phys[64];
 };
@@ -720,8 +720,8 @@ int uvc_video_resume(struct uvc_streaming *stream, int reset);
 int uvc_video_enable(struct uvc_streaming *stream, int enable);
 int uvc_probe_video(struct uvc_streaming *stream,
 		    struct uvc_streaming_control *probe);
-int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
-		   __u8 intfnum, __u8 cs, void *data, __u16 size);
+int uvc_query_ctrl(struct uvc_device *dev, u8 query, u8 unit,
+		   u8 intfnum, u8 cs, void *data, u16 size);
 void uvc_video_clock_update(struct uvc_streaming *stream,
 			    struct vb2_v4l2_buffer *vbuf,
 			    struct uvc_buffer *buf);
@@ -781,7 +781,7 @@ void uvc_simplify_fraction(u32 *numerator, u32 *denominator,
 			   unsigned int n_terms, unsigned int threshold);
 u32 uvc_fraction_to_interval(u32 numerator, u32 denominator);
 struct usb_host_endpoint *uvc_find_endpoint(struct usb_host_interface *alts,
-					    __u8 epaddr);
+					    u8 epaddr);
 
 /* Quirks support */
 void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
-- 
Regards,

Laurent Pinchart
