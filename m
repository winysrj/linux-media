Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:56033 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbcGSOXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:23:11 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 07/16] [media] rcar-vin: add dependency on MEDIA_CONTROLLER
Date: Tue, 19 Jul 2016 16:20:58 +0200
Message-Id: <20160719142107.22358-8-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is done in preparation for Gen3 support where media controller
support will be mandatory for the driver.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/Kconfig     | 2 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 7 +------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index b2ff2d4..111d2a1 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_RCAR_VIN
 	tristate "R-Car Video Input (VIN) Driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA && MEDIA_CONTROLLER
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 3f80a0b..09df396 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -771,10 +771,7 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	struct video_device *vdev = &vin->vdev;
 	struct v4l2_subdev *sd = vin_to_source(vin);
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	int pad_idx;
-#endif
-	int ret;
+	int pad_idx, ret;
 
 	v4l2_set_subdev_hostdata(sd, vin);
 
@@ -821,7 +818,6 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 		V4L2_CAP_READWRITE;
 
 	vin->src_pad_idx = 0;
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
 		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SOURCE)
 			break;
@@ -829,7 +825,6 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 		return -EINVAL;
 
 	vin->src_pad_idx = pad_idx;
-#endif
 	fmt.pad = vin->src_pad_idx;
 
 	/* Try to improve our guess of a reasonable window format */
-- 
2.9.0

