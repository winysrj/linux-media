Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:28208 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab2BNVsY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:24 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 06/22] mt2063: remove remove up + down converter
Date: Tue, 14 Feb 2012 22:47:30 +0100
Message-Id: <1329256066-8844-6-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |  161 ----------------------------------
 1 files changed, 0 insertions(+), 161 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index ee59ebe..31cb636 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -40,20 +40,6 @@ static LIST_HEAD(hybrid_tuner_instance_list);
  * 1 called functions without i2c comunications
  * 2 additional calculating, result etc.
  * 3 maximum debug information
-
-/*  Info: Upconverter frequency is out of range (may be reason for MT_UPC_UNLOCK) */
-#define MT2063_UPC_RANGE                    (0x04000000)
-
-/*  Info: Downconverter frequency is out of range (may be reason for MT_DPC_UNLOCK) */
-#define MT2063_DNC_RANGE                    (0x08000000)
-
-/*
- *  Constant defining the version of the following structure
- *  and therefore the API for this code.
- *
- *  When compiling the tuner driver, the preprocessor will
- *  check against this version number to make sure that
- *  it matches the version that the tuner driver knows about.
  */
 #define dprintk(level, fmt, arg...) do {			\
 if (debug >= level)						\
@@ -83,16 +69,6 @@ enum MT2063_Mask_Bits {
 };
 
 /*
- *  Possible values for MT2063_DNC_OUTPUT
- */
-enum MT2063_DNC_Output_Enable {
-	MT2063_DNC_NONE = 0,
-	MT2063_DNC_1,
-	MT2063_DNC_2,
-	MT2063_DNC_BOTH
-};
-
-/*
  *  Two-wire serial bus subaddresses of the tuner registers.
  *  Also known as the tuner's register addresses.
  */
@@ -469,152 +445,15 @@ static const u8 FIFOVDIS[]	= {  0,  0,  0,  0,  0,  0 };
 static const u8 ACFIFMAX[]	= { 29, 29, 29, 29, 29, 29 };
 static const u8 PD2TGT[]	= { 40, 33, 38, 42, 30, 38 };
 
-/*
- * mt2063_set_dnc_output_enable()
- */
-static u32 mt2063_get_dnc_output_enable(struct mt2063_state *state,
-					enum MT2063_DNC_Output_Enable *pValue)
-{
-	dprintk(2, "\n");
-
-	if ((state->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
-		if ((state->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
-			*pValue = MT2063_DNC_NONE;
-		else
-			*pValue = MT2063_DNC_2;
-	} else {	/* DNC1 is on */
-		if ((state->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
-			*pValue = MT2063_DNC_1;
-		else
-			*pValue = MT2063_DNC_BOTH;
-	}
-	return 0;
-}
-
-/*
- * mt2063_set_dnc_output_enable()
- */
-static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
-					enum MT2063_DNC_Output_Enable nValue)
 {
-	u32 status = 0;	/* Status to be returned        */
-	u8 val = 0;
 
-	dprintk(2, "\n");
 
-	/* selects, which DNC output is used */
-	switch (nValue) {
-	case MT2063_DNC_NONE:
-		val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
-		if (state->reg[MT2063_REG_DNC_GAIN] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_DNC_GAIN,
-					  val);
 
-		val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
-		if (state->reg[MT2063_REG_VGA_GAIN] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_VGA_GAIN,
-					  val);
 
-		val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
-		if (state->reg[MT2063_REG_RSVD_20] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_RSVD_20,
-					  val);
 
 		break;
-	case MT2063_DNC_1:
-		val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
-		if (state->reg[MT2063_REG_DNC_GAIN] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_DNC_GAIN,
-					  val);
-
-		val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | 0x03;	/* Set DNC2GC=3 */
-		if (state->reg[MT2063_REG_VGA_GAIN] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_VGA_GAIN,
-					  val);
-
-		val = (state->reg[MT2063_REG_RSVD_20] & ~0x40);	/* Set PD2MUX=0 */
-		if (state->reg[MT2063_REG_RSVD_20] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_RSVD_20,
-					  val);
-
-		break;
-	case MT2063_DNC_2:
-		val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
-		if (state->reg[MT2063_REG_DNC_GAIN] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_DNC_GAIN,
-					  val);
-
-		val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
-		if (state->reg[MT2063_REG_VGA_GAIN] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_VGA_GAIN,
-					  val);
-
-		val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
-		if (state->reg[MT2063_REG_RSVD_20] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_RSVD_20,
-					  val);
-
-		break;
-	case MT2063_DNC_BOTH:
-		val = (state->reg[MT2063_REG_DNC_GAIN] & 0xFC) | (DNC1GC[state->rcvr_mode] & 0x03);	/* Set DNC1GC=x */
-		if (state->reg[MT2063_REG_DNC_GAIN] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_DNC_GAIN,
-					  val);
-
-		val = (state->reg[MT2063_REG_VGA_GAIN] & 0xFC) | (DNC2GC[state->rcvr_mode] & 0x03);	/* Set DNC2GC=x */
-		if (state->reg[MT2063_REG_VGA_GAIN] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_VGA_GAIN,
-					  val);
-
-		val = (state->reg[MT2063_REG_RSVD_20] | 0x40);	/* Set PD2MUX=1 */
-		if (state->reg[MT2063_REG_RSVD_20] !=
-		    val)
-			status |=
-			    mt2063_setreg(state,
-					  MT2063_REG_RSVD_20,
-					  val);
-
 		break;
 	default:
-		break;
-	}
-
-	return status;
-}
-
 /*
  * MT2063_SetReceiverMode() - Set the MT2063 receiver mode, according with
  * 			      the selected enum mt2063_delivery_sys type.
-- 
1.7.7.6

