Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:56074 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbcGSOXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:23:15 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 10/16] [media] rcar-vin: move media bus information to struct rvin_graph_entity
Date: Tue, 19 Jul 2016 16:21:01 +0200
Message-Id: <20160719142107.22358-11-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The primary reason for this change is to prepare for Gen3 support where
there will be more then one possible video source. Each source will have
its own media bus format and code, so it needs to be moved from the per
device structure to a structure used to represent an individual
connection to a video source.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 12 ++++++------
 drivers/media/platform/rcar-vin/rcar-dma.c  | 10 +++++-----
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  2 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  9 +++++----
 4 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 6934940..fa1fa53 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -31,9 +31,9 @@
 
 #define notifier_to_vin(n) container_of(n, struct rvin_dev, notifier)
 
-static bool rvin_mbus_supported(struct rvin_dev *vin)
+static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
 {
-	struct v4l2_subdev *sd = vin->digital.subdev;
+	struct v4l2_subdev *sd = entity->subdev;
 	struct v4l2_subdev_mbus_code_enum code = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
@@ -47,7 +47,7 @@ static bool rvin_mbus_supported(struct rvin_dev *vin)
 		case MEDIA_BUS_FMT_UYVY8_2X8:
 		case MEDIA_BUS_FMT_UYVY10_2X10:
 		case MEDIA_BUS_FMT_RGB888_1X24:
-			vin->source.code = code.code;
+			entity->code = code.code;
 			return true;
 		default:
 			break;
@@ -97,14 +97,14 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 	int ret;
 
 	/* Verify subdevices mbus format */
-	if (!rvin_mbus_supported(vin)) {
+	if (!rvin_mbus_supported(&vin->digital)) {
 		vin_err(vin, "Unsupported media bus format for %s\n",
 			vin->digital.subdev->name);
 		return -EINVAL;
 	}
 
 	vin_dbg(vin, "Found media bus format for %s: %d\n",
-		vin->digital.subdev->name, vin->source.code);
+		vin->digital.subdev->name, vin->digital.code);
 
 	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
 	if (ret < 0) {
@@ -205,7 +205,7 @@ static int rvin_digital_graph_parse(struct rvin_dev *vin)
 	}
 	of_node_put(np);
 
-	ret = rvin_digitial_parse_v4l2(vin, ep, &vin->mbus_cfg);
+	ret = rvin_digitial_parse_v4l2(vin, ep, &vin->digital.mbus_cfg);
 	of_node_put(ep);
 	if (ret)
 		return ret;
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 7249c4f..79e7963 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -163,7 +163,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	/*
 	 * Input interface
 	 */
-	switch (vin->source.code) {
+	switch (vin->digital.code) {
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
@@ -171,7 +171,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
-		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
 		input_is_yuv = true;
 		break;
@@ -180,7 +180,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
-		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
 		input_is_yuv = true;
 		break;
@@ -192,11 +192,11 @@ static int rvin_setup(struct rvin_dev *vin)
 	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
 
 	/* Hsync Signal Polarity Select */
-	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
+	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_HPS;
 
 	/* Vsync Signal Polarity Select */
-	if (!(vin->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
+	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_VPS;
 
 	/*
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index ef3464d..d0e9d65 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -106,7 +106,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	sd = vin_to_source(vin);
 
-	v4l2_fill_mbus_format(&format.format, pix, vin->source.code);
+	v4l2_fill_mbus_format(&format.format, pix, vin->digital.code);
 
 	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
 	if (pad_cfg == NULL)
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 8f25c4b..972eb30 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -50,12 +50,10 @@ enum rvin_dma_state {
 
 /**
  * struct rvin_source_fmt - Source information
- * @code:	Media bus format from source
  * @width:	Width from source
  * @height:	Height from source
  */
 struct rvin_source_fmt {
-	u32 code;
 	u32 width;
 	u32 height;
 };
@@ -74,10 +72,15 @@ struct rvin_video_format {
  * struct rvin_graph_entity - Video endpoint from async framework
  * @asd:	sub-device descriptor for async framework
  * @subdev:	subdevice matched using async framework
+ * @code:	Media bus format from source
+ * @mbus_cfg:	Media bus format from DT
  */
 struct rvin_graph_entity {
 	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *subdev;
+
+	u32 code;
+	struct v4l2_mbus_config mbus_cfg;
 };
 
 /**
@@ -85,7 +88,6 @@ struct rvin_graph_entity {
  * @dev:		(OF) device
  * @base:		device I/O register space remapped to virtual memory
  * @chip:		type of VIN chip
- * @mbus_cfg		media bus configuration
  *
  * @vdev:		V4L2 video device associated with VIN
  * @v4l2_dev:		V4L2 device
@@ -116,7 +118,6 @@ struct rvin_dev {
 	struct device *dev;
 	void __iomem *base;
 	enum chip_id chip;
-	struct v4l2_mbus_config mbus_cfg;
 
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
-- 
2.9.0

