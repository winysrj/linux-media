Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36494 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbbLUNyx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 08:54:53 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Benoit Parrot <bparrot@ti.com>
Subject: [PATCH] media: i2c: ov2659: speedup probe if no device connected
Date: Mon, 21 Dec 2015 15:54:46 +0200
Message-ID: <1450706086-6801-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov2659 driver performs device detection and initialization in the
following way:
 - send reset command REG_SOFTWARE_RESET
 - load array of predefined register's setting (~150 values)
 - read device version REG_SC_CHIP_ID_H/REG_SC_CHIP_ID_L
 - check version and exit if invalid.

As result, for not connected device there will be >~150 i2c transactions
executed before device version checking and exit (there are no
failures detected because ov2659 declared as I2C_CLIENT_SCCB and NACKs
are ignored in this case).

Let's fix that by checking the chip version first and start
initialization only if it's supported.

Cc: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/media/i2c/ov2659.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 49109f4..9b7b78c 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1321,10 +1321,6 @@ static int ov2659_detect(struct v4l2_subdev *sd)
 	}
 	usleep_range(1000, 2000);
 
-	ret = ov2659_init(sd, 0);
-	if (ret < 0)
-		return ret;
-
 	/* Check sensor revision */
 	ret = ov2659_read(client, REG_SC_CHIP_ID_H, &pid);
 	if (!ret)
@@ -1338,8 +1334,10 @@ static int ov2659_detect(struct v4l2_subdev *sd)
 			dev_err(&client->dev,
 				"Sensor detection failed (%04X, %d)\n",
 				id, ret);
-		else
+		else {
 			dev_info(&client->dev, "Found OV%04X sensor\n", id);
+			ret = ov2659_init(sd, 0);
+		}
 	}
 
 	return ret;
-- 
2.6.4

