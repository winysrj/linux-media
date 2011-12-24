Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab1LXPvO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:14 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFpEE8009998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:14 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 14/47] [media] tda18271-fe: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:19 -0200
Message-Id: <1324741852-26138-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-14-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
 <1324741852-26138-6-git-send-email-mchehab@redhat.com>
 <1324741852-26138-7-git-send-email-mchehab@redhat.com>
 <1324741852-26138-8-git-send-email-mchehab@redhat.com>
 <1324741852-26138-9-git-send-email-mchehab@redhat.com>
 <1324741852-26138-10-git-send-email-mchehab@redhat.com>
 <1324741852-26138-11-git-send-email-mchehab@redhat.com>
 <1324741852-26138-12-git-send-email-mchehab@redhat.com>
 <1324741852-26138-13-git-send-email-mchehab@redhat.com>
 <1324741852-26138-14-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tda18271-fe.c |   74 +++++++++++++---------------
 1 files changed, 34 insertions(+), 40 deletions(-)

diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
index 3347c5b..6348bb3 100644
--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -931,56 +931,51 @@ fail:
 static int tda18271_set_params(struct dvb_frontend *fe,
 			       struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys = c->delivery_system;
+	u32 bw = c->bandwidth_hz;
+	u32 freq = c->frequency;
+	u32 band = BANDWIDTH_6_MHZ;
 	struct tda18271_priv *priv = fe->tuner_priv;
 	struct tda18271_std_map *std_map = &priv->std;
 	struct tda18271_std_map_item *map;
 	int ret;
-	u32 bw, freq = params->frequency;
 
 	priv->mode = TDA18271_DIGITAL;
 
-	if (fe->ops.info.type == FE_ATSC) {
-		switch (params->u.vsb.modulation) {
-		case VSB_8:
-		case VSB_16:
-			map = &std_map->atsc_6;
-			break;
-		case QAM_64:
-		case QAM_256:
-			map = &std_map->qam_6;
-			break;
-		default:
-			tda_warn("modulation not set!\n");
-			return -EINVAL;
-		}
-#if 0
-		/* userspace request is already center adjusted */
-		freq += 1750000; /* Adjust to center (+1.75MHZ) */
-#endif
+	switch (delsys) {
+	case SYS_ATSC:
+		map = &std_map->atsc_6;
 		bw = 6000000;
-	} else if (fe->ops.info.type == FE_OFDM) {
-		switch (params->u.ofdm.bandwidth) {
-		case BANDWIDTH_6_MHZ:
-			bw = 6000000;
+		break;
+	case SYS_DVBT:
+	case SYS_DVBT2:
+		if (bw <= 6000000) {
 			map = &std_map->dvbt_6;
-			break;
-		case BANDWIDTH_7_MHZ:
-			bw = 7000000;
+		} else if (bw <= 7000000) {
 			map = &std_map->dvbt_7;
-			break;
-		case BANDWIDTH_8_MHZ:
-			bw = 8000000;
+			band = BANDWIDTH_7_MHZ;
+		} else {
 			map = &std_map->dvbt_8;
-			break;
-		default:
-			tda_warn("bandwidth not set!\n");
-			return -EINVAL;
+			band = BANDWIDTH_8_MHZ;
 		}
-	} else if (fe->ops.info.type == FE_QAM) {
-		/* DVB-C */
-		map = &std_map->qam_8;
-		bw = 8000000;
-	} else {
+		break;
+	case SYS_DVBC_ANNEX_B:
+		bw = 6000000;
+		/* falltrough */
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_C:
+		if (bw <= 6000000) {
+			map = &std_map->qam_6;
+		} else if (bw <= 7000000) {
+			map = &std_map->qam_7;
+			band = BANDWIDTH_7_MHZ;
+		} else {
+			map = &std_map->qam_8;
+			band = BANDWIDTH_8_MHZ;
+		}
+		break;
+	default:
 		tda_warn("modulation type not supported!\n");
 		return -EINVAL;
 	}
@@ -996,8 +991,7 @@ static int tda18271_set_params(struct dvb_frontend *fe,
 
 	priv->if_freq   = map->if_freq;
 	priv->frequency = freq;
-	priv->bandwidth = (fe->ops.info.type == FE_OFDM) ?
-		params->u.ofdm.bandwidth : 0;
+	priv->bandwidth = band;
 fail:
 	return ret;
 }
-- 
1.7.8.352.g876a6

