Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41128 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbeCIPxn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:53:43 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 10/11] media: lgdt330x: get rid of read_ber stub
Date: Fri,  9 Mar 2018 12:53:35 -0300
Message-Id: <b32e241402ea14a75b9797396d29b75b6e385dd5.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This routine does nothing. Remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt330x.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index 75b9ae6583e8..b430b0500f12 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -300,12 +300,6 @@ static int lgdt330x_init(struct dvb_frontend *fe)
 	return lgdt330x_sw_reset(state);
 }
 
-static int lgdt330x_read_ber(struct dvb_frontend *fe, u32 *ber)
-{
-	*ber = 0; /* Not supplied by the demod chips */
-	return 0;
-}
-
 static int lgdt330x_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct lgdt330x_state *state = fe->demodulator_priv;
@@ -909,7 +903,6 @@ static const struct dvb_frontend_ops lgdt3302_ops = {
 	.get_frontend         = lgdt330x_get_frontend,
 	.get_tune_settings    = lgdt330x_get_tune_settings,
 	.read_status          = lgdt3302_read_status,
-	.read_ber             = lgdt330x_read_ber,
 	.read_signal_strength = lgdt330x_read_signal_strength,
 	.read_snr             = lgdt330x_read_snr,
 	.read_ucblocks        = lgdt330x_read_ucblocks,
@@ -932,7 +925,6 @@ static const struct dvb_frontend_ops lgdt3303_ops = {
 	.get_frontend         = lgdt330x_get_frontend,
 	.get_tune_settings    = lgdt330x_get_tune_settings,
 	.read_status          = lgdt3303_read_status,
-	.read_ber             = lgdt330x_read_ber,
 	.read_signal_strength = lgdt330x_read_signal_strength,
 	.read_snr             = lgdt330x_read_snr,
 	.read_ucblocks        = lgdt330x_read_ucblocks,
-- 
2.14.3
