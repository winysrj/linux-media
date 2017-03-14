Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37423 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdCNTGj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:39 -0400
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
Subject: [PATCH v3 14/27] rcar-vin: move media bus configuration to struct rvin_info
Date: Tue, 14 Mar 2017 20:02:55 +0100
Message-Id: <20170314190308.25790-15-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bus configuration will once the driver is extended to to support Gen3
contain information not specific to only the directly connected parallel
subdevice. Move it to struct rvin_info to show it's not always coupled
to the parallel subdevice.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 14 +++++++-------
 drivers/media/platform/rcar-vin/rcar-dma.c  | 11 ++++++-----
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  2 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  9 ++++-----
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 998617711f1ad045..ed99b1abb99e9ef9 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -45,15 +45,15 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
 	return -EINVAL;
 }
 
-static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
+static bool rvin_mbus_supported(struct rvin_dev *vin)
 {
-	struct v4l2_subdev *sd = entity->subdev;
+	struct v4l2_subdev *sd = vin->digital.subdev;
 	struct v4l2_subdev_mbus_code_enum code = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 
 	code.index = 0;
-	code.pad = entity->source_pad;
+	code.pad = vin->digital.source_pad;
 	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
 		code.index++;
 		switch (code.code) {
@@ -61,7 +61,7 @@ static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
 		case MEDIA_BUS_FMT_UYVY8_2X8:
 		case MEDIA_BUS_FMT_UYVY10_2X10:
 		case MEDIA_BUS_FMT_RGB888_1X24:
-			entity->code = code.code;
+			vin->code = code.code;
 			return true;
 		default:
 			break;
@@ -77,14 +77,14 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 	int ret;
 
 	/* Verify subdevices mbus format */
-	if (!rvin_mbus_supported(&vin->digital)) {
+	if (!rvin_mbus_supported(vin)) {
 		vin_err(vin, "Unsupported media bus format for %s\n",
 			vin->digital.subdev->name);
 		return -EINVAL;
 	}
 
 	vin_dbg(vin, "Found media bus format for %s: %d\n",
-		vin->digital.subdev->name, vin->digital.code);
+		vin->digital.subdev->name, vin->code);
 
 	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
 	if (ret < 0) {
@@ -201,7 +201,7 @@ static int rvin_digital_graph_parse(struct rvin_dev *vin)
 	}
 	of_node_put(np);
 
-	ret = rvin_digitial_parse_v4l2(vin, ep, &vin->digital.mbus_cfg);
+	ret = rvin_digitial_parse_v4l2(vin, ep, &vin->mbus_cfg);
 	of_node_put(ep);
 	if (ret)
 		return ret;
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index ef029e4c7882322e..2931ba7998709307 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -634,7 +634,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	/*
 	 * Input interface
 	 */
-	switch (vin->digital.code) {
+	switch (vin->code) {
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
@@ -642,7 +642,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
-		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
 		input_is_yuv = true;
 		break;
@@ -651,7 +651,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
-		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
 		input_is_yuv = true;
 		break;
@@ -663,11 +663,11 @@ static int rvin_setup(struct rvin_dev *vin)
 	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
 
 	/* Hsync Signal Polarity Select */
-	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
+	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_HPS;
 
 	/* Vsync Signal Polarity Select */
-	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
+	if (!(vin->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_VPS;
 
 	/*
@@ -887,6 +887,7 @@ static void rvin_capture_stop(struct rvin_dev *vin)
 	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
 }
 
+
 /* -----------------------------------------------------------------------------
  * DMA Functions
  */
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 28b62a514bbb93a9..1ee9dcb621350f77 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -180,7 +180,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	sd = vin_to_source(vin);
 
-	v4l2_fill_mbus_format(&format.format, pix, vin->digital.code);
+	v4l2_fill_mbus_format(&format.format, pix, vin->code);
 
 	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
 	if (pad_cfg == NULL)
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 4805127b7af879a3..43206e85bbaadb5b 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -62,8 +62,6 @@ struct rvin_video_format {
  * struct rvin_graph_entity - Video endpoint from async framework
  * @asd:	sub-device descriptor for async framework
  * @subdev:	subdevice matched using async framework
- * @code:	Media bus format from source
- * @mbus_cfg:	Media bus format from DT
  * @source_pad:	source pad of remote subdevice
  * @sink_pad:	sink pad of remote subdevice
  */
@@ -71,9 +69,6 @@ struct rvin_graph_entity {
 	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *subdev;
 
-	u32 code;
-	struct v4l2_mbus_config mbus_cfg;
-
 	unsigned int source_pad;
 	unsigned int sink_pad;
 };
@@ -115,6 +110,8 @@ struct rvin_info {
  * @sequence:		V4L2 buffers sequence number
  * @state:		keeps track of operation state
  *
+ * @mbus_cfg:		media bus format from DT
+ * @code:		media bus coide from subdevice
  * @format:		active V4L2 pixel format
  *
  * @crop:		active cropping
@@ -141,6 +138,8 @@ struct rvin_dev {
 	unsigned int sequence;
 	enum rvin_dma_state state;
 
+	struct v4l2_mbus_config mbus_cfg;
+	u32 code;
 	struct v4l2_pix_format format;
 
 	struct v4l2_rect crop;
-- 
2.12.0
