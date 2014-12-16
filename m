Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1bon0134.outbound.protection.outlook.com ([157.56.111.134]:14710
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbaLPREY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 12:04:24 -0500
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <mchehab@osg.samsung.com>
CC: <hans.verkuil@cisco.com>, <linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] [media] adv7180: Simplify PM hooks
Date: Tue, 16 Dec 2014 14:49:06 -0200
Message-ID: <1418748547-12308-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The macro SIMPLE_DEV_PM_OPS already takes care of the CONFIG_PM_SLEEP=n case, so
move it out of the CONFIG_PM_SLEEP 'if' block and remove the unneeded 
ADV7180_PM_OPS definition to make the code simpler.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/i2c/adv7180.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index bffe6eb..0c1268a 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -700,13 +700,8 @@ static int adv7180_resume(struct device *dev)
 		return ret;
 	return 0;
 }
-
-static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
-#define ADV7180_PM_OPS (&adv7180_pm_ops)
-
-#else
-#define ADV7180_PM_OPS NULL
 #endif
+static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
 
 MODULE_DEVICE_TABLE(i2c, adv7180_id);
 
@@ -714,7 +709,7 @@ static struct i2c_driver adv7180_driver = {
 	.driver = {
 		   .owner = THIS_MODULE,
 		   .name = KBUILD_MODNAME,
-		   .pm = ADV7180_PM_OPS,
+		   .pm = &adv7180_pm_ops,
 		   },
 	.probe = adv7180_probe,
 	.remove = adv7180_remove,
-- 
1.9.1

