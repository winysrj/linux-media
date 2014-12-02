Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:39489 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932412AbaLBMJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 07:09:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, dri-devel@lists.freedesktop.org,
	thierry.reding@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/3] hdmi: added unpack and logging functions for InfoFrames
Date: Tue,  2 Dec 2014 13:08:45 +0100
Message-Id: <1417522126-31771-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417522126-31771-1-git-send-email-hverkuil@xs4all.nl>
References: <1417522126-31771-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

When receiving video it is very useful to be able to unpack the InfoFrames.
Logging is useful as well, both for transmitters and receivers.

Especially when implementing the VIDIOC_LOG_STATUS ioctl (supported by many
V4L2 drivers) for a receiver it is important to be able to easily log what
the InfoFrame contains. This greatly simplifies debugging.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/video/hdmi.c | 819 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/hdmi.h |   4 +
 2 files changed, 816 insertions(+), 7 deletions(-)

diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index 9e758a8..5f7ab47 100644
--- a/drivers/video/hdmi.c
+++ b/drivers/video/hdmi.c
@@ -27,10 +27,12 @@
 #include <linux/export.h>
 #include <linux/hdmi.h>
 #include <linux/string.h>
+#include <linux/device.h>
 
-static void hdmi_infoframe_checksum(void *buffer, size_t size)
+#define hdmi_log(fmt, ...) dev_printk(level, dev, fmt, ##__VA_ARGS__)
+
+static u8 hdmi_infoframe_checksum(u8 *ptr, size_t size)
 {
-	u8 *ptr = buffer;
 	u8 csum = 0;
 	size_t i;
 
@@ -38,7 +40,14 @@ static void hdmi_infoframe_checksum(void *buffer, size_t size)
 	for (i = 0; i < size; i++)
 		csum += ptr[i];
 
-	ptr[3] = 256 - csum;
+	return 256 - csum;
+}
+
+static void hdmi_infoframe_set_checksum(void *buffer, size_t size)
+{
+	u8 *ptr = buffer;
+	/* update checksum */
+	ptr[3] = hdmi_infoframe_checksum(buffer, size);
 }
 
 /**
@@ -136,7 +145,7 @@ ssize_t hdmi_avi_infoframe_pack(struct hdmi_avi_infoframe *frame, void *buffer,
 	ptr[11] = frame->right_bar & 0xff;
 	ptr[12] = (frame->right_bar >> 8) & 0xff;
 
-	hdmi_infoframe_checksum(buffer, length);
+	hdmi_infoframe_set_checksum(buffer, length);
 
 	return length;
 }
@@ -206,7 +215,7 @@ ssize_t hdmi_spd_infoframe_pack(struct hdmi_spd_infoframe *frame, void *buffer,
 
 	ptr[24] = frame->sdi;
 
-	hdmi_infoframe_checksum(buffer, length);
+	hdmi_infoframe_set_checksum(buffer, length);
 
 	return length;
 }
@@ -281,7 +290,7 @@ ssize_t hdmi_audio_infoframe_pack(struct hdmi_audio_infoframe *frame,
 	if (frame->downmix_inhibit)
 		ptr[4] |= BIT(7);
 
-	hdmi_infoframe_checksum(buffer, length);
+	hdmi_infoframe_set_checksum(buffer, length);
 
 	return length;
 }
@@ -373,7 +382,7 @@ ssize_t hdmi_vendor_infoframe_pack(struct hdmi_vendor_infoframe *frame,
 			ptr[9] = (frame->s3d_ext_data & 0xf) << 4;
 	}
 
-	hdmi_infoframe_checksum(buffer, length);
+	hdmi_infoframe_set_checksum(buffer, length);
 
 	return length;
 }
@@ -434,3 +443,799 @@ hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer, size_t size)
 	return length;
 }
 EXPORT_SYMBOL(hdmi_infoframe_pack);
+
+static const char *hdmi_infoframe_type_get_name(enum hdmi_infoframe_type type)
+{
+	if (type < 0x80 || type > 0x9f)
+		return "Invalid";
+	switch (type) {
+	case HDMI_INFOFRAME_TYPE_VENDOR:
+		return "Vendor";
+	case HDMI_INFOFRAME_TYPE_AVI:
+		return "Auxiliary Video Information (AVI)";
+	case HDMI_INFOFRAME_TYPE_SPD:
+		return "Source Product Description (SPD)";
+	case HDMI_INFOFRAME_TYPE_AUDIO:
+		return "Audio";
+	}
+	return "Reserved";
+}
+
+static void hdmi_infoframe_log_header(const char *level,
+				      struct device *dev, void *f)
+{
+	struct hdmi_any_infoframe *frame = f;
+
+	hdmi_log("HDMI infoframe: %s, version %d, length %d\n",
+		hdmi_infoframe_type_get_name(frame->type),
+		frame->version, frame->length);
+}
+
+static const char *hdmi_colorspace_get_name(enum hdmi_colorspace colorspace)
+{
+	switch (colorspace) {
+	case HDMI_COLORSPACE_RGB:
+		return "RGB";
+	case HDMI_COLORSPACE_YUV422:
+		return "YCbCr 4:2:2";
+	case HDMI_COLORSPACE_YUV444:
+		return "YCbCr 4:4:4";
+	case HDMI_COLORSPACE_YUV420:
+		return "YCbCr 4:2:0";
+	case HDMI_COLORSPACE_RESERVED4:
+		return "Reserved (4)";
+	case HDMI_COLORSPACE_RESERVED5:
+		return "Reserved (5)";
+	case HDMI_COLORSPACE_RESERVED6:
+		return "Reserved (6)";
+	case HDMI_COLORSPACE_IDO_DEFINED:
+		return "IDO Defined";
+	}
+	return "Invalid";
+}
+
+static const char *hdmi_scan_mode_get_name(enum hdmi_scan_mode scan_mode)
+{
+	switch (scan_mode) {
+	case HDMI_SCAN_MODE_NONE:
+		return "No Data";
+	case HDMI_SCAN_MODE_OVERSCAN:
+		return "Overscan";
+	case HDMI_SCAN_MODE_UNDERSCAN:
+		return "Underscan";
+	case HDMI_SCAN_MODE_RESERVED:
+		return "Reserved";
+	}
+	return "Invalid";
+}
+
+static const char *hdmi_colorimetry_get_name(enum hdmi_colorimetry colorimetry)
+{
+	switch (colorimetry) {
+	case HDMI_COLORIMETRY_NONE:
+		return "No Data";
+	case HDMI_COLORIMETRY_ITU_601:
+		return "ITU601";
+	case HDMI_COLORIMETRY_ITU_709:
+		return "ITU709";
+	case HDMI_COLORIMETRY_EXTENDED:
+		return "Extended";
+	}
+	return "Invalid";
+}
+
+static const char *
+hdmi_picture_aspect_get_name(enum hdmi_picture_aspect picture_aspect)
+{
+	switch (picture_aspect) {
+	case HDMI_PICTURE_ASPECT_NONE:
+		return "No Data";
+	case HDMI_PICTURE_ASPECT_4_3:
+		return "4:3";
+	case HDMI_PICTURE_ASPECT_16_9:
+		return "16:9";
+	case HDMI_PICTURE_ASPECT_RESERVED:
+		return "Reserved";
+	}
+	return "Invalid";
+}
+
+static const char *
+hdmi_active_aspect_get_name(enum hdmi_active_aspect active_aspect)
+{
+	if (active_aspect < 0 || active_aspect > 0xf)
+		return "Invalid";
+
+	switch (active_aspect) {
+	case HDMI_ACTIVE_ASPECT_16_9_TOP:
+		return "16:9 Top";
+	case HDMI_ACTIVE_ASPECT_14_9_TOP:
+		return "14:9 Top";
+	case HDMI_ACTIVE_ASPECT_16_9_CENTER:
+		return "16:9 Center";
+	case HDMI_ACTIVE_ASPECT_PICTURE:
+		return "Same as Picture";
+	case HDMI_ACTIVE_ASPECT_4_3:
+		return "4:3";
+	case HDMI_ACTIVE_ASPECT_16_9:
+		return "16:9";
+	case HDMI_ACTIVE_ASPECT_14_9:
+		return "14:9";
+	case HDMI_ACTIVE_ASPECT_4_3_SP_14_9:
+		return "4:3 SP 14:9";
+	case HDMI_ACTIVE_ASPECT_16_9_SP_14_9:
+		return "16:9 SP 14:9";
+	case HDMI_ACTIVE_ASPECT_16_9_SP_4_3:
+		return "16:9 SP 4:3";
+	}
+	return "Reserved";
+}
+
+static const char *
+hdmi_extended_colorimetry_get_name(enum hdmi_extended_colorimetry ext_col)
+{
+	switch (ext_col) {
+	case HDMI_EXTENDED_COLORIMETRY_XV_YCC_601:
+		return "xvYCC 601";
+	case HDMI_EXTENDED_COLORIMETRY_XV_YCC_709:
+		return "xvYCC 709";
+	case HDMI_EXTENDED_COLORIMETRY_S_YCC_601:
+		return "sYCC 601";
+	case HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601:
+		return "Adobe YCC 601";
+	case HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB:
+		return "Adobe RGB";
+	case HDMI_EXTENDED_COLORIMETRY_BT2020_CONST_LUM:
+		return "BT.2020 Constant Luminance";
+	case HDMI_EXTENDED_COLORIMETRY_BT2020:
+		return "BT.2020";
+	case HDMI_EXTENDED_COLORIMETRY_RESERVED:
+		return "Reserved";
+	}
+	return "Invalid";
+}
+
+static const char *
+hdmi_quantization_range_get_name(enum hdmi_quantization_range qrange)
+{
+	switch (qrange) {
+	case HDMI_QUANTIZATION_RANGE_DEFAULT:
+		return "Default";
+	case HDMI_QUANTIZATION_RANGE_LIMITED:
+		return "Limited";
+	case HDMI_QUANTIZATION_RANGE_FULL:
+		return "Full";
+	case HDMI_QUANTIZATION_RANGE_RESERVED:
+		return "Reserved";
+	}
+	return "Invalid";
+}
+
+static const char *hdmi_nups_get_name(enum hdmi_nups nups)
+{
+	switch (nups) {
+	case HDMI_NUPS_UNKNOWN:
+		return "No Known Non-uniform Scaling";
+	case HDMI_NUPS_HORIZONTAL:
+		return "Horizontally Scaled";
+	case HDMI_NUPS_VERTICAL:
+		return "Vertically Scaled";
+	case HDMI_NUPS_BOTH:
+		return "Horizontally and Vertically Scaled";
+	}
+	return "Invalid";
+}
+
+static const char *
+hdmi_ycc_quantization_range_get_name(enum hdmi_ycc_quantization_range qrange)
+{
+	switch (qrange) {
+	case HDMI_YCC_QUANTIZATION_RANGE_LIMITED:
+		return "Limited";
+	case HDMI_YCC_QUANTIZATION_RANGE_FULL:
+		return "Full";
+	}
+	return "Invalid";
+}
+
+static const char *
+hdmi_content_type_get_name(enum hdmi_content_type content_type)
+{
+	switch (content_type) {
+	case HDMI_CONTENT_TYPE_GRAPHICS:
+		return "Graphics";
+	case HDMI_CONTENT_TYPE_PHOTO:
+		return "Photo";
+	case HDMI_CONTENT_TYPE_CINEMA:
+		return "Cinema";
+	case HDMI_CONTENT_TYPE_GAME:
+		return "Game";
+	}
+	return "Invalid";
+}
+
+/**
+ * hdmi_avi_infoframe_log() - log info of HDMI AVI infoframe
+ * @level: logging level
+ * @dev: device
+ * @frame: HDMI AVI infoframe
+ */
+static void hdmi_avi_infoframe_log(const char *level,
+				   struct device *dev,
+				   struct hdmi_avi_infoframe *frame)
+{
+	hdmi_infoframe_log_header(level, dev, frame);
+
+	hdmi_log("    colorspace: %s\n",
+			hdmi_colorspace_get_name(frame->colorspace));
+	hdmi_log("    scan mode: %s\n",
+			hdmi_scan_mode_get_name(frame->scan_mode));
+	hdmi_log("    colorimetry: %s\n",
+			hdmi_colorimetry_get_name(frame->colorimetry));
+	hdmi_log("    picture aspect: %s\n",
+			hdmi_picture_aspect_get_name(frame->picture_aspect));
+	hdmi_log("    active aspect: %s\n",
+			hdmi_active_aspect_get_name(frame->active_aspect));
+	hdmi_log("    itc: %s\n", frame->itc ? "IT Content" : "No Data");
+	hdmi_log("    extended colorimetry: %s\n",
+			hdmi_extended_colorimetry_get_name(frame->extended_colorimetry));
+	hdmi_log("    quantization range: %s\n",
+			hdmi_quantization_range_get_name(frame->quantization_range));
+	hdmi_log("    nups: %s\n", hdmi_nups_get_name(frame->nups));
+	hdmi_log("    video code: %d\n", frame->video_code);
+	hdmi_log("    ycc quantization range: %s\n",
+			hdmi_ycc_quantization_range_get_name(frame->ycc_quantization_range));
+	hdmi_log("    hdmi content type: %s\n",
+			hdmi_content_type_get_name(frame->content_type));
+	hdmi_log("    pixel repeat: %d\n", frame->pixel_repeat);
+	hdmi_log("    bar top %d, bottom %d, left %d, right %d\n",
+			frame->top_bar, frame->bottom_bar,
+			frame->left_bar, frame->right_bar);
+}
+
+static const char *hdmi_spd_sdi_get_name(enum hdmi_spd_sdi sdi)
+{
+	if (sdi < 0 || sdi > 0xff)
+		return "Invalid";
+	switch (sdi) {
+	case HDMI_SPD_SDI_UNKNOWN:
+		return "Unknown";
+	case HDMI_SPD_SDI_DSTB:
+		return "Digital STB";
+	case HDMI_SPD_SDI_DVDP:
+		return "DVD Player";
+	case HDMI_SPD_SDI_DVHS:
+		return "D-VHS";
+	case HDMI_SPD_SDI_HDDVR:
+		return "HDD Videorecorder";
+	case HDMI_SPD_SDI_DVC:
+		return "DVC";
+	case HDMI_SPD_SDI_DSC:
+		return "DSC";
+	case HDMI_SPD_SDI_VCD:
+		return "Video CD";
+	case HDMI_SPD_SDI_GAME:
+		return "Game";
+	case HDMI_SPD_SDI_PC:
+		return "PC General";
+	case HDMI_SPD_SDI_BD:
+		return "Blu-Ray Disc (BD)";
+	case HDMI_SPD_SDI_SACD:
+		return "Super Audio CD";
+	case HDMI_SPD_SDI_HDDVD:
+		return "HD DVD";
+	case HDMI_SPD_SDI_PMP:
+		return "PMP";
+	}
+	return "Reserved";
+}
+
+/**
+ * hdmi_spd_infoframe_log() - log info of HDMI SPD infoframe
+ * @level: logging level
+ * @dev: device
+ * @frame: HDMI SPD infoframe
+ */
+static void hdmi_spd_infoframe_log(const char *level,
+				   struct device *dev,
+				   struct hdmi_spd_infoframe *frame)
+{
+	u8 buf[17];
+
+	hdmi_infoframe_log_header(level, dev, frame);
+
+	memset(buf, 0, sizeof(buf));
+
+	strncpy(buf, frame->vendor, 8);
+	hdmi_log("    vendor: %s\n", buf);
+	strncpy(buf, frame->product, 16);
+	hdmi_log("    product: %s\n", buf);
+	hdmi_log("    source device information: %s (0x%x)\n",
+		hdmi_spd_sdi_get_name(frame->sdi), frame->sdi);
+}
+
+static const char *
+hdmi_audio_coding_type_get_name(enum hdmi_audio_coding_type coding_type)
+{
+	switch (coding_type) {
+	case HDMI_AUDIO_CODING_TYPE_STREAM:
+		return "Refer to Stream Header";
+	case HDMI_AUDIO_CODING_TYPE_PCM:
+		return "PCM";
+	case HDMI_AUDIO_CODING_TYPE_AC3:
+		return "AC-3";
+	case HDMI_AUDIO_CODING_TYPE_MPEG1:
+		return "MPEG1";
+	case HDMI_AUDIO_CODING_TYPE_MP3:
+		return "MP3";
+	case HDMI_AUDIO_CODING_TYPE_MPEG2:
+		return "MPEG2";
+	case HDMI_AUDIO_CODING_TYPE_AAC_LC:
+		return "AAC";
+	case HDMI_AUDIO_CODING_TYPE_DTS:
+		return "DTS";
+	case HDMI_AUDIO_CODING_TYPE_ATRAC:
+		return "ATRAC";
+	case HDMI_AUDIO_CODING_TYPE_DSD:
+		return "One Bit Audio";
+	case HDMI_AUDIO_CODING_TYPE_EAC3:
+		return "Dolby Digital +";
+	case HDMI_AUDIO_CODING_TYPE_DTS_HD:
+		return "DTS-HD";
+	case HDMI_AUDIO_CODING_TYPE_MLP:
+		return "MAT (MLP)";
+	case HDMI_AUDIO_CODING_TYPE_DST:
+		return "DST";
+	case HDMI_AUDIO_CODING_TYPE_WMA_PRO:
+		return "WMA PRO";
+	case HDMI_AUDIO_CODING_TYPE_CXT:
+		return "Refer to CXT";
+	}
+	return "Invalid";
+}
+
+static const char *
+hdmi_audio_sample_size_get_name(enum hdmi_audio_sample_size sample_size)
+{
+	switch (sample_size) {
+	case HDMI_AUDIO_SAMPLE_SIZE_STREAM:
+		return "Refer to Stream Header";
+	case HDMI_AUDIO_SAMPLE_SIZE_16:
+		return "16 bit";
+	case HDMI_AUDIO_SAMPLE_SIZE_20:
+		return "20 bit";
+	case HDMI_AUDIO_SAMPLE_SIZE_24:
+		return "24 bit";
+	}
+	return "Invalid";
+}
+
+static const char *
+hdmi_audio_sample_frequency_get_name(enum hdmi_audio_sample_frequency freq)
+{
+	switch (freq) {
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_STREAM:
+		return "Refer to Stream Header";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_32000:
+		return "32 kHz";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_44100:
+		return "44.1 kHz (CD)";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_48000:
+		return "48 kHz";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_88200:
+		return "88.2 kHz";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_96000:
+		return "96 kHz";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_176400:
+		return "176.4 kHz";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_192000:
+		return "192 kHz";
+	}
+	return "Invalid";
+}
+
+static const char *
+hdmi_audio_coding_type_ext_get_name(enum hdmi_audio_coding_type_ext ctx)
+{
+	if (ctx < 0 || ctx > 0x1f)
+		return "Invalid";
+
+	switch (ctx) {
+	case HDMI_AUDIO_CODING_TYPE_EXT_STREAM:
+		return "Stream";
+	case HDMI_AUDIO_CODING_TYPE_EXT_HE_AAC:
+		return "HE AAC";
+	case HDMI_AUDIO_CODING_TYPE_EXT_HE_AAC_V2:
+		return "HE AAC v2";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG_SURROUND:
+		return "MPEG SURROUND";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC:
+		return "MPEG-4 HE AAC";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC_V2:
+		return "MPEG-4 HE AAC v2";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_AAC_LC:
+		return "MPEG-4 AAC LC";
+	case HDMI_AUDIO_CODING_TYPE_EXT_DRA:
+		return "DRA";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC_SURROUND:
+		return "MPEG-4 HE AAC + MPEG Surround";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_AAC_LC_SURROUND:
+		return "MPEG-4 AAC LC + MPEG Surround";
+	}
+	return "Reserved";
+}
+
+/**
+ * hdmi_audio_infoframe_log() - log info of HDMI AUDIO infoframe
+ * @level: logging level
+ * @dev: device
+ * @frame: HDMI AUDIO infoframe
+ */
+static void hdmi_audio_infoframe_log(const char *level,
+				     struct device *dev,
+				     struct hdmi_audio_infoframe *frame)
+{
+	hdmi_infoframe_log_header(level, dev, frame);
+
+	if (frame->channels)
+		hdmi_log("    channels: %d ch\n", frame->channels - 1);
+	else
+		hdmi_log("    channels: Refer to stream header\n");
+	hdmi_log("    coding type: %s\n",
+			hdmi_audio_coding_type_get_name(frame->coding_type));
+	hdmi_log("    sample size: %s\n",
+			hdmi_audio_sample_size_get_name(frame->sample_size));
+	hdmi_log("    sample frequency: %s\n",
+			hdmi_audio_sample_frequency_get_name(frame->sample_frequency));
+	hdmi_log("    coding type ext: %s\n",
+			hdmi_audio_coding_type_ext_get_name(frame->coding_type_ext));
+	hdmi_log("    channel allocation: %d\n",
+			frame->channel_allocation);
+	hdmi_log("    level shift value: %d db\n",
+			frame->level_shift_value);
+	hdmi_log("    downmix inhibit: %s\n",
+			frame->downmix_inhibit ? "Yes" : "No");
+}
+
+static const char *
+hdmi_3d_structure_get_name(enum hdmi_3d_structure s3d_struct)
+{
+	if (s3d_struct < 0 || s3d_struct > 0xf)
+		return "Invalid";
+
+	switch (s3d_struct) {
+	case HDMI_3D_STRUCTURE_FRAME_PACKING:
+		return "Frame Packing";
+	case HDMI_3D_STRUCTURE_FIELD_ALTERNATIVE:
+		return "Field Alternative";
+	case HDMI_3D_STRUCTURE_LINE_ALTERNATIVE:
+		return "Line Alternative";
+	case HDMI_3D_STRUCTURE_SIDE_BY_SIDE_FULL:
+		return "Side-by-side (Full)";
+	case HDMI_3D_STRUCTURE_L_DEPTH:
+		return "L + Depth";
+	case HDMI_3D_STRUCTURE_L_DEPTH_GFX_GFX_DEPTH:
+		return "L + Depth + Graphics + Graphics-depth";
+	case HDMI_3D_STRUCTURE_TOP_AND_BOTTOM:
+		return "Top-and-Bottom";
+	case HDMI_3D_STRUCTURE_SIDE_BY_SIDE_HALF:
+		return "Side-by-side (Half)";
+	default:
+		break;
+	}
+	return "Reserved";
+}
+
+/**
+ * hdmi_vendor_infoframe_log() - log info of HDMI VENDOR infoframe
+ * @level: logging level
+ * @dev: device
+ * @frame: HDMI VENDOR infoframe
+ */
+static void
+hdmi_vendor_any_infoframe_log(const char *level,
+			      struct device *dev,
+			      union hdmi_vendor_any_infoframe *frame)
+{
+	struct hdmi_vendor_infoframe *hvf = &frame->hdmi;
+
+	hdmi_infoframe_log_header(level, dev, frame);
+
+	if (frame->any.oui != HDMI_IEEE_OUI) {
+		hdmi_log("    not a HDMI vendor infoframe\n");
+		return;
+	}
+	if (hvf->vic == 0 && hvf->s3d_struct == HDMI_3D_STRUCTURE_INVALID) {
+		hdmi_log("    empty frame\n");
+		return;
+	}
+
+	if (hvf->vic)
+		hdmi_log("    HDMI VIC: %d\n", hvf->vic);
+	if (hvf->s3d_struct != HDMI_3D_STRUCTURE_INVALID) {
+		hdmi_log("    3D structure: %s\n",
+				hdmi_3d_structure_get_name(hvf->s3d_struct));
+		if (hvf->s3d_struct >= HDMI_3D_STRUCTURE_SIDE_BY_SIDE_HALF)
+			hdmi_log("    3D extension data: %d\n",
+					hvf->s3d_ext_data);
+	}
+}
+
+/**
+ * hdmi_infoframe_log() - log info of HDMI infoframe
+ * @level: logging level
+ * @dev: device
+ * @frame: HDMI infoframe
+ */
+void hdmi_infoframe_log(const char *level,
+			struct device *dev,
+			union hdmi_infoframe *frame)
+{
+	switch (frame->any.type) {
+	case HDMI_INFOFRAME_TYPE_AVI:
+		hdmi_avi_infoframe_log(level, dev, &frame->avi);
+		break;
+	case HDMI_INFOFRAME_TYPE_SPD:
+		hdmi_spd_infoframe_log(level, dev, &frame->spd);
+		break;
+	case HDMI_INFOFRAME_TYPE_AUDIO:
+		hdmi_audio_infoframe_log(level, dev, &frame->audio);
+		break;
+	case HDMI_INFOFRAME_TYPE_VENDOR:
+		hdmi_vendor_any_infoframe_log(level, dev, &frame->vendor);
+		break;
+	}
+}
+EXPORT_SYMBOL(hdmi_infoframe_log);
+
+/**
+ * hdmi_avi_infoframe_unpack() - unpack binary buffer to a HDMI AVI infoframe
+ * @buffer: source buffer
+ * @frame: HDMI AVI infoframe
+ *
+ * Unpacks the information contained in binary @buffer into a structured
+ * @frame of the HDMI Auxiliary Video (AVI) information frame.
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4
+ * specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int hdmi_avi_infoframe_unpack(struct hdmi_avi_infoframe *frame,
+				     void *buffer)
+{
+	u8 *ptr = buffer;
+	int ret;
+
+	if (ptr[0] != HDMI_INFOFRAME_TYPE_AVI ||
+	    ptr[1] != 2 ||
+	    ptr[2] != HDMI_AVI_INFOFRAME_SIZE)
+		return -EINVAL;
+
+	if (hdmi_infoframe_checksum(buffer, HDMI_INFOFRAME_SIZE(AVI)) != 0)
+		return -EINVAL;
+
+	ret = hdmi_avi_infoframe_init(frame);
+	if (ret)
+		return ret;
+
+	ptr += HDMI_INFOFRAME_HEADER_SIZE;
+
+	frame->colorspace = (ptr[0] >> 5) & 0x3;
+	if (ptr[0] & 0x10)
+		frame->active_aspect = ptr[1] & 0xf;
+	if (ptr[0] & 0x8) {
+		frame->top_bar = (ptr[5] << 8) + ptr[6];
+		frame->bottom_bar = (ptr[7] << 8) + ptr[8];
+	}
+	if (ptr[0] & 0x4) {
+		frame->left_bar = (ptr[9] << 8) + ptr[10];
+		frame->right_bar = (ptr[11] << 8) + ptr[12];
+	}
+	frame->scan_mode = ptr[0] & 0x3;
+
+	frame->colorimetry = (ptr[1] >> 6) & 0x3;
+	frame->picture_aspect = (ptr[1] >> 4) & 0x3;
+	frame->active_aspect = ptr[1] & 0xf;
+
+	frame->itc = ptr[2] & 0x80 ? true : false;
+	frame->extended_colorimetry = (ptr[2] >> 4) & 0x7;
+	frame->quantization_range = (ptr[2] >> 2) & 0x3;
+	frame->nups = ptr[2] & 0x3;
+
+	frame->video_code = ptr[3] & 0x7f;
+	frame->ycc_quantization_range = (ptr[4] >> 6) & 0x3;
+	frame->content_type = (ptr[4] >> 4) & 0x3;
+
+	frame->pixel_repeat = ptr[4] & 0xf;
+
+	return 0;
+}
+
+/**
+ * hdmi_spd_infoframe_unpack() - unpack binary buffer to a HDMI SPD infoframe
+ * @buffer: source buffer
+ * @frame: HDMI SPD infoframe
+ *
+ * Unpacks the information contained in binary @buffer into a structured
+ * @frame of the HDMI Source Product Description (SPD) information frame.
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4
+ * specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int hdmi_spd_infoframe_unpack(struct hdmi_spd_infoframe *frame,
+				     void *buffer)
+{
+	u8 *ptr = buffer;
+	int ret;
+
+	if (ptr[0] != HDMI_INFOFRAME_TYPE_SPD ||
+	    ptr[1] != 1 ||
+	    ptr[2] != HDMI_SPD_INFOFRAME_SIZE) {
+		return -EINVAL;
+	}
+
+	if (hdmi_infoframe_checksum(buffer, HDMI_INFOFRAME_SIZE(SPD)) != 0)
+		return -EINVAL;
+
+	ptr += HDMI_INFOFRAME_HEADER_SIZE;
+
+	ret = hdmi_spd_infoframe_init(frame, ptr, ptr + 8);
+	if (ret)
+		return ret;
+
+	frame->sdi = ptr[24];
+
+	return 0;
+}
+
+/**
+ * hdmi_audio_infoframe_unpack() - unpack binary buffer to a HDMI AUDIO infoframe
+ * @buffer: source buffer
+ * @frame: HDMI Audio infoframe
+ *
+ * Unpacks the information contained in binary @buffer into a structured
+ * @frame of the HDMI Audio information frame.
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4
+ * specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int hdmi_audio_infoframe_unpack(struct hdmi_audio_infoframe *frame,
+				       void *buffer)
+{
+	u8 *ptr = buffer;
+	int ret;
+
+	if (ptr[0] != HDMI_INFOFRAME_TYPE_AUDIO ||
+	    ptr[1] != 1 ||
+	    ptr[2] != HDMI_AUDIO_INFOFRAME_SIZE) {
+		return -EINVAL;
+	}
+
+	if (hdmi_infoframe_checksum(buffer, HDMI_INFOFRAME_SIZE(AUDIO)) != 0)
+		return -EINVAL;
+
+	ret = hdmi_audio_infoframe_init(frame);
+	if (ret)
+		return ret;
+
+	ptr += HDMI_INFOFRAME_HEADER_SIZE;
+
+	frame->channels = ptr[0] & 0x7;
+	frame->coding_type = (ptr[0] >> 4) & 0xf;
+	frame->sample_size = ptr[1] & 0x3;
+	frame->sample_frequency = (ptr[1] >> 2) & 0x7;
+	frame->coding_type_ext = ptr[2] & 0x1f;
+	frame->channel_allocation = ptr[3];
+	frame->level_shift_value = (ptr[4] >> 3) & 0xf;
+	frame->downmix_inhibit = ptr[4] & 0x80 ? true : false;
+
+	return 0;
+}
+
+/**
+ * hdmi_vendor_infoframe_unpack() - unpack binary buffer to a HDMI vendor infoframe
+ * @buffer: source buffer
+ * @frame: HDMI Vendor infoframe
+ *
+ * Unpacks the information contained in binary @buffer into a structured
+ * @frame of the HDMI Vendor information frame.
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4
+ * specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int
+hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
+				 void *buffer)
+{
+	u8 *ptr = buffer;
+	size_t length;
+	int ret;
+	u8 hdmi_video_format;
+	struct hdmi_vendor_infoframe *hvf = &frame->hdmi;
+
+	if (ptr[0] != HDMI_INFOFRAME_TYPE_VENDOR ||
+	    ptr[1] != 1 ||
+	    (ptr[2] != 5 && ptr[2] != 6))
+		return -EINVAL;
+
+	length = ptr[2];
+
+	if (hdmi_infoframe_checksum(buffer,
+				    HDMI_INFOFRAME_HEADER_SIZE + length) != 0)
+		return -EINVAL;
+
+	ptr += HDMI_INFOFRAME_HEADER_SIZE;
+
+	/* HDMI OUI */
+	if ((ptr[0] != 0x03) ||
+	    (ptr[1] != 0x0c) ||
+	    (ptr[2] != 0x00))
+		return -EINVAL;
+
+	hdmi_video_format = ptr[3] >> 5;
+
+	if (hdmi_video_format > 0x2)
+		return -EINVAL;
+
+	ret = hdmi_vendor_infoframe_init(hvf);
+	if (ret)
+		return ret;
+
+	hvf->length = length;
+
+	if (hdmi_video_format == 0x1) {
+		hvf->vic = ptr[4];
+	} else if (hdmi_video_format == 0x2) {
+		hvf->s3d_struct = ptr[4] >> 4;
+		if (hvf->s3d_struct >= HDMI_3D_STRUCTURE_SIDE_BY_SIDE_HALF) {
+			if (length == 6)
+				hvf->s3d_ext_data = ptr[5] >> 4;
+			else
+				return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * hdmi_infoframe_unpack() - unpack binary buffer to a HDMI infoframe
+ * @buffer: source buffer
+ * @frame: HDMI infoframe
+ *
+ * Unpacks the information contained in binary buffer @buffer into a structured
+ * @frame of a HDMI infoframe.
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4
+ * specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int hdmi_infoframe_unpack(union hdmi_infoframe *frame, void *buffer)
+{
+	int ret;
+	u8 *ptr = buffer;
+
+	switch (ptr[0]) {
+	case HDMI_INFOFRAME_TYPE_AVI:
+		ret = hdmi_avi_infoframe_unpack(&frame->avi, buffer);
+		break;
+	case HDMI_INFOFRAME_TYPE_SPD:
+		ret = hdmi_spd_infoframe_unpack(&frame->spd, buffer);
+		break;
+	case HDMI_INFOFRAME_TYPE_AUDIO:
+		ret = hdmi_audio_infoframe_unpack(&frame->audio, buffer);
+		break;
+	case HDMI_INFOFRAME_TYPE_VENDOR:
+		ret = hdmi_vendor_any_infoframe_unpack(&frame->vendor, buffer);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(hdmi_infoframe_unpack);
diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index a4aa0c2..d6dea20 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -10,6 +10,7 @@
 #define __LINUX_HDMI_H_
 
 #include <linux/types.h>
+#include <linux/device.h>
 
 enum hdmi_infoframe_type {
 	HDMI_INFOFRAME_TYPE_VENDOR = 0x81,
@@ -312,5 +313,8 @@ union hdmi_infoframe {
 
 ssize_t
 hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer, size_t size);
+int hdmi_infoframe_unpack(union hdmi_infoframe *frame, void *buffer);
+void hdmi_infoframe_log(const char *level, struct device *dev,
+			union hdmi_infoframe *frame);
 
 #endif /* _DRM_HDMI_H */
-- 
2.1.3

