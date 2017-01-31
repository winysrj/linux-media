Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:44323 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbdAaPuD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 10:50:03 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 06/11] media: rcar-vin: move subdev source and sink pad index to rvin_graph_entity
Date: Tue, 31 Jan 2017 16:40:11 +0100
Message-Id: <20170131154016.15526-7-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It makes more sens to store the sink and source pad index in struct
rvin_graph_entity since that contains other subdevice related
information. Add complete documentation for struct rvin_graph_entity
while we are at it.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 45 ++++++++++++++++++++++-------
 drivers/media/platform/rcar-vin/rcar-vin.h  | 17 ++++++-----
 2 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 370bb184e5faace7..f8ff7c43944dd64a 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -109,9 +109,14 @@ static int rvin_reset_format(struct rvin_dev *vin)
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	struct rvin_graph_entity *rent;
 	int ret;
 
-	fmt.pad = vin->src_pad_idx;
+	rent = vin_to_entity(vin);
+	if (!rent)
+		return -ENODEV;
+
+	fmt.pad = rent->source_pad_idx;
 
 	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
 	if (ret)
@@ -182,7 +187,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	if (pad_cfg == NULL)
 		return -ENOMEM;
 
-	format.pad = vin->src_pad_idx;
+	format.pad = rent->source_pad_idx;
 
 	field = pix->field;
 
@@ -560,12 +565,17 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
+	struct rvin_graph_entity *rent;
 	int ret;
 
+	rent = vin_to_entity(vin);
+	if (!rent)
+		return -ENODEV;
+
 	if (timings->pad)
 		return -EINVAL;
 
-	timings->pad = vin->sink_pad_idx;
+	timings->pad = rent->sink_pad_idx;
 
 	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
 
@@ -612,12 +622,17 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
+	struct rvin_graph_entity *rent;
 	int ret;
 
+	rent = vin_to_entity(vin);
+	if (!rent)
+		return -ENODEV;
+
 	if (cap->pad)
 		return -EINVAL;
 
-	cap->pad = vin->sink_pad_idx;
+	cap->pad = rent->sink_pad_idx;
 
 	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
 
@@ -630,12 +645,17 @@ static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
+	struct rvin_graph_entity *rent;
 	int ret;
 
+	rent = vin_to_entity(vin);
+	if (!rent)
+		return -ENODEV;
+
 	if (edid->pad)
 		return -EINVAL;
 
-	edid->pad = vin->sink_pad_idx;
+	edid->pad = rent->sink_pad_idx;
 
 	ret = v4l2_subdev_call(sd, pad, get_edid, edid);
 
@@ -648,12 +668,17 @@ static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
+	struct rvin_graph_entity *rent;
 	int ret;
 
+	rent = vin_to_entity(vin);
+	if (!rent)
+		return -ENODEV;
+
 	if (edid->pad)
 		return -EINVAL;
 
-	edid->pad = vin->sink_pad_idx;
+	edid->pad = rent->sink_pad_idx;
 
 	ret = v4l2_subdev_call(sd, pad, set_edid, edid);
 
@@ -926,19 +951,19 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
 
-	vin->src_pad_idx = 0;
+	vin->digital.source_pad_idx = 0;
 	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
 		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SOURCE)
 			break;
 	if (pad_idx >= sd->entity.num_pads)
 		return -EINVAL;
 
-	vin->src_pad_idx = pad_idx;
+	vin->digital.source_pad_idx = pad_idx;
 
-	vin->sink_pad_idx = 0;
+	vin->digital.sink_pad_idx = 0;
 	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
 		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SINK) {
-			vin->sink_pad_idx = pad_idx;
+			vin->digital.sink_pad_idx = pad_idx;
 			break;
 		}
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index daec26a38d896b21..d31212a992e15506 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -70,10 +70,12 @@ struct rvin_video_format {
 
 /**
  * struct rvin_graph_entity - Video endpoint from async framework
- * @asd:	sub-device descriptor for async framework
- * @subdev:	subdevice matched using async framework
- * @code:	Media bus format from source
- * @mbus_cfg:	Media bus format from DT
+ * @asd:		sub-device descriptor for async framework
+ * @subdev:		subdevice matched using async framework
+ * @code:		Media bus format from source
+ * @mbus_cfg:		Media bus format from DT
+ * @source_pad_idx:	source pad index on remote device
+ * @sink_pad_idx:	sink pad index on remote device
  */
 struct rvin_graph_entity {
 	struct v4l2_async_subdev asd;
@@ -81,6 +83,9 @@ struct rvin_graph_entity {
 
 	u32 code;
 	struct v4l2_mbus_config mbus_cfg;
+
+	int source_pad_idx;
+	int sink_pad_idx;
 };
 
 /**
@@ -91,8 +96,6 @@ struct rvin_graph_entity {
  *
  * @vdev:		V4L2 video device associated with VIN
  * @v4l2_dev:		V4L2 device
- * @src_pad_idx:	source pad index for media controller drivers
- * @sink_pad_idx:	sink pad index for media controller drivers
  * @ctrl_handler:	V4L2 control handler
  * @notifier:		V4L2 asynchronous subdevs notifier
  * @digital:		entity in the DT for local digital subdevice
@@ -121,8 +124,6 @@ struct rvin_dev {
 
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
-	int src_pad_idx;
-	int sink_pad_idx;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_async_notifier notifier;
 	struct rvin_graph_entity digital;
-- 
2.11.0

