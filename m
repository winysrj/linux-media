Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC18C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 19:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFDC32075C
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 19:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfAIT5i (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 14:57:38 -0500
Received: from kozue.soulik.info ([108.61.200.231]:41688 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbfAIT52 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 14:57:28 -0500
Received: from misaki.sumomo.pri (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:401])
        by kozue.soulik.info (Postfix) with ESMTPA id 74B6C101811;
        Thu, 10 Jan 2019 04:58:10 +0900 (JST)
From:   Randy Li <ayaka@soulik.info>
To:     dri-devel@lists.freedesktop.org
Cc:     mchehab+samsung@kernel.org, mikhail.v.gavrilov@gmail.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        sakari.ailus@iki.fi, daniel@fooishbar.org, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, maarten.lankhorst@linux.intel.com,
        maxime.ripard@bootlin.com, sean@poorly.run, airlied@linux.ie,
        daniel@ffwll.ch, Randy Li <ayaka@soulik.info>
Subject: [PATCH v10 2/2] drm/fourcc: add a 10bits fully packed variant of NV12
Date:   Thu, 10 Jan 2019 03:57:10 +0800
Message-Id: <20190109195710.28501-3-ayaka@soulik.info>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190109195710.28501-1-ayaka@soulik.info>
References: <20190109195710.28501-1-ayaka@soulik.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This pixel format is a fully packed and 10bits variant of NV12.
A luma pixel would take 10bits in memory, without any
filled bits between pixels in a stride.

Signed-off-by: Randy Li <ayaka@soulik.info>
---
 drivers/gpu/drm/drm_fourcc.c  | 4 ++++
 include/uapi/drm/drm_fourcc.h | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index ba7e19d4336c..16d3be8278f1 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -247,6 +247,10 @@ const struct drm_format_info *__drm_format_info(u32 format)
 		{ .format = DRM_FORMAT_P016,		.depth = 0,  .num_planes = 2,
 		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
 		  .hsub = 2, .vsub = 2, .is_yuv = true},
+		{ .format = DRM_FORMAT_NV12_10LE40,	.depth = 0,  .num_planes = 2,
+		  .char_per_block = { 5, 5, 0 }, .block_w = { 4, 2, 0 }, .block_h = { 1, 1, 0 },
+		  .hsub = 2, .vsub = 2, .is_yuv = true },
+		},
 	};
 
 	unsigned int i;
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 8dd1328bc8d6..4985fb19b4ce 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -194,6 +194,14 @@ extern "C" {
 #define DRM_FORMAT_NV61		fourcc_code('N', 'V', '6', '1') /* 2x1 subsampled Cb:Cr plane */
 #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
 #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
+/*
+ * A fully packed  2 plane YCbCr
+ * Y1 0-9, Y2 10-19, Y3 20-29, Y4 20-39
+ * ....
+ * U1V1: 0-19, U2V2: 20-39
+ */
+#define DRM_FORMAT_NV12_10LE40	fourcc_code('R', 'K', '2', '0') /* 2x2 subsampled Cr:Cb plane */
+
 
 /*
  * 2 plane YCbCr MSB aligned
-- 
2.20.1

