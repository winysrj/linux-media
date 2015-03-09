Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:53894 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbbCIPrq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:47:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 18/29] vivid-tpg: add helper functions to simplify common calculations
Date: Mon,  9 Mar 2015 16:44:40 +0100
Message-Id: <1425915891-1017-19-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add helper functions to handle horizontal downscaling and horizontal
scaling.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 130 ++++++++++++++-----------------
 drivers/media/platform/vivid/vivid-tpg.h |  23 ++++++
 2 files changed, 80 insertions(+), 73 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 766cbf5..a919363 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -183,6 +183,9 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	tpg->recalc_colors = true;
 	tpg->vdownsampling[0] = 1;
 	tpg->hdownsampling[0] = 1;
+	tpg->hmask[0] = ~0;
+	tpg->hmask[1] = ~0;
+	tpg->hmask[2] = ~0;
 
 	switch (fourcc) {
 	case V4L2_PIX_FMT_RGB565:
@@ -231,6 +234,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_NV61:
 		tpg->vdownsampling[1] = 1;
 		tpg->hdownsampling[1] = 1;
+		tpg->hmask[1] = ~1;
 		tpg->planes = 2;
 		tpg->is_yuv = true;
 		break;
@@ -242,6 +246,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_NV21:
 		tpg->vdownsampling[1] = 2;
 		tpg->hdownsampling[1] = 1;
+		tpg->hmask[1] = ~1;
 		tpg->planes = 2;
 		tpg->is_yuv = true;
 		break;
@@ -249,6 +254,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YVYU:
 	case V4L2_PIX_FMT_VYUY:
+		tpg->hmask[0] = ~1;
 		tpg->is_yuv = true;
 		break;
 	default:
@@ -1116,6 +1122,7 @@ static void tpg_calculate_square_border(struct tpg_data *tpg)
 static void tpg_precalculate_line(struct tpg_data *tpg)
 {
 	enum tpg_color contrast;
+	u8 pix[TPG_MAX_PLANES][8];
 	unsigned pat;
 	unsigned p;
 	unsigned x;
@@ -1142,7 +1149,6 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
 		for (x = 0; x < tpg->scaled_width * 2; x += 2) {
 			unsigned real_x = src_x;
 			enum tpg_color color1, color2;
-			u8 pix[TPG_MAX_PLANES][8];
 
 			real_x = tpg->hflip ? tpg->src_width * 2 - real_x - 2 : real_x;
 			color1 = tpg_get_color(tpg, pat, real_x);
@@ -1170,8 +1176,7 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
 			for (p = 0; p < tpg->planes; p++) {
 				unsigned twopixsize = tpg->twopixelsize[p];
 				unsigned hdiv = tpg->hdownsampling[p];
-				u8 *pos = tpg->lines[pat][p] +
-						(x / hdiv) * twopixsize / 2;
+				u8 *pos = tpg->lines[pat][p] + tpg_hdiv(tpg, p, x);
 
 				memcpy(pos, pix[p], twopixsize / hdiv);
 			}
@@ -1185,50 +1190,38 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
 			unsigned next_pat = (pat + 1) % pat_lines;
 
 			for (p = 1; p < tpg->planes; p++) {
-				unsigned twopixsize = tpg->twopixelsize[p];
-				unsigned hdiv = tpg->hdownsampling[p];
-
-				for (x = 0; x < tpg->scaled_width * 2; x += 2) {
-					unsigned offset = (x / hdiv) * twopixsize / 2;
-					u8 *pos1 = tpg->lines[pat][p] + offset;
-					u8 *pos2 = tpg->lines[next_pat][p] + offset;
-					u8 *dest = tpg->downsampled_lines[pat][p] + offset;
-					unsigned i;
+				unsigned w = tpg_hdiv(tpg, p, tpg->scaled_width * 2);
+				u8 *pos1 = tpg->lines[pat][p];
+				u8 *pos2 = tpg->lines[next_pat][p];
+				u8 *dest = tpg->downsampled_lines[pat][p];
 
-					for (i = 0; i < twopixsize / hdiv; i++, dest++, pos1++, pos2++)
-						*dest = ((u16)*pos1 + (u16)*pos2) / 2;
-				}
+				for (x = 0; x < w; x++, pos1++, pos2++, dest++)
+					*dest = ((u16)*pos1 + (u16)*pos2) / 2;
 			}
 		}
 	}
 
-	for (x = 0; x < tpg->scaled_width; x += 2) {
-		u8 pix[TPG_MAX_PLANES][8];
-
-		gen_twopix(tpg, pix, contrast, 0);
-		gen_twopix(tpg, pix, contrast, 1);
-		for (p = 0; p < tpg->planes; p++) {
-			unsigned twopixsize = tpg->twopixelsize[p];
-			u8 *pos = tpg->contrast_line[p] + x * twopixsize / 2;
+	gen_twopix(tpg, pix, contrast, 0);
+	gen_twopix(tpg, pix, contrast, 1);
+	for (p = 0; p < tpg->planes; p++) {
+		unsigned twopixsize = tpg->twopixelsize[p];
+		u8 *pos = tpg->contrast_line[p];
 
+		for (x = 0; x < tpg->scaled_width; x += 2, pos += twopixsize)
 			memcpy(pos, pix[p], twopixsize);
-		}
 	}
-	for (x = 0; x < tpg->scaled_width; x += 2) {
-		u8 pix[TPG_MAX_PLANES][8];
 
-		gen_twopix(tpg, pix, TPG_COLOR_100_BLACK, 0);
-		gen_twopix(tpg, pix, TPG_COLOR_100_BLACK, 1);
-		for (p = 0; p < tpg->planes; p++) {
-			unsigned twopixsize = tpg->twopixelsize[p];
-			u8 *pos = tpg->black_line[p] + x * twopixsize / 2;
+	gen_twopix(tpg, pix, TPG_COLOR_100_BLACK, 0);
+	gen_twopix(tpg, pix, TPG_COLOR_100_BLACK, 1);
+	for (p = 0; p < tpg->planes; p++) {
+		unsigned twopixsize = tpg->twopixelsize[p];
+		u8 *pos = tpg->black_line[p];
 
+		for (x = 0; x < tpg->scaled_width; x += 2, pos += twopixsize)
 			memcpy(pos, pix[p], twopixsize);
-		}
 	}
-	for (x = 0; x < tpg->scaled_width * 2; x += 2) {
-		u8 pix[TPG_MAX_PLANES][8];
 
+	for (x = 0; x < tpg->scaled_width * 2; x += 2) {
 		gen_twopix(tpg, pix, TPG_COLOR_RANDOM, 0);
 		gen_twopix(tpg, pix, TPG_COLOR_RANDOM, 1);
 		for (p = 0; p < tpg->planes; p++) {
@@ -1238,6 +1231,7 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
 			memcpy(pos, pix[p], twopixsize);
 		}
 	}
+
 	gen_twopix(tpg, tpg->textbg, TPG_COLOR_TEXTBG, 0);
 	gen_twopix(tpg, tpg->textbg, TPG_COLOR_TEXTBG, 1);
 	gen_twopix(tpg, tpg->textfg, TPG_COLOR_TEXTFG, 0);
@@ -1529,9 +1523,8 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 	int hmax = (tpg->compose.height * tpg->perc_fill) / 100;
 	int h;
 	unsigned twopixsize = tpg->twopixelsize[p];
-	unsigned hdiv = tpg->hdownsampling[p];
 	unsigned vdiv = tpg->vdownsampling[p];
-	unsigned img_width = (tpg->compose.width / hdiv) * twopixsize / 2;
+	unsigned img_width = tpg_hdiv(tpg, p, tpg->compose.width);
 	unsigned line_offset;
 	unsigned left_pillar_width = 0;
 	unsigned right_pillar_start = img_width;
@@ -1547,28 +1540,25 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 
 	tpg_recalc(tpg);
 
-	mv_hor_old = (mv_hor_old * tpg->scaled_width / tpg->src_width) & ~1;
-	mv_hor_new = (mv_hor_new * tpg->scaled_width / tpg->src_width) & ~1;
+	mv_hor_old = tpg_hscale_div(tpg, p, mv_hor_old);
+	mv_hor_new = tpg_hscale_div(tpg, p, mv_hor_new);
 	wss_width = tpg->crop.left < tpg->src_width / 2 ?
 			tpg->src_width / 2 - tpg->crop.left : 0;
 	if (wss_width > tpg->crop.width)
 		wss_width = tpg->crop.width;
-	wss_width = wss_width * tpg->scaled_width / tpg->src_width;
+	wss_width = tpg_hscale_div(tpg, p, wss_width);
 
-	vbuf += tpg->compose.left * twopixsize / 2;
-	line_offset = tpg->crop.left * tpg->scaled_width / tpg->src_width;
-	line_offset = ((line_offset & ~1) / hdiv) * twopixsize / 2;
+	vbuf += tpg_hdiv(tpg, p, tpg->compose.left);
+	line_offset = tpg_hscale_div(tpg, p, tpg->crop.left);
 	if (tpg->crop.left < tpg->border.left) {
 		left_pillar_width = tpg->border.left - tpg->crop.left;
 		if (left_pillar_width > tpg->crop.width)
 			left_pillar_width = tpg->crop.width;
-		left_pillar_width = (left_pillar_width * tpg->scaled_width) / tpg->src_width;
-		left_pillar_width = ((left_pillar_width & ~1) / hdiv) * twopixsize / 2;
+		left_pillar_width = tpg_hscale_div(tpg, p, left_pillar_width);
 	}
 	if (tpg->crop.left + tpg->crop.width > tpg->border.left + tpg->border.width) {
 		right_pillar_start = tpg->border.left + tpg->border.width - tpg->crop.left;
-		right_pillar_start = (right_pillar_start * tpg->scaled_width) / tpg->src_width;
-		right_pillar_start = ((right_pillar_start & ~1) / hdiv) * twopixsize / 2;
+		right_pillar_start = tpg_hscale_div(tpg, p, right_pillar_start);
 		if (right_pillar_start > img_width)
 			right_pillar_start = img_width;
 	}
@@ -1651,10 +1641,8 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 
 			pat_line_old = tpg_get_pat_line(tpg, frame_line_old);
 			pat_line_new = tpg_get_pat_line(tpg, frame_line_new);
-			linestart_older = tpg->lines[pat_line_old][p] +
-				(mv_hor_old / hdiv) * twopixsize / 2;
-			linestart_newer = tpg->lines[pat_line_new][p] +
-				(mv_hor_new / hdiv) * twopixsize / 2;
+			linestart_older = tpg->lines[pat_line_old][p] + mv_hor_old;
+			linestart_newer = tpg->lines[pat_line_new][p] + mv_hor_new;
 
 			if (vdiv > 1) {
 				unsigned frame_line_next;
@@ -1679,8 +1667,7 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 					avg_pat = tpg_pattern_avg(tpg, pat_line_old, pat_line_new);
 					if (avg_pat < 0)
 						break;
-					linestart_older = tpg->downsampled_lines[avg_pat][p] +
-						(mv_hor_old / hdiv) * twopixsize / 2;
+					linestart_older = tpg->downsampled_lines[avg_pat][p] + mv_hor_old;
 					linestart_newer = linestart_older;
 					break;
 				case V4L2_FIELD_NONE:
@@ -1691,11 +1678,11 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 					avg_pat = tpg_pattern_avg(tpg, pat_line_old, pat_line_next_old);
 					if (avg_pat >= 0)
 						linestart_older = tpg->downsampled_lines[avg_pat][p] +
-							(mv_hor_old / hdiv) * twopixsize / 2;
+							mv_hor_old;
 					avg_pat = tpg_pattern_avg(tpg, pat_line_new, pat_line_next_new);
 					if (avg_pat >= 0)
 						linestart_newer = tpg->downsampled_lines[avg_pat][p] +
-							(mv_hor_new / hdiv) * twopixsize / 2;
+							mv_hor_new;
 					break;
 				}
 			}
@@ -1739,22 +1726,10 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			memcpy(vbuf + buf_line * stride, linestart_older, img_width);
 			break;
 		}
-
-		if (is_tv && !is_60hz && frame_line == 0 && wss_width) {
-			/*
-			 * Replace the first half of the top line of a 50 Hz frame
-			 * with random data to simulate a WSS signal.
-			 */
-			u8 *wss = tpg->random_line[p] +
-				  twopixsize * prandom_u32_max(tpg->src_width / 2);
-
-			memcpy(vbuf + buf_line * stride, wss,
-			       (wss_width / hdiv) * twopixsize / 2);
-		}
 	}
 
 	vbuf = orig_vbuf;
-	vbuf += (tpg->compose.left / hdiv) * twopixsize / 2;
+	vbuf += tpg_hdiv(tpg, p, tpg->compose.left);
 	src_y = 0;
 	error = 0;
 	for (h = 0; h < tpg->compose.height; h++) {
@@ -1777,6 +1752,17 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			buf_line /= vdiv;
 		}
 
+		if (is_tv && !is_60hz && frame_line == 0 && wss_width) {
+			/*
+			 * Replace the first half of the top line of a 50 Hz frame
+			 * with random data to simulate a WSS signal.
+			 */
+			u8 *wss = tpg->random_line[p] +
+				  twopixsize * prandom_u32_max(tpg->src_width / 2);
+
+			memcpy(vbuf + buf_line * stride, wss, wss_width);
+		}
+
 		if (tpg->show_border && frame_line >= b->top &&
 		    frame_line < b->top + b->height) {
 			unsigned bottom = b->top + b->height - 1;
@@ -1818,14 +1804,12 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			if (c->left + c->width < left + width)
 				width -= left + width - c->left - c->width;
 			left -= c->left;
-			left = (left * tpg->scaled_width) / tpg->src_width;
-			left = ((left & ~1) / hdiv) * twopixsize / 2;
-			width = (width * tpg->scaled_width) / tpg->src_width;
-			width = ((width & ~1) / hdiv) * twopixsize / 2;
+			left = tpg_hscale_div(tpg, p, left);
+			width = tpg_hscale_div(tpg, p, width);
 			memcpy(vbuf + buf_line * stride + left, tpg->contrast_line[p], width);
 		}
 		if (tpg->insert_sav) {
-			unsigned offset = (tpg->compose.width / (6 * hdiv)) * twopixsize;
+			unsigned offset = tpg_hdiv(tpg, p, tpg->compose.width / 3);
 			u8 *p = vbuf + buf_line * stride + offset;
 			unsigned vact = 0, hact = 0;
 
@@ -1839,7 +1823,7 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 				(hact ^ vact ^ f);
 		}
 		if (tpg->insert_eav) {
-			unsigned offset = (tpg->compose.width / (6 * hdiv)) * 2 * twopixsize;
+			unsigned offset = tpg_hdiv(tpg, p, tpg->compose.width * 2 / 3);
 			u8 *p = vbuf + buf_line * stride + offset;
 			unsigned vact = 0, hact = 1;
 
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index 5a53eb9..b62f392 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -142,6 +142,11 @@ struct tpg_data {
 	unsigned			planes;
 	u8				vdownsampling[TPG_MAX_PLANES];
 	u8				hdownsampling[TPG_MAX_PLANES];
+	/*
+	 * horizontal positions must be ANDed with this value to enforce
+	 * correct boundaries for packed YUYV values.
+	 */
+	unsigned			hmask[TPG_MAX_PLANES];
 	/* Used to store the colors in native format, either RGB or YUV */
 	u8				colors[TPG_COLOR_MAX][3];
 	u8				textfg[TPG_MAX_PLANES][8], textbg[TPG_MAX_PLANES][8];
@@ -347,6 +352,24 @@ static inline unsigned tpg_g_twopixelsize(const struct tpg_data *tpg, unsigned p
 	return tpg->twopixelsize[plane];
 }
 
+static inline unsigned tpg_hdiv(const struct tpg_data *tpg,
+				  unsigned plane, unsigned x)
+{
+	return ((x / tpg->hdownsampling[plane]) & tpg->hmask[plane]) *
+		tpg->twopixelsize[plane] / 2;
+}
+
+static inline unsigned tpg_hscale(const struct tpg_data *tpg, unsigned x)
+{
+	return (x * tpg->scaled_width) / tpg->src_width;
+}
+
+static inline unsigned tpg_hscale_div(const struct tpg_data *tpg,
+				      unsigned plane, unsigned x)
+{
+	return tpg_hdiv(tpg, plane, tpg_hscale(tpg, x));
+}
+
 static inline unsigned tpg_g_bytesperline(const struct tpg_data *tpg, unsigned plane)
 {
 	return tpg->bytesperline[plane];
-- 
2.1.4

