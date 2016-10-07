Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:60385 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936228AbcJGQBX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:23 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 20/22] [media] video-multiplexer: set entity function to mux
Date: Fri,  7 Oct 2016 18:01:05 +0200
Message-Id: <20161007160107.5074-21-p.zabel@pengutronix.de>
In-Reply-To: <20161007160107.5074-1-p.zabel@pengutronix.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/video-multiplexer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/video-multiplexer.c b/drivers/media/platform/video-multiplexer.c
index e9137ba..bcd1688 100644
--- a/drivers/media/platform/video-multiplexer.c
+++ b/drivers/media/platform/video-multiplexer.c
@@ -138,6 +138,7 @@ static int vidsw_async_init(struct vidsw *vidsw, struct device_node *node)
 		vidsw->pads[i].flags = MEDIA_PAD_FL_SINK;
 	vidsw->pads[numports - 1].flags = MEDIA_PAD_FL_SOURCE;
 
+	vidsw->subdev.entity.function = MEDIA_ENT_F_MUX;
 	ret = media_entity_pads_init(&vidsw->subdev.entity, numports,
 				     vidsw->pads);
 	if (ret < 0)
-- 
2.9.3

