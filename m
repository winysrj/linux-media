Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab2AAULY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jan 2012 15:11:24 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q01KBNUo021851
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Jan 2012 15:11:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/9] [media] dvb_frontend: Handle all possible DVBv3 values for bandwidth
Date: Sun,  1 Jan 2012 18:11:11 -0200
Message-Id: <1325448678-13001-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to DVB-T2, several new possible values for bandwidth were added.
As the DVBv3 struct were updated to handle them, the core needs to
handle all of them, as a DVBv3 application might try to use it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   55 ++++++++++++++++++++++-------
 1 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index b72b87e..33ce309 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1079,15 +1079,29 @@ static void dtv_property_cache_sync(struct dvb_frontend *fe,
 		c->modulation = p->u.qam.modulation;
 		break;
 	case FE_OFDM:
-		if (p->u.ofdm.bandwidth == BANDWIDTH_6_MHZ)
-			c->bandwidth_hz = 6000000;
-		else if (p->u.ofdm.bandwidth == BANDWIDTH_7_MHZ)
-			c->bandwidth_hz = 7000000;
-		else if (p->u.ofdm.bandwidth == BANDWIDTH_8_MHZ)
+		switch (p->u.ofdm.bandwidth) {
+		case BANDWIDTH_10_MHZ:
+			c->bandwidth_hz = 10000000;
+			break;
+		case BANDWIDTH_8_MHZ:
 			c->bandwidth_hz = 8000000;
-		else
-			/* Including BANDWIDTH_AUTO */
+			break;
+		case BANDWIDTH_7_MHZ:
+			c->bandwidth_hz = 7000000;
+			break;
+		case BANDWIDTH_6_MHZ:
+			c->bandwidth_hz = 6000000;
+			break;
+		case BANDWIDTH_5_MHZ:
+			c->bandwidth_hz = 5000000;
+			break;
+		case BANDWIDTH_1_712_MHZ:
+			c->bandwidth_hz = 1712000;
+			break;
+		case BANDWIDTH_AUTO:
 			c->bandwidth_hz = 0;
+		}
+
 		c->code_rate_HP = p->u.ofdm.code_rate_HP;
 		c->code_rate_LP = p->u.ofdm.code_rate_LP;
 		c->modulation = p->u.ofdm.constellation;
@@ -1130,14 +1144,29 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe,
 		break;
 	case FE_OFDM:
 		dprintk("%s() Preparing OFDM req\n", __func__);
-		if (c->bandwidth_hz == 6000000)
-			p->u.ofdm.bandwidth = BANDWIDTH_6_MHZ;
-		else if (c->bandwidth_hz == 7000000)
-			p->u.ofdm.bandwidth = BANDWIDTH_7_MHZ;
-		else if (c->bandwidth_hz == 8000000)
+		switch (c->bandwidth_hz) {
+		case 10000000:
+			p->u.ofdm.bandwidth = BANDWIDTH_10_MHZ;
+			break;
+		case 8000000:
 			p->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
-		else
+			break;
+		case 7000000:
+			p->u.ofdm.bandwidth = BANDWIDTH_7_MHZ;
+			break;
+		case 6000000:
+			p->u.ofdm.bandwidth = BANDWIDTH_6_MHZ;
+			break;
+		case 5000000:
+			p->u.ofdm.bandwidth = BANDWIDTH_5_MHZ;
+			break;
+		case 1712000:
+			p->u.ofdm.bandwidth = BANDWIDTH_1_712_MHZ;
+			break;
+		case 0:
+		default:
 			p->u.ofdm.bandwidth = BANDWIDTH_AUTO;
+		}
 		p->u.ofdm.code_rate_HP = c->code_rate_HP;
 		p->u.ofdm.code_rate_LP = c->code_rate_LP;
 		p->u.ofdm.constellation = c->modulation;
-- 
1.7.8.352.g876a6

