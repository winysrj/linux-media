Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Q23009099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 15/94] [media] cxd2820r: report delivery system and cleanups
Date: Fri, 30 Dec 2011 13:07:12 -0200
Message-Id: <1325257711-12274-16-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver already uses DVBv5 structs for both get and set
frontend. All it needs is some cleanups, and to properly
report the delivery systems.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/cxd2820r_c.c    |    6 +---
 drivers/media/dvb/frontends/cxd2820r_core.c |   37 ++++++++++++++-------------
 drivers/media/dvb/frontends/cxd2820r_priv.h |   15 ++++------
 drivers/media/dvb/frontends/cxd2820r_t.c    |    6 +---
 drivers/media/dvb/frontends/cxd2820r_t2.c   |    6 +---
 5 files changed, 31 insertions(+), 39 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_c.c b/drivers/media/dvb/frontends/cxd2820r_c.c
index 26545d7..aa6fe1a 100644
--- a/drivers/media/dvb/frontends/cxd2820r_c.c
+++ b/drivers/media/dvb/frontends/cxd2820r_c.c
@@ -21,8 +21,7 @@
 
 #include "cxd2820r_priv.h"
 
-int cxd2820r_set_frontend_c(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -106,10 +105,9 @@ error:
 }
 
 int cxd2820r_get_frontend_c(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+			    struct dtv_frontend_properties *c)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[2];
 
diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index 97bc353..5b2d840 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -184,7 +184,7 @@ int cxd2820r_gpio(struct dvb_frontend *fe)
 	case SYS_DVBT2:
 		gpio = priv->cfg.gpio_dvbt2;
 		break;
-	case SYS_DVBC_ANNEX_AC:
+	case SYS_DVBC_ANNEX_A:
 		gpio = priv->cfg.gpio_dvbc;
 		break;
 	default:
@@ -283,8 +283,7 @@ u32 cxd2820r_div_u64_round_closest(u64 dividend, u32 divisor)
 	return div_u64(dividend + (divisor / 2), divisor);
 }
 
-static int cxd2820r_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int cxd2820r_set_frontend(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -301,34 +300,34 @@ static int cxd2820r_set_frontend(struct dvb_frontend *fe,
 		case SYS_UNDEFINED:
 			if (c->delivery_system == SYS_DVBT) {
 				/* SLEEP => DVB-T */
-				ret = cxd2820r_set_frontend_t(fe, p);
+				ret = cxd2820r_set_frontend_t(fe);
 			} else {
 				/* SLEEP => DVB-T2 */
-				ret = cxd2820r_set_frontend_t2(fe, p);
+				ret = cxd2820r_set_frontend_t2(fe);
 			}
 			break;
 		case SYS_DVBT:
 			if (c->delivery_system == SYS_DVBT) {
 				/* DVB-T => DVB-T */
-				ret = cxd2820r_set_frontend_t(fe, p);
+				ret = cxd2820r_set_frontend_t(fe);
 			} else if (c->delivery_system == SYS_DVBT2) {
 				/* DVB-T => DVB-T2 */
 				ret = cxd2820r_sleep_t(fe);
 				if (ret)
 					break;
-				ret = cxd2820r_set_frontend_t2(fe, p);
+				ret = cxd2820r_set_frontend_t2(fe);
 			}
 			break;
 		case SYS_DVBT2:
 			if (c->delivery_system == SYS_DVBT2) {
 				/* DVB-T2 => DVB-T2 */
-				ret = cxd2820r_set_frontend_t2(fe, p);
+				ret = cxd2820r_set_frontend_t2(fe);
 			} else if (c->delivery_system == SYS_DVBT) {
 				/* DVB-T2 => DVB-T */
 				ret = cxd2820r_sleep_t2(fe);
 				if (ret)
 					break;
-				ret = cxd2820r_set_frontend_t(fe, p);
+				ret = cxd2820r_set_frontend_t(fe);
 			}
 			break;
 		default:
@@ -342,7 +341,7 @@ static int cxd2820r_set_frontend(struct dvb_frontend *fe,
 		if (ret)
 			return ret;
 
-		ret = cxd2820r_set_frontend_c(fe, p);
+		ret = cxd2820r_set_frontend_c(fe);
 	}
 
 	return ret;
@@ -383,7 +382,7 @@ static int cxd2820r_read_status(struct dvb_frontend *fe, fe_status_t *status)
 }
 
 static int cxd2820r_get_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+				 struct dtv_frontend_properties *c)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret;
@@ -397,10 +396,10 @@ static int cxd2820r_get_frontend(struct dvb_frontend *fe,
 
 		switch (fe->dtv_property_cache.delivery_system) {
 		case SYS_DVBT:
-			ret = cxd2820r_get_frontend_t(fe, p);
+			ret = cxd2820r_get_frontend_t(fe, c);
 			break;
 		case SYS_DVBT2:
-			ret = cxd2820r_get_frontend_t2(fe, p);
+			ret = cxd2820r_get_frontend_t2(fe, c);
 			break;
 		default:
 			ret = -EINVAL;
@@ -411,7 +410,7 @@ static int cxd2820r_get_frontend(struct dvb_frontend *fe,
 		if (ret)
 			return ret;
 
-		ret = cxd2820r_get_frontend_c(fe, p);
+		ret = cxd2820r_get_frontend_c(fe, c);
 	}
 
 	return ret;
@@ -672,7 +671,7 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe,
 	}
 
 	/* set frontend */
-	ret = cxd2820r_set_frontend(fe, p);
+	ret = cxd2820r_set_frontend(fe);
 	if (ret)
 		goto error;
 
@@ -799,6 +798,7 @@ EXPORT_SYMBOL(cxd2820r_attach);
 static const struct dvb_frontend_ops cxd2820r_ops[2] = {
 	{
 		/* DVB-T/T2 */
+		.delsys = { SYS_DVBT, SYS_DVBT2 },
 		.info = {
 			.name = "Sony CXD2820R (DVB-T/T2)",
 			.type = FE_OFDM,
@@ -823,7 +823,7 @@ static const struct dvb_frontend_ops cxd2820r_ops[2] = {
 		.get_tune_settings = cxd2820r_get_tune_settings,
 		.i2c_gate_ctrl = cxd2820r_i2c_gate_ctrl,
 
-		.get_frontend_legacy = cxd2820r_get_frontend,
+		.get_frontend = cxd2820r_get_frontend,
 
 		.get_frontend_algo = cxd2820r_get_frontend_algo,
 		.search = cxd2820r_search,
@@ -836,6 +836,7 @@ static const struct dvb_frontend_ops cxd2820r_ops[2] = {
 	},
 	{
 		/* DVB-C */
+		.delsys = { SYS_DVBC_ANNEX_A },
 		.info = {
 			.name = "Sony CXD2820R (DVB-C)",
 			.type = FE_QAM,
@@ -852,8 +853,8 @@ static const struct dvb_frontend_ops cxd2820r_ops[2] = {
 		.get_tune_settings = cxd2820r_get_tune_settings,
 		.i2c_gate_ctrl = cxd2820r_i2c_gate_ctrl,
 
-		.set_frontend_legacy = cxd2820r_set_frontend,
-		.get_frontend_legacy = cxd2820r_get_frontend,
+		.set_frontend = cxd2820r_set_frontend,
+		.get_frontend = cxd2820r_get_frontend,
 
 		.read_status = cxd2820r_read_status,
 		.read_snr = cxd2820r_read_snr,
diff --git a/drivers/media/dvb/frontends/cxd2820r_priv.h b/drivers/media/dvb/frontends/cxd2820r_priv.h
index 9553913..3371fdb 100644
--- a/drivers/media/dvb/frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb/frontends/cxd2820r_priv.h
@@ -90,10 +90,9 @@ int cxd2820r_rd_reg(struct cxd2820r_priv *priv, u32 reg, u8 *val);
 /* cxd2820r_c.c */
 
 int cxd2820r_get_frontend_c(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p);
+			    struct dtv_frontend_properties *c);
 
-int cxd2820r_set_frontend_c(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params);
+int cxd2820r_set_frontend_c(struct dvb_frontend *fe);
 
 int cxd2820r_read_status_c(struct dvb_frontend *fe, fe_status_t *status);
 
@@ -115,10 +114,9 @@ int cxd2820r_get_tune_settings_c(struct dvb_frontend *fe,
 /* cxd2820r_t.c */
 
 int cxd2820r_get_frontend_t(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p);
+			    struct dtv_frontend_properties *c);
 
-int cxd2820r_set_frontend_t(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params);
+int cxd2820r_set_frontend_t(struct dvb_frontend *fe);
 
 int cxd2820r_read_status_t(struct dvb_frontend *fe, fe_status_t *status);
 
@@ -140,10 +138,9 @@ int cxd2820r_get_tune_settings_t(struct dvb_frontend *fe,
 /* cxd2820r_t2.c */
 
 int cxd2820r_get_frontend_t2(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p);
+			     struct dtv_frontend_properties *c);
 
-int cxd2820r_set_frontend_t2(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params);
+int cxd2820r_set_frontend_t2(struct dvb_frontend *fe);
 
 int cxd2820r_read_status_t2(struct dvb_frontend *fe, fe_status_t *status);
 
diff --git a/drivers/media/dvb/frontends/cxd2820r_t.c b/drivers/media/dvb/frontends/cxd2820r_t.c
index a12ba74..f09d856 100644
--- a/drivers/media/dvb/frontends/cxd2820r_t.c
+++ b/drivers/media/dvb/frontends/cxd2820r_t.c
@@ -21,8 +21,7 @@
 
 #include "cxd2820r_priv.h"
 
-int cxd2820r_set_frontend_t(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -143,10 +142,9 @@ error:
 }
 
 int cxd2820r_get_frontend_t(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+			    struct dtv_frontend_properties *c)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[2];
 
diff --git a/drivers/media/dvb/frontends/cxd2820r_t2.c b/drivers/media/dvb/frontends/cxd2820r_t2.c
index 52ed2c4..b7ddae0 100644
--- a/drivers/media/dvb/frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb/frontends/cxd2820r_t2.c
@@ -21,8 +21,7 @@
 
 #include "cxd2820r_priv.h"
 
-int cxd2820r_set_frontend_t2(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *params)
+int cxd2820r_set_frontend_t2(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -157,10 +156,9 @@ error:
 }
 
 int cxd2820r_get_frontend_t2(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+			     struct dtv_frontend_properties *c)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[2];
 
-- 
1.7.8.352.g876a6

