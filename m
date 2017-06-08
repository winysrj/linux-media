Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:60616 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdFHJCZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 05:02:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "[media] et8ek8: Export OF device ID as module aliases"
Date: Thu,  8 Jun 2017 11:01:37 +0200
Message-Id: <20170608090156.2373326-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This one got applied twice, causing a build error with clang:

drivers/media/i2c/et8ek8/et8ek8_driver.c:1499:1: error: redefinition of '__mod_of__et8ek8_of_table_device_table'

Fixes: 9ae05fd1e791 ("[media] et8ek8: Export OF device ID as module aliases")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/et8ek8/et8ek8_driver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
index 6e313d5243a0..f39f5179dd95 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -1496,7 +1496,6 @@ MODULE_DEVICE_TABLE(i2c, et8ek8_id_table);
 static const struct dev_pm_ops et8ek8_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(et8ek8_suspend, et8ek8_resume)
 };
-MODULE_DEVICE_TABLE(of, et8ek8_of_table);
 
 static struct i2c_driver et8ek8_i2c_driver = {
 	.driver		= {
-- 
2.9.0
