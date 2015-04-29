Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37635 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbbD2XG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:26 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 19/27] stv0900: fix bad indenting
Date: Wed, 29 Apr 2015 20:06:04 -0300
Message-Id: <c3d0b98344cf94833ac99c27c9157b5c535772f7.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/stv0900_sw.c:1559 stv0900_search_srate_fine() warn: inconsistent indenting
drivers/media/dvb-frontends/stv0900_sw.c:2012 stv0900_algo() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/stv0900_sw.c b/drivers/media/dvb-frontends/stv0900_sw.c
index a0a7b1664c53..fa63a9e929ce 100644
--- a/drivers/media/dvb-frontends/stv0900_sw.c
+++ b/drivers/media/dvb-frontends/stv0900_sw.c
@@ -1556,8 +1556,8 @@ static u32 stv0900_search_srate_fine(struct dvb_frontend *fe)
 	}
 
 	symbcomp = 13 * (coarse_srate / 10);
-		coarse_freq = (stv0900_read_reg(intp, CFR2) << 8)
-					| stv0900_read_reg(intp, CFR1);
+	coarse_freq = (stv0900_read_reg(intp, CFR2) << 8)
+		      | stv0900_read_reg(intp, CFR1);
 
 	if (symbcomp < intp->symbol_rate[demod])
 		coarse_srate = 0;
@@ -2009,7 +2009,7 @@ enum fe_stv0900_signal_type stv0900_algo(struct dvb_frontend *fe)
 			signal_type = STV0900_NODATA;
 			no_signal = stv0900_check_signal_presence(intp, demod);
 
-				intp->result[demod].locked = FALSE;
+			intp->result[demod].locked = FALSE;
 		}
 	}
 
-- 
2.1.0

