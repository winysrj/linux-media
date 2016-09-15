Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39654 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933713AbcIOL33 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:29:29 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 84B3A600A3
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:29:25 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] smiapp: Set use suspend and resume ops for other functions
Date: Thu, 15 Sep 2016 14:29:19 +0300
Message-Id: <1473938961-16067-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the suspend and resume ops for freeze, thaw, poweroff and restore
callbacks as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index fe1f738..e1d1459 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -3090,8 +3090,7 @@ static const struct i2c_device_id smiapp_id_table[] = {
 MODULE_DEVICE_TABLE(i2c, smiapp_id_table);
 
 static const struct dev_pm_ops smiapp_pm_ops = {
-	.suspend	= smiapp_suspend,
-	.resume		= smiapp_resume,
+	SET_SYSTEM_SLEEP_PM_OPS(smiapp_suspend, smiapp_resume)
 };
 
 static struct i2c_driver smiapp_i2c_driver = {
-- 
2.1.4

