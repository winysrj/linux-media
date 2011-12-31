Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1LaKXG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 05:23:06 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBVAN66g020655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 05:23:06 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] [media] cxd2820: convert get|set_fontend to use DVBv5 parameters
Date: Sat, 31 Dec 2011 08:22:58 -0200
Message-Id: <1325326980-27464-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325326980-27464-1-git-send-email-mchehab@redhat.com>
References: <1325326980-27464-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/cxd2820r_c.c    |    6 +--
 drivers/media/dvb/frontends/cxd2820r_core.c |   62 +++++++++-----------------
 drivers/media/dvb/frontends/cxd2820r_priv.h |   18 +++-----
 drivers/media/dvb/frontends/cxd2820r_t.c    |    6 +--
 drivers/media/dvb/frontends/cxd2820r_t2.c   |    6 +--
 5 files changed, 34 insertions(+), 64 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_c.c b/drivers/media/dvb/frontends/cxd2820r_c.c
index 9d081ef..9454049 100644
--- a/drivers/media/dvb/frontends/cxd2820r_c.c
+++ b/drivers/media/dvb/frontends/cxd2820r_c.c
@@ -21,8 +21,7 @@
 
 #include "cxd2820r_priv.h"
 
-int cxd2820r_set_frontend_c(struct dvb_frontend *fe,
-			    struct dvb_frontend_parameters *params)
+int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -105,8 +104,7 @@ error:
 	return ret;
 }
 
-int cxd2820r_get_frontend_c(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+int cxd2820r_get_frontend_c(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index f4718d5..56b7c28 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -246,8 +246,7 @@ u32 cxd2820r_div_u64_round_closest(u64 dividend, u32 divisor)
 	return div_u64(dividend + (divisor / 2), divisor);
 }
 
-static int cxd2820r_set_frontend(struct dvb_frontend *fe,
-				 struct dvb_frontend_parameters *p)
+static int cxd2820r_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
@@ -258,7 +257,7 @@ static int cxd2820r_set_frontend(struct dvb_frontend *fe,
 		ret = cxd2820r_init_t(fe);
 		if (ret < 0)
 			goto err;
-		ret = cxd2820r_set_frontend_t(fe, p);
+		ret = cxd2820r_set_frontend_t(fe);
 		if (ret < 0)
 			goto err;
 		break;
@@ -266,15 +265,15 @@ static int cxd2820r_set_frontend(struct dvb_frontend *fe,
 		ret = cxd2820r_init_t(fe);
 		if (ret < 0)
 			goto err;
-		ret = cxd2820r_set_frontend_t2(fe, p);
+		ret = cxd2820r_set_frontend_t2(fe);
 		if (ret < 0)
 			goto err;
 		break;
-	case SYS_DVBC_ANNEX_AC:
+	case SYS_DVBC_ANNEX_A:
 		ret = cxd2820r_init_c(fe);
 		if (ret < 0)
 			goto err;
-		ret = cxd2820r_set_frontend_c(fe, p);
+		ret = cxd2820r_set_frontend_c(fe);
 		if (ret < 0)
 			goto err;
 		break;
@@ -298,7 +297,7 @@ static int cxd2820r_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	case SYS_DVBT2:
 		ret = cxd2820r_read_status_t2(fe, status);
 		break;
-	case SYS_DVBC_ANNEX_AC:
+	case SYS_DVBC_ANNEX_A:
 		ret = cxd2820r_read_status_c(fe, status);
 		break;
 	default:
@@ -309,20 +308,20 @@ static int cxd2820r_read_status(struct dvb_frontend *fe, fe_status_t *status)
 }
 
 static int cxd2820r_get_frontend(struct dvb_frontend *fe,
-				 struct dvb_frontend_parameters *p)
+				 struct dtv_frontend_properties *c)
 {
 	int ret;
 
 	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
-		ret = cxd2820r_get_frontend_t(fe, p);
+		ret = cxd2820r_get_frontend_t(fe);
 		break;
 	case SYS_DVBT2:
-		ret = cxd2820r_get_frontend_t2(fe, p);
+		ret = cxd2820r_get_frontend_t2(fe);
 		break;
-	case SYS_DVBC_ANNEX_AC:
-		ret = cxd2820r_get_frontend_c(fe, p);
+	case SYS_DVBC_ANNEX_A:
+		ret = cxd2820r_get_frontend_c(fe);
 		break;
 	default:
 		ret = -EINVAL;
@@ -343,7 +342,7 @@ static int cxd2820r_read_ber(struct dvb_frontend *fe, u32 *ber)
 	case SYS_DVBT2:
 		ret = cxd2820r_read_ber_t2(fe, ber);
 		break;
-	case SYS_DVBC_ANNEX_AC:
+	case SYS_DVBC_ANNEX_A:
 		ret = cxd2820r_read_ber_c(fe, ber);
 		break;
 	default:
@@ -365,7 +364,7 @@ static int cxd2820r_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	case SYS_DVBT2:
 		ret = cxd2820r_read_signal_strength_t2(fe, strength);
 		break;
-	case SYS_DVBC_ANNEX_AC:
+	case SYS_DVBC_ANNEX_A:
 		ret = cxd2820r_read_signal_strength_c(fe, strength);
 		break;
 	default:
@@ -387,7 +386,7 @@ static int cxd2820r_read_snr(struct dvb_frontend *fe, u16 *snr)
 	case SYS_DVBT2:
 		ret = cxd2820r_read_snr_t2(fe, snr);
 		break;
-	case SYS_DVBC_ANNEX_AC:
+	case SYS_DVBC_ANNEX_A:
 		ret = cxd2820r_read_snr_c(fe, snr);
 		break;
 	default:
@@ -409,7 +408,7 @@ static int cxd2820r_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	case SYS_DVBT2:
 		ret = cxd2820r_read_ucblocks_t2(fe, ucblocks);
 		break;
-	case SYS_DVBC_ANNEX_AC:
+	case SYS_DVBC_ANNEX_A:
 		ret = cxd2820r_read_ucblocks_c(fe, ucblocks);
 		break;
 	default:
@@ -436,7 +435,7 @@ static int cxd2820r_sleep(struct dvb_frontend *fe)
 	case SYS_DVBT2:
 		ret = cxd2820r_sleep_t2(fe);
 		break;
-	case SYS_DVBC_ANNEX_AC:
+	case SYS_DVBC_ANNEX_A:
 		ret = cxd2820r_sleep_c(fe);
 		break;
 	default:
@@ -459,7 +458,7 @@ static int cxd2820r_get_tune_settings(struct dvb_frontend *fe,
 	case SYS_DVBT2:
 		ret = cxd2820r_get_tune_settings_t2(fe, s);
 		break;
-	case SYS_DVBC_ANNEX_AC:
+	case SYS_DVBC_ANNEX_A:
 		ret = cxd2820r_get_tune_settings_c(fe, s);
 		break;
 	default:
@@ -479,7 +478,7 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe,
 	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
 
 	/* switch between DVB-T and DVB-T2 when tune fails */
-	if (priv->last_tune_failed && (priv->delivery_system != SYS_DVBC_ANNEX_AC)) {
+	if (priv->last_tune_failed && (priv->delivery_system != SYS_DVBC_ANNEX_A)) {
 		if (priv->delivery_system == SYS_DVBT)
 			c->delivery_system = SYS_DVBT2;
 		else
@@ -487,7 +486,7 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe,
 	}
 
 	/* set frontend */
-	ret = cxd2820r_set_frontend(fe, p);
+	ret = cxd2820r_set_frontend(fe);
 	if (ret)
 		goto error;
 
@@ -555,24 +554,9 @@ static int cxd2820r_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return cxd2820r_wr_reg_mask(priv, 0xdb, enable ? 1 : 0, 0x1);
 }
 
-static int cxd2820r_get_property(struct dvb_frontend *fe, struct dtv_property *p)
-{
-	dbg("%s()\n", __func__);
-
-	switch (p->cmd) {
-	case DTV_ENUM_DELSYS:
-		p->u.buffer.data[0] = SYS_DVBT;
-		p->u.buffer.data[1] = SYS_DVBT2;
-		p->u.buffer.data[2] = SYS_DVBC_ANNEX_AC;
-		p->u.buffer.len = 3;
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
 static const struct dvb_frontend_ops cxd2820r_ops = {
+	.delsys = { SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A },
+
 	/* default: DVB-T/T2 */
 	.info = {
 		.name = "Sony CXD2820R (DVB-T/T2)",
@@ -603,7 +587,7 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
 	.get_tune_settings	= cxd2820r_get_tune_settings,
 	.i2c_gate_ctrl		= cxd2820r_i2c_gate_ctrl,
 
-	.get_frontend_legacy	= cxd2820r_get_frontend,
+	.get_frontend		= cxd2820r_get_frontend,
 
 	.get_frontend_algo	= cxd2820r_get_frontend_algo,
 	.search			= cxd2820r_search,
@@ -613,8 +597,6 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
 	.read_ber		= cxd2820r_read_ber,
 	.read_ucblocks		= cxd2820r_read_ucblocks,
 	.read_signal_strength	= cxd2820r_read_signal_strength,
-
-	.get_property		= cxd2820r_get_property,
 };
 
 struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
diff --git a/drivers/media/dvb/frontends/cxd2820r_priv.h b/drivers/media/dvb/frontends/cxd2820r_priv.h
index 94dcf7f..9a9822c 100644
--- a/drivers/media/dvb/frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb/frontends/cxd2820r_priv.h
@@ -86,11 +86,9 @@ int cxd2820r_rd_reg(struct cxd2820r_priv *priv, u32 reg, u8 *val);
 
 /* cxd2820r_c.c */
 
-int cxd2820r_get_frontend_c(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p);
+int cxd2820r_get_frontend_c(struct dvb_frontend *fe);
 
-int cxd2820r_set_frontend_c(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params);
+int cxd2820r_set_frontend_c(struct dvb_frontend *fe);
 
 int cxd2820r_read_status_c(struct dvb_frontend *fe, fe_status_t *status);
 
@@ -111,11 +109,9 @@ int cxd2820r_get_tune_settings_c(struct dvb_frontend *fe,
 
 /* cxd2820r_t.c */
 
-int cxd2820r_get_frontend_t(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p);
+int cxd2820r_get_frontend_t(struct dvb_frontend *fe);
 
-int cxd2820r_set_frontend_t(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params);
+int cxd2820r_set_frontend_t(struct dvb_frontend *fe);
 
 int cxd2820r_read_status_t(struct dvb_frontend *fe, fe_status_t *status);
 
@@ -136,11 +132,9 @@ int cxd2820r_get_tune_settings_t(struct dvb_frontend *fe,
 
 /* cxd2820r_t2.c */
 
-int cxd2820r_get_frontend_t2(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p);
+int cxd2820r_get_frontend_t2(struct dvb_frontend *fe);
 
-int cxd2820r_set_frontend_t2(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params);
+int cxd2820r_set_frontend_t2(struct dvb_frontend *fe);
 
 int cxd2820r_read_status_t2(struct dvb_frontend *fe, fe_status_t *status);
 
diff --git a/drivers/media/dvb/frontends/cxd2820r_t.c b/drivers/media/dvb/frontends/cxd2820r_t.c
index d0b854a..1a02623 100644
--- a/drivers/media/dvb/frontends/cxd2820r_t.c
+++ b/drivers/media/dvb/frontends/cxd2820r_t.c
@@ -21,8 +21,7 @@
 
 #include "cxd2820r_priv.h"
 
-int cxd2820r_set_frontend_t(struct dvb_frontend *fe,
-			    struct dvb_frontend_parameters *p)
+int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -142,8 +141,7 @@ error:
 	return ret;
 }
 
-int cxd2820r_get_frontend_t(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+int cxd2820r_get_frontend_t(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
diff --git a/drivers/media/dvb/frontends/cxd2820r_t2.c b/drivers/media/dvb/frontends/cxd2820r_t2.c
index c62cf4d..3a5759e 100644
--- a/drivers/media/dvb/frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb/frontends/cxd2820r_t2.c
@@ -21,8 +21,7 @@
 
 #include "cxd2820r_priv.h"
 
-int cxd2820r_set_frontend_t2(struct dvb_frontend *fe,
-			     struct dvb_frontend_parameters *params)
+int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -156,8 +155,7 @@ error:
 
 }
 
-int cxd2820r_get_frontend_t2(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+int cxd2820r_get_frontend_t2(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-- 
1.7.8.352.g876a6

