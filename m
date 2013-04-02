Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:12965 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761797Ab3DBNlS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 09:41:18 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKM00AZIRCLJ6U0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Apr 2013 22:41:16 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, Andrzej Hajda <a.hajda@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] m5mols: Improved power on routine
Date: Tue, 02 Apr 2013 15:40:56 +0200
Message-id: <1364910056-25636-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrzej Hajda <a.hajda@samsung.com>

The regulator bulk API doesn't guarantee an order in which regulators
are enabled or disabled. Make sure the regulators are enabled
sequentially, as specified in the sensor's datasheet.
Additionally a 1ms delay is added after the reset GPIO (de)assertion.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/i2c/m5mols/m5mols_core.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 0b899cb..a364781 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -740,6 +740,24 @@ static const struct v4l2_subdev_video_ops m5mols_video_ops = {
 	.s_stream	= m5mols_s_stream,
 };
 
+static int regulator_bulk_enable_sync(int num_consumers,
+				      struct regulator_bulk_data *consumers)
+{
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(supplies); ++i) {
+		ret = regulator_enable(supplies[i].consumer);
+		if (ret < 0) {
+			for (; i >= 0; --i)
+				regulator_disable(supplies[i].consumer);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 {
 	struct v4l2_subdev *sd = &info->sd;
@@ -757,13 +775,15 @@ static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 				return ret;
 		}
 
-		ret = regulator_bulk_enable(ARRAY_SIZE(supplies), supplies);
+		ret = regulator_bulk_enable_sync(ARRAY_SIZE(supplies),
+						  supplies);
 		if (ret) {
 			info->set_power(&client->dev, 0);
 			return ret;
 		}
 
 		gpio_set_value(pdata->gpio_reset, !pdata->reset_polarity);
+		usleep_range(1000, 1000);
 		info->power = 1;
 
 		return ret;
@@ -777,6 +797,7 @@ static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 		info->set_power(&client->dev, 0);
 
 	gpio_set_value(pdata->gpio_reset, pdata->reset_polarity);
+	usleep_range(1000, 1000);
 
 	info->isp_ready = 0;
 	info->power = 0;
-- 
1.7.9.5

