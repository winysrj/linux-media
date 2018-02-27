Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53322 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753163AbeB0Pky (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:40:54 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 06/13] media: tw9910: Mixed style fixes
Date: Tue, 27 Feb 2018 16:40:23 +0100
Message-Id: <1519746030-15407-7-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two minor style fixes, align function parameter and remove un-necessary
spaces.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/tw9910.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index f082f6d..f9b75c1 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -445,7 +445,7 @@ static const struct tw9910_scale_ctrl *tw9910_select_norm(v4l2_std_id norm,
 
 	for (i = 0; i < size; i++) {
 		tmp = abs(width - scale[i].width) +
-			abs(height - scale[i].height);
+			  abs(height - scale[i].height);
 		if (tmp < diff) {
 			diff = tmp;
 			ret = scale + i;
@@ -953,7 +953,7 @@ static int tw9910_probe(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;
 
-	priv->info   = info;
+	priv->info = info;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
 
-- 
2.7.4
