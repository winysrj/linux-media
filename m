Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbD2XGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/27] zl10353: fix indenting
Date: Wed, 29 Apr 2015 20:05:51 -0300
Message-Id: <94e7a63c4bf0524821c2e016cf88307d05ef182a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/zl10353.c:536 zl10353_read_ucblocks() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/zl10353.c b/drivers/media/dvb-frontends/zl10353.c
index 82946cd517f5..4e62a6611847 100644
--- a/drivers/media/dvb-frontends/zl10353.c
+++ b/drivers/media/dvb-frontends/zl10353.c
@@ -533,13 +533,13 @@ static int zl10353_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int zl10353_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct zl10353_state *state = fe->demodulator_priv;
-       u32 ubl = 0;
+	u32 ubl = 0;
 
-       ubl = zl10353_read_register(state, RS_UBC_1) << 8 |
-	     zl10353_read_register(state, RS_UBC_0);
+	ubl = zl10353_read_register(state, RS_UBC_1) << 8 |
+	      zl10353_read_register(state, RS_UBC_0);
 
-       state->ucblocks += ubl;
-       *ucblocks = state->ucblocks;
+	state->ucblocks += ubl;
+	*ucblocks = state->ucblocks;
 
 	return 0;
 }
-- 
2.1.0

