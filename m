Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64596 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2KWPXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 10:23:00 -0500
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDY00H3B5EQT360@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 15:23:14 +0000 (GMT)
Received: from AMDC1061.digital.local ([106.116.147.88])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDY003BI5DXCUB0@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 15:22:59 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC 3/3] s5p-fimc: improved pipeline try format routine
Date: Fri, 23 Nov 2012 16:22:30 +0100
Message-id: <1353684150-24581-4-git-send-email-a.hajda@samsung.com>
In-reply-to: <1353684150-24581-1-git-send-email-a.hajda@samsung.com>
References: <1353684150-24581-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function support variable number of subdevs in pipe-line.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |  100 +++++++++++++++---------
 1 file changed, 64 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 3acbea3..39c4555 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -794,6 +794,21 @@ static int fimc_cap_enum_fmt_mplane(struct file *file, void *priv,
 	return 0;
 }
 
+static struct media_entity *fimc_pipeline_get_head(struct media_entity *me)
+{
+	struct media_pad *pad = &me->pads[0];
+
+	while (!(pad->flags & MEDIA_PAD_FL_SOURCE)) {
+		pad = media_entity_remote_source(pad);
+		if (!pad)
+			break;
+		me = pad->entity;
+		pad = &me->pads[0];
+	}
+
+	return me;
+}
+
 /**
  * fimc_pipeline_try_format - negotiate and/or set formats at pipeline
  *                            elements
@@ -809,65 +824,78 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
-	struct v4l2_subdev *csis = fimc->pipeline.subdevs[IDX_CSIS];
 	struct v4l2_subdev_format sfmt;
 	struct v4l2_mbus_framefmt *mf = &sfmt.format;
-	struct fimc_fmt *ffmt = NULL;
-	int ret, i = 0;
+	struct media_entity *me;
+	struct fimc_fmt *ffmt;
+	struct media_pad *pad;
+	int ret, i = 1;
+	u32 fcc;
 
 	if (WARN_ON(!sd || !tfmt))
 		return -EINVAL;
 
 	memset(&sfmt, 0, sizeof(sfmt));
 	sfmt.format = *tfmt;
-
 	sfmt.which = set ? V4L2_SUBDEV_FORMAT_ACTIVE : V4L2_SUBDEV_FORMAT_TRY;
+
+	me = fimc_pipeline_get_head(&sd->entity);
+
 	while (1) {
+
 		ffmt = fimc_find_format(NULL, mf->code != 0 ? &mf->code : NULL,
 					FMT_FLAGS_CAM, i++);
-		if (ffmt == NULL) {
-			/*
-			 * Notify user-space if common pixel code for
-			 * host and sensor does not exist.
-			 */
+		if (ffmt == NULL)
 			return -EINVAL;
-		}
+
 		mf->code = tfmt->code = ffmt->mbus_code;
 
-		ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &sfmt);
-		if (ret)
-			return ret;
-		if (mf->code != tfmt->code) {
-			mf->code = 0;
-			continue;
+		/* set format on all pipeline subdevs */
+		while (me != &fimc->vid_cap.subdev.entity) {
+			sd = media_entity_to_v4l2_subdev(me);
+
+			sfmt.pad = 0;
+			ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &sfmt);
+			if (ret)
+				return ret;
+
+			if (me->pads[0].flags & MEDIA_PAD_FL_SINK) {
+				sfmt.pad = me->num_pads - 1;
+				mf->code = tfmt->code;
+				ret = v4l2_subdev_call(sd, pad, set_fmt, NULL,
+									&sfmt);
+				if (ret)
+					return ret;
+			}
+
+			pad = media_entity_remote_source(&me->pads[sfmt.pad]);
+			if (!pad)
+				return -EINVAL;
+			me = pad->entity;
 		}
-		if (mf->width != tfmt->width || mf->height != tfmt->height) {
-			u32 fcc = ffmt->fourcc;
-			tfmt->width  = mf->width;
-			tfmt->height = mf->height;
-			ffmt = fimc_capture_try_format(ctx,
-					       &tfmt->width, &tfmt->height,
-					       NULL, &fcc, FIMC_SD_PAD_SOURCE);
-			if (ffmt && ffmt->mbus_code)
-				mf->code = ffmt->mbus_code;
-			if (mf->width != tfmt->width ||
-			    mf->height != tfmt->height)
-				continue;
-			tfmt->code = mf->code;
-		}
-		if (csis)
-			ret = v4l2_subdev_call(csis, pad, set_fmt, NULL, &sfmt);
 
-		if (mf->code == tfmt->code &&
-		    mf->width == tfmt->width && mf->height == tfmt->height)
-			break;
+		if (mf->code != tfmt->code)
+			continue;
+
+		fcc = ffmt->fourcc;
+		tfmt->width  = mf->width;
+		tfmt->height = mf->height;
+		ffmt = fimc_capture_try_format(ctx, &tfmt->width, &tfmt->height,
+					NULL, &fcc, FIMC_SD_PAD_SINK);
+		ffmt = fimc_capture_try_format(ctx, &tfmt->width, &tfmt->height,
+					NULL, &fcc, FIMC_SD_PAD_SOURCE);
+		if (ffmt && ffmt->mbus_code)
+			mf->code = ffmt->mbus_code;
+		if (mf->width != tfmt->width || mf->height != tfmt->height)
+			continue;
+		tfmt->code = mf->code;
+		break;
 	}
 
 	if (fmt_id && ffmt)
 		*fmt_id = ffmt;
 	*tfmt = *mf;
 
-	dbg("code: 0x%x, %dx%d, %p", mf->code, mf->width, mf->height, ffmt);
 	return 0;
 }
 
-- 
1.7.10.4

