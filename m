Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35287 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbcBPUSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 15:18:07 -0500
Received: by mail-lf0-f51.google.com with SMTP id l143so114597195lfe.2
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2016 12:18:06 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/2] cx23885: fix reversed I2C bus numbering
Date: Tue, 16 Feb 2016 22:17:45 +0200
Message-Id: <1455653865-13005-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1455653865-13005-1-git-send-email-olli.salonen@iki.fi>
References: <1455653865-13005-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C buses for DVBSky T980C and S950C were numbered in an opposite
way compared to every other board in the driver. Switch numbering
to a more logical way.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 6e40dec..f041b69 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1988,8 +1988,8 @@ static int dvb_register(struct cx23885_tsport *port)
 		break;
 	case CX23885_BOARD_DVBSKY_T980C:
 	case CX23885_BOARD_TT_CT2_4500_CI:
-		i2c_bus = &dev->i2c_bus[1];
-		i2c_bus2 = &dev->i2c_bus[0];
+		i2c_bus = &dev->i2c_bus[0];
+		i2c_bus2 = &dev->i2c_bus[1];
 
 		/* attach frontend */
 		memset(&si2168_config, 0, sizeof(si2168_config));
@@ -2001,7 +2001,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		info.addr = 0x64;
 		info.platform_data = &si2168_config;
 		request_module(info.type);
-		client_demod = i2c_new_device(&i2c_bus->i2c_adap, &info);
+		client_demod = i2c_new_device(&i2c_bus2->i2c_adap, &info);
 		if (client_demod == NULL || client_demod->dev.driver == NULL)
 			goto frontend_detach;
 		if (!try_module_get(client_demod->dev.driver->owner)) {
@@ -2030,13 +2030,13 @@ static int dvb_register(struct cx23885_tsport *port)
 		port->i2c_client_tuner = client_tuner;
 		break;
 	case CX23885_BOARD_DVBSKY_S950C:
-		i2c_bus = &dev->i2c_bus[1];
-		i2c_bus2 = &dev->i2c_bus[0];
+		i2c_bus = &dev->i2c_bus[0];
+		i2c_bus2 = &dev->i2c_bus[1];
 
 		/* attach frontend */
 		fe0->dvb.frontend = dvb_attach(m88ds3103_attach,
 				&dvbsky_s950c_m88ds3103_config,
-				&i2c_bus->i2c_adap, &adapter);
+				&i2c_bus2->i2c_adap, &adapter);
 		if (fe0->dvb.frontend == NULL)
 			break;
 
-- 
1.9.1

