Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49495 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752795AbcKBN3j (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 09:29:39 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 09/32] media: rcar-vin: move pad number discovery to async complete handler
Date: Wed,  2 Nov 2016 14:23:06 +0100
Message-Id: <20161102132329.436-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rvin_v4l2_probe() handler will with Gen3 support need to handle more
then one subdevice. To prepare for this move the digital subdev pad
number discover to the digital specific async notification complete
function.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 23 +++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 18 +-----------------
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 89a9280..2c40b6a 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -68,6 +68,8 @@ static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
 static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct v4l2_subdev *sd = vin->digital.subdev;
+	unsigned int pad_idx;
 	int ret;
 
 	/* Verify subdevices mbus format */
@@ -80,6 +82,27 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 	vin_dbg(vin, "Found media bus format for %s: %d\n",
 		vin->digital.subdev->name, vin->digital.code);
 
+	/* Figure out source and sink pad ids */
+	vin->digital.source_pad_idx = 0;
+	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
+		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SOURCE)
+			break;
+	if (pad_idx >= sd->entity.num_pads)
+		return -EINVAL;
+
+	vin->digital.source_pad_idx = pad_idx;
+
+	vin->digital.sink_pad_idx = 0;
+	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
+		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SINK) {
+			vin->digital.sink_pad_idx = pad_idx;
+			break;
+		}
+
+	vin_dbg(vin, "Found media pads for %s source: %d sink %d\n",
+		vin->digital.subdev->name, vin->digital.source_pad_idx,
+		vin->digital.sink_pad_idx);
+
 	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
 	if (ret < 0) {
 		vin_err(vin, "Failed to register subdev nodes\n");
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index f8ff7c4..51324c6 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -905,7 +905,7 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 {
 	struct video_device *vdev = &vin->vdev;
 	struct v4l2_subdev *sd = vin_to_source(vin);
-	int pad_idx, ret;
+	int ret;
 
 	v4l2_set_subdev_hostdata(sd, vin);
 
@@ -951,22 +951,6 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
 
-	vin->digital.source_pad_idx = 0;
-	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
-		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SOURCE)
-			break;
-	if (pad_idx >= sd->entity.num_pads)
-		return -EINVAL;
-
-	vin->digital.source_pad_idx = pad_idx;
-
-	vin->digital.sink_pad_idx = 0;
-	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
-		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SINK) {
-			vin->digital.sink_pad_idx = pad_idx;
-			break;
-		}
-
 	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
 	rvin_reset_format(vin);
 
-- 
2.10.2

