Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51789 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab0HCK5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 06:57:54 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 07/11] mt9m111: added current colorspace at g_fmt
Date: Tue,  3 Aug 2010 12:57:45 +0200
Message-Id: <1280833069-26993-8-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 89c3f89..48c63bc 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -498,6 +498,7 @@ static int mt9m111_g_fmt(struct v4l2_subdev *sd,
 	mf->width	= mt9m111->rect.width;
 	mf->height	= mt9m111->rect.height;
 	mf->code	= mt9m111->fmt->code;
+	mf->colorspace	= mt9m111->fmt->colorspace;
 	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
-- 
1.7.1

