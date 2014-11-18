Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46495 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750788AbaKRFkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 00:40:42 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl
Subject: [REVIEW PATCH v2 4/5] smiapp: Set left and top to zero for crop bounds selection
Date: Tue, 18 Nov 2014 07:40:19 +0200
Message-Id: <1416289220-32673-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289220-32673-1-git-send-email-sakari.ailus@iki.fi>
References: <1416289220-32673-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fields were previously uninitialised, leaving the returned values to
where the user had set them. This was never the intention.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 193af1c..022ad44 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2191,6 +2191,7 @@ static int __smiapp_get_selection(struct v4l2_subdev *subdev,
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
 		if (ssd == sensor->pixel_array) {
+			sel->r.left = sel->r.top = 0;
 			sel->r.width =
 				sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
 			sel->r.height =
-- 
1.7.10.4

