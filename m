Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:44255 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdAaPt5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 10:49:57 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 07/11] media: rcar-vin: move pad index discovery to async complete handler
Date: Tue, 31 Jan 2017 16:40:12 +0100
Message-Id: <20170131154016.15526-8-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To fix support for unbind and rebinding of subdevices the
rvin_v4l2_probe() needs to be called before there might be any subdevice
bound. Move pad index discovery to when we know the subdevice is
present.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 23 +++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 18 +-----------------
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 89a9280efa05aa0c..2c40b6a1a93f108c 100644
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
index f8ff7c43944dd64a..51324c6d826f76ea 100644
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
2.11.0

