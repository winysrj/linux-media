Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37375 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797AbbCIPqd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:46:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/29] vivid-tpg: add helper functions for single buffer planar formats
Date: Mon,  9 Mar 2015 16:44:32 +0100
Message-Id: <1425915891-1017-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add helpers functions to determine the line widths and image sizes
for planar formats that are stores in a single buffer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 18 ++++++++++-
 drivers/media/platform/vivid/vivid-tpg.h | 53 +++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 7463f78..767879e0 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1317,7 +1317,7 @@ void tpg_calc_text_basep(struct tpg_data *tpg,
 		basep[p][0] += tpg->buf_height * stride / 2;
 }
 
-void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
+void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 {
 	bool is_tv = std;
 	bool is_60hz = is_tv && (std & V4L2_STD_525_60);
@@ -1577,3 +1577,19 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 		}
 	}
 }
+
+void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
+{
+	unsigned offset = 0;
+	unsigned i;
+
+	if (tpg->buffers > 1) {
+		tpg_fill_plane_buffer(tpg, std, p, vbuf);
+		return;
+	}
+
+	for (i = 0; i < tpg->planes; i++) {
+		tpg_fill_plane_buffer(tpg, std, i, vbuf + offset);
+		offset += tpg_calc_plane_size(tpg, i);
+	}
+}
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index 9ce2d01..b90ce7d 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -189,6 +189,7 @@ void tpg_gen_text(struct tpg_data *tpg,
 		u8 *basep[TPG_MAX_PLANES][2], int y, int x, char *text);
 void tpg_calc_text_basep(struct tpg_data *tpg,
 		u8 *basep[TPG_MAX_PLANES][2], unsigned p, u8 *vbuf);
+void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf);
 void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf);
 bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc);
 void tpg_s_crop_compose(struct tpg_data *tpg, const struct v4l2_rect *crop,
@@ -350,7 +351,57 @@ static inline unsigned tpg_g_bytesperline(const struct tpg_data *tpg, unsigned p
 
 static inline void tpg_s_bytesperline(struct tpg_data *tpg, unsigned plane, unsigned bpl)
 {
-	tpg->bytesperline[plane] = bpl;
+	unsigned p;
+
+	if (tpg->buffers > 1) {
+		tpg->bytesperline[plane] = bpl;
+		return;
+	}
+
+	for (p = 0; p < tpg->planes; p++) {
+		unsigned plane_w = bpl * tpg->twopixelsize[p] / tpg->twopixelsize[0];
+
+		tpg->bytesperline[p] = plane_w;
+	}
+}
+
+static inline unsigned tpg_g_line_width(const struct tpg_data *tpg, unsigned plane)
+{
+	unsigned w = 0;
+	unsigned p;
+
+	if (tpg->buffers > 1)
+		return tpg_g_bytesperline(tpg, plane);
+	for (p = 0; p < tpg->planes; p++) {
+		unsigned plane_w = tpg_g_bytesperline(tpg, p);
+
+		w += plane_w;
+	}
+	return w;
+}
+
+static inline unsigned tpg_calc_line_width(const struct tpg_data *tpg,
+					   unsigned plane, unsigned bpl)
+{
+	unsigned w = 0;
+	unsigned p;
+
+	if (tpg->buffers > 1)
+		return bpl;
+	for (p = 0; p < tpg->planes; p++) {
+		unsigned plane_w = bpl * tpg->twopixelsize[p] / tpg->twopixelsize[0];
+
+		w += plane_w;
+	}
+	return w;
+}
+
+static inline unsigned tpg_calc_plane_size(const struct tpg_data *tpg, unsigned plane)
+{
+	if (plane >= tpg->planes)
+		return 0;
+
+	return tpg_g_bytesperline(tpg, plane) * tpg->buf_height;
 }
 
 static inline void tpg_s_buf_height(struct tpg_data *tpg, unsigned h)
-- 
2.1.4

