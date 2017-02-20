Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36343
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751403AbdBTUQ2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 15:16:28 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org
Subject: [PATCH] [media] et8ek8: Export OF device ID as module aliases
Date: Mon, 20 Feb 2017 17:16:16 -0300
Message-Id: <20170220201616.15028-1-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The I2C core always reports a MODALIAS of the form i2c:<foo> even if the
device was registered via OF, this means that exporting the OF device ID
table device aliases in the module is not needed. But in order to change
how the core reports modaliases to user-space, it's better to export it.

Before this patch:

$ modinfo drivers/media/i2c/et8ek8/et8ek8.ko | grep alias
alias:          i2c:et8ek8

After this patch:

$ modinfo drivers/media/i2c/et8ek8/et8ek8.ko | grep alias
alias:          i2c:et8ek8
alias:          of:N*T*Ctoshiba,et8ek8C*
alias:          of:N*T*Ctoshiba,et8ek8

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/i2c/et8ek8/et8ek8_driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
index bec4a563a09c..f39f5179dd95 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -1485,6 +1485,7 @@ static const struct of_device_id et8ek8_of_table[] = {
 	{ .compatible = "toshiba,et8ek8" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, et8ek8_of_table);
 
 static const struct i2c_device_id et8ek8_id_table[] = {
 	{ ET8EK8_NAME, 0 },
-- 
2.9.3
