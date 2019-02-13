Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EF9C282CE
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 13:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67D10222B5
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 13:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389520AbfBMN30 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 08:29:26 -0500
Received: from mga07.intel.com ([134.134.136.100]:2839 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbfBMN3Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 08:29:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2019 05:29:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,365,1544515200"; 
   d="scan'208";a="318662154"
Received: from genxfsim-shark-bay-client-platform.iind.intel.com ([10.223.25.3])
  by fmsmga006.fm.intel.com with ESMTP; 13 Feb 2019 05:29:21 -0800
From:   Swati Sharma <swati2.sharma@intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        narmstrong@baylibre.com, clinton.a.taylor@intel.com,
        ayaka@soulik.info, ayan.halder@arm.com, maxime.ripard@bootlin.com,
        daniel@fooishbar.org, juhapekka.heikkila@gmail.com,
        maarten.lankhorst@linux.intel.com, stanislav.lisovskiy@intel.com,
        daniel.vetter@ffwll.ch, ville.syrjala@linux.intel.com,
        Swati Sharma <swati2.sharma@intel.com>
Subject: [PATCH 3/6] drm/i915: Enable P010, P012, P016 formats for primary and sprite planes
Date:   Wed, 13 Feb 2019 18:55:30 +0530
Message-Id: <1550064333-6168-4-git-send-email-swati2.sharma@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550064333-6168-1-git-send-email-swati2.sharma@intel.com>
References: <1550064333-6168-1-git-send-email-swati2.sharma@intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>

Enabling of P010, P012 and P016 formats. These formats will
extend NV12 for larger bit depths.

Signed-off-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_sprite.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index 1be7d59..0db3c5d 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -1832,6 +1832,25 @@ int intel_sprite_set_colorkey_ioctl(struct drm_device *dev, void *data,
 	DRM_FORMAT_NV12,
 };
 
+static const uint32_t glk_planar_formats[] = {
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
+};
+
 static const u64 skl_plane_format_modifiers_noccs[] = {
 	I915_FORMAT_MOD_Yf_TILED,
 	I915_FORMAT_MOD_Y_TILED,
@@ -2114,8 +2133,13 @@ struct intel_plane *
 		plane->update_slave = icl_update_slave;
 
 	if (skl_plane_has_planar(dev_priv, pipe, plane_id)) {
-		formats = skl_planar_formats;
-		num_formats = ARRAY_SIZE(skl_planar_formats);
+		if (INTEL_GEN(dev_priv) >= 10 || IS_GEMINILAKE(dev_priv)) {
+			formats = glk_planar_formats;
+			num_formats = ARRAY_SIZE(glk_planar_formats);
+		} else {
+			formats = skl_planar_formats;
+			num_formats = ARRAY_SIZE(skl_planar_formats);
+		}
 	} else {
 		formats = skl_plane_formats;
 		num_formats = ARRAY_SIZE(skl_plane_formats);
-- 
1.9.1

