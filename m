Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:41828 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200AbbCIPsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:48:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 22/29] vivid-tpg: move pattern-related fields to struct tpg_draw_params
Date: Mon,  9 Mar 2015 16:44:44 +0100
Message-Id: <1425915891-1017-23-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new function that fills in pattern-related fields in struct
tpg_draw_params.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 1e5eefa..c477730 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1539,13 +1539,26 @@ struct tpg_draw_params {
 	unsigned right_pillar_start;
 };
 
+static void tpg_fill_params_pattern(const struct tpg_data *tpg, unsigned p,
+				    struct tpg_draw_params *params)
+{
+	params->mv_hor_old =
+		tpg_hscale_div(tpg, p, tpg->mv_hor_count % tpg->src_width);
+	params->mv_hor_new =
+		tpg_hscale_div(tpg, p, (tpg->mv_hor_count + tpg->mv_hor_step) %
+			       tpg->src_width);
+	params->mv_vert_old = tpg->mv_vert_count % tpg->src_height;
+	params->mv_vert_new =
+		(tpg->mv_vert_count + tpg->mv_vert_step) % tpg->src_height;
+}
+
 void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 {
 	struct tpg_draw_params params;
-	unsigned mv_hor_old = tpg->mv_hor_count % tpg->src_width;
-	unsigned mv_hor_new = (tpg->mv_hor_count + tpg->mv_hor_step) % tpg->src_width;
-	unsigned mv_vert_old = tpg->mv_vert_count % tpg->src_height;
-	unsigned mv_vert_new = (tpg->mv_vert_count + tpg->mv_vert_step) % tpg->src_height;
+	unsigned mv_hor_old;
+	unsigned mv_hor_new;
+	unsigned mv_vert_old;
+	unsigned mv_vert_new;
 	unsigned wss_width;
 	unsigned f;
 	int h;
@@ -1574,12 +1587,17 @@ void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8
 	params.stride = tpg->bytesperline[p];
 	params.hmax = (tpg->compose.height * tpg->perc_fill) / 100;
 
+	tpg_fill_params_pattern(tpg, p, &params);
+
+	mv_hor_old = params.mv_hor_old;
+	mv_hor_new = params.mv_hor_new;
+	mv_vert_old = params.mv_vert_old;
+	mv_vert_new = params.mv_vert_new;
+
 	twopixsize = params.twopixsize;
 	img_width = params.img_width;
 	stride = params.stride;
 
-	mv_hor_old = tpg_hscale_div(tpg, p, mv_hor_old);
-	mv_hor_new = tpg_hscale_div(tpg, p, mv_hor_new);
 	wss_width = tpg->crop.left < tpg->src_width / 2 ?
 			tpg->src_width / 2 - tpg->crop.left : 0;
 	if (wss_width > tpg->crop.width)
-- 
2.1.4

