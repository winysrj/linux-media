Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34129 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbbCIPpp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:45:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/29] vivid: fix test pattern movement for V4L2_FIELD_ALTERNATE
Date: Mon,  9 Mar 2015 16:44:27 +0100
Message-Id: <1425915891-1017-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The successive TOP/BOTTOM fields did not move as they should: only
every other field actually changed position.

The cause was that the tpg needs to know if it is dealing with a
FIELD_ALTERNATE case since that requires slightly different handling.

So tell the TPG whether or not the field setting is for the ALTERNATE
case or not.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-kthread-cap.c | 3 ++-
 drivers/media/platform/vivid/vivid-tpg.c         | 4 +++-
 drivers/media/platform/vivid/vivid-tpg.h         | 4 +++-
 drivers/media/platform/vivid/vivid-vid-cap.c     | 5 ++++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 9898072..9976d45 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -436,7 +436,8 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	} else {
 		buf->vb.v4l2_buf.field = dev->field_cap;
 	}
-	tpg_s_field(&dev->tpg, buf->vb.v4l2_buf.field);
+	tpg_s_field(&dev->tpg, buf->vb.v4l2_buf.field,
+		    dev->field_cap == V4L2_FIELD_ALTERNATE);
 	tpg_s_perc_fill_blank(&dev->tpg, dev->must_blank[buf->vb.v4l2_buf.index]);
 
 	vivid_precalc_copy_rects(dev);
diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 34493f4..8fa2150 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1409,7 +1409,9 @@ void tpg_fillbuffer(struct tpg_data *tpg, v4l2_std_id std, unsigned p, u8 *vbuf)
 			linestart_older += line_offset;
 			linestart_newer += line_offset;
 		}
-		if (is_60hz) {
+		if (tpg->field_alternate) {
+			linestart_top = linestart_bottom = linestart_older;
+		} else if (is_60hz) {
 			linestart_top = linestart_newer;
 			linestart_bottom = linestart_older;
 		} else {
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index bd8b1c7..8100425 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -98,6 +98,7 @@ struct tpg_data {
 	/* Scaled output frame size */
 	unsigned			scaled_width;
 	u32				field;
+	bool				field_alternate;
 	/* crop coordinates are frame-based */
 	struct v4l2_rect		crop;
 	/* compose coordinates are format-based */
@@ -348,9 +349,10 @@ static inline void tpg_s_buf_height(struct tpg_data *tpg, unsigned h)
 	tpg->buf_height = h;
 }
 
-static inline void tpg_s_field(struct tpg_data *tpg, unsigned field)
+static inline void tpg_s_field(struct tpg_data *tpg, unsigned field, bool alternate)
 {
 	tpg->field = field;
+	tpg->field_alternate = alternate;
 }
 
 static inline void tpg_s_perc_fill(struct tpg_data *tpg,
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 49f79a0..d41ac44 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -733,7 +733,10 @@ int vivid_s_fmt_vid_cap(struct file *file, void *priv,
 	if (tpg_g_planes(&dev->tpg) > 1)
 		tpg_s_bytesperline(&dev->tpg, 1, mp->plane_fmt[1].bytesperline);
 	dev->field_cap = mp->field;
-	tpg_s_field(&dev->tpg, dev->field_cap);
+	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
+		tpg_s_field(&dev->tpg, V4L2_FIELD_TOP, true);
+	else
+		tpg_s_field(&dev->tpg, dev->field_cap, false);
 	tpg_s_crop_compose(&dev->tpg, &dev->crop_cap, &dev->compose_cap);
 	tpg_s_fourcc(&dev->tpg, dev->fmt_cap->fourcc);
 	if (vivid_is_sdtv_cap(dev))
-- 
2.1.4

