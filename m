Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47716 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153AbbCIPrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:47:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 16/29] vivid-tpg: add support for more planar formats
Date: Mon,  9 Mar 2015 16:44:38 +0100
Message-Id: <1425915891-1017-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that the support for hor/vert downsampled planar formats is in
place we can add support for such formats to the TPG.

This patch adds support for:

V4L2_PIX_FMT_YUV420M
V4L2_PIX_FMT_YVU420M
V4L2_PIX_FMT_YUV420
V4L2_PIX_FMT_YVU420
V4L2_PIX_FMT_YUV422P
V4L2_PIX_FMT_NV16
V4L2_PIX_FMT_NV61
V4L2_PIX_FMT_NV12
V4L2_PIX_FMT_NV21
V4L2_PIX_FMT_NV12P
V4L2_PIX_FMT_NV21P

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 90 +++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 7d8e87e..19b5806 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -201,13 +201,49 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_ABGR32:
 		tpg->is_yuv = false;
 		break;
+	case V4L2_PIX_FMT_YUV420M:
+	case V4L2_PIX_FMT_YVU420M:
+		tpg->buffers = 3;
+		/* fall through */
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		tpg->vdownsampling[1] = 2;
+		tpg->vdownsampling[2] = 2;
+		tpg->hdownsampling[1] = 2;
+		tpg->hdownsampling[2] = 2;
+		tpg->planes = 3;
+		tpg->is_yuv = true;
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		tpg->vdownsampling[1] = 1;
+		tpg->vdownsampling[2] = 1;
+		tpg->hdownsampling[1] = 2;
+		tpg->hdownsampling[2] = 2;
+		tpg->planes = 3;
+		tpg->is_yuv = true;
+		break;
 	case V4L2_PIX_FMT_NV16M:
 	case V4L2_PIX_FMT_NV61M:
+		tpg->buffers = 2;
+		/* fall through */
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
 		tpg->vdownsampling[1] = 1;
 		tpg->hdownsampling[1] = 1;
+		tpg->planes = 2;
+		tpg->is_yuv = true;
+		break;
+	case V4L2_PIX_FMT_NV12M:
+	case V4L2_PIX_FMT_NV21M:
 		tpg->buffers = 2;
+		/* fall through */
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+		tpg->vdownsampling[1] = 2;
+		tpg->hdownsampling[1] = 1;
 		tpg->planes = 2;
-		/* fall-through */
+		tpg->is_yuv = true;
+		break;
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YVYU:
@@ -243,11 +279,29 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_ABGR32:
 		tpg->twopixelsize[0] = 2 * 4;
 		break;
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV12M:
+	case V4L2_PIX_FMT_NV21M:
+		tpg->twopixelsize[0] = 2;
+		tpg->twopixelsize[1] = 2;
+		break;
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
 	case V4L2_PIX_FMT_NV16M:
 	case V4L2_PIX_FMT_NV61M:
 		tpg->twopixelsize[0] = 2;
 		tpg->twopixelsize[1] = 2;
 		break;
+	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_YUV420M:
+	case V4L2_PIX_FMT_YVU420M:
+		tpg->twopixelsize[0] = 2;
+		tpg->twopixelsize[1] = 2;
+		tpg->twopixelsize[2] = 2;
+		break;
 	}
 	return true;
 }
@@ -685,6 +739,37 @@ static void gen_twopix(struct tpg_data *tpg,
 	b_v = tpg->colors[color][2]; /* B or precalculated V */
 
 	switch (tpg->fourcc) {
+	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YUV420M:
+		buf[0][offset] = r_y;
+		if (odd) {
+			buf[1][0] = (buf[1][0] + g_u) / 2;
+			buf[2][0] = (buf[2][0] + b_v) / 2;
+			buf[1][1] = buf[1][0];
+			buf[2][1] = buf[2][0];
+			break;
+		}
+		buf[1][0] = g_u;
+		buf[2][0] = b_v;
+		break;
+	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_YVU420M:
+		buf[0][offset] = r_y;
+		if (odd) {
+			buf[1][0] = (buf[1][0] + b_v) / 2;
+			buf[2][0] = (buf[2][0] + g_u) / 2;
+			buf[1][1] = buf[1][0];
+			buf[2][1] = buf[2][0];
+			break;
+		}
+		buf[1][0] = b_v;
+		buf[2][0] = g_u;
+		break;
+
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV12M:
+	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV16M:
 		buf[0][offset] = r_y;
 		if (odd) {
@@ -695,6 +780,9 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[1][0] = g_u;
 		buf[1][1] = b_v;
 		break;
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV21M:
+	case V4L2_PIX_FMT_NV61:
 	case V4L2_PIX_FMT_NV61M:
 		buf[0][offset] = r_y;
 		if (odd) {
-- 
2.1.4

