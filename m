Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:35393 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1CKGyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 01:54:54 -0500
Received: from epmmp2 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHV002I9SJE19D0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2011 15:54:50 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHV00IINSJED5@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2011 15:54:51 +0900 (KST)
Date: Fri, 11 Mar 2011 15:54:47 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 2/3] radio-si470x: convert to dev_pm_ops
In-reply-to: <1299826488-20506-1-git-send-email-jy0922.shim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Message-id: <1299826488-20506-2-git-send-email-jy0922.shim@samsung.com>
Content-transfer-encoding: 7BIT
References: <1299826488-20506-1-git-send-email-jy0922.shim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 81b0a1a..92ce10d 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -504,8 +504,9 @@ static __devexit int si470x_i2c_remove(struct i2c_client *client)
 /*
  * si470x_i2c_suspend - suspend the device
  */
-static int si470x_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
+static int si470x_i2c_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct si470x_device *radio = i2c_get_clientdata(client);
 
 	/* power down */
@@ -520,8 +521,9 @@ static int si470x_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
 /*
  * si470x_i2c_resume - resume the device
  */
-static int si470x_i2c_resume(struct i2c_client *client)
+static int si470x_i2c_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct si470x_device *radio = i2c_get_clientdata(client);
 
 	/* power up : need 110ms */
@@ -532,9 +534,8 @@ static int si470x_i2c_resume(struct i2c_client *client)
 
 	return 0;
 }
-#else
-#define si470x_i2c_suspend	NULL
-#define si470x_i2c_resume	NULL
+
+static SIMPLE_DEV_PM_OPS(si470x_i2c_pm, si470x_i2c_suspend, si470x_i2c_resume);
 #endif
 
 
@@ -545,11 +546,12 @@ static struct i2c_driver si470x_i2c_driver = {
 	.driver = {
 		.name		= "si470x",
 		.owner		= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm		= &si470x_i2c_pm,
+#endif
 	},
 	.probe			= si470x_i2c_probe,
 	.remove			= __devexit_p(si470x_i2c_remove),
-	.suspend		= si470x_i2c_suspend,
-	.resume			= si470x_i2c_resume,
 	.id_table		= si470x_i2c_id,
 };
 
-- 
1.7.0.4

