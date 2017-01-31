Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:44324 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdAaPuD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 10:50:03 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 05/11] media: rcar-vin: add wrapper to get rvin_graph_entity
Date: Tue, 31 Jan 2017 16:40:10 +0100
Message-Id: <20170131154016.15526-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the driver to retrieve the code and mbus_cfg values from a
rvin_graph_entity retrieved from a wrapper function instead of directly
accessing the entity for the digital port. This is done to prepare for
Gen3 support where the subdeivce might change during runtime, so to
directly accesses a specific rvin_graph_entity is bad.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c |  9 +++++++++
 drivers/media/platform/rcar-vin/rcar-dma.c  | 15 ++++++++++-----
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  6 +++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  1 +
 4 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 098a0b1cc10a26ba..89a9280efa05aa0c 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -26,6 +26,15 @@
 #include "rcar-vin.h"
 
 /* -----------------------------------------------------------------------------
+ * Subdevice helpers
+ */
+
+struct rvin_graph_entity *vin_to_entity(struct rvin_dev *vin)
+{
+	return &vin->digital;
+}
+
+/* -----------------------------------------------------------------------------
  * Async notifier
  */
 
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 9ccd5ff55e192514..eac5c192b887ea45 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -131,10 +131,15 @@ static u32 rvin_read(struct rvin_dev *vin, u32 offset)
 
 static int rvin_setup(struct rvin_dev *vin)
 {
+	struct rvin_graph_entity *rent;
 	u32 vnmc, dmr, dmr2, interrupts;
 	v4l2_std_id std;
 	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
 
+	rent = vin_to_entity(vin);
+	if (!rent)
+		return -ENODEV;
+
 	switch (vin->format.field) {
 	case V4L2_FIELD_TOP:
 		vnmc = VNMC_IM_ODD;
@@ -174,7 +179,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	/*
 	 * Input interface
 	 */
-	switch (vin->digital.code) {
+	switch (rent->code) {
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
@@ -182,7 +187,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
-		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= rent->mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
 		input_is_yuv = true;
 		break;
@@ -191,7 +196,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
-		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= rent->mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
 		input_is_yuv = true;
 		break;
@@ -203,11 +208,11 @@ static int rvin_setup(struct rvin_dev *vin)
 	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
 
 	/* Hsync Signal Polarity Select */
-	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
+	if (!(rent->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_HPS;
 
 	/* Vsync Signal Polarity Select */
-	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
+	if (!(rent->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_VPS;
 
 	/*
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index f9218f230322eb0b..370bb184e5faace7 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -164,6 +164,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 {
 	struct v4l2_subdev *sd;
 	struct v4l2_subdev_pad_config *pad_cfg;
+	struct rvin_graph_entity *rent;
 	struct v4l2_subdev_format format = {
 		.which = which,
 	};
@@ -171,8 +172,11 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	int ret;
 
 	sd = vin_to_source(vin);
+	rent = vin_to_entity(vin);
+	if (!rent)
+		return -ENODEV;
 
-	v4l2_fill_mbus_format(&format.format, pix, vin->digital.code);
+	v4l2_fill_mbus_format(&format.format, pix, rent->code);
 
 	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
 	if (pad_cfg == NULL)
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 727e215c08718eb9..daec26a38d896b21 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -144,6 +144,7 @@ struct rvin_dev {
 	struct v4l2_rect compose;
 };
 
+struct rvin_graph_entity *vin_to_entity(struct rvin_dev *vin);
 #define vin_to_source(vin)		vin->digital.subdev
 
 /* Debug */
-- 
2.11.0

