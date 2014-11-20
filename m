Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:61440 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbaKTUeA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 15:34:00 -0500
Received: by mail-la0-f45.google.com with SMTP id gq15so3134754lab.32
        for <linux-media@vger.kernel.org>; Thu, 20 Nov 2014 12:33:59 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/3] cxusb: initialize si2168_config struct
Date: Thu, 20 Nov 2014 22:33:47 +0200
Message-Id: <1416515629-22183-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When new parameters are added for si2168 driver, the parameters have to be explicitly defined for each device if the 
si2168_config struct is not initialized to all zeros.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/cxusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 356abb3..ef73c93 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1435,6 +1435,7 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
 	msleep(100);
 
 	/* attach frontend */
+	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &adapter;
 	si2168_config.fe = &adap->fe_adap[0].fe;
 	si2168_config.ts_mode = SI2168_TS_PARALLEL;
-- 
1.9.1

