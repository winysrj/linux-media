Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:36086 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbbC0L5k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 07:57:40 -0400
Received: by lbbug6 with SMTP id ug6so61767572lbb.3
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2015 04:57:39 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 4/5] dvbsky: use si2168 config option ts_clock_gapped
Date: Fri, 27 Mar 2015 13:57:18 +0200
Message-Id: <1427457439-1493-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>
References: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the dvbsky driver to support gapped clock instead of the current
hack.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 9b5add4..a8495cd 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -619,7 +619,8 @@ static int dvbsky_t330_attach(struct dvb_usb_adapter *adap)
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

