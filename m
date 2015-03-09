Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:53894 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932072AbbCIPrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:47:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 15/29] vivid-tpg: finish hor/vert downsampling support
Date: Mon,  9 Mar 2015 16:44:37 +0100
Message-Id: <1425915891-1017-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Implement horizontal and vertical downsampling when filling in the
plane. The TPG is now ready to support such formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 128 ++++++++++++++++++++++++++-----
 1 file changed, 110 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index f03289f..7d8e87e 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1396,15 +1396,29 @@ void tpg_calc_text_basep(struct tpg_data *tpg,
 		u8 *basep[TPG_MAX_PLANES][2], unsigned p, u8 *vbuf)
 {
 	unsigned stride = tpg->bytesperline[p];
+	unsigned h = tpg->buf_height;
 
 	tpg_recalc(tpg);
 
 	basep[p][0] = vbuf;
 	basep[p][1] = vbuf;
+	h /= tpg->vdownsampling[p];
 	if (tpg->field == V4L2_FIELD_SEQ_TB)
-		basep[p][1] += tpg->buf_height * stride / 2;
+		basep[p][1] += h * stride / 2;
 	else if (tpg->field == V4L2_FIELD_SEQ_BT)
-		basep[p][0] += tpg->buf_height * stride / 2;
+		basep[p][0] += h * stride / 2;
+}
+
+static int tpg_pattern_avg(const struct tpg_data *tpg,
+			   unsigned pat1, unsigned pat2)
+{
+	unsigned pat_lines = tpg_get_pat_lines(tpg);
+
+	if (pat1 == (pat2 + 1) % pat_lines)
+		return pat2;
+	if (pat2 == (pat1 + 1) % pat_lines)
+		return pat1;
+	return -1;
 }
 
 void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
@@ -1420,7 +1434,9 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 	int hmax = (tpg->compose.height * tpg->perc_fill) / 100;
 	int h;
 	unsigned twopixsize = tpg->twopixelsize[p];
-	unsigned img_width = tpg->compose.width * twopixsize / 2;
+	unsigned hdiv = tpg->hdownsampling[p];
+	unsigned vdiv = tpg->vdownsampling[p];
+	unsigned img_width = (tpg->compose.width / hdiv) * twopixsize / 2;
 	unsigned line_offset;
 	unsigned left_pillar_width = 0;
 	unsigned right_pillar_start = img_width;
@@ -1446,18 +1462,18 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 
 	vbuf += tpg->compose.left * twopixsize / 2;
 	line_offset = tpg->crop.left * tpg->scaled_width / tpg->src_width;
-	line_offset = (line_offset & ~1) * twopixsize / 2;
+	line_offset = ((line_offset & ~1) / hdiv) * twopixsize / 2;
 	if (tpg->crop.left < tpg->border.left) {
 		left_pillar_width = tpg->border.left - tpg->crop.left;
 		if (left_pillar_width > tpg->crop.width)
 			left_pillar_width = tpg->crop.width;
 		left_pillar_width = (left_pillar_width * tpg->scaled_width) / tpg->src_width;
-		left_pillar_width = (left_pillar_width & ~1) * twopixsize / 2;
+		left_pillar_width = ((left_pillar_width & ~1) / hdiv) * twopixsize / 2;
 	}
 	if (tpg->crop.left + tpg->crop.width > tpg->border.left + tpg->border.width) {
 		right_pillar_start = tpg->border.left + tpg->border.width - tpg->crop.left;
 		right_pillar_start = (right_pillar_start * tpg->scaled_width) / tpg->src_width;
-		right_pillar_start = (right_pillar_start & ~1) * twopixsize / 2;
+		right_pillar_start = ((right_pillar_start & ~1) / hdiv) * twopixsize / 2;
 		if (right_pillar_start > img_width)
 			right_pillar_start = img_width;
 	}
@@ -1486,6 +1502,26 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			src_y++;
 		}
 
+		if (vdiv > 1) {
+			/*
+			 * When doing vertical downsampling the field setting
+			 * matters: for SEQ_BT/TB we downsample each field
+			 * separately (i.e. lines 0+2 are combined, as are
+			 * lines 1+3), for the other field settings we combine
+			 * odd and even lines. Doing that for SEQ_BT/TB would
+			 * be really weird.
+			 */
+			if (tpg->field == V4L2_FIELD_SEQ_BT ||
+			    tpg->field == V4L2_FIELD_SEQ_TB) {
+				if ((h & 3) >= 2)
+					continue;
+			} else if (h & 1) {
+				continue;
+			}
+
+			buf_line /= vdiv;
+		}
+
 		if (h >= hmax) {
 			if (hmax == tpg->compose.height)
 				continue;
@@ -1511,14 +1547,63 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			linestart_newer = tpg->random_line[p] +
 					  twopixsize * prandom_u32_max(tpg->src_width / 2);
 		} else {
-			pat_line_old = tpg_get_pat_line(tpg,
-						(frame_line + mv_vert_old) % tpg->src_height);
-			pat_line_new = tpg_get_pat_line(tpg,
-						(frame_line + mv_vert_new) % tpg->src_height);
+			unsigned frame_line_old =
+				(frame_line + mv_vert_old) % tpg->src_height;
+			unsigned frame_line_new =
+				(frame_line + mv_vert_new) % tpg->src_height;
+			unsigned pat_line_next_old;
+			unsigned pat_line_next_new;
+
+			pat_line_old = tpg_get_pat_line(tpg, frame_line_old);
+			pat_line_new = tpg_get_pat_line(tpg, frame_line_new);
 			linestart_older = tpg->lines[pat_line_old][p] +
-					  mv_hor_old * twopixsize / 2;
+				(mv_hor_old / hdiv) * twopixsize / 2;
 			linestart_newer = tpg->lines[pat_line_new][p] +
-					  mv_hor_new * twopixsize / 2;
+				(mv_hor_new / hdiv) * twopixsize / 2;
+
+			if (vdiv > 1) {
+				unsigned frame_line_next;
+				int avg_pat;
+
+				/*
+				 * Now decide whether we need to use downsampled_lines[].
+				 * That's necessary if the two lines use different patterns.
+				 */
+				frame_line_next = tpg_calc_frameline(tpg, src_y, tpg->field);
+				if (tpg->vflip)
+					frame_line_next = tpg->src_height - frame_line_next - 1;
+				pat_line_next_old = tpg_get_pat_line(tpg,
+						(frame_line_next + mv_vert_old) % tpg->src_height);
+				pat_line_next_new = tpg_get_pat_line(tpg,
+						(frame_line_next + mv_vert_new) % tpg->src_height);
+
+				switch (tpg->field) {
+				case V4L2_FIELD_INTERLACED:
+				case V4L2_FIELD_INTERLACED_BT:
+				case V4L2_FIELD_INTERLACED_TB:
+					avg_pat = tpg_pattern_avg(tpg, pat_line_old, pat_line_new);
+					if (avg_pat < 0)
+						break;
+					linestart_older = tpg->downsampled_lines[avg_pat][p] +
+						(mv_hor_old / hdiv) * twopixsize / 2;
+					linestart_newer = linestart_older;
+					break;
+				case V4L2_FIELD_NONE:
+				case V4L2_FIELD_TOP:
+				case V4L2_FIELD_BOTTOM:
+				case V4L2_FIELD_SEQ_BT:
+				case V4L2_FIELD_SEQ_TB:
+					avg_pat = tpg_pattern_avg(tpg, pat_line_old, pat_line_next_old);
+					if (avg_pat >= 0)
+						linestart_older = tpg->downsampled_lines[avg_pat][p] +
+							(mv_hor_old / hdiv) * twopixsize / 2;
+					avg_pat = tpg_pattern_avg(tpg, pat_line_new, pat_line_next_new);
+					if (avg_pat >= 0)
+						linestart_newer = tpg->downsampled_lines[avg_pat][p] +
+							(mv_hor_new / hdiv) * twopixsize / 2;
+					break;
+				}
+			}
 			linestart_older += line_offset;
 			linestart_newer += line_offset;
 		}
@@ -1568,12 +1653,13 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			u8 *wss = tpg->random_line[p] +
 				  twopixsize * prandom_u32_max(tpg->src_width / 2);
 
-			memcpy(vbuf + buf_line * stride, wss, wss_width * twopixsize / 2);
+			memcpy(vbuf + buf_line * stride, wss,
+			       (wss_width / hdiv) * twopixsize / 2);
 		}
 	}
 
 	vbuf = orig_vbuf;
-	vbuf += tpg->compose.left * twopixsize / 2;
+	vbuf += (tpg->compose.left / hdiv) * twopixsize / 2;
 	src_y = 0;
 	error = 0;
 	for (h = 0; h < tpg->compose.height; h++) {
@@ -1590,6 +1676,12 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			src_y++;
 		}
 
+		if (vdiv > 1) {
+			if (h & 1)
+				continue;
+			buf_line /= vdiv;
+		}
+
 		if (tpg->show_border && frame_line >= b->top &&
 		    frame_line < b->top + b->height) {
 			unsigned bottom = b->top + b->height - 1;
@@ -1632,13 +1724,13 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 				width -= left + width - c->left - c->width;
 			left -= c->left;
 			left = (left * tpg->scaled_width) / tpg->src_width;
-			left = (left & ~1) * twopixsize / 2;
+			left = ((left & ~1) / hdiv) * twopixsize / 2;
 			width = (width * tpg->scaled_width) / tpg->src_width;
-			width = (width & ~1) * twopixsize / 2;
+			width = ((width & ~1) / hdiv) * twopixsize / 2;
 			memcpy(vbuf + buf_line * stride + left, tpg->contrast_line[p], width);
 		}
 		if (tpg->insert_sav) {
-			unsigned offset = (tpg->compose.width / 6) * twopixsize;
+			unsigned offset = (tpg->compose.width / (6 * hdiv)) * twopixsize;
 			u8 *p = vbuf + buf_line * stride + offset;
 			unsigned vact = 0, hact = 0;
 
@@ -1652,7 +1744,7 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 				(hact ^ vact ^ f);
 		}
 		if (tpg->insert_eav) {
-			unsigned offset = (tpg->compose.width / 6) * 2 * twopixsize;
+			unsigned offset = (tpg->compose.width / (6 * hdiv)) * 2 * twopixsize;
 			u8 *p = vbuf + buf_line * stride + offset;
 			unsigned vact = 0, hact = 1;
 
-- 
2.1.4

