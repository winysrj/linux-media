Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36281 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753722AbeAJMU4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 07:20:56 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: ts2020: avoid integer overflows on 32 bit machines
Date: Wed, 10 Jan 2018 07:20:51 -0500
Message-Id: <5a76e47a889fde8726d60834ac1b0fdb8c775d96.1515586847.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before this patch, when compiled for arm32, the signal strength
were reported as:

Lock   (0x1f) Signal= 4294908.66dBm C/N= 12.79dB

Because of a 32 bit integer overflow. After it, it is properly
reported as:

	Lock   (0x1f) Signal= -58.64dBm C/N= 12.79dB

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/ts2020.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 931e5c98da8a..b879e1571469 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -368,7 +368,7 @@ static int ts2020_read_tuner_gain(struct dvb_frontend *fe, unsigned v_agc,
 		gain2 = clamp_t(long, gain2, 0, 13);
 		v_agc = clamp_t(long, v_agc, 400, 1100);
 
-		*_gain = -(gain1 * 2330 +
+		*_gain = -((__s64)gain1 * 2330 +
 			   gain2 * 3500 +
 			   v_agc * 24 / 10 * 10 +
 			   10000);
@@ -386,7 +386,7 @@ static int ts2020_read_tuner_gain(struct dvb_frontend *fe, unsigned v_agc,
 		gain3 = clamp_t(long, gain3, 0, 6);
 		v_agc = clamp_t(long, v_agc, 600, 1600);
 
-		*_gain = -(gain1 * 2650 +
+		*_gain = -((__s64)gain1 * 2650 +
 			   gain2 * 3380 +
 			   gain3 * 2850 +
 			   v_agc * 176 / 100 * 10 -
-- 
2.14.3
