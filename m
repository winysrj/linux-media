Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50213 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166Ab3EHUt1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 May 2013 16:49:27 -0400
Received: from mailout-de.gmx.net ([10.1.76.10]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Lg2yr-1UBVfR3Vgh-00pbYV for
 <linux-media@vger.kernel.org>; Wed, 08 May 2013 22:49:26 +0200
From: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
Subject: [PATCH] stb0899: enable auto inversion handling unconditionally
Date: Wed,  8 May 2013 22:49:19 +0200
Message-Id: <1368046159-18019-1-git-send-email-rnissl@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that current inversion handling addresses only the signal
routing on the PCB, i. e. IQ signals are either swapped or not.
But when the device is operated in a Satellite Channel Router (SCR)
environment, an additional inversion is required due to the way how
the SCR works. Therefore it makes sense to me to always enable auto
inversion handling and drop the enum value IQ_SWAP_AUTO.

Signed-off-by: Reinhard Nißl <rnissl@gmx.de>
---
 drivers/media/dvb-frontends/stb0899_algo.c | 63 ++++++++++++++----------------
 drivers/media/dvb-frontends/stb0899_drv.h  |  1 -
 2 files changed, 29 insertions(+), 35 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_algo.c b/drivers/media/dvb-frontends/stb0899_algo.c
index bd9dbd7..14d720b 100644
--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -1373,9 +1373,6 @@ enum stb0899_status stb0899_dvbs2_algo(struct stb0899_state *state)
 	case IQ_SWAP_ON:
 		STB0899_SETFIELD_VAL(SPECTRUM_INVERT, reg, 1);
 		break;
-	case IQ_SWAP_AUTO:	/* use last successful search first	*/
-		STB0899_SETFIELD_VAL(SPECTRUM_INVERT, reg, 1);
-		break;
 	}
 	stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_DMD_CNTRL2, STB0899_OFF0_DMD_CNTRL2, reg);
 	stb0899_dvbs2_reacquire(state);
@@ -1405,41 +1402,39 @@ enum stb0899_status stb0899_dvbs2_algo(struct stb0899_state *state)
 	}
 
 	if (internal->status != DVBS2_FEC_LOCK) {
-		if (internal->inversion == IQ_SWAP_AUTO) {
-			reg = STB0899_READ_S2REG(STB0899_S2DEMOD, DMD_CNTRL2);
-			iqSpectrum = STB0899_GETFIELD(SPECTRUM_INVERT, reg);
-			/* IQ Spectrum Inversion	*/
-			STB0899_SETFIELD_VAL(SPECTRUM_INVERT, reg, !iqSpectrum);
-			stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_DMD_CNTRL2, STB0899_OFF0_DMD_CNTRL2, reg);
-			/* start acquistion process	*/
-			stb0899_dvbs2_reacquire(state);
+		reg = STB0899_READ_S2REG(STB0899_S2DEMOD, DMD_CNTRL2);
+		iqSpectrum = STB0899_GETFIELD(SPECTRUM_INVERT, reg);
+		/* IQ Spectrum Inversion	*/
+		STB0899_SETFIELD_VAL(SPECTRUM_INVERT, reg, !iqSpectrum);
+		stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_DMD_CNTRL2, STB0899_OFF0_DMD_CNTRL2, reg);
+		/* start acquistion process	*/
+		stb0899_dvbs2_reacquire(state);
+
+		/* Wait for demod lock (UWP and CSM)	*/
+		internal->status = stb0899_dvbs2_get_dmd_status(state, searchTime);
+		if (internal->status == DVBS2_DEMOD_LOCK) {
+			i = 0;
+			/* Demod Locked, check FEC	*/
+			internal->status = stb0899_dvbs2_get_fec_status(state, FecLockTime);
+			/*try thrice for false locks, (UWP and CSM Locked but no FEC)	*/
+			while ((internal->status != DVBS2_FEC_LOCK) && (i < 3)) {
+				/*	Read the frequency offset*/
+				offsetfreq = STB0899_READ_S2REG(STB0899_S2DEMOD, CRL_FREQ);
 
-			/* Wait for demod lock (UWP and CSM)	*/
-			internal->status = stb0899_dvbs2_get_dmd_status(state, searchTime);
-			if (internal->status == DVBS2_DEMOD_LOCK) {
-				i = 0;
-				/* Demod Locked, check FEC	*/
-				internal->status = stb0899_dvbs2_get_fec_status(state, FecLockTime);
-				/*try thrice for false locks, (UWP and CSM Locked but no FEC)	*/
-				while ((internal->status != DVBS2_FEC_LOCK) && (i < 3)) {
-					/*	Read the frequency offset*/
-					offsetfreq = STB0899_READ_S2REG(STB0899_S2DEMOD, CRL_FREQ);
-
-					/* Set the Nominal frequency to the found frequency offset for the next reacquire*/
-					reg = STB0899_READ_S2REG(STB0899_S2DEMOD, CRL_NOM_FREQ);
-					STB0899_SETFIELD_VAL(CRL_NOM_FREQ, reg, offsetfreq);
-					stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_CRL_NOM_FREQ, STB0899_OFF0_CRL_NOM_FREQ, reg);
-
-					stb0899_dvbs2_reacquire(state);
-					internal->status = stb0899_dvbs2_get_fec_status(state, searchTime);
-					i++;
-				}
+				/* Set the Nominal frequency to the found frequency offset for the next reacquire*/
+				reg = STB0899_READ_S2REG(STB0899_S2DEMOD, CRL_NOM_FREQ);
+				STB0899_SETFIELD_VAL(CRL_NOM_FREQ, reg, offsetfreq);
+				stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_CRL_NOM_FREQ, STB0899_OFF0_CRL_NOM_FREQ, reg);
+
+				stb0899_dvbs2_reacquire(state);
+				internal->status = stb0899_dvbs2_get_fec_status(state, searchTime);
+				i++;
 			}
+		}
 /*
-			if (pParams->DVBS2State == FE_DVBS2_FEC_LOCKED)
-				pParams->IQLocked = !iqSpectrum;
+		if (pParams->DVBS2State == FE_DVBS2_FEC_LOCKED)
+			pParams->IQLocked = !iqSpectrum;
 */
-		}
 	}
 	if (internal->status == DVBS2_FEC_LOCK) {
 		dprintk(state->verbose, FE_DEBUG, 1, "----------------> DVB-S2 FEC Lock !");
diff --git a/drivers/media/dvb-frontends/stb0899_drv.h b/drivers/media/dvb-frontends/stb0899_drv.h
index 8d26ff6..1ddad6a 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.h
+++ b/drivers/media/dvb-frontends/stb0899_drv.h
@@ -47,7 +47,6 @@ struct stb0899_s2_reg {
 enum stb0899_inversion {
 	IQ_SWAP_OFF	= 0,
 	IQ_SWAP_ON,
-	IQ_SWAP_AUTO
 };
 
 #define STB0899_GPIO00				0xf140
-- 
1.8.1.4

