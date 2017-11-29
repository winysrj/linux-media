Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:54540 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752573AbdK2ToL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:44:11 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v8 17/28] rcar-vin: add flag to switch to media controller mode
Date: Wed, 29 Nov 2017 20:43:31 +0100
Message-Id: <20171129194342.26239-18-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171129194342.26239-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171129194342.26239-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Gen3 a media controller API needs to be used to allow userspace to
configure the subdevices in the pipeline instead of directly controlling
a single source subdevice, which is and will continue to be the mode of
operation on Gen2.

Prepare for these two modes of operation by adding a flag to struct
rvin_info which will control which mode to use.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 6 +++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 7d49904cab9cb2d9..61f48ecc1ab815ec 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -232,18 +232,21 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 
 static const struct rvin_info rcar_info_h1 = {
 	.chip = RCAR_H1,
+	.use_mc = false,
 	.max_width = 2048,
 	.max_height = 2048,
 };
 
 static const struct rvin_info rcar_info_m1 = {
 	.chip = RCAR_M1,
+	.use_mc = false,
 	.max_width = 2048,
 	.max_height = 2048,
 };
 
 static const struct rvin_info rcar_info_gen2 = {
 	.chip = RCAR_GEN2,
+	.use_mc = false,
 	.max_width = 2048,
 	.max_height = 2048,
 };
@@ -338,7 +341,8 @@ static int rcar_vin_remove(struct platform_device *pdev)
 	v4l2_async_notifier_unregister(&vin->notifier);
 	v4l2_async_notifier_cleanup(&vin->notifier);
 
-	v4l2_ctrl_handler_free(&vin->ctrl_handler);
+	if (!vin->info->use_mc)
+		v4l2_ctrl_handler_free(&vin->ctrl_handler);
 
 	rvin_dma_unregister(vin);
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 7819c760c2c13422..0747873c2b9cb74c 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -77,12 +77,14 @@ struct rvin_graph_entity {
 /**
  * struct rvin_info - Information about the particular VIN implementation
  * @chip:		type of VIN chip
+ * @use_mc:		use media controller instead of controlling subdevice
  *
  * max_width:		max input width the VIN supports
  * max_height:		max input height the VIN supports
  */
 struct rvin_info {
 	enum chip_id chip;
+	bool use_mc;
 
 	unsigned int max_width;
 	unsigned int max_height;
-- 
2.15.0
