Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbD2XG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:26 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 21/27] tda10086: change typecast to u64 to avoid smatch warnings
Date: Wed, 29 Apr 2015 20:06:06 -0300
Message-Id: <1acf7361dc975eea2f0fb7f620a7964ee1a8219d.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/tda10086.c:476 tda10086_get_frontend() warn: should 'tda10086_read_byte(state, 81) << 8' be a 64 bit type?

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/tda10086.c b/drivers/media/dvb-frontends/tda10086.c
index fcfe2e080cb0..f1a752187d08 100644
--- a/drivers/media/dvb-frontends/tda10086.c
+++ b/drivers/media/dvb-frontends/tda10086.c
@@ -472,8 +472,8 @@ static int tda10086_get_frontend(struct dvb_frontend *fe)
 		return -EINVAL;
 
 	/* calculate the updated frequency (note: we convert from Hz->kHz) */
-	tmp64 = tda10086_read_byte(state, 0x52);
-	tmp64 |= (tda10086_read_byte(state, 0x51) << 8);
+	tmp64 = ((u64)tda10086_read_byte(state, 0x52)
+		| (tda10086_read_byte(state, 0x51) << 8));
 	if (tmp64 & 0x8000)
 		tmp64 |= 0xffffffffffff0000ULL;
 	tmp64 = (tmp64 * (SACLK/1000ULL));
-- 
2.1.0

