Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:53894 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164AbbCIPsO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:48:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 21/29] vivid-tpg: move common parameters to tpg_draw_params
Date: Mon,  9 Mar 2015 16:44:43 +0100
Message-Id: <1425915891-1017-22-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace local variables by fields in the tpg_draw_params struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 34 +++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index acee705..1e5eefa 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1541,23 +1541,21 @@ struct tpg_draw_params {
 
 void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 {
-	bool is_tv = std;
-	bool is_60hz = is_tv && (std & V4L2_STD_525_60);
+	struct tpg_draw_params params;
 	unsigned mv_hor_old = tpg->mv_hor_count % tpg->src_width;
 	unsigned mv_hor_new = (tpg->mv_hor_count + tpg->mv_hor_step) % tpg->src_width;
 	unsigned mv_vert_old = tpg->mv_vert_count % tpg->src_height;
 	unsigned mv_vert_new = (tpg->mv_vert_count + tpg->mv_vert_step) % tpg->src_height;
 	unsigned wss_width;
 	unsigned f;
-	int hmax = (tpg->compose.height * tpg->perc_fill) / 100;
 	int h;
-	unsigned twopixsize = tpg->twopixelsize[p];
+	unsigned twopixsize;
 	unsigned vdiv = tpg->vdownsampling[p];
-	unsigned img_width = tpg_hdiv(tpg, p, tpg->compose.width);
+	unsigned img_width;
 	unsigned line_offset;
 	unsigned left_pillar_width = 0;
-	unsigned right_pillar_start = img_width;
-	unsigned stride = tpg->bytesperline[p];
+	unsigned right_pillar_start;
+	unsigned stride;
 	unsigned factor = V4L2_FIELD_HAS_T_OR_B(tpg->field) ? 2 : 1;
 	u8 *orig_vbuf = vbuf;
 
@@ -1569,6 +1567,17 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 
 	tpg_recalc(tpg);
 
+	params.is_tv = std;
+	params.is_60hz = std & V4L2_STD_525_60;
+	params.twopixsize = tpg->twopixelsize[p];
+	params.img_width = tpg_hdiv(tpg, p, tpg->compose.width);
+	params.stride = tpg->bytesperline[p];
+	params.hmax = (tpg->compose.height * tpg->perc_fill) / 100;
+
+	twopixsize = params.twopixsize;
+	img_width = params.img_width;
+	stride = params.stride;
+
 	mv_hor_old = tpg_hscale_div(tpg, p, mv_hor_old);
 	mv_hor_new = tpg_hscale_div(tpg, p, mv_hor_new);
 	wss_width = tpg->crop.left < tpg->src_width / 2 ?
@@ -1585,6 +1594,7 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			left_pillar_width = tpg->crop.width;
 		left_pillar_width = tpg_hscale_div(tpg, p, left_pillar_width);
 	}
+	right_pillar_start = img_width;
 	if (tpg->crop.left + tpg->crop.width > tpg->border.left + tpg->border.width) {
 		right_pillar_start = tpg->border.left + tpg->border.width - tpg->crop.left;
 		right_pillar_start = tpg_hscale_div(tpg, p, right_pillar_start);
@@ -1592,7 +1602,7 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			right_pillar_start = img_width;
 	}
 
-	f = tpg->field == (is_60hz ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM);
+	f = tpg->field == (params.is_60hz ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM);
 
 	for (h = 0; h < tpg->compose.height; h++) {
 		bool even;
@@ -1636,8 +1646,8 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			buf_line /= vdiv;
 		}
 
-		if (h >= hmax) {
-			if (hmax == tpg->compose.height)
+		if (h >= params.hmax) {
+			if (params.hmax == tpg->compose.height)
 				continue;
 			if (!tpg->perc_fill_blank)
 				continue;
@@ -1720,7 +1730,7 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 		}
 		if (tpg->field_alternate) {
 			linestart_top = linestart_bottom = linestart_older;
-		} else if (is_60hz) {
+		} else if (params.is_60hz) {
 			linestart_top = linestart_newer;
 			linestart_bottom = linestart_older;
 		} else {
@@ -1781,7 +1791,7 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 			buf_line /= vdiv;
 		}
 
-		if (is_tv && !is_60hz && frame_line == 0 && wss_width) {
+		if (params.is_tv && !params.is_60hz && frame_line == 0 && wss_width) {
 			/*
 			 * Replace the first half of the top line of a 50 Hz frame
 			 * with random data to simulate a WSS signal.
-- 
2.1.4

