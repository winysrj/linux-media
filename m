Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40595 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428700AbeCBOrV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 09:47:21 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com,
        joe@perches.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 10/11] media: ov772x: Replace msleep(1) with usleep_range
Date: Fri,  2 Mar 2018 15:46:42 +0100
Message-Id: <1520002003-10200-11-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
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
