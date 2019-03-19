Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B10C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9021D2085A
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfCSV6E (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:58:04 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:41921 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfCSV6B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:58:01 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 86C67100005;
        Tue, 19 Mar 2019 21:57:57 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [RFC PATCH 11/20] drm/i915: Convert to generic image format library
Date:   Tue, 19 Mar 2019 22:57:16 +0100
Message-Id: <37ad4786835372353c4479065e0f17f95e2d6953.1553032382.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Now that we have a generic image format libary, let's convert drivers to
use it so that we can deprecate the old DRM one.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/i915/intel_display.c | 4 ++--
 drivers/gpu/drm/i915/intel_sprite.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 86febe2ee510..37c7f6bbf650 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7997,7 +7997,7 @@ i9xx_get_initial_plane_config(struct intel_crtc *crtc,
 
 	pixel_format = val & DISPPLANE_PIXFORMAT_MASK;
 	fourcc = i9xx_format_to_fourcc(pixel_format);
-	fb->format = drm_format_info(fourcc);
+	fb->format = image_format_drm_lookup(fourcc);
 
 	if (IS_HASWELL(dev_priv) || IS_BROADWELL(dev_priv)) {
 		offset = I915_READ(DSPOFFSET(i9xx_plane));
@@ -9078,7 +9078,7 @@ skylake_get_initial_plane_config(struct intel_crtc *crtc,
 
 	fourcc = skl_format_to_fourcc(pixel_format,
 				      val & PLANE_CTL_ORDER_RGBX, alpha);
-	fb->format = drm_format_info(fourcc);
+	fb->format = image_format_drm_lookup(fourcc);
 
 	tiling = val & PLANE_CTL_TILED_MASK;
 	switch (tiling) {
diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index ee0e99b13532..aaae2bd4ed05 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -297,8 +297,8 @@ skl_plane_max_stride(struct intel_plane *plane,
 		     u32 pixel_format, u64 modifier,
 		     unsigned int rotation)
 {
-	const struct drm_format_info *info = drm_format_info(pixel_format);
-	int cpp = drm_format_plane_cpp(info, 0);
+	const struct image_format_info *info = image_format_drm_lookup(pixel_format);
+	int cpp = image_format_plane_cpp(info, 0);
 
 	/*
 	 * "The stride in bytes must not exceed the
-- 
git-series 0.9.1
