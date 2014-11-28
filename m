Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38495 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678AbaK1OvG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 09:51:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
	marbugge@cisco.com, dri-devel@lists.freedesktop.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] hdmi: add new HDMI 2.0 defines
Date: Fri, 28 Nov 2014 15:50:49 +0100
Message-Id: <1417186251-6542-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417186251-6542-1-git-send-email-hverkuil@xs4all.nl>
References: <1417186251-6542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add new Video InfoFrame colorspace information introduced in HDMI 2.0
and new Audio Coding Extension Types, also from HDMI 2.0.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/linux/hdmi.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index 11c0182..38fd2a0 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -37,6 +37,8 @@ enum hdmi_colorspace {
 	HDMI_COLORSPACE_RGB,
 	HDMI_COLORSPACE_YUV422,
 	HDMI_COLORSPACE_YUV444,
+	HDMI_COLORSPACE_YUV420,
+	HDMI_COLORSPACE_IDO_DEFINED = 7,
 };
 
 enum hdmi_scan_mode {
@@ -77,6 +79,10 @@ enum hdmi_extended_colorimetry {
 	HDMI_EXTENDED_COLORIMETRY_S_YCC_601,
 	HDMI_EXTENDED_COLORIMETRY_ADOBE_YCC_601,
 	HDMI_EXTENDED_COLORIMETRY_ADOBE_RGB,
+
+	/* The following EC values are only defined in CEA-861-F. */
+	HDMI_EXTENDED_COLORIMETRY_BT2020_CONST_LUM,
+	HDMI_EXTENDED_COLORIMETRY_BT2020,
 };
 
 enum hdmi_quantization_range {
@@ -201,9 +207,23 @@ enum hdmi_audio_sample_frequency {
 
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
+	HDMI_AUDIO_CODING_TYPE_EXT_MPEG_HE_AAC_SURROUND,
+	HDMI_AUDIO_CODING_TYPE_EXT_MPEG_AAC_LC_SURROUND = 10,
 };
 
 struct hdmi_audio_infoframe {
-- 
2.1.3

