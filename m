Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34141 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbcCBRRE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 12:17:04 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	Rob Taylor <rob.taylor@codethink.co.uk>
Subject: [PATCH v2 5/9] media: rcar-vin: pad-aware driver initialisation
Date: Wed,  2 Mar 2016 18:16:33 +0100
Message-Id: <1456938997-29971-6-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1456938997-29971-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1456938997-29971-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add detection of source pad number for drivers aware of the media controller
API, so that rcar-vin can create device nodes to support modern drivers such
as adv7604.c (for HDMI on Lager) and the converted adv7180.c (for composite)
underneath.

Building rcar_vin gains a dependency on CONFIG_MEDIA_CONTROLLER, in
line with requirements for building the drivers associated with it.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
[uli: adapted to rcar-vin rewrite]
Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 16 ++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 15a67f7..3d957dc 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1008,6 +1008,9 @@ int rvin_dma_on(struct rvin_dev *vin)
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	int pad_idx;
+#endif
 	int ret;
 
 	sd = vin_to_sd(vin);
@@ -1040,6 +1043,19 @@ int rvin_dma_on(struct rvin_dev *vin)
 		return ret;
 	}
 
+	vin->src_pad_idx = 0;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
+		if (sd->entity.pads[pad_idx].flags
+				== MEDIA_PAD_FL_SOURCE)
+			break;
+	if (pad_idx >= sd->entity.num_pads)
+		goto remove_device;
+
+	vin->src_pad_idx = pad_idx;
+#endif
+	fmt.pad = vin->src_pad_idx;
+
 	vin->format.field = V4L2_FIELD_ANY;
 
 	/* Try to improve our guess of a reasonable window format */
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index f07cd7c..c6f6e44 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -121,6 +121,7 @@ struct rvin_dev {
 
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
+	int src_pad_idx;	/* For media-controller drivers */
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_async_notifier notifier;
 	struct rvin_graph_entity entity;
-- 
2.6.4

