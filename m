Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:53894 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081AbbCIPql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:46:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/29] vivid-tpg: add hor/vert downsampling fields
Date: Mon,  9 Mar 2015 16:44:33 +0100
Message-Id: <1425915891-1017-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is step one of supporting horizontal and vertical downsampling.
This just adds support for the h/vdownsampling fields and it increases
the maximum number of planes to 3.

Currently none of the planar formats need horizontal or vertical
downsampling, so this change has no effect at the moment.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c |  7 ++++++-
 drivers/media/platform/vivid/vivid-tpg.h | 15 ++++++++++-----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 767879e0..9f47387 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -172,6 +172,8 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	tpg->planes = 1;
 	tpg->buffers = 1;
 	tpg->recalc_colors = true;
+	tpg->vdownsampling[0] = 1;
+	tpg->hdownsampling[0] = 1;
 
 	switch (fourcc) {
 	case V4L2_PIX_FMT_RGB565:
@@ -192,6 +194,8 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		break;
 	case V4L2_PIX_FMT_NV16M:
 	case V4L2_PIX_FMT_NV61M:
+		tpg->vdownsampling[1] = 1;
+		tpg->hdownsampling[1] = 1;
 		tpg->buffers = 2;
 		tpg->planes = 2;
 		/* fall-through */
@@ -273,7 +277,8 @@ void tpg_reset_source(struct tpg_data *tpg, unsigned width, unsigned height,
 	tpg->compose.width = width;
 	tpg->compose.height = tpg->buf_height;
 	for (p = 0; p < tpg->planes; p++)
-		tpg->bytesperline[p] = width * tpg->twopixelsize[p] / 2;
+		tpg->bytesperline[p] = (width * tpg->twopixelsize[p]) /
+				       (2 * tpg->hdownsampling[p]);
 	tpg->recalc_square_border = true;
 }
 
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index b90ce7d..cec5bb4 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -90,7 +90,7 @@ enum tpg_move_mode {
 
 extern const char * const tpg_aspect_strings[];
 
-#define TPG_MAX_PLANES 2
+#define TPG_MAX_PLANES 3
 #define TPG_MAX_PAT_LINES 8
 
 struct tpg_data {
@@ -140,6 +140,8 @@ struct tpg_data {
 	unsigned			real_rgb_range;
 	unsigned			buffers;
 	unsigned			planes;
+	u8				vdownsampling[TPG_MAX_PLANES];
+	u8				hdownsampling[TPG_MAX_PLANES];
 	/* Used to store the colors in native format, either RGB or YUV */
 	u8				colors[TPG_COLOR_MAX][3];
 	u8				textfg[TPG_MAX_PLANES][8], textbg[TPG_MAX_PLANES][8];
@@ -361,10 +363,11 @@ static inline void tpg_s_bytesperline(struct tpg_data *tpg, unsigned plane, unsi
 	for (p = 0; p < tpg->planes; p++) {
 		unsigned plane_w = bpl * tpg->twopixelsize[p] / tpg->twopixelsize[0];
 
-		tpg->bytesperline[p] = plane_w;
+		tpg->bytesperline[p] = plane_w / tpg->hdownsampling[p];
 	}
 }
 
+
 static inline unsigned tpg_g_line_width(const struct tpg_data *tpg, unsigned plane)
 {
 	unsigned w = 0;
@@ -375,7 +378,7 @@ static inline unsigned tpg_g_line_width(const struct tpg_data *tpg, unsigned pla
 	for (p = 0; p < tpg->planes; p++) {
 		unsigned plane_w = tpg_g_bytesperline(tpg, p);
 
-		w += plane_w;
+		w += plane_w / tpg->vdownsampling[p];
 	}
 	return w;
 }
@@ -391,7 +394,8 @@ static inline unsigned tpg_calc_line_width(const struct tpg_data *tpg,
 	for (p = 0; p < tpg->planes; p++) {
 		unsigned plane_w = bpl * tpg->twopixelsize[p] / tpg->twopixelsize[0];
 
-		w += plane_w;
+		plane_w /= tpg->hdownsampling[p];
+		w += plane_w / tpg->vdownsampling[p];
 	}
 	return w;
 }
@@ -401,7 +405,8 @@ static inline unsigned tpg_calc_plane_size(const struct tpg_data *tpg, unsigned
 	if (plane >= tpg->planes)
 		return 0;
 
-	return tpg_g_bytesperline(tpg, plane) * tpg->buf_height;
+	return tpg_g_bytesperline(tpg, plane) * tpg->buf_height /
+	       tpg->vdownsampling[plane];
 }
 
 static inline void tpg_s_buf_height(struct tpg_data *tpg, unsigned h)
-- 
2.1.4

