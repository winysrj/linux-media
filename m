Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab1L0BJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:29 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19SK4015612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 03/91] [media] dvb-core: add support for a DVBv5 get_frontend() callback
Date: Mon, 26 Dec 2011 23:07:51 -0200
Message-Id: <1324948159-23709-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-3-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The old method is renamed to get_frontend_legacy(), while not all
frontends are converted.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/bt8xx/dst.c               |    8 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c   |  102 ++++++++++++++++++++------
 drivers/media/dvb/dvb-core/dvb_frontend.h   |    5 +-
 drivers/media/dvb/dvb-usb/af9005-fe.c       |    4 +-
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c    |    2 +-
 drivers/media/dvb/dvb-usb/dtt200u-fe.c      |    2 +-
 drivers/media/dvb/dvb-usb/friio-fe.c        |    2 +-
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c  |    2 +-
 drivers/media/dvb/dvb-usb/vp702x-fe.c       |    2 +-
 drivers/media/dvb/dvb-usb/vp7045-fe.c       |    2 +-
 drivers/media/dvb/firewire/firedtv-fe.c     |    2 +-
 drivers/media/dvb/frontends/af9013.c        |    2 +-
 drivers/media/dvb/frontends/atbm8830.c      |    2 +-
 drivers/media/dvb/frontends/au8522_dig.c    |    2 +-
 drivers/media/dvb/frontends/cx22700.c       |    2 +-
 drivers/media/dvb/frontends/cx22702.c       |    2 +-
 drivers/media/dvb/frontends/cx24110.c       |    2 +-
 drivers/media/dvb/frontends/cx24123.c       |    2 +-
 drivers/media/dvb/frontends/cxd2820r_core.c |    4 +-
 drivers/media/dvb/frontends/dib3000mb.c     |    2 +-
 drivers/media/dvb/frontends/dib3000mc.c     |    2 +-
 drivers/media/dvb/frontends/dib7000m.c      |    2 +-
 drivers/media/dvb/frontends/dib7000p.c      |    2 +-
 drivers/media/dvb/frontends/dib8000.c       |    4 +-
 drivers/media/dvb/frontends/dib9000.c       |    4 +-
 drivers/media/dvb/frontends/drxd_hard.c     |    2 +-
 drivers/media/dvb/frontends/drxk_hard.c     |    4 +-
 drivers/media/dvb/frontends/dvb_dummy_fe.c  |    6 +-
 drivers/media/dvb/frontends/it913x-fe.c     |    2 +-
 drivers/media/dvb/frontends/l64781.c        |    2 +-
 drivers/media/dvb/frontends/lgdt3305.c      |    4 +-
 drivers/media/dvb/frontends/lgdt330x.c      |    4 +-
 drivers/media/dvb/frontends/lgs8gl5.c       |    2 +-
 drivers/media/dvb/frontends/lgs8gxx.c       |    2 +-
 drivers/media/dvb/frontends/mb86a20s.c      |    2 +-
 drivers/media/dvb/frontends/mt312.c         |    2 +-
 drivers/media/dvb/frontends/mt352.c         |    2 +-
 drivers/media/dvb/frontends/or51132.c       |    2 +-
 drivers/media/dvb/frontends/s5h1409.c       |    2 +-
 drivers/media/dvb/frontends/s5h1411.c       |    2 +-
 drivers/media/dvb/frontends/s5h1420.c       |    2 +-
 drivers/media/dvb/frontends/s5h1432.c       |    2 +-
 drivers/media/dvb/frontends/s921.c          |    2 +-
 drivers/media/dvb/frontends/stb0899_drv.c   |    2 +-
 drivers/media/dvb/frontends/stb6100.c       |    4 +-
 drivers/media/dvb/frontends/stv0297.c       |    2 +-
 drivers/media/dvb/frontends/stv0299.c       |    2 +-
 drivers/media/dvb/frontends/stv0367.c       |    4 +-
 drivers/media/dvb/frontends/stv0900_core.c  |    2 +-
 drivers/media/dvb/frontends/tda10021.c      |    2 +-
 drivers/media/dvb/frontends/tda10023.c      |    2 +-
 drivers/media/dvb/frontends/tda10048.c      |    2 +-
 drivers/media/dvb/frontends/tda1004x.c      |    4 +-
 drivers/media/dvb/frontends/tda10071.c      |    2 +-
 drivers/media/dvb/frontends/tda10086.c      |    2 +-
 drivers/media/dvb/frontends/tda8083.c       |    2 +-
 drivers/media/dvb/frontends/ves1820.c       |    2 +-
 drivers/media/dvb/frontends/ves1x93.c       |    2 +-
 drivers/media/dvb/frontends/zl10353.c       |    2 +-
 drivers/media/dvb/siano/smsdvb.c            |    2 +-
 drivers/media/video/tlg2300/pd-dvb.c        |    2 +-
 drivers/staging/media/as102/as102_fe.c      |    2 +-
 62 files changed, 157 insertions(+), 100 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
index 4658bd6..6afc083 100644
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -1778,7 +1778,7 @@ static struct dvb_frontend_ops dst_dvbt_ops = {
 	.init = dst_init,
 	.tune = dst_tune_frontend,
 	.set_frontend_legacy = dst_set_frontend,
-	.get_frontend = dst_get_frontend,
+	.get_frontend_legacy = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
 	.read_signal_strength = dst_read_signal_strength,
@@ -1804,7 +1804,7 @@ static struct dvb_frontend_ops dst_dvbs_ops = {
 	.init = dst_init,
 	.tune = dst_tune_frontend,
 	.set_frontend_legacy = dst_set_frontend,
-	.get_frontend = dst_get_frontend,
+	.get_frontend_legacy = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
 	.read_signal_strength = dst_read_signal_strength,
@@ -1838,7 +1838,7 @@ static struct dvb_frontend_ops dst_dvbc_ops = {
 	.init = dst_init,
 	.tune = dst_tune_frontend,
 	.set_frontend_legacy = dst_set_frontend,
-	.get_frontend = dst_get_frontend,
+	.get_frontend_legacy = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
 	.read_signal_strength = dst_read_signal_strength,
@@ -1861,7 +1861,7 @@ static struct dvb_frontend_ops dst_atsc_ops = {
 	.init = dst_init,
 	.tune = dst_tune_frontend,
 	.set_frontend_legacy = dst_set_frontend,
-	.get_frontend = dst_get_frontend,
+	.get_frontend_legacy = dst_get_frontend,
 	.get_frontend_algo = dst_get_tuning_algo,
 	.read_status = dst_read_status,
 	.read_signal_strength = dst_read_signal_strength,
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index eca6170..1eefb91 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -139,6 +139,14 @@ struct dvb_frontend_private {
 };
 
 static void dvb_frontend_wakeup(struct dvb_frontend *fe);
+static int dtv_get_frontend(struct dvb_frontend *fe,
+			    struct dtv_frontend_properties *c,
+			    struct dvb_frontend_parameters *p_out);
+
+static bool has_get_frontend(struct dvb_frontend *fe)
+{
+	return fe->ops.get_frontend || fe->ops.get_frontend_legacy;
+}
 
 static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 {
@@ -149,8 +157,8 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 
 	dprintk ("%s\n", __func__);
 
-	if ((status & FE_HAS_LOCK) && fe->ops.get_frontend)
-		fe->ops.get_frontend(fe, &fepriv->parameters_out);
+	if ((status & FE_HAS_LOCK) && has_get_frontend(fe))
+		dtv_get_frontend(fe, NULL, &fepriv->parameters_out);
 
 	mutex_lock(&events->mtx);
 
@@ -1097,11 +1105,10 @@ static void dtv_property_cache_sync(struct dvb_frontend *fe,
 /* Ensure the cached values are set correctly in the frontend
  * legacy tuning structures, for the advanced tuning API.
  */
-static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
+static void dtv_property_legacy_params_sync(struct dvb_frontend *fe,
+					    struct dvb_frontend_parameters *p)
 {
 	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dvb_frontend_parameters *p = &fepriv->parameters_in;
 
 	p->frequency = c->frequency;
 	p->inversion = c->inversion;
@@ -1223,6 +1230,7 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
 static void dtv_property_cache_submit(struct dvb_frontend *fe)
 {
 	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
 	/* For legacy delivery systems we don't need the delivery_system to
 	 * be specified, but we populate the older structures from the cache
@@ -1231,7 +1239,7 @@ static void dtv_property_cache_submit(struct dvb_frontend *fe)
 	if(is_legacy_delivery_system(c->delivery_system)) {
 
 		dprintk("%s() legacy, modulation = %d\n", __func__, c->modulation);
-		dtv_property_legacy_params_sync(fe);
+		dtv_property_legacy_params_sync(fe, &fepriv->parameters_in);
 
 	} else {
 		dprintk("%s() adv, modulation = %d\n", __func__, c->modulation);
@@ -1246,6 +1254,58 @@ static void dtv_property_cache_submit(struct dvb_frontend *fe)
 	}
 }
 
+/**
+ * dtv_get_frontend - calls a callback for retrieving DTV parameters
+ * @fe:		struct dvb_frontend pointer
+ * @c:		struct dtv_frontend_properties pointer (DVBv5 cache)
+ * @p_out	struct dvb_frontend_parameters pointer (DVBv3 FE struct)
+ *
+ * This routine calls either the DVBv3 or DVBv5 get_frontend call.
+ * If c is not null, it will update the DVBv5 cache struct pointed by it.
+ * If p_out is not null, it will update the DVBv3 params pointed by it.
+ */
+static int dtv_get_frontend(struct dvb_frontend *fe,
+			    struct dtv_frontend_properties *c,
+			    struct dvb_frontend_parameters *p_out)
+{
+	const struct dtv_frontend_properties *cache = &fe->dtv_property_cache;
+	struct dtv_frontend_properties tmp_cache;
+	struct dvb_frontend_parameters tmp_out;
+	bool fill_cache = (c != NULL);
+	bool fill_params = (p_out != NULL);
+	int r;
+
+	if (!p_out)
+		p_out = & tmp_out;
+
+	if (!c)
+		c = &tmp_cache;
+	else
+		memcpy(c, cache, sizeof(*c));
+
+	/* Then try the DVBv5 one */
+	if (fe->ops.get_frontend) {
+		r = fe->ops.get_frontend(fe, c);
+		if (unlikely(r < 0))
+			return r;
+		if (fill_params)
+			dtv_property_legacy_params_sync(fe, p_out);
+		return 0;
+	}
+
+	/* As no DVBv5 call exists, use the DVBv3 one */
+	if (fe->ops.get_frontend_legacy) {
+		r = fe->ops.get_frontend_legacy(fe, p_out);
+		if (unlikely(r < 0))
+			return r;
+		if (fill_cache)
+			dtv_property_cache_sync(fe, c, p_out);
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int dvb_frontend_ioctl_legacy(struct file *file,
 			unsigned int cmd, void *parg);
 static int dvb_frontend_ioctl_properties(struct file *file,
@@ -1296,24 +1356,12 @@ static void dtv_set_default_delivery_caps(const struct dvb_frontend *fe, struct
 }
 
 static int dtv_property_process_get(struct dvb_frontend *fe,
+				    const struct dtv_frontend_properties *c,
 				    struct dtv_property *tvp,
 				    struct file *file)
 {
-	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dtv_frontend_properties cdetected;
 	int r;
 
-	/*
-	 * If the driver implements a get_frontend function, then convert
-	 * detected parameters to S2API properties.
-	 */
-	if (fe->ops.get_frontend) {
-		cdetected = *c;
-		dtv_property_cache_sync(fe, &cdetected, &fepriv->parameters_out);
-		c = &cdetected;
-	}
-
 	switch(tvp->cmd) {
 	case DTV_ENUM_DELSYS:
 		dtv_set_default_delivery_caps(fe, tvp);
@@ -1685,6 +1733,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 
 	} else
 	if(cmd == FE_GET_PROPERTY) {
+		struct dtv_frontend_properties cache_out;
 
 		tvps = (struct dtv_properties __user *)parg;
 
@@ -1707,8 +1756,13 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 			goto out;
 		}
 
+		/*
+		 * Fills the cache out struct with the cache contents, plus
+		 * the data retrieved from get_frontend/get_frontend_legacy.
+		 */
+		dtv_get_frontend(fe, &cache_out, NULL);
 		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_get(fe, tvp + i, file);
+			err = dtv_property_process_get(fe, &cache_out, tvp + i, file);
 			if (err < 0)
 				goto out;
 			(tvp + i)->result = err;
@@ -2008,10 +2062,10 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		break;
 
 	case FE_GET_FRONTEND:
-		if (fe->ops.get_frontend) {
-			err = fe->ops.get_frontend(fe, &fepriv->parameters_out);
-			memcpy(parg, &fepriv->parameters_out, sizeof(struct dvb_frontend_parameters));
-		}
+		err = dtv_get_frontend(fe, NULL, &fepriv->parameters_out);
+		if (err >= 0)
+			memcpy(parg, &fepriv->parameters_out,
+			       sizeof(struct dvb_frontend_parameters));
 		break;
 
 	case FE_SET_FRONTEND_TUNE_MODE:
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index dd44964..06ec17a 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -256,6 +256,8 @@ struct analog_demod_ops {
 	int (*set_config)(struct dvb_frontend *fe, void *priv_cfg);
 };
 
+struct dtv_frontend_properties;
+
 struct dvb_frontend_ops {
 
 	struct dvb_frontend_info info;
@@ -284,7 +286,8 @@ struct dvb_frontend_ops {
 	int (*set_frontend)(struct dvb_frontend* fe);
 	int (*get_tune_settings)(struct dvb_frontend* fe, struct dvb_frontend_tune_settings* settings);
 
-	int (*get_frontend)(struct dvb_frontend* fe, struct dvb_frontend_parameters* params);
+	int (*get_frontend_legacy)(struct dvb_frontend *fe, struct dvb_frontend_parameters *params);
+	int (*get_frontend)(struct dvb_frontend *fe, struct dtv_frontend_properties *props);
 
 	int (*read_status)(struct dvb_frontend* fe, fe_status_t* status);
 	int (*read_ber)(struct dvb_frontend* fe, u32* ber);
diff --git a/drivers/media/dvb/dvb-usb/af9005-fe.c b/drivers/media/dvb/dvb-usb/af9005-fe.c
index f216933..e9addd8 100644
--- a/drivers/media/dvb/dvb-usb/af9005-fe.c
+++ b/drivers/media/dvb/dvb-usb/af9005-fe.c
@@ -1239,7 +1239,7 @@ static int af9005_fe_get_frontend(struct dvb_frontend *fe,
 				      &temp);
 	if (ret)
 		return ret;
-	deb_info("===== fe_get_frontend ==============\n");
+	deb_info("===== fe_get_frontend_legacy = =============\n");
 	deb_info("CONSTELLATION ");
 	switch (temp) {
 	case 0:
@@ -1476,7 +1476,7 @@ static struct dvb_frontend_ops af9005_fe_ops = {
 	.ts_bus_ctrl = af9005_ts_bus_ctrl,
 
 	.set_frontend_legacy = af9005_fe_set_frontend,
-	.get_frontend = af9005_fe_get_frontend,
+	.get_frontend_legacy = af9005_fe_get_frontend,
 
 	.read_status = af9005_fe_read_status,
 	.read_ber = af9005_fe_read_ber,
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
index cad2284..40d50f7 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
@@ -341,7 +341,7 @@ static struct dvb_frontend_ops cinergyt2_fe_ops = {
 	.sleep			= cinergyt2_fe_sleep,
 
 	.set_frontend_legacy		= cinergyt2_fe_set_frontend,
-	.get_frontend		= cinergyt2_fe_get_frontend,
+	.get_frontend_legacy = cinergyt2_fe_get_frontend,
 	.get_tune_settings	= cinergyt2_fe_get_tune_settings,
 
 	.read_status		= cinergyt2_fe_read_status,
diff --git a/drivers/media/dvb/dvb-usb/dtt200u-fe.c b/drivers/media/dvb/dvb-usb/dtt200u-fe.c
index ef9f7e4..7ce8227 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u-fe.c
@@ -194,7 +194,7 @@ static struct dvb_frontend_ops dtt200u_fe_ops = {
 	.sleep = dtt200u_fe_sleep,
 
 	.set_frontend_legacy = dtt200u_fe_set_frontend,
-	.get_frontend = dtt200u_fe_get_frontend,
+	.get_frontend_legacy = dtt200u_fe_get_frontend,
 	.get_tune_settings = dtt200u_fe_get_tune_settings,
 
 	.read_status = dtt200u_fe_read_status,
diff --git a/drivers/media/dvb/dvb-usb/friio-fe.c b/drivers/media/dvb/dvb-usb/friio-fe.c
index c98e2cc..7973aaf 100644
--- a/drivers/media/dvb/dvb-usb/friio-fe.c
+++ b/drivers/media/dvb/dvb-usb/friio-fe.c
@@ -467,7 +467,7 @@ static struct dvb_frontend_ops jdvbt90502_ops = {
 	.set_property = jdvbt90502_set_property,
 
 	.set_frontend_legacy = jdvbt90502_set_frontend,
-	.get_frontend = jdvbt90502_get_frontend,
+	.get_frontend_legacy = jdvbt90502_get_frontend,
 
 	.read_status = jdvbt90502_read_status,
 	.read_signal_strength = jdvbt90502_read_signal_strength,
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-demod.c b/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
index 6639d3a..b798cc8 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-demod.c
@@ -571,7 +571,7 @@ static struct dvb_frontend_ops mxl111sf_demod_ops = {
 	.i2c_gate_ctrl        = mxl111sf_i2c_gate_ctrl,
 #endif
 	.set_frontend_legacy         = mxl111sf_demod_set_frontend,
-	.get_frontend         = mxl111sf_demod_get_frontend,
+	.get_frontend_legacy = mxl111sf_demod_get_frontend,
 	.get_tune_settings    = mxl111sf_demod_get_tune_settings,
 	.read_status          = mxl111sf_demod_read_status,
 	.read_signal_strength = mxl111sf_demod_read_signal_strength,
diff --git a/drivers/media/dvb/dvb-usb/vp702x-fe.c b/drivers/media/dvb/dvb-usb/vp702x-fe.c
index ee2177e..8ff5aab 100644
--- a/drivers/media/dvb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp702x-fe.c
@@ -371,7 +371,7 @@ static struct dvb_frontend_ops vp702x_fe_ops = {
 	.sleep = vp702x_fe_sleep,
 
 	.set_frontend_legacy = vp702x_fe_set_frontend,
-	.get_frontend = vp702x_fe_get_frontend,
+	.get_frontend_legacy = vp702x_fe_get_frontend,
 	.get_tune_settings = vp702x_fe_get_tune_settings,
 
 	.read_status = vp702x_fe_read_status,
diff --git a/drivers/media/dvb/dvb-usb/vp7045-fe.c b/drivers/media/dvb/dvb-usb/vp7045-fe.c
index 4f708c7..f8b5d8c 100644
--- a/drivers/media/dvb/dvb-usb/vp7045-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp7045-fe.c
@@ -181,7 +181,7 @@ static struct dvb_frontend_ops vp7045_fe_ops = {
 	.sleep = vp7045_fe_sleep,
 
 	.set_frontend_legacy = vp7045_fe_set_frontend,
-	.get_frontend = vp7045_fe_get_frontend,
+	.get_frontend_legacy = vp7045_fe_get_frontend,
 	.get_tune_settings = vp7045_fe_get_tune_settings,
 
 	.read_status = vp7045_fe_read_status,
diff --git a/drivers/media/dvb/firewire/firedtv-fe.c b/drivers/media/dvb/firewire/firedtv-fe.c
index a887abc..1eb5ad3 100644
--- a/drivers/media/dvb/firewire/firedtv-fe.c
+++ b/drivers/media/dvb/firewire/firedtv-fe.c
@@ -174,7 +174,7 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 	ops->sleep			= fdtv_sleep;
 
 	ops->set_frontend_legacy	= fdtv_set_frontend;
-	ops->get_frontend		= fdtv_get_frontend;
+	ops->get_frontend_legacy = fdtv_get_frontend;
 
 	ops->get_property		= fdtv_get_property;
 	ops->set_property		= fdtv_set_property;
diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index a041d7f..540ed0f 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -1530,7 +1530,7 @@ static struct dvb_frontend_ops af9013_ops = {
 	.i2c_gate_ctrl = af9013_i2c_gate_ctrl,
 
 	.set_frontend_legacy = af9013_set_frontend,
-	.get_frontend = af9013_get_frontend,
+	.get_frontend_legacy = af9013_get_frontend,
 
 	.get_tune_settings = af9013_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/atbm8830.c b/drivers/media/dvb/frontends/atbm8830.c
index 5fc30f3..c4e0909 100644
--- a/drivers/media/dvb/frontends/atbm8830.c
+++ b/drivers/media/dvb/frontends/atbm8830.c
@@ -450,7 +450,7 @@ static struct dvb_frontend_ops atbm8830_ops = {
 	.i2c_gate_ctrl = atbm8830_i2c_gate_ctrl,
 
 	.set_frontend_legacy = atbm8830_set_fe,
-	.get_frontend = atbm8830_get_fe,
+	.get_frontend_legacy = atbm8830_get_fe,
 	.get_tune_settings = atbm8830_get_tune_settings,
 
 	.read_status = atbm8830_read_status,
diff --git a/drivers/media/dvb/frontends/au8522_dig.c b/drivers/media/dvb/frontends/au8522_dig.c
index 4b74cc8..327d6fe 100644
--- a/drivers/media/dvb/frontends/au8522_dig.c
+++ b/drivers/media/dvb/frontends/au8522_dig.c
@@ -1024,7 +1024,7 @@ static struct dvb_frontend_ops au8522_ops = {
 	.sleep                = au8522_sleep,
 	.i2c_gate_ctrl        = au8522_i2c_gate_ctrl,
 	.set_frontend_legacy         = au8522_set_frontend,
-	.get_frontend         = au8522_get_frontend,
+	.get_frontend_legacy = au8522_get_frontend,
 	.get_tune_settings    = au8522_get_tune_settings,
 	.read_status          = au8522_read_status,
 	.read_ber             = au8522_read_ber,
diff --git a/drivers/media/dvb/frontends/cx22700.c b/drivers/media/dvb/frontends/cx22700.c
index ce1e74f..7ac95de 100644
--- a/drivers/media/dvb/frontends/cx22700.c
+++ b/drivers/media/dvb/frontends/cx22700.c
@@ -420,7 +420,7 @@ static struct dvb_frontend_ops cx22700_ops = {
 	.i2c_gate_ctrl = cx22700_i2c_gate_ctrl,
 
 	.set_frontend_legacy = cx22700_set_frontend,
-	.get_frontend = cx22700_get_frontend,
+	.get_frontend_legacy = cx22700_get_frontend,
 	.get_tune_settings = cx22700_get_tune_settings,
 
 	.read_status = cx22700_read_status,
diff --git a/drivers/media/dvb/frontends/cx22702.c b/drivers/media/dvb/frontends/cx22702.c
index 2cea13e..a04cff8 100644
--- a/drivers/media/dvb/frontends/cx22702.c
+++ b/drivers/media/dvb/frontends/cx22702.c
@@ -623,7 +623,7 @@ static const struct dvb_frontend_ops cx22702_ops = {
 	.i2c_gate_ctrl = cx22702_i2c_gate_ctrl,
 
 	.set_frontend_legacy = cx22702_set_tps,
-	.get_frontend = cx22702_get_frontend,
+	.get_frontend_legacy = cx22702_get_frontend,
 	.get_tune_settings = cx22702_get_tune_settings,
 
 	.read_status = cx22702_read_status,
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index c75f9da..278034d 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -644,7 +644,7 @@ static struct dvb_frontend_ops cx24110_ops = {
 	.init = cx24110_initfe,
 	.write = _cx24110_pll_write,
 	.set_frontend_legacy = cx24110_set_frontend,
-	.get_frontend = cx24110_get_frontend,
+	.get_frontend_legacy = cx24110_get_frontend,
 	.read_status = cx24110_read_status,
 	.read_ber = cx24110_read_ber,
 	.read_signal_strength = cx24110_read_signal_strength,
diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index 1342429..96f99a8 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -1147,7 +1147,7 @@ static struct dvb_frontend_ops cx24123_ops = {
 
 	.init = cx24123_initfe,
 	.set_frontend_legacy = cx24123_set_frontend,
-	.get_frontend = cx24123_get_frontend,
+	.get_frontend_legacy = cx24123_get_frontend,
 	.read_status = cx24123_read_status,
 	.read_ber = cx24123_read_ber,
 	.read_signal_strength = cx24123_read_signal_strength,
diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index e8ace56..97bc353 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -823,7 +823,7 @@ static const struct dvb_frontend_ops cxd2820r_ops[2] = {
 		.get_tune_settings = cxd2820r_get_tune_settings,
 		.i2c_gate_ctrl = cxd2820r_i2c_gate_ctrl,
 
-		.get_frontend = cxd2820r_get_frontend,
+		.get_frontend_legacy = cxd2820r_get_frontend,
 
 		.get_frontend_algo = cxd2820r_get_frontend_algo,
 		.search = cxd2820r_search,
@@ -853,7 +853,7 @@ static const struct dvb_frontend_ops cxd2820r_ops[2] = {
 		.i2c_gate_ctrl = cxd2820r_i2c_gate_ctrl,
 
 		.set_frontend_legacy = cxd2820r_set_frontend,
-		.get_frontend = cxd2820r_get_frontend,
+		.get_frontend_legacy = cxd2820r_get_frontend,
 
 		.read_status = cxd2820r_read_status,
 		.read_snr = cxd2820r_read_snr,
diff --git a/drivers/media/dvb/frontends/dib3000mb.c b/drivers/media/dvb/frontends/dib3000mb.c
index 987eb17..77af240 100644
--- a/drivers/media/dvb/frontends/dib3000mb.c
+++ b/drivers/media/dvb/frontends/dib3000mb.c
@@ -817,7 +817,7 @@ static struct dvb_frontend_ops dib3000mb_ops = {
 	.sleep = dib3000mb_sleep,
 
 	.set_frontend_legacy = dib3000mb_set_frontend_and_tuner,
-	.get_frontend = dib3000mb_get_frontend,
+	.get_frontend_legacy = dib3000mb_get_frontend,
 	.get_tune_settings = dib3000mb_fe_get_tune_settings,
 
 	.read_status = dib3000mb_read_status,
diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb/frontends/dib3000mc.c
index 19fca6e..7ec0e02 100644
--- a/drivers/media/dvb/frontends/dib3000mc.c
+++ b/drivers/media/dvb/frontends/dib3000mc.c
@@ -920,7 +920,7 @@ static struct dvb_frontend_ops dib3000mc_ops = {
 
 	.set_frontend_legacy         = dib3000mc_set_frontend,
 	.get_tune_settings    = dib3000mc_fe_get_tune_settings,
-	.get_frontend         = dib3000mc_get_frontend,
+	.get_frontend_legacy = dib3000mc_get_frontend,
 
 	.read_status          = dib3000mc_read_status,
 	.read_ber             = dib3000mc_read_ber,
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index cc6a710..45c1105 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -1453,7 +1453,7 @@ static struct dvb_frontend_ops dib7000m_ops = {
 
 	.set_frontend_legacy         = dib7000m_set_frontend,
 	.get_tune_settings    = dib7000m_fe_get_tune_settings,
-	.get_frontend         = dib7000m_get_frontend,
+	.get_frontend_legacy = dib7000m_get_frontend,
 
 	.read_status          = dib7000m_read_status,
 	.read_ber             = dib7000m_read_ber,
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 1e81b5b..feb82b0 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -2441,7 +2441,7 @@ static struct dvb_frontend_ops dib7000p_ops = {
 
 	.set_frontend_legacy = dib7000p_set_frontend,
 	.get_tune_settings = dib7000p_fe_get_tune_settings,
-	.get_frontend = dib7000p_get_frontend,
+	.get_frontend_legacy = dib7000p_get_frontend,
 
 	.read_status = dib7000p_read_status,
 	.read_ber = dib7000p_read_ber,
diff --git a/drivers/media/dvb/frontends/dib8000.c b/drivers/media/dvb/frontends/dib8000.c
index f9c98ba..9860062 100644
--- a/drivers/media/dvb/frontends/dib8000.c
+++ b/drivers/media/dvb/frontends/dib8000.c
@@ -2824,7 +2824,7 @@ static int dib8000_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 		if (stat&FE_HAS_SYNC) {
 			dprintk("TMCC lock on the slave%i", index_frontend);
 			/* synchronize the cache with the other frontends */
-			state->fe[index_frontend]->ops.get_frontend(state->fe[index_frontend], fep);
+			state->fe[index_frontend]->ops.get_frontend_legacy(state->fe[index_frontend], fep);
 			for (sub_index_frontend = 0; (sub_index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[sub_index_frontend] != NULL); sub_index_frontend++) {
 				if (sub_index_frontend != index_frontend) {
 					state->fe[sub_index_frontend]->dtv_property_cache.isdbt_sb_mode = state->fe[index_frontend]->dtv_property_cache.isdbt_sb_mode;
@@ -3481,7 +3481,7 @@ static const struct dvb_frontend_ops dib8000_ops = {
 
 	.set_frontend_legacy = dib8000_set_frontend,
 	.get_tune_settings = dib8000_fe_get_tune_settings,
-	.get_frontend = dib8000_get_frontend,
+	.get_frontend_legacy = dib8000_get_frontend,
 
 	.read_status = dib8000_read_status,
 	.read_ber = dib8000_read_ber,
diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index c7b4910..4d82a4a 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -1883,7 +1883,7 @@ static int dib9000_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 			dprintk("TPS lock on the slave%i", index_frontend);
 
 			/* synchronize the cache with the other frontends */
-			state->fe[index_frontend]->ops.get_frontend(state->fe[index_frontend], fep);
+			state->fe[index_frontend]->ops.get_frontend_legacy(state->fe[index_frontend], fep);
 			for (sub_index_frontend = 0; (sub_index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[sub_index_frontend] != NULL);
 			     sub_index_frontend++) {
 				if (sub_index_frontend != index_frontend) {
@@ -2515,7 +2515,7 @@ static struct dvb_frontend_ops dib9000_ops = {
 
 	.set_frontend_legacy = dib9000_set_frontend,
 	.get_tune_settings = dib9000_fe_get_tune_settings,
-	.get_frontend = dib9000_get_frontend,
+	.get_frontend_legacy = dib9000_get_frontend,
 
 	.read_status = dib9000_read_status,
 	.read_ber = dib9000_read_ber,
diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index 8118bb3..ca05a24 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -2957,7 +2957,7 @@ static struct dvb_frontend_ops drxd_ops = {
 	.i2c_gate_ctrl = drxd_i2c_gate_ctrl,
 
 	.set_frontend_legacy = drxd_set_frontend,
-	.get_frontend = drxd_get_frontend,
+	.get_frontend_legacy = drxd_get_frontend,
 	.get_tune_settings = drxd_get_tune_settings,
 
 	.read_status = drxd_read_status,
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 1205944..2299e1d3 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6407,7 +6407,7 @@ static struct dvb_frontend_ops drxk_c_ops = {
 	.i2c_gate_ctrl = drxk_gate_ctrl,
 
 	.set_frontend_legacy = drxk_set_parameters,
-	.get_frontend = drxk_c_get_frontend,
+	.get_frontend_legacy = drxk_c_get_frontend,
 	.get_property = drxk_c_get_property,
 	.get_tune_settings = drxk_c_get_tune_settings,
 
@@ -6440,7 +6440,7 @@ static struct dvb_frontend_ops drxk_t_ops = {
 	.i2c_gate_ctrl = drxk_gate_ctrl,
 
 	.set_frontend_legacy = drxk_set_parameters,
-	.get_frontend = drxk_t_get_frontend,
+	.get_frontend_legacy = drxk_t_get_frontend,
 	.get_property = drxk_t_get_property,
 
 	.read_status = drxk_read_status,
diff --git a/drivers/media/dvb/frontends/dvb_dummy_fe.c b/drivers/media/dvb/frontends/dvb_dummy_fe.c
index 322bcd7..31e1dd6 100644
--- a/drivers/media/dvb/frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb/frontends/dvb_dummy_fe.c
@@ -193,7 +193,7 @@ static struct dvb_frontend_ops dvb_dummy_fe_ofdm_ops = {
 	.sleep = dvb_dummy_fe_sleep,
 
 	.set_frontend_legacy = dvb_dummy_fe_set_frontend,
-	.get_frontend = dvb_dummy_fe_get_frontend,
+	.get_frontend_legacy = dvb_dummy_fe_get_frontend,
 
 	.read_status = dvb_dummy_fe_read_status,
 	.read_ber = dvb_dummy_fe_read_ber,
@@ -223,7 +223,7 @@ static struct dvb_frontend_ops dvb_dummy_fe_qam_ops = {
 	.sleep = dvb_dummy_fe_sleep,
 
 	.set_frontend_legacy = dvb_dummy_fe_set_frontend,
-	.get_frontend = dvb_dummy_fe_get_frontend,
+	.get_frontend_legacy = dvb_dummy_fe_get_frontend,
 
 	.read_status = dvb_dummy_fe_read_status,
 	.read_ber = dvb_dummy_fe_read_ber,
@@ -255,7 +255,7 @@ static struct dvb_frontend_ops dvb_dummy_fe_qpsk_ops = {
 	.sleep = dvb_dummy_fe_sleep,
 
 	.set_frontend_legacy = dvb_dummy_fe_set_frontend,
-	.get_frontend = dvb_dummy_fe_get_frontend,
+	.get_frontend_legacy = dvb_dummy_fe_get_frontend,
 
 	.read_status = dvb_dummy_fe_read_status,
 	.read_ber = dvb_dummy_fe_read_ber,
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 54d8534..a13f897 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -940,7 +940,7 @@ static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
 	.sleep = it913x_fe_sleep,
 
 	.set_frontend_legacy = it913x_fe_set_frontend,
-	.get_frontend = it913x_fe_get_frontend,
+	.get_frontend_legacy = it913x_fe_get_frontend,
 
 	.read_status = it913x_fe_read_status,
 	.read_signal_strength = it913x_fe_read_signal_strength,
diff --git a/drivers/media/dvb/frontends/l64781.c b/drivers/media/dvb/frontends/l64781.c
index fd4170a..1f1c598 100644
--- a/drivers/media/dvb/frontends/l64781.c
+++ b/drivers/media/dvb/frontends/l64781.c
@@ -585,7 +585,7 @@ static struct dvb_frontend_ops l64781_ops = {
 	.sleep = l64781_sleep,
 
 	.set_frontend_legacy = apply_frontend_param,
-	.get_frontend = get_frontend,
+	.get_frontend_legacy = get_frontend,
 	.get_tune_settings = l64781_get_tune_settings,
 
 	.read_status = l64781_read_status,
diff --git a/drivers/media/dvb/frontends/lgdt3305.c b/drivers/media/dvb/frontends/lgdt3305.c
index 8f15178..e1a9c92 100644
--- a/drivers/media/dvb/frontends/lgdt3305.c
+++ b/drivers/media/dvb/frontends/lgdt3305.c
@@ -1177,7 +1177,7 @@ static struct dvb_frontend_ops lgdt3304_ops = {
 	.i2c_gate_ctrl        = lgdt3305_i2c_gate_ctrl,
 	.init                 = lgdt3305_init,
 	.set_frontend_legacy         = lgdt3304_set_parameters,
-	.get_frontend         = lgdt3305_get_frontend,
+	.get_frontend_legacy = lgdt3305_get_frontend,
 	.get_tune_settings    = lgdt3305_get_tune_settings,
 	.read_status          = lgdt3305_read_status,
 	.read_ber             = lgdt3305_read_ber,
@@ -1200,7 +1200,7 @@ static struct dvb_frontend_ops lgdt3305_ops = {
 	.init                 = lgdt3305_init,
 	.sleep                = lgdt3305_sleep,
 	.set_frontend_legacy         = lgdt3305_set_parameters,
-	.get_frontend         = lgdt3305_get_frontend,
+	.get_frontend_legacy = lgdt3305_get_frontend,
 	.get_tune_settings    = lgdt3305_get_tune_settings,
 	.read_status          = lgdt3305_read_status,
 	.read_ber             = lgdt3305_read_ber,
diff --git a/drivers/media/dvb/frontends/lgdt330x.c b/drivers/media/dvb/frontends/lgdt330x.c
index bdae349..21bffc0 100644
--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -774,7 +774,7 @@ static struct dvb_frontend_ops lgdt3302_ops = {
 	},
 	.init                 = lgdt330x_init,
 	.set_frontend_legacy         = lgdt330x_set_parameters,
-	.get_frontend         = lgdt330x_get_frontend,
+	.get_frontend_legacy = lgdt330x_get_frontend,
 	.get_tune_settings    = lgdt330x_get_tune_settings,
 	.read_status          = lgdt3302_read_status,
 	.read_ber             = lgdt330x_read_ber,
@@ -797,7 +797,7 @@ static struct dvb_frontend_ops lgdt3303_ops = {
 	},
 	.init                 = lgdt330x_init,
 	.set_frontend_legacy         = lgdt330x_set_parameters,
-	.get_frontend         = lgdt330x_get_frontend,
+	.get_frontend_legacy = lgdt330x_get_frontend,
 	.get_tune_settings    = lgdt330x_get_tune_settings,
 	.read_status          = lgdt3303_read_status,
 	.read_ber             = lgdt330x_read_ber,
diff --git a/drivers/media/dvb/frontends/lgs8gl5.c b/drivers/media/dvb/frontends/lgs8gl5.c
index 65a5c5d..f4e82a6 100644
--- a/drivers/media/dvb/frontends/lgs8gl5.c
+++ b/drivers/media/dvb/frontends/lgs8gl5.c
@@ -435,7 +435,7 @@ static struct dvb_frontend_ops lgs8gl5_ops = {
 	.init = lgs8gl5_init,
 
 	.set_frontend_legacy = lgs8gl5_set_frontend,
-	.get_frontend = lgs8gl5_get_frontend,
+	.get_frontend_legacy = lgs8gl5_get_frontend,
 	.get_tune_settings = lgs8gl5_get_tune_settings,
 
 	.read_status = lgs8gl5_read_status,
diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index 5684b61..05bfa05 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -1014,7 +1014,7 @@ static struct dvb_frontend_ops lgs8gxx_ops = {
 	.i2c_gate_ctrl = lgs8gxx_i2c_gate_ctrl,
 
 	.set_frontend_legacy = lgs8gxx_set_fe,
-	.get_frontend = lgs8gxx_get_fe,
+	.get_frontend_legacy = lgs8gxx_get_fe,
 	.get_tune_settings = lgs8gxx_get_tune_settings,
 
 	.read_status = lgs8gxx_read_status,
diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index 3ae6d1f..2dfea6c 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -628,7 +628,7 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 
 	.init = mb86a20s_initfe,
 	.set_frontend_legacy = mb86a20s_set_frontend,
-	.get_frontend = mb86a20s_get_frontend,
+	.get_frontend_legacy = mb86a20s_get_frontend,
 	.read_status = mb86a20s_read_status,
 	.read_signal_strength = mb86a20s_read_signal_strength,
 	.tune = mb86a20s_tune,
diff --git a/drivers/media/dvb/frontends/mt312.c b/drivers/media/dvb/frontends/mt312.c
index efae45f..8f5d2d2 100644
--- a/drivers/media/dvb/frontends/mt312.c
+++ b/drivers/media/dvb/frontends/mt312.c
@@ -762,7 +762,7 @@ static struct dvb_frontend_ops mt312_ops = {
 	.i2c_gate_ctrl = mt312_i2c_gate_ctrl,
 
 	.set_frontend_legacy = mt312_set_frontend,
-	.get_frontend = mt312_get_frontend,
+	.get_frontend_legacy = mt312_get_frontend,
 	.get_tune_settings = mt312_get_tune_settings,
 
 	.read_status = mt312_read_status,
diff --git a/drivers/media/dvb/frontends/mt352.c b/drivers/media/dvb/frontends/mt352.c
index 2bd68c5..021108d 100644
--- a/drivers/media/dvb/frontends/mt352.c
+++ b/drivers/media/dvb/frontends/mt352.c
@@ -593,7 +593,7 @@ static struct dvb_frontend_ops mt352_ops = {
 	.write = _mt352_write,
 
 	.set_frontend_legacy = mt352_set_parameters,
-	.get_frontend = mt352_get_parameters,
+	.get_frontend_legacy = mt352_get_parameters,
 	.get_tune_settings = mt352_get_tune_settings,
 
 	.read_status = mt352_read_status,
diff --git a/drivers/media/dvb/frontends/or51132.c b/drivers/media/dvb/frontends/or51132.c
index 461f9fd..e0c952c 100644
--- a/drivers/media/dvb/frontends/or51132.c
+++ b/drivers/media/dvb/frontends/or51132.c
@@ -598,7 +598,7 @@ static struct dvb_frontend_ops or51132_ops = {
 	.sleep = or51132_sleep,
 
 	.set_frontend_legacy = or51132_set_parameters,
-	.get_frontend = or51132_get_parameters,
+	.get_frontend_legacy = or51132_get_parameters,
 	.get_tune_settings = or51132_get_tune_settings,
 
 	.read_status = or51132_read_status,
diff --git a/drivers/media/dvb/frontends/s5h1409.c b/drivers/media/dvb/frontends/s5h1409.c
index 0b6e6c5..f39216c 100644
--- a/drivers/media/dvb/frontends/s5h1409.c
+++ b/drivers/media/dvb/frontends/s5h1409.c
@@ -1009,7 +1009,7 @@ static struct dvb_frontend_ops s5h1409_ops = {
 	.init                 = s5h1409_init,
 	.i2c_gate_ctrl        = s5h1409_i2c_gate_ctrl,
 	.set_frontend_legacy         = s5h1409_set_frontend,
-	.get_frontend         = s5h1409_get_frontend,
+	.get_frontend_legacy = s5h1409_get_frontend,
 	.get_tune_settings    = s5h1409_get_tune_settings,
 	.read_status          = s5h1409_read_status,
 	.read_ber             = s5h1409_read_ber,
diff --git a/drivers/media/dvb/frontends/s5h1411.c b/drivers/media/dvb/frontends/s5h1411.c
index 67ab85c..cb221aa 100644
--- a/drivers/media/dvb/frontends/s5h1411.c
+++ b/drivers/media/dvb/frontends/s5h1411.c
@@ -929,7 +929,7 @@ static struct dvb_frontend_ops s5h1411_ops = {
 	.sleep                = s5h1411_sleep,
 	.i2c_gate_ctrl        = s5h1411_i2c_gate_ctrl,
 	.set_frontend_legacy         = s5h1411_set_frontend,
-	.get_frontend         = s5h1411_get_frontend,
+	.get_frontend_legacy = s5h1411_get_frontend,
 	.get_tune_settings    = s5h1411_get_tune_settings,
 	.read_status          = s5h1411_read_status,
 	.read_ber             = s5h1411_read_ber,
diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
index e2cecf4..44ec27d 100644
--- a/drivers/media/dvb/frontends/s5h1420.c
+++ b/drivers/media/dvb/frontends/s5h1420.c
@@ -961,7 +961,7 @@ static struct dvb_frontend_ops s5h1420_ops = {
 	.i2c_gate_ctrl = s5h1420_i2c_gate_ctrl,
 
 	.set_frontend_legacy = s5h1420_set_frontend,
-	.get_frontend = s5h1420_get_frontend,
+	.get_frontend_legacy = s5h1420_get_frontend,
 	.get_tune_settings = s5h1420_get_tune_settings,
 
 	.read_status = s5h1420_read_status,
diff --git a/drivers/media/dvb/frontends/s5h1432.c b/drivers/media/dvb/frontends/s5h1432.c
index a0dbbdc..f22c71e 100644
--- a/drivers/media/dvb/frontends/s5h1432.c
+++ b/drivers/media/dvb/frontends/s5h1432.c
@@ -397,7 +397,7 @@ static struct dvb_frontend_ops s5h1432_ops = {
 	.init = s5h1432_init,
 	.sleep = s5h1432_sleep,
 	.set_frontend_legacy = s5h1432_set_frontend,
-	.get_frontend = s5h1432_get_frontend,
+	.get_frontend_legacy = s5h1432_get_frontend,
 	.get_tune_settings = s5h1432_get_tune_settings,
 	.read_status = s5h1432_read_status,
 	.read_ber = s5h1432_read_ber,
diff --git a/drivers/media/dvb/frontends/s921.c b/drivers/media/dvb/frontends/s921.c
index 6615979..5e8f2a8 100644
--- a/drivers/media/dvb/frontends/s921.c
+++ b/drivers/media/dvb/frontends/s921.c
@@ -535,7 +535,7 @@ static struct dvb_frontend_ops s921_ops = {
 
 	.init = s921_initfe,
 	.set_frontend_legacy = s921_set_frontend,
-	.get_frontend = s921_get_frontend,
+	.get_frontend_legacy = s921_get_frontend,
 	.read_status = s921_read_status,
 	.read_signal_strength = s921_read_signal_strength,
 	.tune = s921_tune,
diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
index 9c93d9f..9fa31d5 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -1648,7 +1648,7 @@ static struct dvb_frontend_ops stb0899_ops = {
 	.get_frontend_algo		= stb0899_frontend_algo,
 	.search				= stb0899_search,
 	.track				= stb0899_track,
-	.get_frontend			= stb0899_get_frontend,
+	.get_frontend_legacy = stb0899_get_frontend,
 
 
 	.read_status			= stb0899_read_status,
diff --git a/drivers/media/dvb/frontends/stb6100.c b/drivers/media/dvb/frontends/stb6100.c
index bc1a8af..7f68fd3 100644
--- a/drivers/media/dvb/frontends/stb6100.c
+++ b/drivers/media/dvb/frontends/stb6100.c
@@ -335,9 +335,9 @@ static int stb6100_set_frequency(struct dvb_frontend *fe, u32 frequency)
 
 	dprintk(verbose, FE_DEBUG, 1, "Version 2010-8-14 13:51");
 
-	if (fe->ops.get_frontend) {
+	if (fe->ops.get_frontend_legacy) {
 		dprintk(verbose, FE_DEBUG, 1, "Get frontend parameters");
-		fe->ops.get_frontend(fe, &p);
+		fe->ops.get_frontend_legacy(fe, &p);
 	}
 	srate = p.u.qpsk.symbol_rate;
 
diff --git a/drivers/media/dvb/frontends/stv0297.c b/drivers/media/dvb/frontends/stv0297.c
index 63a3e1b..5d7c288 100644
--- a/drivers/media/dvb/frontends/stv0297.c
+++ b/drivers/media/dvb/frontends/stv0297.c
@@ -707,7 +707,7 @@ static struct dvb_frontend_ops stv0297_ops = {
 	.i2c_gate_ctrl = stv0297_i2c_gate_ctrl,
 
 	.set_frontend_legacy = stv0297_set_frontend,
-	.get_frontend = stv0297_get_frontend,
+	.get_frontend_legacy = stv0297_get_frontend,
 
 	.read_status = stv0297_read_status,
 	.read_ber = stv0297_read_ber,
diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index 4f248e1..6aeabaf 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -730,7 +730,7 @@ static struct dvb_frontend_ops stv0299_ops = {
 	.i2c_gate_ctrl = stv0299_i2c_gate_ctrl,
 
 	.set_frontend_legacy = stv0299_set_frontend,
-	.get_frontend = stv0299_get_frontend,
+	.get_frontend_legacy = stv0299_get_frontend,
 	.get_tune_settings = stv0299_get_tune_settings,
 
 	.read_status = stv0299_read_status,
diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index 7752d13..e0a2438 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -2286,7 +2286,7 @@ static struct dvb_frontend_ops stv0367ter_ops = {
 	.sleep = stv0367ter_sleep,
 	.i2c_gate_ctrl = stv0367ter_gate_ctrl,
 	.set_frontend_legacy = stv0367ter_set_frontend,
-	.get_frontend = stv0367ter_get_frontend,
+	.get_frontend_legacy = stv0367ter_get_frontend,
 	.get_tune_settings = stv0367_get_tune_settings,
 	.read_status = stv0367ter_read_status,
 	.read_ber = stv0367ter_read_ber,/* too slow */
@@ -3404,7 +3404,7 @@ static struct dvb_frontend_ops stv0367cab_ops = {
 	.sleep					= stv0367cab_sleep,
 	.i2c_gate_ctrl				= stv0367cab_gate_ctrl,
 	.set_frontend_legacy				= stv0367cab_set_frontend,
-	.get_frontend				= stv0367cab_get_frontend,
+	.get_frontend_legacy = stv0367cab_get_frontend,
 	.read_status				= stv0367cab_read_status,
 /*	.read_ber				= stv0367cab_read_ber, */
 	.read_signal_strength			= stv0367cab_read_strength,
diff --git a/drivers/media/dvb/frontends/stv0900_core.c b/drivers/media/dvb/frontends/stv0900_core.c
index 2b8d78c..df46654 100644
--- a/drivers/media/dvb/frontends/stv0900_core.c
+++ b/drivers/media/dvb/frontends/stv0900_core.c
@@ -1908,7 +1908,7 @@ static struct dvb_frontend_ops stv0900_ops = {
 	},
 	.release			= stv0900_release,
 	.init				= stv0900_init,
-	.get_frontend                   = stv0900_get_frontend,
+	.get_frontend_legacy = stv0900_get_frontend,
 	.sleep				= stv0900_sleep,
 	.get_frontend_algo		= stv0900_frontend_algo,
 	.i2c_gate_ctrl			= stv0900_i2c_gate_ctrl,
diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index 0bbf681..3976d22 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -525,7 +525,7 @@ static struct dvb_frontend_ops tda10021_ops = {
 	.i2c_gate_ctrl = tda10021_i2c_gate_ctrl,
 
 	.set_frontend_legacy = tda10021_set_parameters,
-	.get_frontend = tda10021_get_frontend,
+	.get_frontend_legacy = tda10021_get_frontend,
 	.get_property = tda10021_get_property,
 
 	.read_status = tda10021_read_status,
diff --git a/drivers/media/dvb/frontends/tda10023.c b/drivers/media/dvb/frontends/tda10023.c
index f79841b..de535a4 100644
--- a/drivers/media/dvb/frontends/tda10023.c
+++ b/drivers/media/dvb/frontends/tda10023.c
@@ -610,7 +610,7 @@ static struct dvb_frontend_ops tda10023_ops = {
 	.i2c_gate_ctrl = tda10023_i2c_gate_ctrl,
 
 	.set_frontend_legacy = tda10023_set_parameters,
-	.get_frontend = tda10023_get_frontend,
+	.get_frontend_legacy = tda10023_get_frontend,
 	.get_property = tda10023_get_property,
 	.read_status = tda10023_read_status,
 	.read_ber = tda10023_read_ber,
diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb/frontends/tda10048.c
index 479ff85..bba249b 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -1189,7 +1189,7 @@ static struct dvb_frontend_ops tda10048_ops = {
 	.init = tda10048_init,
 	.i2c_gate_ctrl = tda10048_i2c_gate_ctrl,
 	.set_frontend_legacy = tda10048_set_frontend,
-	.get_frontend = tda10048_get_frontend,
+	.get_frontend_legacy = tda10048_get_frontend,
 	.get_tune_settings = tda10048_get_tune_settings,
 	.read_status = tda10048_read_status,
 	.read_ber = tda10048_read_ber,
diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index dd41057..2dbb070 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -1252,7 +1252,7 @@ static struct dvb_frontend_ops tda10045_ops = {
 	.i2c_gate_ctrl = tda1004x_i2c_gate_ctrl,
 
 	.set_frontend_legacy = tda1004x_set_fe,
-	.get_frontend = tda1004x_get_fe,
+	.get_frontend_legacy = tda1004x_get_fe,
 	.get_tune_settings = tda1004x_get_tune_settings,
 
 	.read_status = tda1004x_read_status,
@@ -1322,7 +1322,7 @@ static struct dvb_frontend_ops tda10046_ops = {
 	.i2c_gate_ctrl = tda1004x_i2c_gate_ctrl,
 
 	.set_frontend_legacy = tda1004x_set_fe,
-	.get_frontend = tda1004x_get_fe,
+	.get_frontend_legacy = tda1004x_get_fe,
 	.get_tune_settings = tda1004x_get_tune_settings,
 
 	.read_status = tda1004x_read_status,
diff --git a/drivers/media/dvb/frontends/tda10071.c b/drivers/media/dvb/frontends/tda10071.c
index 7bffa65..e9e00ea 100644
--- a/drivers/media/dvb/frontends/tda10071.c
+++ b/drivers/media/dvb/frontends/tda10071.c
@@ -1248,7 +1248,7 @@ static struct dvb_frontend_ops tda10071_ops = {
 	.sleep = tda10071_sleep,
 
 	.set_frontend_legacy = tda10071_set_frontend,
-	.get_frontend = tda10071_get_frontend,
+	.get_frontend_legacy = tda10071_get_frontend,
 
 	.read_status = tda10071_read_status,
 	.read_snr = tda10071_read_snr,
diff --git a/drivers/media/dvb/frontends/tda10086.c b/drivers/media/dvb/frontends/tda10086.c
index be4649f..8501100 100644
--- a/drivers/media/dvb/frontends/tda10086.c
+++ b/drivers/media/dvb/frontends/tda10086.c
@@ -723,7 +723,7 @@ static struct dvb_frontend_ops tda10086_ops = {
 	.i2c_gate_ctrl = tda10086_i2c_gate_ctrl,
 
 	.set_frontend_legacy = tda10086_set_frontend,
-	.get_frontend = tda10086_get_frontend,
+	.get_frontend_legacy = tda10086_get_frontend,
 	.get_tune_settings = tda10086_get_tune_settings,
 
 	.read_status = tda10086_read_status,
diff --git a/drivers/media/dvb/frontends/tda8083.c b/drivers/media/dvb/frontends/tda8083.c
index 9d1466f..7ff2946 100644
--- a/drivers/media/dvb/frontends/tda8083.c
+++ b/drivers/media/dvb/frontends/tda8083.c
@@ -462,7 +462,7 @@ static struct dvb_frontend_ops tda8083_ops = {
 	.sleep = tda8083_sleep,
 
 	.set_frontend_legacy = tda8083_set_frontend,
-	.get_frontend = tda8083_get_frontend,
+	.get_frontend_legacy = tda8083_get_frontend,
 
 	.read_status = tda8083_read_status,
 	.read_signal_strength = tda8083_read_signal_strength,
diff --git a/drivers/media/dvb/frontends/ves1820.c b/drivers/media/dvb/frontends/ves1820.c
index 6fb8eb5..7961231 100644
--- a/drivers/media/dvb/frontends/ves1820.c
+++ b/drivers/media/dvb/frontends/ves1820.c
@@ -426,7 +426,7 @@ static struct dvb_frontend_ops ves1820_ops = {
 	.sleep = ves1820_sleep,
 
 	.set_frontend_legacy = ves1820_set_parameters,
-	.get_frontend = ves1820_get_frontend,
+	.get_frontend_legacy = ves1820_get_frontend,
 	.get_tune_settings = ves1820_get_tune_settings,
 
 	.read_status = ves1820_read_status,
diff --git a/drivers/media/dvb/frontends/ves1x93.c b/drivers/media/dvb/frontends/ves1x93.c
index f80f152..a95619e 100644
--- a/drivers/media/dvb/frontends/ves1x93.c
+++ b/drivers/media/dvb/frontends/ves1x93.c
@@ -530,7 +530,7 @@ static struct dvb_frontend_ops ves1x93_ops = {
 	.i2c_gate_ctrl = ves1x93_i2c_gate_ctrl,
 
 	.set_frontend_legacy = ves1x93_set_frontend,
-	.get_frontend = ves1x93_get_frontend,
+	.get_frontend_legacy = ves1x93_get_frontend,
 
 	.read_status = ves1x93_read_status,
 	.read_ber = ves1x93_read_ber,
diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
index 8b6c2a4..35334da 100644
--- a/drivers/media/dvb/frontends/zl10353.c
+++ b/drivers/media/dvb/frontends/zl10353.c
@@ -676,7 +676,7 @@ static struct dvb_frontend_ops zl10353_ops = {
 	.write = zl10353_write,
 
 	.set_frontend_legacy = zl10353_set_parameters,
-	.get_frontend = zl10353_get_parameters,
+	.get_frontend_legacy = zl10353_get_parameters,
 	.get_tune_settings = zl10353_get_tune_settings,
 
 	.read_status = zl10353_read_status,
diff --git a/drivers/media/dvb/siano/smsdvb.c b/drivers/media/dvb/siano/smsdvb.c
index fa17f02..df08d6a 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -806,7 +806,7 @@ static struct dvb_frontend_ops smsdvb_fe_ops = {
 	.release = smsdvb_release,
 
 	.set_frontend_legacy = smsdvb_set_frontend,
-	.get_frontend = smsdvb_get_frontend,
+	.get_frontend_legacy = smsdvb_get_frontend,
 	.get_tune_settings = smsdvb_get_tune_settings,
 
 	.read_status = smsdvb_read_status,
diff --git a/drivers/media/video/tlg2300/pd-dvb.c b/drivers/media/video/tlg2300/pd-dvb.c
index 51a7d55..f864c17 100644
--- a/drivers/media/video/tlg2300/pd-dvb.c
+++ b/drivers/media/video/tlg2300/pd-dvb.c
@@ -354,7 +354,7 @@ static struct dvb_frontend_ops poseidon_frontend_ops = {
 	.sleep = poseidon_fe_sleep,
 
 	.set_frontend_legacy = poseidon_set_fe,
-	.get_frontend = poseidon_get_fe,
+	.get_frontend_legacy = poseidon_get_fe,
 	.get_tune_settings = poseidon_fe_get_tune_settings,
 
 	.read_status	= poseidon_read_status,
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index 161bcbe..b0c5128 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -297,7 +297,7 @@ static struct dvb_frontend_ops as102_fe_ops = {
 	},
 
 	.set_frontend_legacy	= as102_fe_set_frontend,
-	.get_frontend		= as102_fe_get_frontend,
+	.get_frontend_legacy	= as102_fe_get_frontend,
 	.get_tune_settings	= as102_fe_get_tune_settings,
 
 	.read_status		= as102_fe_read_status,
-- 
1.7.8.352.g876a6

