Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:32467 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752478AbeCZVqx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:46:53 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v13 21/33] rcar-vin: add flag to switch to media controller mode
Date: Mon, 26 Mar 2018 23:44:44 +0200
Message-Id: <20180326214456.6655-22-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
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
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 6 +++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 07a04d4bcc91b18b..c0e0412e2ecd9487 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -249,18 +249,21 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 
 static const struct rvin_info rcar_info_h1 = {
 	.model = RCAR_H1,
+	.use_mc = false,
 	.max_width = 2048,
 	.max_height = 2048,
 };
 
 static const struct rvin_info rcar_info_m1 = {
 	.model = RCAR_M1,
+	.use_mc = false,
 	.max_width = 2048,
 	.max_height = 2048,
 };
 
 static const struct rvin_info rcar_info_gen2 = {
 	.model = RCAR_GEN2,
+	.use_mc = false,
 	.max_width = 2048,
 	.max_height = 2048,
 };
@@ -355,7 +358,8 @@ static int rcar_vin_remove(struct platform_device *pdev)
 	v4l2_async_notifier_unregister(&vin->notifier);
 	v4l2_async_notifier_cleanup(&vin->notifier);
 
-	v4l2_ctrl_handler_free(&vin->ctrl_handler);
+	if (!vin->info->use_mc)
+		v4l2_ctrl_handler_free(&vin->ctrl_handler);
 
 	rvin_dma_unregister(vin);
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index c19ddc5e08cbbea4..e5668c1120a67899 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -75,11 +75,13 @@ struct rvin_graph_entity {
 /**
  * struct rvin_info - Information about the particular VIN implementation
  * @model:		VIN model
+ * @use_mc:		use media controller instead of controlling subdevice
  * @max_width:		max input width the VIN supports
  * @max_height:		max input height the VIN supports
  */
 struct rvin_info {
 	enum model_id model;
+	bool use_mc;
 
 	unsigned int max_width;
 	unsigned int max_height;
-- 
2.16.2
