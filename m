Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbaICUda (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:30 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/46] [media] stv0900_core: don't allocate a temporary var
Date: Wed,  3 Sep 2014 17:32:40 -0300
Message-Id: <dde99cb081475312af183688405bf061a0c41612.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The error return code STV0900_NO_ERROR happens only once, at
the end of the functions. So, just return it directly.

This driver should actually be fixed to return standard
Linux error codes, instead of its own macros, but this
should be done on a separate patchset.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index e5a87b57d855..2c88abfab531 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -1270,7 +1270,6 @@ enum fe_stv0900_error stv0900_st_dvbs2_single(struct stv0900_internal *intp,
 					enum fe_stv0900_demod_mode LDPC_Mode,
 					enum fe_stv0900_demod_num demod)
 {
-	enum fe_stv0900_error error = STV0900_NO_ERROR;
 	s32 reg_ind;
 
 	dprintk("%s\n", __func__);
@@ -1337,7 +1336,7 @@ enum fe_stv0900_error stv0900_st_dvbs2_single(struct stv0900_internal *intp,
 		break;
 	}
 
-	return error;
+	return STV0900_NO_ERROR;
 }
 
 static enum fe_stv0900_error stv0900_init_internal(struct dvb_frontend *fe,
@@ -1555,8 +1554,6 @@ static int stv0900_status(struct stv0900_internal *intp,
 static int stv0900_set_mis(struct stv0900_internal *intp,
 				enum fe_stv0900_demod_num demod, int mis)
 {
-	enum fe_stv0900_error error = STV0900_NO_ERROR;
-
 	dprintk("%s\n", __func__);
 
 	if (mis < 0 || mis > 255) {
@@ -1569,7 +1566,7 @@ static int stv0900_set_mis(struct stv0900_internal *intp,
 		stv0900_write_reg(intp, ISIBITENA, 0xff);
 	}
 
-	return error;
+	return STV0900_NO_ERROR;
 }
 
 
-- 
1.9.3

