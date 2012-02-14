Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:28282 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761251Ab2BNVs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:28 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 12/22] mt2063: remove LockStatus
Date: Tue, 14 Feb 2012 22:47:36 +0100
Message-Id: <1329256066-8844-12-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |   36 ----------------------------------
 1 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 24c2c93..8cc58a1 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -179,46 +179,10 @@ static int mt2063_set_mode(struct mt2063_state *state, enum mt2063_delsys Mode)
 	 *
 	 *
 	 */
-/**
- * mt2063_lockStatus - Checks to see if LO1 and LO2 are locked
- *
- * @state:	struct mt2063_state pointer
- *
- * This function returns 0, if no lock, 1 if locked and a value < 1 if error
- */
-static unsigned int mt2063_lockStatus(struct mt2063_state *state)
-{
-	const u32 nMaxWait = 100;	/*  wait a maximum of 100 msec   */
-	const u32 nPollRate = 2;	/*  poll status bits every 2 ms */
-	const u32 nMaxLoops = nMaxWait / nPollRate;
-	const u8 LO1LK = 0x80;
-	u8 LO2LK = 0x08;
-	u32 status;
-	u32 nDelays = 0;
-
-	dprintk(2, "\n");
-
-	/*  LO2 Lock bit was in a different place for B0 version  */
-	if (state->tuner_id == MT2063_B0)
-		LO2LK = 0x40;
 
 	do {
-		status = mt2063_read(state, MT2063_REG_LO_STATUS,
-				     &state->reg[MT2063_REG_LO_STATUS], 1);
-
-		if (status < 0)
-			return status;
-
-		if ((state->reg[MT2063_REG_LO_STATUS] & (LO1LK | LO2LK)) ==
-		    (LO1LK | LO2LK)) {
-			return TUNER_STATUS_LOCKED | TUNER_STATUS_STEREO;
 		}
-		msleep(nPollRate);	/*  Wait between retries  */
-	} while (++nDelays < nMaxLoops);
 
-	/*
-	 * Got no lock or partial lock
-	 */
 	return 0;
 }
 
-- 
1.7.7.6

