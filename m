Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55067 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbbG3QTz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 12:19:55 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 11/27] [media] staging: media: lirc: Export I2C module alias information
Date: Thu, 30 Jul 2015 18:18:36 +0200
Message-Id: <1438273132-20926-12-git-send-email-javier@osg.samsung.com>
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

 drivers/staging/media/lirc/lirc_zilog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 261e27d6b054..bebfc3b093bc 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1364,6 +1364,7 @@ static const struct i2c_device_id ir_transceiver_id[] = {
 	{ "ir_rx_z8f0811_hdpvr", ID_FLAG_HDPVR              },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, ir_transceiver_id);
 
 static struct i2c_driver driver = {
 	.driver = {
-- 
2.4.3

