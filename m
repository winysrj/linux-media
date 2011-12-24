Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab1LXPvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:06 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5mw009938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 17/47] [media] xc4000: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:22 -0200
Message-Id: <1324741852-26138-18-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-17-git-send-email-mchehab@redhat.com>
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
 <1324741852-26138-15-git-send-email-mchehab@redhat.com>
 <1324741852-26138-16-git-send-email-mchehab@redhat.com>
 <1324741852-26138-17-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/xc4000.c |   97 +++++++++++++++-------------------
 1 files changed, 42 insertions(+), 55 deletions(-)

diff --git a/drivers/media/common/tuners/xc4000.c b/drivers/media/common/tuners/xc4000.c
index 634f4d9..e6acc7a 100644
--- a/drivers/media/common/tuners/xc4000.c
+++ b/drivers/media/common/tuners/xc4000.c
@@ -1124,80 +1124,67 @@ static void xc_debug_dump(struct xc4000_priv *priv)
 static int xc4000_set_params(struct dvb_frontend *fe,
 	struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys = c->delivery_system;
+	u32 bw = c->bandwidth_hz;
 	struct xc4000_priv *priv = fe->tuner_priv;
 	unsigned int type;
 	int	ret = -EREMOTEIO;
 
-	dprintk(1, "%s() frequency=%d (Hz)\n", __func__, params->frequency);
+	dprintk(1, "%s() frequency=%d (Hz)\n", __func__, c->frequency);
 
 	mutex_lock(&priv->lock);
 
-	if (fe->ops.info.type == FE_ATSC) {
-		dprintk(1, "%s() ATSC\n", __func__);
-		switch (params->u.vsb.modulation) {
-		case VSB_8:
-		case VSB_16:
-			dprintk(1, "%s() VSB modulation\n", __func__);
-			priv->rf_mode = XC_RF_MODE_AIR;
-			priv->freq_hz = params->frequency - 1750000;
-			priv->bandwidth = BANDWIDTH_6_MHZ;
-			priv->video_standard = XC4000_DTV6;
-			type = DTV6;
-			break;
-		case QAM_64:
-		case QAM_256:
-		case QAM_AUTO:
-			dprintk(1, "%s() QAM modulation\n", __func__);
-			priv->rf_mode = XC_RF_MODE_CABLE;
-			priv->freq_hz = params->frequency - 1750000;
-			priv->bandwidth = BANDWIDTH_6_MHZ;
-			priv->video_standard = XC4000_DTV6;
-			type = DTV6;
-			break;
-		default:
-			ret = -EINVAL;
-			goto fail;
-		}
-	} else if (fe->ops.info.type == FE_OFDM) {
+	switch (delsys) {
+	case SYS_ATSC:
+		dprintk(1, "%s() VSB modulation\n", __func__);
+		priv->rf_mode = XC_RF_MODE_AIR;
+		priv->freq_hz = c->frequency - 1750000;
+		priv->bandwidth = BANDWIDTH_6_MHZ;
+		priv->video_standard = XC4000_DTV6;
+		type = DTV6;
+		break;
+	case SYS_DVBC_ANNEX_B:
+		dprintk(1, "%s() QAM modulation\n", __func__);
+		priv->rf_mode = XC_RF_MODE_CABLE;
+		priv->freq_hz = c->frequency - 1750000;
+		priv->bandwidth = BANDWIDTH_6_MHZ;
+		priv->video_standard = XC4000_DTV6;
+		type = DTV6;
+		break;
+	case SYS_DVBT:
+	case SYS_DVBT2:
 		dprintk(1, "%s() OFDM\n", __func__);
-		switch (params->u.ofdm.bandwidth) {
-		case BANDWIDTH_6_MHZ:
+		if (bw == 0) {
+			if (c->frequency < 400000000) {
+				priv->bandwidth = BANDWIDTH_7_MHZ;
+				priv->freq_hz = c->frequency - 2250000;
+			} else {
+				priv->bandwidth = BANDWIDTH_8_MHZ;
+				priv->freq_hz = c->frequency - 2750000;
+			}
+			priv->video_standard = XC4000_DTV7_8;
+			type = DTV78;
+		} else if (bw <= 6000000) {
 			priv->bandwidth = BANDWIDTH_6_MHZ;
 			priv->video_standard = XC4000_DTV6;
-			priv->freq_hz = params->frequency - 1750000;
+			priv->freq_hz = c->frequency - 1750000;
 			type = DTV6;
-			break;
-		case BANDWIDTH_7_MHZ:
+		} else if (bw <= 7000000) {
 			priv->bandwidth = BANDWIDTH_7_MHZ;
 			priv->video_standard = XC4000_DTV7;
-			priv->freq_hz = params->frequency - 2250000;
+			priv->freq_hz = c->frequency - 2250000;
 			type = DTV7;
-			break;
-		case BANDWIDTH_8_MHZ:
+		} else {
 			priv->bandwidth = BANDWIDTH_8_MHZ;
 			priv->video_standard = XC4000_DTV8;
-			priv->freq_hz = params->frequency - 2750000;
+			priv->freq_hz = c->frequency - 2750000;
 			type = DTV8;
-			break;
-		case BANDWIDTH_AUTO:
-			if (params->frequency < 400000000) {
-				priv->bandwidth = BANDWIDTH_7_MHZ;
-				priv->freq_hz = params->frequency - 2250000;
-			} else {
-				priv->bandwidth = BANDWIDTH_8_MHZ;
-				priv->freq_hz = params->frequency - 2750000;
-			}
-			priv->video_standard = XC4000_DTV7_8;
-			type = DTV78;
-			break;
-		default:
-			printk(KERN_ERR "xc4000 bandwidth not set!\n");
-			ret = -EINVAL;
-			goto fail;
 		}
 		priv->rf_mode = XC_RF_MODE_AIR;
-	} else {
-		printk(KERN_ERR "xc4000 modulation type not supported!\n");
+		break;
+	default:
+		printk(KERN_ERR "xc4000 delivery system not supported!\n");
 		ret = -EINVAL;
 		goto fail;
 	}
-- 
1.7.8.352.g876a6

