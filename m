Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44839 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751176AbeECVUX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 17:20:23 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 2/9] cx231xx: Use board profile values for addresses
Date: Thu,  3 May 2018 16:20:08 -0500
Message-Id: <1525382415-4049-3-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
References: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace all usage of hard coded values with
the proper field from the board profile.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 67ed667..99f1a77 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -728,7 +728,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend[0]->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(tda18271_attach, dev->dvb->frontend[0],
-			       0x60, tuner_i2c,
+			       dev->board.tuner_addr, tuner_i2c,
 			       &cnxt_rde253s_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -752,7 +752,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend[0]->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(tda18271_attach, dev->dvb->frontend[0],
-			       0x60, tuner_i2c,
+			       dev->board.tuner_addr, tuner_i2c,
 			       &cnxt_rde253s_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -779,7 +779,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend[0]->callback = cx231xx_tuner_callback;
 
 		dvb_attach(tda18271_attach, dev->dvb->frontend[0],
-			   0x60, tuner_i2c,
+			   dev->board.tuner_addr, tuner_i2c,
 			   &hcw_tda18271_config);
 		break;
 
@@ -797,7 +797,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
-		info.addr = 0x64;
+		info.addr = dev->board.demod_addr;
 		info.platform_data = &si2165_pdata;
 		request_module(info.type);
 		client = i2c_new_device(demod_i2c, &info);
@@ -822,8 +822,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend[0]->callback = cx231xx_tuner_callback;
 
 		dvb_attach(tda18271_attach, dev->dvb->frontend[0],
-			0x60,
-			tuner_i2c,
+			dev->board.tuner_addr, tuner_i2c,
 			&hcw_tda18271_config);
 
 		dev->cx231xx_reset_analog_tuner = NULL;
@@ -844,7 +843,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
-		info.addr = 0x64;
+		info.addr = dev->board.demod_addr;
 		info.platform_data = &si2165_pdata;
 		request_module(info.type);
 		client = i2c_new_device(demod_i2c, &info);
@@ -879,7 +878,7 @@ static int dvb_init(struct cx231xx *dev)
 		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-		info.addr = 0x60;
+		info.addr = dev->board.tuner_addr;
 		info.platform_data = &si2157_config;
 		request_module("si2157");
 
@@ -938,7 +937,7 @@ static int dvb_init(struct cx231xx *dev)
 		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-		info.addr = 0x60;
+		info.addr = dev->board.tuner_addr;
 		info.platform_data = &si2157_config;
 		request_module("si2157");
 
@@ -985,7 +984,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend[0]->callback = cx231xx_tuner_callback;
 
 		dvb_attach(tda18271_attach, dev->dvb->frontend[0],
-			   0x60, tuner_i2c,
+			   dev->board.tuner_addr, tuner_i2c,
 			   &pv_tda18271_config);
 		break;
 
-- 
2.7.4
