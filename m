Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:60223 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751255AbeDXXrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 19:47:04 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] rcar-vin: add support for MEDIA_BUS_FMT_UYVY8_1X16
Date: Wed, 25 Apr 2018 01:46:07 +0200
Message-Id: <20180424234607.22867-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By setting VNMC_YCAL rcar-vin can support input video in
MEDIA_BUS_FMT_UYVY8_1X16 format.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 1 +
 drivers/media/platform/rcar-vin/rcar-dma.c  | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 55b745ac86a5884d..7bc2774a11232362 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -404,6 +404,7 @@ static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
 		code.index++;
 		switch (code.code) {
 		case MEDIA_BUS_FMT_YUYV8_1X16:
+		case MEDIA_BUS_FMT_UYVY8_1X16:
 		case MEDIA_BUS_FMT_UYVY8_2X8:
 		case MEDIA_BUS_FMT_UYVY10_2X10:
 		case MEDIA_BUS_FMT_RGB888_1X24:
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 4a3a195e7f59047c..ac07f99e3516a620 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -653,6 +653,10 @@ static int rvin_setup(struct rvin_dev *vin)
 		vnmc |= VNMC_INF_YUV16;
 		input_is_yuv = true;
 		break;
+	case MEDIA_BUS_FMT_UYVY8_1X16:
+		vnmc |= VNMC_INF_YUV16 | VNMC_YCAL;
+		input_is_yuv = true;
+		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
 		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
@@ -1009,6 +1013,7 @@ static int rvin_mc_validate_format(struct rvin_dev *vin, struct v4l2_subdev *sd,
 
 	switch (fmt.format.code) {
 	case MEDIA_BUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 	case MEDIA_BUS_FMT_UYVY10_2X10:
 	case MEDIA_BUS_FMT_RGB888_1X24:
-- 
2.17.0
