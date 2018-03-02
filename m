Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56035 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428676AbeCBOrQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 09:47:16 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com,
        joe@perches.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 08/11] media: ov772x: Empty line before end-of-function return
Date: Fri,  2 Mar 2018 15:46:40 +0100
Message-Id: <1520002003-10200-9-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an empty line before return at the end of functions.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/ov772x.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 8849da1..4f464ac 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1129,6 +1129,7 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
 
 	priv->win = win;
 	priv->cfmt = cfmt;
+
 	return 0;
 }
 
@@ -1172,6 +1173,7 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
 
 done:
 	ov772x_s_power(&priv->subdev, 0);
+
 	return ret;
 }
 
@@ -1213,6 +1215,7 @@ static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	code->code = ov772x_cfmts[code->index].code;
+
 	return 0;
 }
 
@@ -1327,6 +1330,7 @@ static int ov772x_remove(struct i2c_client *client)
 		gpiod_put(priv->pwdn_gpio);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
+
 	return 0;
 }
 
-- 
2.7.4
