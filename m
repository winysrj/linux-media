Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.171]:60952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0LYVsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 16:48:08 -0500
Date: Sat, 25 Dec 2010 22:48:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: [PATCH] v4l: ov772x: simplify pointer dereference
Message-ID: <Pine.LNX.4.64.1012252246270.5248@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Use a more direct way to obtain a pointer to struct ov772x_priv, where the
subdevice is available.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Just a minor simplification, planned for 2.6.38

 drivers/media/video/ov772x.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index a84b770..7e366fe 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -600,7 +600,7 @@ static int ov772x_reset(struct i2c_client *client)
 static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov772x_priv *priv = to_ov772x(client);
+	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
 
 	if (!enable) {
 		ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
@@ -646,7 +646,7 @@ static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
 static int ov772x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov772x_priv *priv = to_ov772x(client);
+	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
@@ -665,7 +665,7 @@ static int ov772x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 static int ov772x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov772x_priv *priv = to_ov772x(client);
+	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
 	int ret = 0;
 	u8 val;
 
@@ -716,7 +716,7 @@ static int ov772x_g_chip_ident(struct v4l2_subdev *sd,
 			       struct v4l2_dbg_chip_ident *id)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov772x_priv *priv = to_ov772x(client);
+	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
 
 	id->ident    = priv->model;
 	id->revision = 0;
@@ -955,7 +955,7 @@ static int ov772x_g_fmt(struct v4l2_subdev *sd,
 			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov772x_priv *priv = to_ov772x(client);
+	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
 
 	if (!priv->win || !priv->cfmt) {
 		u32 width = VGA_WIDTH, height = VGA_HEIGHT;
@@ -978,7 +978,7 @@ static int ov772x_s_fmt(struct v4l2_subdev *sd,
 			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov772x_priv *priv = to_ov772x(client);
+	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
 	int ret = ov772x_set_params(client, &mf->width, &mf->height,
 				    mf->code);
 
@@ -992,7 +992,7 @@ static int ov772x_try_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov772x_priv *priv = to_ov772x(client);
+	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
 	const struct ov772x_win_size *win;
 	int i;
 
-- 
1.7.2.3

