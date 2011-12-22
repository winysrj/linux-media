Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab1LVLUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:23 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKNUH019831
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 15/28] [media] max2165: use DVBv5 parameters
Date: Thu, 22 Dec 2011 09:20:03 -0200
Message-Id: <1324552816-25704-16-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324552816-25704-15-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/max2165.c |   60 ++++++++++++++++++++------------
 1 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/media/common/tuners/max2165.c b/drivers/media/common/tuners/max2165.c
index 9883617..8558a63 100644
--- a/drivers/media/common/tuners/max2165.c
+++ b/drivers/media/common/tuners/max2165.c
@@ -150,11 +150,26 @@ static int max2165_set_osc(struct max2165_priv *priv, u8 osc /*MHz*/)
 static int max2165_set_bandwidth(struct max2165_priv *priv, u32 bw)
 {
 	u8 val;
+	u32 newbw;
 
-	if (bw == BANDWIDTH_8_MHZ)
-		val = priv->bb_filter_8mhz_cfg;
-	else
+	if (bw <= 7000000) {
 		val = priv->bb_filter_7mhz_cfg;
+		priv->bandwidth = BANDWIDTH_7_MHZ;
+		newbw = 7000000;
+	} else {
+		val = priv->bb_filter_8mhz_cfg;
+		priv->bandwidth = BANDWIDTH_8_MHZ;
+		newbw = 8000000;
+	}
+
+	switch (bw) {
+	case 7000000:
+	case 8000000:
+		break;
+	default:
+		printk(KERN_INFO "MAX2165: bandwidth %d Hz not supported. using %d Hz instead\n",
+		       bw, newbw);
+	}
 
 	max2165_mask_write_reg(priv, REG_BASEBAND_CTRL, 0xF0, val << 4);
 
@@ -261,35 +276,34 @@ static int max2165_set_params(struct dvb_frontend *fe,
 	struct dvb_frontend_parameters *params)
 {
 	struct max2165_priv *priv = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys = c->delivery_system;
 	int ret;
 
-	dprintk("%s() frequency=%d (Hz)\n", __func__, params->frequency);
-	if (fe->ops.info.type == FE_ATSC) {
-			return -EINVAL;
-	} else if (fe->ops.info.type == FE_OFDM) {
+	dprintk("%s() frequency=%d (Hz)\n", __func__, c->frequency);
+
+	switch (delsys) {
+	case SYS_DVBT:
+	case SYS_DVBT2:
 		dprintk("%s() OFDM\n", __func__);
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
+		break;
+	/*
+	 * FIXME: it is likely that this would work with DVB-C as well,
+	 * at least for 7MHz/8MHz. If this is needed, all the code should
+	 * do is to add a new "case SYS_DVBC_ANNEX_A" line.
+	 */
+	default:
+		printk(KERN_ERR "MAX2165: delivery system not supported!\n");
 		return -EINVAL;
 	}
 
+	priv->frequency = c->frequency;
+
 	dprintk("%s() frequency=%d\n", __func__, priv->frequency);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
-	max2165_set_bandwidth(priv, priv->bandwidth);
+	max2165_set_bandwidth(priv, c->bandwidth_hz);
 	ret = max2165_set_rf(priv, priv->frequency);
 	mdelay(50);
 	max2165_debug_status(priv);
@@ -370,7 +384,7 @@ static int max2165_init(struct dvb_frontend *fe)
 
 	max2165_read_rom_table(priv);
 
-	max2165_set_bandwidth(priv, BANDWIDTH_8_MHZ);
+	max2165_set_bandwidth(priv, 8000000);
 
 	if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
-- 
1.7.8.352.g876a6

