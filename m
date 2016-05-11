Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35449 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbcEKOD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 10:03:27 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	Rob Taylor <rob.taylor@codethink.co.uk>
Subject: [PATCH v4 4/8] media: rcar-vin: pad-aware driver initialisation
Date: Wed, 11 May 2016 16:02:52 +0200
Message-Id: <1462975376-491-5-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
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
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 16 ++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h  |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 42dbd35..3788f8a 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -691,6 +691,9 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	struct video_device *vdev = &vin->vdev;
 	struct v4l2_subdev *sd = vin_to_source(vin);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	int pad_idx;
+#endif
 	int ret;
 
 	v4l2_set_subdev_hostdata(sd, vin);
@@ -737,6 +740,19 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
 
+	vin->src_pad_idx = 0;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
+		if (sd->entity.pads[pad_idx].flags
+				== MEDIA_PAD_FL_SOURCE)
+			break;
+	if (pad_idx >= sd->entity.num_pads)
+		return -EINVAL;
+
+	vin->src_pad_idx = pad_idx;
+#endif
+	fmt.pad = vin->src_pad_idx;
+
 	/* Try to improve our guess of a reasonable window format */
 	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 	if (ret) {
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 544a3b3..a6dd6db 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -87,6 +87,7 @@ struct rvin_graph_entity {
  *
  * @vdev:		V4L2 video device associated with VIN
  * @v4l2_dev:		V4L2 device
+ * @src_pad_idx:	source pad index for media controller drivers
  * @ctrl_handler:	V4L2 control handler
  * @notifier:		V4L2 asynchronous subdevs notifier
  * @entity:		entity in the DT for subdevice
@@ -117,6 +118,7 @@ struct rvin_dev {
 
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
+	int src_pad_idx;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_async_notifier notifier;
 	struct rvin_graph_entity entity;
-- 
2.7.4

