Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/46] [media] m88ds3103: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:45 -0300
Message-Id: <f41a36df0436e3724c194531ce6b5d6c775b1666.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 6eae2c619843..81657e94c5a4 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1063,16 +1063,16 @@ static int m88ds3103_set_voltage(struct dvb_frontend *fe,
 
 	switch (fe_sec_voltage) {
 	case SEC_VOLTAGE_18:
-		voltage_sel = 1;
-		voltage_dis = 0;
+		voltage_sel = true;
+		voltage_dis = false;
 		break;
 	case SEC_VOLTAGE_13:
-		voltage_sel = 0;
-		voltage_dis = 0;
+		voltage_sel = false;
+		voltage_dis = false;
 		break;
 	case SEC_VOLTAGE_OFF:
-		voltage_sel = 0;
-		voltage_dis = 1;
+		voltage_sel = false;
+		voltage_dis = true;
 		break;
 	default:
 		dev_dbg(&priv->i2c->dev, "%s: invalid fe_sec_voltage\n",
-- 
1.9.3

