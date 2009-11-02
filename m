Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60793 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932378AbZKBWv2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 17:51:28 -0500
Message-ID: <4AEF6272.7050602@gmx.de>
Date: Mon, 02 Nov 2009 23:51:30 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 8/9] stv090x: additional check for packet delineator lock
 in stv090x_read_status
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add an additional check for packet delineator lock in stv090x_read_status in case of a tuned DVB-S2 signal.

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>

diff -r 07782fabbff1 linux/drivers/media/dvb/frontends/stv090x.c
--- a/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 23:09:33 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 23:15:41 2009 +0100
@@ -4136,7 +4136,6 @@
 	return DVBFE_ALGO_SEARCH_ERROR;
 }
 
-/* FIXME! */
 static int stv090x_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct stv090x_state *state = fe->demodulator_priv;
@@ -4158,9 +4157,15 @@
 		dprintk(FE_DEBUG, 1, "Delivery system: DVB-S2");
 		reg = STV090x_READ_DEMOD(state, DSTATUS);
 		if (STV090x_GETFIELD_Px(reg, LOCK_DEFINITIF_FIELD)) {
-			reg = STV090x_READ_DEMOD(state, TSSTATUS);
-			if (STV090x_GETFIELD_Px(reg, TSFIFO_LINEOK_FIELD)) {
-				*status = FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+			reg = STV090x_READ_DEMOD(state, PDELSTATUS1);
+			if (STV090x_GETFIELD_Px(reg, PKTDELIN_LOCK_FIELD)) {
+				reg = STV090x_READ_DEMOD(state, TSSTATUS);
+				if (STV090x_GETFIELD_Px(reg, TSFIFO_LINEOK_FIELD)) {
+					*status = FE_HAS_CARRIER |
+						  FE_HAS_VITERBI |
+						  FE_HAS_SYNC |
+						  FE_HAS_LOCK;
+				}
 			}
 		}
 		break;
