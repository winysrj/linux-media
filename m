Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbbHKWku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 18:40:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] [media] tda10071: use div_s64() when dividing a s64 integer
Date: Tue, 11 Aug 2015 19:39:05 -0300
Message-Id: <7d0ddc91c854f1f42fd7165e259b3573f53c1d73.1439332733.git.mchehab@osg.samsung.com>
In-Reply-To: <53cc7c9043f0a68a66e53623b114c86051a7250c.1439332733.git.mchehab@osg.samsung.com>
References: <53cc7c9043f0a68a66e53623b114c86051a7250c.1439332733.git.mchehab@osg.samsung.com>
In-Reply-To: <53cc7c9043f0a68a66e53623b114c86051a7250c.1439332733.git.mchehab@osg.samsung.com>
References: <53cc7c9043f0a68a66e53623b114c86051a7250c.1439332733.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise, it will break on 32 bits archs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index ee6653124618..119d47596ac8 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -527,7 +527,7 @@ static int tda10071_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	unsigned int uitmp;
 
 	if (c->strength.stat[0].scale == FE_SCALE_DECIBEL) {
-		uitmp = c->strength.stat[0].svalue / 1000 + 256;
+		uitmp = div_s64(c->strength.stat[0].svalue, 1000) + 256;
 		uitmp = clamp(uitmp, 181U, 236U); /* -75dBm - -20dBm */
 		/* scale value to 0x0000-0xffff */
 		*strength = (uitmp-181) * 0xffff / (236-181);
-- 
2.4.3

