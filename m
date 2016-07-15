Return-path: <linux-media-owner@vger.kernel.org>
Received: from 108-197-250-228.lightspeed.miamfl.sbcglobal.net ([108.197.250.228]:53266
	"EHLO usa.attlocal.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751276AbcGOUV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 16:21:26 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH 1/3] [media] cxd2841er: fix switch-case for DVB-C
Date: Fri, 15 Jul 2016 16:21:18 -0400
Message-Id: <1468614078-2612-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

compilation was failed with complains about duplicate case.
now fixed

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb-frontends/cxd2841er.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 41349c2..b2bfbaa 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -1750,14 +1750,6 @@ static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
-	case SYS_DVBC_ANNEX_A:
-	case SYS_DVBC_ANNEX_B:
-	case SYS_DVBC_ANNEX_C:
-		strength = 65535 - cxd2841er_read_agc_gain_c(
-				priv, p->delivery_system);
-		p->strength.stat[0].scale = FE_SCALE_RELATIVE;
-		p->strength.stat[0].uvalue = strength;
-		break;
 	case SYS_DVBT:
 	case SYS_DVBT2:
 		strength = cxd2841er_read_agc_gain_t_t2(priv,
@@ -1767,7 +1759,9 @@ static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
 		p->strength.stat[0].uvalue = strength * 366 / 100 - 89520;
 		break;	/* Code moved out of the function */
 	case SYS_DVBC_ANNEX_A:
-		strength = cxd2841er_read_agc_gain_t_t2(priv,
+	case SYS_DVBC_ANNEX_B:
+	case SYS_DVBC_ANNEX_C:
+		strength = cxd2841er_read_agc_gain_c(priv,
 							p->delivery_system);
 		p->strength.stat[0].scale = FE_SCALE_DECIBEL;
 		/*
-- 
2.7.4

