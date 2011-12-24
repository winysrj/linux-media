Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581Ab1LXPvH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:07 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp7h6018702
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 39/47] [media] dvb-pll: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:44 -0200
Message-Id: <1324741852-26138-40-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-39-git-send-email-mchehab@redhat.com>
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
 <1324741852-26138-18-git-send-email-mchehab@redhat.com>
 <1324741852-26138-19-git-send-email-mchehab@redhat.com>
 <1324741852-26138-20-git-send-email-mchehab@redhat.com>
 <1324741852-26138-21-git-send-email-mchehab@redhat.com>
 <1324741852-26138-22-git-send-email-mchehab@redhat.com>
 <1324741852-26138-23-git-send-email-mchehab@redhat.com>
 <1324741852-26138-24-git-send-email-mchehab@redhat.com>
 <1324741852-26138-25-git-send-email-mchehab@redhat.com>
 <1324741852-26138-26-git-send-email-mchehab@redhat.com>
 <1324741852-26138-27-git-send-email-mchehab@redhat.com>
 <1324741852-26138-28-git-send-email-mchehab@redhat.com>
 <1324741852-26138-29-git-send-email-mchehab@redhat.com>
 <1324741852-26138-30-git-send-email-mchehab@redhat.com>
 <1324741852-26138-31-git-send-email-mchehab@redhat.com>
 <1324741852-26138-32-git-send-email-mchehab@redhat.com>
 <1324741852-26138-33-git-send-email-mchehab@redhat.com>
 <1324741852-26138-34-git-send-email-mchehab@redhat.com>
 <1324741852-26138-35-git-send-email-mchehab@redhat.com>
 <1324741852-26138-36-git-send-email-mchehab@redhat.com>
 <1324741852-26138-37-git-send-email-mchehab@redhat.com>
 <1324741852-26138-38-git-send-email-mchehab@redhat.com>
 <1324741852-26138-39-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/dvb-pll.c |   61 +++++++++++++++++---------------
 1 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/media/dvb/frontends/dvb-pll.c b/drivers/media/dvb/frontends/dvb-pll.c
index 62a65ef..4ed7bee 100644
--- a/drivers/media/dvb/frontends/dvb-pll.c
+++ b/drivers/media/dvb/frontends/dvb-pll.c
@@ -61,8 +61,7 @@ struct dvb_pll_desc {
 	u32  min;
 	u32  max;
 	u32  iffreq;
-	void (*set)(struct dvb_frontend *fe, u8 *buf,
-		    const struct dvb_frontend_parameters *params);
+	void (*set)(struct dvb_frontend *fe, u8 *buf);
 	u8   *initdata;
 	u8   *initdata2;
 	u8   *sleepdata;
@@ -93,10 +92,10 @@ static struct dvb_pll_desc dvb_pll_thomson_dtt7579 = {
 	},
 };
 
-static void thomson_dtt759x_bw(struct dvb_frontend *fe, u8 *buf,
-			       const struct dvb_frontend_parameters *params)
+static void thomson_dtt759x_bw(struct dvb_frontend *fe, u8 *buf)
 {
-	if (BANDWIDTH_7_MHZ == params->u.ofdm.bandwidth)
+	u32 bw = fe->dtv_property_cache.bandwidth_hz;
+	if (bw == 7000000)
 		buf[3] |= 0x10;
 }
 
@@ -186,10 +185,10 @@ static struct dvb_pll_desc dvb_pll_env57h1xd5 = {
 /* Philips TDA6650/TDA6651
  * used in Panasonic ENV77H11D5
  */
-static void tda665x_bw(struct dvb_frontend *fe, u8 *buf,
-		       const struct dvb_frontend_parameters *params)
+static void tda665x_bw(struct dvb_frontend *fe, u8 *buf)
 {
-	if (params->u.ofdm.bandwidth == BANDWIDTH_8_MHZ)
+	u32 bw = fe->dtv_property_cache.bandwidth_hz;
+	if (bw == 8000000)
 		buf[3] |= 0x08;
 }
 
@@ -220,10 +219,10 @@ static struct dvb_pll_desc dvb_pll_tda665x = {
 /* Infineon TUA6034
  * used in LG TDTP E102P
  */
-static void tua6034_bw(struct dvb_frontend *fe, u8 *buf,
-		       const struct dvb_frontend_parameters *params)
+static void tua6034_bw(struct dvb_frontend *fe, u8 *buf)
 {
-	if (BANDWIDTH_7_MHZ != params->u.ofdm.bandwidth)
+	u32 bw = fe->dtv_property_cache.bandwidth_hz;
+	if (bw == 7000000)
 		buf[3] |= 0x08;
 }
 
@@ -244,10 +243,10 @@ static struct dvb_pll_desc dvb_pll_tua6034 = {
 /* ALPS TDED4
  * used in Nebula-Cards and USB boxes
  */
-static void tded4_bw(struct dvb_frontend *fe, u8 *buf,
-		     const struct dvb_frontend_parameters *params)
+static void tded4_bw(struct dvb_frontend *fe, u8 *buf)
 {
-	if (params->u.ofdm.bandwidth == BANDWIDTH_8_MHZ)
+	u32 bw = fe->dtv_property_cache.bandwidth_hz;
+	if (bw == 8000000)
 		buf[3] |= 0x04;
 }
 
@@ -319,11 +318,11 @@ static struct dvb_pll_desc dvb_pll_philips_sd1878_tda8261 = {
 	},
 };
 
-static void opera1_bw(struct dvb_frontend *fe, u8 *buf,
-		      const struct dvb_frontend_parameters *params)
+static void opera1_bw(struct dvb_frontend *fe, u8 *buf)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_pll_priv *priv = fe->tuner_priv;
-	u32 b_w  = (params->u.qpsk.symbol_rate * 27) / 32000;
+	u32 b_w  = (c->symbol_rate * 27) / 32000;
 	struct i2c_msg msg = {
 		.addr = priv->pll_i2c_address,
 		.flags = 0,
@@ -392,8 +391,7 @@ static struct dvb_pll_desc dvb_pll_opera1 = {
 	}
 };
 
-static void samsung_dtos403ih102a_set(struct dvb_frontend *fe, u8 *buf,
-		       const struct dvb_frontend_parameters *params)
+static void samsung_dtos403ih102a_set(struct dvb_frontend *fe, u8 *buf)
 {
 	struct dvb_pll_priv *priv = fe->tuner_priv;
 	struct i2c_msg msg = {
@@ -537,30 +535,29 @@ static struct dvb_pll_desc *pll_list[] = {
 /* code                                                        */
 
 static int dvb_pll_configure(struct dvb_frontend *fe, u8 *buf,
-			     const struct dvb_frontend_parameters *params)
+			     const u32 frequency)
 {
 	struct dvb_pll_priv *priv = fe->tuner_priv;
 	struct dvb_pll_desc *desc = priv->pll_desc;
 	u32 div;
 	int i;
 
-	if (params->frequency != 0 && (params->frequency < desc->min ||
-				       params->frequency > desc->max))
+	if (frequency && (frequency < desc->min || frequency > desc->max))
 		return -EINVAL;
 
 	for (i = 0; i < desc->count; i++) {
-		if (params->frequency > desc->entries[i].limit)
+		if (frequency > desc->entries[i].limit)
 			continue;
 		break;
 	}
 
 	if (debug)
 		printk("pll: %s: freq=%d | i=%d/%d\n", desc->name,
-		       params->frequency, i, desc->count);
+		       frequency, i, desc->count);
 	if (i == desc->count)
 		return -EINVAL;
 
-	div = (params->frequency + desc->iffreq +
+	div = (frequency + desc->iffreq +
 	       desc->entries[i].stepsize/2) / desc->entries[i].stepsize;
 	buf[0] = div >> 8;
 	buf[1] = div & 0xff;
@@ -568,7 +565,7 @@ static int dvb_pll_configure(struct dvb_frontend *fe, u8 *buf,
 	buf[3] = desc->entries[i].cb;
 
 	if (desc->set)
-		desc->set(fe, buf, params);
+		desc->set(fe, buf);
 
 	if (debug)
 		printk("pll: %s: div=%d | buf=0x%02x,0x%02x,0x%02x,0x%02x\n",
@@ -614,6 +611,7 @@ static int dvb_pll_sleep(struct dvb_frontend *fe)
 static int dvb_pll_set_params(struct dvb_frontend *fe,
 			      struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_pll_priv *priv = fe->tuner_priv;
 	u8 buf[4];
 	struct i2c_msg msg =
@@ -625,7 +623,7 @@ static int dvb_pll_set_params(struct dvb_frontend *fe,
 	if (priv->i2c == NULL)
 		return -EINVAL;
 
-	if ((result = dvb_pll_configure(fe, buf, params)) < 0)
+	if ((result = dvb_pll_configure(fe, buf, c->frequency)) < 0)
 		return result;
 	else
 		frequency = result;
@@ -637,7 +635,12 @@ static int dvb_pll_set_params(struct dvb_frontend *fe,
 	}
 
 	priv->frequency = frequency;
-	priv->bandwidth = (fe->ops.info.type == FE_OFDM) ? params->u.ofdm.bandwidth : 0;
+	if (c->bandwidth_hz <= 6000000)
+		priv->bandwidth = BANDWIDTH_6_MHZ;
+	else if (c->bandwidth_hz <= 7000000)
+		priv->bandwidth = BANDWIDTH_7_MHZ;
+	if (c->bandwidth_hz <= 8000000)
+		priv->bandwidth = BANDWIDTH_8_MHZ;
 
 	return 0;
 }
@@ -653,7 +656,7 @@ static int dvb_pll_calc_regs(struct dvb_frontend *fe,
 	if (buf_len < 5)
 		return -EINVAL;
 
-	if ((result = dvb_pll_configure(fe, buf+1, params)) < 0)
+	if ((result = dvb_pll_configure(fe, buf+1, params->frequency)) < 0)
 		return result;
 	else
 		frequency = result;
-- 
1.7.8.352.g876a6

