Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59149 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2GRN61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 09:58:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 4/9] ov772x: try_fmt must not default to the current format
Date: Wed, 18 Jul 2012 15:58:21 +0200
Message-Id: <1342619906-5820-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342619906-5820-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342619906-5820-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the requested format isn't supported, return a fixed default format
instead of the current format.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |   36 +++++++-----------------------------
 1 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index c2bd087..be3dfb5 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -919,38 +919,16 @@ static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 static int ov772x_try_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_mbus_framefmt *mf)
 {
-	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
+	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size *win;
-	int i;
-
-	/*
-	 * select suitable win
-	 */
-	win = ov772x_select_win(mf->width, mf->height);
 
-	mf->width	= win->width;
-	mf->height	= win->height;
-	mf->field	= V4L2_FIELD_NONE;
-
-	for (i = 0; i < ARRAY_SIZE(ov772x_cfmts); i++)
-		if (mf->code == ov772x_cfmts[i].code)
-			break;
+	ov772x_select_params(mf, &cfmt, &win);
 
-	if (i == ARRAY_SIZE(ov772x_cfmts)) {
-		/* Unsupported format requested. Propose either */
-		if (priv->cfmt) {
-			/* the current one or */
-			mf->colorspace = priv->cfmt->colorspace;
-			mf->code = priv->cfmt->code;
-		} else {
-			/* the default one */
-			mf->colorspace = ov772x_cfmts[0].colorspace;
-			mf->code = ov772x_cfmts[0].code;
-		}
-	} else {
-		/* Also return the colorspace */
-		mf->colorspace	= ov772x_cfmts[i].colorspace;
-	}
+	mf->code = cfmt->code;
+	mf->width = win->width;
+	mf->height = win->height;
+	mf->field = V4L2_FIELD_NONE;
+	mf->colorspace = cfmt->colorspace;
 
 	return 0;
 }
-- 
1.7.8.6

