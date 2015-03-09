Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50153 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbbCIPsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:48:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 20/29] vivid-tpg: add a new tpg_draw_params structure
Date: Mon,  9 Mar 2015 16:44:42 +0100
Message-Id: <1425915891-1017-21-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is needed to refactor the drawing function which is much too big.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 2f78ccd..acee705 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1510,6 +1510,35 @@ static int tpg_pattern_avg(const struct tpg_data *tpg,
 	return -1;
 }
 
+/*
+ * This struct contains common parameters used by both the drawing of the
+ * test pattern and the drawing of the extras (borders, square, etc.)
+ */
+struct tpg_draw_params {
+	/* common data */
+	bool is_tv;
+	bool is_60hz;
+	unsigned twopixsize;
+	unsigned img_width;
+	unsigned stride;
+	unsigned hmax;
+	unsigned frame_line;
+	unsigned frame_line_next;
+
+	/* test pattern */
+	unsigned mv_hor_old;
+	unsigned mv_hor_new;
+	unsigned mv_vert_old;
+	unsigned mv_vert_new;
+
+	/* extras */
+	unsigned wss_width;
+	unsigned wss_random_offset;
+	unsigned sav_eav_f;
+	unsigned left_pillar_width;
+	unsigned right_pillar_start;
+};
+
 void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 {
 	bool is_tv = std;
-- 
2.1.4

