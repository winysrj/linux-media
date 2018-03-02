Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49042 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428676AbeCBOrT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 09:47:19 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com,
        joe@perches.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 09/11] media: ov772x: Re-order variables declaration
Date: Fri,  2 Mar 2018 15:46:41 +0100
Message-Id: <1520002003-10200-10-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Re-order variables declaration to respect 'reverse christmas tree'
ordering whenever possible.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/ov772x.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 4f464ac..1fd6d4b 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1098,8 +1098,8 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *format)
 {
-	struct ov772x_priv *priv = to_ov772x(sd);
 	struct v4l2_mbus_framefmt *mf = &format->format;
+	struct ov772x_priv *priv = to_ov772x(sd);
 	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size *win;
 	int ret;
@@ -1135,10 +1135,11 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
 
 static int ov772x_video_probe(struct ov772x_priv *priv)
 {
-	struct i2c_client  *client = v4l2_get_subdevdata(&priv->subdev);
-	u8                  pid, ver;
-	const char         *devname;
-	int		    ret;
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
+	const char *devname;
+	int ret;
+	u8 pid;
+	u8 ver;
 
 	ret = ov772x_s_power(&priv->subdev, 1);
 	if (ret < 0)
@@ -1246,9 +1247,9 @@ static const struct v4l2_subdev_ops ov772x_subdev_ops = {
 static int ov772x_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
-	struct ov772x_priv	*priv;
-	struct i2c_adapter	*adapter = client->adapter;
-	int			ret;
+	struct i2c_adapter *adapter = client->adapter;
+	struct ov772x_priv *priv;
+	int ret;
 
 	if (!client->dev.platform_data) {
 		dev_err(&client->dev, "Missing ov772x platform data\n");
-- 
2.7.4
