Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:35261 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbbCIPr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:47:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 19/29] vivid-tpg: add const where appropriate
Date: Mon,  9 Mar 2015 16:44:41 +0100
Message-Id: <1425915891-1017-20-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Added 'const' to several functions where that is possible to do.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 8 ++++----
 drivers/media/platform/vivid/vivid-tpg.h | 8 +++++---
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index a919363..2f78ccd 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1241,8 +1241,8 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
 /* need this to do rgb24 rendering */
 typedef struct { u16 __; u8 _; } __packed x24;
 
-void tpg_gen_text(struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
-		int y, int x, char *text)
+void tpg_gen_text(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
+		  int y, int x, char *text)
 {
 	int line;
 	unsigned step = V4L2_FIELD_HAS_T_OR_B(tpg->field) ? 2 : 1;
@@ -1389,7 +1389,7 @@ void tpg_update_mv_step(struct tpg_data *tpg)
 }
 
 /* Map the line number relative to the crop rectangle to a frame line number */
-static unsigned tpg_calc_frameline(struct tpg_data *tpg, unsigned src_y,
+static unsigned tpg_calc_frameline(const struct tpg_data *tpg, unsigned src_y,
 				    unsigned field)
 {
 	switch (field) {
@@ -1406,7 +1406,7 @@ static unsigned tpg_calc_frameline(struct tpg_data *tpg, unsigned src_y,
  * Map the line number relative to the compose rectangle to a destination
  * buffer line number.
  */
-static unsigned tpg_calc_buffer_line(struct tpg_data *tpg, unsigned y,
+static unsigned tpg_calc_buffer_line(const struct tpg_data *tpg, unsigned y,
 				    unsigned field)
 {
 	y += tpg->compose.top;
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index b62f392..82ce9bf 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -193,12 +193,14 @@ void tpg_reset_source(struct tpg_data *tpg, unsigned width, unsigned height,
 		       u32 field);
 
 void tpg_set_font(const u8 *f);
-void tpg_gen_text(struct tpg_data *tpg,
+void tpg_gen_text(const struct tpg_data *tpg,
 		u8 *basep[TPG_MAX_PLANES][2], int y, int x, char *text);
 void tpg_calc_text_basep(struct tpg_data *tpg,
 		u8 *basep[TPG_MAX_PLANES][2], unsigned p, u8 *vbuf);
-void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf);
-void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf);
+void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std,
+			   unsigned p, u8 *vbuf);
+void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std,
+		    unsigned p, u8 *vbuf);
 bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc);
 void tpg_s_crop_compose(struct tpg_data *tpg, const struct v4l2_rect *crop,
 		const struct v4l2_rect *compose);
-- 
2.1.4

