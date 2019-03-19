Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E989CC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0B4D217F9
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfCSV6T (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:58:19 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:57357 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfCSV6T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:58:19 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 1680720002;
        Tue, 19 Mar 2019 21:58:12 +0000 (UTC)
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
Subject: [RFC PATCH 17/20] drm/fourcc: Remove old DRM format API
Date:   Tue, 19 Mar 2019 22:57:22 +0100
Message-Id: <4ac66a937d2bc87984660ebe88a556369d00fae3.1553032382.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Now that all the clients of the old drm_format* API have been converted to
the generic one, let's remove it.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/Kconfig                             |   1 +-
 drivers/gpu/drm/drm_fourcc.c                        | 253 +------------
 drivers/gpu/drm/selftests/Makefile                  |   3 +-
 drivers/gpu/drm/selftests/drm_modeset_selftests.h   |   3 +-
 drivers/gpu/drm/selftests/test-drm_format.c         | 280 +-------------
 drivers/gpu/drm/selftests/test-drm_modeset_common.h |   3 +-
 include/drm/drm_fourcc.h                            | 216 +----------
 7 files changed, 2 insertions(+), 757 deletions(-)
 delete mode 100644 drivers/gpu/drm/selftests/test-drm_format.c

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 7992a95ea965..cfc50fc92497 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -54,6 +54,7 @@ config DRM_DEBUG_SELFTEST
 	tristate "kselftests for DRM"
 	depends on DRM
 	depends on DEBUG_KERNEL
+	select IMAGE_FORMATS_SELFTESTS
 	select PRIME_NUMBERS
 	select DRM_LIB_RANDOM
 	select DRM_KMS_HELPER
diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index 6ddb1c28be49..4f262e1a202a 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -150,136 +150,6 @@ const char *drm_get_format_name(uint32_t format, struct drm_format_name_buf *buf
 }
 EXPORT_SYMBOL(drm_get_format_name);
 
-/*
- * Internal function to query information for a given format. See
- * drm_format_info() for the public API.
- */
-const struct drm_format_info *__drm_format_info(u32 format)
-{
-	static const struct drm_format_info formats[] = {
-		{ .format = DRM_FORMAT_C8,		.depth = 8,  .num_planes = 1, .cpp = { 1, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_RGB332,		.depth = 8,  .num_planes = 1, .cpp = { 1, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_BGR233,		.depth = 8,  .num_planes = 1, .cpp = { 1, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_XRGB4444,	.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_XBGR4444,	.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_RGBX4444,	.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_BGRX4444,	.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_ARGB4444,	.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_ABGR4444,	.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_RGBA4444,	.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_BGRA4444,	.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_XRGB1555,	.depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_XBGR1555,	.depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_RGBX5551,	.depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_BGRX5551,	.depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_ARGB1555,	.depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_ABGR1555,	.depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_RGBA5551,	.depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_BGRA5551,	.depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_RGB565,		.depth = 16, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_BGR565,		.depth = 16, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_RGB888,		.depth = 24, .num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_BGR888,		.depth = 24, .num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_XRGB8888,	.depth = 24, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_XBGR8888,	.depth = 24, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_RGBX8888,	.depth = 24, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_BGRX8888,	.depth = 24, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_RGB565_A8,	.depth = 24, .num_planes = 2, .cpp = { 2, 1, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_BGR565_A8,	.depth = 24, .num_planes = 2, .cpp = { 2, 1, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_XRGB2101010,	.depth = 30, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_XBGR2101010,	.depth = 30, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_RGBX1010102,	.depth = 30, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_BGRX1010102,	.depth = 30, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
-		{ .format = DRM_FORMAT_ARGB2101010,	.depth = 30, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_ABGR2101010,	.depth = 30, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_RGBA1010102,	.depth = 30, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_BGRA1010102,	.depth = 30, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_ARGB8888,	.depth = 32, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_ABGR8888,	.depth = 32, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_RGBA8888,	.depth = 32, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_BGRA8888,	.depth = 32, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_RGB888_A8,	.depth = 32, .num_planes = 2, .cpp = { 3, 1, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_BGR888_A8,	.depth = 32, .num_planes = 2, .cpp = { 3, 1, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_XRGB8888_A8,	.depth = 32, .num_planes = 2, .cpp = { 4, 1, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_XBGR8888_A8,	.depth = 32, .num_planes = 2, .cpp = { 4, 1, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_RGBX8888_A8,	.depth = 32, .num_planes = 2, .cpp = { 4, 1, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_BGRX8888_A8,	.depth = 32, .num_planes = 2, .cpp = { 4, 1, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
-		{ .format = DRM_FORMAT_YUV410,		.depth = 0,  .num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 4, .vsub = 4, .is_yuv = true },
-		{ .format = DRM_FORMAT_YVU410,		.depth = 0,  .num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 4, .vsub = 4, .is_yuv = true },
-		{ .format = DRM_FORMAT_YUV411,		.depth = 0,  .num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 4, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_YVU411,		.depth = 0,  .num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 4, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_YUV420,		.depth = 0,  .num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2, .is_yuv = true },
-		{ .format = DRM_FORMAT_YVU420,		.depth = 0,  .num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2, .is_yuv = true },
-		{ .format = DRM_FORMAT_YUV422,		.depth = 0,  .num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_YVU422,		.depth = 0,  .num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_YUV444,		.depth = 0,  .num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 1, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_YVU444,		.depth = 0,  .num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 1, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_NV12,		.depth = 0,  .num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2, .is_yuv = true },
-		{ .format = DRM_FORMAT_NV21,		.depth = 0,  .num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2, .is_yuv = true },
-		{ .format = DRM_FORMAT_NV16,		.depth = 0,  .num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_NV61,		.depth = 0,  .num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_NV24,		.depth = 0,  .num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 1, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_NV42,		.depth = 0,  .num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 1, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_YUYV,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_YVYU,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_UYVY,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_VYUY,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_XYUV8888,	.depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .is_yuv = true },
-		{ .format = DRM_FORMAT_AYUV,		.depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true, .is_yuv = true },
-		{ .format = DRM_FORMAT_Y0L0,		.depth = 0,  .num_planes = 1,
-		  .char_per_block = { 8, 0, 0 }, .block_w = { 2, 0, 0 }, .block_h = { 2, 0, 0 },
-		  .hsub = 2, .vsub = 2, .has_alpha = true, .is_yuv = true },
-		{ .format = DRM_FORMAT_X0L0,		.depth = 0,  .num_planes = 1,
-		  .char_per_block = { 8, 0, 0 }, .block_w = { 2, 0, 0 }, .block_h = { 2, 0, 0 },
-		  .hsub = 2, .vsub = 2, .is_yuv = true },
-		{ .format = DRM_FORMAT_Y0L2,		.depth = 0,  .num_planes = 1,
-		  .char_per_block = { 8, 0, 0 }, .block_w = { 2, 0, 0 }, .block_h = { 2, 0, 0 },
-		  .hsub = 2, .vsub = 2, .has_alpha = true, .is_yuv = true },
-		{ .format = DRM_FORMAT_X0L2,		.depth = 0,  .num_planes = 1,
-		  .char_per_block = { 8, 0, 0 }, .block_w = { 2, 0, 0 }, .block_h = { 2, 0, 0 },
-		  .hsub = 2, .vsub = 2, .is_yuv = true },
-		{ .format = DRM_FORMAT_P010,            .depth = 0,  .num_planes = 2,
-		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
-		  .hsub = 2, .vsub = 2, .is_yuv = true},
-		{ .format = DRM_FORMAT_P012,		.depth = 0,  .num_planes = 2,
-		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
-		   .hsub = 2, .vsub = 2, .is_yuv = true},
-		{ .format = DRM_FORMAT_P016,		.depth = 0,  .num_planes = 2,
-		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
-		  .hsub = 2, .vsub = 2, .is_yuv = true},
-	};
-
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
-		if (formats[i].format == format)
-			return &formats[i];
-	}
-
-	return NULL;
-}
-
-/**
- * drm_format_info - query information for a given format
- * @format: pixel format (DRM_FORMAT_*)
- *
- * The caller should only pass a supported pixel format to this function.
- * Unsupported pixel formats will generate a warning in the kernel log.
- *
- * Returns:
- * The instance of struct drm_format_info that describes the pixel format, or
- * NULL if the format is unsupported.
- */
-const struct drm_format_info *drm_format_info(u32 format)
-{
-	const struct drm_format_info *info;
-
-	info = __drm_format_info(format);
-	WARN_ON(!info);
-	return info;
-}
-EXPORT_SYMBOL(drm_format_info);
-
 /**
  * drm_get_format_info - query information for a given framebuffer configuration
  * @dev: DRM device
@@ -304,126 +174,3 @@ drm_get_format_info(struct drm_device *dev,
 	return info;
 }
 EXPORT_SYMBOL(drm_get_format_info);
-
-/**
- * drm_format_plane_cpp - determine the bytes per pixel value
- * @format: pixel format info
- * @plane: plane index
- *
- * Returns:
- * The bytes per pixel value for the specified plane.
- */
-int drm_format_plane_cpp(const struct drm_format_info *info, int plane)
-{
-	if (!info || plane >= info->num_planes)
-		return 0;
-
-	return info->cpp[plane];
-}
-EXPORT_SYMBOL(drm_format_plane_cpp);
-
-/**
- * drm_format_plane_width - width of the plane given the first plane
- * @width: width of the first plane
- * @format: pixel format info
- * @plane: plane index
- *
- * Returns:
- * The width of @plane, given that the width of the first plane is @width.
- */
-int drm_format_plane_width(int width, const struct drm_format_info *info,
-			   int plane)
-{
-	if (!info || plane >= info->num_planes)
-		return 0;
-
-	if (plane == 0)
-		return width;
-
-	return width / info->hsub;
-}
-EXPORT_SYMBOL(drm_format_plane_width);
-
-/**
- * drm_format_plane_height - height of the plane given the first plane
- * @height: height of the first plane
- * @format: pixel format info
- * @plane: plane index
- *
- * Returns:
- * The height of @plane, given that the height of the first plane is @height.
- */
-int drm_format_plane_height(int height, const struct drm_format_info *info,
-			    int plane)
-{
-	if (!info || plane >= info->num_planes)
-		return 0;
-
-	if (plane == 0)
-		return height;
-
-	return height / info->vsub;
-}
-EXPORT_SYMBOL(drm_format_plane_height);
-
-/**
- * drm_format_info_block_width - width in pixels of block.
- * @info: pixel format info
- * @plane: plane index
- *
- * Returns:
- * The width in pixels of a block, depending on the plane index.
- */
-unsigned int drm_format_info_block_width(const struct drm_format_info *info,
-					 int plane)
-{
-	if (!info || plane < 0 || plane >= info->num_planes)
-		return 0;
-
-	if (!info->block_w[plane])
-		return 1;
-	return info->block_w[plane];
-}
-EXPORT_SYMBOL(drm_format_info_block_width);
-
-/**
- * drm_format_info_block_height - height in pixels of a block
- * @info: pixel format info
- * @plane: plane index
- *
- * Returns:
- * The height in pixels of a block, depending on the plane index.
- */
-unsigned int drm_format_info_block_height(const struct drm_format_info *info,
-					  int plane)
-{
-	if (!info || plane < 0 || plane >= info->num_planes)
-		return 0;
-
-	if (!info->block_h[plane])
-		return 1;
-	return info->block_h[plane];
-}
-EXPORT_SYMBOL(drm_format_info_block_height);
-
-/**
- * drm_format_info_min_pitch - computes the minimum required pitch in bytes
- * @info: pixel format info
- * @plane: plane index
- * @buffer_width: buffer width in pixels
- *
- * Returns:
- * The minimum required pitch in bytes for a buffer by taking into consideration
- * the pixel format information and the buffer width.
- */
-uint64_t drm_format_info_min_pitch(const struct drm_format_info *info,
-				   int plane, unsigned int buffer_width)
-{
-	if (!info || plane < 0 || plane >= info->num_planes)
-		return 0;
-
-	return DIV_ROUND_UP_ULL((u64)buffer_width * info->char_per_block[plane],
-			    drm_format_info_block_width(info, plane) *
-			    drm_format_info_block_height(info, plane));
-}
-EXPORT_SYMBOL(drm_format_info_min_pitch);
diff --git a/drivers/gpu/drm/selftests/Makefile b/drivers/gpu/drm/selftests/Makefile
index 1bb73dc4c88c..e32921691662 100644
--- a/drivers/gpu/drm/selftests/Makefile
+++ b/drivers/gpu/drm/selftests/Makefile
@@ -1,5 +1,4 @@
 test-drm_modeset-y := test-drm_modeset_common.o test-drm_plane_helper.o \
-                      test-drm_format.o test-drm_framebuffer.o \
-		      test-drm_damage_helper.o
+                      test-drm_framebuffer.o test-drm_damage_helper.o
 
 obj-$(CONFIG_DRM_DEBUG_SELFTEST) += test-drm_mm.o test-drm_modeset.o
diff --git a/drivers/gpu/drm/selftests/drm_modeset_selftests.h b/drivers/gpu/drm/selftests/drm_modeset_selftests.h
index 464753746013..4a2ef84c2762 100644
--- a/drivers/gpu/drm/selftests/drm_modeset_selftests.h
+++ b/drivers/gpu/drm/selftests/drm_modeset_selftests.h
@@ -7,9 +7,6 @@
  * Tests are executed in order by igt/drm_selftests_helper
  */
 selftest(check_plane_state, igt_check_plane_state)
-selftest(check_drm_format_block_width, igt_check_drm_format_block_width)
-selftest(check_drm_format_block_height, igt_check_drm_format_block_height)
-selftest(check_drm_format_min_pitch, igt_check_drm_format_min_pitch)
 selftest(check_drm_framebuffer_create, igt_check_drm_framebuffer_create)
 selftest(damage_iter_no_damage, igt_damage_iter_no_damage)
 selftest(damage_iter_no_damage_fractional_src, igt_damage_iter_no_damage_fractional_src)
diff --git a/drivers/gpu/drm/selftests/test-drm_format.c b/drivers/gpu/drm/selftests/test-drm_format.c
deleted file mode 100644
index c5e212afa27a..000000000000
--- a/drivers/gpu/drm/selftests/test-drm_format.c
+++ /dev/null
@@ -1,280 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Test cases for the drm_format functions
- */
-
-#define pr_fmt(fmt) "drm_format: " fmt
-
-#include <linux/errno.h>
-#include <linux/kernel.h>
-
-#include <drm/drm_fourcc.h>
-
-#include "test-drm_modeset_common.h"
-
-int igt_check_drm_format_block_width(void *ignored)
-{
-	const struct drm_format_info *info = NULL;
-
-	/* Test invalid arguments */
-	FAIL_ON(drm_format_info_block_width(info, 0) != 0);
-	FAIL_ON(drm_format_info_block_width(info, -1) != 0);
-	FAIL_ON(drm_format_info_block_width(info, 1) != 0);
-
-	/* Test 1 plane format */
-	info = drm_format_info(DRM_FORMAT_XRGB4444);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_block_width(info, 0) != 1);
-	FAIL_ON(drm_format_info_block_width(info, 1) != 0);
-	FAIL_ON(drm_format_info_block_width(info, -1) != 0);
-
-	/* Test 2 planes format */
-	info = drm_format_info(DRM_FORMAT_NV12);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_block_width(info, 0) != 1);
-	FAIL_ON(drm_format_info_block_width(info, 1) != 1);
-	FAIL_ON(drm_format_info_block_width(info, 2) != 0);
-	FAIL_ON(drm_format_info_block_width(info, -1) != 0);
-
-	/* Test 3 planes format */
-	info = drm_format_info(DRM_FORMAT_YUV422);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_block_width(info, 0) != 1);
-	FAIL_ON(drm_format_info_block_width(info, 1) != 1);
-	FAIL_ON(drm_format_info_block_width(info, 2) != 1);
-	FAIL_ON(drm_format_info_block_width(info, 3) != 0);
-	FAIL_ON(drm_format_info_block_width(info, -1) != 0);
-
-	/* Test a tiled format */
-	info = drm_format_info(DRM_FORMAT_X0L0);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_block_width(info, 0) != 2);
-	FAIL_ON(drm_format_info_block_width(info, 1) != 0);
-	FAIL_ON(drm_format_info_block_width(info, -1) != 0);
-
-	return 0;
-}
-
-int igt_check_drm_format_block_height(void *ignored)
-{
-	const struct drm_format_info *info = NULL;
-
-	/* Test invalid arguments */
-	FAIL_ON(drm_format_info_block_height(info, 0) != 0);
-	FAIL_ON(drm_format_info_block_height(info, -1) != 0);
-	FAIL_ON(drm_format_info_block_height(info, 1) != 0);
-
-	/* Test 1 plane format */
-	info = drm_format_info(DRM_FORMAT_XRGB4444);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_block_height(info, 0) != 1);
-	FAIL_ON(drm_format_info_block_height(info, 1) != 0);
-	FAIL_ON(drm_format_info_block_height(info, -1) != 0);
-
-	/* Test 2 planes format */
-	info = drm_format_info(DRM_FORMAT_NV12);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_block_height(info, 0) != 1);
-	FAIL_ON(drm_format_info_block_height(info, 1) != 1);
-	FAIL_ON(drm_format_info_block_height(info, 2) != 0);
-	FAIL_ON(drm_format_info_block_height(info, -1) != 0);
-
-	/* Test 3 planes format */
-	info = drm_format_info(DRM_FORMAT_YUV422);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_block_height(info, 0) != 1);
-	FAIL_ON(drm_format_info_block_height(info, 1) != 1);
-	FAIL_ON(drm_format_info_block_height(info, 2) != 1);
-	FAIL_ON(drm_format_info_block_height(info, 3) != 0);
-	FAIL_ON(drm_format_info_block_height(info, -1) != 0);
-
-	/* Test a tiled format */
-	info = drm_format_info(DRM_FORMAT_X0L0);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_block_height(info, 0) != 2);
-	FAIL_ON(drm_format_info_block_height(info, 1) != 0);
-	FAIL_ON(drm_format_info_block_height(info, -1) != 0);
-
-	return 0;
-}
-
-int igt_check_drm_format_min_pitch(void *ignored)
-{
-	const struct drm_format_info *info = NULL;
-
-	/* Test invalid arguments */
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, -1, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 0) != 0);
-
-	/* Test 1 plane 8 bits per pixel format */
-	info = drm_format_info(DRM_FORMAT_RGB332);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, -1, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 0) != 0);
-
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1) != 1);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 2) != 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 640) != 640);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1024) != 1024);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1920) != 1920);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 4096) != 4096);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 671) != 671);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, UINT_MAX) !=
-			(uint64_t)UINT_MAX);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, (UINT_MAX - 1)) !=
-			(uint64_t)(UINT_MAX - 1));
-
-	/* Test 1 plane 16 bits per pixel format */
-	info = drm_format_info(DRM_FORMAT_XRGB4444);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, -1, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 0) != 0);
-
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1) != 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 2) != 4);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 640) != 1280);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1024) != 2048);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1920) != 3840);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 4096) != 8192);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 671) != 1342);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, UINT_MAX) !=
-			(uint64_t)UINT_MAX * 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, (UINT_MAX - 1)) !=
-			(uint64_t)(UINT_MAX - 1) * 2);
-
-	/* Test 1 plane 24 bits per pixel format */
-	info = drm_format_info(DRM_FORMAT_RGB888);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, -1, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 0) != 0);
-
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1) != 3);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 2) != 6);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 640) != 1920);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1024) != 3072);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1920) != 5760);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 4096) != 12288);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 671) != 2013);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, UINT_MAX) !=
-			(uint64_t)UINT_MAX * 3);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, UINT_MAX - 1) !=
-			(uint64_t)(UINT_MAX - 1) * 3);
-
-	/* Test 1 plane 32 bits per pixel format */
-	info = drm_format_info(DRM_FORMAT_ABGR8888);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, -1, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 0) != 0);
-
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1) != 4);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 2) != 8);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 640) != 2560);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1024) != 4096);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1920) != 7680);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 4096) != 16384);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 671) != 2684);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, UINT_MAX) !=
-			(uint64_t)UINT_MAX * 4);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, UINT_MAX - 1) !=
-			(uint64_t)(UINT_MAX - 1) * 4);
-
-	/* Test 2 planes format */
-	info = drm_format_info(DRM_FORMAT_NV12);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, -1, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, 2, 0) != 0);
-
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1) != 1);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 1) != 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 2) != 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 1) != 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 640) != 640);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 320) != 640);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1024) != 1024);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 512) != 1024);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1920) != 1920);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 960) != 1920);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 4096) != 4096);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 2048) != 4096);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 671) != 671);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 336) != 672);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, UINT_MAX) !=
-			(uint64_t)UINT_MAX);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, UINT_MAX / 2 + 1) !=
-			(uint64_t)UINT_MAX + 1);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, (UINT_MAX - 1)) !=
-			(uint64_t)(UINT_MAX - 1));
-	FAIL_ON(drm_format_info_min_pitch(info, 1, (UINT_MAX - 1) /  2) !=
-			(uint64_t)(UINT_MAX - 1));
-
-	/* Test 3 planes 8 bits per pixel format */
-	info = drm_format_info(DRM_FORMAT_YUV422);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, 2, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, -1, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, 3, 0) != 0);
-
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1) != 1);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 1) != 1);
-	FAIL_ON(drm_format_info_min_pitch(info, 2, 1) != 1);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 2) != 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 2) != 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 2, 2) != 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 640) != 640);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 320) != 320);
-	FAIL_ON(drm_format_info_min_pitch(info, 2, 320) != 320);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1024) != 1024);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 512) != 512);
-	FAIL_ON(drm_format_info_min_pitch(info, 2, 512) != 512);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1920) != 1920);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 960) != 960);
-	FAIL_ON(drm_format_info_min_pitch(info, 2, 960) != 960);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 4096) != 4096);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 2048) != 2048);
-	FAIL_ON(drm_format_info_min_pitch(info, 2, 2048) != 2048);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 671) != 671);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 336) != 336);
-	FAIL_ON(drm_format_info_min_pitch(info, 2, 336) != 336);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, UINT_MAX) !=
-			(uint64_t)UINT_MAX);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, UINT_MAX / 2 + 1) !=
-			(uint64_t)UINT_MAX / 2 + 1);
-	FAIL_ON(drm_format_info_min_pitch(info, 2, UINT_MAX / 2 + 1) !=
-			(uint64_t)UINT_MAX / 2 + 1);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, (UINT_MAX - 1) / 2) !=
-			(uint64_t)(UINT_MAX - 1) / 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, (UINT_MAX - 1) / 2) !=
-			(uint64_t)(UINT_MAX - 1) / 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 2, (UINT_MAX - 1) / 2) !=
-			(uint64_t)(UINT_MAX - 1) / 2);
-
-	/* Test tiled format */
-	info = drm_format_info(DRM_FORMAT_X0L2);
-	FAIL_ON(!info);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, -1, 0) != 0);
-	FAIL_ON(drm_format_info_min_pitch(info, 1, 0) != 0);
-
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1) != 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 2) != 4);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 640) != 1280);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1024) != 2048);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 1920) != 3840);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 4096) != 8192);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, 671) != 1342);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, UINT_MAX) !=
-			(uint64_t)UINT_MAX * 2);
-	FAIL_ON(drm_format_info_min_pitch(info, 0, UINT_MAX - 1) !=
-			(uint64_t)(UINT_MAX - 1) * 2);
-
-	return 0;
-}
diff --git a/drivers/gpu/drm/selftests/test-drm_modeset_common.h b/drivers/gpu/drm/selftests/test-drm_modeset_common.h
index 8c76f09c12d1..fb2b8fbd7566 100644
--- a/drivers/gpu/drm/selftests/test-drm_modeset_common.h
+++ b/drivers/gpu/drm/selftests/test-drm_modeset_common.h
@@ -14,9 +14,6 @@
 #define FAIL_ON(x) FAIL((x), "%s", "FAIL_ON(" __stringify(x) ")\n")
 
 int igt_check_plane_state(void *ignored);
-int igt_check_drm_format_block_width(void *ignored);
-int igt_check_drm_format_block_height(void *ignored);
-int igt_check_drm_format_min_pitch(void *ignored);
 int igt_check_drm_framebuffer_create(void *ignored);
 int igt_damage_iter_no_damage(void *ignored);
 int igt_damage_iter_no_damage_fractional_src(void *ignored);
diff --git a/include/drm/drm_fourcc.h b/include/drm/drm_fourcc.h
index 7cc7b99a6569..8ca45b2be9ca 100644
--- a/include/drm/drm_fourcc.h
+++ b/include/drm/drm_fourcc.h
@@ -52,91 +52,6 @@ struct drm_mode_fb_cmd2;
 struct image_format_info;
 
 /**
- * struct drm_format_info - information about a DRM format
- */
-struct drm_format_info {
-	/** @format: 4CC format identifier (DRM_FORMAT_*) */
-	u32 format;
-
-	/**
-	 * @depth:
-	 *
-	 * Color depth (number of bits per pixel excluding padding bits),
-	 * valid for a subset of RGB formats only. This is a legacy field, do
-	 * not use in new code and set to 0 for new formats.
-	 */
-	u8 depth;
-
-	/** @num_planes: Number of color planes (1 to 3) */
-	u8 num_planes;
-
-	union {
-		/**
-		 * @cpp:
-		 *
-		 * Number of bytes per pixel (per plane), this is aliased with
-		 * @char_per_block. It is deprecated in favour of using the
-		 * triplet @char_per_block, @block_w, @block_h for better
-		 * describing the pixel format.
-		 */
-		u8 cpp[3];
-
-		/**
-		 * @char_per_block:
-		 *
-		 * Number of bytes per block (per plane), where blocks are
-		 * defined as a rectangle of pixels which are stored next to
-		 * each other in a byte aligned memory region. Together with
-		 * @block_w and @block_h this is used to properly describe tiles
-		 * in tiled formats or to describe groups of pixels in packed
-		 * formats for which the memory needed for a single pixel is not
-		 * byte aligned.
-		 *
-		 * @cpp has been kept for historical reasons because there are
-		 * a lot of places in drivers where it's used. In drm core for
-		 * generic code paths the preferred way is to use
-		 * @char_per_block, drm_format_info_block_width() and
-		 * drm_format_info_block_height() which allows handling both
-		 * block and non-block formats in the same way.
-		 *
-		 * For formats that are intended to be used only with non-linear
-		 * modifiers both @cpp and @char_per_block must be 0 in the
-		 * generic format table. Drivers could supply accurate
-		 * information from their drm_mode_config.get_format_info hook
-		 * if they want the core to be validating the pitch.
-		 */
-		u8 char_per_block[3];
-	};
-
-	/**
-	 * @block_w:
-	 *
-	 * Block width in pixels, this is intended to be accessed through
-	 * drm_format_info_block_width()
-	 */
-	u8 block_w[3];
-
-	/**
-	 * @block_h:
-	 *
-	 * Block height in pixels, this is intended to be accessed through
-	 * drm_format_info_block_height()
-	 */
-	u8 block_h[3];
-
-	/** @hsub: Horizontal chroma subsampling factor */
-	u8 hsub;
-	/** @vsub: Vertical chroma subsampling factor */
-	u8 vsub;
-
-	/** @has_alpha: Does the format embeds an alpha component? */
-	bool has_alpha;
-
-	/** @is_yuv: Is it a YUV format? */
-	bool is_yuv;
-};
-
-/**
  * struct drm_format_name_buf - name of a DRM format
  * @str: string buffer containing the format name
  */
@@ -144,143 +59,12 @@ struct drm_format_name_buf {
 	char str[32];
 };
 
-/**
- * drm_format_info_is_yuv_packed - check that the format info matches a YUV
- * format with data laid in a single plane
- * @info: format info
- *
- * Returns:
- * A boolean indicating whether the format info matches a packed YUV format.
- */
-static inline bool
-drm_format_info_is_yuv_packed(const struct drm_format_info *info)
-{
-	return info->is_yuv && info->num_planes == 1;
-}
-
-/**
- * drm_format_info_is_yuv_semiplanar - check that the format info matches a YUV
- * format with data laid in two planes (luminance and chrominance)
- * @info: format info
- *
- * Returns:
- * A boolean indicating whether the format info matches a semiplanar YUV format.
- */
-static inline bool
-drm_format_info_is_yuv_semiplanar(const struct drm_format_info *info)
-{
-	return info->is_yuv && info->num_planes == 2;
-}
-
-/**
- * drm_format_info_is_yuv_planar - check that the format info matches a YUV
- * format with data laid in three planes (one for each YUV component)
- * @info: format info
- *
- * Returns:
- * A boolean indicating whether the format info matches a planar YUV format.
- */
-static inline bool
-drm_format_info_is_yuv_planar(const struct drm_format_info *info)
-{
-	return info->is_yuv && info->num_planes == 3;
-}
-
-/**
- * drm_format_info_is_yuv_sampling_410 - check that the format info matches a
- * YUV format with 4:1:0 sub-sampling
- * @info: format info
- *
- * Returns:
- * A boolean indicating whether the format info matches a YUV format with 4:1:0
- * sub-sampling.
- */
-static inline bool
-drm_format_info_is_yuv_sampling_410(const struct drm_format_info *info)
-{
-	return info->is_yuv && info->hsub == 4 && info->vsub == 4;
-}
-
-/**
- * drm_format_info_is_yuv_sampling_411 - check that the format info matches a
- * YUV format with 4:1:1 sub-sampling
- * @info: format info
- *
- * Returns:
- * A boolean indicating whether the format info matches a YUV format with 4:1:1
- * sub-sampling.
- */
-static inline bool
-drm_format_info_is_yuv_sampling_411(const struct drm_format_info *info)
-{
-	return info->is_yuv && info->hsub == 4 && info->vsub == 1;
-}
-
-/**
- * drm_format_info_is_yuv_sampling_420 - check that the format info matches a
- * YUV format with 4:2:0 sub-sampling
- * @info: format info
- *
- * Returns:
- * A boolean indicating whether the format info matches a YUV format with 4:2:0
- * sub-sampling.
- */
-static inline bool
-drm_format_info_is_yuv_sampling_420(const struct drm_format_info *info)
-{
-	return info->is_yuv && info->hsub == 2 && info->vsub == 2;
-}
-
-/**
- * drm_format_info_is_yuv_sampling_422 - check that the format info matches a
- * YUV format with 4:2:2 sub-sampling
- * @info: format info
- *
- * Returns:
- * A boolean indicating whether the format info matches a YUV format with 4:2:2
- * sub-sampling.
- */
-static inline bool
-drm_format_info_is_yuv_sampling_422(const struct drm_format_info *info)
-{
-	return info->is_yuv && info->hsub == 2 && info->vsub == 1;
-}
-
-/**
- * drm_format_info_is_yuv_sampling_444 - check that the format info matches a
- * YUV format with 4:4:4 sub-sampling
- * @info: format info
- *
- * Returns:
- * A boolean indicating whether the format info matches a YUV format with 4:4:4
- * sub-sampling.
- */
-static inline bool
-drm_format_info_is_yuv_sampling_444(const struct drm_format_info *info)
-{
-	return info->is_yuv && info->hsub == 1 && info->vsub == 1;
-}
-
-const struct drm_format_info *__drm_format_info(u32 format);
-const struct drm_format_info *drm_format_info(u32 format);
-
 const struct image_format_info *
 drm_get_format_info(struct drm_device *dev,
 		    const struct drm_mode_fb_cmd2 *mode_cmd);
 uint32_t drm_mode_legacy_fb_format(uint32_t bpp, uint32_t depth);
 uint32_t drm_driver_legacy_fb_format(struct drm_device *dev,
 				     uint32_t bpp, uint32_t depth);
-int drm_format_plane_cpp(const struct drm_format_info *info, int plane);
-int drm_format_plane_width(int width, const struct drm_format_info *info,
-			   int plane);
-int drm_format_plane_height(int height, const struct drm_format_info *info,
-			    int plane);
-unsigned int drm_format_info_block_width(const struct drm_format_info *info,
-					 int plane);
-unsigned int drm_format_info_block_height(const struct drm_format_info *info,
-					  int plane);
-uint64_t drm_format_info_min_pitch(const struct drm_format_info *info,
-				   int plane, unsigned int buffer_width);
 const char *drm_get_format_name(uint32_t format, struct drm_format_name_buf *buf);
 
 #endif /* __DRM_FOURCC_H__ */
-- 
git-series 0.9.1
