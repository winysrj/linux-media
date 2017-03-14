Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37494 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751777AbdCNTGl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:41 -0400
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
Subject: [PATCH v3 17/27] rcar-vin: prepare digital notifier for group notifier
Date: Tue, 14 Mar 2017 20:02:58 +0100
Message-Id: <20170314190308.25790-18-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media bus parsing functions used by the digital subdevice V4L2
notifier can be shared with the upcoming CSI-2 notifier. To prepare for
this move and rename the function to reflect it's generic.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 70 +++++++++++++++--------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index ed99b1abb99e9ef9..adc38696a0ba70b9 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -45,6 +45,42 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
 	return -EINVAL;
 }
 
+static int rvin_parse_v4l2(struct rvin_dev *vin,
+			   struct device_node *ep,
+			   struct v4l2_mbus_config *mbus_cfg)
+{
+	struct v4l2_of_endpoint v4l2_ep;
+	int ret;
+
+	ret = v4l2_of_parse_endpoint(ep, &v4l2_ep);
+	if (ret) {
+		vin_err(vin, "Could not parse v4l2 endpoint\n");
+		return -EINVAL;
+	}
+
+	mbus_cfg->type = v4l2_ep.bus_type;
+
+	switch (mbus_cfg->type) {
+	case V4L2_MBUS_PARALLEL:
+		vin_dbg(vin, "Found PARALLEL media bus\n");
+		mbus_cfg->flags = v4l2_ep.bus.parallel.flags;
+		break;
+	case V4L2_MBUS_BT656:
+		vin_dbg(vin, "Found BT656 media bus\n");
+		mbus_cfg->flags = 0;
+		break;
+	default:
+		vin_err(vin, "Unknown media bus type\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * Digital async notifier
+ */
+
 static bool rvin_mbus_supported(struct rvin_dev *vin)
 {
 	struct v4l2_subdev *sd = vin->digital.subdev;
@@ -145,38 +181,6 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
 	return -EINVAL;
 }
 
-static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,
-				    struct device_node *ep,
-				    struct v4l2_mbus_config *mbus_cfg)
-{
-	struct v4l2_of_endpoint v4l2_ep;
-	int ret;
-
-	ret = v4l2_of_parse_endpoint(ep, &v4l2_ep);
-	if (ret) {
-		vin_err(vin, "Could not parse v4l2 endpoint\n");
-		return -EINVAL;
-	}
-
-	mbus_cfg->type = v4l2_ep.bus_type;
-
-	switch (mbus_cfg->type) {
-	case V4L2_MBUS_PARALLEL:
-		vin_dbg(vin, "Found PARALLEL media bus\n");
-		mbus_cfg->flags = v4l2_ep.bus.parallel.flags;
-		break;
-	case V4L2_MBUS_BT656:
-		vin_dbg(vin, "Found BT656 media bus\n");
-		mbus_cfg->flags = 0;
-		break;
-	default:
-		vin_err(vin, "Unknown media bus type\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int rvin_digital_graph_parse(struct rvin_dev *vin)
 {
 	struct device_node *ep, *np;
@@ -201,7 +205,7 @@ static int rvin_digital_graph_parse(struct rvin_dev *vin)
 	}
 	of_node_put(np);
 
-	ret = rvin_digitial_parse_v4l2(vin, ep, &vin->mbus_cfg);
+	ret = rvin_parse_v4l2(vin, ep, &vin->mbus_cfg);
 	of_node_put(ep);
 	if (ret)
 		return ret;
-- 
2.12.0
