Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36803 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161621AbcBQPtP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 10:49:15 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	Rob Taylor <rob.taylor@codethink.co.uk>
Subject: [PATCH/RFC 5/9] media: rcar-vin: pad-aware driver initialisation
Date: Wed, 17 Feb 2016 16:48:41 +0100
Message-Id: <1455724125-13004-6-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1455724125-13004-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1455724125-13004-1-git-send-email-ulrich.hecht+renesas@gmail.com>
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
 drivers/media/platform/rcar-vin/rcar-dma.c | 15 +++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 70dc928..6b23c968 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -891,6 +891,9 @@ int rvin_dma_on(struct rvin_dev *vin)
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	int pad_idx;
+#endif
 	int ret;
 
 	sd = vin_to_sd(vin);
@@ -924,6 +927,18 @@ int rvin_dma_on(struct rvin_dev *vin)
 
 	/* TODO: ret = rvin_sensor_setup(vin, pix, ...); */
 
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
+
 	vin->format.field = V4L2_FIELD_ANY;
 
 	video_set_drvdata(&vin->vdev, vin);
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 99141d7..f127f5d 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -106,6 +106,7 @@ struct rvin_dev {
 	enum chip_id chip;
 
 	struct v4l2_device v4l2_dev;
+	int src_pad_idx;	/* For media-controller drivers */
 	struct v4l2_ctrl_handler ctrl_handler;
 
 	struct video_device vdev;
-- 
2.6.4

