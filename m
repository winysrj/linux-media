Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:53183 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726886AbeIMQ4p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 12:56:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hansverk@cisco.com>,
        amd-gfx@lists.freedesktop.org
Subject: [PATCH 5/5] drm/amd: rename ADOBE to OP
Date: Thu, 13 Sep 2018 13:47:31 +0200
Message-Id: <20180913114731.16500-6-hverkuil@xs4all.nl>
In-Reply-To: <20180913114731.16500-1-hverkuil@xs4all.nl>
References: <20180913114731.16500-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The CTA-861 standard renamed ADOBE to OP, so do the same to remain
in sync with the standard.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Cc: amd-gfx@lists.freedesktop.org
---
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c       | 4 ++--
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c           | 4 ++--
 drivers/gpu/drm/amd/display/dc/dc_hw_types.h                | 2 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c     | 2 +-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c   | 2 +-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c | 2 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/transform.h           | 4 ++--
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index 83d121510ef5..c7709711d3c3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -99,7 +99,7 @@ static bool is_rgb_type(
 		color_space == COLOR_SPACE_XR_RGB		||
 		color_space == COLOR_SPACE_MSREF_SCRGB		||
 		color_space == COLOR_SPACE_2020_RGB_FULLRANGE	||
-		color_space == COLOR_SPACE_ADOBERGB		||
+		color_space == COLOR_SPACE_OPRGB		||
 		color_space == COLOR_SPACE_DCIP3	||
 		color_space == COLOR_SPACE_DOLBYVISION)
 		ret = true;
@@ -230,7 +230,7 @@ void color_space_to_black_color(
 	case COLOR_SPACE_XV_YCC_601:
 	case COLOR_SPACE_2020_RGB_FULLRANGE:
 	case COLOR_SPACE_2020_RGB_LIMITEDRANGE:
-	case COLOR_SPACE_ADOBERGB:
+	case COLOR_SPACE_OPRGB:
 	case COLOR_SPACE_DCIP3:
 	case COLOR_SPACE_DISPLAYNATIVE:
 	case COLOR_SPACE_DOLBYVISION:
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index ea6beccfd89d..2e454e905ee2 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2151,8 +2151,8 @@ static void set_avi_info_frame(
 			color_space == COLOR_SPACE_2020_YCBCR) {
 		hdmi_info.bits.EC0_EC2 = COLORIMETRYEX_BT2020RGBYCBCR;
 		hdmi_info.bits.C0_C1   = COLORIMETRY_EXTENDED;
-	} else if (color_space == COLOR_SPACE_ADOBERGB) {
-		hdmi_info.bits.EC0_EC2 = COLORIMETRYEX_ADOBERGB;
+	} else if (color_space == COLOR_SPACE_OPRGB) {
+		hdmi_info.bits.EC0_EC2 = COLORIMETRYEX_OPRGB;
 		hdmi_info.bits.C0_C1   = COLORIMETRY_EXTENDED;
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
index b789cb2b354b..ddaaf17a3bc6 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
@@ -524,7 +524,7 @@ enum dc_color_space {
 	COLOR_SPACE_2020_RGB_FULLRANGE,
 	COLOR_SPACE_2020_RGB_LIMITEDRANGE,
 	COLOR_SPACE_2020_YCBCR,
-	COLOR_SPACE_ADOBERGB,
+	COLOR_SPACE_OPRGB,
 	COLOR_SPACE_DCIP3,
 	COLOR_SPACE_DISPLAYNATIVE,
 	COLOR_SPACE_DOLBYVISION,
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c
index 91642e684858..d37d7a20ef54 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c
@@ -423,7 +423,7 @@ static void dce110_stream_encoder_dp_set_stream_attribute(
 		case COLOR_SPACE_2020_YCBCR:
 		case COLOR_SPACE_XR_RGB:
 		case COLOR_SPACE_MSREF_SCRGB:
-		case COLOR_SPACE_ADOBERGB:
+		case COLOR_SPACE_OPRGB:
 		case COLOR_SPACE_DCIP3:
 		case COLOR_SPACE_XV_YCC_709:
 		case COLOR_SPACE_XV_YCC_601:
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index cfcc54f2ce65..99282c6c91c3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1729,7 +1729,7 @@ bool is_rgb_cspace(enum dc_color_space output_color_space)
 	case COLOR_SPACE_SRGB_LIMITED:
 	case COLOR_SPACE_2020_RGB_FULLRANGE:
 	case COLOR_SPACE_2020_RGB_LIMITEDRANGE:
-	case COLOR_SPACE_ADOBERGB:
+	case COLOR_SPACE_OPRGB:
 		return true;
 	case COLOR_SPACE_YCBCR601:
 	case COLOR_SPACE_YCBCR709:
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
index 6f9078f3c4d3..17e5d287aca7 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
@@ -394,7 +394,7 @@ void enc1_stream_encoder_dp_set_stream_attribute(
 	case COLOR_SPACE_2020_YCBCR:
 	case COLOR_SPACE_XR_RGB:
 	case COLOR_SPACE_MSREF_SCRGB:
-	case COLOR_SPACE_ADOBERGB:
+	case COLOR_SPACE_OPRGB:
 	case COLOR_SPACE_DCIP3:
 	case COLOR_SPACE_XV_YCC_709:
 	case COLOR_SPACE_XV_YCC_601:
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/transform.h b/drivers/gpu/drm/amd/display/dc/inc/hw/transform.h
index fecc80c47c26..9a0f8d161592 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/transform.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/transform.h
@@ -54,8 +54,8 @@ enum colorimetry_ext {
 	COLORIMETRYEX_XVYCC601 = 0,
 	COLORIMETRYEX_XVYCC709 = 1,
 	COLORIMETRYEX_SYCC601 = 2,
-	COLORIMETRYEX_ADOBEYCC601 = 3,
-	COLORIMETRYEX_ADOBERGB = 4,
+	COLORIMETRYEX_OPYCC601 = 3,
+	COLORIMETRYEX_OPRGB = 4,
 	COLORIMETRYEX_BT2020YCC = 5,
 	COLORIMETRYEX_BT2020RGBYCBCR = 6,
 	COLORIMETRYEX_RESERVED = 7
-- 
2.18.0
