Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:57324 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdADQ3p (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 11:29:45 -0500
From: Randy Li <ayaka@soulik.info>
To: dri-devel@lists.freedesktop.org
Cc: ville.syrjala@linux.intel.com, randy.li@rock-chips.com,
        linux-kernel@vger.kernel.org, daniel.vetter@intel.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v2 1/2] drm_fourcc: Add new P010, P016 video format
Date: Thu,  5 Jan 2017 00:29:10 +0800
Message-Id: <1483547351-5792-2-git-send-email-ayaka@soulik.info>
In-Reply-To: <1483547351-5792-1-git-send-email-ayaka@soulik.info>
References: <1483547351-5792-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits
per channel video format. Rockchip's vop support this
video format(little endian only) as the input video format.

P016 is a planar 4:2:0 YUV with interleaved UV plane, 16 bits
per channel video format.

Signed-off-by: Randy Li <ayaka@soulik.info>

drm
---
 drivers/gpu/drm/drm_fourcc.c  | 3 +++
 include/uapi/drm/drm_fourcc.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index 90d2cc8..23c8e99 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -165,6 +165,9 @@ const struct drm_format_info *__drm_format_info(u32 format)
 		{ .format = DRM_FORMAT_UYVY,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
 		{ .format = DRM_FORMAT_VYUY,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
 		{ .format = DRM_FORMAT_AYUV,		.depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
+		/* FIXME a pixel in Y for P010 is 10 bits */
+		{ .format = DRM_FORMAT_P010,		.depth = 0,  .num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2 },
+		{ .format = DRM_FORMAT_P016,		.depth = 0,  .num_planes = 2, .cpp = { 2, 4, 0 }, .hsub = 2, .vsub = 2 },
 	};
 
 	unsigned int i;
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 9e1bb7f..ecc2e05e5 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -119,6 +119,8 @@ extern "C" {
 #define DRM_FORMAT_NV61		fourcc_code('N', 'V', '6', '1') /* 2x1 subsampled Cb:Cr plane */
 #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
 #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
+#define DRM_FORMAT_P010		fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel */
+#define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cr:Cb plane 16 bits per channel */
 
 /*
  * 3 plane YCbCr
-- 
2.7.4

