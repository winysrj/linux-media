Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44682 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbdKEOZ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:26 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 09/15] cx231xx: Use semicolon after assignment instead of comma
Date: Sun,  5 Nov 2017 15:25:05 +0100
Message-Id: <20171105142511.16563-9-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

End assignments by semicolon instead of comma.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 4e462edf044f..5cee642dff06 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -762,8 +762,8 @@ static int dvb_init(struct cx231xx *dev)
 		/* attach demod */
 		memset(&si2165_pdata, 0, sizeof(si2165_pdata));
 		si2165_pdata.fe = &dev->dvb->frontend;
-		si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL,
-		si2165_pdata.ref_freq_hz = 16000000,
+		si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL;
+		si2165_pdata.ref_freq_hz = 16000000;
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
@@ -809,8 +809,8 @@ static int dvb_init(struct cx231xx *dev)
 		/* attach demod */
 		memset(&si2165_pdata, 0, sizeof(si2165_pdata));
 		si2165_pdata.fe = &dev->dvb->frontend;
-		si2165_pdata.chip_mode = SI2165_MODE_PLL_EXT,
-		si2165_pdata.ref_freq_hz = 24000000,
+		si2165_pdata.chip_mode = SI2165_MODE_PLL_EXT;
+		si2165_pdata.ref_freq_hz = 24000000;
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
-- 
2.15.0
