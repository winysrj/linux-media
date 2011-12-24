Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab1LXPvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:06 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5Pj017032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 07/47] [media] max2165: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:12 -0200
Message-Id: <1324741852-26138-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-7-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
 <1324741852-26138-6-git-send-email-mchehab@redhat.com>
 <1324741852-26138-7-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/max2165.c |   36 +++++++++++---------------------
 1 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/media/common/tuners/max2165.c b/drivers/media/common/tuners/max2165.c
index 9883617..0343449 100644
--- a/drivers/media/common/tuners/max2165.c
+++ b/drivers/media/common/tuners/max2165.c
@@ -151,7 +151,7 @@ static int max2165_set_bandwidth(struct max2165_priv *priv, u32 bw)
 {
 	u8 val;
 
-	if (bw == BANDWIDTH_8_MHZ)
+	if (bw == 8000000)
 		val = priv->bb_filter_8mhz_cfg;
 	else
 		val = priv->bb_filter_7mhz_cfg;
@@ -261,35 +261,25 @@ static int max2165_set_params(struct dvb_frontend *fe,
 	struct dvb_frontend_parameters *params)
 {
 	struct max2165_priv *priv = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	dprintk("%s() frequency=%d (Hz)\n", __func__, params->frequency);
-	if (fe->ops.info.type == FE_ATSC) {
-			return -EINVAL;
-	} else if (fe->ops.info.type == FE_OFDM) {
-		dprintk("%s() OFDM\n", __func__);
-		switch (params->u.ofdm.bandwidth) {
-		case BANDWIDTH_6_MHZ:
-			return -EINVAL;
-		case BANDWIDTH_7_MHZ:
-		case BANDWIDTH_8_MHZ:
-			priv->frequency = params->frequency;
-			priv->bandwidth = params->u.ofdm.bandwidth;
-			break;
-		default:
-			printk(KERN_ERR "MAX2165 bandwidth not set!\n");
-			return -EINVAL;
-		}
-	} else {
-		printk(KERN_ERR "MAX2165 modulation type not supported!\n");
+	switch (c->bandwidth_hz) {
+	case 7000000:
+	case 8000000:
+		priv->frequency = c->frequency;
+		break;
+	default:
+		printk(KERN_INFO "MAX2165: bandwidth %d Hz not supported.\n",
+		       c->bandwidth_hz);
 		return -EINVAL;
 	}
 
-	dprintk("%s() frequency=%d\n", __func__, priv->frequency);
+	dprintk("%s() frequency=%d\n", __func__, c->frequency);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
-	max2165_set_bandwidth(priv, priv->bandwidth);
+	max2165_set_bandwidth(priv, c->bandwidth_hz);
 	ret = max2165_set_rf(priv, priv->frequency);
 	mdelay(50);
 	max2165_debug_status(priv);
@@ -370,7 +360,7 @@ static int max2165_init(struct dvb_frontend *fe)
 
 	max2165_read_rom_table(priv);
 
-	max2165_set_bandwidth(priv, BANDWIDTH_8_MHZ);
+	max2165_set_bandwidth(priv, 8000000);
 
 	if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
-- 
1.7.8.352.g876a6

