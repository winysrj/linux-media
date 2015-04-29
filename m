Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbbD2XGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 07/27] stv0297: change typecast to u64 to avoid smatch warnings
Date: Wed, 29 Apr 2015 20:05:52 -0300
Message-Id: <27e24ddb9f6859119c2f541f8fcef40ccf761d9d.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/stv0297.c:140 stv0297_get_symbolrate() warn: should 'stv0297_readreg(state, 86) << 8' be a 64 bit type?
drivers/media/dvb-frontends/stv0297.c:141 stv0297_get_symbolrate() warn: should 'stv0297_readreg(state, 87) << 16' be a 64 bit type?
drivers/media/dvb-frontends/stv0297.c:142 stv0297_get_symbolrate() warn: should 'stv0297_readreg(state, 88) << 24' be a 64 bit type?

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/stv0297.c b/drivers/media/dvb-frontends/stv0297.c
index d40f226160ef..dfc14d5c3999 100644
--- a/drivers/media/dvb-frontends/stv0297.c
+++ b/drivers/media/dvb-frontends/stv0297.c
@@ -136,10 +136,10 @@ static u32 stv0297_get_symbolrate(struct stv0297_state *state)
 {
 	u64 tmp;
 
-	tmp = stv0297_readreg(state, 0x55);
-	tmp |= stv0297_readreg(state, 0x56) << 8;
-	tmp |= stv0297_readreg(state, 0x57) << 16;
-	tmp |= stv0297_readreg(state, 0x58) << 24;
+	tmp = (u64)(stv0297_readreg(state, 0x55)
+		    | (stv0297_readreg(state, 0x56) << 8)
+		    | (stv0297_readreg(state, 0x57) << 16)
+		    | (stv0297_readreg(state, 0x58) << 24));
 
 	tmp *= STV0297_CLOCK_KHZ;
 	tmp >>= 32;
-- 
2.1.0

