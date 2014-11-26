Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46759 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbaKZP00 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 10:26:26 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH] [media] tda18271: Fix identation
Date: Wed, 26 Nov 2014 13:26:09 -0200
Message-Id: <ebd316f3f4f7cefa937562adba8ce60f2057ca9d.1417015567.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/tuners/tda18271-common.c:176 tda18271_read_extended() warn: if statement not indented

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
index 86e5e3110118..6118203543ea 100644
--- a/drivers/media/tuners/tda18271-common.c
+++ b/drivers/media/tuners/tda18271-common.c
@@ -173,12 +173,9 @@ int tda18271_read_extended(struct dvb_frontend *fe)
 
 	for (i = 0; i < TDA18271_NUM_REGS; i++) {
 		/* don't update write-only registers */
-		if ((i != R_EB9)  &&
-		    (i != R_EB16) &&
-		    (i != R_EB17) &&
-		    (i != R_EB19) &&
-		    (i != R_EB20))
-		regs[i] = regdump[i];
+		if ((i != R_EB9)  && (i != R_EB16) && (i != R_EB17) &&
+		    (i != R_EB19) && (i != R_EB20))
+			regs[i] = regdump[i];
 	}
 
 	if (tda18271_debug & DBG_REG)
-- 
1.9.3

