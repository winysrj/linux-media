Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33544 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966005AbcKLNNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:52 -0500
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
Subject: [PATCHv2 20/32] media: rcar-vin: expose a sink pad if we are on Gen3
Date: Sat, 12 Nov 2016 14:12:04 +0100
Message-Id: <20161112131216.22635-21-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor the probe code path to look for the digital subdevice, if one
is found use it just like the driver did before (Gen2 mode) but if it's
not found prepare for a Gen3 mode by registering a pad for the media
controller API to use.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 21 ++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  9 +++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 26e438a..6554141 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -308,6 +308,25 @@ static const struct of_device_id rvin_of_id_table[] = {
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
 
+static int rvin_graph_init(struct rvin_dev *vin)
+{
+	int ret;
+
+	/* Try to get digital video pipe */
+	ret = rvin_digital_graph_init(vin);
+
+	/* No digital pipe and we are on Gen3 try to joint CSI2 group */
+	if (ret == -ENODEV && vin->info->chip == RCAR_GEN3) {
+
+		vin->pads[RVIN_SINK].flags = MEDIA_PAD_FL_SINK;
+		ret = media_entity_pads_init(&vin->vdev.entity, 1, vin->pads);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
 static int rcar_vin_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
@@ -343,7 +362,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = rvin_digital_graph_init(vin);
+	ret = rvin_graph_init(vin);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index a6a49a96..8ed43be 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -36,6 +36,11 @@ enum chip_id {
 	RCAR_GEN3,
 };
 
+enum rvin_pads {
+	RVIN_SINK,
+	RVIN_PAD_MAX,
+};
+
 /**
  * STOPPED  - No operation in progress
  * RUNNING  - Operation in progress have buffers
@@ -115,6 +120,8 @@ struct rvin_info {
  * @notifier:		V4L2 asynchronous subdevs notifier
  * @digital:		entity in the DT for local digital subdevice
  *
+ * @pads:		pads for media controller
+ *
  * @lock:		protects @queue
  * @queue:		vb2 buffers queue
  *
@@ -144,6 +151,8 @@ struct rvin_dev {
 	struct v4l2_async_notifier notifier;
 	struct rvin_graph_entity digital;
 
+	struct media_pad pads[RVIN_PAD_MAX];
+
 	struct mutex lock;
 	struct vb2_queue queue;
 
-- 
2.10.2

