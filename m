Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234Ab1LVLUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:23 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKNpm032749
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 24/28] [media] tuner-xc2028: use DVBv5 parameters
Date: Thu, 22 Dec 2011 09:20:12 -0200
Message-Id: <1324552816-25704-25-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324552816-25704-24-git-send-email-mchehab@redhat.com>
References: <1324552816-25704-1-git-send-email-mchehab@redhat.com>
 <1324552816-25704-2-git-send-email-mchehab@redhat.com>
 <1324552816-25704-3-git-send-email-mchehab@redhat.com>
 <1324552816-25704-4-git-send-email-mchehab@redhat.com>
 <1324552816-25704-5-git-send-email-mchehab@redhat.com>
 <1324552816-25704-6-git-send-email-mchehab@redhat.com>
 <1324552816-25704-7-git-send-email-mchehab@redhat.com>
 <1324552816-25704-8-git-send-email-mchehab@redhat.com>
 <1324552816-25704-9-git-send-email-mchehab@redhat.com>
 <1324552816-25704-10-git-send-email-mchehab@redhat.com>
 <1324552816-25704-11-git-send-email-mchehab@redhat.com>
 <1324552816-25704-12-git-send-email-mchehab@redhat.com>
 <1324552816-25704-13-git-send-email-mchehab@redhat.com>
 <1324552816-25704-14-git-send-email-mchehab@redhat.com>
 <1324552816-25704-15-git-send-email-mchehab@redhat.com>
 <1324552816-25704-16-git-send-email-mchehab@redhat.com>
 <1324552816-25704-17-git-send-email-mchehab@redhat.com>
 <1324552816-25704-18-git-send-email-mchehab@redhat.com>
 <1324552816-25704-19-git-send-email-mchehab@redhat.com>
 <1324552816-25704-20-git-send-email-mchehab@redhat.com>
 <1324552816-25704-21-git-send-email-mchehab@redhat.com>
 <1324552816-25704-22-git-send-email-mchehab@redhat.com>
 <1324552816-25704-23-git-send-email-mchehab@redhat.com>
 <1324552816-25704-24-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |   83 ++++++++++++----------------
 1 files changed, 36 insertions(+), 47 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index e531267..8c0dc6a1 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -1087,65 +1087,26 @@ static int xc2028_set_analog_freq(struct dvb_frontend *fe,
 static int xc2028_set_params(struct dvb_frontend *fe,
 			     struct dvb_frontend_parameters *p)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys = c->delivery_system;
+	u32 bw = c->bandwidth_hz;
 	struct xc2028_data *priv = fe->tuner_priv;
 	unsigned int       type=0;
-	fe_bandwidth_t     bw = BANDWIDTH_8_MHZ;
 	u16                demod = 0;
 
 	tuner_dbg("%s called\n", __func__);
 
-	switch(fe->ops.info.type) {
-	case FE_OFDM:
-		bw = p->u.ofdm.bandwidth;
+	switch (delsys) {
+	case SYS_DVBT:
+	case SYS_DVBT2:
 		/*
 		 * The only countries with 6MHz seem to be Taiwan/Uruguay.
 		 * Both seem to require QAM firmware for OFDM decoding
 		 * Tested in Taiwan by Terry Wu <terrywu2009@gmail.com>
 		 */
-		if (bw == BANDWIDTH_6_MHZ)
+		if (bw <= 6000000)
 			type |= QAM;
-		break;
-	case FE_ATSC:
-		bw = BANDWIDTH_6_MHZ;
-		/* The only ATSC firmware (at least on v2.7) is D2633 */
-		type |= ATSC | D2633;
-		break;
-	/* DVB-S and pure QAM (FE_QAM) are not supported */
-	default:
-		return -EINVAL;
-	}
-
-	switch (bw) {
-	case BANDWIDTH_8_MHZ:
-		if (p->frequency < 470000000)
-			priv->ctrl.vhfbw7 = 0;
-		else
-			priv->ctrl.uhfbw8 = 1;
-		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV8;
-		type |= F8MHZ;
-		break;
-	case BANDWIDTH_7_MHZ:
-		if (p->frequency < 470000000)
-			priv->ctrl.vhfbw7 = 1;
-		else
-			priv->ctrl.uhfbw8 = 0;
-		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV7;
-		type |= F8MHZ;
-		break;
-	case BANDWIDTH_6_MHZ:
-		type |= DTV6;
-		priv->ctrl.vhfbw7 = 0;
-		priv->ctrl.uhfbw8 = 0;
-		break;
-	default:
-		tuner_err("error: bandwidth not supported.\n");
-	};
 
-	/*
-	  Selects between D2633 or D2620 firmware.
-	  It doesn't make sense for ATSC, since it should be D2633 on all cases
-	 */
-	if (fe->ops.info.type != FE_ATSC) {
 		switch (priv->ctrl.type) {
 		case XC2028_D2633:
 			type |= D2633;
@@ -1161,6 +1122,34 @@ static int xc2028_set_params(struct dvb_frontend *fe,
 			else
 				type |= D2620;
 		}
+		break;
+	case SYS_ATSC:
+		/* The only ATSC firmware (at least on v2.7) is D2633 */
+		type |= ATSC | D2633;
+		break;
+	/* DVB-S and pure QAM (FE_QAM) are not supported */
+	default:
+		return -EINVAL;
+	}
+
+	if (bw <= 6000000) {
+		type |= DTV6;
+		priv->ctrl.vhfbw7 = 0;
+		priv->ctrl.uhfbw8 = 0;
+	} else if (bw <= 7000000) {
+		if (c->frequency < 470000000)
+			priv->ctrl.vhfbw7 = 1;
+		else
+			priv->ctrl.uhfbw8 = 0;
+		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV7;
+		type |= F8MHZ;
+	} else {
+		if (c->frequency < 470000000)
+			priv->ctrl.vhfbw7 = 0;
+		else
+			priv->ctrl.uhfbw8 = 1;
+		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV8;
+		type |= F8MHZ;
 	}
 
 	/* All S-code tables need a 200kHz shift */
@@ -1185,7 +1174,7 @@ static int xc2028_set_params(struct dvb_frontend *fe,
 		 */
 	}
 
-	return generic_set_freq(fe, p->frequency,
+	return generic_set_freq(fe, c->frequency,
 				V4L2_TUNER_DIGITAL_TV, type, 0, demod);
 }
 
-- 
1.7.8.352.g876a6

