Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:48244 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbaKTUeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 15:34:04 -0500
Received: by mail-lb0-f169.google.com with SMTP id p9so1949553lbv.28
        for <linux-media@vger.kernel.org>; Thu, 20 Nov 2014 12:34:02 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/3] af9035: initialize si2168_config struct
Date: Thu, 20 Nov 2014 22:33:48 +0200
Message-Id: <1416515629-22183-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1416515629-22183-1-git-send-email-olli.salonen@iki.fi>
References: <1416515629-22183-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When new parameters are added for si2168 driver, the parameters have to be explicitly defined for each device if the
si2168_config struct is not initialized to all zeros.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 1896ab2..80a29f5 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1171,6 +1171,7 @@ static int it930x_frontend_attach(struct dvb_usb_adapter *adap)
 
 	dev_dbg(&d->udev->dev, "adap->id=%d\n", adap->id);
 
+	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &adapter;
 	si2168_config.fe = &adap->fe[0];
 	si2168_config.ts_mode = SI2168_TS_SERIAL;
-- 
1.9.1

