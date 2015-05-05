Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34743 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761087AbbEEQyj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 12:54:39 -0400
Received: by lbcga7 with SMTP id ga7so133647160lbc.1
        for <linux-media@vger.kernel.org>; Tue, 05 May 2015 09:54:38 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH v4 2/6] dvbsky: use si2168 config option ts_clock_gapped
Date: Tue,  5 May 2015 19:54:15 +0300
Message-Id: <1430844859-24947-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1430844859-24947-1-git-send-email-olli.salonen@iki.fi>
References: <1430844859-24947-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the dvbsky driver to support gapped clock instead of the current
hack.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index cdf59bc..0f73b1d 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -615,7 +615,8 @@ static int dvbsky_t330_attach(struct dvb_usb_adapter *adap)
 	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &i2c_adapter;
 	si2168_config.fe = &adap->fe[0];
-	si2168_config.ts_mode = SI2168_TS_PARALLEL | 0x40;
+	si2168_config.ts_mode = SI2168_TS_PARALLEL;
+	si2168_config.ts_clock_gapped = true;
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
 	info.addr = 0x64;
-- 
1.9.1

