Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33711 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933304AbdKAVGR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 21/26] media: m88rs2000: handle the case where tuner doesn't have get_frequency
Date: Wed,  1 Nov 2017 17:05:58 -0400
Message-Id: <ba63d758d1ef892fd27e8dd6d356afa74c7583ee.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the tuner doesn't have get_frequency() callback, the current
code will place a random value as the frequency offset. That
doesn't seem right! The better is to just assume that, on such
case, the tuner was able to set the exact frequency that was
requested.

Fixes a smatch warning:
	drivers/media/dvb-frontends/m88rs2000.c:639 m88rs2000_set_frontend() error: uninitialized symbol 'tuner_freq'.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/m88rs2000.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index ce6c21d405ee..e34dab41d104 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -630,13 +630,16 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 	if (ret < 0)
 		return -ENODEV;
 
-	if (fe->ops.tuner_ops.get_frequency)
+	if (fe->ops.tuner_ops.get_frequency) {
 		ret = fe->ops.tuner_ops.get_frequency(fe, &tuner_freq);
 
-	if (ret < 0)
-		return -ENODEV;
+		if (ret < 0)
+			return -ENODEV;
 
-	offset = (s16)((s32)tuner_freq - c->frequency);
+		offset = (s16)((s32)tuner_freq - c->frequency);
+	} else {
+		offset = 0;
+	}
 
 	/* default mclk value 96.4285 * 2 * 1000 = 192857 */
 	if (((c->frequency % 192857) >= (192857 - 3000)) ||
-- 
2.13.6
