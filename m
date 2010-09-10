Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:42125 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab0IJNgo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 09:36:44 -0400
Date: Fri, 10 Sep 2010 15:36:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 5/5] cx22702: Simplify cx22702_set_tps()
Message-ID: <20100910153637.183d366a@hyperion.delvare>
In-Reply-To: <20100910151943.103f7423@hyperion.delvare>
References: <20100910151943.103f7423@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Code in function cx22702_set_tps() can be slightly simplified.
Apparently gcc was smart enough to optimize it anyway, but it can't
hurt to make the code more readable.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Steven Toth <stoth@kernellabs.com>
---
 drivers/media/dvb/frontends/cx22702.c |   58 ++++++++++++++-------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

--- linux-2.6.32-rc5.orig/drivers/media/dvb/frontends/cx22702.c	2009-10-17 14:50:42.000000000 +0200
+++ linux-2.6.32-rc5/drivers/media/dvb/frontends/cx22702.c	2009-10-17 16:12:39.000000000 +0200
@@ -316,33 +316,31 @@ static int cx22702_set_tps(struct dvb_fr
 	}
 
 	/* manually programmed values */
-	val = 0;
-	switch (p->u.ofdm.constellation) {
+	switch (p->u.ofdm.constellation) {		/* mask 0x18 */
 	case QPSK:
-		val = (val & 0xe7);
+		val = 0x00;
 		break;
 	case QAM_16:
-		val = (val & 0xe7) | 0x08;
+		val = 0x08;
 		break;
 	case QAM_64:
-		val = (val & 0xe7) | 0x10;
+		val = 0x10;
 		break;
 	default:
 		dprintk("%s: invalid constellation\n", __func__);
 		return -EINVAL;
 	}
-	switch (p->u.ofdm.hierarchy_information) {
+	switch (p->u.ofdm.hierarchy_information) {	/* mask 0x07 */
 	case HIERARCHY_NONE:
-		val = (val & 0xf8);
 		break;
 	case HIERARCHY_1:
-		val = (val & 0xf8) | 1;
+		val |= 0x01;
 		break;
 	case HIERARCHY_2:
-		val = (val & 0xf8) | 2;
+		val |= 0x02;
 		break;
 	case HIERARCHY_4:
-		val = (val & 0xf8) | 3;
+		val |= 0x03;
 		break;
 	default:
 		dprintk("%s: invalid hierarchy\n", __func__);
@@ -350,44 +348,42 @@ static int cx22702_set_tps(struct dvb_fr
 	}
 	cx22702_writereg(state, 0x06, val);
 
-	val = 0;
-	switch (p->u.ofdm.code_rate_HP) {
+	switch (p->u.ofdm.code_rate_HP) {		/* mask 0x38 */
 	case FEC_NONE:
 	case FEC_1_2:
-		val = (val & 0xc7);
+		val = 0x00;
 		break;
 	case FEC_2_3:
-		val = (val & 0xc7) | 0x08;
+		val = 0x08;
 		break;
 	case FEC_3_4:
-		val = (val & 0xc7) | 0x10;
+		val = 0x10;
 		break;
 	case FEC_5_6:
-		val = (val & 0xc7) | 0x18;
+		val = 0x18;
 		break;
 	case FEC_7_8:
-		val = (val & 0xc7) | 0x20;
+		val = 0x20;
 		break;
 	default:
 		dprintk("%s: invalid code_rate_HP\n", __func__);
 		return -EINVAL;
 	}
-	switch (p->u.ofdm.code_rate_LP) {
+	switch (p->u.ofdm.code_rate_LP) {		/* mask 0x07 */
 	case FEC_NONE:
 	case FEC_1_2:
-		val = (val & 0xf8);
 		break;
 	case FEC_2_3:
-		val = (val & 0xf8) | 1;
+		val |= 0x01;
 		break;
 	case FEC_3_4:
-		val = (val & 0xf8) | 2;
+		val |= 0x02;
 		break;
 	case FEC_5_6:
-		val = (val & 0xf8) | 3;
+		val |= 0x03;
 		break;
 	case FEC_7_8:
-		val = (val & 0xf8) | 4;
+		val |= 0x04;
 		break;
 	default:
 		dprintk("%s: invalid code_rate_LP\n", __func__);
@@ -395,30 +391,28 @@ static int cx22702_set_tps(struct dvb_fr
 	}
 	cx22702_writereg(state, 0x07, val);
 
-	val = 0;
-	switch (p->u.ofdm.guard_interval) {
+	switch (p->u.ofdm.guard_interval) {		/* mask 0x0c */
 	case GUARD_INTERVAL_1_32:
-		val = (val & 0xf3);
+		val = 0x00;
 		break;
 	case GUARD_INTERVAL_1_16:
-		val = (val & 0xf3) | 0x04;
+		val = 0x04;
 		break;
 	case GUARD_INTERVAL_1_8:
-		val = (val & 0xf3) | 0x08;
+		val = 0x08;
 		break;
 	case GUARD_INTERVAL_1_4:
-		val = (val & 0xf3) | 0x0c;
+		val = 0x0c;
 		break;
 	default:
 		dprintk("%s: invalid guard_interval\n", __func__);
 		return -EINVAL;
 	}
-	switch (p->u.ofdm.transmission_mode) {
+	switch (p->u.ofdm.transmission_mode) {		/* mask 0x03 */
 	case TRANSMISSION_MODE_2K:
-		val = (val & 0xfc);
 		break;
 	case TRANSMISSION_MODE_8K:
-		val = (val & 0xfc) | 1;
+		val |= 0x1;
 		break;
 	default:
 		dprintk("%s: invalid transmission_mode\n", __func__);

-- 
Jean Delvare
