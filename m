Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40423 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161346AbbKFNOJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2015 08:14:09 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH 2/3] [media] mt9v032: Do not unset master_mode
Date: Fri,  6 Nov 2015 14:13:44 +0100
Message-Id: <1446815625-18413-2-git-send-email-mpa@pengutronix.de>
In-Reply-To: <1446815625-18413-1-git-send-email-mpa@pengutronix.de>
References: <1446815625-18413-1-git-send-email-mpa@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The power_on function of the driver resets the chip and sets the
CHIP_CONTROL register to 0. This switches the operating mode to slave.
The s_stream function sets the correct mode. But this caused problems on
a board where the camera chip is operated as master. The camera started
after a random amount of time streaming an image, I observed between 10
and 300 seconds.

The STRFM_OUT and STLN_OUT pins are not connected on this board which
may cause some issues in slave mode. I could not find any documentation
about this.

Keeping the chip in master mode after the reset helped to fix this
issue for me.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/media/i2c/mt9v032.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 4aefde9634f5..943c3f39ea73 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -344,7 +344,8 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
 	if (ret < 0)
 		return ret;
 
-	return regmap_write(map, MT9V032_CHIP_CONTROL, 0);
+	return regmap_write(map, MT9V032_CHIP_CONTROL,
+			    MT9V032_CHIP_CONTROL_MASTER_MODE);
 }
 
 static void mt9v032_power_off(struct mt9v032 *mt9v032)
-- 
2.6.1

