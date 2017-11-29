Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:54502 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752701AbdK2ToM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:44:12 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v8 20/28] rcar-vin: prepare for media controller mode initialization
Date: Wed, 29 Nov 2017 20:43:34 +0100
Message-Id: <20171129194342.26239-21-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171129194342.26239-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171129194342.26239-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When running in media controller mode a media pad is needed, register
one. Also set the media bus format to CSI-2.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 24 ++++++++++++++++++++++--
 drivers/media/platform/rcar-vin/rcar-vin.h  |  4 ++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 61f48ecc1ab815ec..45de4079fd835759 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -46,6 +46,10 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
 	return -EINVAL;
 }
 
+/* -----------------------------------------------------------------------------
+ * Digital async notifier
+ */
+
 static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
@@ -226,6 +230,20 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 	return 0;
 }
 
+/* -----------------------------------------------------------------------------
+ * Group async notifier
+ */
+
+static int rvin_group_init(struct rvin_dev *vin)
+{
+	/* All our sources are CSI-2 */
+	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
+	vin->mbus_cfg.flags = 0;
+
+	vin->pad.flags = MEDIA_PAD_FL_SINK;
+	return media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
+}
+
 /* -----------------------------------------------------------------------------
  * Platform Device Driver
  */
@@ -314,8 +332,10 @@ static int rcar_vin_probe(struct platform_device *pdev)
 		return ret;
 
 	platform_set_drvdata(pdev, vin);
-
-	ret = rvin_digital_graph_init(vin);
+	if (vin->info->use_mc)
+		ret = rvin_group_init(vin);
+	else
+		ret = rvin_digital_graph_init(vin);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index fd3cd781be0ab1cf..07d270a976893cdb 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -103,6 +103,8 @@ struct rvin_info {
  * @notifier:		V4L2 asynchronous subdevs notifier
  * @digital:		entity in the DT for local digital subdevice
  *
+ * @pad:		pad for media controller
+ *
  * @lock:		protects @queue
  * @queue:		vb2 buffers queue
  *
@@ -132,6 +134,8 @@ struct rvin_dev {
 	struct v4l2_async_notifier notifier;
 	struct rvin_graph_entity *digital;
 
+	struct media_pad pad;
+
 	struct mutex lock;
 	struct vb2_queue queue;
 
-- 
2.15.0
