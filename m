Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41294 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbaLSMOi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 07:14:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, marbugge@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 1/4] hdmi: add new HDMI 2.0 defines
Date: Fri, 19 Dec 2014 13:14:20 +0100
Message-Id: <1418991263-17934-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418991263-17934-1-git-send-email-hverkuil@xs4all.nl>
References: <1418991263-17934-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add new Video InfoFrame colorspace information introduced in HDMI 2.0
and new Audio Coding Extension Types, also from HDMI 2.0.

HDMI_CONTENT_TYPE_NONE was renamed to _GRAPHICS since that's what
it is called in CEA-861-F.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/hdmi.h | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index 11c0182..a4aa0c2 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -37,12 +37,18 @@ enum hdmi_colorspace {
 	HDMI_COLORSPACE_RGB,
 	HDMI_COLORSPACE_YUV422,
 	HDMI_COLORSPACE_YUV444,
+	HDMI_COLORSPACE_YUV420,
+	HDMI_COLORSPACE_RESERVED4,
+	HDMI_COLORSPACE_RESERVED5,
+	HDMI_COLORSPACE_RESERVED6,
+	HDMI_COLORSPACE_IDO_DEFINED,
 };
 
 enum hdmi_scan_mode {
 	HDMI_SCAN_MODE_NONE,
 	HDMI_SCAN_MODE_OVERSCAN,
 	HDMI_SCAN_MODE_UNDERSCAN,
+	HDMI_SCAN_MODE_RESERVED,
 };
 
 enum hdmi_colorimetry {
@@ -56,6 +62,7 @@ enum hdmi_picture_aspect {
 	HDMI_PICTURE_ASPECT_NONE,
 	HDMI_PICTURE_ASPECT_4_3,
 	HDMI_PICTURE_ASPECT_16_9,
+	HDMI_PICTURE_ASPECT_RESERVED,
 };
 
 enum hdmi_active_aspect {
@@ -77,12 +84,18 @@ enum hdmi_extended_colorimetry {
 	HDMI_EXTENDED_COLORIMETRY_S_YCC_601,
 	HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601,
 	HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB,
+
+	/* The following EC values are only defined in CEA-861-F. */
+	HDMI_EXTENDED_COLORIMETRY_BT2020_CONST_LUM,
+	HDMI_EXTENDED_COLORIMETRY_BT2020,
+	HDMI_EXTENDED_COLORIMETRY_RESERVED,
 };
 
 enum hdmi_quantization_range {
 	HDMI_QUANTIZATION_RANGE_DEFAULT,
 	HDMI_QUANTIZATION_RANGE_LIMITED,
 	HDMI_QUANTIZATION_RANGE_FULL,
+	HDMI_QUANTIZATION_RANGE_RESERVED,
 };
 
 /* non-uniform picture scaling */
@@ -99,7 +112,7 @@ enum hdmi_ycc_quantization_range {
 };
 
 enum hdmi_content_type {
-	HDMI_CONTENT_TYPE_NONE,
+	HDMI_CONTENT_TYPE_GRAPHICS,
 	HDMI_CONTENT_TYPE_PHOTO,
 	HDMI_CONTENT_TYPE_CINEMA,
 	HDMI_CONTENT_TYPE_GAME,
@@ -179,6 +192,7 @@ enum hdmi_audio_coding_type {
 	HDMI_AUDIO_CODING_TYPE_MLP,
 	HDMI_AUDIO_CODING_TYPE_DST,
 	HDMI_AUDIO_CODING_TYPE_WMA_PRO,
+	HDMI_AUDIO_CODING_TYPE_CXT,
 };
 
 enum hdmi_audio_sample_size {
@@ -201,9 +215,23 @@ enum hdmi_audio_sample_frequency {
 
 enum hdmi_audio_coding_type_ext {
 	HDMI_AUDIO_CODING_TYPE_EXT_STREAM,
+
+	/*
+	 * The next three CXT values are defined in CEA-861-E only.
+	 * They do not exist in older versions, and in CEA-861-F they are
+	 * defined as 'Not in use'.
+	 */
 	HDMI_AUDIO_CODING_TYPE_EXT_HE_AAC,
 	HDMI_AUDIO_CODING_TYPE_EXT_HE_AAC_V2,
 	HDMI_AUDIO_CODING_TYPE_EXT_MPEG_SURROUND,
+
+	/* The following CXT values are only defined in CEA-861-F. */
+	HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC,
+	HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC_V2,
+	HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_AAC_LC,
+	HDMI_AUDIO_CODING_TYPE_EXT_DRA,
+	HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_HE_AAC_SURROUND,
+	HDMI_AUDIO_CODING_TYPE_EXT_MPEG4_AAC_LC_SURROUND = 10,
 };
 
 struct hdmi_audio_infoframe {
-- 
2.1.3

