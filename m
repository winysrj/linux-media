Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4054 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1HYOIq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 06/12] mxl5005s: fix compiler warning
Date: Thu, 25 Aug 2011 16:08:29 +0200
Message-Id: <9b2e10a974dfd7fe47ed6b4364cc6e75a4fe0f70.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
References: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/common/tuners/mxl5005s.c: In function 'MXL_TuneRF':
v4l-dvb-git/drivers/media/common/tuners/mxl5005s.c:2327:6: warning: variable 'Xtal_Int' set but not used [-Wunused-but-set-variable]

Removed the unused Xtal_Int variable. That made it also possible to remove a
related function. However, the code of that function has been preserved in a
comment describing an equation. Without that function that comment would
have been hard to understand.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/tuners/mxl5005s.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
index 56fe75c..54be9e6 100644
--- a/drivers/media/common/tuners/mxl5005s.c
+++ b/drivers/media/common/tuners/mxl5005s.c
@@ -309,7 +309,6 @@ static u16 MXL_ControlWrite_Group(struct dvb_frontend *fe, u16 controlNum,
 static u16 MXL_SetGPIO(struct dvb_frontend *fe, u8 GPIO_Num, u8 GPIO_Val);
 static u16 MXL_GetInitRegister(struct dvb_frontend *fe, u8 *RegNum,
 	u8 *RegVal, int *count);
-static u32 MXL_GetXtalInt(u32 Xtal_Freq);
 static u16 MXL_TuneRF(struct dvb_frontend *fe, u32 RF_Freq);
 static void MXL_SynthIFLO_Calc(struct dvb_frontend *fe);
 static void MXL_SynthRFTGLO_Calc(struct dvb_frontend *fe);
@@ -2307,14 +2306,6 @@ static u16 MXL_IFSynthInit(struct dvb_frontend *fe)
 	return status ;
 }
 
-static u32 MXL_GetXtalInt(u32 Xtal_Freq)
-{
-	if ((Xtal_Freq % 1000000) == 0)
-		return (Xtal_Freq / 10000);
-	else
-		return (((Xtal_Freq / 1000000) + 1)*100);
-}
-
 static u16 MXL_TuneRF(struct dvb_frontend *fe, u32 RF_Freq)
 {
 	struct mxl5005s_state *state = fe->tuner_priv;
@@ -2324,13 +2315,10 @@ static u16 MXL_TuneRF(struct dvb_frontend *fe, u32 RF_Freq)
 	u32 Kdbl_RF = 2;
 	u32 tg_divval;
 	u32 tg_lo;
-	u32 Xtal_Int;
 
 	u32 Fref_TG;
 	u32 Fvco;
 
-	Xtal_Int = MXL_GetXtalInt(state->Fxtal);
-
 	state->RF_IN = RF_Freq;
 
 	MXL_SynthRFTGLO_Calc(fe);
@@ -2779,6 +2767,16 @@ static u16 MXL_TuneRF(struct dvb_frontend *fe, u32 RF_Freq)
 	tg_lo = (((Fmax/10 - Fvco)/100)*32) / ((Fmax-Fmin)/1000)+8;
 
 	/* below equation is same as above but much harder to debug.
+	 *
+	 * static u32 MXL_GetXtalInt(u32 Xtal_Freq)
+	 * {
+	 *	if ((Xtal_Freq % 1000000) == 0)
+	 *		return (Xtal_Freq / 10000);
+	 *	else
+	 *		return (((Xtal_Freq / 1000000) + 1)*100);
+	 * }
+	 *
+	 * u32 Xtal_Int = MXL_GetXtalInt(state->Fxtal);
 	 * tg_lo = ( ((Fmax/10000 * Xtal_Int)/100) -
 	 * ((state->TG_LO/10000)*divider_val *
 	 * (state->Fxtal/10000)/100) )*32/((Fmax-Fmin)/10000 *
-- 
1.7.5.4

