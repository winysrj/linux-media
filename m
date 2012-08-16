Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60225 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820Ab2HPA3P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 20:29:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/5] dvb_frontend: use Kernel dev_* logging
Date: Thu, 16 Aug 2012 03:28:37 +0300
Message-Id: <1345076921-9773-2-git-send-email-crope@iki.fi>
In-Reply-To: <1345076921-9773-1-git-send-email-crope@iki.fi>
References: <1345076921-9773-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb_frontend.c | 226 +++++++++++++++++-----------------
 1 file changed, 116 insertions(+), 110 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index aa4d4d8..609e691 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -66,8 +66,6 @@ MODULE_PARM_DESC(dvb_powerdown_on_sleep, "0: do not power down, 1: turn LNB volt
 module_param(dvb_mfe_wait_time, int, 0644);
 MODULE_PARM_DESC(dvb_mfe_wait_time, "Wait up to <mfe_wait_time> seconds on open() for multi-frontend to become available (default:5 seconds)");
 
-#define dprintk if (dvb_frontend_debug) printk
-
 #define FESTATE_IDLE 1
 #define FESTATE_RETUNE 2
 #define FESTATE_TUNING_FAST 4
@@ -207,7 +205,7 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 	struct dvb_frontend_event *e;
 	int wp;
 
-	dprintk ("%s\n", __func__);
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	if ((status & FE_HAS_LOCK) && has_get_frontend(fe))
 		dtv_get_frontend(fe, &fepriv->parameters_out);
@@ -237,7 +235,7 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dvb_fe_events *events = &fepriv->events;
 
-	dprintk ("%s\n", __func__);
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	if (events->overflow) {
 		events->overflow = 0;
@@ -282,10 +280,9 @@ static void dvb_frontend_clear_events(struct dvb_frontend *fe)
 
 static void dvb_frontend_init(struct dvb_frontend *fe)
 {
-	dprintk ("DVB: initialising adapter %i frontend %i (%s)...\n",
-		 fe->dvb->num,
-		 fe->id,
-		 fe->ops.info.name);
+	dev_dbg(fe->dvb->device,
+			"%s: initialising adapter %i frontend %i (%s)...\n",
+			__func__, fe->dvb->num, fe->id, fe->ops.info.name);
 
 	if (fe->ops.init)
 		fe->ops.init(fe);
@@ -310,8 +307,9 @@ EXPORT_SYMBOL(dvb_frontend_reinitialise);
 static void dvb_frontend_swzigzag_update_delay(struct dvb_frontend_private *fepriv, int locked)
 {
 	int q2;
+	struct dvb_frontend *fe = fepriv->dvbdev->priv;
 
-	dprintk ("%s\n", __func__);
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	if (locked)
 		(fepriv->quality) = (fepriv->quality * 220 + 36*256) / 256;
@@ -403,10 +401,11 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 		return 1;
 	}
 
-	dprintk("%s: drift:%i inversion:%i auto_step:%i "
-		"auto_sub_step:%i started_auto_step:%i\n",
-		__func__, fepriv->lnb_drift, fepriv->inversion,
-		fepriv->auto_step, fepriv->auto_sub_step, fepriv->started_auto_step);
+	dev_dbg(fe->dvb->device, "%s: drift:%i inversion:%i auto_step:%i " \
+			"auto_sub_step:%i started_auto_step:%i\n",
+			__func__, fepriv->lnb_drift, fepriv->inversion,
+			fepriv->auto_step, fepriv->auto_sub_step,
+			fepriv->started_auto_step);
 
 	/* set the frontend itself */
 	c->frequency += fepriv->lnb_drift;
@@ -605,7 +604,7 @@ static int dvb_frontend_thread(void *data)
 
 	bool re_tune = false;
 
-	dprintk("%s\n", __func__);
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	fepriv->check_wrapped = 0;
 	fepriv->quality = 0;
@@ -651,10 +650,10 @@ restart:
 			algo = fe->ops.get_frontend_algo(fe);
 			switch (algo) {
 			case DVBFE_ALGO_HW:
-				dprintk("%s: Frontend ALGO = DVBFE_ALGO_HW\n", __func__);
+				dev_dbg(fe->dvb->device, "%s: Frontend ALGO = DVBFE_ALGO_HW\n", __func__);
 
 				if (fepriv->state & FESTATE_RETUNE) {
-					dprintk("%s: Retune requested, FESTATE_RETUNE\n", __func__);
+					dev_dbg(fe->dvb->device, "%s: Retune requested, FESTATE_RETUNE\n", __func__);
 					re_tune = true;
 					fepriv->state = FESTATE_TUNED;
 				} else {
@@ -665,19 +664,19 @@ restart:
 					fe->ops.tune(fe, re_tune, fepriv->tune_mode_flags, &fepriv->delay, &s);
 
 				if (s != fepriv->status && !(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT)) {
-					dprintk("%s: state changed, adding current state\n", __func__);
+					dev_dbg(fe->dvb->device, "%s: state changed, adding current state\n", __func__);
 					dvb_frontend_add_event(fe, s);
 					fepriv->status = s;
 				}
 				break;
 			case DVBFE_ALGO_SW:
-				dprintk("%s: Frontend ALGO = DVBFE_ALGO_SW\n", __func__);
+				dev_dbg(fe->dvb->device, "%s: Frontend ALGO = DVBFE_ALGO_SW\n", __func__);
 				dvb_frontend_swzigzag(fe);
 				break;
 			case DVBFE_ALGO_CUSTOM:
-				dprintk("%s: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=%d\n", __func__, fepriv->state);
+				dev_dbg(fe->dvb->device, "%s: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=%d\n", __func__, fepriv->state);
 				if (fepriv->state & FESTATE_RETUNE) {
-					dprintk("%s: Retune requested, FESTAT_RETUNE\n", __func__);
+					dev_dbg(fe->dvb->device, "%s: Retune requested, FESTAT_RETUNE\n", __func__);
 					fepriv->state = FESTATE_TUNED;
 				}
 				/* Case where we are going to search for a carrier
@@ -713,7 +712,7 @@ restart:
 				}
 				break;
 			default:
-				dprintk("%s: UNDEFINED ALGO !\n", __func__);
+				dev_dbg(fe->dvb->device, "%s: UNDEFINED ALGO !\n", __func__);
 				break;
 			}
 		} else {
@@ -750,7 +749,7 @@ static void dvb_frontend_stop(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	dprintk ("%s\n", __func__);
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	fepriv->exit = DVB_FE_NORMAL_EXIT;
 	mb();
@@ -765,7 +764,8 @@ static void dvb_frontend_stop(struct dvb_frontend *fe)
 
 	/* paranoia check in case a signal arrived */
 	if (fepriv->thread)
-		printk("dvb_frontend_stop: warning: thread %p won't exit\n",
+		dev_warn(fe->dvb->device,
+				"dvb_frontend_stop: warning: thread %p won't exit\n",
 				fepriv->thread);
 }
 
@@ -818,7 +818,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct task_struct *fe_thread;
 
-	dprintk ("%s\n", __func__);
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	if (fepriv->thread) {
 		if (fepriv->exit == DVB_FE_NO_EXIT)
@@ -841,7 +841,9 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 		"kdvb-ad-%i-fe-%i", fe->dvb->num,fe->id);
 	if (IS_ERR(fe_thread)) {
 		ret = PTR_ERR(fe_thread);
-		printk("dvb_frontend_start: failed to start kthread (%d)\n", ret);
+		dev_warn(fe->dvb->device,
+				"dvb_frontend_start: failed to start kthread (%d)\n",
+				ret);
 		up(&fepriv->sem);
 		return ret;
 	}
@@ -862,8 +864,8 @@ static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
 		*freq_max = min(fe->ops.info.frequency_max, fe->ops.tuner_ops.info.frequency_max);
 
 	if (*freq_min == 0 || *freq_max == 0)
-		printk(KERN_WARNING "DVB: adapter %i frontend %u frequency limits undefined - fix the driver\n",
-		       fe->dvb->num,fe->id);
+		dev_warn(fe->dvb->device, "DVB: adapter %i frontend %u frequency limits undefined - fix the driver\n",
+				fe->dvb->num, fe->id);
 }
 
 static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
@@ -876,8 +878,9 @@ static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
 	dvb_frontend_get_frequency_limits(fe, &freq_min, &freq_max);
 	if ((freq_min && c->frequency < freq_min) ||
 	    (freq_max && c->frequency > freq_max)) {
-		printk(KERN_WARNING "DVB: adapter %i frontend %i frequency %u out of range (%u..%u)\n",
-		       fe->dvb->num, fe->id, c->frequency, freq_min, freq_max);
+		dev_warn(fe->dvb->device, "DVB: adapter %i frontend %i frequency %u out of range (%u..%u)\n",
+				fe->dvb->num, fe->id, c->frequency,
+				freq_min, freq_max);
 		return -EINVAL;
 	}
 
@@ -892,10 +895,10 @@ static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
 		     c->symbol_rate < fe->ops.info.symbol_rate_min) ||
 		    (fe->ops.info.symbol_rate_max &&
 		     c->symbol_rate > fe->ops.info.symbol_rate_max)) {
-			printk(KERN_WARNING "DVB: adapter %i frontend %i symbol rate %u out of range (%u..%u)\n",
-			       fe->dvb->num, fe->id, c->symbol_rate,
-			       fe->ops.info.symbol_rate_min,
-			       fe->ops.info.symbol_rate_max);
+			dev_warn(fe->dvb->device, "DVB: adapter %i frontend %i symbol rate %u out of range (%u..%u)\n",
+					fe->dvb->num, fe->id, c->symbol_rate,
+					fe->ops.info.symbol_rate_min,
+					fe->ops.info.symbol_rate_max);
 			return -EINVAL;
 		}
 	default:
@@ -917,8 +920,8 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 
 	c->state = DTV_CLEAR;
 
-	dprintk("%s() Clearing cache for delivery system %d\n", __func__,
-		c->delivery_system);
+	dev_dbg(fe->dvb->device, "%s: Clearing cache for delivery system %d\n",
+			__func__, c->delivery_system);
 
 	c->transmission_mode = TRANSMISSION_MODE_AUTO;
 	c->bandwidth_hz = 0;	/* AUTO */
@@ -1053,35 +1056,31 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_D, 0, 0),
 };
 
-static void dtv_property_dump(struct dtv_property *tvp)
+static void dtv_property_dump(struct dvb_frontend *fe, struct dtv_property *tvp)
 {
 	int i;
 
 	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
-		printk(KERN_WARNING "%s: tvp.cmd = 0x%08x undefined\n",
-			__func__, tvp->cmd);
+		dev_warn(fe->dvb->device, "%s: tvp.cmd = 0x%08x undefined\n",
+				__func__, tvp->cmd);
 		return;
 	}
 
-	dprintk("%s() tvp.cmd    = 0x%08x (%s)\n"
-		,__func__
-		,tvp->cmd
-		,dtv_cmds[ tvp->cmd ].name);
-
-	if(dtv_cmds[ tvp->cmd ].buffer) {
+	dev_dbg(fe->dvb->device, "%s: tvp.cmd    = 0x%08x (%s)\n", __func__,
+			tvp->cmd, dtv_cmds[tvp->cmd].name);
 
-		dprintk("%s() tvp.u.buffer.len = 0x%02x\n"
-			,__func__
-			,tvp->u.buffer.len);
+	if (dtv_cmds[tvp->cmd].buffer) {
+		dev_dbg(fe->dvb->device, "%s: tvp.u.buffer.len = 0x%02x\n",
+			__func__, tvp->u.buffer.len);
 
 		for(i = 0; i < tvp->u.buffer.len; i++)
-			dprintk("%s() tvp.u.buffer.data[0x%02x] = 0x%02x\n"
-				,__func__
-				,i
-				,tvp->u.buffer.data[i]);
-
-	} else
-		dprintk("%s() tvp.u.data = 0x%08x\n", __func__, tvp->u.data);
+			dev_dbg(fe->dvb->device,
+					"%s: tvp.u.buffer.data[0x%02x] = 0x%02x\n",
+					__func__, i, tvp->u.buffer.data[i]);
+	} else {
+		dev_dbg(fe->dvb->device, "%s: tvp.u.data = 0x%08x\n", __func__,
+				tvp->u.data);
+	}
 }
 
 /* Synchronise the legacy tuning parameters into the cache, so that demodulator
@@ -1097,18 +1096,19 @@ static int dtv_property_cache_sync(struct dvb_frontend *fe,
 
 	switch (dvbv3_type(c->delivery_system)) {
 	case DVBV3_QPSK:
-		dprintk("%s() Preparing QPSK req\n", __func__);
+		dev_dbg(fe->dvb->device, "%s: Preparing QPSK req\n", __func__);
 		c->symbol_rate = p->u.qpsk.symbol_rate;
 		c->fec_inner = p->u.qpsk.fec_inner;
 		break;
 	case DVBV3_QAM:
-		dprintk("%s() Preparing QAM req\n", __func__);
+		dev_dbg(fe->dvb->device, "%s: Preparing QAM req\n", __func__);
 		c->symbol_rate = p->u.qam.symbol_rate;
 		c->fec_inner = p->u.qam.fec_inner;
 		c->modulation = p->u.qam.modulation;
 		break;
 	case DVBV3_OFDM:
-		dprintk("%s() Preparing OFDM req\n", __func__);
+		dev_dbg(fe->dvb->device, "%s: Preparing OFDM req\n", __func__);
+
 		switch (p->u.ofdm.bandwidth) {
 		case BANDWIDTH_10_MHZ:
 			c->bandwidth_hz = 10000000;
@@ -1140,7 +1140,7 @@ static int dtv_property_cache_sync(struct dvb_frontend *fe,
 		c->hierarchy = p->u.ofdm.hierarchy_information;
 		break;
 	case DVBV3_ATSC:
-		dprintk("%s() Preparing ATSC req\n", __func__);
+		dev_dbg(fe->dvb->device, "%s: Preparing ATSC req\n", __func__);
 		c->modulation = p->u.vsb.modulation;
 		if (c->delivery_system == SYS_ATSCMH)
 			break;
@@ -1150,9 +1150,9 @@ static int dtv_property_cache_sync(struct dvb_frontend *fe,
 			c->delivery_system = SYS_DVBC_ANNEX_B;
 		break;
 	case DVBV3_UNKNOWN:
-		printk(KERN_ERR
-		       "%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
-		       __func__, c->delivery_system);
+		dev_err(fe->dvb->device,
+				"%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
+				__func__, c->delivery_system);
 		return -EINVAL;
 	}
 
@@ -1172,24 +1172,23 @@ static int dtv_property_legacy_params_sync(struct dvb_frontend *fe,
 
 	switch (dvbv3_type(c->delivery_system)) {
 	case DVBV3_UNKNOWN:
-		printk(KERN_ERR
-		       "%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
-		       __func__, c->delivery_system);
+		dev_err(fe->dvb->device,
+				"%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
+				__func__, c->delivery_system);
 		return -EINVAL;
 	case DVBV3_QPSK:
-		dprintk("%s() Preparing QPSK req\n", __func__);
+		dev_dbg(fe->dvb->device, "%s: Preparing QPSK req\n", __func__);
 		p->u.qpsk.symbol_rate = c->symbol_rate;
 		p->u.qpsk.fec_inner = c->fec_inner;
 		break;
 	case DVBV3_QAM:
-		dprintk("%s() Preparing QAM req\n", __func__);
+		dev_dbg(fe->dvb->device, "%s: Preparing QAM req\n", __func__);
 		p->u.qam.symbol_rate = c->symbol_rate;
 		p->u.qam.fec_inner = c->fec_inner;
 		p->u.qam.modulation = c->modulation;
 		break;
 	case DVBV3_OFDM:
-		dprintk("%s() Preparing OFDM req\n", __func__);
-
+		dev_dbg(fe->dvb->device, "%s: Preparing OFDM req\n", __func__);
 		switch (c->bandwidth_hz) {
 		case 10000000:
 			p->u.ofdm.bandwidth = BANDWIDTH_10_MHZ;
@@ -1221,7 +1220,7 @@ static int dtv_property_legacy_params_sync(struct dvb_frontend *fe,
 		p->u.ofdm.hierarchy_information = c->hierarchy;
 		break;
 	case DVBV3_ATSC:
-		dprintk("%s() Preparing VSB req\n", __func__);
+		dev_dbg(fe->dvb->device, "%s: Preparing VSB req\n", __func__);
 		p->u.vsb.modulation = c->modulation;
 		break;
 	}
@@ -1452,7 +1451,7 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 			return r;
 	}
 
-	dtv_property_dump(tvp);
+	dtv_property_dump(fe, tvp);
 
 	return 0;
 }
@@ -1497,8 +1496,9 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 		 * DVBv3 system that matches the delivery system.
 		 */
 		if (is_dvbv3_delsys(c->delivery_system)) {
-			dprintk("%s() Using delivery system to %d\n",
-				__func__, c->delivery_system);
+			dev_dbg(fe->dvb->device,
+					"%s: Using delivery system to %d\n",
+					__func__, c->delivery_system);
 			return 0;
 		}
 		type = dvbv3_type(c->delivery_system);
@@ -1516,8 +1516,8 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 			desired_system = SYS_DVBT;
 			break;
 		default:
-			dprintk("%s(): This frontend doesn't support DVBv3 calls\n",
-				__func__);
+			dev_dbg(fe->dvb->device, "%s: This frontend doesn't support DVBv3 calls\n",
+					__func__);
 			return -EINVAL;
 		}
 		/*
@@ -1539,8 +1539,8 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 			ncaps++;
 		}
 		if (delsys == SYS_UNDEFINED) {
-			dprintk("%s() Couldn't find a delivery system that matches %d\n",
-				__func__, desired_system);
+			dev_dbg(fe->dvb->device, "%s: Couldn't find a delivery system that matches %d\n",
+					__func__, desired_system);
 		}
 	} else {
 		/*
@@ -1553,8 +1553,9 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
 			if (fe->ops.delsys[ncaps] == desired_system) {
 				c->delivery_system = desired_system;
-				dprintk("%s() Changing delivery system to %d\n",
-					__func__, desired_system);
+				dev_dbg(fe->dvb->device,
+						"%s: Changing delivery system to %d\n",
+						__func__, desired_system);
 				return 0;
 			}
 			ncaps++;
@@ -1568,8 +1569,9 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 		 * DVBv3 delivery systems
 		 */
 		if (!is_dvbv3_delsys(desired_system)) {
-			dprintk("%s() can't use a DVBv3 FE_SET_FRONTEND call on this frontend\n",
-				__func__);
+			dev_dbg(fe->dvb->device,
+					"%s: can't use a DVBv3 FE_SET_FRONTEND call on this frontend\n",
+					__func__);
 			return -EINVAL;
 		}
 
@@ -1586,8 +1588,9 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 		}
 		/* There's nothing compatible with the desired delivery system */
 		if (delsys == SYS_UNDEFINED) {
-			dprintk("%s() Incompatible DVBv3 FE_SET_FRONTEND call for this frontend\n",
-				__func__);
+			dev_dbg(fe->dvb->device,
+					"%s: Incompatible DVBv3 FE_SET_FRONTEND call for this frontend\n",
+					__func__);
 			return -EINVAL;
 		}
 	}
@@ -1603,8 +1606,9 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 	 * the auto mode for most things, and will assume that the desired
 	 * delivery system is the last one at the ops.delsys[] array
 	 */
-	dprintk("%s() Using delivery system %d emulated as if it were a %d\n",
-		__func__, delsys, desired_system);
+	dev_dbg(fe->dvb->device,
+			"%s: Using delivery system %d emulated as if it were a %d\n",
+			__func__, delsys, desired_system);
 
 	/*
 	 * For now, handles ISDB-T calls. More code may be needed here for the
@@ -1612,8 +1616,10 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 	 */
 	if (type == DVBV3_OFDM) {
 		if (c->delivery_system == SYS_ISDBT) {
-			dprintk("%s() Using defaults for SYS_ISDBT\n",
-				__func__);
+			dev_dbg(fe->dvb->device,
+					"%s: Using defaults for SYS_ISDBT\n",
+					__func__);
+
 			if (!c->bandwidth_hz)
 				c->bandwidth_hz = 6000000;
 
@@ -1631,7 +1637,8 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 			}
 		}
 	}
-	dprintk("change delivery system on cache to %d\n", c->delivery_system);
+	dev_dbg(fe->dvb->device, "%s: change delivery system on cache to %d\n",
+			__func__, c->delivery_system);
 
 	return 0;
 }
@@ -1664,7 +1671,8 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		 * ioctl.
 		 */
 		c->state = tvp->cmd;
-		dprintk("%s() Finalised property cache\n", __func__);
+		dev_dbg(fe->dvb->device, "%s: Finalised property cache\n",
+				__func__);
 
 		r = dtv_set_frontend(fe);
 		break;
@@ -1810,8 +1818,7 @@ static int dvb_frontend_ioctl(struct file *file,
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err = -EOPNOTSUPP;
 
-	dprintk("%s (%d)\n", __func__, _IOC_NR(cmd));
-
+	dev_dbg(fe->dvb->device, "%s: (%d)\n", __func__, _IOC_NR(cmd));
 	if (fepriv->exit != DVB_FE_NO_EXIT)
 		return -ENODEV;
 
@@ -1847,13 +1854,13 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 	struct dtv_property *tvp = NULL;
 	int i;
 
-	dprintk("%s\n", __func__);
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	if(cmd == FE_SET_PROPERTY) {
 		tvps = (struct dtv_properties __user *)parg;
 
-		dprintk("%s() properties.num = %d\n", __func__, tvps->num);
-		dprintk("%s() properties.props = %p\n", __func__, tvps->props);
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
 
 		/* Put an arbitrary limit on the number of messages that can
 		 * be sent at once */
@@ -1879,14 +1886,14 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		}
 
 		if (c->state == DTV_TUNE)
-			dprintk("%s() Property cache is full, tuning\n", __func__);
+			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
 
 	} else
 	if(cmd == FE_GET_PROPERTY) {
 		tvps = (struct dtv_properties __user *)parg;
 
-		dprintk("%s() properties.num = %d\n", __func__, tvps->num);
-		dprintk("%s() properties.props = %p\n", __func__, tvps->props);
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
 
 		/* Put an arbitrary limit on the number of messages that can
 		 * be sent at once */
@@ -2094,13 +2101,13 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 			info->type = FE_OFDM;
 			break;
 		default:
-			printk(KERN_ERR
-			       "%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
-			       __func__, c->delivery_system);
+			dev_err(fe->dvb->device,
+					"%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
+					__func__, c->delivery_system);
 			fe->ops.info.type = FE_OFDM;
 		}
-		dprintk("current delivery system on cache: %d, V3 type: %d\n",
-			c->delivery_system, fe->ops.info.type);
+		dev_dbg(fe->dvb->device, "%s: current delivery system on cache: %d, V3 type: %d\n",
+				 __func__, c->delivery_system, fe->ops.info.type);
 
 		/* Force the CAN_INVERSION_AUTO bit on. If the frontend doesn't
 		 * do it, it is done for it. */
@@ -2294,7 +2301,7 @@ static unsigned int dvb_frontend_poll(struct file *file, struct poll_table_struc
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	dprintk ("%s\n", __func__);
+	dev_dbg_ratelimited(fe->dvb->device, "%s:\n", __func__);
 
 	poll_wait (file, &fepriv->events.wait_queue, wait);
 
@@ -2312,7 +2319,7 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 	struct dvb_adapter *adapter = fe->dvb;
 	int ret;
 
-	dprintk ("%s\n", __func__);
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 	if (fepriv->exit == DVB_FE_DEVICE_REMOVED)
 		return -ENODEV;
 
@@ -2407,7 +2414,7 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int ret;
 
-	dprintk ("%s\n", __func__);
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	if ((file->f_flags & O_ACCMODE) != O_RDONLY) {
 		fepriv->release_jiffies = jiffies;
@@ -2489,7 +2496,7 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 		.kernel_ioctl = dvb_frontend_ioctl
 	};
 
-	dprintk ("%s\n", __func__);
+	dev_dbg(dvb->device, "%s:\n", __func__);
 
 	if (mutex_lock_interruptible(&frontend_mutex))
 		return -ERESTARTSYS;
@@ -2508,10 +2515,9 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 	fe->dvb = dvb;
 	fepriv->inversion = INVERSION_OFF;
 
-	printk ("DVB: registering adapter %i frontend %i (%s)...\n",
-		fe->dvb->num,
-		fe->id,
-		fe->ops.info.name);
+	dev_info(fe->dvb->device,
+			"DVB: registering adapter %i frontend %i (%s)...\n",
+			fe->dvb->num, fe->id, fe->ops.info.name);
 
 	dvb_register_device (fe->dvb, &fepriv->dvbdev, &dvbdev_template,
 			     fe, DVB_DEVICE_FRONTEND);
@@ -2532,7 +2538,7 @@ EXPORT_SYMBOL(dvb_register_frontend);
 int dvb_unregister_frontend(struct dvb_frontend* fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	dprintk ("%s\n", __func__);
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	mutex_lock(&frontend_mutex);
 	dvb_frontend_stop (fe);
-- 
1.7.11.2

