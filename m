Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55045 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbbG3QTp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 12:19:45 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 04/27] [media] Export I2C module alias information in missing drivers
Date: Thu, 30 Jul 2015 18:18:29 +0200
Message-Id: <1438273132-20926-5-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1438273132-20926-1-git-send-email-javier@osg.samsung.com>
References: <1438273132-20926-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The I2C core always reports the MODALIAS uevent as "i2c:<client name"
regardless if the driver was matched using the I2C id_table or the
of_match_table. So the driver needs to export the I2C table and this
be built into the module or udev won't have the necessary information
to auto load the correct module when the device is added.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/i2c/ir-kbd-i2c.c | 1 +
 drivers/media/i2c/s5k6a3.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 175a76114953..728d2cc8a3e7 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -478,6 +478,7 @@ static const struct i2c_device_id ir_kbd_id[] = {
 	{ "ir_rx_z8f0811_hdpvr", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, ir_kbd_id);
 
 static struct i2c_driver ir_kbd_driver = {
 	.driver = {
diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index bc389d5e42ae..b1b1574dfb95 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -363,6 +363,7 @@ static int s5k6a3_remove(struct i2c_client *client)
 static const struct i2c_device_id s5k6a3_ids[] = {
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, s5k6a3_ids);
 
 #ifdef CONFIG_OF
 static const struct of_device_id s5k6a3_of_match[] = {
-- 
2.4.3

