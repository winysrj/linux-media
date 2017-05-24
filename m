Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:46751 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937861AbdEXARD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:17:03 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 14/17] rcar-vin: remove subdevice matching from bind and unbind callbacks
Date: Wed, 24 May 2017 02:15:37 +0200
Message-Id: <20170524001540.13613-15-niklas.soderlund@ragnatech.se>
In-Reply-To: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
References: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

There is only one subdevice registered with the async framework so there
is no need for the driver to check which subdevice is bound or unbound.
Remove these checks since the async framework preforms this.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 40 +++++++++++------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index e67e4a57baadc3fb..dcca906ba58435f5 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -101,14 +101,9 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 
-	if (vin->digital.subdev == subdev) {
-		vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
-		rvin_v4l2_remove(vin);
-		vin->digital.subdev = NULL;
-		return;
-	}
-
-	vin_err(vin, "no entity for subdev %s to unbind\n", subdev->name);
+	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
+	rvin_v4l2_remove(vin);
+	vin->digital.subdev = NULL;
 }
 
 static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
@@ -120,28 +115,23 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
 
 	v4l2_set_subdev_hostdata(subdev, vin);
 
-	if (vin->digital.asd.match.fwnode.fwnode ==
-	    of_fwnode_handle(subdev->dev->of_node)) {
-		/* Find surce and sink pad of remote subdevice */
+	/* Find surce and sink pad of remote subdevice */
 
-		ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
-		if (ret < 0)
-			return ret;
-		vin->digital.source_pad = ret;
+	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
+	if (ret < 0)
+		return ret;
+	vin->digital.source_pad = ret;
 
-		ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
-		vin->digital.sink_pad = ret < 0 ? 0 : ret;
+	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
+	vin->digital.sink_pad = ret < 0 ? 0 : ret;
 
-		vin->digital.subdev = subdev;
+	vin->digital.subdev = subdev;
 
-		vin_dbg(vin, "bound subdev %s source pad: %u sink pad: %u\n",
-			subdev->name, vin->digital.source_pad,
-			vin->digital.sink_pad);
-		return 0;
-	}
+	vin_dbg(vin, "bound subdev %s source pad: %u sink pad: %u\n",
+		subdev->name, vin->digital.source_pad,
+		vin->digital.sink_pad);
 
-	vin_err(vin, "no entity for subdev %s to bind\n", subdev->name);
-	return -EINVAL;
+	return 0;
 }
 
 static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,
-- 
2.13.0
