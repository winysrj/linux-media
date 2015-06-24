Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33362 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbbFXKtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 06:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/7] [media] lmedm04: use u32 instead of u64 for relative stats
Date: Wed, 24 Jun 2015 07:49:10 -0300
Message-Id: <16b045d679aff9359b1070410ef874f299302ae0.1435142906.git.mchehab@osg.samsung.com>
In-Reply-To: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
References: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
In-Reply-To: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
References: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanup this sparse warning:
	drivers/media/usb/dvb-usb-v2/lmedm04.c:302 lme2510_update_stats() warn: should '((255 - st->signal_sn - 161) * 3) << 8' be a 64 bit type?

Both c_tmp and s_tmp actually stores a u16 stat. Using a u64 data
there is a waste, specially on u32 archs, as 64 ints there are more
expensive.

So, change the types to u32 and do the typecast only when storing
the result.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 57fb184184bf..fcef2a33ef3d 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -262,7 +262,7 @@ static void lme2510_update_stats(struct dvb_usb_adapter *adap)
 	struct lme2510_state *st = adap_to_priv(adap);
 	struct dvb_frontend *fe = adap->fe[0];
 	struct dtv_frontend_properties *c;
-	u64 s_tmp = 0, c_tmp = 0;
+	u32 s_tmp = 0, c_tmp = 0;
 
 	if (!fe)
 		return;
@@ -309,11 +309,11 @@ static void lme2510_update_stats(struct dvb_usb_adapter *adap)
 
 	c->strength.len = 1;
 	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
-	c->strength.stat[0].uvalue = s_tmp;
+	c->strength.stat[0].uvalue = (u64)s_tmp;
 
 	c->cnr.len = 1;
 	c->cnr.stat[0].scale = FE_SCALE_RELATIVE;
-	c->cnr.stat[0].uvalue = c_tmp;
+	c->cnr.stat[0].uvalue = (u64)c_tmp;
 }
 
 static void lme2510_int_response(struct urb *lme_urb)
-- 
2.4.3

