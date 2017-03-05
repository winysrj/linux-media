Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:39134 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdCEKAp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 05:00:45 -0500
From: Randy Li <ayaka@soulik.info>
To: dri-devel@lists.freedesktop.org
Cc: clinton.a.taylor@intel.com, daniel@fooishbar.org,
        ville.syrjala@linux.intel.com, linux-media@vger.kernel.org,
        mchehab@kernel.org, linux-kernel@vger.kernel.org,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v6 1/3] drm_fourcc: Add new P010, P016 video format
Date: Sun,  5 Mar 2017 18:00:31 +0800
Message-Id: <1488708033-5691-2-git-send-email-ayaka@soulik.info>
In-Reply-To: <1488708033-5691-1-git-send-email-ayaka@soulik.info>
References: <1488708033-5691-1-git-send-email-ayaka@soulik.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits
per channel video format.

P016 is a planar 4:2:0 YUV with interleaved UV plane, 16 bits
per channel video format.

V3: Added P012 and fixed cpp for P010
V4: format definition refined per review
V5: Format comment block for each new pixel format
V6: reversed Cb/Cr order in comments
v7: reversed Cb/Cr order in comments of header files, remove
the wrong part of commit message.

Cc: Daniel Stone <daniel@fooishbar.org>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>

Signed-off-by: Randy Li <ayaka@soulik.info>
Signed-off-by: Clint Taylor <clinton.a.taylor@intel.com>
---
 drivers/gpu/drm/drm_fourcc.c  |  3 +++
 include/uapi/drm/drm_fourcc.h | 21 +++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index 90d2cc8..3e0fd58 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -165,6 +165,9 @@ const struct drm_format_info *__drm_format_info(u32 format)
 		{ .format = DRM_FORMAT_UYVY,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
 		{ .format = DRM_FORMAT_VYUY,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
 		{ .format = DRM_FORMAT_AYUV,		.depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
+		{ .format = DRM_FORMAT_P010,		.depth = 0,  .num_planes = 2, .cpp = { 2, 4, 0 }, .hsub = 2, .vsub = 2 },
+		{ .format = DRM_FORMAT_P012,		.depth = 0,  .num_planes = 2, .cpp = { 2, 4, 0 }, .hsub = 2, .vsub = 2 },
+		{ .format = DRM_FORMAT_P016,		.depth = 0,  .num_planes = 2, .cpp = { 2, 4, 0 }, .hsub = 2, .vsub = 2 },
 	};
 
 	unsigned int i;
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index ef20abb..306f979 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -128,6 +128,27 @@ extern "C" {
 #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
 
 /*
+ * 2 plane YCbCr MSB aligned
+ * index 0 = Y plane, [15:0] Y:x [10:6] little endian
+ * index 1 = Cb:Cr plane, [31:0] Cb:x:Cr:x [10:6:10:6] little endian
+ */
+#define DRM_FORMAT_P010		fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cb:Cr plane 10 bits per channel */
+
+/*
+ * 2 plane YCbCr MSB aligned
+ * index 0 = Y plane, [15:0] Y:x [12:4] little endian
+ * index 1 = Cb:Cr plane, [31:0] Cb:x:Cr:x [12:4:12:4] little endian
+ */
+#define DRM_FORMAT_P012		fourcc_code('P', '0', '1', '2') /* 2x2 subsampled Cb:Cr plane 12 bits per channel */
+
+/*
+ * 2 plane YCbCr MSB aligned
+ * index 0 = Y plane, [15:0] Y little endian
+ * index 1 = Cb:Cr plane, [31:0] Cb:Cr [16:16] little endian
+ */
+#define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cb:Cr plane 16 bits per channel */
+
+/*
  * 3 plane YCbCr
  * index 0: Y plane, [7:0] Y
  * index 1: Cb plane, [7:0] Cb
-- 
2.7.4
