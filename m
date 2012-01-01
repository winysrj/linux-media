Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab2AAULY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jan 2012 15:11:24 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q01KBOM0002857
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Jan 2012 15:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/9] [media] dvb_frontend: Don't use ops->info.type anymore
Date: Sun,  1 Jan 2012 18:11:13 -0200
Message-Id: <1325448678-13001-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of using ops->info.type defined on DVB drivers,
as it doesn't apply anymore.

Currently, one driver (cxd2820) supports more than one different
info.type, as it can be used for DVB-T/T2 and DVB-C. There are more
drivers like that to come. So, the same frontend will have
different DVBv3 types, depending on the current delivery system.

This breaks the existing logic at dvb_frontend, that assumes that
just one delivery system DVBv3 type is supported by all delsys.

In order to easy the DVBv3->DVBv5 conversion, an ancillary function
that maps DVBv3 delivery systems into DVBv5 were added.

Also, on all places, except for the event logic, the DVBv5 cache
will be used to check parameters, instead of the DVBv5 copy.

This patch simplifies the cache sync logic, and warrants that the
cache will be in a clear state at DVB frontend register. This way,
ops->info.type will be filled to reflect the first delivery system,
providing backward compatibility support for it.

For example, in the cases like cxd2820, where the delivery systems
are defined as:
        .delsys = { SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A },

A pure DVBv3 will be able to use both DVB-T and DVB-T2, as, at
DVB cache clear, the ops->info.type will be equal to FE_OFDM.

However, DVB-C won't be visible. A quick workaround would be to
do a DVBv5 call to set the delivery system to SYS_DVBC_ANNEX_A.

After such call, ops->info.type will be equal to FE_QAM, and a
DVBv3 application will see the frontend as a DVB-C one.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |  541 ++++++++++++++---------------
 1 files changed, 266 insertions(+), 275 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index eefcb7f..7f6ce06 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -150,6 +150,55 @@ static bool has_get_frontend(struct dvb_frontend *fe)
 	return fe->ops.get_frontend;
 }
 
+/*
+ * Due to DVBv3 API calls, a delivery system should be mapped into one of
+ * the 4 DVBv3 delivery systems (FE_QPSK, FE_QAM, FE_OFDM or FE_ATSC),
+ * otherwise, a DVBv3 call will fail.
+ */
+enum dvbv3_emulation_type {
+	DVBV3_UNKNOWN,
+	DVBV3_QPSK,
+	DVBV3_QAM,
+	DVBV3_OFDM,
+	DVBV3_ATSC,
+};
+
+static enum dvbv3_emulation_type dvbv3_type(u32 delivery_system)
+{
+	switch (delivery_system) {
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_C:
+		return DVBV3_QAM;
+	case SYS_DVBS:
+	case SYS_DVBS2:
+	case SYS_TURBO:
+	case SYS_ISDBS:
+	case SYS_DSS:
+		return DVBV3_QPSK;
+	case SYS_DVBT:
+	case SYS_DVBT2:
+	case SYS_ISDBT:
+	case SYS_DMBTH:
+		return DVBV3_OFDM;
+	case SYS_ATSC:
+	case SYS_DVBC_ANNEX_B:
+		return DVBV3_ATSC;
+	case SYS_UNDEFINED:
+	case SYS_ISDBC:
+	case SYS_DVBH:
+	case SYS_DAB:
+	case SYS_ATSCMH:
+	default:
+		/*
+		 * Doesn't know how to emulate those types and/or
+		 * there's no frontend driver from this type yet
+		 * with some emulation code, so, we're not sure yet how
+		 * to handle them, or they're not compatible with a DVBv3 call.
+		 */
+		return DVBV3_UNKNOWN;
+	}
+}
+
 static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -814,52 +863,63 @@ static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
 		       fe->dvb->num,fe->id);
 }
 
-static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *parms)
+static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 freq_min;
 	u32 freq_max;
 
 	/* range check: frequency */
 	dvb_frontend_get_frequency_limits(fe, &freq_min, &freq_max);
-	if ((freq_min && parms->frequency < freq_min) ||
-	    (freq_max && parms->frequency > freq_max)) {
+	if ((freq_min && c->frequency < freq_min) ||
+	    (freq_max && c->frequency > freq_max)) {
 		printk(KERN_WARNING "DVB: adapter %i frontend %i frequency %u out of range (%u..%u)\n",
-		       fe->dvb->num, fe->id, parms->frequency, freq_min, freq_max);
+		       fe->dvb->num, fe->id, c->frequency, freq_min, freq_max);
 		return -EINVAL;
 	}
 
 	/* range check: symbol rate */
-	if (fe->ops.info.type == FE_QPSK) {
-		if ((fe->ops.info.symbol_rate_min &&
-		     parms->u.qpsk.symbol_rate < fe->ops.info.symbol_rate_min) ||
-		    (fe->ops.info.symbol_rate_max &&
-		     parms->u.qpsk.symbol_rate > fe->ops.info.symbol_rate_max)) {
-			printk(KERN_WARNING "DVB: adapter %i frontend %i symbol rate %u out of range (%u..%u)\n",
-			       fe->dvb->num, fe->id, parms->u.qpsk.symbol_rate,
-			       fe->ops.info.symbol_rate_min, fe->ops.info.symbol_rate_max);
-			return -EINVAL;
-		}
-
-	} else if (fe->ops.info.type == FE_QAM) {
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+	case SYS_DVBS2:
+	case SYS_TURBO:
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_C:
 		if ((fe->ops.info.symbol_rate_min &&
-		     parms->u.qam.symbol_rate < fe->ops.info.symbol_rate_min) ||
+		     c->symbol_rate < fe->ops.info.symbol_rate_min) ||
 		    (fe->ops.info.symbol_rate_max &&
-		     parms->u.qam.symbol_rate > fe->ops.info.symbol_rate_max)) {
+		     c->symbol_rate > fe->ops.info.symbol_rate_max)) {
 			printk(KERN_WARNING "DVB: adapter %i frontend %i symbol rate %u out of range (%u..%u)\n",
-			       fe->dvb->num, fe->id, parms->u.qam.symbol_rate,
-			       fe->ops.info.symbol_rate_min, fe->ops.info.symbol_rate_max);
+			       fe->dvb->num, fe->id, c->symbol_rate,
+			       fe->ops.info.symbol_rate_min,
+			       fe->ops.info.symbol_rate_max);
 			return -EINVAL;
 		}
+	default:
+		break;
 	}
 
-	/* check for supported modulation */
-	if (fe->ops.info.type == FE_QAM &&
-	    (parms->u.qam.modulation > QAM_AUTO ||
-	     !((1 << (parms->u.qam.modulation + 10)) & fe->ops.info.caps))) {
-		printk(KERN_WARNING "DVB: adapter %i frontend %i modulation %u not supported\n",
-		       fe->dvb->num, fe->id, parms->u.qam.modulation);
+	/*
+	 * check for supported modulation
+	 *
+	 * This is currently hacky. Also, it only works for DVB-S & friends,
+	 * and not all modulations has FE_CAN flags
+	 */
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+	case SYS_DVBS2:
+	case SYS_TURBO:
+		if ((c->modulation > QAM_AUTO ||
+		    !((1 << (c->modulation + 10)) & fe->ops.info.caps))) {
+			printk(KERN_WARNING
+			       "DVB: adapter %i frontend %i modulation %u not supported\n",
+			       fe->dvb->num, fe->id, c->modulation);
 			return -EINVAL;
+		}
+		break;
+	default:
+		/* FIXME: it makes sense to validate othere delsys here */
+		break;
 	}
 
 	return 0;
@@ -875,6 +935,8 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	c->state = DTV_CLEAR;
 
 	c->delivery_system = fe->ops.delsys[0];
+	dprintk("%s() Clearing cache for delivery system %d\n", __func__,
+		c->delivery_system);
 
 	c->transmission_mode = TRANSMISSION_MODE_AUTO;
 	c->bandwidth_hz = 0;	/* AUTO */
@@ -886,7 +948,6 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	c->fec_inner = FEC_AUTO;
 	c->rolloff = ROLLOFF_AUTO;
 	c->voltage = SEC_VOLTAGE_OFF;
-	c->modulation = QAM_AUTO;
 	c->sectone = SEC_TONE_OFF;
 	c->pilot = PILOT_AUTO;
 
@@ -906,6 +967,21 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	c->isdbs_ts_id = 0;
 	c->dvbt2_plp_id = 0;
 
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+	case SYS_DVBS2:
+	case SYS_TURBO:
+		c->modulation = QPSK;   /* implied for DVB-S in legacy API */
+		c->rolloff = ROLLOFF_35;/* implied for DVB-S */
+		break;
+	case SYS_ATSC:
+		c->modulation = VSB_8;
+		break;
+	default:
+		c->modulation = QAM_AUTO;
+		break;
+	}
+
 	return 0;
 }
 
@@ -1024,61 +1100,31 @@ static void dtv_property_dump(struct dtv_property *tvp)
 		dprintk("%s() tvp.u.data = 0x%08x\n", __func__, tvp->u.data);
 }
 
-static int is_legacy_delivery_system(fe_delivery_system_t s)
-{
-	if((s == SYS_UNDEFINED) || (s == SYS_DVBC_ANNEX_A) ||
-	   (s == SYS_DVBC_ANNEX_B) || (s == SYS_DVBT) || (s == SYS_DVBS) ||
-	   (s == SYS_ATSC))
-		return 1;
-
-	return 0;
-}
-
-/* Initialize the cache with some default values derived from the
- * legacy frontend_info structure.
- */
-static void dtv_property_cache_init(struct dvb_frontend *fe,
-				    struct dtv_frontend_properties *c)
-{
-	switch (fe->ops.info.type) {
-	case FE_QPSK:
-		c->modulation = QPSK;   /* implied for DVB-S in legacy API */
-		c->rolloff = ROLLOFF_35;/* implied for DVB-S */
-		c->delivery_system = SYS_DVBS;
-		break;
-	case FE_QAM:
-		c->delivery_system = SYS_DVBC_ANNEX_A;
-		break;
-	case FE_OFDM:
-		c->delivery_system = SYS_DVBT;
-		break;
-	case FE_ATSC:
-		break;
-	}
-}
-
 /* Synchronise the legacy tuning parameters into the cache, so that demodulator
  * drivers can use a single set_frontend tuning function, regardless of whether
  * it's being used for the legacy or new API, reducing code and complexity.
  */
-static void dtv_property_cache_sync(struct dvb_frontend *fe,
-				    struct dtv_frontend_properties *c,
-				    const struct dvb_frontend_parameters *p)
+static int dtv_property_cache_sync(struct dvb_frontend *fe,
+				   struct dtv_frontend_properties *c,
+				   const struct dvb_frontend_parameters *p)
 {
 	c->frequency = p->frequency;
 	c->inversion = p->inversion;
 
-	switch (fe->ops.info.type) {
-	case FE_QPSK:
+	switch (dvbv3_type(c->delivery_system)) {
+	case DVBV3_QPSK:
+		dprintk("%s() Preparing QPSK req\n", __func__);
 		c->symbol_rate = p->u.qpsk.symbol_rate;
 		c->fec_inner = p->u.qpsk.fec_inner;
 		break;
-	case FE_QAM:
+	case DVBV3_QAM:
+		dprintk("%s() Preparing QAM req\n", __func__);
 		c->symbol_rate = p->u.qam.symbol_rate;
 		c->fec_inner = p->u.qam.fec_inner;
 		c->modulation = p->u.qam.modulation;
 		break;
-	case FE_OFDM:
+	case DVBV3_OFDM:
+		dprintk("%s() Preparing OFDM req\n", __func__);
 		switch (p->u.ofdm.bandwidth) {
 		case BANDWIDTH_10_MHZ:
 			c->bandwidth_hz = 10000000;
@@ -1109,20 +1155,28 @@ static void dtv_property_cache_sync(struct dvb_frontend *fe,
 		c->guard_interval = p->u.ofdm.guard_interval;
 		c->hierarchy = p->u.ofdm.hierarchy_information;
 		break;
-	case FE_ATSC:
+	case DVBV3_ATSC:
+		dprintk("%s() Preparing ATSC req\n", __func__);
 		c->modulation = p->u.vsb.modulation;
 		if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
 			c->delivery_system = SYS_ATSC;
 		else
 			c->delivery_system = SYS_DVBC_ANNEX_B;
 		break;
+	case DVBV3_UNKNOWN:
+		printk(KERN_ERR
+		       "%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
+		       __func__, c->delivery_system);
+		return -EINVAL;
 	}
+
+	return 0;
 }
 
 /* Ensure the cached values are set correctly in the frontend
  * legacy tuning structures, for the advanced tuning API.
  */
-static void dtv_property_legacy_params_sync(struct dvb_frontend *fe,
+static int dtv_property_legacy_params_sync(struct dvb_frontend *fe,
 					    struct dvb_frontend_parameters *p)
 {
 	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -1130,20 +1184,26 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe,
 	p->frequency = c->frequency;
 	p->inversion = c->inversion;
 
-	switch (fe->ops.info.type) {
-	case FE_QPSK:
+	switch (dvbv3_type(c->delivery_system)) {
+	case DVBV3_UNKNOWN:
+		printk(KERN_ERR
+		       "%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
+		       __func__, c->delivery_system);
+		return -EINVAL;
+	case DVBV3_QPSK:
 		dprintk("%s() Preparing QPSK req\n", __func__);
 		p->u.qpsk.symbol_rate = c->symbol_rate;
 		p->u.qpsk.fec_inner = c->fec_inner;
 		break;
-	case FE_QAM:
+	case DVBV3_QAM:
 		dprintk("%s() Preparing QAM req\n", __func__);
 		p->u.qam.symbol_rate = c->symbol_rate;
 		p->u.qam.fec_inner = c->fec_inner;
 		p->u.qam.modulation = c->modulation;
 		break;
-	case FE_OFDM:
+	case DVBV3_OFDM:
 		dprintk("%s() Preparing OFDM req\n", __func__);
+
 		switch (c->bandwidth_hz) {
 		case 10000000:
 			p->u.ofdm.bandwidth = BANDWIDTH_10_MHZ;
@@ -1174,116 +1234,12 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe,
 		p->u.ofdm.guard_interval = c->guard_interval;
 		p->u.ofdm.hierarchy_information = c->hierarchy;
 		break;
-	case FE_ATSC:
+	case DVBV3_ATSC:
 		dprintk("%s() Preparing VSB req\n", __func__);
 		p->u.vsb.modulation = c->modulation;
 		break;
 	}
-}
-
-/* Ensure the cached values are set correctly in the frontend
- * legacy tuning structures, for the legacy tuning API.
- */
-static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dvb_frontend_parameters *p = &fepriv->parameters_in;
-	u32 rolloff = 0;
-
-	p->frequency = c->frequency;
-	p->inversion = c->inversion;
-
-	if (c->delivery_system == SYS_DSS ||
-	    c->delivery_system == SYS_DVBS ||
-	    c->delivery_system == SYS_DVBS2 ||
-	    c->delivery_system == SYS_ISDBS ||
-	    c->delivery_system == SYS_TURBO) {
-		p->u.qpsk.symbol_rate = c->symbol_rate;
-		p->u.qpsk.fec_inner = c->fec_inner;
-	}
-
-	/* Fake out a generic DVB-T request so we pass validation in the ioctl */
-	if ((c->delivery_system == SYS_ISDBT) ||
-	    (c->delivery_system == SYS_DVBT2)) {
-		p->u.ofdm.constellation = QAM_AUTO;
-		p->u.ofdm.code_rate_HP = FEC_AUTO;
-		p->u.ofdm.code_rate_LP = FEC_AUTO;
-		p->u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;
-		p->u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
-		p->u.ofdm.hierarchy_information = HIERARCHY_AUTO;
-		if (c->bandwidth_hz == 8000000)
-			p->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
-		else if (c->bandwidth_hz == 7000000)
-			p->u.ofdm.bandwidth = BANDWIDTH_7_MHZ;
-		else if (c->bandwidth_hz == 6000000)
-			p->u.ofdm.bandwidth = BANDWIDTH_6_MHZ;
-		else
-			p->u.ofdm.bandwidth = BANDWIDTH_AUTO;
-	}
-
-	/*
-	 * Be sure that the bandwidth will be filled for all
-	 * non-satellite systems, as tuners need to know what
-	 * low pass/Nyquist half filter should be applied, in
-	 * order to avoid inter-channel noise.
-	 *
-	 * ISDB-T and DVB-T/T2 already sets bandwidth.
-	 * ATSC and DVB-C don't set, so, the core should fill it.
-	 *
-	 * On DVB-C Annex A and C, the bandwidth is a function of
-	 * the roll-off and symbol rate. Annex B defines different
-	 * roll-off factors depending on the modulation. Fortunately,
-	 * Annex B is only used with 6MHz, so there's no need to
-	 * calculate it.
-	 *
-	 * While not officially supported, a side effect of handling it at
-	 * the cache level is that a program could retrieve the bandwidth
-	 * via DTV_BANDWIDTH_HZ, which may be useful for test programs.
-	 */
-	switch (c->delivery_system) {
-	case SYS_ATSC:
-	case SYS_DVBC_ANNEX_B:
-		c->bandwidth_hz = 6000000;
-		break;
-	case SYS_DVBC_ANNEX_A:
-		rolloff = 115;
-		break;
-	case SYS_DVBC_ANNEX_C:
-		rolloff = 113;
-		break;
-	default:
-		break;
-	}
-	if (rolloff)
-		c->bandwidth_hz = (c->symbol_rate * rolloff) / 100;
-}
-
-static void dtv_property_cache_submit(struct dvb_frontend *fe)
-{
-	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-
-	/* For legacy delivery systems we don't need the delivery_system to
-	 * be specified, but we populate the older structures from the cache
-	 * so we can call set_frontend on older drivers.
-	 */
-	if(is_legacy_delivery_system(c->delivery_system)) {
-
-		dprintk("%s() legacy, modulation = %d\n", __func__, c->modulation);
-		dtv_property_legacy_params_sync(fe, &fepriv->parameters_in);
-
-	} else {
-		dprintk("%s() adv, modulation = %d\n", __func__, c->modulation);
-
-		/* For advanced delivery systems / modulation types ...
-		 * we seed the lecacy dvb_frontend_parameters structure
-		 * so that the sanity checking code later in the IOCTL processing
-		 * can validate our basic frequency ranges, symbolrates, modulation
-		 * etc.
-		 */
-		dtv_property_adv_params_sync(fe);
-	}
+	return 0;
 }
 
 /**
@@ -1319,59 +1275,21 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 static int dvb_frontend_ioctl_properties(struct file *file,
 			unsigned int cmd, void *parg);
 
-static void dtv_set_default_delivery_caps(const struct dvb_frontend *fe, struct dtv_property *p)
-{
-	const struct dvb_frontend_info *info = &fe->ops.info;
-	u32 ncaps = 0;
-
-	/*
-	 * If the frontend explicitly sets a list, use it, instead of
-	 * filling based on the info->type
-	 */
-	if (fe->ops.delsys[ncaps]) {
-		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
-			p->u.buffer.data[ncaps] = fe->ops.delsys[ncaps];
-			ncaps++;
-		}
-		p->u.buffer.len = ncaps;
-		return;
-	}
-	switch (info->type) {
-	case FE_QPSK:
-		p->u.buffer.data[ncaps++] = SYS_DVBS;
-		if (info->caps & FE_CAN_2G_MODULATION)
-			p->u.buffer.data[ncaps++] = SYS_DVBS2;
-		if (info->caps & FE_CAN_TURBO_FEC)
-			p->u.buffer.data[ncaps++] = SYS_TURBO;
-		break;
-	case FE_QAM:
-		p->u.buffer.data[ncaps++] = SYS_DVBC_ANNEX_A;
-		break;
-	case FE_OFDM:
-		p->u.buffer.data[ncaps++] = SYS_DVBT;
-		if (info->caps & FE_CAN_2G_MODULATION)
-			p->u.buffer.data[ncaps++] = SYS_DVBT2;
-		break;
-	case FE_ATSC:
-		if (info->caps & (FE_CAN_8VSB | FE_CAN_16VSB))
-			p->u.buffer.data[ncaps++] = SYS_ATSC;
-		if (info->caps & (FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_128 | FE_CAN_QAM_256))
-			p->u.buffer.data[ncaps++] = SYS_DVBC_ANNEX_B;
-		break;
-	}
-	p->u.buffer.len = ncaps;
-}
-
 static int dtv_property_process_get(struct dvb_frontend *fe,
 				    const struct dtv_frontend_properties *c,
 				    struct dtv_property *tvp,
 				    struct file *file)
 {
-	int r;
+	int r, ncaps;
 
 	switch(tvp->cmd) {
 	case DTV_ENUM_DELSYS:
-		dtv_set_default_delivery_caps(fe, tvp);
+		ncaps = 0;
+		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+			tvp->u.buffer.data[ncaps] = fe->ops.delsys[ncaps];
+			ncaps++;
+		}
+		tvp->u.buffer.len = ncaps;
 		break;
 	case DTV_FREQUENCY:
 		tvp->u.data = c->frequency;
@@ -1502,6 +1420,8 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 	return 0;
 }
 
+static int dtv_set_frontend(struct dvb_frontend *fe);
+
 static int dtv_property_process_set(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
 				    struct file *file)
@@ -1520,11 +1440,11 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 
 	switch(tvp->cmd) {
 	case DTV_CLEAR:
-		/* Reset a cache of data specific to the frontend here. This does
+		/*
+		 * Reset a cache of data specific to the frontend here. This does
 		 * not effect hardware.
 		 */
 		dvb_frontend_clear_cache(fe);
-		dprintk("%s() Flushing property cache\n", __func__);
 		break;
 	case DTV_TUNE:
 		/* interpret the cache of data, build either a traditional frontend
@@ -1533,10 +1453,11 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		 */
 		c->state = tvp->cmd;
 		dprintk("%s() Finalised property cache\n", __func__);
-		dtv_property_cache_submit(fe);
 
-		r = dvb_frontend_ioctl_legacy(file, FE_SET_FRONTEND,
-			&fepriv->parameters_in);
+		/* Needed, due to status update */
+		dtv_property_legacy_params_sync(fe, &fepriv->parameters_in);
+
+		r = dtv_set_frontend(fe);
 		break;
 	case DTV_FREQUENCY:
 		c->frequency = tvp->u.data;
@@ -1786,76 +1707,102 @@ out:
 	return err;
 }
 
-static int dtv_set_frontend(struct file *file, unsigned int cmd, void *parg)
+static int dtv_set_frontend(struct dvb_frontend *fe)
 {
-	struct dvb_device *dvbdev = file->private_data;
-	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_tune_settings fetunesettings;
+	u32 rolloff = 0;
 
-	if (c->state == DTV_TUNE) {
-		if (dvb_frontend_check_parameters(fe, &fepriv->parameters_in) < 0)
-			return -EINVAL;
-	} else {
-		if (dvb_frontend_check_parameters(fe, parg) < 0)
-			return -EINVAL;
-
-		memcpy (&fepriv->parameters_in, parg,
-			sizeof (struct dvb_frontend_parameters));
-		dtv_property_cache_init(fe, c);
-		dtv_property_cache_sync(fe, c, &fepriv->parameters_in);
-	}
+	if (dvb_frontend_check_parameters(fe) < 0)
+		return -EINVAL;
 
 	/*
-		* Initialize output parameters to match the values given by
-		* the user. FE_SET_FRONTEND triggers an initial frontend event
-		* with status = 0, which copies output parameters to userspace.
-		*/
+	 * Initialize output parameters to match the values given by
+	 * the user. FE_SET_FRONTEND triggers an initial frontend event
+	 * with status = 0, which copies output parameters to userspace.
+	 *
+	 * This is still needed for DVBv5 calls, due to event state update.
+	 */
 	fepriv->parameters_out = fepriv->parameters_in;
 
-	memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
+	/*
+	 * Be sure that the bandwidth will be filled for all
+	 * non-satellite systems, as tuners need to know what
+	 * low pass/Nyquist half filter should be applied, in
+	 * order to avoid inter-channel noise.
+	 *
+	 * ISDB-T and DVB-T/T2 already sets bandwidth.
+	 * ATSC and DVB-C don't set, so, the core should fill it.
+	 *
+	 * On DVB-C Annex A and C, the bandwidth is a function of
+	 * the roll-off and symbol rate. Annex B defines different
+	 * roll-off factors depending on the modulation. Fortunately,
+	 * Annex B is only used with 6MHz, so there's no need to
+	 * calculate it.
+	 *
+	 * While not officially supported, a side effect of handling it at
+	 * the cache level is that a program could retrieve the bandwidth
+	 * via DTV_BANDWIDTH_HZ, which may be useful for test programs.
+	 */
+	switch (c->delivery_system) {
+	case SYS_ATSC:
+	case SYS_DVBC_ANNEX_B:
+		c->bandwidth_hz = 6000000;
+		break;
+	case SYS_DVBC_ANNEX_A:
+		rolloff = 115;
+		break;
+	case SYS_DVBC_ANNEX_C:
+		rolloff = 113;
+		break;
+	default:
+		break;
+	}
+	if (rolloff)
+		c->bandwidth_hz = (c->symbol_rate * rolloff) / 100;
 
 	/* force auto frequency inversion if requested */
-	if (dvb_force_auto_inversion) {
+	if (dvb_force_auto_inversion)
 		c->inversion = INVERSION_AUTO;
-	}
-	if (fe->ops.info.type == FE_OFDM) {
-		/* without hierarchical coding code_rate_LP is irrelevant,
-			* so we tolerate the otherwise invalid FEC_NONE setting */
-		if (c->hierarchy == HIERARCHY_NONE &&
-			c->code_rate_LP == FEC_NONE)
-			c->code_rate_LP = FEC_AUTO;
-	}
+
+	/*
+	 * without hierarchical coding code_rate_LP is irrelevant,
+	 * so we tolerate the otherwise invalid FEC_NONE setting
+	 */
+	if (c->hierarchy == HIERARCHY_NONE && c->code_rate_LP == FEC_NONE)
+		c->code_rate_LP = FEC_AUTO;
 
 	/* get frontend-specific tuning settings */
+	memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
 	if (fe->ops.get_tune_settings && (fe->ops.get_tune_settings(fe, &fetunesettings) == 0)) {
 		fepriv->min_delay = (fetunesettings.min_delay_ms * HZ) / 1000;
 		fepriv->max_drift = fetunesettings.max_drift;
 		fepriv->step_size = fetunesettings.step_size;
 	} else {
 		/* default values */
-		switch(fe->ops.info.type) {
-		case FE_QPSK:
-			fepriv->min_delay = HZ/20;
+		switch (c->delivery_system) {
+		case SYS_DVBC_ANNEX_A:
+		case SYS_DVBC_ANNEX_C:
+			fepriv->min_delay = HZ / 20;
 			fepriv->step_size = c->symbol_rate / 16000;
 			fepriv->max_drift = c->symbol_rate / 2000;
 			break;
-
-		case FE_QAM:
-			fepriv->min_delay = HZ/20;
-			fepriv->step_size = 0; /* no zigzag */
-			fepriv->max_drift = 0;
-			break;
-
-		case FE_OFDM:
-			fepriv->min_delay = HZ/20;
+		case SYS_DVBT:
+		case SYS_DVBT2:
+		case SYS_ISDBT:
+		case SYS_DMBTH:
+			fepriv->min_delay = HZ / 20;
 			fepriv->step_size = fe->ops.info.frequency_stepsize * 2;
 			fepriv->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
 			break;
-		case FE_ATSC:
-			fepriv->min_delay = HZ/20;
-			fepriv->step_size = 0;
+		default:
+			/*
+			 * FIXME: This sounds wrong! if freqency_stepsize is
+			 * defined by the frontend, why not use it???
+			 */
+			fepriv->min_delay = HZ / 20;
+			fepriv->step_size = 0; /* no zigzag */
 			fepriv->max_drift = 0;
 			break;
 		}
@@ -1883,6 +1830,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int cb_err, err = -EOPNOTSUPP;
 
 	if (fe->dvb->fe_ioctl_override) {
@@ -1902,6 +1850,37 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
 		dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
 
+		/*
+		 * Associate the 4 delivery systems supported by DVBv3
+		 * API with their DVBv5 counterpart. For the other standards,
+		 * use the closest type, assuming that it would hopefully
+		 * work with a DVBv3 application.
+		 * It should be noticed that, on multi-frontend devices with
+		 * different types (terrestrial and cable, for example),
+		 * a pure DVBv3 application won't be able to use all delivery
+		 * systems. Yet, changing the DVBv5 cache to the other delivery
+		 * system should be enough for making it work.
+		 */
+		switch (dvbv3_type(c->delivery_system)) {
+		case DVBV3_QPSK:
+			fe->ops.info.type = FE_QPSK;
+			break;
+		case DVBV3_ATSC:
+			fe->ops.info.type = FE_ATSC;
+			break;
+		case DVBV3_QAM:
+			fe->ops.info.type = FE_QAM;
+			break;
+		case DVBV3_OFDM:
+			fe->ops.info.type = FE_OFDM;
+			break;
+		default:
+			printk(KERN_ERR
+			       "%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
+			       __func__, c->delivery_system);
+			fe->ops.info.type = FE_OFDM;
+		}
+
 		/* Force the CAN_INVERSION_AUTO bit on. If the frontend doesn't
 		 * do it, it is done for it. */
 		info->caps |= FE_CAN_INVERSION_AUTO;
@@ -2061,7 +2040,13 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		break;
 
 	case FE_SET_FRONTEND:
-		err = dtv_set_frontend(file, cmd, parg);
+		/* Synchronise DVBv5 parameters from DVBv3 */
+		memcpy (&fepriv->parameters_in, parg,
+			sizeof (struct dvb_frontend_parameters));
+		err = dtv_property_cache_sync(fe, c, &fepriv->parameters_in);
+		if (err)
+			break;
+		err = dtv_set_frontend(fe);
 		break;
 	case FE_GET_EVENT:
 		err = dvb_frontend_get_event (fe, parg, file->f_flags);
@@ -2281,6 +2266,12 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 	dvb_register_device (fe->dvb, &fepriv->dvbdev, &dvbdev_template,
 			     fe, DVB_DEVICE_FRONTEND);
 
+	/*
+	 * Initialize the cache to the proper values according with the
+	 * first supported delivery system (ops->delsys[0])
+	 */
+	dvb_frontend_clear_cache(fe);
+
 	mutex_unlock(&frontend_mutex);
 	return 0;
 }
-- 
1.7.8.352.g876a6

