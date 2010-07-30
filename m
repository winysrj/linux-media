Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51750 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758661Ab0G3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 10:54:19 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de, p.wiesner@phytec.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 08/20] mt9m111: cropcap use defined default rect properties in defrect
Date: Fri, 30 Jul 2010 16:53:26 +0200
Message-Id: <1280501618-23634-9-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index f024cc5..3b19274 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -480,7 +480,10 @@ static int mt9m111_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	a->bounds.top			= MT9M111_MIN_DARK_ROWS;
 	a->bounds.width			= MT9M111_MAX_WIDTH;
 	a->bounds.height		= MT9M111_MAX_HEIGHT;
-	a->defrect			= a->bounds;
+	a->defrect.left			= MT9M111_DEF_DARK_COLS;
+	a->defrect.top			= MT9M111_DEF_DARK_ROWS;
+	a->defrect.width		= MT9M111_DEF_WIDTH;
+	a->defrect.height		= MT9M111_DEF_HEIGHT;
 	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	a->pixelaspect.numerator	= 1;
 	a->pixelaspect.denominator	= 1;
-- 
1.7.1

