Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbcBVTJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 14:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 3/9] [media] stv0900: avoid going past array
Date: Mon, 22 Feb 2016 16:09:17 -0300
Message-Id: <f4d17794d984e8e5bec9f4063ee06bb616294cae.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following smatch warnings:
	drivers/media/dvb-frontends/stv0900_core.c:1183 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
	drivers/media/dvb-frontends/stv0900_core.c:1185 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
	drivers/media/dvb-frontends/stv0900_core.c:1187 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
	drivers/media/dvb-frontends/stv0900_core.c:1189 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
	drivers/media/dvb-frontends/stv0900_core.c:1191 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/stv0900_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index 28239b1fd954..f667005a6661 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -1087,7 +1087,7 @@ u8 stv0900_get_optim_carr_loop(s32 srate, enum fe_stv0900_modcode modcode,
 							s32 pilot, u8 chip_id)
 {
 	u8 aclc_value = 0x29;
-	s32 i;
+	s32 i, cllas2_size;
 	const struct stv0900_car_loop_optim *cls2, *cllqs2, *cllas2;
 
 	dprintk("%s\n", __func__);
@@ -1096,14 +1096,17 @@ u8 stv0900_get_optim_carr_loop(s32 srate, enum fe_stv0900_modcode modcode,
 		cls2 = FE_STV0900_S2CarLoop;
 		cllqs2 = FE_STV0900_S2LowQPCarLoopCut30;
 		cllas2 = FE_STV0900_S2APSKCarLoopCut30;
+		cllas2_size = ARRAY_SIZE(FE_STV0900_S2APSKCarLoopCut30);
 	} else if (chip_id == 0x20) {
 		cls2 = FE_STV0900_S2CarLoopCut20;
 		cllqs2 = FE_STV0900_S2LowQPCarLoopCut20;
 		cllas2 = FE_STV0900_S2APSKCarLoopCut20;
+		cllas2_size = ARRAY_SIZE(FE_STV0900_S2APSKCarLoopCut20);
 	} else {
 		cls2 = FE_STV0900_S2CarLoopCut30;
 		cllqs2 = FE_STV0900_S2LowQPCarLoopCut30;
 		cllas2 = FE_STV0900_S2APSKCarLoopCut30;
+		cllas2_size = ARRAY_SIZE(FE_STV0900_S2APSKCarLoopCut30);
 	}
 
 	if (modcode < STV0900_QPSK_12) {
@@ -1178,7 +1181,7 @@ u8 stv0900_get_optim_carr_loop(s32 srate, enum fe_stv0900_modcode modcode,
 				aclc_value = cls2[i].car_loop_pilots_off_30;
 		}
 
-	} else {
+	} else if (i < cllas2_size) {
 		if (srate <= 3000000)
 			aclc_value = cllas2[i].car_loop_pilots_on_2;
 		else if (srate <= 7000000)
-- 
2.5.0

