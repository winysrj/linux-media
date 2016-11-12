Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33429 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965750AbcKLNNo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:44 -0500
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
Subject: [PATCHv2 11/32] media: rcar-vin: refactor pad lookup code
Date: Sat, 12 Nov 2016 14:11:55 +0100
Message-Id: <20161112131216.22635-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code to lookup which pad is source and sink can be broken out to a
helper function.

A bad check is also dropped in this refactoring. If the subdeivce don't
supply pad information the driver would not be able to use it if the
check is kept.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index fb6368c..50058fe 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -66,11 +66,21 @@ static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
 	return false;
 }
 
+static unsigned int rvin_pad_idx(struct v4l2_subdev *sd, int direction)
+{
+	unsigned int pad_idx;
+
+	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
+		if (sd->entity.pads[pad_idx].flags == direction)
+			return pad_idx;
+
+	return 0;
+}
+
 static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 	struct v4l2_subdev *sd = vin->digital.subdev;
-	unsigned int pad_idx;
 	int ret;
 
 	/* Verify subdevices mbus format */
@@ -84,21 +94,8 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 		vin->digital.subdev->name, vin->digital.code);
 
 	/* Figure out source and sink pad ids */
-	vin->digital.source_pad_idx = 0;
-	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
-		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SOURCE)
-			break;
-	if (pad_idx >= sd->entity.num_pads)
-		return -EINVAL;
-
-	vin->digital.source_pad_idx = pad_idx;
-
-	vin->digital.sink_pad_idx = 0;
-	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
-		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SINK) {
-			vin->digital.sink_pad_idx = pad_idx;
-			break;
-		}
+	vin->digital.source_pad_idx = rvin_pad_idx(sd, MEDIA_PAD_FL_SOURCE);
+	vin->digital.sink_pad_idx = rvin_pad_idx(sd, MEDIA_PAD_FL_SINK);
 
 	vin_dbg(vin, "Found media pads for %s source: %d sink %d\n",
 		vin->digital.subdev->name, vin->digital.source_pad_idx,
-- 
2.10.2

