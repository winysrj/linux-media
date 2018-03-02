Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48635 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428700AbeCBOrY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 09:47:24 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com,
        joe@perches.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 11/11] media: ov772x: Unregister async subdevice
Date: Fri,  2 Mar 2018 15:46:43 +0100
Message-Id: <1520002003-10200-12-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the media subdevice is registered with 'v4l2_async_register_subdev()'
unregister it at module removal time with
'v4l2_async_unregister_subdev()'

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/ov772x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 2d5281a..3d1ea58 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1329,7 +1329,7 @@ static int ov772x_remove(struct i2c_client *client)
 	clk_put(priv->clk);
 	if (priv->pwdn_gpio)
 		gpiod_put(priv->pwdn_gpio);
-	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 
 	return 0;
-- 
2.7.4
