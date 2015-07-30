Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55118 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbbG3QUS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 12:20:18 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 24/27] [media] smiapp: Export OF module alias information
Date: Thu, 30 Jul 2015 18:18:49 +0200
Message-Id: <1438273132-20926-25-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1438273132-20926-1-git-send-email-javier@osg.samsung.com>
References: <1438273132-20926-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The I2C core always reports the MODALIAS uevent as "i2c:<client name"
regardless if the driver was matched using the I2C id_table or the
of_match_table. So technically there's no need for a driver to export
the OF table since currently it's not used.

In fact, the I2C device ID table is mandatory for I2C drivers since
a i2c_device_id is passed to the driver's probe function even if the
I2C core used the OF table to match the driver.

And since the I2C core uses different tables, OF-only drivers needs to
have duplicated data that has to be kept in sync and also the dev node
compatible manufacturer prefix is stripped when reporting the MODALIAS.

To avoid the above, the I2C core behavior may be changed in the future
to not require an I2C device table for OF-only drivers and report the
OF module alias. So, it's better to also export the OF table to prevent
breaking module autoloading if that happens.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/i2c/smiapp/smiapp-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 636ebd6fe5dc..fb39dfd55e75 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -3131,6 +3131,7 @@ static const struct of_device_id smiapp_of_table[] = {
 	{ .compatible = "nokia,smia" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, smiapp_of_table);
 
 static const struct i2c_device_id smiapp_id_table[] = {
 	{ SMIAPP_NAME, 0 },
-- 
2.4.3

