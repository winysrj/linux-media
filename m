Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41661 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031086AbbD1XEm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:04:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/13] stv0288: fix indentation
Date: Tue, 28 Apr 2015 20:04:28 -0300
Message-Id: <32dc88090817fea7b8b83214a17a347e1ab59daa.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/stv0288.c:137 stv0288_set_symbolrate() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
index 632b25156e4c..ecf4bb3a3b6b 100644
--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -134,20 +134,20 @@ static int stv0288_set_symbolrate(struct dvb_frontend *fe, u32 srate)
 
 	temp = (unsigned int)srate / 1000;
 
-		temp = temp * 32768;
-		temp = temp / 25;
-		temp = temp / 125;
-		b[0] = (unsigned char)((temp >> 12) & 0xff);
-		b[1] = (unsigned char)((temp >> 4) & 0xff);
-		b[2] = (unsigned char)((temp << 4) & 0xf0);
-		stv0288_writeregI(state, 0x28, 0x80); /* SFRH */
-		stv0288_writeregI(state, 0x29, 0); /* SFRM */
-		stv0288_writeregI(state, 0x2a, 0); /* SFRL */
+	temp = temp * 32768;
+	temp = temp / 25;
+	temp = temp / 125;
+	b[0] = (unsigned char)((temp >> 12) & 0xff);
+	b[1] = (unsigned char)((temp >> 4) & 0xff);
+	b[2] = (unsigned char)((temp << 4) & 0xf0);
+	stv0288_writeregI(state, 0x28, 0x80); /* SFRH */
+	stv0288_writeregI(state, 0x29, 0); /* SFRM */
+	stv0288_writeregI(state, 0x2a, 0); /* SFRL */
 
-		stv0288_writeregI(state, 0x28, b[0]);
-		stv0288_writeregI(state, 0x29, b[1]);
-		stv0288_writeregI(state, 0x2a, b[2]);
-		dprintk("stv0288: stv0288_set_symbolrate\n");
+	stv0288_writeregI(state, 0x28, b[0]);
+	stv0288_writeregI(state, 0x29, b[1]);
+	stv0288_writeregI(state, 0x2a, b[2]);
+	dprintk("stv0288: stv0288_set_symbolrate\n");
 
 	return 0;
 }
-- 
2.1.0

