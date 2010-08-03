Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51799 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab0HCK5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 06:57:54 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: [PATCH 06/11] mt9m111: cropcap and s_crop check if type is VIDEO_CAPTURE
Date: Tue,  3 Aug 2010 12:57:44 +0200
Message-Id: <1280833069-26993-7-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---

This one is a merge of:

[PATCH 09/20] mt9m111: cropcap check if type is CAPTURE
[PATCH 13/20] mt9m111: s_crop check for VIDEO_CAPTURE type


 drivers/media/video/mt9m111.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 944e0cb..89c3f89 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -453,6 +453,9 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	dev_dbg(&client->dev, "%s left=%d, top=%d, width=%d, height=%d\n",
 		__func__, rect.left, rect.top, rect.width, rect.height);
 
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
 	ret = mt9m111_make_rect(client, &rect);
 	if (!ret)
 		mt9m111->rect = rect;
@@ -472,12 +475,14 @@ static int mt9m111_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 
 static int mt9m111_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 {
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
 	a->bounds.left			= MT9M111_MIN_DARK_COLS;
 	a->bounds.top			= MT9M111_MIN_DARK_ROWS;
 	a->bounds.width			= MT9M111_MAX_WIDTH;
 	a->bounds.height		= MT9M111_MAX_HEIGHT;
 	a->defrect			= a->bounds;
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	a->pixelaspect.numerator	= 1;
 	a->pixelaspect.denominator	= 1;
 
-- 
1.7.1

