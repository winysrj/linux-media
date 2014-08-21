Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4516 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaHUUTw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:19:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/12] mt2063: fix sparse warnings
Date: Thu, 21 Aug 2014 22:19:25 +0200
Message-Id: <1408652376-39525-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
References: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/tuners/mt2063.c:1238:56: warning: cast truncates bits from constant value (ffffff0f becomes f)
drivers/media/tuners/mt2063.c:1313:62: warning: cast truncates bits from constant value (ffffff7f becomes 7f)
drivers/media/tuners/mt2063.c:1321:62: warning: cast truncates bits from constant value (ffffff7f becomes 7f)

Cast to u8 is unnecessary.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/tuners/mt2063.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index f640dcf..9e9c5eb 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -1216,7 +1216,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 	if (status >= 0) {
 		val =
 		    (state->
-		     reg[MT2063_REG_PD1_TGT] & (u8) ~0x40) | (RFAGCEN[Mode]
+		     reg[MT2063_REG_PD1_TGT] & ~0x40) | (RFAGCEN[Mode]
 								   ? 0x40 :
 								   0x00);
 		if (state->reg[MT2063_REG_PD1_TGT] != val)
@@ -1225,7 +1225,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* LNARin */
 	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_CTRL_2C] & (u8) ~0x03) |
+		u8 val = (state->reg[MT2063_REG_CTRL_2C] & ~0x03) |
 			 (LNARIN[Mode] & 0x03);
 		if (state->reg[MT2063_REG_CTRL_2C] != val)
 			status |= mt2063_setreg(state, MT2063_REG_CTRL_2C, val);
@@ -1235,19 +1235,19 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 	if (status >= 0) {
 		val =
 		    (state->
-		     reg[MT2063_REG_FIFF_CTRL2] & (u8) ~0xF0) |
+		     reg[MT2063_REG_FIFF_CTRL2] & ~0xF0) |
 		    (FIFFQEN[Mode] << 7) | (FIFFQ[Mode] << 4);
 		if (state->reg[MT2063_REG_FIFF_CTRL2] != val) {
 			status |=
 			    mt2063_setreg(state, MT2063_REG_FIFF_CTRL2, val);
 			/* trigger FIFF calibration, needed after changing FIFFQ */
 			val =
-			    (state->reg[MT2063_REG_FIFF_CTRL] | (u8) 0x01);
+			    (state->reg[MT2063_REG_FIFF_CTRL] | 0x01);
 			status |=
 			    mt2063_setreg(state, MT2063_REG_FIFF_CTRL, val);
 			val =
 			    (state->
-			     reg[MT2063_REG_FIFF_CTRL] & (u8) ~0x01);
+			     reg[MT2063_REG_FIFF_CTRL] & ~0x01);
 			status |=
 			    mt2063_setreg(state, MT2063_REG_FIFF_CTRL, val);
 		}
@@ -1259,7 +1259,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* acLNAmax */
 	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_LNA_OV] & (u8) ~0x1F) |
+		u8 val = (state->reg[MT2063_REG_LNA_OV] & ~0x1F) |
 			 (ACLNAMAX[Mode] & 0x1F);
 		if (state->reg[MT2063_REG_LNA_OV] != val)
 			status |= mt2063_setreg(state, MT2063_REG_LNA_OV, val);
@@ -1267,7 +1267,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* LNATGT */
 	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_LNA_TGT] & (u8) ~0x3F) |
+		u8 val = (state->reg[MT2063_REG_LNA_TGT] & ~0x3F) |
 			 (LNATGT[Mode] & 0x3F);
 		if (state->reg[MT2063_REG_LNA_TGT] != val)
 			status |= mt2063_setreg(state, MT2063_REG_LNA_TGT, val);
@@ -1275,7 +1275,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* ACRF */
 	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_RF_OV] & (u8) ~0x1F) |
+		u8 val = (state->reg[MT2063_REG_RF_OV] & ~0x1F) |
 			 (ACRFMAX[Mode] & 0x1F);
 		if (state->reg[MT2063_REG_RF_OV] != val)
 			status |= mt2063_setreg(state, MT2063_REG_RF_OV, val);
@@ -1283,7 +1283,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* PD1TGT */
 	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_PD1_TGT] & (u8) ~0x3F) |
+		u8 val = (state->reg[MT2063_REG_PD1_TGT] & ~0x3F) |
 			 (PD1TGT[Mode] & 0x3F);
 		if (state->reg[MT2063_REG_PD1_TGT] != val)
 			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
@@ -1294,7 +1294,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		u8 val = ACFIFMAX[Mode];
 		if (state->reg[MT2063_REG_PART_REV] != MT2063_B3 && val > 5)
 			val = 5;
-		val = (state->reg[MT2063_REG_FIF_OV] & (u8) ~0x1F) |
+		val = (state->reg[MT2063_REG_FIF_OV] & ~0x1F) |
 		      (val & 0x1F);
 		if (state->reg[MT2063_REG_FIF_OV] != val)
 			status |= mt2063_setreg(state, MT2063_REG_FIF_OV, val);
@@ -1302,7 +1302,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* PD2TGT */
 	if (status >= 0) {
-		u8 val = (state->reg[MT2063_REG_PD2_TGT] & (u8) ~0x3F) |
+		u8 val = (state->reg[MT2063_REG_PD2_TGT] & ~0x3F) |
 		    (PD2TGT[Mode] & 0x3F);
 		if (state->reg[MT2063_REG_PD2_TGT] != val)
 			status |= mt2063_setreg(state, MT2063_REG_PD2_TGT, val);
@@ -1310,7 +1310,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* Ignore ATN Overload */
 	if (status >= 0) {
-		val = (state->reg[MT2063_REG_LNA_TGT] & (u8) ~0x80) |
+		val = (state->reg[MT2063_REG_LNA_TGT] & ~0x80) |
 		      (RFOVDIS[Mode] ? 0x80 : 0x00);
 		if (state->reg[MT2063_REG_LNA_TGT] != val)
 			status |= mt2063_setreg(state, MT2063_REG_LNA_TGT, val);
@@ -1318,7 +1318,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* Ignore FIF Overload */
 	if (status >= 0) {
-		val = (state->reg[MT2063_REG_PD1_TGT] & (u8) ~0x80) |
+		val = (state->reg[MT2063_REG_PD1_TGT] & ~0x80) |
 		      (FIFOVDIS[Mode] ? 0x80 : 0x00);
 		if (state->reg[MT2063_REG_PD1_TGT] != val)
 			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
-- 
2.1.0.rc1

