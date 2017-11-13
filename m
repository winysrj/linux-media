Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:9278 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753801AbdKMRFe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 12:05:34 -0500
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 10/10] video/hdmi: Pass buffer size to infoframe unpack functions
Date: Mon, 13 Nov 2017 19:04:27 +0200
Message-Id: <20171113170427.4150-11-ville.syrjala@linux.intel.com>
In-Reply-To: <20171113170427.4150-1-ville.syrjala@linux.intel.com>
References: <20171113170427.4150-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

To make sure the infoframe unpack functions don't end up examining
stack garbage or oopsing, let's pass in the size of the buffer.

Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/media/i2c/adv7511.c  |  2 +-
 drivers/media/i2c/adv7604.c  |  2 +-
 drivers/media/i2c/adv7842.c  |  2 +-
 drivers/media/i2c/tc358743.c |  2 +-
 drivers/video/hdmi.c         | 51 ++++++++++++++++++++++++++++++++------------
 include/linux/hdmi.h         |  2 +-
 6 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 2817bafc67bf..dec09c18ea34 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -562,7 +562,7 @@ static void log_infoframe(struct v4l2_subdev *sd, const struct adv7511_cfg_read_
 	buffer[3] = 0;
 	buffer[3] = hdmi_infoframe_checksum(buffer, len + 4);
 
-	if (hdmi_infoframe_unpack(&frame, buffer) < 0) {
+	if (hdmi_infoframe_unpack(&frame, buffer, sizeof(buffer)) < 0) {
 		v4l2_err(sd, "%s: unpack of %s infoframe failed\n", __func__, cri->desc);
 		return;
 	}
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index f289b8aca1da..8500438af0d3 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2429,7 +2429,7 @@ static int adv76xx_read_infoframe(struct v4l2_subdev *sd, int index,
 		buffer[i + 3] = infoframe_read(sd,
 				       adv76xx_cri[index].payload_addr + i);
 
-	if (hdmi_infoframe_unpack(frame, buffer) < 0) {
+	if (hdmi_infoframe_unpack(frame, buffer, sizeof(buffer)) < 0) {
 		v4l2_err(sd, "%s: unpack of %s infoframe failed\n", __func__,
 			 adv76xx_cri[index].desc);
 		return -ENOENT;
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 65f34e7e146f..fd5d5e84dcbf 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2576,7 +2576,7 @@ static void log_infoframe(struct v4l2_subdev *sd, struct adv7842_cfg_read_infofr
 	for (i = 0; i < len; i++)
 		buffer[i + 3] = infoframe_read(sd, cri->payload_addr + i);
 
-	if (hdmi_infoframe_unpack(&frame, buffer) < 0) {
+	if (hdmi_infoframe_unpack(&frame, buffer, sizeof(buffer)) < 0) {
 		v4l2_err(sd, "%s: unpack of %s infoframe failed\n", __func__, cri->desc);
 		return;
 	}
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index e6f5c363ccab..f6a5ebffd9c6 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -453,7 +453,7 @@ static void print_avi_infoframe(struct v4l2_subdev *sd)
 
 	i2c_rd(sd, PK_AVI_0HEAD, buffer, HDMI_INFOFRAME_SIZE(AVI));
 
-	if (hdmi_infoframe_unpack(&frame, buffer) < 0) {
+	if (hdmi_infoframe_unpack(&frame, buffer, sizeof(buffer)) < 0) {
 		v4l2_err(sd, "%s: unpack of AVI infoframe failed\n", __func__);
 		return;
 	}
diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index 65b915ea4936..b5d491014b0b 100644
--- a/drivers/video/hdmi.c
+++ b/drivers/video/hdmi.c
@@ -1005,8 +1005,9 @@ EXPORT_SYMBOL(hdmi_infoframe_log);
 
 /**
  * hdmi_avi_infoframe_unpack() - unpack binary buffer to a HDMI AVI infoframe
- * @buffer: source buffer
  * @frame: HDMI AVI infoframe
+ * @buffer: source buffer
+ * @size: size of buffer
  *
  * Unpacks the information contained in binary @buffer into a structured
  * @frame of the HDMI Auxiliary Video (AVI) information frame.
@@ -1016,11 +1017,14 @@ EXPORT_SYMBOL(hdmi_infoframe_log);
  * Returns 0 on success or a negative error code on failure.
  */
 static int hdmi_avi_infoframe_unpack(struct hdmi_avi_infoframe *frame,
-				     const void *buffer)
+				     const void *buffer, size_t size)
 {
 	const u8 *ptr = buffer;
 	int ret;
 
+	if (size < HDMI_INFOFRAME_SIZE(AVI))
+		return -EINVAL;
+
 	if (ptr[0] != HDMI_INFOFRAME_TYPE_AVI ||
 	    ptr[1] != 2 ||
 	    ptr[2] != HDMI_AVI_INFOFRAME_SIZE)
@@ -1068,8 +1072,9 @@ static int hdmi_avi_infoframe_unpack(struct hdmi_avi_infoframe *frame,
 
 /**
  * hdmi_spd_infoframe_unpack() - unpack binary buffer to a HDMI SPD infoframe
- * @buffer: source buffer
  * @frame: HDMI SPD infoframe
+ * @buffer: source buffer
+ * @size: size of buffer
  *
  * Unpacks the information contained in binary @buffer into a structured
  * @frame of the HDMI Source Product Description (SPD) information frame.
@@ -1079,11 +1084,14 @@ static int hdmi_avi_infoframe_unpack(struct hdmi_avi_infoframe *frame,
  * Returns 0 on success or a negative error code on failure.
  */
 static int hdmi_spd_infoframe_unpack(struct hdmi_spd_infoframe *frame,
-				     const void *buffer)
+				     const void *buffer, size_t size)
 {
 	const u8 *ptr = buffer;
 	int ret;
 
+	if (size < HDMI_INFOFRAME_SIZE(SPD))
+		return -EINVAL;
+
 	if (ptr[0] != HDMI_INFOFRAME_TYPE_SPD ||
 	    ptr[1] != 1 ||
 	    ptr[2] != HDMI_SPD_INFOFRAME_SIZE) {
@@ -1106,8 +1114,9 @@ static int hdmi_spd_infoframe_unpack(struct hdmi_spd_infoframe *frame,
 
 /**
  * hdmi_audio_infoframe_unpack() - unpack binary buffer to a HDMI AUDIO infoframe
- * @buffer: source buffer
  * @frame: HDMI Audio infoframe
+ * @buffer: source buffer
+ * @size: size of buffer
  *
  * Unpacks the information contained in binary @buffer into a structured
  * @frame of the HDMI Audio information frame.
@@ -1117,11 +1126,14 @@ static int hdmi_spd_infoframe_unpack(struct hdmi_spd_infoframe *frame,
  * Returns 0 on success or a negative error code on failure.
  */
 static int hdmi_audio_infoframe_unpack(struct hdmi_audio_infoframe *frame,
-				       const void *buffer)
+				       const void *buffer, size_t size)
 {
 	const u8 *ptr = buffer;
 	int ret;
 
+	if (size < HDMI_INFOFRAME_SIZE(AUDIO))
+		return -EINVAL;
+
 	if (ptr[0] != HDMI_INFOFRAME_TYPE_AUDIO ||
 	    ptr[1] != 1 ||
 	    ptr[2] != HDMI_AUDIO_INFOFRAME_SIZE) {
@@ -1151,8 +1163,9 @@ static int hdmi_audio_infoframe_unpack(struct hdmi_audio_infoframe *frame,
 
 /**
  * hdmi_vendor_infoframe_unpack() - unpack binary buffer to a HDMI vendor infoframe
- * @buffer: source buffer
  * @frame: HDMI Vendor infoframe
+ * @buffer: source buffer
+ * @size: size of buffer
  *
  * Unpacks the information contained in binary @buffer into a structured
  * @frame of the HDMI Vendor information frame.
@@ -1163,7 +1176,7 @@ static int hdmi_audio_infoframe_unpack(struct hdmi_audio_infoframe *frame,
  */
 static int
 hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
-				 const void *buffer)
+				 const void *buffer, size_t size)
 {
 	const u8 *ptr = buffer;
 	size_t length;
@@ -1171,6 +1184,9 @@ hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
 	u8 hdmi_video_format;
 	struct hdmi_vendor_infoframe *hvf = &frame->hdmi;
 
+	if (size < HDMI_INFOFRAME_HEADER_SIZE)
+		return -EINVAL;
+
 	if (ptr[0] != HDMI_INFOFRAME_TYPE_VENDOR ||
 	    ptr[1] != 1 ||
 	    (ptr[2] != 4 && ptr[2] != 5 && ptr[2] != 6))
@@ -1178,6 +1194,9 @@ hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
 
 	length = ptr[2];
 
+	if (size < HDMI_INFOFRAME_HEADER_SIZE + length)
+		return -EINVAL;
+
 	if (hdmi_infoframe_checksum(buffer,
 				    HDMI_INFOFRAME_HEADER_SIZE + length) != 0)
 		return -EINVAL;
@@ -1224,8 +1243,9 @@ hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
 
 /**
  * hdmi_infoframe_unpack() - unpack binary buffer to a HDMI infoframe
- * @buffer: source buffer
  * @frame: HDMI infoframe
+ * @buffer: source buffer
+ * @size: size of buffer
  *
  * Unpacks the information contained in binary buffer @buffer into a structured
  * @frame of a HDMI infoframe.
@@ -1235,23 +1255,26 @@ hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
  * Returns 0 on success or a negative error code on failure.
  */
 int hdmi_infoframe_unpack(union hdmi_infoframe *frame,
-			  const void *buffer)
+			  const void *buffer, size_t size)
 {
 	int ret;
 	const u8 *ptr = buffer;
 
+	if (size < HDMI_INFOFRAME_HEADER_SIZE)
+		return -EINVAL;
+
 	switch (ptr[0]) {
 	case HDMI_INFOFRAME_TYPE_AVI:
-		ret = hdmi_avi_infoframe_unpack(&frame->avi, buffer);
+		ret = hdmi_avi_infoframe_unpack(&frame->avi, buffer, size);
 		break;
 	case HDMI_INFOFRAME_TYPE_SPD:
-		ret = hdmi_spd_infoframe_unpack(&frame->spd, buffer);
+		ret = hdmi_spd_infoframe_unpack(&frame->spd, buffer, size);
 		break;
 	case HDMI_INFOFRAME_TYPE_AUDIO:
-		ret = hdmi_audio_infoframe_unpack(&frame->audio, buffer);
+		ret = hdmi_audio_infoframe_unpack(&frame->audio, buffer, size);
 		break;
 	case HDMI_INFOFRAME_TYPE_VENDOR:
-		ret = hdmi_vendor_any_infoframe_unpack(&frame->vendor, buffer);
+		ret = hdmi_vendor_any_infoframe_unpack(&frame->vendor, buffer, size);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index d3816170c062..a577d4ae2570 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -333,7 +333,7 @@ union hdmi_infoframe {
 ssize_t
 hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer, size_t size);
 int hdmi_infoframe_unpack(union hdmi_infoframe *frame,
-			  const void *buffer);
+			  const void *buffer, size_t size);
 void hdmi_infoframe_log(const char *level, struct device *dev,
 			union hdmi_infoframe *frame);
 
-- 
2.13.6
