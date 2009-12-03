Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:33040 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbZLCM5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 07:57:22 -0500
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KU200C85UNSNO@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Dec 2009 21:57:28 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KU200KSSUNS31@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Dec 2009 21:57:28 +0900 (KST)
Date: Thu, 03 Dec 2009 21:57:29 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v2 3/3] radio-si470x: support PM functions
To: linux-media@vger.kernel.org
Cc: tobias.lorenz@gmx.net, kyungmin.park@samsung.com
Message-id: <4B17B5B9.6070409@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is to support PM of the si470x i2c driver.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c |   40 +++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 77532e6..4c6e586 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -486,6 +486,44 @@ static __devexit int si470x_i2c_remove(struct i2c_client *client)
 }
 
 
+#ifdef CONFIG_PM
+/*
+ * si470x_i2c_suspend - suspend the device
+ */
+static int si470x_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct si470x_device *radio = i2c_get_clientdata(client);
+
+	/* power down */
+	radio->registers[POWERCFG] |= POWERCFG_DISABLE;
+	if (si470x_set_register(radio, POWERCFG) < 0)
+		return -EIO;
+
+	return 0;
+}
+
+
+/*
+ * si470x_i2c_resume - resume the device
+ */
+static int si470x_i2c_resume(struct i2c_client *client)
+{
+	struct si470x_device *radio = i2c_get_clientdata(client);
+
+	/* power up : need 110ms */
+	radio->registers[POWERCFG] |= POWERCFG_ENABLE;
+	if (si470x_set_register(radio, POWERCFG) < 0)
+		return -EIO;
+	msleep(110);
+
+	return 0;
+}
+#else
+#define si470x_i2c_suspend	NULL
+#define si470x_i2c_resume	NULL
+#endif
+
+
 /*
  * si470x_i2c_driver - i2c driver interface
  */
@@ -496,6 +534,8 @@ static struct i2c_driver si470x_i2c_driver = {
 	},
 	.probe			= si470x_i2c_probe,
 	.remove			= __devexit_p(si470x_i2c_remove),
+	.suspend		= si470x_i2c_suspend,
+	.resume			= si470x_i2c_resume,
 	.id_table		= si470x_i2c_id,
 };
 
-- 
1.6.3.3
