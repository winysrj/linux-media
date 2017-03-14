Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37413 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751922AbdCNTGp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:45 -0400
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
Subject: [PATCH v3 25/27] rcar-vin: extend {start,stop}_streaming to work with media controller
Date: Tue, 14 Mar 2017 20:03:06 +0100
Message-Id: <20170314190308.25790-26-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The procedure to start or stop streaming using the none MC single
subdevice and the MC graph and multiple subdevices are quiet different.
Create a new function to abstract which method is used based on which
mode the driver is running in and add logic to start the MC graph.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 82 +++++++++++++++++++++++++++---
 1 file changed, 75 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 34f01f32bab7bd32..2a525bb3506c2e37 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1099,15 +1099,85 @@ static void rvin_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&vin->qlock, flags);
 }
 
+static int rvin_set_stream(struct rvin_dev *vin, int on)
+{
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct media_pipeline *pipe;
+	struct  v4l2_subdev *sd;
+	struct media_pad *pad;
+	int ret = -EPIPE;
+
+	/* Not media controller used, simply pass operation to subdevice */
+	if (!vin->info->use_mc) {
+		ret = v4l2_subdev_call(vin->digital.subdev, video, s_stream,
+				       on);
+
+		return ret == -ENOIOCTLCMD ? 0 : ret;
+	}
+	mutex_lock(&vin->group->lock);
+
+	pad = media_entity_remote_pad(&vin->pad);
+	if (!pad)
+		goto out;
+
+	sd = media_entity_to_v4l2_subdev(pad->entity);
+	if (!sd)
+		goto out;
+
+	if (on) {
+		fmt.pad = pad->index;
+		if (v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt))
+			goto out;
+
+		switch (fmt.format.code) {
+		case MEDIA_BUS_FMT_YUYV8_1X16:
+		case MEDIA_BUS_FMT_UYVY8_2X8:
+		case MEDIA_BUS_FMT_UYVY10_2X10:
+		case MEDIA_BUS_FMT_RGB888_1X24:
+			vin->code = fmt.format.code;
+			break;
+		default:
+			goto out;
+		}
+
+		if (fmt.format.width != vin->format.width ||
+		    fmt.format.height != vin->format.height)
+			goto out;
+
+		pipe = sd->entity.pipe ? sd->entity.pipe : &vin->vdev->pipe;
+		if (media_pipeline_start(&vin->vdev->entity, pipe))
+			goto out;
+
+		ret = v4l2_subdev_call(sd, video, s_stream, 1);
+		if (ret == -ENOIOCTLCMD)
+			ret = 0;
+		if (ret)
+			media_pipeline_stop(&vin->vdev->entity);
+	} else {
+		media_pipeline_stop(&vin->vdev->entity);
+		ret = v4l2_subdev_call(sd, video, s_stream, 0);
+	}
+out:
+	mutex_unlock(&vin->group->lock);
+
+	return ret;
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
+	ret = rvin_set_stream(vin, 1);
+	if (ret) {
+		spin_lock_irqsave(&vin->qlock, flags);
+		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
+		spin_unlock_irqrestore(&vin->qlock, flags);
+		return ret;
+	}
 
 	spin_lock_irqsave(&vin->qlock, flags);
 
@@ -1116,7 +1186,7 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 	ret = rvin_capture_start(vin);
 	if (ret) {
 		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
-		v4l2_subdev_call(sd, video, s_stream, 0);
+		rvin_set_stream(vin, 0);
 	}
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
@@ -1127,7 +1197,6 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 static void rvin_stop_streaming(struct vb2_queue *vq)
 {
 	struct rvin_dev *vin = vb2_get_drv_priv(vq);
-	struct v4l2_subdev *sd;
 	unsigned long flags;
 	int retries = 0;
 
@@ -1166,8 +1235,7 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
 
-	sd = vin_to_source(vin);
-	v4l2_subdev_call(sd, video, s_stream, 0);
+	rvin_set_stream(vin, 0);
 
 	/* disable interrupts */
 	rvin_disable_interrupts(vin);
-- 
2.12.0
