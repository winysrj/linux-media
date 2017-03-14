Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47148 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdCNTKI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:10:08 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 07/16] rcar-vin: move pad lookup to async bound handler
Date: Tue, 14 Mar 2017 19:59:48 +0100
Message-Id: <20170314185957.25253-8-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Information about pads will be needed when enumerating the media bus
codes in the async complete handler which is run before
rvin_v4l2_probe(). Move the pad lookup to the async bound handler so
they are available when needed.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 32 ++++++++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 24 ----------------------
 2 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 098a0b1cc10a26ba..d7aba15f6761259b 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -31,6 +31,20 @@
 
 #define notifier_to_vin(n) container_of(n, struct rvin_dev, notifier)
 
+static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
+{
+	unsigned int pad;
+
+	if (sd->entity.num_pads <= 1)
+		return 0;
+
+	for (pad = 0; pad < sd->entity.num_pads; pad++)
+		if (sd->entity.pads[pad].flags & direction)
+			return pad;
+
+	return -EINVAL;
+}
+
 static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
 {
 	struct v4l2_subdev *sd = entity->subdev;
@@ -101,12 +115,28 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
 				     struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
+	int ret;
 
 	v4l2_set_subdev_hostdata(subdev, vin);
 
 	if (vin->digital.asd.match.of.node == subdev->dev->of_node) {
-		vin_dbg(vin, "bound digital subdev %s\n", subdev->name);
+		/* Find surce and sink pad of remote subdevice */
+
+		ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
+		if (ret < 0)
+			return ret;
+		vin->digital.source_pad = ret;
+
+		ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
+		if (ret < 0)
+			return ret;
+		vin->digital.sink_pad = ret;
+
 		vin->digital.subdev = subdev;
+
+		vin_dbg(vin, "bound subdev %s source pad: %d sink pad: %d\n",
+			subdev->name, vin->digital.source_pad,
+			vin->digital.sink_pad);
 		return 0;
 	}
 
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index ce29a21888da48d5..be6f41bf82ac3bc5 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -870,20 +870,6 @@ static void rvin_notify(struct v4l2_subdev *sd,
 	}
 }
 
-static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
-{
-	unsigned int pad;
-
-	if (sd->entity.num_pads <= 1)
-		return 0;
-
-	for (pad = 0; pad < sd->entity.num_pads; pad++)
-		if (sd->entity.pads[pad].flags & direction)
-			return pad;
-
-	return -EINVAL;
-}
-
 int rvin_v4l2_probe(struct rvin_dev *vin)
 {
 	struct video_device *vdev = &vin->vdev;
@@ -934,16 +920,6 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
 
-	ret = rvin_find_pad(sd, MEDIA_PAD_FL_SOURCE);
-	if (ret < 0)
-		return ret;
-	vin->digital.source_pad = ret;
-
-	ret = rvin_find_pad(sd, MEDIA_PAD_FL_SINK);
-	if (ret < 0)
-		return ret;
-	vin->digital.sink_pad = ret;
-
 	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
 	rvin_reset_format(vin);
 
-- 
2.12.0
