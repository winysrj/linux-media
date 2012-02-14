Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:28207 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab2BNVsY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:24 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 10/22] mt2063: new set_mode
Date: Tue, 14 Feb 2012 22:47:34 +0100
Message-Id: <1329256066-8844-10-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |  161 +++++-----------------------------
 1 files changed, 23 insertions(+), 138 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index ac8a0dc..dfa2e28 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -136,16 +136,39 @@ static void mt2063_shutdown(struct mt2063_state *state,
 	}
 }
 
+static int mt2063_set_mode(struct mt2063_state *state, enum mt2063_delsys Mode)
 {
+	dprintk(1, "\n");
 
+	/* check, if mode outside */
+	if (Mode > 5)
+		return -EINVAL;
 
+	/* set LNA R in (75 Ohm ??) */
+	mt2063_set_reg_mask(state, MT2063_REG_CTRL_2C, LNARIN[Mode], 0x03);
 
+	/* set LNA Target */
+	mt2063_set_reg_mask(state, MT2063_REG_LNA_TGT, LNATGT[Mode], 0x3f);
 
+	/* PD1 Target */
+	mt2063_set_reg_mask(state, MT2063_REG_PD1_TGT, PD1TGT[Mode], 0x3f);
 
+	/* PD2 Target */
+	mt2063_set_reg_mask(state, MT2063_REG_PD2_TGT, PD2TGT[Mode], 0x3f);
 
+	/* Ignore ATN Overload */
+	if (RFOVDIS[Mode])
+		mt2063_set_reg_mask(state, MT2063_REG_LNA_TGT, 0x80, 0x80);
 	else
+		mt2063_set_reg_mask(state, MT2063_REG_LNA_TGT, 0x00, 0x80);
 
+	/* Ignore FIF Overload */
+	if (FIFOVDIS[Mode])
+		mt2063_set_reg_mask(state, MT2063_REG_PD1_TGT, 0x80, 0x80);
+	else
+		mt2063_set_reg_mask(state, MT2063_REG_PD1_TGT, 0x00, 0x80);
 
+	dprintk(1, "mode changed to %s\n", mt2063_mode_name[Mode]);
 	return 0;
 }
 
@@ -208,147 +231,9 @@ static unsigned int mt2063_lockStatus(struct mt2063_state *state)
 		break;
 		break;
 	default:
-/*
- * MT2063_SetReceiverMode() - Set the MT2063 receiver mode, according with
- * 			      the selected enum mt2063_delivery_sys type.
- *
- *  (DNC1GC & DNC2GC are the values, which are used, when the specific
- *   DNC Output is selected, the other is always off)
- *
- * @state:	ptr to mt2063_state structure
- * @Mode:	desired reciever delivery system
- *
- * Note: Register cache must be valid for it to work
- */
-
-static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
-				  enum mt2063_delivery_sys Mode)
-{
-	u32 status = 0;	/* Status to be returned        */
-	u8 val;
-	u32 longval;
-
-	dprintk(2, "\n");
-
-	if (Mode >= MT2063_NUM_RCVR_MODES)
-		status = -ERANGE;
-
-	/* RFAGCen */
-	if (status >= 0) {
-		val =
-		    (state->
-		     reg[MT2063_REG_PD1_TGT] & (u8) ~0x40) | (RFAGCEN[Mode]
-								   ? 0x40 :
-								   0x00);
-		if (state->reg[MT2063_REG_PD1_TGT] != val)
-			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
-	}
-
-	/* LNARin */
-	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_CTRL_2C] & (u8) ~0x03) |
-			 (LNARIN[Mode] & 0x03);
-		if (state->reg[MT2063_REG_CTRL_2C] != val)
-			status |= mt2063_setreg(state, MT2063_REG_CTRL_2C, val);
-	}
-
-	/* FIFFQEN and FIFFQ */
-	if (status >= 0) {
-		val =
-		    (state->
-		     reg[MT2063_REG_FIFF_CTRL2] & (u8) ~0xF0) |
-		    (FIFFQEN[Mode] << 7) | (FIFFQ[Mode] << 4);
-		if (state->reg[MT2063_REG_FIFF_CTRL2] != val) {
-			status |=
-			    mt2063_setreg(state, MT2063_REG_FIFF_CTRL2, val);
-			/* trigger FIFF calibration, needed after changing FIFFQ */
-			val =
-			    (state->reg[MT2063_REG_FIFF_CTRL] | (u8) 0x01);
-			status |=
-			    mt2063_setreg(state, MT2063_REG_FIFF_CTRL, val);
-			val =
-			    (state->
-			     reg[MT2063_REG_FIFF_CTRL] & (u8) ~0x01);
-			status |=
-			    mt2063_setreg(state, MT2063_REG_FIFF_CTRL, val);
-		}
-	}
-
-	/* acLNAmax */
-	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_LNA_OV] & (u8) ~0x1F) |
-			 (ACLNAMAX[Mode] & 0x1F);
-		if (state->reg[MT2063_REG_LNA_OV] != val)
-			status |= mt2063_setreg(state, MT2063_REG_LNA_OV, val);
-	}
-
-	/* LNATGT */
-	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_LNA_TGT] & (u8) ~0x3F) |
-			 (LNATGT[Mode] & 0x3F);
-		if (state->reg[MT2063_REG_LNA_TGT] != val)
-			status |= mt2063_setreg(state, MT2063_REG_LNA_TGT, val);
 	}
 
-	/* ACRF */
-	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_RF_OV] & (u8) ~0x1F) |
-			 (ACRFMAX[Mode] & 0x1F);
-		if (state->reg[MT2063_REG_RF_OV] != val)
-			status |= mt2063_setreg(state, MT2063_REG_RF_OV, val);
-	}
 
-	/* PD1TGT */
-	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_PD1_TGT] & (u8) ~0x3F) |
-			 (PD1TGT[Mode] & 0x3F);
-		if (state->reg[MT2063_REG_PD1_TGT] != val)
-			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
-	}
-
-	/* FIFATN */
-	if (status >= 0) {
-		u8 val = ACFIFMAX[Mode];
-		if (state->reg[MT2063_REG_PART_REV] != MT2063_B3 && val > 5)
-			val = 5;
-		val = (state->reg[MT2063_REG_FIF_OV] & (u8) ~0x1F) |
-		      (val & 0x1F);
-		if (state->reg[MT2063_REG_FIF_OV] != val)
-			status |= mt2063_setreg(state, MT2063_REG_FIF_OV, val);
-	}
-
-	/* PD2TGT */
-	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_PD2_TGT] & (u8) ~0x3F) |
-		    (PD2TGT[Mode] & 0x3F);
-		if (state->reg[MT2063_REG_PD2_TGT] != val)
-			status |= mt2063_setreg(state, MT2063_REG_PD2_TGT, val);
-	}
-
-	/* Ignore ATN Overload */
-	if (status >= 0) {
-		val = (state->reg[MT2063_REG_LNA_TGT] & (u8) ~0x80) |
-		      (RFOVDIS[Mode] ? 0x80 : 0x00);
-		if (state->reg[MT2063_REG_LNA_TGT] != val)
-			status |= mt2063_setreg(state, MT2063_REG_LNA_TGT, val);
-	}
-
-	/* Ignore FIF Overload */
-	if (status >= 0) {
-		val = (state->reg[MT2063_REG_PD1_TGT] & (u8) ~0x80) |
-		      (FIFOVDIS[Mode] ? 0x80 : 0x00);
-		if (state->reg[MT2063_REG_PD1_TGT] != val)
-			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
-	}
-
-	if (status >= 0) {
-		state->rcvr_mode = Mode;
-		dprintk(1, "mt2063 mode changed to %s\n",
-			mt2063_mode_name[state->rcvr_mode]);
-	}
-
-	return status;
-}
 
 
 
-- 
1.7.7.6

