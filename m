Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:54254 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbcHOPHP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 11:07:15 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	sergei.shtylyov@cogentembedded.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 01/10] [media] rcar-vin: fix indentation errors in rcar-v4l2.c
Date: Mon, 15 Aug 2016 17:06:26 +0200
Message-Id: <20160815150635.22637-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix broken indentations and line breaks.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 46 +++++++++++++----------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 10a5c10..f26e3cd 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -93,9 +93,9 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
  */
 
 static int __rvin_try_format_source(struct rvin_dev *vin,
-					u32 which,
-					struct v4l2_pix_format *pix,
-					struct rvin_source_fmt *source)
+				    u32 which,
+				    struct v4l2_pix_format *pix,
+				    struct rvin_source_fmt *source)
 {
 	struct v4l2_subdev *sd;
 	struct v4l2_subdev_pad_config *pad_cfg;
@@ -133,9 +133,9 @@ cleanup:
 }
 
 static int __rvin_try_format(struct rvin_dev *vin,
-				 u32 which,
-				 struct v4l2_pix_format *pix,
-				 struct rvin_source_fmt *source)
+			     u32 which,
+			     struct v4l2_pix_format *pix,
+			     struct rvin_source_fmt *source)
 {
 	const struct rvin_video_format *info;
 	u32 rwidth, rheight, walign;
@@ -219,7 +219,7 @@ static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
 	struct rvin_source_fmt source;
 
 	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
-				     &source);
+				 &source);
 }
 
 static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
@@ -233,7 +233,7 @@ static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
 		return -EBUSY;
 
 	ret = __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
-				    &source);
+				&source);
 	if (ret)
 		return ret;
 
@@ -334,8 +334,8 @@ static int rvin_s_selection(struct file *file, void *fh,
 		vin->crop = s->r = r;
 
 		vin_dbg(vin, "Cropped %dx%d@%d:%d of %dx%d\n",
-			 r.width, r.height, r.left, r.top,
-			 vin->source.width, vin->source.height);
+			r.width, r.height, r.left, r.top,
+			vin->source.width, vin->source.height);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
 		/* Make sure compose rect fits inside output format */
@@ -359,8 +359,8 @@ static int rvin_s_selection(struct file *file, void *fh,
 		vin->compose = s->r = r;
 
 		vin_dbg(vin, "Compose %dx%d@%d:%d in %dx%d\n",
-			 r.width, r.height, r.left, r.top,
-			 vin->format.width, vin->format.height);
+			r.width, r.height, r.left, r.top,
+			vin->format.width, vin->format.height);
 		break;
 	default:
 		return -EINVAL;
@@ -483,7 +483,7 @@ static int rvin_subscribe_event(struct v4l2_fh *fh,
 }
 
 static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
-				    struct v4l2_enum_dv_timings *timings)
+				struct v4l2_enum_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
@@ -500,14 +500,13 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
 }
 
 static int rvin_s_dv_timings(struct file *file, void *priv_fh,
-				    struct v4l2_dv_timings *timings)
+			     struct v4l2_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
 	int err;
 
-	err = v4l2_subdev_call(sd,
-			video, s_dv_timings, timings);
+	err = v4l2_subdev_call(sd, video, s_dv_timings, timings);
 	if (!err) {
 		vin->source.width = timings->bt.width;
 		vin->source.height = timings->bt.height;
@@ -518,27 +517,25 @@ static int rvin_s_dv_timings(struct file *file, void *priv_fh,
 }
 
 static int rvin_g_dv_timings(struct file *file, void *priv_fh,
-				    struct v4l2_dv_timings *timings)
+			     struct v4l2_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
 
-	return v4l2_subdev_call(sd,
-			video, g_dv_timings, timings);
+	return v4l2_subdev_call(sd, video, g_dv_timings, timings);
 }
 
 static int rvin_query_dv_timings(struct file *file, void *priv_fh,
-				    struct v4l2_dv_timings *timings)
+				 struct v4l2_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
 
-	return v4l2_subdev_call(sd,
-			video, query_dv_timings, timings);
+	return v4l2_subdev_call(sd, video, query_dv_timings, timings);
 }
 
 static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
-				    struct v4l2_dv_timings_cap *cap)
+			       struct v4l2_dv_timings_cap *cap)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
@@ -825,8 +822,7 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vin->src_pad_idx = 0;
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
-		if (sd->entity.pads[pad_idx].flags
-				== MEDIA_PAD_FL_SOURCE)
+		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SOURCE)
 			break;
 	if (pad_idx >= sd->entity.num_pads)
 		return -EINVAL;
-- 
2.9.2

