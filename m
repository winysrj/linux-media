Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:34050 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754272AbdLNTJR (ORCPT
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
Subject: [PATCH/RFC v2 03/15] rcar-vin: use the pad and stream aware s_stream
Date: Thu, 14 Dec 2017 20:08:23 +0100
Message-Id: <20171214190835.7672-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To work with multiplexed streams the pad and stream aware s_stream
operation needs to be used.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index cf30e5fceb1d493a..8435491535060eae 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1180,7 +1180,7 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
 
 	if (!on) {
 		media_pipeline_stop(vin->vdev.entity.pads);
-		return v4l2_subdev_call(sd, video, s_stream, 0);
+		return v4l2_subdev_call(sd, pad, s_stream, pad->index, 0, 0);
 	}
 
 	fmt.pad = pad->index;
@@ -1239,12 +1239,14 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
 	if (media_pipeline_start(vin->vdev.entity.pads, pipe))
 		return -EPIPE;
 
-	ret = v4l2_subdev_call(sd, video, s_stream, 1);
+	ret = v4l2_subdev_call(sd, pad, s_stream, pad->index, 0, 1);
 	if (ret == -ENOIOCTLCMD)
 		ret = 0;
 	if (ret)
 		media_pipeline_stop(vin->vdev.entity.pads);
 
+	vin_dbg(vin, "pad: %u stream: 0 enable: %d\n", pad->index, on);
+
 	return ret;
 }
 
-- 
2.15.1
