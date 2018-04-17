Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:51048 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755304AbeDQQk0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 12:40:26 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@s-opensource.com
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 6/9] cx231xx: Update 955Q from dvb attach to i2c device
Date: Tue, 17 Apr 2018 11:39:52 -0500
Message-Id: <1523983195-28691-7-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
References: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trim out some unused config params. Use the i2c mux
adapter returned by frontend with the tuner.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index f5903e6..ac1d8e6 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -156,10 +156,8 @@ static struct tda18271_config pv_tda18271_config = {
 };
 
 static struct lgdt3306a_config hauppauge_955q_lgdt3306a_config = {
-	.i2c_addr           = 0x59,
 	.qam_if_khz         = 4000,
 	.vsb_if_khz         = 3250,
-	.deny_i2c_rptr      = 1,
 	.spectral_inversion = 1,
 	.mpeg_mode          = LGDT3306A_MPEG_SERIAL,
 	.tpclk_edge         = LGDT3306A_TPCLK_RISING_EDGE,
@@ -860,18 +858,22 @@ static int dvb_init(struct cx231xx *dev)
 	case CX231XX_BOARD_HAUPPAUGE_955Q:
 	{
 		struct si2157_config si2157_config = {};
+		struct lgdt3306a_config lgdt3306a_config = {};
 
-		dev->dvb->frontend[0] = dvb_attach(lgdt3306a_attach,
-			&hauppauge_955q_lgdt3306a_config,
-			demod_i2c
-			);
+		/* attach first demodulator chip */
+		lgdt3306a_config = hauppauge_955q_lgdt3306a_config;
+		lgdt3306a_config.fe = &dev->dvb->frontend[0];
+		lgdt3306a_config.i2c_adapter = &adapter;
 
-		if (!dev->dvb->frontend[0]) {
-			dev_err(dev->dev,
-				"Failed to attach LGDT3306A frontend.\n");
-			result = -EINVAL;
+		/* perform tuner probe/init/attach */
+		client = dvb_module_probe("lgdt3306a", NULL, demod_i2c,
+						dev->board.demod_addr,
+						&lgdt3306a_config);
+		if (!client) {
+			result = -ENODEV;
 			goto out_free;
 		}
+		dvb->i2c_client_demod[0] = client;
 
 		dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
 
-- 
2.7.4
