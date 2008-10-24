Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <sinter.mann@gmx.de>) id 1KtQlH-0000Nh-NL
	for linux-dvb@linuxtv.org; Fri, 24 Oct 2008 19:47:50 +0200
Content-Type: multipart/mixed; boundary="========GMX68261224870434527010"
Date: Fri, 24 Oct 2008 19:47:14 +0200
From: sinter.mann@gmx.de
Message-ID: <20081024174714.68260@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Technisat Skystar 2.8 brioken in kernel 2.6.28-rc1
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--========GMX68261224870434527010
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi,

I appended a reverse patch that users of a Technisat Skystar Rev. 28 need to run that Technisat card under kernel 2.6.28-rc1.

Cheers

sinter

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger

--========GMX68261224870434527010
Content-Type: text/x-patch; charset="iso-8859-15"; name="skystar2628.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="skystar2628.diff"

diff -U 3 -H -d -r -N -- drivers/media/dvb/dvb-core/dvb_frontend.c drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c	2008-10-24 14:28:29.000000000 +0200
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c	2008-10-10 00:13:53.000000000 +0200
@@ -40,14 +40,12 @@
 
 #include "dvb_frontend.h"
 #include "dvbdev.h"
-#include <linux/dvb/version.h>
 
 static int dvb_frontend_debug;
 static int dvb_shutdown_timeout;
 static int dvb_force_auto_inversion;
 static int dvb_override_tune_delay;
 static int dvb_powerdown_on_sleep = 1;
-static int dvb_mfe_wait_time = 5;
 
 module_param_named(frontend_debug, dvb_frontend_debug, int, 0644);
 MODULE_PARM_DESC(frontend_debug, "Turn on/off frontend core debugging (default:off).");
@@ -59,8 +57,6 @@
 MODULE_PARM_DESC(dvb_override_tune_delay, "0: normal (default), >0 => delay in milliseconds to wait for lock after a tune attempt");
 module_param(dvb_powerdown_on_sleep, int, 0644);
 MODULE_PARM_DESC(dvb_powerdown_on_sleep, "0: do not power down, 1: turn LNB voltage off on sleep (default)");
-module_param(dvb_mfe_wait_time, int, 0644);
-MODULE_PARM_DESC(dvb_mfe_wait_time, "Wait up to <mfe_wait_time> seconds on open() for multi-frontend to become available (default:5 seconds)");
 
 #define dprintk if (dvb_frontend_debug) printk
 
@@ -215,9 +211,8 @@
 
 static void dvb_frontend_init(struct dvb_frontend *fe)
 {
-	dprintk ("DVB: initialising adapter %i frontend %i (%s)...\n",
+	dprintk ("DVB: initialising frontend %i (%s)...\n",
 		 fe->dvb->num,
-		 fe->id,
 		 fe->ops.info.name);
 
 	if (fe->ops.init)
@@ -690,7 +685,7 @@
 	mb();
 
 	fe_thread = kthread_run(dvb_frontend_thread, fe,
-		"kdvb-ad-%i-fe-%i", fe->dvb->num,fe->id);
+		"kdvb-fe-%i", fe->dvb->num);
 	if (IS_ERR(fe_thread)) {
 		ret = PTR_ERR(fe_thread);
 		printk("dvb_frontend_start: failed to start kthread (%d)\n", ret);
@@ -714,8 +709,8 @@
 		*freq_max = min(fe->ops.info.frequency_max, fe->ops.tuner_ops.info.frequency_max);
 
 	if (*freq_min == 0 || *freq_max == 0)
-		printk(KERN_WARNING "DVB: adapter %i frontend %u frequency limits undefined - fix the driver\n",
-		       fe->dvb->num,fe->id);
+		printk(KERN_WARNING "DVB: frontend %u frequency limits undefined - fix the driver\n",
+		       fe->dvb->num);
 }
 
 static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
@@ -728,8 +723,8 @@
 	dvb_frontend_get_frequeny_limits(fe, &freq_min, &freq_max);
 	if ((freq_min && parms->frequency < freq_min) ||
 	    (freq_max && parms->frequency > freq_max)) {
-		printk(KERN_WARNING "DVB: adapter %i frontend %i frequency %u out of range (%u..%u)\n",
-		       fe->dvb->num, fe->id, parms->frequency, freq_min, freq_max);
+		printk(KERN_WARNING "DVB: frontend %u frequency %u out of range (%u..%u)\n",
+		       fe->dvb->num, parms->frequency, freq_min, freq_max);
 		return -EINVAL;
 	}
 
@@ -739,8 +734,8 @@
 		     parms->u.qpsk.symbol_rate < fe->ops.info.symbol_rate_min) ||
 		    (fe->ops.info.symbol_rate_max &&
 		     parms->u.qpsk.symbol_rate > fe->ops.info.symbol_rate_max)) {
-			printk(KERN_WARNING "DVB: adapter %i frontend %i symbol rate %u out of range (%u..%u)\n",
-			       fe->dvb->num, fe->id, parms->u.qpsk.symbol_rate,
+			printk(KERN_WARNING "DVB: frontend %u symbol rate %u out of range (%u..%u)\n",
+			       fe->dvb->num, parms->u.qpsk.symbol_rate,
 			       fe->ops.info.symbol_rate_min, fe->ops.info.symbol_rate_max);
 			return -EINVAL;
 		}
@@ -750,8 +745,8 @@
 		     parms->u.qam.symbol_rate < fe->ops.info.symbol_rate_min) ||
 		    (fe->ops.info.symbol_rate_max &&
 		     parms->u.qam.symbol_rate > fe->ops.info.symbol_rate_max)) {
-			printk(KERN_WARNING "DVB: adapter %i frontend %i symbol rate %u out of range (%u..%u)\n",
-			       fe->dvb->num, fe->id, parms->u.qam.symbol_rate,
+			printk(KERN_WARNING "DVB: frontend %u symbol rate %u out of range (%u..%u)\n",
+			       fe->dvb->num, parms->u.qam.symbol_rate,
 			       fe->ops.info.symbol_rate_min, fe->ops.info.symbol_rate_max);
 			return -EINVAL;
 		}
@@ -760,529 +755,6 @@
 	return 0;
 }
 
-struct dtv_cmds_h dtv_cmds[] = {
-	[DTV_TUNE] = {
-		.name	= "DTV_TUNE",
-		.cmd	= DTV_TUNE,
-		.set	= 1,
-	},
-	[DTV_CLEAR] = {
-		.name	= "DTV_CLEAR",
-		.cmd	= DTV_CLEAR,
-		.set	= 1,
-	},
-
-	/* Set */
-	[DTV_FREQUENCY] = {
-		.name	= "DTV_FREQUENCY",
-		.cmd	= DTV_FREQUENCY,
-		.set	= 1,
-	},
-	[DTV_BANDWIDTH_HZ] = {
-		.name	= "DTV_BANDWIDTH_HZ",
-		.cmd	= DTV_BANDWIDTH_HZ,
-		.set	= 1,
-	},
-	[DTV_MODULATION] = {
-		.name	= "DTV_MODULATION",
-		.cmd	= DTV_MODULATION,
-		.set	= 1,
-	},
-	[DTV_INVERSION] = {
-		.name	= "DTV_INVERSION",
-		.cmd	= DTV_INVERSION,
-		.set	= 1,
-	},
-	[DTV_DISEQC_MASTER] = {
-		.name	= "DTV_DISEQC_MASTER",
-		.cmd	= DTV_DISEQC_MASTER,
-		.set	= 1,
-		.buffer	= 1,
-	},
-	[DTV_SYMBOL_RATE] = {
-		.name	= "DTV_SYMBOL_RATE",
-		.cmd	= DTV_SYMBOL_RATE,
-		.set	= 1,
-	},
-	[DTV_INNER_FEC] = {
-		.name	= "DTV_INNER_FEC",
-		.cmd	= DTV_INNER_FEC,
-		.set	= 1,
-	},
-	[DTV_VOLTAGE] = {
-		.name	= "DTV_VOLTAGE",
-		.cmd	= DTV_VOLTAGE,
-		.set	= 1,
-	},
-	[DTV_TONE] = {
-		.name	= "DTV_TONE",
-		.cmd	= DTV_TONE,
-		.set	= 1,
-	},
-	[DTV_PILOT] = {
-		.name	= "DTV_PILOT",
-		.cmd	= DTV_PILOT,
-		.set	= 1,
-	},
-	[DTV_ROLLOFF] = {
-		.name	= "DTV_ROLLOFF",
-		.cmd	= DTV_ROLLOFF,
-		.set	= 1,
-	},
-	[DTV_DELIVERY_SYSTEM] = {
-		.name	= "DTV_DELIVERY_SYSTEM",
-		.cmd	= DTV_DELIVERY_SYSTEM,
-		.set	= 1,
-	},
-	[DTV_HIERARCHY] = {
-		.name	= "DTV_HIERARCHY",
-		.cmd	= DTV_HIERARCHY,
-		.set	= 1,
-	},
-	[DTV_CODE_RATE_HP] = {
-		.name	= "DTV_CODE_RATE_HP",
-		.cmd	= DTV_CODE_RATE_HP,
-		.set	= 1,
-	},
-	[DTV_CODE_RATE_LP] = {
-		.name	= "DTV_CODE_RATE_LP",
-		.cmd	= DTV_CODE_RATE_LP,
-		.set	= 1,
-	},
-	[DTV_GUARD_INTERVAL] = {
-		.name	= "DTV_GUARD_INTERVAL",
-		.cmd	= DTV_GUARD_INTERVAL,
-		.set	= 1,
-	},
-	[DTV_TRANSMISSION_MODE] = {
-		.name	= "DTV_TRANSMISSION_MODE",
-		.cmd	= DTV_TRANSMISSION_MODE,
-		.set	= 1,
-	},
-	/* Get */
-	[DTV_DISEQC_SLAVE_REPLY] = {
-		.name	= "DTV_DISEQC_SLAVE_REPLY",
-		.cmd	= DTV_DISEQC_SLAVE_REPLY,
-		.set	= 0,
-		.buffer	= 1,
-	},
-	[DTV_API_VERSION] = {
-		.name	= "DTV_API_VERSION",
-		.cmd	= DTV_API_VERSION,
-		.set	= 0,
-	},
-	[DTV_CODE_RATE_HP] = {
-		.name	= "DTV_CODE_RATE_HP",
-		.cmd	= DTV_CODE_RATE_HP,
-		.set	= 0,
-	},
-	[DTV_CODE_RATE_LP] = {
-		.name	= "DTV_CODE_RATE_LP",
-		.cmd	= DTV_CODE_RATE_LP,
-		.set	= 0,
-	},
-	[DTV_GUARD_INTERVAL] = {
-		.name	= "DTV_GUARD_INTERVAL",
-		.cmd	= DTV_GUARD_INTERVAL,
-		.set	= 0,
-	},
-	[DTV_TRANSMISSION_MODE] = {
-		.name	= "DTV_TRANSMISSION_MODE",
-		.cmd	= DTV_TRANSMISSION_MODE,
-		.set	= 0,
-	},
-	[DTV_HIERARCHY] = {
-		.name	= "DTV_HIERARCHY",
-		.cmd	= DTV_HIERARCHY,
-		.set	= 0,
-	},
-};
-
-void dtv_property_dump(struct dtv_property *tvp)
-{
-	int i;
-
-	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
-		printk(KERN_WARNING "%s: tvp.cmd = 0x%08x undefined\n",
-			__func__, tvp->cmd);
-		return;
-	}
-
-	dprintk("%s() tvp.cmd    = 0x%08x (%s)\n"
-		,__func__
-		,tvp->cmd
-		,dtv_cmds[ tvp->cmd ].name);
-
-	if(dtv_cmds[ tvp->cmd ].buffer) {
-
-		dprintk("%s() tvp.u.buffer.len = 0x%02x\n"
-			,__func__
-			,tvp->u.buffer.len);
-
-		for(i = 0; i < tvp->u.buffer.len; i++)
-			dprintk("%s() tvp.u.buffer.data[0x%02x] = 0x%02x\n"
-				,__func__
-				,i
-				,tvp->u.buffer.data[i]);
-
-	} else
-		dprintk("%s() tvp.u.data = 0x%08x\n", __func__, tvp->u.data);
-}
-
-int is_legacy_delivery_system(fe_delivery_system_t s)
-{
-	if((s == SYS_UNDEFINED) || (s == SYS_DVBC_ANNEX_AC) ||
-		(s == SYS_DVBC_ANNEX_B) || (s == SYS_DVBT) || (s == SYS_DVBS))
-		return 1;
-
-	return 0;
-}
-
-/* Synchronise the legacy tuning parameters into the cache, so that demodulator
- * drivers can use a single set_frontend tuning function, regardless of whether
- * it's being used for the legacy or new API, reducing code and complexity.
- */
-void dtv_property_cache_sync(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
-{
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-
-	c->frequency = p->frequency;
-	c->inversion = p->inversion;
-
-	switch (fe->ops.info.type) {
-	case FE_QPSK:
-		c->modulation = QPSK;   /* implied for DVB-S in legacy API */
-		c->rolloff = ROLLOFF_35;/* implied for DVB-S */
-		c->symbol_rate = p->u.qpsk.symbol_rate;
-		c->fec_inner = p->u.qpsk.fec_inner;
-		c->delivery_system = SYS_DVBS;
-		break;
-	case FE_QAM:
-		c->symbol_rate = p->u.qam.symbol_rate;
-		c->fec_inner = p->u.qam.fec_inner;
-		c->modulation = p->u.qam.modulation;
-		c->delivery_system = SYS_DVBC_ANNEX_AC;
-		break;
-	case FE_OFDM:
-		if (p->u.ofdm.bandwidth == BANDWIDTH_6_MHZ)
-			c->bandwidth_hz = 6000000;
-		else if (p->u.ofdm.bandwidth == BANDWIDTH_7_MHZ)
-			c->bandwidth_hz = 7000000;
-		else if (p->u.ofdm.bandwidth == BANDWIDTH_8_MHZ)
-			c->bandwidth_hz = 8000000;
-		else
-			/* Including BANDWIDTH_AUTO */
-			c->bandwidth_hz = 0;
-		c->code_rate_HP = p->u.ofdm.code_rate_HP;
-		c->code_rate_LP = p->u.ofdm.code_rate_LP;
-		c->modulation = p->u.ofdm.constellation;
-		c->transmission_mode = p->u.ofdm.transmission_mode;
-		c->guard_interval = p->u.ofdm.guard_interval;
-		c->hierarchy = p->u.ofdm.hierarchy_information;
-		c->delivery_system = SYS_DVBT;
-		break;
-	case FE_ATSC:
-		c->modulation = p->u.vsb.modulation;
-		if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
-			c->delivery_system = SYS_ATSC;
-		else
-			c->delivery_system = SYS_DVBC_ANNEX_B;
-		break;
-	}
-}
-
-/* Ensure the cached values are set correctly in the frontend
- * legacy tuning structures, for the advanced tuning API.
- */
-void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dvb_frontend_parameters *p = &fepriv->parameters;
-
-	p->frequency = c->frequency;
-	p->inversion = c->inversion;
-
-	switch (fe->ops.info.type) {
-	case FE_QPSK:
-		dprintk("%s() Preparing QPSK req\n", __func__);
-		p->u.qpsk.symbol_rate = c->symbol_rate;
-		p->u.qpsk.fec_inner = c->fec_inner;
-		c->delivery_system = SYS_DVBS;
-		break;
-	case FE_QAM:
-		dprintk("%s() Preparing QAM req\n", __func__);
-		p->u.qam.symbol_rate = c->symbol_rate;
-		p->u.qam.fec_inner = c->fec_inner;
-		p->u.qam.modulation = c->modulation;
-		c->delivery_system = SYS_DVBC_ANNEX_AC;
-		break;
-	case FE_OFDM:
-		dprintk("%s() Preparing OFDM req\n", __func__);
-		if (c->bandwidth_hz == 6000000)
-			p->u.ofdm.bandwidth = BANDWIDTH_6_MHZ;
-		else if (c->bandwidth_hz == 7000000)
-			p->u.ofdm.bandwidth = BANDWIDTH_7_MHZ;
-		else if (c->bandwidth_hz == 8000000)
-			p->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
-		else
-			p->u.ofdm.bandwidth = BANDWIDTH_AUTO;
-		p->u.ofdm.code_rate_HP = c->code_rate_HP;
-		p->u.ofdm.code_rate_LP = c->code_rate_LP;
-		p->u.ofdm.constellation = c->modulation;
-		p->u.ofdm.transmission_mode = c->transmission_mode;
-		p->u.ofdm.guard_interval = c->guard_interval;
-		p->u.ofdm.hierarchy_information = c->hierarchy;
-		c->delivery_system = SYS_DVBT;
-		break;
-	case FE_ATSC:
-		dprintk("%s() Preparing VSB req\n", __func__);
-		p->u.vsb.modulation = c->modulation;
-		if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
-			c->delivery_system = SYS_ATSC;
-		else
-			c->delivery_system = SYS_DVBC_ANNEX_B;
-		break;
-	}
-}
-
-/* Ensure the cached values are set correctly in the frontend
- * legacy tuning structures, for the legacy tuning API.
- */
-void dtv_property_adv_params_sync(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dvb_frontend_parameters *p = &fepriv->parameters;
-
-	p->frequency = c->frequency;
-	p->inversion = c->inversion;
-
-	switch(c->modulation) {
-	case PSK_8:
-	case APSK_16:
-	case APSK_32:
-	case QPSK:
-		p->u.qpsk.symbol_rate = c->symbol_rate;
-		p->u.qpsk.fec_inner = c->fec_inner;
-		break;
-	default:
-		break;
-	}
-
-	if(c->delivery_system == SYS_ISDBT) {
-		/* Fake out a generic DVB-T request so we pass validation in the ioctl */
-		p->frequency = c->frequency;
-		p->inversion = INVERSION_AUTO;
-		p->u.ofdm.constellation = QAM_AUTO;
-		p->u.ofdm.code_rate_HP = FEC_AUTO;
-		p->u.ofdm.code_rate_LP = FEC_AUTO;
-		p->u.ofdm.bandwidth = BANDWIDTH_AUTO;
-		p->u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;
-		p->u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
-		p->u.ofdm.hierarchy_information = HIERARCHY_AUTO;
-	}
-}
-
-void dtv_property_cache_submit(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-
-	/* For legacy delivery systems we don't need the delivery_system to
-	 * be specified, but we populate the older structures from the cache
-	 * so we can call set_frontend on older drivers.
-	 */
-	if(is_legacy_delivery_system(c->delivery_system)) {
-
-		dprintk("%s() legacy, modulation = %d\n", __func__, c->modulation);
-		dtv_property_legacy_params_sync(fe);
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
-}
-
-static int dvb_frontend_ioctl_legacy(struct inode *inode, struct file *file,
-			unsigned int cmd, void *parg);
-static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
-			unsigned int cmd, void *parg);
-
-int dtv_property_process_get(struct dvb_frontend *fe, struct dtv_property *tvp,
-	struct inode *inode, struct file *file)
-{
-	int r = 0;
-
-	dtv_property_dump(tvp);
-
-	/* Allow the frontend to validate incoming properties */
-	if (fe->ops.get_property)
-		r = fe->ops.get_property(fe, tvp);
-
-	if (r < 0)
-		return r;
-
-	switch(tvp->cmd) {
-	case DTV_FREQUENCY:
-		tvp->u.data = fe->dtv_property_cache.frequency;
-		break;
-	case DTV_MODULATION:
-		tvp->u.data = fe->dtv_property_cache.modulation;
-		break;
-	case DTV_BANDWIDTH_HZ:
-		tvp->u.data = fe->dtv_property_cache.bandwidth_hz;
-		break;
-	case DTV_INVERSION:
-		tvp->u.data = fe->dtv_property_cache.inversion;
-		break;
-	case DTV_SYMBOL_RATE:
-		tvp->u.data = fe->dtv_property_cache.symbol_rate;
-		break;
-	case DTV_INNER_FEC:
-		tvp->u.data = fe->dtv_property_cache.fec_inner;
-		break;
-	case DTV_PILOT:
-		tvp->u.data = fe->dtv_property_cache.pilot;
-		break;
-	case DTV_ROLLOFF:
-		tvp->u.data = fe->dtv_property_cache.rolloff;
-		break;
-	case DTV_DELIVERY_SYSTEM:
-		tvp->u.data = fe->dtv_property_cache.delivery_system;
-		break;
-	case DTV_VOLTAGE:
-		tvp->u.data = fe->dtv_property_cache.voltage;
-		break;
-	case DTV_TONE:
-		tvp->u.data = fe->dtv_property_cache.sectone;
-		break;
-	case DTV_API_VERSION:
-		tvp->u.data = (DVB_API_VERSION << 8) | DVB_API_VERSION_MINOR;
-		break;
-	case DTV_CODE_RATE_HP:
-		tvp->u.data = fe->dtv_property_cache.code_rate_HP;
-		break;
-	case DTV_CODE_RATE_LP:
-		tvp->u.data = fe->dtv_property_cache.code_rate_LP;
-		break;
-	case DTV_GUARD_INTERVAL:
-		tvp->u.data = fe->dtv_property_cache.guard_interval;
-		break;
-	case DTV_TRANSMISSION_MODE:
-		tvp->u.data = fe->dtv_property_cache.transmission_mode;
-		break;
-	case DTV_HIERARCHY:
-		tvp->u.data = fe->dtv_property_cache.hierarchy;
-		break;
-	default:
-		r = -1;
-	}
-
-	return r;
-}
-
-int dtv_property_process_set(struct dvb_frontend *fe, struct dtv_property *tvp,
-	struct inode *inode, struct file *file)
-{
-	int r = 0;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	dtv_property_dump(tvp);
-
-	/* Allow the frontend to validate incoming properties */
-	if (fe->ops.set_property)
-		r = fe->ops.set_property(fe, tvp);
-
-	if (r < 0)
-		return r;
-
-	switch(tvp->cmd) {
-	case DTV_CLEAR:
-		/* Reset a cache of data specific to the frontend here. This does
-		 * not effect hardware.
-		 */
-		dprintk("%s() Flushing property cache\n", __func__);
-		memset(&fe->dtv_property_cache, 0, sizeof(struct dtv_frontend_properties));
-		fe->dtv_property_cache.state = tvp->cmd;
-		fe->dtv_property_cache.delivery_system = SYS_UNDEFINED;
-		break;
-	case DTV_TUNE:
-		/* interpret the cache of data, build either a traditional frontend
-		 * tunerequest so we can pass validation in the FE_SET_FRONTEND
-		 * ioctl.
-		 */
-		fe->dtv_property_cache.state = tvp->cmd;
-		dprintk("%s() Finalised property cache\n", __func__);
-		dtv_property_cache_submit(fe);
-
-		r |= dvb_frontend_ioctl_legacy(inode, file, FE_SET_FRONTEND,
-			&fepriv->parameters);
-		break;
-	case DTV_FREQUENCY:
-		fe->dtv_property_cache.frequency = tvp->u.data;
-		break;
-	case DTV_MODULATION:
-		fe->dtv_property_cache.modulation = tvp->u.data;
-		break;
-	case DTV_BANDWIDTH_HZ:
-		fe->dtv_property_cache.bandwidth_hz = tvp->u.data;
-		break;
-	case DTV_INVERSION:
-		fe->dtv_property_cache.inversion = tvp->u.data;
-		break;
-	case DTV_SYMBOL_RATE:
-		fe->dtv_property_cache.symbol_rate = tvp->u.data;
-		break;
-	case DTV_INNER_FEC:
-		fe->dtv_property_cache.fec_inner = tvp->u.data;
-		break;
-	case DTV_PILOT:
-		fe->dtv_property_cache.pilot = tvp->u.data;
-		break;
-	case DTV_ROLLOFF:
-		fe->dtv_property_cache.rolloff = tvp->u.data;
-		break;
-	case DTV_DELIVERY_SYSTEM:
-		fe->dtv_property_cache.delivery_system = tvp->u.data;
-		break;
-	case DTV_VOLTAGE:
-		fe->dtv_property_cache.voltage = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(inode, file, FE_SET_VOLTAGE,
-			(void *)fe->dtv_property_cache.voltage);
-		break;
-	case DTV_TONE:
-		fe->dtv_property_cache.sectone = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(inode, file, FE_SET_TONE,
-			(void *)fe->dtv_property_cache.sectone);
-		break;
-	case DTV_CODE_RATE_HP:
-		fe->dtv_property_cache.code_rate_HP = tvp->u.data;
-		break;
-	case DTV_CODE_RATE_LP:
-		fe->dtv_property_cache.code_rate_LP = tvp->u.data;
-		break;
-	case DTV_GUARD_INTERVAL:
-		fe->dtv_property_cache.guard_interval = tvp->u.data;
-		break;
-	case DTV_TRANSMISSION_MODE:
-		fe->dtv_property_cache.transmission_mode = tvp->u.data;
-		break;
-	case DTV_HIERARCHY:
-		fe->dtv_property_cache.hierarchy = tvp->u.data;
-		break;
-	default:
-		r = -1;
-	}
-
-	return r;
-}
-
 static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, void *parg)
 {
@@ -1304,112 +776,6 @@
 	if (down_interruptible (&fepriv->sem))
 		return -ERESTARTSYS;
 
-	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
-		err = dvb_frontend_ioctl_properties(inode, file, cmd, parg);
-	else {
-		fe->dtv_property_cache.state = DTV_UNDEFINED;
-		err = dvb_frontend_ioctl_legacy(inode, file, cmd, parg);
-	}
-
-	up(&fepriv->sem);
-	return err;
-}
-
-static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
-			unsigned int cmd, void *parg)
-{
-	struct dvb_device *dvbdev = file->private_data;
-	struct dvb_frontend *fe = dvbdev->priv;
-	int err = 0;
-
-	struct dtv_properties *tvps = NULL;
-	struct dtv_property *tvp = NULL;
-	int i;
-
-	dprintk("%s\n", __func__);
-
-	if(cmd == FE_SET_PROPERTY) {
-		tvps = (struct dtv_properties __user *)parg;
-
-		dprintk("%s() properties.num = %d\n", __func__, tvps->num);
-		dprintk("%s() properties.props = %p\n", __func__, tvps->props);
-
-		/* Put an arbitrary limit on the number of messages that can
-		 * be sent at once */
-		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
-			return -EINVAL;
-
-		tvp = (struct dtv_property *) kmalloc(tvps->num *
-			sizeof(struct dtv_property), GFP_KERNEL);
-		if (!tvp) {
-			err = -ENOMEM;
-			goto out;
-		}
-
-		if (copy_from_user(tvp, tvps->props, tvps->num * sizeof(struct dtv_property))) {
-			err = -EFAULT;
-			goto out;
-		}
-
-		for (i = 0; i < tvps->num; i++) {
-			(tvp + i)->result = dtv_property_process_set(fe, tvp + i, inode, file);
-			err |= (tvp + i)->result;
-		}
-
-		if(fe->dtv_property_cache.state == DTV_TUNE)
-			dprintk("%s() Property cache is full, tuning\n", __func__);
-
-	} else
-	if(cmd == FE_GET_PROPERTY) {
-
-		tvps = (struct dtv_properties __user *)parg;
-
-		dprintk("%s() properties.num = %d\n", __func__, tvps->num);
-		dprintk("%s() properties.props = %p\n", __func__, tvps->props);
-
-		/* Put an arbitrary limit on the number of messages that can
-		 * be sent at once */
-		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
-			return -EINVAL;
-
-		tvp = (struct dtv_property *) kmalloc(tvps->num *
-			sizeof(struct dtv_property), GFP_KERNEL);
-		if (!tvp) {
-			err = -ENOMEM;
-			goto out;
-		}
-
-		if (copy_from_user(tvp, tvps->props, tvps->num * sizeof(struct dtv_property))) {
-			err = -EFAULT;
-			goto out;
-		}
-
-		for (i = 0; i < tvps->num; i++) {
-			(tvp + i)->result = dtv_property_process_get(fe, tvp + i, inode, file);
-			err |= (tvp + i)->result;
-		}
-
-		if (copy_to_user(tvps->props, tvp, tvps->num * sizeof(struct dtv_property))) {
-			err = -EFAULT;
-			goto out;
-		}
-
-	} else
-		err = -EOPNOTSUPP;
-
-out:
-	kfree(tvp);
-	return err;
-}
-
-static int dvb_frontend_ioctl_legacy(struct inode *inode, struct file *file,
-			unsigned int cmd, void *parg)
-{
-	struct dvb_device *dvbdev = file->private_data;
-	struct dvb_frontend *fe = dvbdev->priv;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	int err = -EOPNOTSUPP;
-
 	switch (cmd) {
 	case FE_GET_INFO: {
 		struct dvb_frontend_info* info = parg;
@@ -1576,22 +942,14 @@
 	case FE_SET_FRONTEND: {
 		struct dvb_frontend_tune_settings fetunesettings;
 
-		if(fe->dtv_property_cache.state == DTV_TUNE) {
-			if (dvb_frontend_check_parameters(fe, &fepriv->parameters) < 0) {
-				err = -EINVAL;
-				break;
-			}
-		} else {
-			if (dvb_frontend_check_parameters(fe, parg) < 0) {
-				err = -EINVAL;
-				break;
-			}
-
-			memcpy (&fepriv->parameters, parg,
-				sizeof (struct dvb_frontend_parameters));
-			dtv_property_cache_sync(fe, &fepriv->parameters);
+		if (dvb_frontend_check_parameters(fe, parg) < 0) {
+			err = -EINVAL;
+			break;
 		}
 
+		memcpy (&fepriv->parameters, parg,
+			sizeof (struct dvb_frontend_parameters));
+
 		memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
 		memcpy(&fetunesettings.parameters, parg,
 		       sizeof (struct dvb_frontend_parameters));
@@ -1669,10 +1027,10 @@
 		break;
 	};
 
+	up (&fepriv->sem);
 	return err;
 }
 
-
 static unsigned int dvb_frontend_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -1694,53 +1052,13 @@
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dvb_adapter *adapter = fe->dvb;
 	int ret;
 
 	dprintk ("%s\n", __func__);
 
-	if (adapter->mfe_shared) {
-		mutex_lock (&adapter->mfe_lock);
-
-		if (adapter->mfe_dvbdev == NULL)
-			adapter->mfe_dvbdev = dvbdev;
-
-		else if (adapter->mfe_dvbdev != dvbdev) {
-			struct dvb_device
-				*mfedev = adapter->mfe_dvbdev;
-			struct dvb_frontend
-				*mfe = mfedev->priv;
-			struct dvb_frontend_private
-				*mfepriv = mfe->frontend_priv;
-			int mferetry = (dvb_mfe_wait_time << 1);
-
-			mutex_unlock (&adapter->mfe_lock);
-			while (mferetry-- && (mfedev->users != -1 ||
-					mfepriv->thread != NULL)) {
-				if(msleep_interruptible(500)) {
-					if(signal_pending(current))
-						return -EINTR;
-				}
-			}
-
-			mutex_lock (&adapter->mfe_lock);
-			if(adapter->mfe_dvbdev != dvbdev) {
-				mfedev = adapter->mfe_dvbdev;
-				mfe = mfedev->priv;
-				mfepriv = mfe->frontend_priv;
-				if (mfedev->users != -1 ||
-						mfepriv->thread != NULL) {
-					mutex_unlock (&adapter->mfe_lock);
-					return -EBUSY;
-				}
-				adapter->mfe_dvbdev = dvbdev;
-			}
-		}
-	}
-
 	if (dvbdev->users == -1 && fe->ops.ts_bus_ctrl) {
 		if ((ret = fe->ops.ts_bus_ctrl(fe, 1)) < 0)
-			goto err0;
+			return ret;
 	}
 
 	if ((ret = dvb_generic_open (inode, file)) < 0)
@@ -1760,8 +1078,6 @@
 		fepriv->events.eventr = fepriv->events.eventw = 0;
 	}
 
-	if (adapter->mfe_shared)
-		mutex_unlock (&adapter->mfe_lock);
 	return ret;
 
 err2:
@@ -1769,9 +1085,6 @@
 err1:
 	if (dvbdev->users == -1 && fe->ops.ts_bus_ctrl)
 		fe->ops.ts_bus_ctrl(fe, 0);
-err0:
-	if (adapter->mfe_shared)
-		mutex_unlock (&adapter->mfe_lock);
 	return ret;
 }
 
@@ -1841,9 +1154,8 @@
 	fe->dvb = dvb;
 	fepriv->inversion = INVERSION_OFF;
 
-	printk ("DVB: registering adapter %i frontend %i (%s)...\n",
+	printk ("DVB: registering frontend %i (%s)...\n",
 		fe->dvb->num,
-		fe->id,
 		fe->ops.info.name);
 
 	dvb_register_device (fe->dvb, &fepriv->dvbdev, &dvbdev_template,
diff -U 3 -H -d -r -N -- drivers/media/dvb/dvb-core/dvb_frontend.h drivers/media/dvb/dvb-core/dvb_frontend.h
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h	2008-10-24 14:28:29.000000000 +0200
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h	2008-10-10 00:13:53.000000000 +0200
@@ -169,9 +169,6 @@
 
 	struct dvb_tuner_ops tuner_ops;
 	struct analog_demod_ops analog_ops;
-
-	int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
-	int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
 };
 
 #define MAX_EVENT 8
@@ -185,32 +182,6 @@
 	struct mutex		  mtx;
 };
 
-struct dtv_frontend_properties {
-
-	/* Cache State */
-	u32			state;
-
-	u32			frequency;
-	fe_modulation_t		modulation;
-
-	fe_sec_voltage_t	voltage;
-	fe_sec_tone_mode_t	sectone;
-	fe_spectral_inversion_t	inversion;
-	fe_code_rate_t		fec_inner;
-	fe_transmit_mode_t	transmission_mode;
-	u32			bandwidth_hz;	/* 0 = AUTO */
-	fe_guard_interval_t	guard_interval;
-	fe_hierarchy_t		hierarchy;
-	u32			symbol_rate;
-	fe_code_rate_t		code_rate_HP;
-	fe_code_rate_t		code_rate_LP;
-
-	fe_pilot_t		pilot;
-	fe_rolloff_t		rolloff;
-
-	fe_delivery_system_t	delivery_system;
-};
-
 struct dvb_frontend {
 	struct dvb_frontend_ops ops;
 	struct dvb_adapter *dvb;
@@ -219,10 +190,6 @@
 	void *frontend_priv;
 	void *sec_priv;
 	void *analog_demod_priv;
-	struct dtv_frontend_properties dtv_property_cache;
-#define DVB_FRONTEND_COMPONENT_TUNER 0
-	int (*callback)(void *adapter_priv, int component, int cmd, int arg);
-	int id;
 };
 
 extern int dvb_register_frontend(struct dvb_adapter *dvb,

--========GMX68261224870434527010
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--========GMX68261224870434527010--
