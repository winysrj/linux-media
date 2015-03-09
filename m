Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:35261 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbbCIPsk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:48:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 24/29] vivid-tpg: move the 'extras' drawing to a separate function
Date: Mon,  9 Mar 2015 16:44:46 +0100
Message-Id: <1425915891-1017-25-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This moves the drawing code for the extras (border, square, etc) to
a function of its own instead of having this in the main for loop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 216 +++++++++++++++----------------
 1 file changed, 104 insertions(+), 112 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index a738ce1..5ff9db9 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1590,6 +1590,105 @@ static void tpg_fill_params_extras(const struct tpg_data *tpg,
 			(params->is_60hz ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM);
 }
 
+static void tpg_fill_plane_extras(const struct tpg_data *tpg,
+				  const struct tpg_draw_params *params,
+				  unsigned p, unsigned h, u8 *vbuf)
+{
+	unsigned twopixsize = params->twopixsize;
+	unsigned img_width = params->img_width;
+	unsigned frame_line = params->frame_line;
+	const struct v4l2_rect *sq = &tpg->square;
+	const struct v4l2_rect *b = &tpg->border;
+	const struct v4l2_rect *c = &tpg->crop;
+
+	if (params->is_tv && !params->is_60hz &&
+	    frame_line == 0 && params->wss_width) {
+		/*
+		 * Replace the first half of the top line of a 50 Hz frame
+		 * with random data to simulate a WSS signal.
+		 */
+		u8 *wss = tpg->random_line[p] + params->wss_random_offset;
+
+		memcpy(vbuf, wss, params->wss_width);
+	}
+
+	if (tpg->show_border && frame_line >= b->top &&
+	    frame_line < b->top + b->height) {
+		unsigned bottom = b->top + b->height - 1;
+		unsigned left = params->left_pillar_width;
+		unsigned right = params->right_pillar_start;
+
+		if (frame_line == b->top || frame_line == b->top + 1 ||
+		    frame_line == bottom || frame_line == bottom - 1) {
+			memcpy(vbuf + left, tpg->contrast_line[p],
+					right - left);
+		} else {
+			if (b->left >= c->left &&
+			    b->left < c->left + c->width)
+				memcpy(vbuf + left,
+					tpg->contrast_line[p], twopixsize);
+			if (b->left + b->width > c->left &&
+			    b->left + b->width <= c->left + c->width)
+				memcpy(vbuf + right - twopixsize,
+					tpg->contrast_line[p], twopixsize);
+		}
+	}
+	if (tpg->qual != TPG_QUAL_NOISE && frame_line >= b->top &&
+	    frame_line < b->top + b->height) {
+		memcpy(vbuf, tpg->black_line[p], params->left_pillar_width);
+		memcpy(vbuf + params->right_pillar_start, tpg->black_line[p],
+		       img_width - params->right_pillar_start);
+	}
+	if (tpg->show_square && frame_line >= sq->top &&
+	    frame_line < sq->top + sq->height &&
+	    sq->left < c->left + c->width &&
+	    sq->left + sq->width >= c->left) {
+		unsigned left = sq->left;
+		unsigned width = sq->width;
+
+		if (c->left > left) {
+			width -= c->left - left;
+			left = c->left;
+		}
+		if (c->left + c->width < left + width)
+			width -= left + width - c->left - c->width;
+		left -= c->left;
+		left = tpg_hscale_div(tpg, p, left);
+		width = tpg_hscale_div(tpg, p, width);
+		memcpy(vbuf + left, tpg->contrast_line[p], width);
+	}
+	if (tpg->insert_sav) {
+		unsigned offset = tpg_hdiv(tpg, p, tpg->compose.width / 3);
+		u8 *p = vbuf + offset;
+		unsigned vact = 0, hact = 0;
+
+		p[0] = 0xff;
+		p[1] = 0;
+		p[2] = 0;
+		p[3] = 0x80 | (params->sav_eav_f << 6) |
+			(vact << 5) | (hact << 4) |
+			((hact ^ vact) << 3) |
+			((hact ^ params->sav_eav_f) << 2) |
+			((params->sav_eav_f ^ vact) << 1) |
+			(hact ^ vact ^ params->sav_eav_f);
+	}
+	if (tpg->insert_eav) {
+		unsigned offset = tpg_hdiv(tpg, p, tpg->compose.width * 2 / 3);
+		u8 *p = vbuf + offset;
+		unsigned vact = 0, hact = 1;
+
+		p[0] = 0xff;
+		p[1] = 0;
+		p[2] = 0;
+		p[3] = 0x80 | (params->sav_eav_f << 6) |
+			(vact << 5) | (hact << 4) |
+			((hact ^ vact) << 3) |
+			((hact ^ params->sav_eav_f) << 2) |
+			((params->sav_eav_f ^ vact) << 1) |
+			(hact ^ vact ^ params->sav_eav_f);
+	}
+}
+
 void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 {
 	struct tpg_draw_params params;
@@ -1604,7 +1703,6 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 	unsigned line_offset;
 	unsigned stride;
 	unsigned factor = V4L2_FIELD_HAS_T_OR_B(tpg->field) ? 2 : 1;
-	u8 *orig_vbuf = vbuf;
 
 	/* Coarse scaling with Bresenham */
 	unsigned int_part = (tpg->crop.height / factor) / tpg->compose.height;
@@ -1649,7 +1747,9 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 		u8 *linestart_top;
 		u8 *linestart_bottom;
 
-		frame_line = tpg_calc_frameline(tpg, src_y, tpg->field);
+		params.frame_line = tpg_calc_frameline(tpg, src_y, tpg->field);
+		params.frame_line_next = params.frame_line;
+		frame_line = params.frame_line;
 		even = !(frame_line & 1);
 		buf_line = tpg_calc_buffer_line(tpg, h, tpg->field);
 		src_y += int_part;
@@ -1798,117 +1898,9 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			memcpy(vbuf + buf_line * stride, linestart_older, img_width);
 			break;
 		}
-	}
 
-	vbuf = orig_vbuf;
-	vbuf += tpg_hdiv(tpg, p, tpg->compose.left);
-	src_y = 0;
-	error = 0;
-	for (h = 0; h < tpg->compose.height; h++) {
-		unsigned frame_line = tpg_calc_frameline(tpg, src_y, tpg->field);
-		unsigned buf_line = tpg_calc_buffer_line(tpg, h, tpg->field);
-		const struct v4l2_rect *sq = &tpg->square;
-		const struct v4l2_rect *b = &tpg->border;
-		const struct v4l2_rect *c = &tpg->crop;
-
-		src_y += int_part;
-		error += fract_part;
-		if (error >= tpg->compose.height) {
-			error -= tpg->compose.height;
-			src_y++;
-		}
-
-		if (vdiv > 1) {
-			if (h & 1)
-				continue;
-			buf_line /= vdiv;
-		}
-
-		if (params.is_tv && !params.is_60hz && frame_line == 0 && params.wss_width) {
-			/*
-			 * Replace the first half of the top line of a 50 Hz frame
-			 * with random data to simulate a WSS signal.
-			 */
-			u8 *wss = tpg->random_line[p] + params.wss_random_offset;
-
-			memcpy(vbuf + buf_line * stride, wss, params.wss_width);
-		}
-
-		if (tpg->show_border && frame_line >= b->top &&
-		    frame_line < b->top + b->height) {
-			unsigned bottom = b->top + b->height - 1;
-			unsigned left = params.left_pillar_width;
-			unsigned right = params.right_pillar_start;
-
-			if (frame_line == b->top || frame_line == b->top + 1 ||
-			    frame_line == bottom || frame_line == bottom - 1) {
-				memcpy(vbuf + buf_line * stride + left, tpg->contrast_line[p],
-						right - left);
-			} else {
-				if (b->left >= c->left &&
-				    b->left < c->left + c->width)
-					memcpy(vbuf + buf_line * stride + left,
-						tpg->contrast_line[p], twopixsize);
-				if (b->left + b->width > c->left &&
-				    b->left + b->width <= c->left + c->width)
-					memcpy(vbuf + buf_line * stride + right - twopixsize,
-						tpg->contrast_line[p], twopixsize);
-			}
-		}
-		if (tpg->qual != TPG_QUAL_NOISE && frame_line >= b->top &&
-		    frame_line < b->top + b->height) {
-			memcpy(vbuf + buf_line * stride, tpg->black_line[p], params.left_pillar_width);
-			memcpy(vbuf + buf_line * stride + params.right_pillar_start, tpg->black_line[p],
-			       img_width - params.right_pillar_start);
-		}
-		if (tpg->show_square && frame_line >= sq->top &&
-		    frame_line < sq->top + sq->height &&
-		    sq->left < c->left + c->width &&
-		    sq->left + sq->width >= c->left) {
-			unsigned left = sq->left;
-			unsigned width = sq->width;
-
-			if (c->left > left) {
-				width -= c->left - left;
-				left = c->left;
-			}
-			if (c->left + c->width < left + width)
-				width -= left + width - c->left - c->width;
-			left -= c->left;
-			left = tpg_hscale_div(tpg, p, left);
-			width = tpg_hscale_div(tpg, p, width);
-			memcpy(vbuf + buf_line * stride + left, tpg->contrast_line[p], width);
-		}
-		if (tpg->insert_sav) {
-			unsigned offset = tpg_hdiv(tpg, p, tpg->compose.width / 3);
-			u8 *p = vbuf + buf_line * stride + offset;
-			unsigned vact = 0, hact = 0;
-
-			p[0] = 0xff;
-			p[1] = 0;
-			p[2] = 0;
-			p[3] = 0x80 | (params.sav_eav_f << 6) |
-				(vact << 5) | (hact << 4) |
-				((hact ^ vact) << 3) |
-				((hact ^ params.sav_eav_f) << 2) |
-				((params.sav_eav_f ^ vact) << 1) |
-				(hact ^ vact ^ params.sav_eav_f);
-		}
-		if (tpg->insert_eav) {
-			unsigned offset = tpg_hdiv(tpg, p, tpg->compose.width * 2 / 3);
-			u8 *p = vbuf + buf_line * stride + offset;
-			unsigned vact = 0, hact = 1;
-
-			p[0] = 0xff;
-			p[1] = 0;
-			p[2] = 0;
-			p[3] = 0x80 | (params.sav_eav_f << 6) |
-				(vact << 5) | (hact << 4) |
-				((hact ^ vact) << 3) |
-				((hact ^ params.sav_eav_f) << 2) |
-				((params.sav_eav_f ^ vact) << 1) |
-				(hact ^ vact ^ params.sav_eav_f);
-		}
+		tpg_fill_plane_extras(tpg, &params, p, h,
+				vbuf + buf_line * params.stride);
 	}
 }
 
-- 
2.1.4

