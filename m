Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39815 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753582AbeB0Pk7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:40:59 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 08/13] media: tw9910: Replace msleep(1) with usleep_range
Date: Tue, 27 Feb 2018 16:40:25 +0100
Message-Id: <1519746030-15407-9-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

msleep() can sleep up to 20ms.

As suggested by Documentation/timers/timers_howto.txt replace it with
usleep_range() with up to 5ms delay.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/tw9910.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index 1043f7d..920877a 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -401,7 +401,7 @@ static int tw9910_set_hsync(struct i2c_client *client)
 static void tw9910_reset(struct i2c_client *client)
 {
 	tw9910_mask_set(client, ACNTL1, SRESET, SRESET);
-	msleep(1);
+	usleep_range(1000, 5000);
 }
 
 static int tw9910_power(struct i2c_client *client, int enable)
-- 
2.7.4
