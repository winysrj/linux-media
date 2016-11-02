Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49638 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754583AbcKBN3s (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 09:29:48 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 27/32] media: rcar-vin: start/stop the CSI2 bridge stream
Date: Wed,  2 Nov 2016 14:23:24 +0100
Message-Id: <20161102132329.436-28-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Gen3 the CSI2 bridge stream needs to be start/stop in conjunction
with the video source. Create helpers to deal with both the Gen2 single
subdevice case and the Gen3 CSI2 group case.

In the Gen3 case there might be other simultaneous users of the bridge
and source devices so examine each entity stream_count before acting on
any particular device.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 84 +++++++++++++++++++++++++++---
 1 file changed, 77 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 322e4c1..872f138 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1089,15 +1089,87 @@ static void rvin_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&vin->qlock, flags);
 }
 
+static int __rvin_start_streaming(struct rvin_dev *vin)
+{
+	struct v4l2_subdev *source, *bridge = NULL;
+	struct media_pipeline *pipe;
+	int ret;
+
+	source = vin_to_source(vin);
+	if (!source)
+		return -EINVAL;
+
+	if (vin_have_bridge(vin)) {
+		bridge = vin_to_bridge(vin);
+
+		if (!bridge)
+			return -EINVAL;
+
+		mutex_lock(&vin->group->lock);
+
+		pipe = bridge->entity.pipe ? bridge->entity.pipe :
+			&vin->vdev.pipe;
+		ret = media_entity_pipeline_start(&vin->vdev.entity, pipe);
+		if (ret) {
+			mutex_unlock(&vin->group->lock);
+			return ret;
+		}
+
+		/* Only need to start stream if it's not running */
+		if (bridge->entity.stream_count <= 1)
+			v4l2_subdev_call(bridge, video, s_stream, 1);
+		if (source->entity.stream_count <= 1)
+			v4l2_subdev_call(source, video, s_stream, 1);
+
+		mutex_unlock(&vin->group->lock);
+	} else {
+		v4l2_subdev_call(source, video, s_stream, 1);
+	}
+
+	return 0;
+}
+
+static int __rvin_stop_streaming(struct rvin_dev *vin)
+{
+	struct v4l2_subdev *source, *bridge = NULL;
+
+	source = vin_to_source(vin);
+	if (!source)
+		return -EINVAL;
+
+	if (vin_have_bridge(vin)) {
+		bridge = vin_to_bridge(vin);
+
+		if (!bridge)
+			return -EINVAL;
+
+		mutex_lock(&vin->group->lock);
+
+		media_entity_pipeline_stop(&vin->vdev.entity);
+
+		/* Only need to stop stream if there are no other users */
+		if (bridge->entity.stream_count <= 0)
+			v4l2_subdev_call(bridge, video, s_stream, 0);
+		if (source->entity.stream_count <= 0)
+			v4l2_subdev_call(source, video, s_stream, 0);
+
+		mutex_unlock(&vin->group->lock);
+	} else {
+		v4l2_subdev_call(source, video, s_stream, 0);
+	}
+
+	return 0;
+}
+
 static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct rvin_dev *vin = vb2_get_drv_priv(vq);
-	struct v4l2_subdev *sd;
 	unsigned long flags;
 	int ret;
 
-	sd = vin_to_source(vin);
-	v4l2_subdev_call(sd, video, s_stream, 1);
+	ret = __rvin_start_streaming(vin);
+	if (ret)
+		return ret;
 
 	spin_lock_irqsave(&vin->qlock, flags);
 
@@ -1122,7 +1194,7 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* Return all buffers if something went wrong */
 	if (ret) {
 		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
-		v4l2_subdev_call(sd, video, s_stream, 0);
+		__rvin_stop_streaming(vin);
 	}
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
@@ -1133,7 +1205,6 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 static void rvin_stop_streaming(struct vb2_queue *vq)
 {
 	struct rvin_dev *vin = vb2_get_drv_priv(vq);
-	struct v4l2_subdev *sd;
 	unsigned long flags;
 	int retries = 0;
 
@@ -1172,8 +1243,7 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
 
-	sd = vin_to_source(vin);
-	v4l2_subdev_call(sd, video, s_stream, 0);
+	__rvin_stop_streaming(vin);
 
 	/* disable interrupts */
 	rvin_disable_interrupts(vin);
-- 
2.10.2

