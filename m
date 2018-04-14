Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:63656 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751067AbeDNL7M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 07:59:12 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v14 04/33] rcar-vin: rename poorly named initialize and cleanup functions
Date: Sat, 14 Apr 2018 13:56:57 +0200
Message-Id: <20180414115726.5075-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The functions to register and unregister the hardware and video device
where poorly named from the start. Rename them to better describe their
intended function.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 10 +++++-----
 drivers/media/platform/rcar-vin/rcar-dma.c  |  6 +++---
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  4 ++--
 drivers/media/platform/rcar-vin/rcar-vin.h  |  8 ++++----
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f1fc7978d6d1523d..2bedf20abcf3ca07 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -93,7 +93,7 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
-	return rvin_v4l2_probe(vin);
+	return rvin_v4l2_register(vin);
 }
 
 static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
@@ -103,7 +103,7 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 
 	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
-	rvin_v4l2_remove(vin);
+	rvin_v4l2_unregister(vin);
 	vin->digital->subdev = NULL;
 }
 
@@ -245,7 +245,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	ret = rvin_dma_probe(vin, irq);
+	ret = rvin_dma_register(vin, irq);
 	if (ret)
 		return ret;
 
@@ -260,7 +260,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 
 	return 0;
 error:
-	rvin_dma_remove(vin);
+	rvin_dma_unregister(vin);
 	v4l2_async_notifier_cleanup(&vin->notifier);
 
 	return ret;
@@ -275,7 +275,7 @@ static int rcar_vin_remove(struct platform_device *pdev)
 	v4l2_async_notifier_unregister(&vin->notifier);
 	v4l2_async_notifier_cleanup(&vin->notifier);
 
-	rvin_dma_remove(vin);
+	rvin_dma_unregister(vin);
 
 	return 0;
 }
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 4a40e6ad1be7ed95..2aae3ca54eabac01 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1087,14 +1087,14 @@ static const struct vb2_ops rvin_qops = {
 	.wait_finish		= vb2_ops_wait_finish,
 };
 
-void rvin_dma_remove(struct rvin_dev *vin)
+void rvin_dma_unregister(struct rvin_dev *vin)
 {
 	mutex_destroy(&vin->lock);
 
 	v4l2_device_unregister(&vin->v4l2_dev);
 }
 
-int rvin_dma_probe(struct rvin_dev *vin, int irq)
+int rvin_dma_register(struct rvin_dev *vin, int irq)
 {
 	struct vb2_queue *q = &vin->queue;
 	int i, ret;
@@ -1142,7 +1142,7 @@ int rvin_dma_probe(struct rvin_dev *vin, int irq)
 
 	return 0;
 error:
-	rvin_dma_remove(vin);
+	rvin_dma_unregister(vin);
 
 	return ret;
 }
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index b479b882da12f62d..178aecc94962abe2 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -839,7 +839,7 @@ static const struct v4l2_file_operations rvin_fops = {
 	.read		= vb2_fop_read,
 };
 
-void rvin_v4l2_remove(struct rvin_dev *vin)
+void rvin_v4l2_unregister(struct rvin_dev *vin)
 {
 	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
 		  video_device_node_name(&vin->vdev));
@@ -866,7 +866,7 @@ static void rvin_notify(struct v4l2_subdev *sd,
 	}
 }
 
-int rvin_v4l2_probe(struct rvin_dev *vin)
+int rvin_v4l2_register(struct rvin_dev *vin)
 {
 	struct video_device *vdev = &vin->vdev;
 	struct v4l2_subdev *sd = vin_to_source(vin);
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 95897127cc410d4f..385243e3d4da130b 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -153,11 +153,11 @@ struct rvin_dev {
 #define vin_warn(d, fmt, arg...)	dev_warn(d->dev, fmt, ##arg)
 #define vin_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
 
-int rvin_dma_probe(struct rvin_dev *vin, int irq);
-void rvin_dma_remove(struct rvin_dev *vin);
+int rvin_dma_register(struct rvin_dev *vin, int irq);
+void rvin_dma_unregister(struct rvin_dev *vin);
 
-int rvin_v4l2_probe(struct rvin_dev *vin);
-void rvin_v4l2_remove(struct rvin_dev *vin);
+int rvin_v4l2_register(struct rvin_dev *vin);
+void rvin_v4l2_unregister(struct rvin_dev *vin);
 
 const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 
-- 
2.16.2
