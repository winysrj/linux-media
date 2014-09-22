Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbaIVUy5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 16:54:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Maks Naumov <maksqwe1@ukr.net>,
	Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 1/2] [media] stv0367: Remove an unused parameter
Date: Mon, 22 Sep 2014 17:54:28 -0300
Message-Id: <886da6ac33ac7e82392f1bc8b7b25b058710a269.1411419252.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cab_state->modulation is initialized with a wrong value:

drivers/media/dvb-frontends/stv0367.c:3000:42: warning: mixing different enum types
drivers/media/dvb-frontends/stv0367.c:3000:42:     int enum fe_modulation  versus
drivers/media/dvb-frontends/stv0367.c:3000:42:     int enum stv0367cab_mod

as it was declared as "enum stv0367cab_mod". While it could be fixed,
there's no value on it, as this is never used.

So, just remove the modulation from cab_state structure.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 7f010683dbf8..b31ff265ff24 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -59,7 +59,6 @@ struct stv0367cab_state {
 	int locked;			/* channel found		*/
 	u32 freq_khz;			/* found frequency (in kHz)	*/
 	u32 symbol_rate;		/* found symbol rate (in Bds)	*/
-	enum stv0367cab_mod modulation;	/* modulation			*/
 	fe_spectral_inversion_t	spect_inv; /* Spectrum Inversion	*/
 };
 
@@ -2997,7 +2996,6 @@ enum stv0367_cab_signal_type stv0367cab_algo(struct stv0367_state *state,
 
 	if (QAMFEC_Lock) {
 		signalType = FE_CAB_DATAOK;
-		cab_state->modulation = p->modulation;
 		cab_state->spect_inv = stv0367_readbits(state,
 							F367CAB_QUAD_INV);
 #if 0
-- 
1.9.3

