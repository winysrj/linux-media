Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54624 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbcA0ODv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 09:03:51 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: David Engel <david@istwok.net>, stable@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org
Subject: [PATCH] [media] media: i2c: Don't export ir-kbd-i2c module alias
Date: Wed, 27 Jan 2016 11:03:23 -0300
Message-Id: <1453903403-1213-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a partial revert of commit ed8d1cf07cb16d ("[media] Export I2C
module alias information in missing drivers") that exported the module
aliases for the I2C drivers that were missing to make autoload to work.

But there is a bug report [0] that auto load of the ir-kbd-i2c driver
cause the Hauppauge HD-PVR driver to not behave correctly.

This is a hdpvr latent bug that was just exposed by ir-kbd-i2c module
autoloading working and will also happen if the I2C driver is built-in
or a user calls modprobe to load the module and register the driver.

But there is a regression experimented by users so until the real bug
is fixed, let's not export the module alias for the ir-kbd-i2c driver
even when this just masks the actual issue.

[0]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=810726

Fixes: ed8d1cf07cb1 ("[media] Export I2C module alias information in missing drivers")
Cc: <stable@vger.kernel.org> # 4.3+
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/i2c/ir-kbd-i2c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 830491960add..bf82726fd3f4 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -478,7 +478,6 @@ static const struct i2c_device_id ir_kbd_id[] = {
 	{ "ir_rx_z8f0811_hdpvr", 0 },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, ir_kbd_id);
 
 static struct i2c_driver ir_kbd_driver = {
 	.driver = {
-- 
2.5.0

