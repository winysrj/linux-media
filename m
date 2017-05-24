Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:46751 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756155AbdEXARB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:17:01 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 05/17] rcar-vin: move subdev source and sink pad index to rvin_graph_entity
Date: Wed, 24 May 2017 02:15:28 +0200
Message-Id: <20170524001540.13613-6-niklas.soderlund@ragnatech.se>
In-Reply-To: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
References: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

It makes more sense to store the sink and source pads in struct
rvin_graph_entity since that contains other subdevice related
information.

The data type to store pad information in is unsigned int and not int,
change this. While we are at it drop the _idx suffix from the names,
this never made sense.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 20 ++++++++++----------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  9 +++++----
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 7be52c2036bb35fc..1a75191539b0e7d7 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -111,7 +111,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	int ret;
 
-	fmt.pad = vin->src_pad_idx;
+	fmt.pad = vin->digital.source_pad;
 
 	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
 	if (ret)
@@ -178,7 +178,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	if (pad_cfg == NULL)
 		return -ENOMEM;
 
-	format.pad = vin->src_pad_idx;
+	format.pad = vin->digital.source_pad;
 
 	field = pix->field;
 
@@ -559,7 +559,7 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
 	if (timings->pad)
 		return -EINVAL;
 
-	timings->pad = vin->sink_pad_idx;
+	timings->pad = vin->digital.sink_pad;
 
 	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
 
@@ -611,7 +611,7 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
 	if (cap->pad)
 		return -EINVAL;
 
-	cap->pad = vin->sink_pad_idx;
+	cap->pad = vin->digital.sink_pad;
 
 	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
 
@@ -629,7 +629,7 @@ static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
 	if (edid->pad)
 		return -EINVAL;
 
-	edid->pad = vin->sink_pad_idx;
+	edid->pad = vin->digital.sink_pad;
 
 	ret = v4l2_subdev_call(sd, pad, get_edid, edid);
 
@@ -647,7 +647,7 @@ static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
 	if (edid->pad)
 		return -EINVAL;
 
-	edid->pad = vin->sink_pad_idx;
+	edid->pad = vin->digital.sink_pad;
 
 	ret = v4l2_subdev_call(sd, pad, set_edid, edid);
 
@@ -920,19 +920,19 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
 
-	vin->src_pad_idx = 0;
+	vin->digital.source_pad = 0;
 	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
 		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SOURCE)
 			break;
 	if (pad_idx >= sd->entity.num_pads)
 		return -EINVAL;
 
-	vin->src_pad_idx = pad_idx;
+	vin->digital.source_pad = pad_idx;
 
-	vin->sink_pad_idx = 0;
+	vin->digital.sink_pad = 0;
 	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
 		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SINK) {
-			vin->sink_pad_idx = pad_idx;
+			vin->digital.sink_pad = pad_idx;
 			break;
 		}
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 727e215c08718eb9..9bfb5a7c4dc4f215 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -74,6 +74,8 @@ struct rvin_video_format {
  * @subdev:	subdevice matched using async framework
  * @code:	Media bus format from source
  * @mbus_cfg:	Media bus format from DT
+ * @source_pad:	source pad of remote subdevice
+ * @sink_pad:	sink pad of remote subdevice
  */
 struct rvin_graph_entity {
 	struct v4l2_async_subdev asd;
@@ -81,6 +83,9 @@ struct rvin_graph_entity {
 
 	u32 code;
 	struct v4l2_mbus_config mbus_cfg;
+
+	unsigned int source_pad;
+	unsigned int sink_pad;
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
2.13.0
