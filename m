Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:39660 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbbCIP4Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:56:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 25/29] vivid-tpg: split off the pattern drawing code.
Date: Mon,  9 Mar 2015 16:44:47 +0100
Message-Id: <1425915891-1017-26-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The last part of the vivid-tpg refactoring: split off the pattern
drawing code into a function of its own. This greatly improves the
readability and maintainability of this code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 320 ++++++++++++++++---------------
 1 file changed, 162 insertions(+), 158 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 5ff9db9..e7086e1 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1689,19 +1689,153 @@ static void tpg_fill_plane_extras(const struct tpg_data *tpg,
 	}
 }
 
-void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
+static void tpg_fill_plane_pattern(const struct tpg_data *tpg,
+				   const struct tpg_draw_params *params,
+				   unsigned p, unsigned h, u8 *vbuf)
+{
+	unsigned twopixsize = params->twopixsize;
+	unsigned img_width = params->img_width;
+	unsigned mv_hor_old = params->mv_hor_old;
+	unsigned mv_hor_new = params->mv_hor_new;
+	unsigned mv_vert_old = params->mv_vert_old;
+	unsigned mv_vert_new = params->mv_vert_new;
+	unsigned frame_line = params->frame_line;
+	unsigned frame_line_next = params->frame_line_next;
+	unsigned line_offset = tpg_hscale_div(tpg, p, tpg->crop.left);
+	bool even;
+	bool fill_blank = false;
+	unsigned pat_line_old;
+	unsigned pat_line_new;
+	u8 *linestart_older;
+	u8 *linestart_newer;
+	u8 *linestart_top;
+	u8 *linestart_bottom;
+
+	even = !(frame_line & 1);
+
+	if (h >= params->hmax) {
+		if (params->hmax == tpg->compose.height)
+			return;
+		if (!tpg->perc_fill_blank)
+			return;
+		fill_blank = true;
+	}
+
+	if (tpg->vflip) {
+		frame_line = tpg->src_height - frame_line - 1;
+		frame_line_next = tpg->src_height - frame_line_next - 1;
+	}
+
+	if (fill_blank) {
+		linestart_older = tpg->contrast_line[p];
+		linestart_newer = tpg->contrast_line[p];
+	} else if (tpg->qual != TPG_QUAL_NOISE &&
+		   (frame_line < tpg->border.top ||
+		    frame_line >= tpg->border.top + tpg->border.height)) {
+		linestart_older = tpg->black_line[p];
+		linestart_newer = tpg->black_line[p];
+	} else if (tpg->pattern == TPG_PAT_NOISE || tpg->qual == TPG_QUAL_NOISE) {
+		linestart_older = tpg->random_line[p] +
+				  twopixsize * prandom_u32_max(tpg->src_width / 2);
+		linestart_newer = tpg->random_line[p] +
+				  twopixsize * prandom_u32_max(tpg->src_width / 2);
+	} else {
+		unsigned frame_line_old =
+			(frame_line + mv_vert_old) % tpg->src_height;
+		unsigned frame_line_new =
+			(frame_line + mv_vert_new) % tpg->src_height;
+		unsigned pat_line_next_old;
+		unsigned pat_line_next_new;
+
+		pat_line_old = tpg_get_pat_line(tpg, frame_line_old);
+		pat_line_new = tpg_get_pat_line(tpg, frame_line_new);
+		linestart_older = tpg->lines[pat_line_old][p] + mv_hor_old;
+		linestart_newer = tpg->lines[pat_line_new][p] + mv_hor_new;
+
+		if (tpg->vdownsampling[p] > 1 && frame_line != frame_line_next) {
+			int avg_pat;
+
+			/*
+			 * Now decide whether we need to use downsampled_lines[].
+			 * That's necessary if the two lines use different patterns.
+			 */
+			pat_line_next_old = tpg_get_pat_line(tpg,
+					(frame_line_next + mv_vert_old) % tpg->src_height);
+			pat_line_next_new = tpg_get_pat_line(tpg,
+					(frame_line_next + mv_vert_new) % tpg->src_height);
+
+			switch (tpg->field) {
+			case V4L2_FIELD_INTERLACED:
+			case V4L2_FIELD_INTERLACED_BT:
+			case V4L2_FIELD_INTERLACED_TB:
+				avg_pat = tpg_pattern_avg(tpg, pat_line_old, pat_line_new);
+				if (avg_pat < 0)
+					break;
+				linestart_older = tpg->downsampled_lines[avg_pat][p] + mv_hor_old;
+				linestart_newer = linestart_older;
+				break;
+			case V4L2_FIELD_NONE:
+			case V4L2_FIELD_TOP:
+			case V4L2_FIELD_BOTTOM:
+			case V4L2_FIELD_SEQ_BT:
+			case V4L2_FIELD_SEQ_TB:
+				avg_pat = tpg_pattern_avg(tpg, pat_line_old, pat_line_next_old);
+				if (avg_pat >= 0)
+					linestart_older = tpg->downsampled_lines[avg_pat][p] +
+						mv_hor_old;
+				avg_pat = tpg_pattern_avg(tpg, pat_line_new, pat_line_next_new);
+				if (avg_pat >= 0)
+					linestart_newer = tpg->downsampled_lines[avg_pat][p] +
+						mv_hor_new;
+				break;
+			}
+		}
+		linestart_older += line_offset;
+		linestart_newer += line_offset;
+	}
+	if (tpg->field_alternate) {
+		linestart_top = linestart_bottom = linestart_older;
+	} else if (params->is_60hz) {
+		linestart_top = linestart_newer;
+		linestart_bottom = linestart_older;
+	} else {
+		linestart_top = linestart_older;
+		linestart_bottom = linestart_newer;
+	}
+
+	switch (tpg->field) {
+	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_SEQ_TB:
+	case V4L2_FIELD_SEQ_BT:
+		if (even)
+			memcpy(vbuf, linestart_top, img_width);
+		else
+			memcpy(vbuf, linestart_bottom, img_width);
+		break;
+	case V4L2_FIELD_INTERLACED_BT:
+		if (even)
+			memcpy(vbuf, linestart_bottom, img_width);
+		else
+			memcpy(vbuf, linestart_top, img_width);
+		break;
+	case V4L2_FIELD_TOP:
+		memcpy(vbuf, linestart_top, img_width);
+		break;
+	case V4L2_FIELD_BOTTOM:
+		memcpy(vbuf, linestart_bottom, img_width);
+		break;
+	case V4L2_FIELD_NONE:
+	default:
+		memcpy(vbuf, linestart_older, img_width);
+		break;
+	}
+}
+
+void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std,
+			   unsigned p, u8 *vbuf)
 {
 	struct tpg_draw_params params;
-	unsigned mv_hor_old;
-	unsigned mv_hor_new;
-	unsigned mv_vert_old;
-	unsigned mv_vert_new;
-	int h;
-	unsigned twopixsize;
-	unsigned vdiv = tpg->vdownsampling[p];
-	unsigned img_width;
-	unsigned line_offset;
-	unsigned stride;
 	unsigned factor = V4L2_FIELD_HAS_T_OR_B(tpg->field) ? 2 : 1;
 
 	/* Coarse scaling with Bresenham */
@@ -1709,6 +1843,7 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 	unsigned fract_part = (tpg->crop.height / factor) % tpg->compose.height;
 	unsigned src_y = 0;
 	unsigned error = 0;
+	unsigned h;
 
 	tpg_recalc(tpg);
 
@@ -1720,37 +1855,15 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 	params.hmax = (tpg->compose.height * tpg->perc_fill) / 100;
 
 	tpg_fill_params_pattern(tpg, p, &params);
-
-	mv_hor_old = params.mv_hor_old;
-	mv_hor_new = params.mv_hor_new;
-	mv_vert_old = params.mv_vert_old;
-	mv_vert_new = params.mv_vert_new;
-
 	tpg_fill_params_extras(tpg, p, &params);
 
-	twopixsize = params.twopixsize;
-	img_width = params.img_width;
-	stride = params.stride;
-
 	vbuf += tpg_hdiv(tpg, p, tpg->compose.left);
-	line_offset = tpg_hscale_div(tpg, p, tpg->crop.left);
 
 	for (h = 0; h < tpg->compose.height; h++) {
-		bool even;
-		bool fill_blank = false;
-		unsigned frame_line;
 		unsigned buf_line;
-		unsigned pat_line_old;
-		unsigned pat_line_new;
-		u8 *linestart_older;
-		u8 *linestart_newer;
-		u8 *linestart_top;
-		u8 *linestart_bottom;
 
 		params.frame_line = tpg_calc_frameline(tpg, src_y, tpg->field);
 		params.frame_line_next = params.frame_line;
-		frame_line = params.frame_line;
-		even = !(frame_line & 1);
 		buf_line = tpg_calc_buffer_line(tpg, h, tpg->field);
 		src_y += int_part;
 		error += fract_part;
@@ -1759,7 +1872,7 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			src_y++;
 		}
 
-		if (vdiv > 1) {
+		if (tpg->vdownsampling[p] > 1) {
 			/*
 			 * When doing vertical downsampling the field setting
 			 * matters: for SEQ_BT/TB we downsample each field
@@ -1770,135 +1883,26 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			 */
 			if (tpg->field == V4L2_FIELD_SEQ_BT ||
 			    tpg->field == V4L2_FIELD_SEQ_TB) {
+				unsigned next_src_y = src_y;
+
 				if ((h & 3) >= 2)
 					continue;
-			} else if (h & 1) {
-				continue;
-			}
-
-			buf_line /= vdiv;
-		}
-
-		if (h >= params.hmax) {
-			if (params.hmax == tpg->compose.height)
-				continue;
-			if (!tpg->perc_fill_blank)
-				continue;
-			fill_blank = true;
-		}
-
-		if (tpg->vflip)
-			frame_line = tpg->src_height - frame_line - 1;
-
-		if (fill_blank) {
-			linestart_older = tpg->contrast_line[p];
-			linestart_newer = tpg->contrast_line[p];
-		} else if (tpg->qual != TPG_QUAL_NOISE &&
-			   (frame_line < tpg->border.top ||
-			    frame_line >= tpg->border.top + tpg->border.height)) {
-			linestart_older = tpg->black_line[p];
-			linestart_newer = tpg->black_line[p];
-		} else if (tpg->pattern == TPG_PAT_NOISE || tpg->qual == TPG_QUAL_NOISE) {
-			linestart_older = tpg->random_line[p] +
-					  twopixsize * prandom_u32_max(tpg->src_width / 2);
-			linestart_newer = tpg->random_line[p] +
-					  twopixsize * prandom_u32_max(tpg->src_width / 2);
-		} else {
-			unsigned frame_line_old =
-				(frame_line + mv_vert_old) % tpg->src_height;
-			unsigned frame_line_new =
-				(frame_line + mv_vert_new) % tpg->src_height;
-			unsigned pat_line_next_old;
-			unsigned pat_line_next_new;
-
-			pat_line_old = tpg_get_pat_line(tpg, frame_line_old);
-			pat_line_new = tpg_get_pat_line(tpg, frame_line_new);
-			linestart_older = tpg->lines[pat_line_old][p] + mv_hor_old;
-			linestart_newer = tpg->lines[pat_line_new][p] + mv_hor_new;
-
-			if (vdiv > 1) {
-				unsigned frame_line_next;
-				int avg_pat;
-
-				/*
-				 * Now decide whether we need to use downsampled_lines[].
-				 * That's necessary if the two lines use different patterns.
-				 */
-				frame_line_next = tpg_calc_frameline(tpg, src_y, tpg->field);
-				if (tpg->vflip)
-					frame_line_next = tpg->src_height - frame_line_next - 1;
-				pat_line_next_old = tpg_get_pat_line(tpg,
-						(frame_line_next + mv_vert_old) % tpg->src_height);
-				pat_line_next_new = tpg_get_pat_line(tpg,
-						(frame_line_next + mv_vert_new) % tpg->src_height);
-
-				switch (tpg->field) {
-				case V4L2_FIELD_INTERLACED:
-				case V4L2_FIELD_INTERLACED_BT:
-				case V4L2_FIELD_INTERLACED_TB:
-					avg_pat = tpg_pattern_avg(tpg, pat_line_old, pat_line_new);
-					if (avg_pat < 0)
-						break;
-					linestart_older = tpg->downsampled_lines[avg_pat][p] + mv_hor_old;
-					linestart_newer = linestart_older;
-					break;
-				case V4L2_FIELD_NONE:
-				case V4L2_FIELD_TOP:
-				case V4L2_FIELD_BOTTOM:
-				case V4L2_FIELD_SEQ_BT:
-				case V4L2_FIELD_SEQ_TB:
-					avg_pat = tpg_pattern_avg(tpg, pat_line_old, pat_line_next_old);
-					if (avg_pat >= 0)
-						linestart_older = tpg->downsampled_lines[avg_pat][p] +
-							mv_hor_old;
-					avg_pat = tpg_pattern_avg(tpg, pat_line_new, pat_line_next_new);
-					if (avg_pat >= 0)
-						linestart_newer = tpg->downsampled_lines[avg_pat][p] +
-							mv_hor_new;
-					break;
-				}
+				next_src_y += int_part;
+				if (error + fract_part >= tpg->compose.height)
+					next_src_y++;
+				params.frame_line_next =
+					tpg_calc_frameline(tpg, next_src_y, tpg->field);
+			} else {
+				if (h & 1)
+					continue;
+				params.frame_line_next =
+					tpg_calc_frameline(tpg, src_y, tpg->field);
 			}
-			linestart_older += line_offset;
-			linestart_newer += line_offset;
-		}
-		if (tpg->field_alternate) {
-			linestart_top = linestart_bottom = linestart_older;
-		} else if (params.is_60hz) {
-			linestart_top = linestart_newer;
-			linestart_bottom = linestart_older;
-		} else {
-			linestart_top = linestart_older;
-			linestart_bottom = linestart_newer;
-		}
 
-		switch (tpg->field) {
-		case V4L2_FIELD_INTERLACED:
-		case V4L2_FIELD_INTERLACED_TB:
-		case V4L2_FIELD_SEQ_TB:
-		case V4L2_FIELD_SEQ_BT:
-			if (even)
-				memcpy(vbuf + buf_line * stride, linestart_top, img_width);
-			else
-				memcpy(vbuf + buf_line * stride, linestart_bottom, img_width);
-			break;
-		case V4L2_FIELD_INTERLACED_BT:
-			if (even)
-				memcpy(vbuf + buf_line * stride, linestart_bottom, img_width);
-			else
-				memcpy(vbuf + buf_line * stride, linestart_top, img_width);
-			break;
-		case V4L2_FIELD_TOP:
-			memcpy(vbuf + buf_line * stride, linestart_top, img_width);
-			break;
-		case V4L2_FIELD_BOTTOM:
-			memcpy(vbuf + buf_line * stride, linestart_bottom, img_width);
-			break;
-		case V4L2_FIELD_NONE:
-		default:
-			memcpy(vbuf + buf_line * stride, linestart_older, img_width);
-			break;
+			buf_line /= tpg->vdownsampling[p];
 		}
-
+		tpg_fill_plane_pattern(tpg, &params, p, h,
+				vbuf + buf_line * params.stride);
 		tpg_fill_plane_extras(tpg, &params, p, h,
 				vbuf + buf_line * params.stride);
 	}
-- 
2.1.4

