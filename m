Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 17/19] em28xx-dvb: remove some left over
Date: Fri, 24 Jun 2016 12:31:58 -0300
Message-Id: <5776fbec90735e72e1310d0d006c098aca7f1f00.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gcc 6.1 warns about an unused table:

drivers/media/usb/em28xx/em28xx-dvb.c:907:38: warning: 'pctv_461e_m88ds3103_config' defined but not used [-Wunused-const-variable=]
 static const struct m88ds3103_config pctv_461e_m88ds3103_config = {
                                      ^~~~~~~~~~~~~~~~~~~~~~~~~~

That's a left over of patch 76b91be3d360a ('em28xx: PCTV 461e use I2C
client for demod and SEC').

Remove the dead code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 1a5c01202f73..8cedef0daae4 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -904,17 +904,6 @@ static struct tda18271_config c3tech_duo_tda18271_config = {
 	.small_i2c = TDA18271_03_BYTE_CHUNK_INIT,
 };
 
-static const struct m88ds3103_config pctv_461e_m88ds3103_config = {
-	.i2c_addr = 0x68,
-	.clock = 27000000,
-	.i2c_wr_max = 33,
-	.clock_out = 0,
-	.ts_mode = M88DS3103_TS_PARALLEL,
-	.ts_clk = 16000,
-	.ts_clk_pol = 1,
-	.agc = 0x99,
-};
-
 static struct tda18271_std_map drx_j_std_map = {
 	.atsc_6   = { .if_freq = 5000, .agc_mode = 3, .std = 0, .if_lvl = 1,
 		      .rfagc_top = 0x37, },
-- 
2.7.4


