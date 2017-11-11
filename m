Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47648 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754753AbdKKAjD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 19:39:03 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v7 04/25] rcar-vin: move max width and height information to chip information
Date: Sat, 11 Nov 2017 01:38:14 +0100
Message-Id: <20171111003835.4909-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Gen3 the max supported width and height will be different from Gen2.
Move the limits to the struct rvin_info to prepare for Gen3 support.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 6 ++++++
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 6 ++----
 drivers/media/platform/rcar-vin/rcar-vin.h  | 6 ++++++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index e90e5d014e074d64..cb761057459caa3f 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -244,14 +244,20 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 
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
index be00f4431493eb0a..76c0b8fa8602d08d 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -23,8 +23,6 @@
 #include "rcar-vin.h"
 
 #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
-#define RVIN_MAX_WIDTH		2048
-#define RVIN_MAX_HEIGHT		2048
 
 /* -----------------------------------------------------------------------------
  * Format Conversions
@@ -258,8 +256,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
 
 	/* Limit to VIN capabilities */
-	v4l_bound_align_image(&pix->width, 2, RVIN_MAX_WIDTH, walign,
-			      &pix->height, 4, RVIN_MAX_HEIGHT, 2, 0);
+	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
+			      &pix->height, 4, vin->info->max_height, 2, 0);
 
 	pix->bytesperline = max_t(u32, pix->bytesperline,
 				  rvin_format_bytesperline(pix));
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index ab240eb4aad9176c..e41dc3bff7fdc649 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -91,9 +91,15 @@ struct rvin_graph_entity {
 /**
  * struct rvin_info - Information about the particular VIN implementation
  * @chip:		type of VIN chip
+ *
+ * max_width:		max input width the VIN supports
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
2.15.0
