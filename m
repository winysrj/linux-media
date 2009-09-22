Return-path: <linux-media-owner@vger.kernel.org>
Received: from av7-2-sn3.vrr.skanova.net ([81.228.9.182]:49959 "EHLO
	av7-2-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbZIVJ1z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 05:27:55 -0400
Message-ID: <4AB893D6.5090009@mocean-labs.com>
Date: Tue, 22 Sep 2009 11:07:34 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?=
	<richard.rojfors@mocean-labs.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: [PATCH 4/4] adv7180: Use __devinit and __devexit macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch defines the probe and remove function as __devinit and __devexit.

Signed-off-by: Richard Röjfors <richard.rojfors@mocean-labs.com>
---
diff --git a/drivers/media/video/adv7180.c b/drivers/media/video/adv7180.c
index d9e897d..0826f0d 100644
--- a/drivers/media/video/adv7180.c
+++ b/drivers/media/video/adv7180.c
@@ -302,7 +302,7 @@ static irqreturn_t adv7180_irq(int irq, void *devid)
  * concerning the addresses: i2c wants 7 bit (without the r/w bit), so '>>1'
  */

-static int adv7180_probe(struct i2c_client *client,
+static __devinit int adv7180_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct adv7180_state *state;
@@ -404,7 +404,7 @@ err:
 	return ret;
 }

-static int adv7180_remove(struct i2c_client *client)
+static __devexit int adv7180_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct adv7180_state *state = to_state(sd);
@@ -440,7 +440,7 @@ static struct i2c_driver adv7180_driver = {
 		.name	= DRIVER_NAME,
 	},
 	.probe		= adv7180_probe,
-	.remove		= adv7180_remove,
+	.remove		= __devexit_p(adv7180_remove),
 	.id_table	= adv7180_id,
 };

