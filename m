Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:38017 "EHLO
        homiemail-a123.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753296AbeAQVck (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 16:32:40 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 2/2] em28xx: Enable inversion for Solo/Dual HD DVB models
Date: Wed, 17 Jan 2018 15:32:36 -0600
Message-Id: <1516224756-1649-3-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1516224756-1649-1-git-send-email-brad@nextdimension.cc>
References: <1516224756-1649-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge Solo/Dual HD DVB models use a si2157 tuner, which is set to
produce inverted spectrum. This configures the si2168 DVB demod for
inverted spectrum on both affected models.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 9bc9576..6d0616e 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1727,6 +1727,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			si2168_config.i2c_adapter = &adapter;
 			si2168_config.fe = &dvb->fe[0];
 			si2168_config.ts_mode = SI2168_TS_PARALLEL;
+			si2168_config.spectral_inversion = true;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
 			info.addr = 0x64;
@@ -1911,6 +1912,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			si2168_config.i2c_adapter = &adapter;
 			si2168_config.fe = &dvb->fe[0];
 			si2168_config.ts_mode = SI2168_TS_SERIAL;
+			si2168_config.spectral_inversion = true;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
 			if (dev->ts == PRIMARY_TS)
-- 
2.7.4
