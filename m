Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab1LXPvK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:10 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp955009974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 46/47] [media] dvb: remove dvb_frontend_parameters from calc_regs()
Date: Sat, 24 Dec 2011 13:50:51 -0200
Message-Id: <1324741852-26138-47-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-46-git-send-email-mchehab@redhat.com>
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
 <1324741852-26138-40-git-send-email-mchehab@redhat.com>
 <1324741852-26138-41-git-send-email-mchehab@redhat.com>
 <1324741852-26138-42-git-send-email-mchehab@redhat.com>
 <1324741852-26138-43-git-send-email-mchehab@redhat.com>
 <1324741852-26138-44-git-send-email-mchehab@redhat.com>
 <1324741852-26138-45-git-send-email-mchehab@redhat.com>
 <1324741852-26138-46-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The calc_regs() callback is used by a few frontends (mt352, nxt200x,
digitv and zl10353). On all places it is called, the parameters are
set by DVBv5 way. So, just use the DVBv5 struct and remove the
extra parameter.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tuner-simple.c |   31 ++++++--------
 drivers/media/dvb/bt8xx/dvb-bt8xx.c        |   64 ++++++++++++++-------------
 drivers/media/dvb/dvb-core/dvb_frontend.h  |    2 +-
 drivers/media/dvb/dvb-usb/digitv.c         |    2 +-
 drivers/media/dvb/frontends/dvb-pll.c      |    6 +-
 drivers/media/dvb/frontends/mt352.c        |    2 +-
 drivers/media/dvb/frontends/nxt200x.c      |    2 +-
 drivers/media/dvb/frontends/zl10353.c      |    2 +-
 8 files changed, 54 insertions(+), 57 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
index e6342db..1dad5fb 100644
--- a/drivers/media/common/tuners/tuner-simple.c
+++ b/drivers/media/common/tuners/tuner-simple.c
@@ -884,7 +884,6 @@ static u32 simple_dvb_configure(struct dvb_frontend *fe, u8 *buf,
 }
 
 static int simple_dvb_calc_regs(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *params,
 				u8 *buf, int buf_len)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -896,28 +895,14 @@ static int simple_dvb_calc_regs(struct dvb_frontend *fe,
 	if (buf_len < 5)
 		return -EINVAL;
 
-	switch (delsys) {
-	case SYS_DVBT:
-	case SYS_DVBT2:
-		if (params->u.ofdm.bandwidth == BANDWIDTH_6_MHZ)
-			bw = 6000000;
-		if (params->u.ofdm.bandwidth == BANDWIDTH_7_MHZ)
-			bw = 7000000;
-		if (params->u.ofdm.bandwidth == BANDWIDTH_8_MHZ)
-			bw = 8000000;
-		break;
-	default:
-		break;
-	}
-	frequency = simple_dvb_configure(fe, buf+1, delsys, params->frequency, bw);
+	frequency = simple_dvb_configure(fe, buf+1, delsys, c->frequency, bw);
 	if (frequency == 0)
 		return -EINVAL;
 
 	buf[0] = priv->i2c_props.addr;
 
 	priv->frequency = frequency;
-	priv->bandwidth = (fe->ops.info.type == FE_OFDM) ?
-		params->u.ofdm.bandwidth : 0;
+	priv->bandwidth = c->bandwidth_hz;
 
 	return 5;
 }
@@ -1044,7 +1029,17 @@ static int simple_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static int simple_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 {
 	struct tuner_simple_priv *priv = fe->tuner_priv;
-	*bandwidth = priv->bandwidth;
+	switch (priv->bandwidth) {
+	case 6000000:
+		*bandwidth = BANDWIDTH_6_MHZ;
+		break;
+	case 7000000:
+		*bandwidth = BANDWIDTH_7_MHZ;
+		break;
+	case 8000000:
+		*bandwidth = BANDWIDTH_8_MHZ;
+		break;
+	}
 	return 0;
 }
 
diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index 5948601..8275d7e 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -148,8 +148,9 @@ static int thomson_dtt7579_demod_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int thomson_dtt7579_tuner_calc_regs(struct dvb_frontend* fe, struct dvb_frontend_parameters* params, u8* pllbuf, int buf_len)
+static int thomson_dtt7579_tuner_calc_regs(struct dvb_frontend* fe, u8* pllbuf, int buf_len)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 div;
 	unsigned char bs = 0;
 	unsigned char cp = 0;
@@ -157,18 +158,18 @@ static int thomson_dtt7579_tuner_calc_regs(struct dvb_frontend* fe, struct dvb_f
 	if (buf_len < 5)
 		return -EINVAL;
 
-	div = (((params->frequency + 83333) * 3) / 500000) + IF_FREQUENCYx6;
+	div = (((c->frequency + 83333) * 3) / 500000) + IF_FREQUENCYx6;
 
-	if (params->frequency < 542000000)
+	if (c->frequency < 542000000)
 		cp = 0xb4;
-	else if (params->frequency < 771000000)
+	else if (c->frequency < 771000000)
 		cp = 0xbc;
 	else
 		cp = 0xf4;
 
-	if (params->frequency == 0)
+	if (c->frequency == 0)
 		bs = 0x03;
-	else if (params->frequency < 443250000)
+	else if (c->frequency < 443250000)
 		bs = 0x02;
 	else
 		bs = 0x08;
@@ -342,50 +343,51 @@ static int advbt771_samsung_tdtc9251dh0_demod_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int advbt771_samsung_tdtc9251dh0_tuner_calc_regs(struct dvb_frontend* fe, struct dvb_frontend_parameters* params, u8* pllbuf, int buf_len)
+static int advbt771_samsung_tdtc9251dh0_tuner_calc_regs(struct dvb_frontend* fe, u8* pllbuf, int buf_len)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 div;
 	unsigned char bs = 0;
 	unsigned char cp = 0;
 
 	if (buf_len < 5) return -EINVAL;
 
-	div = (((params->frequency + 83333) * 3) / 500000) + IF_FREQUENCYx6;
+	div = (((c->frequency + 83333) * 3) / 500000) + IF_FREQUENCYx6;
 
-	if (params->frequency < 150000000)
+	if (c->frequency < 150000000)
 		cp = 0xB4;
-	else if (params->frequency < 173000000)
+	else if (c->frequency < 173000000)
 		cp = 0xBC;
-	else if (params->frequency < 250000000)
+	else if (c->frequency < 250000000)
 		cp = 0xB4;
-	else if (params->frequency < 400000000)
+	else if (c->frequency < 400000000)
 		cp = 0xBC;
-	else if (params->frequency < 420000000)
+	else if (c->frequency < 420000000)
 		cp = 0xF4;
-	else if (params->frequency < 470000000)
+	else if (c->frequency < 470000000)
 		cp = 0xFC;
-	else if (params->frequency < 600000000)
+	else if (c->frequency < 600000000)
 		cp = 0xBC;
-	else if (params->frequency < 730000000)
+	else if (c->frequency < 730000000)
 		cp = 0xF4;
 	else
 		cp = 0xFC;
 
-	if (params->frequency < 150000000)
+	if (c->frequency < 150000000)
 		bs = 0x01;
-	else if (params->frequency < 173000000)
+	else if (c->frequency < 173000000)
 		bs = 0x01;
-	else if (params->frequency < 250000000)
+	else if (c->frequency < 250000000)
 		bs = 0x02;
-	else if (params->frequency < 400000000)
+	else if (c->frequency < 400000000)
 		bs = 0x02;
-	else if (params->frequency < 420000000)
+	else if (c->frequency < 420000000)
 		bs = 0x02;
-	else if (params->frequency < 470000000)
+	else if (c->frequency < 470000000)
 		bs = 0x02;
-	else if (params->frequency < 600000000)
+	else if (c->frequency < 600000000)
 		bs = 0x08;
-	else if (params->frequency < 730000000)
+	else if (c->frequency < 730000000)
 		bs = 0x08;
 	else
 		bs = 0x08;
@@ -514,31 +516,31 @@ static int digitv_alps_tded4_demod_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int digitv_alps_tded4_tuner_calc_regs(struct dvb_frontend* fe, struct dvb_frontend_parameters* params, u8* pllbuf, int buf_len)
+static int digitv_alps_tded4_tuner_calc_regs(struct dvb_frontend* fe,  u8* pllbuf, int buf_len)
 {
 	u32 div;
-	struct dvb_ofdm_parameters *op = &params->u.ofdm;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
 	if (buf_len < 5)
 		return -EINVAL;
 
-	div = (((params->frequency + 83333) * 3) / 500000) + IF_FREQUENCYx6;
+	div = (((c->frequency + 83333) * 3) / 500000) + IF_FREQUENCYx6;
 
 	pllbuf[0] = 0x61;
 	pllbuf[1] = (div >> 8) & 0x7F;
 	pllbuf[2] = div & 0xFF;
 	pllbuf[3] = 0x85;
 
-	dprintk("frequency %u, div %u\n", params->frequency, div);
+	dprintk("frequency %u, div %u\n", c->frequency, div);
 
-	if (params->frequency < 470000000)
+	if (c->frequency < 470000000)
 		pllbuf[4] = 0x02;
-	else if (params->frequency > 823000000)
+	else if (c->frequency > 823000000)
 		pllbuf[4] = 0x88;
 	else
 		pllbuf[4] = 0x08;
 
-	if (op->bandwidth == 8)
+	if (c->bandwidth_hz == 8000000)
 		pllbuf[4] |= 0x04;
 
 	return 5;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 67bbfa7..99ae782 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -202,7 +202,7 @@ struct dvb_tuner_ops {
 	int (*set_analog_params)(struct dvb_frontend *fe, struct analog_parameters *p);
 
 	/** This is support for demods like the mt352 - fills out the supplied buffer with what to write. */
-	int (*calc_regs)(struct dvb_frontend *fe, struct dvb_frontend_parameters *p, u8 *buf, int buf_len);
+	int (*calc_regs)(struct dvb_frontend *fe, u8 *buf, int buf_len);
 
 	/** This is to allow setting tuner-specific configs */
 	int (*set_config)(struct dvb_frontend *fe, void *priv_cfg);
diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index f718411..2856ab7 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -123,7 +123,7 @@ static int digitv_nxt6000_tuner_set_params(struct dvb_frontend *fe, struct dvb_f
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	u8 b[5];
 
-	fe->ops.tuner_ops.calc_regs(fe, fep, b, sizeof(b));
+	fe->ops.tuner_ops.calc_regs(fe, b, sizeof(b));
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	return digitv_ctrl_msg(adap->dev, USB_WRITE_TUNER, 0, &b[1], 4, NULL, 0);
diff --git a/drivers/media/dvb/frontends/dvb-pll.c b/drivers/media/dvb/frontends/dvb-pll.c
index 4ed7bee..21f425f 100644
--- a/drivers/media/dvb/frontends/dvb-pll.c
+++ b/drivers/media/dvb/frontends/dvb-pll.c
@@ -646,9 +646,9 @@ static int dvb_pll_set_params(struct dvb_frontend *fe,
 }
 
 static int dvb_pll_calc_regs(struct dvb_frontend *fe,
-			     struct dvb_frontend_parameters *params,
 			     u8 *buf, int buf_len)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_pll_priv *priv = fe->tuner_priv;
 	int result;
 	u32 frequency = 0;
@@ -656,7 +656,7 @@ static int dvb_pll_calc_regs(struct dvb_frontend *fe,
 	if (buf_len < 5)
 		return -EINVAL;
 
-	if ((result = dvb_pll_configure(fe, buf+1, params->frequency)) < 0)
+	if ((result = dvb_pll_configure(fe, buf+1, c->frequency)) < 0)
 		return result;
 	else
 		frequency = result;
@@ -664,7 +664,7 @@ static int dvb_pll_calc_regs(struct dvb_frontend *fe,
 	buf[0] = priv->pll_i2c_address;
 
 	priv->frequency = frequency;
-	priv->bandwidth = (fe->ops.info.type == FE_OFDM) ? params->u.ofdm.bandwidth : 0;
+	priv->bandwidth = c->bandwidth_hz;
 
 	return 5;
 }
diff --git a/drivers/media/dvb/frontends/mt352.c b/drivers/media/dvb/frontends/mt352.c
index 319672f..e2a86da 100644
--- a/drivers/media/dvb/frontends/mt352.c
+++ b/drivers/media/dvb/frontends/mt352.c
@@ -302,7 +302,7 @@ static int mt352_set_parameters(struct dvb_frontend* fe,
 		_mt352_write(fe, fsm_go, 2);
 	} else {
 		if (fe->ops.tuner_ops.calc_regs) {
-			fe->ops.tuner_ops.calc_regs(fe, param, buf+8, 5);
+			fe->ops.tuner_ops.calc_regs(fe, buf+8, 5);
 			buf[8] <<= 1;
 			_mt352_write(fe, buf, sizeof(buf));
 			_mt352_write(fe, tuner_go, 2);
diff --git a/drivers/media/dvb/frontends/nxt200x.c b/drivers/media/dvb/frontends/nxt200x.c
index eac2065..ae5c3c3 100644
--- a/drivers/media/dvb/frontends/nxt200x.c
+++ b/drivers/media/dvb/frontends/nxt200x.c
@@ -566,7 +566,7 @@ static int nxt200x_setup_frontend_parameters (struct dvb_frontend* fe,
 
 	if (fe->ops.tuner_ops.calc_regs) {
 		/* get tuning information */
-		fe->ops.tuner_ops.calc_regs(fe, p, buf, 5);
+		fe->ops.tuner_ops.calc_regs(fe, buf, 5);
 
 		/* write frequency information */
 		nxt200x_writetuner(state, buf);
diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
index adbbf6d..9caccc0 100644
--- a/drivers/media/dvb/frontends/zl10353.c
+++ b/drivers/media/dvb/frontends/zl10353.c
@@ -367,7 +367,7 @@ static int zl10353_set_parameters(struct dvb_frontend *fe,
 				fe->ops.i2c_gate_ctrl(fe, 0);
 		}
 	} else if (fe->ops.tuner_ops.calc_regs) {
-		fe->ops.tuner_ops.calc_regs(fe, param, pllbuf + 1, 5);
+		fe->ops.tuner_ops.calc_regs(fe, pllbuf + 1, 5);
 		pllbuf[1] <<= 1;
 		zl10353_write(fe, pllbuf, sizeof(pllbuf));
 	}
-- 
1.7.8.352.g876a6

