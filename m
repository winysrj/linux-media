Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbaIWUCw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 16:02:52 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] [media] tc90522: declare tc90522_functionality as static
Date: Tue, 23 Sep 2014 17:02:24 -0300
Message-Id: <5b2f265c143c9e8ee35b035de7d35bb69871fd84.1411502537.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/tc90522.c:706:5: warning: symbol 'tc90522_functionality' was not declared. Should it be static?
drivers/media/dvb-frontends/tc90522.c:706:5: warning: no previous prototype for 'tc90522_functionality' [-Wmissing-prototypes]
 u32 tc90522_functionality(struct i2c_adapter *adap)
     ^

Cc: Akihiro Tsukada <tskd08@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index f4760dd998c3..cdd9808c322c 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -703,7 +703,7 @@ tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	return (ret == j) ? num : ret;
 }
 
-u32 tc90522_functionality(struct i2c_adapter *adap)
+static u32 tc90522_functionality(struct i2c_adapter *adap)
 {
 	return I2C_FUNC_I2C;
 }
-- 
1.9.3

