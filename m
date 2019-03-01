Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2088EC10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA3912186A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbfCAIUK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 03:20:10 -0500
Received: from mga05.intel.com ([192.55.52.43]:32905 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727755AbfCAIUK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 03:20:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Mar 2019 00:20:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,426,1544515200"; 
   d="scan'208";a="130340031"
Received: from genxfsim-shark-bay-client-platform.iind.intel.com ([10.223.25.3])
  by orsmga003.jf.intel.com with ESMTP; 01 Mar 2019 00:20:05 -0800
From:   swati2.sharma@intel.com
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        narmstrong@baylibre.com, clinton.a.taylor@intel.com,
        ayaka@soulik.info, ayan.halder@arm.com, maxime.ripard@bootlin.com,
        daniel@fooishbar.org, juhapekka.heikkila@gmail.com,
        maarten.lankhorst@linux.intel.com, stanislav.lisovskiy@intel.com,
        daniel.vetter@ffwll.ch, ville.syrjala@linux.intel.com,
        Swati Sharma <swati2.sharma@intel.com>,
        Vidya Srinivas <vidya.srinivas@intel.com>
Subject: [PATCH 6/6] drm/i915/icl: Enabling Y2xx and Y4xx (xx:10/12/16) formats for universal planes
Date:   Fri,  1 Mar 2019 13:46:27 +0530
Message-Id: <1551428187-12535-7-git-send-email-swati2.sharma@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551428187-12535-1-git-send-email-swati2.sharma@intel.com>
References: <1551428187-12535-1-git-send-email-swati2.sharma@intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Swati Sharma <swati2.sharma@intel.com>

Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
Signed-off-by: Vidya Srinivas <vidya.srinivas@intel.com>
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_display.c | 30 ++++++++++++++++++
 drivers/gpu/drm/i915/intel_sprite.c  | 60 +++++++++++++++++++++++++++++++++++-
 2 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 61ad775..6825267 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2687,6 +2687,18 @@ int skl_format_to_fourcc(int format, bool rgb_order, bool alpha)
 		return DRM_FORMAT_P012;
 	case PLANE_CTL_FORMAT_P016:
 		return DRM_FORMAT_P016;
+	case PLANE_CTL_FORMAT_Y210:
+		return DRM_FORMAT_Y210;
+	case PLANE_CTL_FORMAT_Y212:
+		return DRM_FORMAT_Y212;
+	case PLANE_CTL_FORMAT_Y216:
+		return DRM_FORMAT_Y216;
+	case PLANE_CTL_FORMAT_Y410:
+		return DRM_FORMAT_Y410;
+	case PLANE_CTL_FORMAT_Y412:
+		return DRM_FORMAT_Y412;
+	case PLANE_CTL_FORMAT_Y416:
+		return DRM_FORMAT_Y416;
 	default:
 	case PLANE_CTL_FORMAT_XRGB_8888:
 		if (rgb_order) {
@@ -3616,6 +3628,18 @@ static u32 skl_plane_ctl_format(u32 pixel_format)
 		return PLANE_CTL_FORMAT_P012;
 	case DRM_FORMAT_P016:
 		return PLANE_CTL_FORMAT_P016;
+	case DRM_FORMAT_Y210:
+		return PLANE_CTL_FORMAT_Y210;
+	case DRM_FORMAT_Y212:
+		return PLANE_CTL_FORMAT_Y212;
+	case DRM_FORMAT_Y216:
+		return PLANE_CTL_FORMAT_Y216;
+	case DRM_FORMAT_Y410:
+		return PLANE_CTL_FORMAT_Y410;
+	case DRM_FORMAT_Y412:
+		return PLANE_CTL_FORMAT_Y412;
+	case DRM_FORMAT_Y416:
+		return PLANE_CTL_FORMAT_Y416;
 	default:
 		MISSING_CASE(pixel_format);
 	}
@@ -5155,6 +5179,12 @@ static int skl_update_scaler_plane(struct intel_crtc_state *crtc_state,
 	case DRM_FORMAT_P010:
 	case DRM_FORMAT_P012:
 	case DRM_FORMAT_P016:
+	case DRM_FORMAT_Y210:
+	case DRM_FORMAT_Y212:
+	case DRM_FORMAT_Y216:
+	case DRM_FORMAT_Y410:
+	case DRM_FORMAT_Y412:
+	case DRM_FORMAT_Y416:
 		break;
 	default:
 		DRM_DEBUG_KMS("[PLANE:%d:%s] FB:%d unsupported scaling format 0x%x\n",
diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index 0db3c5d..89d7bf7 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -1816,6 +1816,27 @@ int intel_sprite_set_colorkey_ioctl(struct drm_device *dev, void *data,
 	DRM_FORMAT_VYUY,
 };
 
+static const uint32_t icl_plane_formats[] = {
+	DRM_FORMAT_C8,
+	DRM_FORMAT_RGB565,
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_XBGR8888,
+	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_ABGR8888,
+	DRM_FORMAT_XRGB2101010,
+	DRM_FORMAT_XBGR2101010,
+	DRM_FORMAT_YUYV,
+	DRM_FORMAT_YVYU,
+	DRM_FORMAT_UYVY,
+	DRM_FORMAT_VYUY,
+	DRM_FORMAT_Y210,
+	DRM_FORMAT_Y212,
+	DRM_FORMAT_Y216,
+	DRM_FORMAT_Y410,
+	DRM_FORMAT_Y412,
+	DRM_FORMAT_Y416,
+};
+
 static const u32 skl_planar_formats[] = {
 	DRM_FORMAT_C8,
 	DRM_FORMAT_RGB565,
@@ -1851,6 +1872,31 @@ int intel_sprite_set_colorkey_ioctl(struct drm_device *dev, void *data,
 	DRM_FORMAT_P016,
 };
 
+static const uint32_t icl_planar_formats[] = {
+	DRM_FORMAT_C8,
+	DRM_FORMAT_RGB565,
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_XBGR8888,
+	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_ABGR8888,
+	DRM_FORMAT_XRGB2101010,
+	DRM_FORMAT_XBGR2101010,
+	DRM_FORMAT_YUYV,
+	DRM_FORMAT_YVYU,
+	DRM_FORMAT_UYVY,
+	DRM_FORMAT_VYUY,
+	DRM_FORMAT_NV12,
+	DRM_FORMAT_P010,
+	DRM_FORMAT_P012,
+	DRM_FORMAT_P016,
+	DRM_FORMAT_Y210,
+	DRM_FORMAT_Y212,
+	DRM_FORMAT_Y216,
+	DRM_FORMAT_Y410,
+	DRM_FORMAT_Y412,
+	DRM_FORMAT_Y416,
+};
+
 static const u64 skl_plane_format_modifiers_noccs[] = {
 	I915_FORMAT_MOD_Yf_TILED,
 	I915_FORMAT_MOD_Y_TILED,
@@ -1993,6 +2039,12 @@ static bool skl_plane_format_mod_supported(struct drm_plane *_plane,
 	case DRM_FORMAT_P010:
 	case DRM_FORMAT_P012:
 	case DRM_FORMAT_P016:
+	case DRM_FORMAT_Y210:
+	case DRM_FORMAT_Y212:
+	case DRM_FORMAT_Y216:
+	case DRM_FORMAT_Y410:
+	case DRM_FORMAT_Y412:
+	case DRM_FORMAT_Y416:
 		if (modifier == I915_FORMAT_MOD_Yf_TILED)
 			return true;
 		/* fall through */
@@ -2133,13 +2185,19 @@ struct intel_plane *
 		plane->update_slave = icl_update_slave;
 
 	if (skl_plane_has_planar(dev_priv, pipe, plane_id)) {
-		if (INTEL_GEN(dev_priv) >= 10 || IS_GEMINILAKE(dev_priv)) {
+		if (INTEL_GEN(dev_priv) >= 11) {
+			formats = icl_planar_formats;
+			num_formats = ARRAY_SIZE(icl_planar_formats);
+		} else if (INTEL_GEN(dev_priv) == 10 || IS_GEMINILAKE(dev_priv)) {
 			formats = glk_planar_formats;
 			num_formats = ARRAY_SIZE(glk_planar_formats);
 		} else {
 			formats = skl_planar_formats;
 			num_formats = ARRAY_SIZE(skl_planar_formats);
 		}
+	} else if (INTEL_GEN(dev_priv) >= 11) {
+		formats = icl_plane_formats;
+		num_formats = ARRAY_SIZE(icl_plane_formats);
 	} else {
 		formats = skl_plane_formats;
 		num_formats = ARRAY_SIZE(skl_plane_formats);
-- 
1.9.1

