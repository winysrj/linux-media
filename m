Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33587 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbcBPUR6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 15:17:58 -0500
Received: by mail-lf0-f41.google.com with SMTP id m1so115091676lfg.0
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2016 12:17:57 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] cx23885: incorrect I2C bus used in the CI registration
Date: Tue, 16 Feb 2016 22:17:44 +0200
Message-Id: <1455653865-13005-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes a bug that was introduced by the commit:

commit 2b0aac3011bc7a9db27791bed4978554263ef079
Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date:   Tue Dec 23 13:48:07 2014 -0200

    [media] cx23885: move CI/MAC registration to a separate function

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 5131c9f..6e40dec 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1139,7 +1139,7 @@ static int dvb_register_ci_mac(struct cx23885_tsport *port)
 		u8 eeprom[256]; /* 24C02 i2c eeprom */
 		struct sp2_config sp2_config;
 		struct i2c_board_info info;
-		struct cx23885_i2c *i2c_bus2 = &dev->i2c_bus[1];
+		struct cx23885_i2c *i2c_bus = &dev->i2c_bus[0];
 
 		/* attach CI */
 		memset(&sp2_config, 0, sizeof(sp2_config));
@@ -1151,7 +1151,7 @@ static int dvb_register_ci_mac(struct cx23885_tsport *port)
 		info.addr = 0x40;
 		info.platform_data = &sp2_config;
 		request_module(info.type);
-		client_ci = i2c_new_device(&i2c_bus2->i2c_adap, &info);
+		client_ci = i2c_new_device(&i2c_bus->i2c_adap, &info);
 		if (client_ci == NULL || client_ci->dev.driver == NULL)
 			return -ENODEV;
 		if (!try_module_get(client_ci->dev.driver->owner)) {
-- 
1.9.1

