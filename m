Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:34232 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753382AbcJZI4G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 04:56:06 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [RFC PATCH v2 4/9] drm: mali-dp: Add RGB writeback formats for DP550/DP650
Date: Wed, 26 Oct 2016 09:55:03 +0100
Message-Id: <1477472108-27222-5-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a layer bit for the SE memory-write, and add it to the pixel format
matrix for DP550/DP650.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/arm/malidp_hw.c |   28 ++++++++++++++--------------
 drivers/gpu/drm/arm/malidp_hw.h |    1 +
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
index eb8a4bf..df1fce0 100644
--- a/drivers/gpu/drm/arm/malidp_hw.c
+++ b/drivers/gpu/drm/arm/malidp_hw.c
@@ -46,20 +46,20 @@ static const struct malidp_format_id malidp500_de_formats[] = {
 
 #define MALIDP_COMMON_FORMATS \
 	/*    fourcc,   layers supporting the format,      internal id   */ \
-	{ DRM_FORMAT_ARGB2101010, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2, MALIDP_ID(0, 0) }, \
-	{ DRM_FORMAT_ABGR2101010, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2, MALIDP_ID(0, 1) }, \
-	{ DRM_FORMAT_RGBA1010102, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2, MALIDP_ID(0, 2) }, \
-	{ DRM_FORMAT_BGRA1010102, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2, MALIDP_ID(0, 3) }, \
-	{ DRM_FORMAT_ARGB8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART, MALIDP_ID(1, 0) }, \
-	{ DRM_FORMAT_ABGR8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART, MALIDP_ID(1, 1) }, \
-	{ DRM_FORMAT_RGBA8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART, MALIDP_ID(1, 2) }, \
-	{ DRM_FORMAT_BGRA8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART, MALIDP_ID(1, 3) }, \
-	{ DRM_FORMAT_XRGB8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART, MALIDP_ID(2, 0) }, \
-	{ DRM_FORMAT_XBGR8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART, MALIDP_ID(2, 1) }, \
-	{ DRM_FORMAT_RGBX8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART, MALIDP_ID(2, 2) }, \
-	{ DRM_FORMAT_BGRX8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART, MALIDP_ID(2, 3) }, \
-	{ DRM_FORMAT_RGB888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2, MALIDP_ID(3, 0) }, \
-	{ DRM_FORMAT_BGR888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2, MALIDP_ID(3, 1) }, \
+	{ DRM_FORMAT_ARGB2101010, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | SE_MEMWRITE, MALIDP_ID(0, 0) }, \
+	{ DRM_FORMAT_ABGR2101010, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | SE_MEMWRITE, MALIDP_ID(0, 1) }, \
+	{ DRM_FORMAT_RGBA1010102, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | SE_MEMWRITE, MALIDP_ID(0, 2) }, \
+	{ DRM_FORMAT_BGRA1010102, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | SE_MEMWRITE, MALIDP_ID(0, 3) }, \
+	{ DRM_FORMAT_ARGB8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART | SE_MEMWRITE, MALIDP_ID(1, 0) }, \
+	{ DRM_FORMAT_ABGR8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART | SE_MEMWRITE, MALIDP_ID(1, 1) }, \
+	{ DRM_FORMAT_RGBA8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART | SE_MEMWRITE, MALIDP_ID(1, 2) }, \
+	{ DRM_FORMAT_BGRA8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART | SE_MEMWRITE, MALIDP_ID(1, 3) }, \
+	{ DRM_FORMAT_XRGB8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART | SE_MEMWRITE, MALIDP_ID(2, 0) }, \
+	{ DRM_FORMAT_XBGR8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART | SE_MEMWRITE, MALIDP_ID(2, 1) }, \
+	{ DRM_FORMAT_RGBX8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART | SE_MEMWRITE, MALIDP_ID(2, 2) }, \
+	{ DRM_FORMAT_BGRX8888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | DE_SMART | SE_MEMWRITE, MALIDP_ID(2, 3) }, \
+	{ DRM_FORMAT_RGB888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | SE_MEMWRITE, MALIDP_ID(3, 0) }, \
+	{ DRM_FORMAT_BGR888, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2 | SE_MEMWRITE, MALIDP_ID(3, 1) }, \
 	{ DRM_FORMAT_RGBA5551, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2, MALIDP_ID(4, 0) }, \
 	{ DRM_FORMAT_ABGR1555, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2, MALIDP_ID(4, 1) }, \
 	{ DRM_FORMAT_RGB565, DE_VIDEO1 | DE_GRAPHICS1 | DE_VIDEO2, MALIDP_ID(4, 2) }, \
diff --git a/drivers/gpu/drm/arm/malidp_hw.h b/drivers/gpu/drm/arm/malidp_hw.h
index 4f8c884..ce4ea55 100644
--- a/drivers/gpu/drm/arm/malidp_hw.h
+++ b/drivers/gpu/drm/arm/malidp_hw.h
@@ -33,6 +33,7 @@ enum {
 	DE_GRAPHICS2 = BIT(2), /* used only in DP500 */
 	DE_VIDEO2 = BIT(3),
 	DE_SMART = BIT(4),
+	SE_MEMWRITE = BIT(5),
 };
 
 struct malidp_format_id {
-- 
1.7.9.5

