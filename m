Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:53894 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417AbbCIPsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:48:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 23/29] vivid-tpg: move 'extras' parameters to tpg_draw_params
Date: Mon,  9 Mar 2015 16:44:45 +0100
Message-Id: <1425915891-1017-24-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Any parameters related to drawing 'extras' like the border, the square,
etc. are moved to struct tpg_draw_params.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 100 ++++++++++++++++++-------------
 1 file changed, 58 insertions(+), 42 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index c477730..a738ce1 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1552,6 +1552,44 @@ static void tpg_fill_params_pattern(const struct tpg_data *tpg, unsigned p,
 		(tpg->mv_vert_count + tpg->mv_vert_step) % tpg->src_height;
 }
 
+static void tpg_fill_params_extras(const struct tpg_data *tpg,
+				   unsigned p,
+				   struct tpg_draw_params *params)
+{
+	unsigned left_pillar_width = 0;
+	unsigned right_pillar_start = params->img_width;
+
+	params->wss_width = tpg->crop.left < tpg->src_width / 2 ?
+		tpg->src_width / 2 - tpg->crop.left : 0;
+	if (params->wss_width > tpg->crop.width)
+		params->wss_width = tpg->crop.width;
+	params->wss_width = tpg_hscale_div(tpg, p, params->wss_width);
+	params->wss_random_offset =
+		params->twopixsize * prandom_u32_max(tpg->src_width / 2);
+
+	if (tpg->crop.left < tpg->border.left) {
+		left_pillar_width = tpg->border.left - tpg->crop.left;
+		if (left_pillar_width > tpg->crop.width)
+			left_pillar_width = tpg->crop.width;
+		left_pillar_width = tpg_hscale_div(tpg, p, left_pillar_width);
+	}
+	params->left_pillar_width = left_pillar_width;
+
+	if (tpg->crop.left + tpg->crop.width >
+	    tpg->border.left + tpg->border.width) {
+		right_pillar_start =
+			tpg->border.left + tpg->border.width - tpg->crop.left;
+		right_pillar_start =
+			tpg_hscale_div(tpg, p, right_pillar_start);
+		if (right_pillar_start > params->img_width)
+			right_pillar_start = params->img_width;
+	}
+	params->right_pillar_start = right_pillar_start;
+
+	params->sav_eav_f = tpg->field ==
+			(params->is_60hz ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM);
+}
+
 void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 {
 	struct tpg_draw_params params;
@@ -1559,15 +1597,11 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 	unsigned mv_hor_new;
 	unsigned mv_vert_old;
 	unsigned mv_vert_new;
-	unsigned wss_width;
-	unsigned f;
 	int h;
 	unsigned twopixsize;
 	unsigned vdiv = tpg->vdownsampling[p];
 	unsigned img_width;
 	unsigned line_offset;
-	unsigned left_pillar_width = 0;
-	unsigned right_pillar_start;
 	unsigned stride;
 	unsigned factor = V4L2_FIELD_HAS_T_OR_B(tpg->field) ? 2 : 1;
 	u8 *orig_vbuf = vbuf;
@@ -1594,33 +1628,14 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 	mv_vert_old = params.mv_vert_old;
 	mv_vert_new = params.mv_vert_new;
 
+	tpg_fill_params_extras(tpg, p, &params);
+
 	twopixsize = params.twopixsize;
 	img_width = params.img_width;
 	stride = params.stride;
 
-	wss_width = tpg->crop.left < tpg->src_width / 2 ?
-			tpg->src_width / 2 - tpg->crop.left : 0;
-	if (wss_width > tpg->crop.width)
-		wss_width = tpg->crop.width;
-	wss_width = tpg_hscale_div(tpg, p, wss_width);
-
 	vbuf += tpg_hdiv(tpg, p, tpg->compose.left);
 	line_offset = tpg_hscale_div(tpg, p, tpg->crop.left);
-	if (tpg->crop.left < tpg->border.left) {
-		left_pillar_width = tpg->border.left - tpg->crop.left;
-		if (left_pillar_width > tpg->crop.width)
-			left_pillar_width = tpg->crop.width;
-		left_pillar_width = tpg_hscale_div(tpg, p, left_pillar_width);
-	}
-	right_pillar_start = img_width;
-	if (tpg->crop.left + tpg->crop.width > tpg->border.left + tpg->border.width) {
-		right_pillar_start = tpg->border.left + tpg->border.width - tpg->crop.left;
-		right_pillar_start = tpg_hscale_div(tpg, p, right_pillar_start);
-		if (right_pillar_start > img_width)
-			right_pillar_start = img_width;
-	}
-
-	f = tpg->field == (params.is_60hz ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM);
 
 	for (h = 0; h < tpg->compose.height; h++) {
 		bool even;
@@ -1809,22 +1824,21 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			buf_line /= vdiv;
 		}
 
-		if (params.is_tv && !params.is_60hz && frame_line == 0 && wss_width) {
+		if (params.is_tv && !params.is_60hz && frame_line == 0 && params.wss_width) {
 			/*
 			 * Replace the first half of the top line of a 50 Hz frame
 			 * with random data to simulate a WSS signal.
 			 */
-			u8 *wss = tpg->random_line[p] +
-				  twopixsize * prandom_u32_max(tpg->src_width / 2);
+			u8 *wss = tpg->random_line[p] + params.wss_random_offset;
 
-			memcpy(vbuf + buf_line * stride, wss, wss_width);
+			memcpy(vbuf + buf_line * stride, wss, params.wss_width);
 		}
 
 		if (tpg->show_border && frame_line >= b->top &&
 		    frame_line < b->top + b->height) {
 			unsigned bottom = b->top + b->height - 1;
-			unsigned left = left_pillar_width;
-			unsigned right = right_pillar_start;
+			unsigned left = params.left_pillar_width;
+			unsigned right = params.right_pillar_start;
 
 			if (frame_line == b->top || frame_line == b->top + 1 ||
 			    frame_line == bottom || frame_line == bottom - 1) {
@@ -1843,9 +1857,9 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 		}
 		if (tpg->qual != TPG_QUAL_NOISE && frame_line >= b->top &&
 		    frame_line < b->top + b->height) {
-			memcpy(vbuf + buf_line * stride, tpg->black_line[p], left_pillar_width);
-			memcpy(vbuf + buf_line * stride + right_pillar_start, tpg->black_line[p],
-			       img_width - right_pillar_start);
+			memcpy(vbuf + buf_line * stride, tpg->black_line[p], params.left_pillar_width);
+			memcpy(vbuf + buf_line * stride + params.right_pillar_start, tpg->black_line[p],
+			       img_width - params.right_pillar_start);
 		}
 		if (tpg->show_square && frame_line >= sq->top &&
 		    frame_line < sq->top + sq->height &&
@@ -1873,11 +1887,12 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			p[0] = 0xff;
 			p[1] = 0;
 			p[2] = 0;
-			p[3] = 0x80 | (f << 6) | (vact << 5) | (hact << 4) |
+			p[3] = 0x80 | (params.sav_eav_f << 6) |
+				(vact << 5) | (hact << 4) |
 				((hact ^ vact) << 3) |
-				((hact ^ f) << 2) |
-				((f ^ vact) << 1) |
-				(hact ^ vact ^ f);
+				((hact ^ params.sav_eav_f) << 2) |
+				((params.sav_eav_f ^ vact) << 1) |
+				(hact ^ vact ^ params.sav_eav_f);
 		}
 		if (tpg->insert_eav) {
 			unsigned offset = tpg_hdiv(tpg, p, tpg->compose.width * 2 / 3);
@@ -1887,11 +1902,12 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			p[0] = 0xff;
 			p[1] = 0;
 			p[2] = 0;
-			p[3] = 0x80 | (f << 6) | (vact << 5) | (hact << 4) |
+			p[3] = 0x80 | (params.sav_eav_f << 6) |
+				(vact << 5) | (hact << 4) |
 				((hact ^ vact) << 3) |
-				((hact ^ f) << 2) |
-				((f ^ vact) << 1) |
-				(hact ^ vact ^ f);
+				((hact ^ params.sav_eav_f) << 2) |
+				((params.sav_eav_f ^ vact) << 1) |
+				(hact ^ vact ^ params.sav_eav_f);
 		}
 	}
 }
-- 
2.1.4

