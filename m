Return-path: <mchehab@pedra>
Received: from tuur.schedom-europe.net ([193.109.184.94]:49614 "EHLO
	tuur.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab1FAPZ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 11:25:27 -0400
Date: Wed, 1 Jun 2011 17:25:16 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: <linux-media@vger.kernel.org>, Manu Abraham <manu@linuxtv.org>
Subject: [PATCH] stv090x: set status bits when there is no lock
Message-ID: <20110601172516.28a153c8@borg.bxl.tuxicoman.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Currently, the stv090x driver only set the status bits to SCVYL when
there is a lock. This patch set the right bits even if there is no lock.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>

--
 drivers/media/dvb/frontends/stv090x.c |   35 ++++++++++++++------------------
 1 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index 52d8712..ebda419 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -3463,9 +3463,15 @@ static enum dvbfe_search stv090x_search(struct dvb_frontend *fe, struct dvb_fron
 static int stv090x_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct stv090x_state *state = fe->demodulator_priv;
-	u32 reg;
+	u32 reg, dstatus;
 	u8 search_state;
 
+	*status = 0;
+
+	dstatus = STV090x_READ_DEMOD(state, DSTATUS);
+	if (STV090x_GETFIELD_Px(dstatus, CAR_LOCK_FIELD))
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
+
 	reg = STV090x_READ_DEMOD(state, DMDSTATE);
 	search_state = STV090x_GETFIELD_Px(reg, HEADER_MODE_FIELD);
 
@@ -3474,41 +3480,30 @@ static int stv090x_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	case 1: /* first PLH detected */
 	default:
 		dprintk(FE_DEBUG, 1, "Status: Unlocked (Searching ..)");
-		*status = 0;
 		break;
 
 	case 2: /* DVB-S2 mode */
 		dprintk(FE_DEBUG, 1, "Delivery system: DVB-S2");
-		reg = STV090x_READ_DEMOD(state, DSTATUS);
-		if (STV090x_GETFIELD_Px(reg, LOCK_DEFINITIF_FIELD)) {
+		if (STV090x_GETFIELD_Px(dstatus, LOCK_DEFINITIF_FIELD)) {
 			reg = STV090x_READ_DEMOD(state, PDELSTATUS1);
 			if (STV090x_GETFIELD_Px(reg, PKTDELIN_LOCK_FIELD)) {
+				*status |= FE_HAS_VITERBI;
 				reg = STV090x_READ_DEMOD(state, TSSTATUS);
-				if (STV090x_GETFIELD_Px(reg, TSFIFO_LINEOK_FIELD)) {
-					*status = FE_HAS_SIGNAL |
-						  FE_HAS_CARRIER |
-						  FE_HAS_VITERBI |
-						  FE_HAS_SYNC |
-						  FE_HAS_LOCK;
-				}
+				if (STV090x_GETFIELD_Px(reg, TSFIFO_LINEOK_FIELD))
+					*status |= FE_HAS_SYNC | FE_HAS_LOCK;
 			}
 		}
 		break;
 
 	case 3: /* DVB-S1/legacy mode */
 		dprintk(FE_DEBUG, 1, "Delivery system: DVB-S");
-		reg = STV090x_READ_DEMOD(state, DSTATUS);
-		if (STV090x_GETFIELD_Px(reg, LOCK_DEFINITIF_FIELD)) {
+		if (STV090x_GETFIELD_Px(dstatus, LOCK_DEFINITIF_FIELD)) {
 			reg = STV090x_READ_DEMOD(state, VSTATUSVIT);
 			if (STV090x_GETFIELD_Px(reg, LOCKEDVIT_FIELD)) {
+				*status |= FE_HAS_VITERBI;
 				reg = STV090x_READ_DEMOD(state, TSSTATUS);
-				if (STV090x_GETFIELD_Px(reg, TSFIFO_LINEOK_FIELD)) {
-					*status = FE_HAS_SIGNAL |
-						  FE_HAS_CARRIER |
-						  FE_HAS_VITERBI |
-						  FE_HAS_SYNC |
-						  FE_HAS_LOCK;
-				}
+				if (STV090x_GETFIELD_Px(reg, TSFIFO_LINEOK_FIELD))
+					*status |= FE_HAS_SYNC | FE_HAS_LOCK;
 			}
 		}
 		break;
