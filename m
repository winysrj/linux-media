Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49472 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754465AbcKBN3m (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 09:29:42 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 17/32] media: rcar-vin: clarify error message from the digital notifier
Date: Wed,  2 Nov 2016 14:23:14 +0100
Message-Id: <20161102132329.436-18-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some of the parser functions previously only used by the digital
subdevice OF/V4L2 async code will be shared with the CSI2 group
notifiers. Clarify which notifier register error message and mark which
functions are generic helpers.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index e3dea60..f961957 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -35,7 +35,7 @@ struct rvin_graph_entity *vin_to_entity(struct rvin_dev *vin)
 }
 
 /* -----------------------------------------------------------------------------
- * Async notifier
+ * Async notifier helpers
  */
 
 #define notifier_to_vin(n) container_of(n, struct rvin_dev, notifier)
@@ -77,6 +77,10 @@ static unsigned int rvin_pad_idx(struct v4l2_subdev *sd, int direction)
 	return 0;
 }
 
+/* -----------------------------------------------------------------------------
+ * Digital async notifier
+ */
+
 static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
@@ -242,7 +246,7 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
 	if (ret < 0) {
-		vin_err(vin, "Notifier registration failed\n");
+		vin_err(vin, "Digital notifier registration failed\n");
 		return ret;
 	}
 
-- 
2.10.2

