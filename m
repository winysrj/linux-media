Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37887 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbeCJSfi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 13:35:38 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: soc_camera: mt9t112: Update to new interface
Date: Sat, 10 Mar 2018 19:35:31 +0100
Message-Id: <1520706931-25278-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use in the soc_camera version of mt9t112 driver the new name for the
driver's platform data as defined by the new v4l2 driver for the same chip.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---

Hans: to not break bisect, would you like me to resend the whole series
with this commit squashed in:
[PATCH 2/5] media: i2c: mt9t112: Remove soc_camera dependencies
that changes the driver interface, or can you do that when applying?

Thanks
   j

---
 drivers/media/i2c/soc_camera/mt9t112.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 297d22e..b53c36d 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -85,7 +85,7 @@ struct mt9t112_format {

 struct mt9t112_priv {
 	struct v4l2_subdev		 subdev;
-	struct mt9t112_camera_info	*info;
+	struct mt9t112_platform_data	*info;
 	struct i2c_client		*client;
 	struct v4l2_rect		 frame;
 	struct v4l2_clk			*clk;
--
2.7.4
