Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51758 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693Ab0G3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:54:19 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de, p.wiesner@phytec.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 12/20] mt9m111: s_crop add calculation of output size
Date: Fri, 30 Jul 2010 16:53:30 +0200
Message-Id: <1280501618-23634-13-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index cc0f996..2758a97 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -472,11 +472,19 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	struct mt9m111_format format;
 	struct v4l2_mbus_framefmt *mf = &format.mf;
+	s32 rectwidth	= mt9m111->format.rect.width;
+	s32 rectheight	= mt9m111->format.rect.height;
+	u32 pixwidth	= mt9m111->format.mf.width;
+	u32 pixheight	= mt9m111->format.mf.height;
 	int ret;
 
 	format.rect	= a->c;
 	format.mf	= mt9m111->format.mf;
 
+	/* calculate output size, maintain current scaling factors */
+	format.mf.width = pixwidth / rectwidth * format.mf.width;
+	format.mf.height = pixheight / rectheight * format.mf.height;
+
 	dev_dbg(&client->dev, "%s: rect: left=%d top=%d width=%d height=%d\n",
 		__func__, a->c.left, a->c.top, a->c.width, a->c.height);
 	dev_dbg(&client->dev, "%s: mf: width=%d height=%d pixelcode=%d "
-- 
1.7.1

