Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:22517 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1163973AbeCBB7N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:59:13 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 17/32] rcar-vin: move media bus configuration to struct rvin_info
Date: Fri,  2 Mar 2018 02:57:36 +0100
Message-Id: <20180302015751.25596-18-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
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
---
 drivers/media/platform/rcar-vin/rcar-core.c | 18 +++++++++---------
 drivers/media/platform/rcar-vin/rcar-dma.c  | 11 ++++++-----
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  2 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  9 ++++-----
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index cc863e4ec9a4d4b3..449175c3133e42c6 100644
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
@@ -190,16 +190,16 @@ static int rvin_digital_parse_v4l2(struct device *dev,
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
index c8831e189d362c8b..4ebf76c30a3e9117 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -633,7 +633,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	/*
 	 * Input interface
 	 */
-	switch (vin->digital->code) {
+	switch (vin->mbus_code) {
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
@@ -641,7 +641,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
-		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
 		input_is_yuv = true;
 		break;
@@ -650,7 +650,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
-		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
 		input_is_yuv = true;
 		break;
@@ -662,11 +662,11 @@ static int rvin_setup(struct rvin_dev *vin)
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
@@ -875,6 +875,7 @@ static void rvin_capture_stop(struct rvin_dev *vin)
 	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
 }
 
+
 /* -----------------------------------------------------------------------------
  * DMA Functions
  */
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 55640c6b2a1200ca..20be21cb1cf521e5 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -199,7 +199,7 @@ static int rvin_try_format(struct rvin_dev *vin, u32 which,
 	if (pad_cfg == NULL)
 		return -ENOMEM;
 
-	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
+	v4l2_fill_mbus_format(&format.format, pix, vin->mbus_code);
 
 	/* Allow the video device to override field and to scale */
 	field = pix->field;
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 39051da31650bd79..491f3187b932f81e 100644
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
@@ -114,6 +109,8 @@ struct rvin_info {
  * @sequence:		V4L2 buffers sequence number
  * @state:		keeps track of operation state
  *
+ * @mbus_cfg:		media bus configuration from DT
+ * @mbus_code:		media bus format code
  * @format:		active V4L2 pixel format
  *
  * @crop:		active cropping
@@ -140,6 +137,8 @@ struct rvin_dev {
 	unsigned int sequence;
 	enum rvin_dma_state state;
 
+	struct v4l2_mbus_config mbus_cfg;
+	u32 mbus_code;
 	struct v4l2_pix_format format;
 
 	struct v4l2_rect crop;
-- 
2.16.2
