Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0509CC43444
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 19:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC1F32075C
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 19:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbfAIT51 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 14:57:27 -0500
Received: from kozue.soulik.info ([108.61.200.231]:41664 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfAIT51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 14:57:27 -0500
Received: from misaki.sumomo.pri (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:401])
        by kozue.soulik.info (Postfix) with ESMTPA id 64D19101784;
        Thu, 10 Jan 2019 04:58:08 +0900 (JST)
From:   Randy Li <ayaka@soulik.info>
To:     dri-devel@lists.freedesktop.org
Cc:     mchehab+samsung@kernel.org, mikhail.v.gavrilov@gmail.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        sakari.ailus@iki.fi, daniel@fooishbar.org, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, maarten.lankhorst@linux.intel.com,
        maxime.ripard@bootlin.com, sean@poorly.run, airlied@linux.ie,
        daniel@ffwll.ch, Randy Li <ayaka@soulik.info>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Clint Taylor <clinton.a.taylor@intel.com>
Subject: [PATCH v10 1/2] drm/fourcc: Add new P010, P016 video format
Date:   Thu, 10 Jan 2019 03:57:09 +0800
Message-Id: <20190109195710.28501-2-ayaka@soulik.info>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190109195710.28501-1-ayaka@soulik.info>
References: <20190109195710.28501-1-ayaka@soulik.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits per
channel video format.

P012 is a planar 4:2:0 YUV 12 bits per channel

P016 is a planar 4:2:0 YUV with interleaved UV plane, 16 bits per
channel video format.

V3: Added P012 and fixed cpp for P010.
V4: format definition refined per review.
V5: Format comment block for each new pixel format.
V6: reversed Cb/Cr order in comments.
v7: reversed Cb/Cr order in comments of header files, remove
the wrong part of commit message.
V8: reversed V7 changes except commit message and rebased.
v9: used the new properties to describe those format and
rebased.

Cc: Daniel Stone <daniel@fooishbar.org>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>

Signed-off-by: Randy Li <ayaka@soulik.info>
Signed-off-by: Clint Taylor <clinton.a.taylor@intel.com>
---
 drivers/gpu/drm/drm_fourcc.c  |  9 +++++++++
 include/uapi/drm/drm_fourcc.h | 21 +++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index d90ee03a84c6..ba7e19d4336c 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -238,6 +238,15 @@ const struct drm_format_info *__drm_format_info(u32 format)
 		{ .format = DRM_FORMAT_X0L2,		.depth = 0,  .num_planes = 1,
 		  .char_per_block = { 8, 0, 0 }, .block_w = { 2, 0, 0 }, .block_h = { 2, 0, 0 },
 		  .hsub = 2, .vsub = 2, .is_yuv = true },
+		{ .format = DRM_FORMAT_P010,            .depth = 0,  .num_planes = 2,
+		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
+		  .hsub = 2, .vsub = 2, .is_yuv = true},
+		{ .format = DRM_FORMAT_P012,		.depth = 0,  .num_planes = 2,
+		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
+		   .hsub = 2, .vsub = 2, .is_yuv = true},
+		{ .format = DRM_FORMAT_P016,		.depth = 0,  .num_planes = 2,
+		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
+		  .hsub = 2, .vsub = 2, .is_yuv = true},
 	};
 
 	unsigned int i;
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 0b44260a5ee9..8dd1328bc8d6 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -195,6 +195,27 @@ extern "C" {
 #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
 #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
 
+/*
+ * 2 plane YCbCr MSB aligned
+ * index 0 = Y plane, [15:0] Y:x [10:6] little endian
+ * index 1 = Cr:Cb plane, [31:0] Cr:x:Cb:x [10:6:10:6] little endian
+ */
+#define DRM_FORMAT_P010		fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel */
+
+/*
+ * 2 plane YCbCr MSB aligned
+ * index 0 = Y plane, [15:0] Y:x [12:4] little endian
+ * index 1 = Cr:Cb plane, [31:0] Cr:x:Cb:x [12:4:12:4] little endian
+ */
+#define DRM_FORMAT_P012		fourcc_code('P', '0', '1', '2') /* 2x2 subsampled Cr:Cb plane 12 bits per channel */
+
+/*
+ * 2 plane YCbCr MSB aligned
+ * index 0 = Y plane, [15:0] Y little endian
+ * index 1 = Cr:Cb plane, [31:0] Cr:Cb [16:16] little endian
+ */
+#define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cr:Cb plane 16 bits per channel */
+
 /*
  * 3 plane YCbCr
  * index 0: Y plane, [7:0] Y
-- 
2.20.1

