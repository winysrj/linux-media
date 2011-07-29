Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62898 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 8F86118B040
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007nh-BD
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 15/59] V4L: ov772x: rename macros to not pollute the global namespace
Date: Fri, 29 Jul 2011 12:56:15 +0200
Message-Id: <1311937019-29914-16-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Macros, defined in a header under include/ should be kept in a local
namespace and not pollute the global one.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov772x.c |    8 ++++----
 include/media/ov772x.h       |   25 ++++++++++++-------------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 397870f..458265b 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -822,13 +822,13 @@ static int ov772x_set_params(struct i2c_client *client, u32 *width, u32 *height,
 			goto ov772x_set_fmt_error;
 
 		ret = ov772x_mask_set(client,
-				      EDGE_TRSHLD, EDGE_THRESHOLD_MASK,
+				      EDGE_TRSHLD, OV772X_EDGE_THRESHOLD_MASK,
 				      priv->info->edgectrl.threshold);
 		if (ret < 0)
 			goto ov772x_set_fmt_error;
 
 		ret = ov772x_mask_set(client,
-				      EDGE_STRNGT, EDGE_STRENGTH_MASK,
+				      EDGE_STRNGT, OV772X_EDGE_STRENGTH_MASK,
 				      priv->info->edgectrl.strength);
 		if (ret < 0)
 			goto ov772x_set_fmt_error;
@@ -840,13 +840,13 @@ static int ov772x_set_params(struct i2c_client *client, u32 *width, u32 *height,
 		 * set upper and lower limit
 		 */
 		ret = ov772x_mask_set(client,
-				      EDGE_UPPER, EDGE_UPPER_MASK,
+				      EDGE_UPPER, OV772X_EDGE_UPPER_MASK,
 				      priv->info->edgectrl.upper);
 		if (ret < 0)
 			goto ov772x_set_fmt_error;
 
 		ret = ov772x_mask_set(client,
-				      EDGE_LOWER, EDGE_LOWER_MASK,
+				      EDGE_LOWER, OV772X_EDGE_LOWER_MASK,
 				      priv->info->edgectrl.lower);
 		if (ret < 0)
 			goto ov772x_set_fmt_error;
diff --git a/include/media/ov772x.h b/include/media/ov772x.h
index 548bf11..f9e27c0 100644
--- a/include/media/ov772x.h
+++ b/include/media/ov772x.h
@@ -12,8 +12,6 @@
 #ifndef __OV772X_H__
 #define __OV772X_H__
 
-#include <media/soc_camera.h>
-
 /* for flags */
 #define OV772X_FLAG_VFLIP	(1 << 0) /* Vertical flip image */
 #define OV772X_FLAG_HFLIP	(1 << 1) /* Horizontal flip image */
@@ -32,22 +30,23 @@ struct ov772x_edge_ctrl {
 	unsigned char lower;
 };
 
-#define OV772X_MANUAL_EDGE_CTRL	0x80 /* un-used bit of strength */
-#define EDGE_STRENGTH_MASK	0x1F
-#define EDGE_THRESHOLD_MASK	0x0F
-#define EDGE_UPPER_MASK		0xFF
-#define EDGE_LOWER_MASK		0xFF
+#define OV772X_MANUAL_EDGE_CTRL		0x80 /* un-used bit of strength */
+#define OV772X_EDGE_STRENGTH_MASK	0x1F
+#define OV772X_EDGE_THRESHOLD_MASK	0x0F
+#define OV772X_EDGE_UPPER_MASK		0xFF
+#define OV772X_EDGE_LOWER_MASK		0xFF
 
 #define OV772X_AUTO_EDGECTRL(u, l)	\
 {					\
-	.upper = (u & EDGE_UPPER_MASK),	\
-	.lower = (l & EDGE_LOWER_MASK),	\
+	.upper = (u & OV772X_EDGE_UPPER_MASK),	\
+	.lower = (l & OV772X_EDGE_LOWER_MASK),	\
 }
 
-#define OV772X_MANUAL_EDGECTRL(s, t)					\
-{									\
-	.strength  = (s & EDGE_STRENGTH_MASK) | OV772X_MANUAL_EDGE_CTRL,\
-	.threshold = (t & EDGE_THRESHOLD_MASK),				\
+#define OV772X_MANUAL_EDGECTRL(s, t)			\
+{							\
+	.strength  = (s & OV772X_EDGE_STRENGTH_MASK) |	\
+			OV772X_MANUAL_EDGE_CTRL,	\
+	.threshold = (t & OV772X_EDGE_THRESHOLD_MASK),	\
 }
 
 /*
-- 
1.7.2.5

