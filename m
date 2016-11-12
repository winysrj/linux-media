Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33452 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964936AbcKLNNq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:46 -0500
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
Subject: [PATCHv2 15/32] media: rcar-vin: move max width and height information to chip information
Date: Sat, 12 Nov 2016 14:11:59 +0100
Message-Id: <20161112131216.22635-16-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Gen3 the max supported width and height will be different from Gen2.
Move the limits to the struct chip_info to prepare for Gen3 support.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 6 ++++++
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 6 ++----
 drivers/media/platform/rcar-vin/rcar-vin.h  | 6 ++++++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index c80bbbc..def240b1 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -255,14 +255,20 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 
 static const struct rvin_info rcar_info_h1 = {
 	.chip = RCAR_H1,
+	.max_width = 2048,
+	.max_height = 2048,
 };
 
 static const struct rvin_info rcar_info_m1 = {
 	.chip = RCAR_M1,
+	.max_width = 2048,
+	.max_height = 2048,
 };
 
 static const struct rvin_info rcar_info_gen2 = {
 	.chip = RCAR_GEN2,
+	.max_width = 2048,
+	.max_height = 2048,
 };
 
 static const struct of_device_id rvin_of_id_table[] = {
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 05b0181..f5fbe9f 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -23,8 +23,6 @@
 #include "rcar-vin.h"
 
 #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
-#define RVIN_MAX_WIDTH		2048
-#define RVIN_MAX_HEIGHT		2048
 
 /* -----------------------------------------------------------------------------
  * Format Conversions
@@ -271,8 +269,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
 
 	/* Limit to VIN capabilities */
-	v4l_bound_align_image(&pix->width, 2, RVIN_MAX_WIDTH, walign,
-			      &pix->height, 4, RVIN_MAX_HEIGHT, 2, 0);
+	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
+			      &pix->height, 4, vin->info->max_height, 2, 0);
 
 	pix->bytesperline = max_t(u32, pix->bytesperline,
 				  rvin_format_bytesperline(pix));
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 17a5fce..ddeca9f 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -91,9 +91,15 @@ struct rvin_graph_entity {
 /**
  * struct rvin_info- Information about the particular VIN implementation
  * @chip:		type of VIN chip
+ *
+ * max_width:		max input with the VIN supports
+ * max_height:		max input height the VIN supports
  */
 struct rvin_info {
 	enum chip_id chip;
+
+	unsigned int max_width;
+	unsigned int max_height;
 };
 
 /**
-- 
2.10.2

