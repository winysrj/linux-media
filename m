Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37169 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbeKOVcI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 16:32:08 -0500
Received: by mail-wm1-f68.google.com with SMTP id p2-v6so17541547wmc.2
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 03:24:40 -0800 (PST)
From: Dafna Hirschfeld <dafna3@gmail.com>
To: helen.koike@collabora.com, hverkuil@xs4all.nl, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, Dafna Hirschfeld <dafna3@gmail.com>,
        outreachy-kernel@googlegroups.com
Subject: [PATCH vicodec v4 1/3] media: vicodec: prepare support for various number of planes
Date: Thu, 15 Nov 2018 13:23:30 +0200
Message-Id: <a1a9d0d1150c20e72f71a640ed658376c025388a.1541451484.git.dafna3@gmail.com>
In-Reply-To: <cover.1541451484.git.dafna3@gmail.com>
References: <cover.1541451484.git.dafna3@gmail.com>
In-Reply-To: <cover.1541451484.git.dafna3@gmail.com>
References: <cover.1541451484.git.dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add fields to the structs `fwht_raw_frame`, `v4l2_fwht_pixfmts`
to support various number of planes - formats
with alpha channel that have 4 planes and greyscale formats
that have 1 plane.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.c   |  2 +-
 drivers/media/platform/vicodec/codec-fwht.h   |  5 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 47 ++++++++++---------
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  3 +-
 drivers/media/platform/vicodec/vicodec-core.c |  2 +-
 5 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index 36656031b295..4ee6d7e0fbe2 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -760,7 +760,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 	rlco_max = rlco + size / 2 - 256;
 	encoding = encode_plane(frm->luma, ref_frm->luma, &rlco, rlco_max, cf,
 				frm->height, frm->width,
-				frm->luma_step, is_intra, next_is_intra);
+				frm->luma_alpha_step, is_intra, next_is_intra);
 	if (encoding & FWHT_FRAME_UNENCODED)
 		encoding |= FWHT_LUMA_UNENCODED;
 	encoding &= ~FWHT_FRAME_UNENCODED;
diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 3e9391fec5fe..743d78e112f8 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -104,9 +104,10 @@ struct fwht_raw_frame {
 	unsigned int width, height;
 	unsigned int width_div;
 	unsigned int height_div;
-	unsigned int luma_step;
+	unsigned int luma_alpha_step;
 	unsigned int chroma_step;
-	u8 *luma, *cb, *cr;
+	unsigned int components_num;
+	u8 *luma, *cb, *cr, *alpha;
 };
 
 #define FWHT_FRAME_PCODED	BIT(0)
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index e5b68fb38aac..b842636e71a9 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -11,27 +11,28 @@
 #include "codec-v4l2-fwht.h"
 
 static const struct v4l2_fwht_pixfmt_info v4l2_fwht_pixfmts[] = {
-	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2 },
-	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2 },
-	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1 },
-	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2 },
-	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2 },
-	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1 },
-	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1 },
-	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1 },
-	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1 },
-	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1 },
-	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1 },
-	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1 },
-	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2, 3},
+	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2, 3},
+	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1, 3},
+	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2, 3},
+	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2, 3},
+	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1, 3},
+	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1, 3},
+	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1, 3},
+	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1, 3},
+	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1, 3},
+	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1, 3},
+	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1, 3},
+	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1, 3},
+	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1, 3},
+	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1, 3},
+	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1, 3},
+	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1, 3},
+	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1, 3},
+	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1, 3},
+	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1, 3},
+	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1, 3},
+
 };
 
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat)
@@ -68,8 +69,10 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	rf.luma = p_in;
 	rf.width_div = info->width_div;
 	rf.height_div = info->height_div;
-	rf.luma_step = info->luma_step;
+	rf.luma_alpha_step = info->luma_alpha_step;
 	rf.chroma_step = info->chroma_step;
+	rf.alpha = NULL;
+	rf.components_num = info->components_num;
 
 	switch (info->id) {
 	case V4L2_PIX_FMT_YUV420:
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index 162465b78067..ed53e28d4f9c 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -13,11 +13,12 @@ struct v4l2_fwht_pixfmt_info {
 	unsigned int bytesperline_mult;
 	unsigned int sizeimage_mult;
 	unsigned int sizeimage_div;
-	unsigned int luma_step;
+	unsigned int luma_alpha_step;
 	unsigned int chroma_step;
 	/* Chroma plane subsampling */
 	unsigned int width_div;
 	unsigned int height_div;
+	unsigned int components_num;
 };
 
 struct v4l2_fwht_state {
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 1eb9132bfc85..fb6d5e9a06ab 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -61,7 +61,7 @@ struct pixfmt_info {
 };
 
 static const struct v4l2_fwht_pixfmt_info pixfmt_fwht = {
-	V4L2_PIX_FMT_FWHT, 0, 3, 1, 1, 1, 1, 1
+	V4L2_PIX_FMT_FWHT, 0, 3, 1, 1, 1, 1, 1, 0
 };
 
 static void vicodec_dev_release(struct device *dev)
-- 
2.17.1
