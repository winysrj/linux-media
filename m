Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:55737 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbaKTUeG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 15:34:06 -0500
Received: by mail-lb0-f181.google.com with SMTP id l4so2997509lbv.12
        for <linux-media@vger.kernel.org>; Thu, 20 Nov 2014 12:34:05 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 3/3] em28xx: initialize si2168_config struct
Date: Thu, 20 Nov 2014 22:33:49 +0200
Message-Id: <1416515629-22183-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1416515629-22183-1-git-send-email-olli.salonen@iki.fi>
References: <1416515629-22183-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When new parameters are added for si2168 driver, the parameters have to be explicitly defined for each device if the
si2168_config struct is not initialized to all zeros.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 65a456d..5a94f17 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1553,6 +1553,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			struct si2157_config si2157_config;
 
 			/* attach demod */
+			memset(&si2168_config, 0, sizeof(si2168_config));
 			si2168_config.i2c_adapter = &adapter;
 			si2168_config.fe = &dvb->fe[0];
 			si2168_config.ts_mode = SI2168_TS_PARALLEL;
-- 
1.9.1

