Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:22236 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbcKRRt3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 12:49:29 -0500
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: g.liakhovetski@gmx.de, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] [media] soc-camera: Fix a return value in case of error
Date: Fri, 18 Nov 2016 18:49:15 +0100
Message-Id: <20161118174915.8072-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If 'ov9640_reg_read()' does not return 0, then 'val' is left unmodified.
As it is not initialized either, the return value can be anything.

It is likely that returning the error code was expected here.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/media/i2c/soc_camera/ov9640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 8c93c57af71c..65085a235128 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -233,7 +233,7 @@ static int ov9640_reg_rmw(struct i2c_client *client, u8 reg, u8 set, u8 unset)
 	if (ret) {
 		dev_err(&client->dev,
 			"[Read]-Modify-Write of register %02x failed!\n", reg);
-		return val;
+		return ret;
 	}
 
 	val |= set;
-- 
2.9.3

