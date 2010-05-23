Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:44249 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997Ab0EWSda (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 14:33:30 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 4/5] tm6000: add frontend tuner xc5000
Date: Sun, 23 May 2010 20:31:44 +0200
Message-Id: <1274639505-2674-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-dvb.c |   66 ++++++++++++++++++++++++----------
 1 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index e6a802e..b504a90 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -257,27 +257,53 @@ int tm6000_dvb_register(struct tm6000_core *dev)
 	dvb->adapter.priv = dev;
 
 	if (dvb->frontend) {
-		struct xc2028_config cfg = {
-			.i2c_adap = &dev->i2c_adap,
-			.i2c_addr = dev->tuner_addr,
-		};
-
-		dvb->frontend->callback = tm6000_tuner_callback;
-		ret = dvb_register_frontend(&dvb->adapter, dvb->frontend);
-		if (ret < 0) {
-			printk(KERN_ERR
-				"tm6000: couldn't register frontend\n");
-			goto adapter_err;
+		switch (dev->tuner_type) {
+		case TUNER_XC2028:
+			struct xc2028_config cfg = {
+				.i2c_adap = &dev->i2c_adap,
+				.i2c_addr = dev->tuner_addr,
+			};
+
+			dvb->frontend->callback = tm6000_tuner_callback;
+			ret = dvb_register_frontend(&dvb->adapter, dvb->frontend);
+			if (ret < 0) {
+				printk(KERN_ERR
+					"tm6000: couldn't register frontend\n");
+				goto adapter_err;
+			}
+
+			if (!dvb_attach(xc2028_attach, dvb->frontend, &cfg)) {
+				printk(KERN_ERR "tm6000: couldn't register "
+						"frontend (xc3028)\n");
+				ret = -EINVAL;
+				goto frontend_err;
+			}
+			printk(KERN_INFO "tm6000: XC2028/3028 asked to be "
+					 "attached to frontend!\n");
+			break;
+		case TUNER_XC5000:
+			struct xc5000_config cfg = {
+				.i2c_address = dev->tuner_addr,
+			};
+
+			dvb->frontend->callback = tm6000_xc5000_callback;
+			ret = dvb_register_frontend(&dvb->adapter, dvb->frontend);
+			if (ret < 0) {
+				printk(KERN_ERR
+					"tm6000: couldn't register frontend\n");
+				goto adapter_err;
+			}
+
+			if (!dvb_attach(xc5000_attach, dvb->frontend, &dev->i2c_adap, &cfg)) {
+				printk(KERN_ERR "tm6000: couldn't register "
+						"frontend (xc5000)\n");
+				ret = -EINVAL;
+				goto frontend_err;
+			}
+			printk(KERN_INFO "tm6000: XC5000 asked to be "
+					 "attached to frontend!\n");
+			break;
 		}
-
-		if (!dvb_attach(xc2028_attach, dvb->frontend, &cfg)) {
-			printk(KERN_ERR "tm6000: couldn't register "
-					"frontend (xc3028)\n");
-			ret = -EINVAL;
-			goto frontend_err;
-		}
-		printk(KERN_INFO "tm6000: XC2028/3028 asked to be "
-				 "attached to frontend!\n");
 	} else {
 		printk(KERN_ERR "tm6000: no frontend found\n");
 	}
-- 
1.7.0.3

