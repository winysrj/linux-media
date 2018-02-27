Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44853 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753692AbeB0PlK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:41:10 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 13/13] media: ov772x: Replace msleep(1) with usleep_range
Date: Tue, 27 Feb 2018 16:40:30 +0100
Message-Id: <1519746030-15407-14-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

msleep() can sleep up to 20ms.

As suggested by Documentation/timers/timers_howto.txt replace it with
usleep_range() with up to 5ms delay.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/ov772x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 1fd6d4b..2d5281a 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -574,7 +574,7 @@ static int ov772x_reset(struct i2c_client *client)
 	if (ret < 0)
 		return ret;
 
-	msleep(1);
+	usleep_range(1000, 5000);
 
 	return ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
 }
-- 
2.7.4
