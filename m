Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:54502 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752588AbdK2ToO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:44:14 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v8 25/28] rcar-vin: extend {start,stop}_streaming to work with media controller
Date: Wed, 29 Nov 2017 20:43:39 +0100
Message-Id: <20171129194342.26239-26-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171129194342.26239-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171129194342.26239-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The procedure to start or stop streaming using the non-MC single
subdevice and the MC graph and multiple subdevices are quite different.
Create a new function to abstract which method is used based on which
mode the driver is running in and add logic to start the MC graph.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 112 +++++++++++++++++++++++++++--
 1 file changed, 105 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 6c5df13b30d6dd14..8a6674a891aab357 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1087,15 +1087,115 @@ static void rvin_buffer_queue(struct vb2_buffer *vb)
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
+	int ret;
+
+	/* No media controller used, simply pass operation to subdevice */
+	if (!vin->info->use_mc) {
+		ret = v4l2_subdev_call(vin->digital->subdev, video, s_stream,
+				       on);
+
+		return ret == -ENOIOCTLCMD ? 0 : ret;
+	}
+
+	pad = media_entity_remote_pad(&vin->pad);
+	if (!pad)
+		return -EPIPE;
+
+	sd = media_entity_to_v4l2_subdev(pad->entity);
+	if (!sd)
+		return -EPIPE;
+
+	if (!on) {
+		media_pipeline_stop(&vin->vdev.entity);
+		return v4l2_subdev_call(sd, video, s_stream, 0);
+	}
+
+	fmt.pad = pad->index;
+	if (v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt))
+		return -EPIPE;
+
+	switch (fmt.format.code) {
+	case MEDIA_BUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY10_2X10:
+	case MEDIA_BUS_FMT_RGB888_1X24:
+		vin->code = fmt.format.code;
+		break;
+	default:
+		return -EPIPE;
+	}
+
+	switch (fmt.format.field) {
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_NONE:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_SEQ_TB:
+	case V4L2_FIELD_SEQ_BT:
+		/* Supported natively */
+		break;
+	case V4L2_FIELD_ALTERNATE:
+		switch (vin->format.field) {
+		case V4L2_FIELD_TOP:
+		case V4L2_FIELD_BOTTOM:
+		case V4L2_FIELD_NONE:
+			break;
+		case V4L2_FIELD_INTERLACED_TB:
+		case V4L2_FIELD_INTERLACED_BT:
+		case V4L2_FIELD_INTERLACED:
+		case V4L2_FIELD_SEQ_TB:
+		case V4L2_FIELD_SEQ_BT:
+			/* Use VIN hardware to combine the two fields */
+			fmt.format.height *= 2;
+			break;
+		default:
+			return -EPIPE;
+		}
+		break;
+	default:
+		return -EPIPE;
+	}
+
+	if (fmt.format.width != vin->format.width ||
+	    fmt.format.height != vin->format.height)
+		return -EPIPE;
+
+	pipe = sd->entity.pipe ? sd->entity.pipe : &vin->vdev.pipe;
+	if (media_pipeline_start(&vin->vdev.entity, pipe))
+		return -EPIPE;
+
+	ret = v4l2_subdev_call(sd, video, s_stream, 1);
+	if (ret == -ENOIOCTLCMD)
+		ret = 0;
+	if (ret)
+		media_pipeline_stop(&vin->vdev.entity);
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
 
@@ -1104,7 +1204,7 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 	ret = rvin_capture_start(vin);
 	if (ret) {
 		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
-		v4l2_subdev_call(sd, video, s_stream, 0);
+		rvin_set_stream(vin, 0);
 	}
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
@@ -1115,7 +1215,6 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 static void rvin_stop_streaming(struct vb2_queue *vq)
 {
 	struct rvin_dev *vin = vb2_get_drv_priv(vq);
-	struct v4l2_subdev *sd;
 	unsigned long flags;
 	int retries = 0;
 
@@ -1154,8 +1253,7 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
 
-	sd = vin_to_source(vin);
-	v4l2_subdev_call(sd, video, s_stream, 0);
+	rvin_set_stream(vin, 0);
 
 	/* disable interrupts */
 	rvin_disable_interrupts(vin);
-- 
2.15.0
