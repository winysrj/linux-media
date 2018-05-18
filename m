Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:58493 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752002AbeEROlf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:41:35 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 4/9] media: rcar-vin: Cache the mbus configuration flags
Date: Fri, 18 May 2018 16:40:40 +0200
Message-Id: <1526654445-10702-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Media bus configuration flags and media bus type were so far a property
of each VIN instance, as the subdevice they were connected to was
immutable during the whole system life time.

With the forth-coming introduction of parallel input devices support,
a VIN instance can have the subdevice it is connected to switched at
runtime, from a CSI-2 subdevice to a parallel one and viceversa, through
the modification of links between media entities in the media controller
graph. To avoid discarding the per-subdevice configuration flags retrieved by
v4l2_fwnode parsing facilities, cache them in the 'rvin_graph_entity'
member of each VIN instance, opportunely renamed to 'rvin_parallel_entity'.

Also modify the register configuration function to take mbus flags into
account when running on a bus type that supports them.

The media bus type currently in use will be updated in a follow-up patch
to the link state change notification function.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 23 ++++++++++-------------
 drivers/media/platform/rcar-vin/rcar-dma.c  | 24 +++++++++++++++++-------
 drivers/media/platform/rcar-vin/rcar-vin.h  | 22 ++++++++++++++++------
 3 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index c6e603f..0a35a98 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -524,30 +524,30 @@ static int rvin_parallel_parse_v4l2(struct device *dev,
 				    struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = dev_get_drvdata(dev);
-	struct rvin_graph_entity *rvge =
-		container_of(asd, struct rvin_graph_entity, asd);
+	struct rvin_parallel_entity *rvpe =
+		container_of(asd, struct rvin_parallel_entity, asd);
 
 	if (vep->base.port || vep->base.id)
 		return -ENOTCONN;
 
-	vin->mbus_cfg.type = vep->bus_type;
+	vin->is_csi = false;
+	vin->parallel = rvpe;
+	vin->parallel->mbus_type = vep->bus_type;
 
-	switch (vin->mbus_cfg.type) {
+	switch (vin->parallel->mbus_type) {
 	case V4L2_MBUS_PARALLEL:
 		vin_dbg(vin, "Found PARALLEL media bus\n");
-		vin->mbus_cfg.flags = vep->bus.parallel.flags;
+		vin->parallel->mbus_flags = vep->bus.parallel.flags;
 		break;
 	case V4L2_MBUS_BT656:
 		vin_dbg(vin, "Found BT656 media bus\n");
-		vin->mbus_cfg.flags = 0;
+		vin->parallel->mbus_flags = 0;
 		break;
 	default:
 		vin_err(vin, "Unknown media bus type\n");
 		return -EINVAL;
 	}
 
-	vin->parallel = rvge;
-
 	return 0;
 }
 
@@ -557,7 +557,7 @@ static int rvin_parallel_graph_init(struct rvin_dev *vin)
 
 	ret = v4l2_async_notifier_parse_fwnode_endpoints(
 		vin->dev, &vin->notifier,
-		sizeof(struct rvin_graph_entity), rvin_parallel_parse_v4l2);
+		sizeof(struct rvin_parallel_entity), rvin_parallel_parse_v4l2);
 	if (ret)
 		return ret;
 
@@ -718,6 +718,7 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
 		return -ENOTCONN;
 	}
 
+	vin->is_csi = true;
 	vin->group->csi[vep->base.id].fwnode = asd->match.fwnode;
 
 	vin_dbg(vin, "Add group OF device %pOF to slot %u\n",
@@ -783,10 +784,6 @@ static int rvin_mc_init(struct rvin_dev *vin)
 {
 	int ret;
 
-	/* All our sources are CSI-2 */
-	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
-	vin->mbus_cfg.flags = 0;
-
 	vin->pad.flags = MEDIA_PAD_FL_SINK;
 	ret = media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
 	if (ret)
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index f1c3585..17f291f 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -659,8 +659,12 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
-		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
-			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
+		if (!vin->is_csi &&
+		    vin->parallel->mbus_type == V4L2_MBUS_BT656)
+			vnmc |= VNMC_INF_YUV8_BT656;
+		else
+			vnmc |= VNMC_INF_YUV8_BT601;
+
 		input_is_yuv = true;
 		break;
 	case MEDIA_BUS_FMT_RGB888_1X24:
@@ -668,8 +672,12 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
-		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
-			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
+		if (!vin->is_csi &&
+		    vin->parallel->mbus_type == V4L2_MBUS_BT656)
+			vnmc |= VNMC_INF_YUV10_BT656;
+		else
+			vnmc |= VNMC_INF_YUV10_BT601;
+
 		input_is_yuv = true;
 		break;
 	default:
@@ -683,11 +691,13 @@ static int rvin_setup(struct rvin_dev *vin)
 		dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
 
 	/* Hsync Signal Polarity Select */
-	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
+	if (!vin->is_csi &&
+	    !(vin->parallel->mbus_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_HPS;
 
 	/* Vsync Signal Polarity Select */
-	if (!(vin->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
+	if (!vin->is_csi &&
+	    !(vin->parallel->mbus_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_VPS;
 
 	/*
@@ -734,7 +744,7 @@ static int rvin_setup(struct rvin_dev *vin)
 
 	if (vin->info->model == RCAR_GEN3) {
 		/* Select between CSI-2 and parallel input */
-		if (vin->mbus_cfg.type == V4L2_MBUS_CSI2)
+		if (vin->is_csi)
 			vnmc &= ~VNMC_DPINE;
 		else
 			vnmc |= VNMC_DPINE;
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 7d0ffe08..c5f7fd1 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -73,16 +73,22 @@ struct rvin_video_format {
 };
 
 /**
- * struct rvin_graph_entity - Video endpoint from async framework
+ * struct rvin_parallel_entity - Parallel video input endpoint descriptor
  * @asd:	sub-device descriptor for async framework
  * @subdev:	subdevice matched using async framework
+ * @mbus_type:	media bus type
+ * @mbus_flags:	media bus configuration flags
  * @source_pad:	source pad of remote subdevice
  * @sink_pad:	sink pad of remote subdevice
+ *
  */
-struct rvin_graph_entity {
+struct rvin_parallel_entity {
 	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *subdev;
 
+	enum v4l2_mbus_type mbus_type;
+	unsigned int mbus_flags;
+
 	unsigned int source_pad;
 	unsigned int sink_pad;
 };
@@ -146,7 +152,8 @@ struct rvin_info {
  * @v4l2_dev:		V4L2 device
  * @ctrl_handler:	V4L2 control handler
  * @notifier:		V4L2 asynchronous subdevs notifier
- * @parallel:		entity in the DT for local parallel subdevice
+ *
+ * @parallel:		parallel input subdevice descriptor
  *
  * @group:		Gen3 CSI group
  * @id:			Gen3 group id for this VIN
@@ -164,7 +171,8 @@ struct rvin_info {
  * @sequence:		V4L2 buffers sequence number
  * @state:		keeps track of operation state
  *
- * @mbus_cfg:		media bus configuration from DT
+ * @is_csi:		flag to mark the VIN as using a CSI-2 subdevice
+ *
  * @mbus_code:		media bus format code
  * @format:		active V4L2 pixel format
  *
@@ -182,7 +190,8 @@ struct rvin_dev {
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_async_notifier notifier;
-	struct rvin_graph_entity *parallel;
+
+	struct rvin_parallel_entity *parallel;
 
 	struct rvin_group *group;
 	unsigned int id;
@@ -199,7 +208,8 @@ struct rvin_dev {
 	unsigned int sequence;
 	enum rvin_dma_state state;
 
-	struct v4l2_mbus_config mbus_cfg;
+	bool is_csi;
+
 	u32 mbus_code;
 	struct v4l2_pix_format format;
 
-- 
2.7.4
