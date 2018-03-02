Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45198 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428676AbeCBOrL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 09:47:11 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com,
        joe@perches.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 06/11] media: ov772x: Align function parameters
Date: Fri,  2 Mar 2018 15:46:38 +0100
Message-Id: <1520002003-10200-7-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Align all function parameters to first open brace when declaring
functions.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/ov772x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 16665af..a418455 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1064,7 +1064,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 
 static int ov772x_get_selection(struct v4l2_subdev *sd,
 				struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_selection *sel)
+				struct v4l2_subdev_selection *sel)
 {
 	struct ov772x_priv *priv = to_ov772x(sd);
 
@@ -1087,7 +1087,7 @@ static int ov772x_get_selection(struct v4l2_subdev *sd,
 
 static int ov772x_get_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
+			  struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct ov772x_priv *priv = to_ov772x(sd);
@@ -1106,7 +1106,7 @@ static int ov772x_get_fmt(struct v4l2_subdev *sd,
 
 static int ov772x_set_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
+			  struct v4l2_subdev_format *format)
 {
 	struct ov772x_priv *priv = to_ov772x(sd);
 	struct v4l2_mbus_framefmt *mf = &format->format;
@@ -1219,7 +1219,7 @@ static int ov772x_enum_frame_interval(struct v4l2_subdev *sd,
 
 static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
 				 struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_mbus_code_enum *code)
+				 struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->pad || code->index >= ARRAY_SIZE(ov772x_cfmts))
 		return -EINVAL;
-- 
2.7.4
