Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40274 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1JUHfo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Oct 2011 03:35:44 -0400
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LTE00IQUNRJCHP0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Oct 2011 16:35:43 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTPA id <0LTE002GVNRJR4A0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Oct 2011 16:35:43 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: "HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 3/5] m5mols: Support for interrupt in the sensor's booting time
Date: Fri, 21 Oct 2011 16:35:52 +0900
Message-id: <1319182554-10645-3-git-send-email-riverful.kim@samsung.com>
In-reply-to: <1319182554-10645-1-git-send-email-riverful.kim@samsung.com>
References: <1319182554-10645-1-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The M-5MOLS suports 2 booting ways. 1) waiting specific delay(over 520ms),
or 2) waiting with interrupt. The way of interrupt type supports optimum delay
for booting by waiting interrupt. Also, in case of using this way, it doesn't
need the extra delay in the m5mols_sensor_power() for stabilization.

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_core.c |   16 ++++++++++------
 drivers/media/video/m5mols/m5mols_reg.h  |    3 ++-
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index f3b9415..24e66ad 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -738,7 +738,6 @@ static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 		}
 
 		gpio_set_value(pdata->gpio_reset, !pdata->reset_polarity);
-		usleep_range(1000, 1000);
 		info->power = true;
 
 		return ret;
@@ -755,7 +754,6 @@ static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 		info->set_power(&client->dev, 0);
 
 	gpio_set_value(pdata->gpio_reset, pdata->reset_polarity);
-	usleep_range(1000, 1000);
 	info->power = false;
 
 	return ret;
@@ -773,18 +771,24 @@ int __attribute__ ((weak)) m5mols_update_fw(struct v4l2_subdev *sd,
  *
  * Booting internal ARM core makes the M-5MOLS is ready for getting commands
  * with I2C. It's the first thing to be done after it powered up. It must wait
- * at least 520ms recommended by M-5MOLS datasheet, after executing arm booting.
+ * at least 520ms recommended by M-5MOLS datasheet. Otherwise we also can check
+ * the register CATF_CAM_START is still in FLASH_MODE or not, after sensor's
+ * I2C transfer status is stabled and we write REG_START_ARM_BOOT command
+ * on the CAT_FLASH category.
  */
 static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
 {
 	int ret;
 
-	ret = m5mols_write(sd, FLASH_CAM_START, REG_START_ARM_BOOT);
+	/* Execute ARM boot sequence */
+	ret = m5mols_busy(sd, REG_IN_FLASH_MODE, CAT_FLASH, CATF_CAM_START);
+	if (!ret)
+		ret = m5mols_write(sd, FLASH_CAM_START, REG_START_ARM_BOOT);
+	if (!ret)
+		ret = m5mols_timeout_interrupt(sd, REG_INT_MODE, 2000);
 	if (ret < 0)
 		return ret;
 
-	msleep(520);
-
 	ret = m5mols_get_version(sd);
 	if (!ret)
 		ret = m5mols_update_fw(sd, m5mols_sensor_power);
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
index c755bd6..533aa27 100644
--- a/drivers/media/video/m5mols/m5mols_reg.h
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -405,6 +405,7 @@
 					 * after power-up */
 
 #define FLASH_CAM_START		I2C_REG(CAT_FLASH, CATF_CAM_START, 1)
-#define REG_START_ARM_BOOT	0x01
+#define REG_START_ARM_BOOT	0x01	/* value in case of writing */
+#define REG_IN_FLASH_MODE	0x00	/* value in case of reading */
 
 #endif	/* M5MOLS_REG_H */
-- 
1.7.4.1

