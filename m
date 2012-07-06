Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60067 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509Ab2GFOe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 10:34:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 06/10] ov772x: Make to_ov772x convert from v4l2_subdev to ov772x_priv
Date: Fri,  6 Jul 2012 16:34:57 +0200
Message-Id: <1341585301-1003-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Conversion from i2c_client to ov772x_priv is only needed in a single
location, while conversion from v4l2_subdev to ov772x_priv is needed in
several locations. Perform the former manually, and use to_ov772x for
the later.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index e3de4de..9055ba4 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -442,10 +442,9 @@ static const struct regval_list ov772x_vga_regs[] = {
  * general function
  */
 
-static struct ov772x_priv *to_ov772x(const struct i2c_client *client)
+static struct ov772x_priv *to_ov772x(struct v4l2_subdev *sd)
 {
-	return container_of(i2c_get_clientdata(client), struct ov772x_priv,
-			    subdev);
+	return container_of(sd, struct ov772x_priv, subdev);
 }
 
 static int ov772x_write_array(struct i2c_client        *client,
@@ -789,7 +788,7 @@ static const struct v4l2_ctrl_ops ov772x_ctrl_ops = {
 static int ov772x_g_chip_ident(struct v4l2_subdev *sd,
 			       struct v4l2_dbg_chip_ident *id)
 {
-	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
+	struct ov772x_priv *priv = to_ov772x(sd);
 
 	id->ident    = priv->model;
 	id->revision = 0;
@@ -845,7 +844,7 @@ static int ov772x_s_power(struct v4l2_subdev *sd, int on)
 static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
+	struct ov772x_priv *priv = to_ov772x(sd);
 
 	if (!enable) {
 		ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
@@ -863,7 +862,7 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 static int ov772x_g_fmt(struct v4l2_subdev *sd,
 			struct v4l2_mbus_framefmt *mf)
 {
-	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
+	struct ov772x_priv *priv = to_ov772x(sd);
 
 	mf->width	= priv->win->width;
 	mf->height	= priv->win->height;
@@ -876,7 +875,7 @@ static int ov772x_g_fmt(struct v4l2_subdev *sd,
 
 static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
-	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
+	struct ov772x_priv *priv = to_ov772x(sd);
 	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size *win;
 	int ret;
@@ -999,9 +998,9 @@ static struct v4l2_subdev_ops ov772x_subdev_ops = {
  * Initialization and cleanup
  */
 
-static int ov772x_video_probe(struct i2c_client *client)
+static int ov772x_video_probe(struct ov772x_priv *priv)
 {
-	struct ov772x_priv *priv = to_ov772x(client);
+	struct i2c_client  *client = v4l2_get_subdevdata(&priv->subdev);
 	u8                  pid, ver;
 	const char         *devname;
 	int		    ret;
@@ -1086,7 +1085,7 @@ static int ov772x_probe(struct i2c_client *client,
 		goto done;
 	}
 
-	ret = ov772x_video_probe(client);
+	ret = ov772x_video_probe(priv);
 	if (ret < 0)
 		goto done;
 
@@ -1103,7 +1102,7 @@ done:
 
 static int ov772x_remove(struct i2c_client *client)
 {
-	struct ov772x_priv *priv = to_ov772x(client);
+	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));
 
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
-- 
1.7.8.6

