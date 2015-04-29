Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbD2XGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 20/27] s5h1420: use only one statement per line
Date: Wed, 29 Apr 2015 20:06:05 -0300
Message-Id: <1ebaf10c6c244fa49d3577683167c13019a93140.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/s5h1420.c:565 s5h1420_setfec_inversion() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
index 0b4f8fe6bf99..dfc20665e372 100644
--- a/drivers/media/dvb-frontends/s5h1420.c
+++ b/drivers/media/dvb-frontends/s5h1420.c
@@ -561,27 +561,33 @@ static void s5h1420_setfec_inversion(struct s5h1420_state* state,
 	} else {
 		switch (p->fec_inner) {
 		case FEC_1_2:
-			vit08 = 0x01; vit09 = 0x10;
+			vit08 = 0x01;
+			vit09 = 0x10;
 			break;
 
 		case FEC_2_3:
-			vit08 = 0x02; vit09 = 0x11;
+			vit08 = 0x02;
+			vit09 = 0x11;
 			break;
 
 		case FEC_3_4:
-			vit08 = 0x04; vit09 = 0x12;
+			vit08 = 0x04;
+			vit09 = 0x12;
 			break;
 
 		case FEC_5_6:
-			vit08 = 0x08; vit09 = 0x13;
+			vit08 = 0x08;
+			vit09 = 0x13;
 			break;
 
 		case FEC_6_7:
-			vit08 = 0x10; vit09 = 0x14;
+			vit08 = 0x10;
+			vit09 = 0x14;
 			break;
 
 		case FEC_7_8:
-			vit08 = 0x20; vit09 = 0x15;
+			vit08 = 0x20;
+			vit09 = 0x15;
 			break;
 
 		default:
-- 
2.1.0

