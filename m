Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38495 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbaK1OvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 09:51:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
	marbugge@cisco.com, dri-devel@lists.freedesktop.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] hdmi: added unpack and logging functions for InfoFrames
Date: Fri, 28 Nov 2014 15:50:50 +0100
Message-Id: <1417186251-6542-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417186251-6542-1-git-send-email-hverkuil@xs4all.nl>
References: <1417186251-6542-1-git-send-email-hverkuil@xs4all.nl>
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
 drivers/video/hdmi.c | 622 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/hdmi.h |   3 +
 2 files changed, 618 insertions(+), 7 deletions(-)

diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index 9e758a8..9f0f554 100644
--- a/drivers/video/hdmi.c
+++ b/drivers/video/hdmi.c
@@ -27,10 +27,10 @@
 #include <linux/export.h>
 #include <linux/hdmi.h>
 #include <linux/string.h>
+#include <linux/device.h>
 
-static void hdmi_infoframe_checksum(void *buffer, size_t size)
+static u8 hdmi_infoframe_calc_checksum(u8 *ptr, size_t size)
 {
-	u8 *ptr = buffer;
 	u8 csum = 0;
 	size_t i;
 
@@ -38,7 +38,14 @@ static void hdmi_infoframe_checksum(void *buffer, size_t size)
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
+	ptr[3] = hdmi_infoframe_calc_checksum(buffer, size);
 }
 
 /**
@@ -136,7 +143,7 @@ ssize_t hdmi_avi_infoframe_pack(struct hdmi_avi_infoframe *frame, void *buffer,
 	ptr[11] = frame->right_bar & 0xff;
 	ptr[12] = (frame->right_bar >> 8) & 0xff;
 
-	hdmi_infoframe_checksum(buffer, length);
+	hdmi_infoframe_set_checksum(buffer, length);
 
 	return length;
 }
@@ -206,7 +213,7 @@ ssize_t hdmi_spd_infoframe_pack(struct hdmi_spd_infoframe *frame, void *buffer,
 
 	ptr[24] = frame->sdi;
 
-	hdmi_infoframe_checksum(buffer, length);
+	hdmi_infoframe_set_checksum(buffer, length);
 
 	return length;
 }
@@ -281,7 +288,7 @@ ssize_t hdmi_audio_infoframe_pack(struct hdmi_audio_infoframe *frame,
 	if (frame->downmix_inhibit)
 		ptr[4] |= BIT(7);
 
-	hdmi_infoframe_checksum(buffer, length);
+	hdmi_infoframe_set_checksum(buffer, length);
 
 	return length;
 }
@@ -373,7 +380,7 @@ ssize_t hdmi_vendor_infoframe_pack(struct hdmi_vendor_infoframe *frame,
 			ptr[9] = (frame->s3d_ext_data & 0xf) << 4;
 	}
 
-	hdmi_infoframe_checksum(buffer, length);
+	hdmi_infoframe_set_checksum(buffer, length);
 
 	return length;
 }
@@ -434,3 +441,604 @@ hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer, size_t size)
 	return length;
 }
 EXPORT_SYMBOL(hdmi_infoframe_pack);
+
+static const char *hdmi_infoframe_type_txt(enum hdmi_infoframe_type type)
+{
+	switch (type) {
+	case HDMI_INFOFRAME_TYPE_VENDOR: return "Vendor";
+	case HDMI_INFOFRAME_TYPE_AVI: return "Auxiliary Video Information (AVI)";
+	case HDMI_INFOFRAME_TYPE_SPD: return "Source Product Description (SPD)";
+	case HDMI_INFOFRAME_TYPE_AUDIO: return "Audio";
+	}
+	return "Invalid/Unknown";
+}
+
+static void hdmi_infoframe_log_header(struct device *dev, void *f)
+{
+	struct hdmi_any_infoframe *frame = f;
+	dev_info(dev, "HDMI infoframe: %s, version %d, length %d\n",
+		hdmi_infoframe_type_txt(frame->type), frame->version, frame->length);
+}
+
+static const char *hdmi_colorspace_txt(enum hdmi_colorspace colorspace)
+{
+	switch (colorspace) {
+	case HDMI_COLORSPACE_RGB: return "RGB";
+	case HDMI_COLORSPACE_YUV422: return "YCbCr 4:2:2";
+	case HDMI_COLORSPACE_YUV444: return "YCbCr 4:4:4";
+	case HDMI_COLORSPACE_YUV420: return "YCbCr 4:2:0";
+	case HDMI_COLORSPACE_IDO_DEFINED: return "IDO Defined";
+	}
+	return "Future";
+}
+
+static const char *hdmi_scan_mode_txt(enum hdmi_scan_mode scan_mode)
+{
+	switch(scan_mode) {
+	case HDMI_SCAN_MODE_NONE: return "No Data";
+	case HDMI_SCAN_MODE_OVERSCAN: return "Composed for overscanned display";
+	case HDMI_SCAN_MODE_UNDERSCAN: return "Composed for underscanned display";
+	}
+	return "Future";
+}
+
+static const char *hdmi_colorimetry_txt(enum hdmi_colorimetry colorimetry)
+{
+	switch(colorimetry) {
+	case HDMI_COLORIMETRY_NONE: return "No Data";
+	case HDMI_COLORIMETRY_ITU_601: return "ITU601";
+	case HDMI_COLORIMETRY_ITU_709: return "ITU709";
+	case HDMI_COLORIMETRY_EXTENDED: return "Extended";
+	}
+	return "Invalid/Unknown";
+}
+
+static const char *hdmi_picture_aspect_txt(enum hdmi_picture_aspect picture_aspect)
+{
+	switch (picture_aspect) {
+	case HDMI_PICTURE_ASPECT_NONE: return "No Data";
+	case HDMI_PICTURE_ASPECT_4_3: return "4:3";
+	case HDMI_PICTURE_ASPECT_16_9: return "16:9";
+	}
+	return "Future";
+}
+
+static const char *hdmi_active_aspect_txt(enum hdmi_active_aspect active_aspect)
+{
+	switch (active_aspect) {
+	case HDMI_ACTIVE_ASPECT_16_9_TOP: return "16:9 Top";
+	case HDMI_ACTIVE_ASPECT_14_9_TOP: return "14:9 Top";
+	case HDMI_ACTIVE_ASPECT_16_9_CENTER: return "16:9 Center";
+	case HDMI_ACTIVE_ASPECT_PICTURE: return "Same as Picture";
+	case HDMI_ACTIVE_ASPECT_4_3: return "4:3";
+	case HDMI_ACTIVE_ASPECT_16_9: return "16:9";
+	case HDMI_ACTIVE_ASPECT_14_9: return "14:9";
+	case HDMI_ACTIVE_ASPECT_4_3_SP_14_9: return "4:3 SP 14:9";
+	case HDMI_ACTIVE_ASPECT_16_9_SP_14_9: return "16:9 SP 14:9";
+	case HDMI_ACTIVE_ASPECT_16_9_SP_4_3: return "16:9 SP 4:3";
+	}
+	return "Invalid/Unknown";
+}
+
+static const char *hdmi_extended_colorimetry_txt(enum hdmi_extended_colorimetry extended_colorimetry)
+{
+	switch (extended_colorimetry) {
+	case HDMI_EXTENDED_COLORIMETRY_XV_YCC_601: return "xvYCC 601";
+	case HDMI_EXTENDED_COLORIMETRY_XV_YCC_709: return "xvYCC 709";
+	case HDMI_EXTENDED_COLORIMETRY_S_YCC_601: return "sYCC 601";
+	case HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601: return "Adobe YCC 601";
+	case HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB: return "Adobe RGB";
+	case HDMI_EXTENDED_COLORIMETRY_BT2020_CONST_LUM: return "BT.2020 Constant Luminance";
+	case HDMI_EXTENDED_COLORIMETRY_BT2020: return "BT.2020";
+	}
+	return "Invalid/Unknown";
+}
+
+static const char *hdmi_quantization_range_txt(enum hdmi_quantization_range quantization_range)
+{
+	switch (quantization_range) {
+	case HDMI_QUANTIZATION_RANGE_DEFAULT: return "Default (depends on video format)";
+	case HDMI_QUANTIZATION_RANGE_LIMITED: return "Limited";
+	case HDMI_QUANTIZATION_RANGE_FULL: return "Full";
+	}
+	return "Reserved";
+}
+
+static const char *hdmi_nups_txt(enum hdmi_nups nups)
+{
+	switch (nups) {
+	case HDMI_NUPS_UNKNOWN: return "No known non-uniform scaling";
+	case HDMI_NUPS_HORIZONTAL: return "Horizontally scaled";
+	case HDMI_NUPS_VERTICAL: return "Vertically scaled";
+	case HDMI_NUPS_BOTH: return "Horizontally and Vertically scaled";
+	}
+	return "Invalid/Unknown";
+}
+
+static const char *hdmi_ycc_quantization_range_txt(enum hdmi_ycc_quantization_range ycc_quantization_range)
+{
+	switch (ycc_quantization_range) {
+	case HDMI_YCC_QUANTIZATION_RANGE_LIMITED: return "Limited";
+	case HDMI_YCC_QUANTIZATION_RANGE_FULL: return "Full";
+	}
+	return "Invalid/Unknown";
+}
+
+static const char *hdmi_content_type_txt(enum hdmi_content_type content_type)
+{
+	switch (content_type) {
+	case HDMI_CONTENT_TYPE_NONE: return "None";
+	case HDMI_CONTENT_TYPE_PHOTO: return "Photo";
+	case HDMI_CONTENT_TYPE_CINEMA: return "Cinema";
+	case HDMI_CONTENT_TYPE_GAME: return "Game";
+	}
+	return "Invalid/Unknown";
+}
+
+/**
+ * hdmi_avi_infoframe_log() - log info of HDMI AVI infoframe
+ * @dev: device
+ * @frame: HDMI AVI infoframe
+ */
+static void hdmi_avi_infoframe_log(struct device *dev, struct hdmi_avi_infoframe *frame)
+{
+	hdmi_infoframe_log_header(dev, frame);
+
+	dev_info(dev, "    colorspace: %s\n", hdmi_colorspace_txt(frame->colorspace));
+	dev_info(dev, "    scan mode: %s\n", hdmi_scan_mode_txt(frame->scan_mode));
+	dev_info(dev, "    colorimetry: %s\n", hdmi_colorimetry_txt(frame->colorimetry));
+	dev_info(dev, "    picture aspect: %s\n", hdmi_picture_aspect_txt(frame->picture_aspect));
+	dev_info(dev, "    active aspect: %s\n", hdmi_active_aspect_txt(frame->active_aspect));
+	dev_info(dev, "    itc: %s\n", frame->itc ? "It Content" : "No Data");
+	dev_info(dev, "    extended colorimetry: %s\n", hdmi_extended_colorimetry_txt(frame->extended_colorimetry));
+	dev_info(dev, "    quantization range: %s\n", hdmi_quantization_range_txt(frame->quantization_range));
+	dev_info(dev, "    nups: %s\n", hdmi_nups_txt(frame->nups));
+	dev_info(dev, "    video code: %d\n", frame->video_code);
+	dev_info(dev, "    ycc quantization range: %s\n", hdmi_ycc_quantization_range_txt(frame->ycc_quantization_range));
+	dev_info(dev, "    hdmi content type: %s\n",  hdmi_content_type_txt(frame->content_type));
+	dev_info(dev, "    pixel repeat: %d\n", frame->pixel_repeat);
+	dev_info(dev, "    bar top %d, bottom %d, left %d, right %d\n", frame->top_bar, frame->bottom_bar, frame->left_bar, frame->right_bar);
+}
+
+static const char *hdmi_spd_sdi_txt(enum hdmi_spd_sdi sdi)
+{
+	switch (sdi) {
+	case HDMI_SPD_SDI_UNKNOWN: return "Unknown";
+	case HDMI_SPD_SDI_DSTB: return "Digital STB";
+	case HDMI_SPD_SDI_DVDP: return "DVD player";
+	case HDMI_SPD_SDI_DVHS: return "D-VHS";
+	case HDMI_SPD_SDI_HDDVR: return "HDD Videorecorder";
+	case HDMI_SPD_SDI_DVC: return "DVC";
+	case HDMI_SPD_SDI_DSC: return "DSC";
+	case HDMI_SPD_SDI_VCD: return "Video CD";
+	case HDMI_SPD_SDI_GAME: return "Game";
+	case HDMI_SPD_SDI_PC: return "PC general";
+	case HDMI_SPD_SDI_BD: return "Blu-Ray Disc (BD)";
+	case HDMI_SPD_SDI_SACD: return "Super Audio CD";
+	case HDMI_SPD_SDI_HDDVD: return "HD DVD";
+	case HDMI_SPD_SDI_PMP: return "PMP";
+	}
+	return "Reserved";
+}
+
+/**
+ * hdmi_spd_infoframe_log() - log info of HDMI SPD infoframe
+ * @dev: device
+ * @frame: HDMI SPD infoframe
+ */
+static void hdmi_spd_infoframe_log(struct device *dev, struct hdmi_spd_infoframe *frame)
+{
+	u8 buf[17];
+
+	hdmi_infoframe_log_header(dev, frame);
+
+	memset(buf, 0, sizeof(buf));
+
+	strncpy(buf, frame->vendor, 8);
+	dev_info(dev, "    vendor: %s\n", buf);
+	strncpy(buf, frame->product, 16);
+	dev_info(dev, "    product: %s\n", buf);
+	dev_info(dev, "    source device information: %s (0x%x)\n",
+		hdmi_spd_sdi_txt(frame->sdi), frame->sdi);
+}
+
+static const char *hdmi_audio_coding_type_txt(enum hdmi_audio_coding_type coding_type)
+{
+	switch (coding_type) {
+	case HDMI_AUDIO_CODING_TYPE_STREAM: return "Refer to stream header";
+	case HDMI_AUDIO_CODING_TYPE_PCM: return "PCM";
+	case HDMI_AUDIO_CODING_TYPE_AC3: return "AC-3";
+	case HDMI_AUDIO_CODING_TYPE_MPEG1: return "MPEG1";
+	case HDMI_AUDIO_CODING_TYPE_MP3: return "MP3";
+	case HDMI_AUDIO_CODING_TYPE_MPEG2: return "MPEG2";
+	case HDMI_AUDIO_CODING_TYPE_AAC_LC: return "AAC";
+	case HDMI_AUDIO_CODING_TYPE_DTS: return "DTS";
+	case HDMI_AUDIO_CODING_TYPE_ATRAC: return "ATRAC";
+	case HDMI_AUDIO_CODING_TYPE_DSD: return "One Bit Audio";
+	case HDMI_AUDIO_CODING_TYPE_EAC3: return "Dolby Digital +";
+	case HDMI_AUDIO_CODING_TYPE_DTS_HD: return "DTS-HD";
+	case HDMI_AUDIO_CODING_TYPE_MLP: return "MAT (MLP)";
+	case HDMI_AUDIO_CODING_TYPE_DST: return "DST";
+	case HDMI_AUDIO_CODING_TYPE_WMA_PRO: return "WMA PRO";
+	}
+	return "Reserved";
+}
+
+static const char *hdmi_audio_sample_size_txt(enum hdmi_audio_sample_size sample_size)
+{
+	switch (sample_size) {
+	case HDMI_AUDIO_SAMPLE_SIZE_STREAM: return "Refer to stream header";
+	case HDMI_AUDIO_SAMPLE_SIZE_16: return "16 bit";
+	case HDMI_AUDIO_SAMPLE_SIZE_20: return "20 bit";
+	case HDMI_AUDIO_SAMPLE_SIZE_24: return "24 bit";
+	}
+	return "Invalid/Unknown";
+}
+
+static const char *hdmi_audio_sample_frequency_txt(enum hdmi_audio_sample_frequency sample_frequency)
+{
+	switch (sample_frequency) {
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_STREAM: return "Refer to stream header";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_32000: return "32 kHz";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_44100: return "44.1 kHz (CD)";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_48000: return "48 kHz";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_88200: return "88.2 kHz";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_96000: return "96 kHz";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_176400: return "176.4 kHz";
+	case HDMI_AUDIO_SAMPLE_FREQUENCY_192000: return "192 kHz";
+	}
+	return "Invalid/Unknown";
+}
+
+static const char *hdmi_audio_coding_type_ext_txt(enum hdmi_audio_coding_type_ext coding_type_ext)
+{
+	switch (coding_type_ext) {
+	case HDMI_AUDIO_CODING_TYPE_EXT_STREAM: return "Stream";
+	case HDMI_AUDIO_CODING_TYPE_EXT_HE_AAC: return "HE AAC";
+	case HDMI_AUDIO_CODING_TYPE_EXT_HE_AAC_V2: return "HE AAC v2";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG_SURROUND: return "MPEG SURROUND";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC: return "MPEG-4 HE AAC";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC_V2: return "MPEG-4 HE AAC v2";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_AAC_LC: return "MPEG-4 AAC LC";
+	case HDMI_AUDIO_CODING_TYPE_EXT_DRA: return "DRA";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG_HE_AAC_SURROUND: return "MPEG-4 HE AAC + MPEG Surround";
+	case HDMI_AUDIO_CODING_TYPE_EXT_MPEG_AAC_LC_SURROUND: return "MPEG-4 AAC LC + MPEG Surround";
+	}
+	return "Invalid/Unknown";
+}
+
+/**
+ * hdmi_audio_infoframe_log() - log info of HDMI AUDIO infoframe
+ * @dev: device
+ * @frame: HDMI AUDIO infoframe
+ */
+static void hdmi_audio_infoframe_log(struct device *dev, struct hdmi_audio_infoframe *frame)
+{
+	hdmi_infoframe_log_header(dev, frame);
+
+	if (frame->channels)
+		dev_info(dev, "    channels: %d ch\n", frame->channels - 1);
+	else
+		dev_info(dev, "    channels: Refer to stream header\n");
+	dev_info(dev, "    coding type: %s\n", hdmi_audio_coding_type_txt(frame->coding_type));
+	dev_info(dev, "    sample size: %s\n", hdmi_audio_sample_size_txt(frame->sample_size));
+	dev_info(dev, "    sample frequency: %s\n", hdmi_audio_sample_frequency_txt(frame->sample_frequency));
+	dev_info(dev, "    coding type ext: %s\n", hdmi_audio_coding_type_ext_txt(frame->coding_type_ext));
+	dev_info(dev, "    channel allocation: %d\n", frame->channel_allocation);
+	dev_info(dev, "    level shift value: %d db\n", frame->level_shift_value);
+	dev_info(dev, "    downmix inhibit: %s\n", frame->downmix_inhibit ? "Yes" : "No");
+}
+
+static const char *hdmi_3d_structure_txt(enum hdmi_3d_structure s3d_struct)
+{
+	switch (s3d_struct) {
+	case HDMI_3D_STRUCTURE_INVALID: return "Invalid";
+	case HDMI_3D_STRUCTURE_FRAME_PACKING: return "Frame packing";
+	case HDMI_3D_STRUCTURE_FIELD_ALTERNATIVE: return "Field alternative";
+	case HDMI_3D_STRUCTURE_LINE_ALTERNATIVE: return "Line alternative";
+	case HDMI_3D_STRUCTURE_SIDE_BY_SIDE_FULL: return "Side-by-side (Full)";
+	case HDMI_3D_STRUCTURE_L_DEPTH: return "L + depth";
+	case HDMI_3D_STRUCTURE_L_DEPTH_GFX_GFX_DEPTH: return "L + depth + graphics + graphics-depth";
+	case HDMI_3D_STRUCTURE_TOP_AND_BOTTOM: return "Top-and-Bottom";
+	case HDMI_3D_STRUCTURE_SIDE_BY_SIDE_HALF: return "Side-by-side (Half)";
+	}
+	return "Invalid/Unknown";
+}
+
+/**
+ * hdmi_vendor_infoframe_log() - log info of HDMI VENDOR infoframe
+ * @dev: device
+ * @frame: HDMI VENDOR infoframe
+ */
+static void hdmi_vendor_any_infoframe_log(struct device *dev, union hdmi_vendor_any_infoframe *frame)
+{
+	struct hdmi_vendor_infoframe *hvf = &frame->hdmi;
+
+	hdmi_infoframe_log_header(dev, frame);
+
+	if (frame->any.oui != HDMI_IEEE_OUI) {
+		dev_info(dev, "    not a HDMI vendor infoframe\n");
+		return;
+	}
+	if (hvf->vic == 0 && hvf->s3d_struct == HDMI_3D_STRUCTURE_INVALID) {
+		dev_info(dev, "    empty frame\n");
+		return;
+	}
+
+	if (hvf->vic) {
+		dev_info(dev, "    Hdmi Vic: %d\n", hvf->vic);
+	}
+	if (hvf->s3d_struct != HDMI_3D_STRUCTURE_INVALID) {
+		dev_info(dev, "    3D structure: %s\n", hdmi_3d_structure_txt(hvf->s3d_struct));
+		if (hvf->s3d_struct >= HDMI_3D_STRUCTURE_SIDE_BY_SIDE_HALF)
+			dev_info(dev, "    3D extension data: %d\n", hvf->s3d_ext_data);
+	}
+}
+
+/**
+ * hdmi_infoframe_log() - log info of HDMI infoframe
+ * @dev: device
+ * @frame: HDMI infoframe
+ */
+void hdmi_infoframe_log(struct device *dev, union hdmi_infoframe *frame)
+{
+	switch (frame->any.type) {
+	case HDMI_INFOFRAME_TYPE_AVI:
+		hdmi_avi_infoframe_log(dev, &frame->avi);
+		break;
+	case HDMI_INFOFRAME_TYPE_SPD:
+		hdmi_spd_infoframe_log(dev, &frame->spd);
+		break;
+	case HDMI_INFOFRAME_TYPE_AUDIO:
+		hdmi_audio_infoframe_log(dev, &frame->audio);
+		break;
+	case HDMI_INFOFRAME_TYPE_VENDOR:
+		hdmi_vendor_any_infoframe_log(dev, &frame->vendor);
+		break;
+	default:
+		WARN(1, "Bad infoframe type %d\n", frame->any.type);
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
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4 specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int hdmi_avi_infoframe_unpack(void *buffer, struct hdmi_avi_infoframe *frame)
+{
+	u8 *ptr = buffer;
+	int ret;
+
+	if (ptr[0] != HDMI_INFOFRAME_TYPE_AVI ||
+	    ptr[1] != 2 ||
+	    ptr[2] != HDMI_AVI_INFOFRAME_SIZE) {
+		return -EINVAL;
+	}
+
+	if (hdmi_infoframe_calc_checksum(buffer, HDMI_INFOFRAME_SIZE(AVI)) != 0)
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
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4 specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int hdmi_spd_infoframe_unpack(void *buffer, struct hdmi_spd_infoframe *frame)
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
+	if (hdmi_infoframe_calc_checksum(buffer, HDMI_INFOFRAME_SIZE(SPD)) != 0)
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
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4 specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int hdmi_audio_infoframe_unpack(void *buffer, struct hdmi_audio_infoframe *frame)
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
+	if (hdmi_infoframe_calc_checksum(buffer, HDMI_INFOFRAME_SIZE(AUDIO)) != 0)
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
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4 specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int hdmi_vendor_any_infoframe_unpack(void *buffer, union hdmi_vendor_any_infoframe *frame)
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
+	if (hdmi_infoframe_calc_checksum(buffer, HDMI_INFOFRAME_HEADER_SIZE + length) != 0)
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
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4 specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int hdmi_infoframe_unpack(void *buffer, union hdmi_infoframe *frame)
+{
+	int ret;
+	u8 *ptr = buffer;
+
+	switch (ptr[0]) {
+	case HDMI_INFOFRAME_TYPE_AVI:
+		ret = hdmi_avi_infoframe_unpack(buffer, &frame->avi);
+		break;
+	case HDMI_INFOFRAME_TYPE_SPD:
+		ret = hdmi_spd_infoframe_unpack(buffer, &frame->spd);
+		break;
+	case HDMI_INFOFRAME_TYPE_AUDIO:
+		ret = hdmi_audio_infoframe_unpack(buffer, &frame->audio);
+		break;
+	case HDMI_INFOFRAME_TYPE_VENDOR:
+		ret = hdmi_vendor_any_infoframe_unpack(buffer, &frame->vendor);
+		break;
+	default:
+		WARN(1, "Bad infoframe type %d\n", ptr[0]);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(hdmi_infoframe_unpack);
diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index 38fd2a0..e6adae4 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -10,6 +10,7 @@
 #define __LINUX_HDMI_H_
 
 #include <linux/types.h>
+#include <linux/device.h>
 
 enum hdmi_infoframe_type {
 	HDMI_INFOFRAME_TYPE_VENDOR = 0x81,
@@ -304,5 +305,7 @@ union hdmi_infoframe {
 
 ssize_t
 hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer, size_t size);
+int hdmi_infoframe_unpack(void *buffer, union hdmi_infoframe *frame);
+void hdmi_infoframe_log(struct device *dev, union hdmi_infoframe *frame);
 
 #endif /* _DRM_HDMI_H */
-- 
2.1.3

