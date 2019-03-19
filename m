Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F15C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E4282085A
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfCSV7Z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:59:25 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:49921 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfCSV5y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:57:54 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 0CE34240005;
        Tue, 19 Mar 2019 21:57:45 +0000 (UTC)
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
Subject: [RFC PATCH 06/20] lib: Add video format information library
Date:   Tue, 19 Mar 2019 22:57:11 +0100
Message-Id: <a2ecd9e599e0b536c2a005e5feb140463566788e.1553032382.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Move the DRM formats API to turn this into a more generic image formats API
to be able to leverage it into some other places of the kernel, such as
v4l2 drivers.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 include/linux/image-formats.h | 240 +++++++++++-
 lib/Kconfig                   |   7 +-
 lib/Makefile                  |   3 +-
 lib/image-formats-selftests.c | 326 +++++++++++++++-
 lib/image-formats.c           | 760 +++++++++++++++++++++++++++++++++++-
 5 files changed, 1336 insertions(+)
 create mode 100644 include/linux/image-formats.h
 create mode 100644 lib/image-formats-selftests.c
 create mode 100644 lib/image-formats.c

diff --git a/include/linux/image-formats.h b/include/linux/image-formats.h
new file mode 100644
index 000000000000..53fd73a71b3d
--- /dev/null
+++ b/include/linux/image-formats.h
@@ -0,0 +1,240 @@
+#ifndef _IMAGE_FORMATS_H_
+#define _IMAGE_FORMATS_H_
+
+#include <linux/types.h>
+
+/**
+ * struct image_format_info - information about a image format
+ */
+struct image_format_info {
+	union {
+		/**
+		 * @drm_fmt:
+		 *
+		 * DRM 4CC format identifier (DRM_FORMAT_*)
+		 */
+		u32 drm_fmt;
+
+		/**
+		 * @format:
+		 *
+		 * DRM 4CC format identifier (DRM_FORMAT_*). Kept
+		 * around for compatibility reasons with the current
+		 * DRM drivers.
+		 */
+		u32 format;
+	};
+
+	/**
+	 * @depth:
+	 *
+	 * Color depth (number of bits per pixel excluding padding bits),
+	 * valid for a subset of RGB formats only. This is a legacy field, do
+	 * not use in new code and set to 0 for new formats.
+	 */
+	u8 depth;
+
+	/** @num_planes: Number of color planes (1 to 3) */
+	u8 num_planes;
+
+	union {
+		/**
+		 * @cpp:
+		 *
+		 * Number of bytes per pixel (per plane), this is aliased with
+		 * @char_per_block. It is deprecated in favour of using the
+		 * triplet @char_per_block, @block_w, @block_h for better
+		 * describing the pixel format.
+		 */
+		u8 cpp[3];
+
+		/**
+		 * @char_per_block:
+		 *
+		 * Number of bytes per block (per plane), where blocks are
+		 * defined as a rectangle of pixels which are stored next to
+		 * each other in a byte aligned memory region. Together with
+		 * @block_w and @block_h this is used to properly describe tiles
+		 * in tiled formats or to describe groups of pixels in packed
+		 * formats for which the memory needed for a single pixel is not
+		 * byte aligned.
+		 *
+		 * @cpp has been kept for historical reasons because there are
+		 * a lot of places in drivers where it's used. In drm core for
+		 * generic code paths the preferred way is to use
+		 * @char_per_block, image_format_block_width() and
+		 * image_format_block_height() which allows handling both
+		 * block and non-block formats in the same way.
+		 *
+		 * For formats that are intended to be used only with non-linear
+		 * modifiers both @cpp and @char_per_block must be 0 in the
+		 * generic format table. Drivers could supply accurate
+		 * information from their drm_mode_config.get_format_info hook
+		 * if they want the core to be validating the pitch.
+		 */
+		u8 char_per_block[3];
+	};
+
+	/**
+	 * @block_w:
+	 *
+	 * Block width in pixels, this is intended to be accessed through
+	 * image_format_block_width()
+	 */
+	u8 block_w[3];
+
+	/**
+	 * @block_h:
+	 *
+	 * Block height in pixels, this is intended to be accessed through
+	 * image_format_block_height()
+	 */
+	u8 block_h[3];
+
+	/** @hsub: Horizontal chroma subsampling factor */
+	u8 hsub;
+	/** @vsub: Vertical chroma subsampling factor */
+	u8 vsub;
+
+	/** @has_alpha: Does the format embeds an alpha component? */
+	bool has_alpha;
+
+	/** @is_yuv: Is it a YUV format? */
+	bool is_yuv;
+};
+
+/**
+ * image_format_info_is_yuv_packed - check that the format info matches a YUV
+ * format with data laid in a single plane
+ * @info: format info
+ *
+ * Returns:
+ * A boolean indicating whether the format info matches a packed YUV format.
+ */
+static inline bool
+image_format_info_is_yuv_packed(const struct image_format_info *info)
+{
+	return info->is_yuv && info->num_planes == 1;
+}
+
+/**
+ * image_format_info_is_yuv_semiplanar - check that the format info matches a YUV
+ * format with data laid in two planes (luminance and chrominance)
+ * @info: format info
+ *
+ * Returns:
+ * A boolean indicating whether the format info matches a semiplanar YUV format.
+ */
+static inline bool
+image_format_info_is_yuv_semiplanar(const struct image_format_info *info)
+{
+	return info->is_yuv && info->num_planes == 2;
+}
+
+/**
+ * image_format_info_is_yuv_planar - check that the format info matches a YUV
+ * format with data laid in three planes (one for each YUV component)
+ * @info: format info
+ *
+ * Returns:
+ * A boolean indicating whether the format info matches a planar YUV format.
+ */
+static inline bool
+image_format_info_is_yuv_planar(const struct image_format_info *info)
+{
+	return info->is_yuv && info->num_planes == 3;
+}
+
+/**
+ * image_format_info_is_yuv_sampling_410 - check that the format info matches a
+ * YUV format with 4:1:0 sub-sampling
+ * @info: format info
+ *
+ * Returns:
+ * A boolean indicating whether the format info matches a YUV format with 4:1:0
+ * sub-sampling.
+ */
+static inline bool
+image_format_info_is_yuv_sampling_410(const struct image_format_info *info)
+{
+	return info->is_yuv && info->hsub == 4 && info->vsub == 4;
+}
+
+/**
+ * image_format_info_is_yuv_sampling_411 - check that the format info matches a
+ * YUV format with 4:1:1 sub-sampling
+ * @info: format info
+ *
+ * Returns:
+ * A boolean indicating whether the format info matches a YUV format with 4:1:1
+ * sub-sampling.
+ */
+static inline bool
+image_format_info_is_yuv_sampling_411(const struct image_format_info *info)
+{
+	return info->is_yuv && info->hsub == 4 && info->vsub == 1;
+}
+
+/**
+ * image_format_info_is_yuv_sampling_420 - check that the format info matches a
+ * YUV format with 4:2:0 sub-sampling
+ * @info: format info
+ *
+ * Returns:
+ * A boolean indicating whether the format info matches a YUV format with 4:2:0
+ * sub-sampling.
+ */
+static inline bool
+image_format_info_is_yuv_sampling_420(const struct image_format_info *info)
+{
+	return info->is_yuv && info->hsub == 2 && info->vsub == 2;
+}
+
+/**
+ * image_format_info_is_yuv_sampling_422 - check that the format info matches a
+ * YUV format with 4:2:2 sub-sampling
+ * @info: format info
+ *
+ * Returns:
+ * A boolean indicating whether the format info matches a YUV format with 4:2:2
+ * sub-sampling.
+ */
+static inline bool
+image_format_info_is_yuv_sampling_422(const struct image_format_info *info)
+{
+	return info->is_yuv && info->hsub == 2 && info->vsub == 1;
+}
+
+/**
+ * image_format_info_is_yuv_sampling_444 - check that the format info matches a
+ * YUV format with 4:4:4 sub-sampling
+ * @info: format info
+ *
+ * Returns:
+ * A boolean indicating whether the format info matches a YUV format with 4:4:4
+ * sub-sampling.
+ */
+static inline bool
+image_format_info_is_yuv_sampling_444(const struct image_format_info *info)
+{
+	return info->is_yuv && info->hsub == 1 && info->vsub == 1;
+}
+
+const struct image_format_info *__image_format_drm_lookup(u32 drm);
+const struct image_format_info *image_format_drm_lookup(u32 drm);
+unsigned int image_format_plane_cpp(const struct image_format_info *format,
+				    int plane);
+unsigned int image_format_plane_width(int width,
+				      const struct image_format_info *format,
+				      int plane);
+unsigned int image_format_plane_height(int height,
+				       const struct image_format_info *format,
+				       int plane);
+unsigned int image_format_block_width(const struct image_format_info *format,
+				      int plane);
+unsigned int image_format_block_height(const struct image_format_info *format,
+				       int plane);
+uint64_t image_format_min_pitch(const struct image_format_info *info,
+				int plane, unsigned int buffer_width);
+
+#endif /* _IMAGE_FORMATS_H_ */
diff --git a/lib/Kconfig b/lib/Kconfig
index a9e56539bd11..421acac83b13 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -635,3 +635,10 @@ config GENERIC_LIB_UCMPDI2
 
 config OBJAGG
 	tristate "objagg" if COMPILE_TEST
+
+config IMAGE_FORMATS
+	bool
+
+config IMAGE_FORMATS_SELFTESTS
+	tristate "Test image format functions"
+	depends on IMAGE_FORMATS
diff --git a/lib/Makefile b/lib/Makefile
index e1b59da71418..b1916e6d30da 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -276,3 +276,6 @@ obj-$(CONFIG_GENERIC_LIB_MULDI3) += muldi3.o
 obj-$(CONFIG_GENERIC_LIB_CMPDI2) += cmpdi2.o
 obj-$(CONFIG_GENERIC_LIB_UCMPDI2) += ucmpdi2.o
 obj-$(CONFIG_OBJAGG) += objagg.o
+
+obj-$(CONFIG_IMAGE_FORMATS) += image-formats.o
+obj-$(CONFIG_IMAGE_FORMATS_SELFTESTS) += image-formats-selftests.o
diff --git a/lib/image-formats-selftests.c b/lib/image-formats-selftests.c
new file mode 100644
index 000000000000..8fdc50b15dcc
--- /dev/null
+++ b/lib/image-formats-selftests.c
@@ -0,0 +1,326 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test cases for the image_format functions
+ */
+
+#define pr_fmt(fmt) "image_format: " fmt
+
+#include <linux/errno.h>
+#include <linux/image-formats.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <drm/drm_fourcc.h>
+
+#define FAIL(test, msg, ...) \
+	do { \
+		if (test) { \
+			pr_err("%s/%u: " msg, __FUNCTION__, __LINE__, ##__VA_ARGS__); \
+			return -EINVAL; \
+		} \
+	} while (0)
+
+#define FAIL_ON(x) FAIL((x), "%s", "FAIL_ON(" __stringify(x) ")\n")
+
+static int test_image_format_block_width(void)
+{
+	const struct image_format_info *info = NULL;
+
+	/* Test invalid arguments */
+	FAIL_ON(image_format_block_width(info, 0) != 0);
+	FAIL_ON(image_format_block_width(info, -1) != 0);
+	FAIL_ON(image_format_block_width(info, 1) != 0);
+
+	/* Test 1 plane format */
+	info = image_format_drm_lookup(DRM_FORMAT_XRGB4444);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_block_width(info, 0) != 1);
+	FAIL_ON(image_format_block_width(info, 1) != 0);
+	FAIL_ON(image_format_block_width(info, -1) != 0);
+
+	/* Test 2 planes format */
+	info = image_format_drm_lookup(DRM_FORMAT_NV12);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_block_width(info, 0) != 1);
+	FAIL_ON(image_format_block_width(info, 1) != 1);
+	FAIL_ON(image_format_block_width(info, 2) != 0);
+	FAIL_ON(image_format_block_width(info, -1) != 0);
+
+	/* Test 3 planes format */
+	info = image_format_drm_lookup(DRM_FORMAT_YUV422);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_block_width(info, 0) != 1);
+	FAIL_ON(image_format_block_width(info, 1) != 1);
+	FAIL_ON(image_format_block_width(info, 2) != 1);
+	FAIL_ON(image_format_block_width(info, 3) != 0);
+	FAIL_ON(image_format_block_width(info, -1) != 0);
+
+	/* Test a tiled format */
+	info = image_format_drm_lookup(DRM_FORMAT_X0L0);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_block_width(info, 0) != 2);
+	FAIL_ON(image_format_block_width(info, 1) != 0);
+	FAIL_ON(image_format_block_width(info, -1) != 0);
+
+	return 0;
+}
+
+static int test_image_format_block_height(void)
+{
+	const struct image_format_info *info = NULL;
+
+	/* Test invalid arguments */
+	FAIL_ON(image_format_block_height(info, 0) != 0);
+	FAIL_ON(image_format_block_height(info, -1) != 0);
+	FAIL_ON(image_format_block_height(info, 1) != 0);
+
+	/* Test 1 plane format */
+	info = image_format_drm_lookup(DRM_FORMAT_XRGB4444);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_block_height(info, 0) != 1);
+	FAIL_ON(image_format_block_height(info, 1) != 0);
+	FAIL_ON(image_format_block_height(info, -1) != 0);
+
+	/* Test 2 planes format */
+	info = image_format_drm_lookup(DRM_FORMAT_NV12);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_block_height(info, 0) != 1);
+	FAIL_ON(image_format_block_height(info, 1) != 1);
+	FAIL_ON(image_format_block_height(info, 2) != 0);
+	FAIL_ON(image_format_block_height(info, -1) != 0);
+
+	/* Test 3 planes format */
+	info = image_format_drm_lookup(DRM_FORMAT_YUV422);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_block_height(info, 0) != 1);
+	FAIL_ON(image_format_block_height(info, 1) != 1);
+	FAIL_ON(image_format_block_height(info, 2) != 1);
+	FAIL_ON(image_format_block_height(info, 3) != 0);
+	FAIL_ON(image_format_block_height(info, -1) != 0);
+
+	/* Test a tiled format */
+	info = image_format_drm_lookup(DRM_FORMAT_X0L0);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_block_height(info, 0) != 2);
+	FAIL_ON(image_format_block_height(info, 1) != 0);
+	FAIL_ON(image_format_block_height(info, -1) != 0);
+
+	return 0;
+}
+
+static int test_image_format_min_pitch(void)
+{
+	const struct image_format_info *info = NULL;
+
+	/* Test invalid arguments */
+	FAIL_ON(image_format_min_pitch(info, 0, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, -1, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, 1, 0) != 0);
+
+	/* Test 1 plane 8 bits per pixel format */
+	info = image_format_drm_lookup(DRM_FORMAT_RGB332);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_min_pitch(info, 0, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, -1, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, 1, 0) != 0);
+
+	FAIL_ON(image_format_min_pitch(info, 0, 1) != 1);
+	FAIL_ON(image_format_min_pitch(info, 0, 2) != 2);
+	FAIL_ON(image_format_min_pitch(info, 0, 640) != 640);
+	FAIL_ON(image_format_min_pitch(info, 0, 1024) != 1024);
+	FAIL_ON(image_format_min_pitch(info, 0, 1920) != 1920);
+	FAIL_ON(image_format_min_pitch(info, 0, 4096) != 4096);
+	FAIL_ON(image_format_min_pitch(info, 0, 671) != 671);
+	FAIL_ON(image_format_min_pitch(info, 0, UINT_MAX) !=
+			(uint64_t)UINT_MAX);
+	FAIL_ON(image_format_min_pitch(info, 0, (UINT_MAX - 1)) !=
+			(uint64_t)(UINT_MAX - 1));
+
+	/* Test 1 plane 16 bits per pixel format */
+	info = image_format_drm_lookup(DRM_FORMAT_XRGB4444);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_min_pitch(info, 0, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, -1, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, 1, 0) != 0);
+
+	FAIL_ON(image_format_min_pitch(info, 0, 1) != 2);
+	FAIL_ON(image_format_min_pitch(info, 0, 2) != 4);
+	FAIL_ON(image_format_min_pitch(info, 0, 640) != 1280);
+	FAIL_ON(image_format_min_pitch(info, 0, 1024) != 2048);
+	FAIL_ON(image_format_min_pitch(info, 0, 1920) != 3840);
+	FAIL_ON(image_format_min_pitch(info, 0, 4096) != 8192);
+	FAIL_ON(image_format_min_pitch(info, 0, 671) != 1342);
+	FAIL_ON(image_format_min_pitch(info, 0, UINT_MAX) !=
+			(uint64_t)UINT_MAX * 2);
+	FAIL_ON(image_format_min_pitch(info, 0, (UINT_MAX - 1)) !=
+			(uint64_t)(UINT_MAX - 1) * 2);
+
+	/* Test 1 plane 24 bits per pixel format */
+	info = image_format_drm_lookup(DRM_FORMAT_RGB888);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_min_pitch(info, 0, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, -1, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, 1, 0) != 0);
+
+	FAIL_ON(image_format_min_pitch(info, 0, 1) != 3);
+	FAIL_ON(image_format_min_pitch(info, 0, 2) != 6);
+	FAIL_ON(image_format_min_pitch(info, 0, 640) != 1920);
+	FAIL_ON(image_format_min_pitch(info, 0, 1024) != 3072);
+	FAIL_ON(image_format_min_pitch(info, 0, 1920) != 5760);
+	FAIL_ON(image_format_min_pitch(info, 0, 4096) != 12288);
+	FAIL_ON(image_format_min_pitch(info, 0, 671) != 2013);
+	FAIL_ON(image_format_min_pitch(info, 0, UINT_MAX) !=
+			(uint64_t)UINT_MAX * 3);
+	FAIL_ON(image_format_min_pitch(info, 0, UINT_MAX - 1) !=
+			(uint64_t)(UINT_MAX - 1) * 3);
+
+	/* Test 1 plane 32 bits per pixel format */
+	info = image_format_drm_lookup(DRM_FORMAT_ABGR8888);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_min_pitch(info, 0, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, -1, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, 1, 0) != 0);
+
+	FAIL_ON(image_format_min_pitch(info, 0, 1) != 4);
+	FAIL_ON(image_format_min_pitch(info, 0, 2) != 8);
+	FAIL_ON(image_format_min_pitch(info, 0, 640) != 2560);
+	FAIL_ON(image_format_min_pitch(info, 0, 1024) != 4096);
+	FAIL_ON(image_format_min_pitch(info, 0, 1920) != 7680);
+	FAIL_ON(image_format_min_pitch(info, 0, 4096) != 16384);
+	FAIL_ON(image_format_min_pitch(info, 0, 671) != 2684);
+	FAIL_ON(image_format_min_pitch(info, 0, UINT_MAX) !=
+			(uint64_t)UINT_MAX * 4);
+	FAIL_ON(image_format_min_pitch(info, 0, UINT_MAX - 1) !=
+			(uint64_t)(UINT_MAX - 1) * 4);
+
+	/* Test 2 planes format */
+	info = image_format_drm_lookup(DRM_FORMAT_NV12);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_min_pitch(info, 0, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, 1, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, -1, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, 2, 0) != 0);
+
+	FAIL_ON(image_format_min_pitch(info, 0, 1) != 1);
+	FAIL_ON(image_format_min_pitch(info, 1, 1) != 2);
+	FAIL_ON(image_format_min_pitch(info, 0, 2) != 2);
+	FAIL_ON(image_format_min_pitch(info, 1, 1) != 2);
+	FAIL_ON(image_format_min_pitch(info, 0, 640) != 640);
+	FAIL_ON(image_format_min_pitch(info, 1, 320) != 640);
+	FAIL_ON(image_format_min_pitch(info, 0, 1024) != 1024);
+	FAIL_ON(image_format_min_pitch(info, 1, 512) != 1024);
+	FAIL_ON(image_format_min_pitch(info, 0, 1920) != 1920);
+	FAIL_ON(image_format_min_pitch(info, 1, 960) != 1920);
+	FAIL_ON(image_format_min_pitch(info, 0, 4096) != 4096);
+	FAIL_ON(image_format_min_pitch(info, 1, 2048) != 4096);
+	FAIL_ON(image_format_min_pitch(info, 0, 671) != 671);
+	FAIL_ON(image_format_min_pitch(info, 1, 336) != 672);
+	FAIL_ON(image_format_min_pitch(info, 0, UINT_MAX) !=
+			(uint64_t)UINT_MAX);
+	FAIL_ON(image_format_min_pitch(info, 1, UINT_MAX / 2 + 1) !=
+			(uint64_t)UINT_MAX + 1);
+	FAIL_ON(image_format_min_pitch(info, 0, (UINT_MAX - 1)) !=
+			(uint64_t)(UINT_MAX - 1));
+	FAIL_ON(image_format_min_pitch(info, 1, (UINT_MAX - 1) /  2) !=
+			(uint64_t)(UINT_MAX - 1));
+
+	/* Test 3 planes 8 bits per pixel format */
+	info = image_format_drm_lookup(DRM_FORMAT_YUV422);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_min_pitch(info, 0, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, 1, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, 2, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, -1, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, 3, 0) != 0);
+
+	FAIL_ON(image_format_min_pitch(info, 0, 1) != 1);
+	FAIL_ON(image_format_min_pitch(info, 1, 1) != 1);
+	FAIL_ON(image_format_min_pitch(info, 2, 1) != 1);
+	FAIL_ON(image_format_min_pitch(info, 0, 2) != 2);
+	FAIL_ON(image_format_min_pitch(info, 1, 2) != 2);
+	FAIL_ON(image_format_min_pitch(info, 2, 2) != 2);
+	FAIL_ON(image_format_min_pitch(info, 0, 640) != 640);
+	FAIL_ON(image_format_min_pitch(info, 1, 320) != 320);
+	FAIL_ON(image_format_min_pitch(info, 2, 320) != 320);
+	FAIL_ON(image_format_min_pitch(info, 0, 1024) != 1024);
+	FAIL_ON(image_format_min_pitch(info, 1, 512) != 512);
+	FAIL_ON(image_format_min_pitch(info, 2, 512) != 512);
+	FAIL_ON(image_format_min_pitch(info, 0, 1920) != 1920);
+	FAIL_ON(image_format_min_pitch(info, 1, 960) != 960);
+	FAIL_ON(image_format_min_pitch(info, 2, 960) != 960);
+	FAIL_ON(image_format_min_pitch(info, 0, 4096) != 4096);
+	FAIL_ON(image_format_min_pitch(info, 1, 2048) != 2048);
+	FAIL_ON(image_format_min_pitch(info, 2, 2048) != 2048);
+	FAIL_ON(image_format_min_pitch(info, 0, 671) != 671);
+	FAIL_ON(image_format_min_pitch(info, 1, 336) != 336);
+	FAIL_ON(image_format_min_pitch(info, 2, 336) != 336);
+	FAIL_ON(image_format_min_pitch(info, 0, UINT_MAX) !=
+			(uint64_t)UINT_MAX);
+	FAIL_ON(image_format_min_pitch(info, 1, UINT_MAX / 2 + 1) !=
+			(uint64_t)UINT_MAX / 2 + 1);
+	FAIL_ON(image_format_min_pitch(info, 2, UINT_MAX / 2 + 1) !=
+			(uint64_t)UINT_MAX / 2 + 1);
+	FAIL_ON(image_format_min_pitch(info, 0, (UINT_MAX - 1) / 2) !=
+			(uint64_t)(UINT_MAX - 1) / 2);
+	FAIL_ON(image_format_min_pitch(info, 1, (UINT_MAX - 1) / 2) !=
+			(uint64_t)(UINT_MAX - 1) / 2);
+	FAIL_ON(image_format_min_pitch(info, 2, (UINT_MAX - 1) / 2) !=
+			(uint64_t)(UINT_MAX - 1) / 2);
+
+	/* Test tiled format */
+	info = image_format_drm_lookup(DRM_FORMAT_X0L2);
+	FAIL_ON(!info);
+	FAIL_ON(image_format_min_pitch(info, 0, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, -1, 0) != 0);
+	FAIL_ON(image_format_min_pitch(info, 1, 0) != 0);
+
+	FAIL_ON(image_format_min_pitch(info, 0, 1) != 2);
+	FAIL_ON(image_format_min_pitch(info, 0, 2) != 4);
+	FAIL_ON(image_format_min_pitch(info, 0, 640) != 1280);
+	FAIL_ON(image_format_min_pitch(info, 0, 1024) != 2048);
+	FAIL_ON(image_format_min_pitch(info, 0, 1920) != 3840);
+	FAIL_ON(image_format_min_pitch(info, 0, 4096) != 8192);
+	FAIL_ON(image_format_min_pitch(info, 0, 671) != 1342);
+	FAIL_ON(image_format_min_pitch(info, 0, UINT_MAX) !=
+			(uint64_t)UINT_MAX * 2);
+	FAIL_ON(image_format_min_pitch(info, 0, UINT_MAX - 1) !=
+			(uint64_t)(UINT_MAX - 1) * 2);
+
+	return 0;
+}
+
+#define selftest(test)	{ .name = #test, .func = test, }
+
+static struct image_format_test {
+	char	*name;
+	int	(*func)(void);
+} tests[] = {
+	selftest(test_image_format_block_height),
+	selftest(test_image_format_block_width),
+	selftest(test_image_format_min_pitch),
+};
+
+static int __init image_format_test_init(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		struct image_format_test *test = &tests[i];
+		int ret;
+
+		ret = test->func();
+		if (ret) {
+			pr_err("Failed test %s\n", test->name);
+			return ret;
+		}
+	}
+
+	pr_info("All tests executed properly.\n");
+	return 0;
+}
+
+static void __exit image_format_test_exit(void)
+{
+}
+module_init(image_format_test_init);
+module_exit(image_format_test_exit);
diff --git a/lib/image-formats.c b/lib/image-formats.c
new file mode 100644
index 000000000000..9b9a73220c5d
--- /dev/null
+++ b/lib/image-formats.c
@@ -0,0 +1,760 @@
+#include <linux/bug.h>
+#include <linux/image-formats.h>
+#include <linux/kernel.h>
+#include <linux/math64.h>
+
+#include <uapi/drm/drm_fourcc.h>
+
+static const struct image_format_info formats[] = {
+	{
+		.drm_fmt = DRM_FORMAT_C8,
+		.depth = 8,
+		.num_planes = 1,
+		.cpp = { 1, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGB332,
+		.depth = 8,
+		.num_planes = 1,
+		.cpp = { 1, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGR233,
+		.depth = 8,
+		.num_planes = 1,
+		.cpp = { 1, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_XRGB4444,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_XBGR4444,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGBX4444,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGRX4444,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_ARGB4444,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_ABGR4444,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGBA4444,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGRA4444,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_XRGB1555,
+		.depth = 15,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_XBGR1555,
+		.depth = 15,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGBX5551,
+		.depth = 15,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGRX5551,
+		.depth = 15,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_ARGB1555,
+		.depth = 15,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_ABGR1555,
+		.depth = 15,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGBA5551,
+		.depth = 15,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGRA5551,
+		.depth = 15,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGB565,
+		.depth = 16,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGR565,
+		.depth = 16,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGB888,
+		.depth = 24,
+		.num_planes = 1,
+		.cpp = { 3, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGR888,
+		.depth = 24,
+		.num_planes = 1,
+		.cpp = { 3, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_XRGB8888,
+		.depth = 24,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_XBGR8888,
+		.depth = 24,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGBX8888,
+		.depth = 24,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGRX8888,
+		.depth = 24,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGB565_A8,
+		.depth = 24,
+		.num_planes = 2,
+		.cpp = { 2, 1, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGR565_A8,
+		.depth = 24,
+		.num_planes = 2,
+		.cpp = { 2, 1, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_XRGB2101010,
+		.depth = 30,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_XBGR2101010,
+		.depth = 30,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGBX1010102,
+		.depth = 30,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGRX1010102,
+		.depth = 30,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+	}, {
+		.drm_fmt = DRM_FORMAT_ARGB2101010,
+		.depth = 30,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_ABGR2101010,
+		.depth = 30,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGBA1010102,
+		.depth = 30,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGRA1010102,
+		.depth = 30,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_ARGB8888,
+		.depth = 32,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_ABGR8888,
+		.depth = 32,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGBA8888,
+		.depth = 32,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGRA8888,
+		.depth = 32,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGB888_A8,
+		.depth = 32,
+		.num_planes = 2,
+		.cpp = { 3, 1, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGR888_A8,
+		.depth = 32,
+		.num_planes = 2,
+		.cpp = { 3, 1, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_XRGB8888_A8,
+		.depth = 32,
+		.num_planes = 2,
+		.cpp = { 4, 1, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_XBGR8888_A8,
+		.depth = 32,
+		.num_planes = 2,
+		.cpp = { 4, 1, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_RGBX8888_A8,
+		.depth = 32,
+		.num_planes = 2,
+		.cpp = { 4, 1, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_BGRX8888_A8,
+		.depth = 32,
+		.num_planes = 2,
+		.cpp = { 4, 1, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YUV410,
+		.depth = 0,
+		.num_planes = 3,
+		.cpp = { 1, 1, 1 },
+		.hsub = 4,
+		.vsub = 4,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YVU410,
+		.depth = 0,
+		.num_planes = 3,
+		.cpp = { 1, 1, 1 },
+		.hsub = 4,
+		.vsub = 4,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YUV411,
+		.depth = 0,
+		.num_planes = 3,
+		.cpp = { 1, 1, 1 },
+		.hsub = 4,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YVU411,
+		.depth = 0,
+		.num_planes = 3,
+		.cpp = { 1, 1, 1 },
+		.hsub = 4,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YUV420,
+		.depth = 0,
+		.num_planes = 3,
+		.cpp = { 1, 1, 1 },
+		.hsub = 2,
+		.vsub = 2,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YVU420,
+		.depth = 0,
+		.num_planes = 3,
+		.cpp = { 1, 1, 1 },
+		.hsub = 2,
+		.vsub = 2,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YUV422,
+		.depth = 0,
+		.num_planes = 3,
+		.cpp = { 1, 1, 1 },
+		.hsub = 2,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YVU422,
+		.depth = 0,
+		.num_planes = 3,
+		.cpp = { 1, 1, 1 },
+		.hsub = 2,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YUV444,
+		.depth = 0,
+		.num_planes = 3,
+		.cpp = { 1, 1, 1 },
+		.hsub = 1,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YVU444,
+		.depth = 0,
+		.num_planes = 3,
+		.cpp = { 1, 1, 1 },
+		.hsub = 1,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_NV12,
+		.depth = 0,
+		.num_planes = 2,
+		.cpp = { 1, 2, 0 },
+		.hsub = 2,
+		.vsub = 2,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_NV21,
+		.depth = 0,
+		.num_planes = 2,
+		.cpp = { 1, 2, 0 },
+		.hsub = 2,
+		.vsub = 2,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_NV16,
+		.depth = 0,
+		.num_planes = 2,
+		.cpp = { 1, 2, 0 },
+		.hsub = 2,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_NV61,
+		.depth = 0,
+		.num_planes = 2,
+		.cpp = { 1, 2, 0 },
+		.hsub = 2,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_NV24,
+		.depth = 0,
+		.num_planes = 2,
+		.cpp = { 1, 2, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_NV42,
+		.depth = 0,
+		.num_planes = 2,
+		.cpp = { 1, 2, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YUYV,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 2,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_YVYU,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 2,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_UYVY,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 2,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_VYUY,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 2, 0, 0 },
+		.hsub = 2,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_XYUV8888,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_AYUV,
+		.depth = 0,
+		.num_planes = 1,
+		.cpp = { 4, 0, 0 },
+		.hsub = 1,
+		.vsub = 1,
+		.has_alpha = true,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_Y0L0,
+		.depth = 0,
+		.num_planes = 1,
+		.char_per_block = { 8, 0, 0 },
+		.block_w = { 2, 0, 0 },
+		.block_h = { 2, 0, 0 },
+		.hsub = 2,
+		.vsub = 2,
+		.has_alpha = true,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_X0L0,
+		.depth = 0,
+		.num_planes = 1,
+		.char_per_block = { 8, 0, 0 },
+		.block_w = { 2, 0, 0 },
+		.block_h = { 2, 0, 0 },
+		.hsub = 2,
+		.vsub = 2,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_Y0L2,
+		.depth = 0,
+		.num_planes = 1,
+		.char_per_block = { 8, 0, 0 },
+		.block_w = { 2, 0, 0 },
+		.block_h = { 2, 0, 0 },
+		.hsub = 2,
+		.vsub = 2,
+		.has_alpha = true,
+		.is_yuv = true,
+	}, {
+		.drm_fmt = DRM_FORMAT_X0L2,
+		.depth = 0,
+		.num_planes = 1,
+		.char_per_block = { 8, 0, 0 },
+		.block_w = { 2, 0, 0 },
+		.block_h = { 2, 0, 0 },
+		.hsub = 2,
+		.vsub = 2,
+		.is_yuv = true,
+	},
+};
+
+#define __image_format_lookup(_field, _fmt)			\
+	({							\
+		const struct image_format_info *format = NULL;	\
+		unsigned i;					\
+								\
+		for (i = 0; i < ARRAY_SIZE(formats); i++)	\
+			if (formats[i]._field == _fmt)		\
+				format = &formats[i];		\
+								\
+		format;						\
+	})
+
+/**
+ * __image_format_drm_lookup - query information for a given format
+ * @drm: DRM fourcc pixel format (DRM_FORMAT_*)
+ *
+ * The caller should only pass a supported pixel format to this function.
+ *
+ * Returns:
+ * The instance of struct image_format_info that describes the pixel format, or
+ * NULL if the format is unsupported.
+ */
+const struct image_format_info *__image_format_drm_lookup(u32 drm)
+{
+	return __image_format_lookup(drm_fmt, drm);
+}
+EXPORT_SYMBOL(__image_format_drm_lookup);
+
+/**
+ * image_format_drm_lookup - query information for a given format
+ * @drm: DRM fourcc pixel format (DRM_FORMAT_*)
+ *
+ * The caller should only pass a supported pixel format to this function.
+ * Unsupported pixel formats will generate a warning in the kernel log.
+ *
+ * Returns:
+ * The instance of struct image_format_info that describes the pixel format, or
+ * NULL if the format is unsupported.
+ */
+const struct image_format_info *image_format_drm_lookup(u32 drm)
+{
+	const struct image_format_info *format;
+
+	format = __image_format_drm_lookup(drm);
+
+	WARN_ON(!format);
+	return format;
+}
+EXPORT_SYMBOL(image_format_drm_lookup);
+
+/**
+ * image_format_plane_cpp - determine the bytes per pixel value
+ * @format: pointer to the image_format
+ * @plane: plane index
+ *
+ * Returns:
+ * The bytes per pixel value for the specified plane.
+ */
+unsigned int image_format_plane_cpp(const struct image_format_info *format,
+				    int plane)
+{
+	if (!format || plane >= format->num_planes)
+		return 0;
+
+	return format->cpp[plane];
+}
+EXPORT_SYMBOL(image_format_plane_cpp);
+
+/**
+ * image_format_plane_width - width of the plane given the first plane
+ * @format: pointer to the image_format
+ * @width: width of the first plane
+ * @plane: plane index
+ *
+ * Returns:
+ * The width of @plane, given that the width of the first plane is @width.
+ */
+unsigned int image_format_plane_width(int width,
+				      const struct image_format_info *format,
+				      int plane)
+{
+	if (!format || plane >= format->num_planes)
+		return 0;
+
+	if (plane == 0)
+		return width;
+
+	return width / format->hsub;
+}
+EXPORT_SYMBOL(image_format_plane_width);
+
+/**
+ * image_format_plane_height - height of the plane given the first plane
+ * @format: pointer to the image_format
+ * @height: height of the first plane
+ * @plane: plane index
+ *
+ * Returns:
+ * The height of @plane, given that the height of the first plane is @height.
+ */
+unsigned int image_format_plane_height(int height,
+				       const struct image_format_info *format,
+				       int plane)
+{
+	if (!format || plane >= format->num_planes)
+		return 0;
+
+	if (plane == 0)
+		return height;
+
+	return height / format->vsub;
+}
+EXPORT_SYMBOL(image_format_plane_height);
+
+/**
+ * image_format_block_width - width in pixels of block.
+ * @format: pointer to the image_format
+ * @plane: plane index
+ *
+ * Returns:
+ * The width in pixels of a block, depending on the plane index.
+ */
+unsigned int image_format_block_width(const struct image_format_info *format,
+				      int plane)
+{
+	if (!format || plane < 0 || plane >= format->num_planes)
+		return 0;
+
+	if (!format->block_w[plane])
+		return 1;
+
+	return format->block_w[plane];
+}
+EXPORT_SYMBOL(image_format_block_width);
+
+/**
+ * image_format_block_height - height in pixels of a block
+ * @info: pointer to the image_format
+ * @plane: plane index
+ *
+ * Returns:
+ * The height in pixels of a block, depending on the plane index.
+ */
+unsigned int image_format_block_height(const struct image_format_info *format,
+				       int plane)
+{
+	if (!format || plane < 0 || plane >= format->num_planes)
+		return 0;
+
+	if (!format->block_h[plane])
+		return 1;
+
+	return format->block_h[plane];
+}
+EXPORT_SYMBOL(image_format_block_height);
+
+/**
+ * image_format_min_pitch - computes the minimum required pitch in bytes
+ * @info: pixel format info
+ * @plane: plane index
+ * @buffer_width: buffer width in pixels
+ *
+ * Returns:
+ * The minimum required pitch in bytes for a buffer by taking into consideration
+ * the pixel format information and the buffer width.
+ */
+uint64_t image_format_min_pitch(const struct image_format_info *info,
+				int plane, unsigned int buffer_width)
+{
+	if (!info || plane < 0 || plane >= info->num_planes)
+		return 0;
+
+	return DIV_ROUND_UP_ULL((u64)buffer_width * info->char_per_block[plane],
+			    image_format_block_width(info, plane) *
+			    image_format_block_height(info, plane));
+}
+EXPORT_SYMBOL(image_format_min_pitch);
-- 
git-series 0.9.1
