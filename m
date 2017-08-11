Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39202 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752939AbdHKJ5Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:25 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 06/20] rcar-vin: use the pad and stream aware s_stream
Date: Fri, 11 Aug 2017 11:56:49 +0200
Message-Id: <20170811095703.6170-7-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
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
index 67a82ac6dc88c0da..395cbf96b40aeb8d 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1235,16 +1235,18 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
 		if (media_pipeline_start(&vin->vdev.entity, pipe))
 			return -EPIPE;
 
-		ret = v4l2_subdev_call(sd, video, s_stream, 1);
+		ret = v4l2_subdev_call(sd, pad, s_stream, pad->index, 0, 1);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
 		if (ret)
 			media_pipeline_stop(&vin->vdev.entity);
 	} else {
 		media_pipeline_stop(&vin->vdev.entity);
-		ret = v4l2_subdev_call(sd, video, s_stream, 0);
+		ret = v4l2_subdev_call(sd, pad, s_stream, pad->index, 0, 0);
 	}
 
+	vin_dbg(vin, "pad: %u stream: 0 enable: %d\n", pad->index, on);
+
 	return ret;
 }
 
-- 
2.13.3
