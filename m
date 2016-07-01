Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbcGAOD2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 10:03:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>
Subject: [PATCH 2/4] cxd2841er: provide signal strength for DVB-C
Date: Fri,  1 Jul 2016 11:03:14 -0300
Message-Id: <61dea922c711592c5bf13a2ced7da4b31fa8a9fc.1467381792.git.mchehab@s-opensource.com>
In-Reply-To: <75889448cdfcea311a0c0f5e1c8cc022915dd4fe.1467381792.git.mchehab@s-opensource.com>
References: <75889448cdfcea311a0c0f5e1c8cc022915dd4fe.1467381792.git.mchehab@s-opensource.com>
In-Reply-To: <75889448cdfcea311a0c0f5e1c8cc022915dd4fe.1467381792.git.mchehab@s-opensource.com>
References: <75889448cdfcea311a0c0f5e1c8cc022915dd4fe.1467381792.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, there's no stats for DVB-C. Let's at least return
signal strength. The scale is different than on DVB-T, so let's
use a relative scale, for now.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/cxd2841er.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 543b20155efc..e35f5d0d3f34 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -1752,6 +1752,12 @@ static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
 		/* Formula was empirically determinated @ 410 MHz */
 		p->strength.stat[0].uvalue = ((s32)strength) * 366 / 100 - 89520;
 		break;	/* Code moved out of the function */
+	case SYS_DVBC_ANNEX_A:
+		strength = cxd2841er_read_agc_gain_t_t2(priv,
+							p->delivery_system);
+		p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		p->strength.stat[0].uvalue = strength;
+		break;
 	case SYS_ISDBT:
 		strength = 65535 - cxd2841er_read_agc_gain_i(
 				priv, p->delivery_system);
-- 
2.7.4

