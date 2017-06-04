Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:47805 "EHLO
        emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751169AbdFDS16 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Jun 2017 14:27:58 -0400
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v1] [media] as3645a: Join string literals back
Date: Sun,  4 Jun 2017 21:29:18 +0300
Message-Id: <20170604182918.31476-1-andy.shevchenko@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to split long string literals.
Join them back.

No functional change intended.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/media/i2c/as3645a.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
index b6aeceea9850..af5db71a0888 100644
--- a/drivers/media/i2c/as3645a.c
+++ b/drivers/media/i2c/as3645a.c
@@ -294,8 +294,8 @@ static int as3645a_read_fault(struct as3645a *flash)
 		dev_dbg(&client->dev, "Inductor Peak limit fault\n");
 
 	if (rval & AS_FAULT_INFO_INDICATOR_LED)
-		dev_dbg(&client->dev, "Indicator LED fault: "
-			"Short circuit or open loop\n");
+		dev_dbg(&client->dev,
+			"Indicator LED fault: Short circuit or open loop\n");
 
 	dev_dbg(&client->dev, "%u connected LEDs\n",
 		rval & AS_FAULT_INFO_LED_AMOUNT ? 2 : 1);
@@ -310,8 +310,8 @@ static int as3645a_read_fault(struct as3645a *flash)
 		dev_dbg(&client->dev, "Short circuit fault\n");
 
 	if (rval & AS_FAULT_INFO_OVER_VOLTAGE)
-		dev_dbg(&client->dev, "Over voltage fault: "
-			"Indicates missing capacitor or open connection\n");
+		dev_dbg(&client->dev,
+			"Over voltage fault: Indicates missing capacitor or open connection\n");
 
 	return rval;
 }
@@ -583,8 +583,8 @@ static int as3645a_registered(struct v4l2_subdev *sd)
 
 	/* Verify the chip model and version. */
 	if (model != 0x01 || rfu != 0x00) {
-		dev_err(&client->dev, "AS3645A not detected "
-			"(model %d rfu %d)\n", model, rfu);
+		dev_err(&client->dev,
+			"AS3645A not detected (model %d rfu %d)\n", model, rfu);
 		rval = -ENODEV;
 		goto power_off;
 	}
-- 
2.13.0
