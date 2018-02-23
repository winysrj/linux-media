Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:52142 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbeBWJQN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 04:16:13 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        linux-kernel@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] media: imx274: fix typo in error message
Date: Fri, 23 Feb 2018 09:57:15 +0100
Message-Id: <1519376235-25101-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 664e8acdf2a0..daec33f4196a 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -1426,7 +1426,7 @@ static int imx274_set_vflip(struct stimx274 *priv, int val)
 
 	err = imx274_write_reg(priv, IMX274_VFLIP_REG, val);
 	if (err) {
-		dev_err(&priv->client->dev, "VFILP control error\n");
+		dev_err(&priv->client->dev, "VFLIP control error\n");
 		return err;
 	}
 
-- 
2.7.4
