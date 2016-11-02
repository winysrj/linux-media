Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49502 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754569AbcKBN3r (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 09:29:47 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 26/32] media: rcar-vin: add helpers for bridge
Date: Wed,  2 Nov 2016 14:23:23 +0100
Message-Id: <20161102132329.436-27-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Gen3 there might be a CSI2 bridge between the video source and the
VIN. Add helpers to check for this and to fetch the bridge subdevice.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 19 +++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h  |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f382f91..a409157 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -369,6 +369,11 @@ static int rvin_group_vin_to_csi(struct rvin_dev *vin)
 	return csi;
 }
 
+bool vin_have_bridge(struct rvin_dev *vin)
+{
+	return vin->digital.subdev == NULL;
+}
+
 struct rvin_graph_entity *vin_to_entity(struct rvin_dev *vin)
 {
 	int csi;
@@ -399,6 +404,20 @@ struct v4l2_subdev *vin_to_source(struct rvin_dev *vin)
 	return vin->group->source[csi].subdev;
 }
 
+struct v4l2_subdev *vin_to_bridge(struct rvin_dev *vin)
+{
+	int csi;
+
+	if (vin->digital.subdev)
+		return NULL;
+
+	csi = rvin_group_vin_to_csi(vin);
+	if (csi < 0)
+		return NULL;
+
+	return vin->group->bridge[csi].subdev;
+}
+
 /* -----------------------------------------------------------------------------
  * Async notifier helpers
  */
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 2f1e087..acaed2b 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -206,8 +206,10 @@ struct rvin_dev {
 	struct v4l2_rect compose;
 };
 
+bool vin_have_bridge(struct rvin_dev *vin);
 struct rvin_graph_entity *vin_to_entity(struct rvin_dev *vin);
 struct v4l2_subdev *vin_to_source(struct rvin_dev *vin);
+struct v4l2_subdev *vin_to_bridge(struct rvin_dev *vin);
 
 /* Debug */
 #define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
-- 
2.10.2

