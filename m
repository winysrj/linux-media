Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab1LXPvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:05 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5P3030826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 08/47] [media] mt2266: use DVBv5 parameters for set_params()
Date: Sat, 24 Dec 2011 13:50:13 -0200
Message-Id: <1324741852-26138-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-8-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
 <1324741852-26138-6-git-send-email-mchehab@redhat.com>
 <1324741852-26138-7-git-send-email-mchehab@redhat.com>
 <1324741852-26138-8-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2266.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/media/common/tuners/mt2266.c b/drivers/media/common/tuners/mt2266.c
index 25a8ea3..dd883d7 100644
--- a/drivers/media/common/tuners/mt2266.c
+++ b/drivers/media/common/tuners/mt2266.c
@@ -124,6 +124,7 @@ static u8 mt2266_vhf[] = { 0x1d, 0xfe, 0x00, 0x00, 0xb4, 0x03, 0xa5, 0xa5,
 
 static int mt2266_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct mt2266_priv *priv;
 	int ret=0;
 	u32 freq;
@@ -135,30 +136,32 @@ static int mt2266_set_params(struct dvb_frontend *fe, struct dvb_frontend_parame
 
 	priv = fe->tuner_priv;
 
-	freq = params->frequency / 1000; // Hz -> kHz
+	freq = priv->frequency / 1000; /* Hz -> kHz */
 	if (freq < 470000 && freq > 230000)
 		return -EINVAL; /* Gap between VHF and UHF bands */
-	priv->bandwidth = (fe->ops.info.type == FE_OFDM) ? params->u.ofdm.bandwidth : 0;
-	priv->frequency = freq * 1000;
 
+	priv->frequency = c->frequency;
 	tune = 2 * freq * (8192/16) / (FREF/16);
 	band = (freq < 300000) ? MT2266_VHF : MT2266_UHF;
 	if (band == MT2266_VHF)
 		tune *= 2;
 
-	switch (params->u.ofdm.bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	switch (c->bandwidth_hz) {
+	case 6000000:
 		mt2266_writeregs(priv, mt2266_init_6mhz,
 				 sizeof(mt2266_init_6mhz));
+		priv->bandwidth = BANDWIDTH_6_MHZ;
 		break;
-	case BANDWIDTH_7_MHZ:
-		mt2266_writeregs(priv, mt2266_init_7mhz,
-				 sizeof(mt2266_init_7mhz));
-		break;
-	case BANDWIDTH_8_MHZ:
-	default:
+	case 8000000:
 		mt2266_writeregs(priv, mt2266_init_8mhz,
 				 sizeof(mt2266_init_8mhz));
+		priv->bandwidth = BANDWIDTH_8_MHZ;
+		break;
+	case 7000000:
+	default:
+		mt2266_writeregs(priv, mt2266_init_7mhz,
+				 sizeof(mt2266_init_7mhz));
+		priv->bandwidth = BANDWIDTH_7_MHZ;
 		break;
 	}
 
-- 
1.7.8.352.g876a6

