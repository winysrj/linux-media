Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60068 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab2GFOe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 10:34:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 03/10] ov772x: Select the default format at probe time
Date: Fri,  6 Jul 2012 16:34:54 +0200
Message-Id: <1341585301-1003-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The format and window size are only initialized during the first g_fmt
call. This leaves the device in an inconsistent state after
initialization, which will cause problems when implementing pad
operations. Move the format and window size initialization to probe
time.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |   63 ++++++++++++++++++++---------------------
 1 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 066bac6..576780a 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -547,37 +547,36 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 #define MAX_WIDTH   VGA_WIDTH
 #define MAX_HEIGHT  VGA_HEIGHT
 
-static const struct ov772x_win_size ov772x_win_vga = {
-	.name     = "VGA",
-	.width    = VGA_WIDTH,
-	.height   = VGA_HEIGHT,
-	.com7_bit = SLCT_VGA,
-	.regs     = ov772x_vga_regs,
-};
-
-static const struct ov772x_win_size ov772x_win_qvga = {
-	.name     = "QVGA",
-	.width    = QVGA_WIDTH,
-	.height   = QVGA_HEIGHT,
-	.com7_bit = SLCT_QVGA,
-	.regs     = ov772x_qvga_regs,
+static const struct ov772x_win_size ov772x_win_sizes[] = {
+	{
+		.name     = "VGA",
+		.width    = VGA_WIDTH,
+		.height   = VGA_HEIGHT,
+		.com7_bit = SLCT_VGA,
+		.regs     = ov772x_vga_regs,
+	}, {
+		.name     = "QVGA",
+		.width    = QVGA_WIDTH,
+		.height   = QVGA_HEIGHT,
+		.com7_bit = SLCT_QVGA,
+		.regs     = ov772x_qvga_regs,
+	},
 };
 
 static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
 {
-	__u32 diff;
-	const struct ov772x_win_size *win;
-
-	/* default is QVGA */
-	diff = abs(width - ov772x_win_qvga.width) +
-		abs(height - ov772x_win_qvga.height);
-	win = &ov772x_win_qvga;
-
-	/* VGA */
-	if (diff >
-	    abs(width  - ov772x_win_vga.width) +
-	    abs(height - ov772x_win_vga.height))
-		win = &ov772x_win_vga;
+	const struct ov772x_win_size *win = &ov772x_win_sizes[0];
+	unsigned int i;
+	u32 best_diff = (u32)-1;
+
+	for (i = 0; i < ARRAY_SIZE(ov772x_win_sizes); ++i) {
+		u32 diff = abs(width - ov772x_win_sizes[i].width)
+			 + abs(height - ov772x_win_sizes[i].height);
+		if (diff < best_diff) {
+			best_diff = diff;
+			win = &ov772x_win_sizes[i];
+		}
+	}
 
 	return win;
 }
@@ -874,11 +873,6 @@ static int ov772x_g_fmt(struct v4l2_subdev *sd,
 {
 	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
 
-	if (!priv->win || !priv->cfmt) {
-		priv->cfmt = &ov772x_cfmts[0];
-		priv->win = ov772x_select_win(VGA_WIDTH, VGA_HEIGHT);
-	}
-
 	mf->width	= priv->win->width;
 	mf->height	= priv->win->height;
 	mf->code	= priv->cfmt->code;
@@ -1112,6 +1106,11 @@ static int ov772x_probe(struct i2c_client *client,
 	}
 
 	ret = ov772x_video_probe(client);
+	if (ret < 0)
+		goto done;
+
+	priv->cfmt = &ov772x_cfmts[0];
+	priv->win = &ov772x_win_sizes[0];
 
 done:
 	if (ret) {
-- 
1.7.8.6

