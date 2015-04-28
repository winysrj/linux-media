Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031115AbbD1XEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:04:43 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 05/13] lgdt3306a: fix indentation
Date: Tue, 28 Apr 2015 20:04:27 -0300
Message-Id: <4c0ba574a0a1a9a7971c81fe8853ee4eed7f54f4.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/lgdt3306a.c:2104 lgdt3306a_DumpRegs() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index d9a2b0e768e0..0e2e43e9ede5 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -2101,7 +2101,7 @@ static void lgdt3306a_DumpRegs(struct lgdt3306a_state *state)
 		lgdt3306a_read_reg(state, regtab[i], &regval1[i]);
 		if (regval1[i] != regval2[i]) {
 			lg_debug(" %04X = %02X\n", regtab[i], regval1[i]);
-				 regval2[i] = regval1[i];
+			regval2[i] = regval1[i];
 		}
 	}
 	debug = sav_debug;
-- 
2.1.0

