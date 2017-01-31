Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:44251 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbdAaPt5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 10:49:57 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 08/11] media: rcar-vin: refactor pad lookup code
Date: Tue, 31 Jan 2017 16:40:13 +0100
Message-Id: <20170131154016.15526-9-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the subdeivce did not supply pad information the driver will return
-EINVAL, this is not what we want so remove that check. The code can
then be broken out to a helper function reducing duplication.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 2c40b6a1a93f108c..e9373d9ab97fb827 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -65,11 +65,21 @@ static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
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
@@ -83,21 +93,8 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
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
2.11.0

