Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.194]:56416 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaHKT62 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 15:58:28 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: olli@cabbala.net
Cc: Olli Salonen <olli.salonen@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/6] em28xx: add ts mode setting for PCTV 461e
Date: Mon, 11 Aug 2014 22:58:11 +0300
Message-Id: <1407787095-2167-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi>
References: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TS mode must be set in the existing PCTV 461e driver.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index d8e9760..0645793 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1535,6 +1535,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			/* attach demod */
 			si2168_config.i2c_adapter = &adapter;
 			si2168_config.fe = &dvb->fe[0];
+			si2168_config.ts_mode = SI2168_TS_PARALLEL;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
 			info.addr = 0x64;
-- 
1.9.1

