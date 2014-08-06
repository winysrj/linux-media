Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53108 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaHFEeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 00:34:50 -0400
Received: by mail-pa0-f41.google.com with SMTP id rd3so2706238pab.0
        for <linux-media@vger.kernel.org>; Tue, 05 Aug 2014 21:34:50 -0700 (PDT)
Date: Wed, 6 Aug 2014 12:34:44 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] support for DVBSky dvb-s2 usb: change em28xx-dvb.c following the m88ds3103 config change
Message-ID: <201408061234417811441@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

change em28xx-dvb.c following the m88ds3103 config change

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 3a3e243..d8e9760 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -856,7 +856,9 @@ static const struct m88ds3103_config pctv_461e_m88ds3103_config = {
 	.clock = 27000000,
 	.i2c_wr_max = 33,
 	.clock_out = 0,
-	.ts_mode = M88DS3103_TS_PARALLEL_16,
+	.ts_mode = M88DS3103_TS_PARALLEL,
+	.ts_clk = 16000,
+	.ts_clk_pol = 1,
 	.agc = 0x99,
 };
  

