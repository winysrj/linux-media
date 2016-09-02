Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:57792 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932311AbcIBPhp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 11:37:45 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        steve_longerbeam@mentor.com
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] [media] adv7180: rcar-vin: change mbus format to UYVY
Date: Fri,  2 Sep 2016 17:37:06 +0200
Message-Id: <20160902153706.512-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media bus format reported by the adv7180 is wrong. Steve Longerbeam
posted a patch which changed the format to UYVY8_2X8 with the commit
message:

  Change the media bus format from YUYV8_2X8 to UYVY8_2X8. Colors
  now look correct when capturing with the i.mx6 backend. The other
  option is to set the SWPC bit in register 0x27 to swap the Cr and Cb
  output samples.

The rcar-vin driver was developed and tested with the adv7180 and
therefor suffers from the same issue, looking for the wrong media bus
format. The two errors corrected each other.

This patch takes Steve's patch and merge it with a fix for rcar-vin
driver. The rcar-vin driver is used used in together with the adv7180
och Koelsch and this ensures it will not break while fixing the adv7180
issue. I checked wit Steve and he was fine with me merging the patches.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Suggested-by: Steve Longerbeam <steve_longerbeam@mentor.com>

ADV7180 parts:

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/media/i2c/adv7180.c                 | 4 ++--
 drivers/media/platform/rcar-vin/rcar-core.c | 4 ++--
 drivers/media/platform/rcar-vin/rcar-dma.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 515ea6a..a6ac78b 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -633,7 +633,7 @@ static int adv7180_enum_mbus_code(struct v4l2_subdev *sd,
 	if (code->index != 0)
 		return -EINVAL;
 
-	code->code = MEDIA_BUS_FMT_YUYV8_2X8;
+	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 	return 0;
 }
@@ -643,7 +643,7 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
 {
 	struct adv7180_state *state = to_state(sd);
 
-	fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
+	fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	fmt->width = 720;
 	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 64999a2..6219cba 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -43,8 +43,8 @@ static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
 		code.index++;
 		switch (code.code) {
 		case MEDIA_BUS_FMT_YUYV8_1X16:
-		case MEDIA_BUS_FMT_YUYV8_2X8:
-		case MEDIA_BUS_FMT_YUYV10_2X10:
+		case MEDIA_BUS_FMT_UYVY8_2X8:
+		case MEDIA_BUS_FMT_UYVY10_2X10:
 		case MEDIA_BUS_FMT_RGB888_1X24:
 			entity->code = code.code;
 			return true;
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 46abdb0..8c66a93 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -169,7 +169,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		vnmc |= VNMC_INF_YUV16;
 		input_is_yuv = true;
 		break;
-	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
 		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
@@ -178,7 +178,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	case MEDIA_BUS_FMT_RGB888_1X24:
 		vnmc |= VNMC_INF_RGB888;
 		break;
-	case MEDIA_BUS_FMT_YUYV10_2X10:
+	case MEDIA_BUS_FMT_UYVY10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
 		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
-- 
2.9.3

