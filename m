Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:24760 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1164158AbeCBB7U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:59:20 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 23/32] rcar-vin: prepare for media controller mode initialization
Date: Fri,  2 Mar 2018 02:57:42 +0100
Message-Id: <20180302015751.25596-24-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare for media controller by calling a different initialization then
when running in device centric mode. Add trivial configuration of
the mbus and creation of the media pad for the video device entity.

While we are at it clearly mark the digital device centric notifier
functions with a comment.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 20 ++++++++++++++++++--
 drivers/media/platform/rcar-vin/rcar-vin.h  |  4 ++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index ca22903c375d2018..eb67ad5e2633064b 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -46,6 +46,10 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
 	return -EINVAL;
 }
 
+/* -----------------------------------------------------------------------------
+ * Digital async notifier
+ */
+
 /* The vin lock shuld be held when calling the subdevice attach and detach */
 static int rvin_digital_subdevice_attach(struct rvin_dev *vin,
 					 struct v4l2_subdev *subdev)
@@ -237,6 +241,16 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 	return 0;
 }
 
+static int rvin_mc_init(struct rvin_dev *vin)
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
@@ -325,8 +339,10 @@ static int rcar_vin_probe(struct platform_device *pdev)
 		return ret;
 
 	platform_set_drvdata(pdev, vin);
-
-	ret = rvin_digital_graph_init(vin);
+	if (vin->info->use_mc)
+		ret = rvin_mc_init(vin);
+	else
+		ret = rvin_digital_graph_init(vin);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 7bae9270c6216c3e..849f428871af113f 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -101,6 +101,8 @@ struct rvin_info {
  * @notifier:		V4L2 asynchronous subdevs notifier
  * @digital:		entity in the DT for local digital subdevice
  *
+ * @pad:		media pad for the video device entity
+ *
  * @lock:		protects @queue
  * @queue:		vb2 buffers queue
  *
@@ -130,6 +132,8 @@ struct rvin_dev {
 	struct v4l2_async_notifier notifier;
 	struct rvin_graph_entity *digital;
 
+	struct media_pad pad;
+
 	struct mutex lock;
 	struct vb2_queue queue;
 
-- 
2.16.2
