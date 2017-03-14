Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37404 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdCNTGg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:36 -0400
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
Subject: [PATCH v3 06/27] rcar-vin: move max width and height information to chip information
Date: Tue, 14 Mar 2017 20:02:47 +0100
Message-Id: <20170314190308.25790-7-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
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
index ec1eb723d401fda2..998617711f1ad045 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -257,14 +257,20 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 
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
index 7deca15d22b4d6e3..1b364f359ff4b5ed 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -23,8 +23,6 @@
 #include "rcar-vin.h"
 
 #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
-#define RVIN_MAX_WIDTH		2048
-#define RVIN_MAX_HEIGHT		2048
 
 /* -----------------------------------------------------------------------------
  * Format Conversions
@@ -264,8 +262,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
 
 	/* Limit to VIN capabilities */
-	v4l_bound_align_image(&pix->width, 2, RVIN_MAX_WIDTH, walign,
-			      &pix->height, 4, RVIN_MAX_HEIGHT, 2, 0);
+	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
+			      &pix->height, 4, vin->info->max_height, 2, 0);
 
 	pix->bytesperline = max_t(u32, pix->bytesperline,
 				  rvin_format_bytesperline(pix));
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index c07b4a6893440a6a..32d9d130dd6e2e44 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -91,9 +91,15 @@ struct rvin_graph_entity {
 /**
  * struct rvin_info- Information about the particular VIN implementation
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
2.12.0
