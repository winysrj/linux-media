Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C805C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35408218AE
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfCAIUA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 03:20:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:11607 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727755AbfCAIUA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 03:20:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Mar 2019 00:20:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,426,1544515200"; 
   d="scan'208";a="130339940"
Received: from genxfsim-shark-bay-client-platform.iind.intel.com ([10.223.25.3])
  by orsmga003.jf.intel.com with ESMTP; 01 Mar 2019 00:19:55 -0800
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
Subject: [PATCH 4/6] drm: Add Y2xx and Y4xx (xx:10/12/16) format definitions and fourcc
Date:   Fri,  1 Mar 2019 13:46:25 +0530
Message-Id: <1551428187-12535-5-git-send-email-swati2.sharma@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551428187-12535-1-git-send-email-swati2.sharma@intel.com>
References: <1551428187-12535-1-git-send-email-swati2.sharma@intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Swati Sharma <swati2.sharma@intel.com>

The following pixel formats are packed format that follows 4:2:2
chroma sampling. For memory represenation each component is
allocated 16 bits each. Thus each pixel occupies 32bit.

Y210:	For each component, valid data occupies MSB 10 bits.
	LSB 6 bits are filled with zeroes.
Y212:	For each component, valid data occupies MSB 12 bits.
	LSB 4 bits are filled with zeroes.
Y216:	For each component valid data occupies 16 bits,
	doesn't require any padding bits.

First 16 bits stores the Y value and the next 16 bits stores one
of the chroma samples alternatively. The first luma sample will
be accompanied by first U sample and second luma sample is
accompanied by the first V sample.

The following pixel formats are packed format that follows 4:4:4
chroma sampling. Channels are arranged in the order UYVA in
increasing memory order.

Y410:	Each color component occupies 10 bits and X component
	takes 2 bits, thus each pixel occupies 32 bits.
Y412:   Each color component is 16 bits where valid data
	occupies MSB 12 bits. LSB 4 bits are filled with zeroes.
	Thus, each pixel occupies 64 bits.
Y416:   Each color component occupies 16 bits for valid data,
	doesn't require any padding bits. Thus, each pixel
	occupies 64 bits.

Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
Signed-off-by: Vidya Srinivas <vidya.srinivas@intel.com>
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
---
 drivers/gpu/drm/drm_fourcc.c  |  6 ++++++
 include/uapi/drm/drm_fourcc.h | 18 +++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index ba7e19d..45c9882 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -226,6 +226,12 @@ const struct drm_format_info *__drm_format_info(u32 format)
 		{ .format = DRM_FORMAT_VYUY,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
 		{ .format = DRM_FORMAT_XYUV8888,	.depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .is_yuv = true },
 		{ .format = DRM_FORMAT_AYUV,		.depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true, .is_yuv = true },
+		{ .format = DRM_FORMAT_Y210,            .depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
+		{ .format = DRM_FORMAT_Y212,            .depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
+		{ .format = DRM_FORMAT_Y216,            .depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
+		{ .format = DRM_FORMAT_Y410,            .depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .is_yuv = true },
+		{ .format = DRM_FORMAT_Y412,            .depth = 0,  .num_planes = 1, .cpp = { 8, 0, 0 }, .hsub = 1, .vsub = 1, .is_yuv = true },
+		{ .format = DRM_FORMAT_Y416,            .depth = 0,  .num_planes = 1, .cpp = { 8, 0, 0 }, .hsub = 1, .vsub = 1, .is_yuv = true },
 		{ .format = DRM_FORMAT_Y0L0,		.depth = 0,  .num_planes = 1,
 		  .char_per_block = { 8, 0, 0 }, .block_w = { 2, 0, 0 }, .block_h = { 2, 0, 0 },
 		  .hsub = 2, .vsub = 2, .has_alpha = true, .is_yuv = true },
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index bab2029..6e20ced 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -151,7 +151,23 @@
 #define DRM_FORMAT_VYUY		fourcc_code('V', 'Y', 'U', 'Y') /* [31:0] Y1:Cb0:Y0:Cr0 8:8:8:8 little endian */
 
 #define DRM_FORMAT_AYUV		fourcc_code('A', 'Y', 'U', 'V') /* [31:0] A:Y:Cb:Cr 8:8:8:8 little endian */
-#define DRM_FORMAT_XYUV8888		fourcc_code('X', 'Y', 'U', 'V') /* [31:0] X:Y:Cb:Cr 8:8:8:8 little endian */
+#define DRM_FORMAT_XYUV8888	fourcc_code('X', 'Y', 'U', 'V') /* [31:0] X:Y:Cb:Cr 8:8:8:8 little endian */
+
+/*
+ * packed Y2xx indicate for each component, xx valid data occupy msb
+ * 16-xx padding occupy lsb
+ */
+#define DRM_FORMAT_Y210         fourcc_code('Y', '2', '1', '0') /* [63:0] Y0:x:Cb0:x:Y1:x:Cr1:x 10:6:10:6:10:6:10:6 little endian per 2 Y pixels */
+#define DRM_FORMAT_Y212         fourcc_code('Y', '2', '1', '2') /* [63:0] Y0:x:Cb0:x:Y1:x:Cr1:x 12:4:12:4:12:4:12:4 little endian per 2 Y pixels */
+#define DRM_FORMAT_Y216         fourcc_code('Y', '2', '1', '6') /* [63:0] Y0:Cb0:Y1:Cr1 16:16:16:16 little endian per 2 Y pixels */
+
+/*
+ * packed Y4xx indicate for each component, xx valid data occupy msb
+ * 16-xx padding occupy lsb except Y410
+ */
+#define DRM_FORMAT_Y410         fourcc_code('Y', '4', '1', '0') /* [31:0] X:V:Y:U 2:10:10:10 little endian */
+#define DRM_FORMAT_Y412         fourcc_code('Y', '4', '1', '2') /* [63:0] X:x:V:x:Y:x:U:x 12:4:12:4:12:4:12:4 little endian */
+#define DRM_FORMAT_Y416         fourcc_code('Y', '4', '1', '6') /* [63:0] X:V:Y:U 16:16:16:16 little endian */
 
 /*
  * packed YCbCr420 2x2 tiled formats
-- 
1.9.1

