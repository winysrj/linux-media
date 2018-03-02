Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48028 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426315AbeCBOrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 09:47:08 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com,
        joe@perches.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 05/11] media: tw9910: Replace msleep(1) with usleep_range
Date: Fri,  2 Mar 2018 15:46:37 +0100
Message-Id: <1520002003-10200-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
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
index 9c12bda..6f2f1d7 100644
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
