Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:40905 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbeG0FBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 01:01:46 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: mchehab@kernel.org, hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 2/2] media: pci: cx88: Replace mdelay() with msleep() in dvb_register()
Date: Fri, 27 Jul 2018 11:41:50 +0800
Message-Id: <20180727034150.4259-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_register() is never called in atomic context.
It calls mdelay() to busily wait, which is not necessary.
mdelay() can be replaced with msleep().

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/pci/cx88/cx88-dvb.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 2f886140dd2e..f350adc94cb8 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -1229,9 +1229,9 @@ static int dvb_register(struct cx8802_dev *dev)
 
 		/* Do a hardware reset of chip before using it. */
 		cx_clear(MO_GP0_IO, 1);
-		mdelay(100);
+		msleep(100);
 		cx_set(MO_GP0_IO, 1);
-		mdelay(200);
+		msleep(200);
 
 		/* Select RF connector callback */
 		fusionhdtv_3_gold.pll_rf_set = lgdt330x_pll_rf_set;
@@ -1250,9 +1250,9 @@ static int dvb_register(struct cx8802_dev *dev)
 
 		/* Do a hardware reset of chip before using it. */
 		cx_clear(MO_GP0_IO, 1);
-		mdelay(100);
+		msleep(100);
 		cx_set(MO_GP0_IO, 9);
-		mdelay(200);
+		msleep(200);
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &fusionhdtv_3_gold,
 					       &core->i2c_adap);
@@ -1268,9 +1268,9 @@ static int dvb_register(struct cx8802_dev *dev)
 
 		/* Do a hardware reset of chip before using it. */
 		cx_clear(MO_GP0_IO, 1);
-		mdelay(100);
+		msleep(100);
 		cx_set(MO_GP0_IO, 1);
-		mdelay(200);
+		msleep(200);
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &fusionhdtv_5_gold,
 					       &core->i2c_adap);
@@ -1289,9 +1289,9 @@ static int dvb_register(struct cx8802_dev *dev)
 
 		/* Do a hardware reset of chip before using it. */
 		cx_clear(MO_GP0_IO, 1);
-		mdelay(100);
+		msleep(100);
 		cx_set(MO_GP0_IO, 1);
-		mdelay(200);
+		msleep(200);
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &pchdtv_hd5500,
 					       &core->i2c_adap);
@@ -1582,9 +1582,9 @@ static int dvb_register(struct cx8802_dev *dev)
 		cx_set(MO_GP0_IO, 0x0101);
 
 		cx_clear(MO_GP0_IO, 0x01);
-		mdelay(100);
+		msleep(100);
 		cx_set(MO_GP0_IO, 0x01);
-		mdelay(200);
+		msleep(200);
 
 		fe0->dvb.frontend = dvb_attach(stv0299_attach,
 					       &samsung_stv0299_config,
-- 
2.17.0
