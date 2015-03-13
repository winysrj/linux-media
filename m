Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:51429 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753565AbbCMLRG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:17:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 33/39] vivid: add support for NV24 and NV42
Date: Fri, 13 Mar 2015 12:16:11 +0100
Message-Id: <1426245377-17704-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
References: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the YUV 4:4:4 formats NV24 and NV42.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c        | 28 +++++++++++++++++++++++--
 drivers/media/platform/vivid/vivid-vid-common.c | 18 ++++++++++++++++
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index e4d461a..787747b 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -123,7 +123,7 @@ int tpg_alloc(struct tpg_data *tpg, unsigned max_w)
 	tpg->max_line_width = max_w;
 	for (pat = 0; pat < TPG_MAX_PAT_LINES; pat++) {
 		for (plane = 0; plane < TPG_MAX_PLANES; plane++) {
-			unsigned pixelsz = plane ? 1 : 4;
+			unsigned pixelsz = plane ? 2 : 4;
 
 			tpg->lines[pat][plane] = vzalloc(max_w * 2 * pixelsz);
 			if (!tpg->lines[pat][plane])
@@ -136,7 +136,7 @@ int tpg_alloc(struct tpg_data *tpg, unsigned max_w)
 		}
 	}
 	for (plane = 0; plane < TPG_MAX_PLANES; plane++) {
-		unsigned pixelsz = plane ? 1 : 4;
+		unsigned pixelsz = plane ? 2 : 4;
 
 		tpg->contrast_line[plane] = vzalloc(max_w * pixelsz);
 		if (!tpg->contrast_line[plane])
@@ -255,6 +255,13 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->planes = 2;
 		tpg->is_yuv = true;
 		break;
+	case V4L2_PIX_FMT_NV24:
+	case V4L2_PIX_FMT_NV42:
+		tpg->vdownsampling[1] = 1;
+		tpg->hdownsampling[1] = 1;
+		tpg->planes = 2;
+		tpg->is_yuv = true;
+		break;
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YVYU:
@@ -322,6 +329,11 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->twopixelsize[1] = 2;
 		tpg->twopixelsize[2] = 2;
 		break;
+	case V4L2_PIX_FMT_NV24:
+	case V4L2_PIX_FMT_NV42:
+		tpg->twopixelsize[0] = 2;
+		tpg->twopixelsize[1] = 4;
+		break;
 	}
 	return true;
 }
@@ -826,6 +838,18 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[1][1] = g_u;
 		break;
 
+	case V4L2_PIX_FMT_NV24:
+		buf[0][offset] = r_y;
+		buf[1][2 * offset] = g_u;
+		buf[1][2 * offset + 1] = b_v;
+		break;
+
+	case V4L2_PIX_FMT_NV42:
+		buf[0][offset] = r_y;
+		buf[1][2 * offset] = b_v;
+		buf[1][2 * offset + 1] = g_u;
+		break;
+
 	case V4L2_PIX_FMT_YUYV:
 		buf[0][offset] = r_y;
 		if (odd) {
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 81e6c82..aa89850 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -144,6 +144,24 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
+		.name     = "YUV 4:4:4 biplanar",
+		.fourcc   = V4L2_PIX_FMT_NV24,
+		.vdownsampling = { 1, 1 },
+		.bit_depth = { 8, 16 },
+		.is_yuv   = true,
+		.planes   = 2,
+		.buffers = 1,
+	},
+	{
+		.name     = "YVU 4:4:4 biplanar",
+		.fourcc   = V4L2_PIX_FMT_NV42,
+		.vdownsampling = { 1, 1 },
+		.bit_depth = { 8, 16 },
+		.is_yuv   = true,
+		.planes   = 2,
+		.buffers = 1,
+	},
+	{
 		.name     = "Monochrome",
 		.fourcc   = V4L2_PIX_FMT_GREY,
 		.vdownsampling = { 1 },
-- 
2.1.4

