Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:56024 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbcGSOXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:23:11 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 06/16] [media] rcar-vin: cosmetic clean up in preparation for Gen3
Date: Tue, 19 Jul 2016 16:20:57 +0200
Message-Id: <20160719142107.22358-7-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The main purpose of this commit is to make consecutive patches easier to
read. This is achieved with the following changes.

- Rename the variable 'entity' in struct rvin_dev to 'digital'. When we
  add Gen3 support later this will only deal with the digital input
  source.

- Rename all functions dealing with the v4l2 async framework and DT
  parsing for the digital input from rvin_graph_* to rvin_digital_*.

- Reduce indentation in rvin_s_dv_timings() and use 'ret' instead of
  'err' for return value variable as used in the rest of the driver.

- Order enum chip_id in chronological order.

- Fix indentation errors in rcar-v4l2.c which for some reason had bad
  indentations at some locations.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 46 ++++++++++----------
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 66 ++++++++++++++---------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  8 ++--
 3 files changed, 59 insertions(+), 61 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index ff27d75..6744325 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -95,7 +95,7 @@ static int rvin_mbus_supported(struct rvin_dev *vin)
 	return false;
 }
 
-static int rvin_graph_notify_complete(struct v4l2_async_notifier *notifier)
+static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 	int ret;
@@ -114,31 +114,31 @@ static int rvin_graph_notify_complete(struct v4l2_async_notifier *notifier)
 	return rvin_v4l2_probe(vin);
 }
 
-static void rvin_graph_notify_unbind(struct v4l2_async_notifier *notifier,
-				     struct v4l2_subdev *sd,
-				     struct v4l2_async_subdev *asd)
+static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
+				       struct v4l2_subdev *subdev,
+				       struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 
 	rvin_v4l2_remove(vin);
 }
 
-static int rvin_graph_notify_bound(struct v4l2_async_notifier *notifier,
-				   struct v4l2_subdev *subdev,
-				   struct v4l2_async_subdev *asd)
+static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
+				     struct v4l2_subdev *subdev,
+				     struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 
 	vin_dbg(vin, "subdev %s bound\n", subdev->name);
 
-	vin->entity.entity = &subdev->entity;
-	vin->entity.subdev = subdev;
+	vin->digital.entity = &subdev->entity;
+	vin->digital.subdev = subdev;
 
 	return 0;
 }
 
-static int rvin_graph_parse(struct rvin_dev *vin,
-			    struct device_node *node)
+static int rvin_digital_parse(struct rvin_dev *vin,
+			      struct device_node *node)
 {
 	struct device_node *remote;
 	struct device_node *ep = NULL;
@@ -166,10 +166,10 @@ static int rvin_graph_parse(struct rvin_dev *vin,
 		}
 
 		/* Remote node to connect */
-		if (!vin->entity.node) {
-			vin->entity.node = remote;
-			vin->entity.asd.match_type = V4L2_ASYNC_MATCH_OF;
-			vin->entity.asd.match.of.node = remote;
+		if (!vin->digital.node) {
+			vin->digital.node = remote;
+			vin->digital.asd.match_type = V4L2_ASYNC_MATCH_OF;
+			vin->digital.asd.match.of.node = remote;
 			ret++;
 		}
 	}
@@ -179,13 +179,13 @@ static int rvin_graph_parse(struct rvin_dev *vin,
 	return ret;
 }
 
-static int rvin_graph_init(struct rvin_dev *vin)
+static int rvin_digital_init(struct rvin_dev *vin)
 {
 	struct v4l2_async_subdev **subdevs = NULL;
 	int ret;
 
 	/* Parse the graph to extract a list of subdevice DT nodes. */
-	ret = rvin_graph_parse(vin, vin->dev->of_node);
+	ret = rvin_digital_parse(vin, vin->dev->of_node);
 	if (ret < 0) {
 		vin_err(vin, "Graph parsing failed\n");
 		goto done;
@@ -208,13 +208,13 @@ static int rvin_graph_init(struct rvin_dev *vin)
 		goto done;
 	}
 
-	subdevs[0] = &vin->entity.asd;
+	subdevs[0] = &vin->digital.asd;
 
 	vin->notifier.subdevs = subdevs;
 	vin->notifier.num_subdevs = 1;
-	vin->notifier.bound = rvin_graph_notify_bound;
-	vin->notifier.unbind = rvin_graph_notify_unbind;
-	vin->notifier.complete = rvin_graph_notify_complete;
+	vin->notifier.bound = rvin_digital_notify_bound;
+	vin->notifier.unbind = rvin_digital_notify_unbind;
+	vin->notifier.complete = rvin_digital_notify_complete;
 
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
 	if (ret < 0) {
@@ -227,7 +227,7 @@ static int rvin_graph_init(struct rvin_dev *vin)
 done:
 	if (ret < 0) {
 		v4l2_async_notifier_unregister(&vin->notifier);
-		of_node_put(vin->entity.node);
+		of_node_put(vin->digital.node);
 	}
 
 	return ret;
@@ -324,7 +324,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = rvin_graph_init(vin);
+	ret = rvin_digital_init(vin);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 5dceff8..3f80a0b 100644
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
@@ -132,9 +132,9 @@ done:
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
@@ -218,7 +218,7 @@ static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
 	struct rvin_source_fmt source;
 
 	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
-				     &source);
+				 &source);
 }
 
 static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
@@ -232,7 +232,7 @@ static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
 		return -EBUSY;
 
 	ret = __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
-				    &source);
+				&source);
 	if (ret)
 		return ret;
 
@@ -333,8 +333,8 @@ static int rvin_s_selection(struct file *file, void *fh,
 		vin->crop = s->r = r;
 
 		vin_dbg(vin, "Cropped %dx%d@%d:%d of %dx%d\n",
-			 r.width, r.height, r.left, r.top,
-			 vin->source.width, vin->source.height);
+			r.width, r.height, r.left, r.top,
+			vin->source.width, vin->source.height);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
 		/* Make sure compose rect fits inside output format */
@@ -358,8 +358,8 @@ static int rvin_s_selection(struct file *file, void *fh,
 		vin->compose = s->r = r;
 
 		vin_dbg(vin, "Compose %dx%d@%d:%d in %dx%d\n",
-			 r.width, r.height, r.left, r.top,
-			 vin->format.width, vin->format.height);
+			r.width, r.height, r.left, r.top,
+			vin->format.width, vin->format.height);
 		break;
 	default:
 		return -EINVAL;
@@ -482,7 +482,7 @@ static int rvin_subscribe_event(struct v4l2_fh *fh,
 }
 
 static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
-				    struct v4l2_enum_dv_timings *timings)
+				struct v4l2_enum_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
@@ -499,45 +499,44 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
 }
 
 static int rvin_s_dv_timings(struct file *file, void *priv_fh,
-				    struct v4l2_dv_timings *timings)
+			     struct v4l2_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
-	int err;
-
-	err = v4l2_subdev_call(sd,
-			video, s_dv_timings, timings);
-	if (!err) {
-		vin->source.width = timings->bt.width;
-		vin->source.height = timings->bt.height;
-		vin->format.width = timings->bt.width;
-		vin->format.height = timings->bt.height;
-	}
-	return err;
+	int ret;
+
+	ret = v4l2_subdev_call(sd, video, s_dv_timings, timings);
+	if (ret)
+		return ret;
+
+	vin->source.width = timings->bt.width;
+	vin->source.height = timings->bt.height;
+	vin->format.width = timings->bt.width;
+	vin->format.height = timings->bt.height;
+
+	return 0;
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
@@ -824,8 +823,7 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vin->src_pad_idx = 0;
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
-		if (sd->entity.pads[pad_idx].flags
-				== MEDIA_PAD_FL_SOURCE)
+		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SOURCE)
 			break;
 	if (pad_idx >= sd->entity.num_pads)
 		return -EINVAL;
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index a6dd6db..9488ca3 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -30,9 +30,9 @@
 #define HW_BUFFER_MASK 0x7f
 
 enum chip_id {
-	RCAR_GEN2,
 	RCAR_H1,
 	RCAR_M1,
+	RCAR_GEN2,
 };
 
 /**
@@ -90,7 +90,7 @@ struct rvin_graph_entity {
  * @src_pad_idx:	source pad index for media controller drivers
  * @ctrl_handler:	V4L2 control handler
  * @notifier:		V4L2 asynchronous subdevs notifier
- * @entity:		entity in the DT for subdevice
+ * @digital:		entity in the DT for local digital subdevice
  *
  * @lock:		protects @queue
  * @queue:		vb2 buffers queue
@@ -121,7 +121,7 @@ struct rvin_dev {
 	int src_pad_idx;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_async_notifier notifier;
-	struct rvin_graph_entity entity;
+	struct rvin_graph_entity digital;
 
 	struct mutex lock;
 	struct vb2_queue queue;
@@ -141,7 +141,7 @@ struct rvin_dev {
 	struct v4l2_rect compose;
 };
 
-#define vin_to_source(vin)		vin->entity.subdev
+#define vin_to_source(vin)		vin->digital.subdev
 
 /* Debug */
 #define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
-- 
2.9.0

