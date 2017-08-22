Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:56064 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752835AbdHVX2r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 19:28:47 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v6 18/25] rcar-vin: prepare for media controller mode initialization
Date: Wed, 23 Aug 2017 01:26:33 +0200
Message-Id: <20170822232640.26147-19-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When running in media controller mode a media pad is needed, register
one. Also set the media bus format to CSI-2.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 23 ++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  4 ++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index fbbb22924cf3a045..dd0525f2ba336bc2 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -45,6 +45,10 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
 	return -EINVAL;
 }
 
+/* -----------------------------------------------------------------------------
+ * Digital async notifier
+ */
+
 static bool rvin_mbus_supported(struct rvin_dev *vin)
 {
 	struct v4l2_subdev *sd = vin->digital.subdev;
@@ -273,6 +277,20 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
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
@@ -365,7 +383,10 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = rvin_digital_graph_init(vin);
+	if (vin->info->use_mc)
+		ret = rvin_group_init(vin);
+	else
+		ret = rvin_digital_graph_init(vin);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 12daff804bb6f77f..9c47669669c0469c 100644
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
 	struct rvin_graph_entity digital;
 
+	struct media_pad pad;
+
 	struct mutex lock;
 	struct vb2_queue queue;
 
-- 
2.14.0
