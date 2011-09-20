Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65286 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1ITNet (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 09:34:49 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRT00035PPZLX@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Sep 2011 14:34:47 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRT00EJYPPZNX@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Sep 2011 14:34:47 +0100 (BST)
Date: Tue, 20 Sep 2011 15:34:43 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] m5mols: Remove superfluous irq field from the platform data
 struct
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1316525683-7648-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to put the IRQ number in driver's private platform
data structure as this can also be passed through struct i2c_lient.irq.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_core.c |    6 +++---
 include/media/m5mols.h                   |    4 +---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index fb8e4a7..5d21d05 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -936,7 +936,7 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	if (!pdata->irq) {
+	if (!client->irq) {
 		dev_err(&client->dev, "Interrupt not assigned\n");
 		return -EINVAL;
 	}
@@ -973,7 +973,7 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 
 	init_waitqueue_head(&info->irq_waitq);
 	INIT_WORK(&info->work_irq, m5mols_irq_work);
-	ret = request_irq(pdata->irq, m5mols_irq_handler,
+	ret = request_irq(client->irq, m5mols_irq_handler,
 			  IRQF_TRIGGER_RISING, MODULE_NAME, sd);
 	if (ret) {
 		dev_err(&client->dev, "Interrupt request failed: %d\n", ret);
@@ -998,7 +998,7 @@ static int __devexit m5mols_remove(struct i2c_client *client)
 	struct m5mols_info *info = to_m5mols(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	free_irq(info->pdata->irq, sd);
+	free_irq(client->irq, sd);
 
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
 	gpio_free(info->pdata->gpio_reset);
diff --git a/include/media/m5mols.h b/include/media/m5mols.h
index aac2c0e..4a825ae 100644
--- a/include/media/m5mols.h
+++ b/include/media/m5mols.h
@@ -18,15 +18,13 @@
 
 /**
  * struct m5mols_platform_data - platform data for M-5MOLS driver
- * @irq:	GPIO getting the irq pin of M-5MOLS
  * @gpio_reset:	GPIO driving the reset pin of M-5MOLS
- * @reset_polarity: active state for gpio_rst pin, 0 or 1
+ * @reset_polarity: active state for gpio_reset pin, 0 or 1
  * @set_power:	an additional callback to the board setup code
  *		to be called after enabling and before disabling
  *		the sensor's supply regulators
  */
 struct m5mols_platform_data {
-	int irq;
 	int gpio_reset;
 	u8 reset_polarity;
 	int (*set_power)(struct device *dev, int on);
-- 
1.7.6.3

