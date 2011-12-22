Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251Ab1LVLUY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:24 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKOfX006766
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 26/28] [media] tuner-simple: get rid of DVBv3 params at set_params call
Date: Thu, 22 Dec 2011 09:20:14 -0200
Message-Id: <1324552816-25704-27-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324552816-25704-26-git-send-email-mchehab@redhat.com>
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
 <1324552816-25704-25-git-send-email-mchehab@redhat.com>
 <1324552816-25704-26-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Despite its name, tuner-simple has a complex logic to set freqs ;)

Basically, it can be called by two different ways: via set_params()
or via calc_regs() callbacks. Both are bound to the DVBv3 API.
Also, set_params internally calls calc_regs().

In order to get rid of DVBv3 params at set_params(), it shouldn't
call calc_regs() anymore. The code duplication is very small,
as most of the code there is just to check for invalid parameters.

With regards to calc_regs(), it should still trust on bandwidth and
frequency parameters passed via DVBv3.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tuner-simple.c |   63 ++++++++++++++++++++-------
 1 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
index 4092200..e6342db 100644
--- a/drivers/media/common/tuners/tuner-simple.c
+++ b/drivers/media/common/tuners/tuner-simple.c
@@ -791,24 +791,26 @@ static int simple_set_params(struct dvb_frontend *fe,
 }
 
 static void simple_set_dvb(struct dvb_frontend *fe, u8 *buf,
-			   const struct dvb_frontend_parameters *params)
+			   const u32 delsys,
+			   const u32 frequency,
+			   const u32 bandwidth)
 {
 	struct tuner_simple_priv *priv = fe->tuner_priv;
 
 	switch (priv->type) {
 	case TUNER_PHILIPS_FMD1216ME_MK3:
 	case TUNER_PHILIPS_FMD1216MEX_MK3:
-		if (params->u.ofdm.bandwidth == BANDWIDTH_8_MHZ &&
-		    params->frequency >= 158870000)
+		if (bandwidth == 8000000 &&
+		    frequency >= 158870000)
 			buf[3] |= 0x08;
 		break;
 	case TUNER_PHILIPS_TD1316:
 		/* determine band */
-		buf[3] |= (params->frequency < 161000000) ? 1 :
-			  (params->frequency < 444000000) ? 2 : 4;
+		buf[3] |= (frequency < 161000000) ? 1 :
+			  (frequency < 444000000) ? 2 : 4;
 
 		/* setup PLL filter */
-		if (params->u.ofdm.bandwidth == BANDWIDTH_8_MHZ)
+		if (bandwidth == 8000000)
 			buf[3] |= 1 << 3;
 		break;
 	case TUNER_PHILIPS_TUV1236D:
@@ -819,12 +821,11 @@ static void simple_set_dvb(struct dvb_frontend *fe, u8 *buf,
 		if (dtv_input[priv->nr])
 			new_rf = dtv_input[priv->nr];
 		else
-			switch (params->u.vsb.modulation) {
-			case QAM_64:
-			case QAM_256:
+			switch (delsys) {
+			case SYS_DVBC_ANNEX_B:
 				new_rf = 1;
 				break;
-			case VSB_8:
+			case SYS_ATSC:
 			default:
 				new_rf = 0;
 				break;
@@ -838,7 +839,9 @@ static void simple_set_dvb(struct dvb_frontend *fe, u8 *buf,
 }
 
 static u32 simple_dvb_configure(struct dvb_frontend *fe, u8 *buf,
-				const struct dvb_frontend_parameters *params)
+				const u32 delsys,
+				const u32 freq,
+				const u32 bw)
 {
 	/* This function returns the tuned frequency on success, 0 on error */
 	struct tuner_simple_priv *priv = fe->tuner_priv;
@@ -847,7 +850,7 @@ static u32 simple_dvb_configure(struct dvb_frontend *fe, u8 *buf,
 	u8 config, cb;
 	u32 div;
 	int ret;
-	unsigned frequency = params->frequency / 62500;
+	u32 frequency = freq / 62500;
 
 	if (!tun->stepsize) {
 		/* tuner-core was loaded before the digital tuner was
@@ -871,7 +874,7 @@ static u32 simple_dvb_configure(struct dvb_frontend *fe, u8 *buf,
 	buf[2] = config;
 	buf[3] = cb;
 
-	simple_set_dvb(fe, buf, params);
+	simple_set_dvb(fe, buf, delsys, freq, bw);
 
 	tuner_dbg("%s: div=%d | buf=0x%02x,0x%02x,0x%02x,0x%02x\n",
 		  tun->name, div, buf[0], buf[1], buf[2], buf[3]);
@@ -884,13 +887,29 @@ static int simple_dvb_calc_regs(struct dvb_frontend *fe,
 				struct dvb_frontend_parameters *params,
 				u8 *buf, int buf_len)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys = c->delivery_system;
+	u32 bw = c->bandwidth_hz;
 	struct tuner_simple_priv *priv = fe->tuner_priv;
 	u32 frequency;
 
 	if (buf_len < 5)
 		return -EINVAL;
 
-	frequency = simple_dvb_configure(fe, buf+1, params);
+	switch (delsys) {
+	case SYS_DVBT:
+	case SYS_DVBT2:
+		if (params->u.ofdm.bandwidth == BANDWIDTH_6_MHZ)
+			bw = 6000000;
+		if (params->u.ofdm.bandwidth == BANDWIDTH_7_MHZ)
+			bw = 7000000;
+		if (params->u.ofdm.bandwidth == BANDWIDTH_8_MHZ)
+			bw = 8000000;
+		break;
+	default:
+		break;
+	}
+	frequency = simple_dvb_configure(fe, buf+1, delsys, params->frequency, bw);
 	if (frequency == 0)
 		return -EINVAL;
 
@@ -906,7 +925,12 @@ static int simple_dvb_calc_regs(struct dvb_frontend *fe,
 static int simple_dvb_set_params(struct dvb_frontend *fe,
 				 struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys = c->delivery_system;
+	u32 bw = c->bandwidth_hz;
+	u32 freq = c->frequency;
 	struct tuner_simple_priv *priv = fe->tuner_priv;
+	u32 frequency;
 	u32 prev_freq, prev_bw;
 	int ret;
 	u8 buf[5];
@@ -917,9 +941,14 @@ static int simple_dvb_set_params(struct dvb_frontend *fe,
 	prev_freq = priv->frequency;
 	prev_bw   = priv->bandwidth;
 
-	ret = simple_dvb_calc_regs(fe, params, buf, 5);
-	if (ret != 5)
-		goto fail;
+	frequency = simple_dvb_configure(fe, buf+1, delsys, freq, bw);
+	if (frequency == 0)
+		return -EINVAL;
+
+	buf[0] = priv->i2c_props.addr;
+
+	priv->frequency = frequency;
+	priv->bandwidth = bw;
 
 	/* put analog demod in standby when tuning digital */
 	if (fe->ops.analog_ops.standby)
-- 
1.7.8.352.g876a6

