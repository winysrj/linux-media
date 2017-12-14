Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:34026 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753870AbdLNTJR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:09:17 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH/RFC v2 02/15] rcar-vin: use pad as the starting point for a pipeline
Date: Thu, 14 Dec 2017 20:08:22 +0100
Message-Id: <20171214190835.7672-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pipeline will be moved from the entity to the pads; reflect this in
the media pipeline function API.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 03a914361a33125c..cf30e5fceb1d493a 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1179,7 +1179,7 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
 		return -EPIPE;
 
 	if (!on) {
-		media_pipeline_stop(&vin->vdev.entity);
+		media_pipeline_stop(vin->vdev.entity.pads);
 		return v4l2_subdev_call(sd, video, s_stream, 0);
 	}
 
@@ -1235,15 +1235,15 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
 	    fmt.format.height != vin->format.height)
 		return -EPIPE;
 
-	pipe = sd->entity.pipe ? sd->entity.pipe : &vin->vdev.pipe;
-	if (media_pipeline_start(&vin->vdev.entity, pipe))
+	pipe = sd->entity.pads->pipe ? sd->entity.pads->pipe : &vin->vdev.pipe;
+	if (media_pipeline_start(vin->vdev.entity.pads, pipe))
 		return -EPIPE;
 
 	ret = v4l2_subdev_call(sd, video, s_stream, 1);
 	if (ret == -ENOIOCTLCMD)
 		ret = 0;
 	if (ret)
-		media_pipeline_stop(&vin->vdev.entity);
+		media_pipeline_stop(vin->vdev.entity.pads);
 
 	return ret;
 }
-- 
2.15.1
