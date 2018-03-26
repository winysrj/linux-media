Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:32368 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752462AbeCZVqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:46:50 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v13 18/33] rcar-vin: move media bus configuration to struct rvin_dev
Date: Mon, 26 Mar 2018 23:44:41 +0200
Message-Id: <20180326214456.6655-19-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bus configuration will once the driver is extended to support Gen3
contain information not specific to only the directly connected parallel
subdevice. Move it to struct rvin_dev to show it's not always coupled
to the parallel subdevice.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 18 +++++++++---------
 drivers/media/platform/rcar-vin/rcar-dma.c  | 10 +++++-----
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  2 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  9 ++++-----
 4 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 8c251687e81b345b..07a04d4bcc91b18b 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -65,10 +65,10 @@ static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
 	vin->digital->sink_pad = ret < 0 ? 0 : ret;
 
 	/* Find compatible subdevices mbus format */
-	vin->digital->code = 0;
+	vin->mbus_code = 0;
 	code.index = 0;
 	code.pad = vin->digital->source_pad;
-	while (!vin->digital->code &&
+	while (!vin->mbus_code &&
 	       !v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
 		code.index++;
 		switch (code.code) {
@@ -76,16 +76,16 @@ static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
 		case MEDIA_BUS_FMT_UYVY8_2X8:
 		case MEDIA_BUS_FMT_UYVY10_2X10:
 		case MEDIA_BUS_FMT_RGB888_1X24:
-			vin->digital->code = code.code;
+			vin->mbus_code = code.code;
 			vin_dbg(vin, "Found media bus format for %s: %d\n",
-				subdev->name, vin->digital->code);
+				subdev->name, vin->mbus_code);
 			break;
 		default:
 			break;
 		}
 	}
 
-	if (!vin->digital->code) {
+	if (!vin->mbus_code) {
 		vin_err(vin, "Unsupported media bus format for %s\n",
 			subdev->name);
 		return -EINVAL;
@@ -196,16 +196,16 @@ static int rvin_digital_parse_v4l2(struct device *dev,
 	if (vep->base.port || vep->base.id)
 		return -ENOTCONN;
 
-	rvge->mbus_cfg.type = vep->bus_type;
+	vin->mbus_cfg.type = vep->bus_type;
 
-	switch (rvge->mbus_cfg.type) {
+	switch (vin->mbus_cfg.type) {
 	case V4L2_MBUS_PARALLEL:
 		vin_dbg(vin, "Found PARALLEL media bus\n");
-		rvge->mbus_cfg.flags = vep->bus.parallel.flags;
+		vin->mbus_cfg.flags = vep->bus.parallel.flags;
 		break;
 	case V4L2_MBUS_BT656:
 		vin_dbg(vin, "Found BT656 media bus\n");
-		rvge->mbus_cfg.flags = 0;
+		vin->mbus_cfg.flags = 0;
 		break;
 	default:
 		vin_err(vin, "Unknown media bus type\n");
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 79f4074b931b5aeb..41907a200037d5d5 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -626,7 +626,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	/*
 	 * Input interface
 	 */
-	switch (vin->digital->code) {
+	switch (vin->mbus_code) {
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
@@ -634,7 +634,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
-		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
 		input_is_yuv = true;
 		break;
@@ -643,7 +643,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
-		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
 		input_is_yuv = true;
 		break;
@@ -655,11 +655,11 @@ static int rvin_setup(struct rvin_dev *vin)
 	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
 
 	/* Hsync Signal Polarity Select */
-	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
+	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_HPS;
 
 	/* Vsync Signal Polarity Select */
-	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
+	if (!(vin->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_VPS;
 
 	/*
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 43370c57d4b6239a..dd835be0f9cbcc05 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -191,7 +191,7 @@ static int rvin_try_format(struct rvin_dev *vin, u32 which,
 	     pix->pixelformat == V4L2_PIX_FMT_XBGR32))
 		pix->pixelformat = RVIN_DEFAULT_FORMAT;
 
-	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
+	v4l2_fill_mbus_format(&format.format, pix, vin->mbus_code);
 
 	/* Allow the video device to override field and to scale */
 	field = pix->field;
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 06cec4f8e5ffaf2b..952d57f32873388d 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -60,8 +60,6 @@ struct rvin_video_format {
  * struct rvin_graph_entity - Video endpoint from async framework
  * @asd:	sub-device descriptor for async framework
  * @subdev:	subdevice matched using async framework
- * @code:	Media bus format from source
- * @mbus_cfg:	Media bus format from DT
  * @source_pad:	source pad of remote subdevice
  * @sink_pad:	sink pad of remote subdevice
  */
@@ -69,9 +67,6 @@ struct rvin_graph_entity {
 	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *subdev;
 
-	u32 code;
-	struct v4l2_mbus_config mbus_cfg;
-
 	unsigned int source_pad;
 	unsigned int sink_pad;
 };
@@ -113,6 +108,8 @@ struct rvin_info {
  * @sequence:		V4L2 buffers sequence number
  * @state:		keeps track of operation state
  *
+ * @mbus_cfg:		media bus configuration from DT
+ * @mbus_code:		media bus format code
  * @format:		active V4L2 pixel format
  *
  * @crop:		active cropping
@@ -142,6 +139,8 @@ struct rvin_dev {
 	unsigned int sequence;
 	enum rvin_dma_state state;
 
+	struct v4l2_mbus_config mbus_cfg;
+	u32 mbus_code;
 	struct v4l2_pix_format format;
 
 	struct v4l2_rect crop;
-- 
2.16.2
