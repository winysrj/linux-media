Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbeJaBJE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 21:09:04 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD41130820DC
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 16:14:57 +0000 (UTC)
Received: from wingsuit.redhat.com (ovpn-117-230.ams2.redhat.com [10.36.117.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E55DC1061A2B
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 16:14:56 +0000 (UTC)
From: Victor Toso <victortoso@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH dvb v1 4/4] media: dvb_frontend: remove __func__ from dev_dbg()
Date: Tue, 30 Oct 2018 17:14:51 +0100
Message-Id: <20181030161451.4560-5-victortoso@redhat.com>
In-Reply-To: <20181030161451.4560-1-victortoso@redhat.com>
References: <20181030161451.4560-1-victortoso@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Victor Toso <me@victortoso.com>

As dynamic debug can be instructed to add the function name to the
debug output using +f switch, we can remove __func__ from all
dev_dbg() calls. If not, a user that sets +f in dynamic debug would
get duplicated function name.

Signed-off-by: Victor Toso <me@victortoso.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 142 +++++++++++++-------------
 1 file changed, 69 insertions(+), 73 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 961207cf09eb..ab6d778aa641 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -251,7 +251,7 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe,
 	struct dvb_frontend_event *e;
 	int wp;
 
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+	dev_dbg(fe->dvb->device, "\n");
 
 	if ((status & FE_HAS_LOCK) && has_get_frontend(fe))
 		dtv_get_frontend(fe, c, &fepriv->parameters_out);
@@ -293,7 +293,7 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dvb_fe_events *events = &fepriv->events;
 
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+	dev_dbg(fe->dvb->device, "\n");
 
 	if (events->overflow) {
 		events->overflow = 0;
@@ -334,8 +334,8 @@ static void dvb_frontend_clear_events(struct dvb_frontend *fe)
 static void dvb_frontend_init(struct dvb_frontend *fe)
 {
 	dev_dbg(fe->dvb->device,
-		"%s: initialising adapter %i frontend %i (%s)...\n",
-		__func__, fe->dvb->num, fe->id, fe->ops.info.name);
+		"initialising adapter %i frontend %i (%s)...\n",
+		fe->dvb->num, fe->id, fe->ops.info.name);
 
 	if (fe->ops.init)
 		fe->ops.init(fe);
@@ -362,7 +362,7 @@ static void dvb_frontend_swzigzag_update_delay(struct dvb_frontend_private *fepr
 	int q2;
 	struct dvb_frontend *fe = fepriv->dvbdev->priv;
 
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+	dev_dbg(fe->dvb->device, "\n");
 
 	if (locked)
 		(fepriv->quality) = (fepriv->quality * 220 + 36 * 256) / 256;
@@ -458,8 +458,8 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 	}
 
 	dev_dbg(fe->dvb->device,
-		"%s: drift:%i inversion:%i auto_step:%i auto_sub_step:%i started_auto_step:%i\n",
-		__func__, fepriv->lnb_drift, fepriv->inversion,
+		"drift:%i inversion:%i auto_step:%i auto_sub_step:%i started_auto_step:%i\n",
+		fepriv->lnb_drift, fepriv->inversion,
 		fepriv->auto_step, fepriv->auto_sub_step,
 		fepriv->started_auto_step);
 
@@ -661,7 +661,7 @@ static int dvb_frontend_thread(void *data)
 	bool re_tune = false;
 	bool semheld = false;
 
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+	dev_dbg(fe->dvb->device, "\n");
 
 	fepriv->check_wrapped = 0;
 	fepriv->quality = 0;
@@ -710,10 +710,10 @@ static int dvb_frontend_thread(void *data)
 			algo = fe->ops.get_frontend_algo(fe);
 			switch (algo) {
 			case DVBFE_ALGO_HW:
-				dev_dbg(fe->dvb->device, "%s: Frontend ALGO = DVBFE_ALGO_HW\n", __func__);
+				dev_dbg(fe->dvb->device, "Frontend ALGO = DVBFE_ALGO_HW\n");
 
 				if (fepriv->state & FESTATE_RETUNE) {
-					dev_dbg(fe->dvb->device, "%s: Retune requested, FESTATE_RETUNE\n", __func__);
+					dev_dbg(fe->dvb->device, "Retune requested, FESTATE_RETUNE\n");
 					re_tune = true;
 					fepriv->state = FESTATE_TUNED;
 				} else {
@@ -724,19 +724,21 @@ static int dvb_frontend_thread(void *data)
 					fe->ops.tune(fe, re_tune, fepriv->tune_mode_flags, &fepriv->delay, &s);
 
 				if (s != fepriv->status && !(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT)) {
-					dev_dbg(fe->dvb->device, "%s: state changed, adding current state\n", __func__);
+					dev_dbg(fe->dvb->device, "state changed, adding current state\n");
 					dvb_frontend_add_event(fe, s);
 					fepriv->status = s;
 				}
 				break;
 			case DVBFE_ALGO_SW:
-				dev_dbg(fe->dvb->device, "%s: Frontend ALGO = DVBFE_ALGO_SW\n", __func__);
+				dev_dbg(fe->dvb->device, "Frontend ALGO = DVBFE_ALGO_SW\n");
 				dvb_frontend_swzigzag(fe);
 				break;
 			case DVBFE_ALGO_CUSTOM:
-				dev_dbg(fe->dvb->device, "%s: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=%d\n", __func__, fepriv->state);
+				dev_dbg(fe->dvb->device,
+					"Frontend ALGO = DVBFE_ALGO_CUSTOM, state=%d\n",
+					fepriv->state);
 				if (fepriv->state & FESTATE_RETUNE) {
-					dev_dbg(fe->dvb->device, "%s: Retune requested, FESTAT_RETUNE\n", __func__);
+					dev_dbg(fe->dvb->device, "Retune requested, FESTAT_RETUNE\n");
 					fepriv->state = FESTATE_TUNED;
 				}
 				/* Case where we are going to search for a carrier
@@ -772,7 +774,7 @@ static int dvb_frontend_thread(void *data)
 				}
 				break;
 			default:
-				dev_dbg(fe->dvb->device, "%s: UNDEFINED ALGO !\n", __func__);
+				dev_dbg(fe->dvb->device, "UNDEFINED ALGO !\n");
 				break;
 			}
 		} else {
@@ -811,7 +813,7 @@ static void dvb_frontend_stop(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+	dev_dbg(fe->dvb->device, "\n");
 
 	if (fe->exit != DVB_FE_DEVICE_REMOVED)
 		fe->exit = DVB_FE_NORMAL_EXIT;
@@ -860,7 +862,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct task_struct *fe_thread;
 
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+	dev_dbg(fe->dvb->device, "\n");
 
 	if (fepriv->thread) {
 		if (fe->exit == DVB_FE_NO_EXIT)
@@ -1007,8 +1009,8 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	memset(c, 0, offsetof(struct dtv_frontend_properties, strength));
 	c->delivery_system = delsys;
 
-	dev_dbg(fe->dvb->device, "%s: Clearing cache for delivery system %d\n",
-		__func__, c->delivery_system);
+	dev_dbg(fe->dvb->device, "Clearing cache for delivery system %d\n",
+		c->delivery_system);
 
 	c->transmission_mode = TRANSMISSION_MODE_AUTO;
 	c->bandwidth_hz = 0;	/* AUTO */
@@ -1178,18 +1180,18 @@ static int dtv_property_cache_sync(struct dvb_frontend *fe,
 
 	switch (dvbv3_type(c->delivery_system)) {
 	case DVBV3_QPSK:
-		dev_dbg(fe->dvb->device, "%s: Preparing QPSK req\n", __func__);
+		dev_dbg(fe->dvb->device, "Preparing QPSK req\n");
 		c->symbol_rate = p->u.qpsk.symbol_rate;
 		c->fec_inner = p->u.qpsk.fec_inner;
 		break;
 	case DVBV3_QAM:
-		dev_dbg(fe->dvb->device, "%s: Preparing QAM req\n", __func__);
+		dev_dbg(fe->dvb->device, "Preparing QAM req\n");
 		c->symbol_rate = p->u.qam.symbol_rate;
 		c->fec_inner = p->u.qam.fec_inner;
 		c->modulation = p->u.qam.modulation;
 		break;
 	case DVBV3_OFDM:
-		dev_dbg(fe->dvb->device, "%s: Preparing OFDM req\n", __func__);
+		dev_dbg(fe->dvb->device, "Preparing OFDM req\n");
 
 		switch (p->u.ofdm.bandwidth) {
 		case BANDWIDTH_10_MHZ:
@@ -1222,7 +1224,7 @@ static int dtv_property_cache_sync(struct dvb_frontend *fe,
 		c->hierarchy = p->u.ofdm.hierarchy_information;
 		break;
 	case DVBV3_ATSC:
-		dev_dbg(fe->dvb->device, "%s: Preparing ATSC req\n", __func__);
+		dev_dbg(fe->dvb->device, "Preparing ATSC req\n");
 		c->modulation = p->u.vsb.modulation;
 		if (c->delivery_system == SYS_ATSCMH)
 			break;
@@ -1259,18 +1261,18 @@ dtv_property_legacy_params_sync(struct dvb_frontend *fe,
 			__func__, c->delivery_system);
 		return -EINVAL;
 	case DVBV3_QPSK:
-		dev_dbg(fe->dvb->device, "%s: Preparing QPSK req\n", __func__);
+		dev_dbg(fe->dvb->device, "Preparing QPSK req\n");
 		p->u.qpsk.symbol_rate = c->symbol_rate;
 		p->u.qpsk.fec_inner = c->fec_inner;
 		break;
 	case DVBV3_QAM:
-		dev_dbg(fe->dvb->device, "%s: Preparing QAM req\n", __func__);
+		dev_dbg(fe->dvb->device, "Preparing QAM req\n");
 		p->u.qam.symbol_rate = c->symbol_rate;
 		p->u.qam.fec_inner = c->fec_inner;
 		p->u.qam.modulation = c->modulation;
 		break;
 	case DVBV3_OFDM:
-		dev_dbg(fe->dvb->device, "%s: Preparing OFDM req\n", __func__);
+		dev_dbg(fe->dvb->device, "Preparing OFDM req\n");
 		switch (c->bandwidth_hz) {
 		case 10000000:
 			p->u.ofdm.bandwidth = BANDWIDTH_10_MHZ;
@@ -1302,7 +1304,7 @@ dtv_property_legacy_params_sync(struct dvb_frontend *fe,
 		p->u.ofdm.hierarchy_information = c->hierarchy;
 		break;
 	case DVBV3_ATSC:
-		dev_dbg(fe->dvb->device, "%s: Preparing VSB req\n", __func__);
+		dev_dbg(fe->dvb->device, "Preparing VSB req\n");
 		p->u.vsb.modulation = c->modulation;
 		break;
 	}
@@ -1557,20 +1559,19 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		break;
 	default:
 		dev_dbg(fe->dvb->device,
-			"%s: FE property %d doesn't exist\n",
-			__func__, tvp->cmd);
+			"FE property %d doesn't exist\n",
+			tvp->cmd);
 		return -EINVAL;
 	}
 
 	if (!dtv_cmds[tvp->cmd].buffer)
 		dev_dbg(fe->dvb->device,
-			"%s: GET cmd 0x%08x (%s) = 0x%08x\n",
-			__func__, tvp->cmd, dtv_cmds[tvp->cmd].name,
+			"GET cmd 0x%08x (%s) = 0x%08x\n",
+			tvp->cmd, dtv_cmds[tvp->cmd].name,
 			tvp->u.data);
 	else
 		dev_dbg(fe->dvb->device,
-			"%s: GET cmd 0x%08x (%s) len %d: %*ph\n",
-			__func__,
+			"GET cmd 0x%08x (%s) len %d: %*ph\n",
 			tvp->cmd, dtv_cmds[tvp->cmd].name,
 			tvp->u.buffer.len,
 			tvp->u.buffer.len, tvp->u.buffer.data);
@@ -1608,8 +1609,7 @@ static int emulate_delivery_system(struct dvb_frontend *fe, u32 delsys)
 	 */
 	if (c->delivery_system == SYS_ISDBT) {
 		dev_dbg(fe->dvb->device,
-			"%s: Using defaults for SYS_ISDBT\n",
-			__func__);
+			"Using defaults for SYS_ISDBT\n");
 
 		if (!c->bandwidth_hz)
 			c->bandwidth_hz = 6000000;
@@ -1627,8 +1627,8 @@ static int emulate_delivery_system(struct dvb_frontend *fe, u32 delsys)
 			c->layer[i].segment_count = 0;
 		}
 	}
-	dev_dbg(fe->dvb->device, "%s: change delivery system on cache to %d\n",
-		__func__, c->delivery_system);
+	dev_dbg(fe->dvb->device, "change delivery system on cache to %d\n",
+		c->delivery_system);
 
 	return 0;
 }
@@ -1677,8 +1677,8 @@ static int dvbv5_set_delivery_system(struct dvb_frontend *fe,
 		if (fe->ops.delsys[ncaps] == desired_system) {
 			c->delivery_system = desired_system;
 			dev_dbg(fe->dvb->device,
-				"%s: Changing delivery system to %d\n",
-				__func__, desired_system);
+				"Changing delivery system to %d\n",
+				desired_system);
 			return 0;
 		}
 		ncaps++;
@@ -1693,8 +1693,8 @@ static int dvbv5_set_delivery_system(struct dvb_frontend *fe,
 	 */
 	if (!is_dvbv3_delsys(desired_system)) {
 		dev_dbg(fe->dvb->device,
-			"%s: Delivery system %d not supported.\n",
-			__func__, desired_system);
+			"Delivery system %d not supported.\n",
+			desired_system);
 		return -EINVAL;
 	}
 
@@ -1714,14 +1714,14 @@ static int dvbv5_set_delivery_system(struct dvb_frontend *fe,
 	/* There's nothing compatible with the desired delivery system */
 	if (delsys == SYS_UNDEFINED) {
 		dev_dbg(fe->dvb->device,
-			"%s: Delivery system %d not supported on emulation mode.\n",
-			__func__, desired_system);
+			"Delivery system %d not supported on emulation mode.\n",
+			desired_system);
 		return -EINVAL;
 	}
 
 	dev_dbg(fe->dvb->device,
-		"%s: Using delivery system %d emulated as if it were %d\n",
-		__func__, delsys, desired_system);
+		"Using delivery system %d emulated as if it were %d\n",
+		delsys, desired_system);
 
 	return emulate_delivery_system(fe, desired_system);
 }
@@ -1770,8 +1770,8 @@ static int dvbv3_set_delivery_system(struct dvb_frontend *fe)
 	 */
 	if (is_dvbv3_delsys(c->delivery_system)) {
 		dev_dbg(fe->dvb->device,
-			"%s: Using delivery system to %d\n",
-			__func__, c->delivery_system);
+			"Using delivery system to %d\n",
+			c->delivery_system);
 		return 0;
 	}
 
@@ -1789,8 +1789,7 @@ static int dvbv3_set_delivery_system(struct dvb_frontend *fe)
 	}
 	if (delsys == SYS_UNDEFINED) {
 		dev_dbg(fe->dvb->device,
-			"%s: Couldn't find a delivery system that works with FE_SET_FRONTEND\n",
-			__func__);
+			"Couldn't find a delivery system that works with FE_SET_FRONTEND\n");
 		return -EINVAL;
 	}
 	return emulate_delivery_system(fe, delsys);
@@ -1823,8 +1822,8 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 			 __func__, cmd);
 	else
 		dev_dbg(fe->dvb->device,
-			"%s: SET cmd 0x%08x (%s) to 0x%08x\n",
-			__func__, cmd, dtv_cmds[cmd].name, data);
+			"SET cmd 0x%08x (%s) to 0x%08x\n",
+			cmd, dtv_cmds[cmd].name, data);
 	switch (cmd) {
 	case DTV_CLEAR:
 		/*
@@ -1839,8 +1838,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		 * frontend
 		 */
 		dev_dbg(fe->dvb->device,
-			"%s: Setting the frontend from property cache\n",
-			__func__);
+			"Setting the frontend from property cache\n");
 
 		r = dtv_set_frontend(fe);
 		break;
@@ -1998,7 +1996,7 @@ static int dvb_frontend_do_ioctl(struct file *file, unsigned int cmd,
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err;
 
-	dev_dbg(fe->dvb->device, "%s: (%d)\n", __func__, _IOC_NR(cmd));
+	dev_dbg(fe->dvb->device, "(%d)\n", _IOC_NR(cmd));
 	if (down_interruptible(&fepriv->sem))
 		return -ERESTARTSYS;
 
@@ -2329,17 +2327,17 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int i, err = -ENOTSUPP;
 
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+	dev_dbg(fe->dvb->device, "\n");
 
 	switch (cmd) {
 	case FE_SET_PROPERTY: {
 		struct dtv_properties *tvps = parg;
 		struct dtv_property *tvp = NULL;
 
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
-			__func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
-			__func__, tvps->props);
+		dev_dbg(fe->dvb->device, "properties.num = %d\n",
+			tvps->num);
+		dev_dbg(fe->dvb->device, "properties.props = %p\n",
+			tvps->props);
 
 		/*
 		 * Put an arbitrary limit on the number of messages that can
@@ -2370,10 +2368,10 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 		struct dtv_property *tvp = NULL;
 		struct dtv_frontend_properties getp = fe->dtv_property_cache;
 
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
-			__func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
-			__func__, tvps->props);
+		dev_dbg(fe->dvb->device, "properties.num = %d\n",
+			tvps->num);
+		dev_dbg(fe->dvb->device, "properties.props = %p\n",
+			tvps->props);
 
 		/*
 		 * Put an arbitrary limit on the number of messages that can
@@ -2462,8 +2460,8 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 				__func__, c->delivery_system);
 			info->type = FE_OFDM;
 		}
-		dev_dbg(fe->dvb->device, "%s: current delivery system on cache: %d, V3 type: %d\n",
-			__func__, c->delivery_system, info->type);
+		dev_dbg(fe->dvb->device, "current delivery system on cache: %d, V3 type: %d\n",
+			c->delivery_system, info->type);
 
 		/* Set CAN_INVERSION_AUTO bit on in other than oneshot mode */
 		if (!(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT))
@@ -2721,7 +2719,7 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 	struct dvb_adapter *adapter = fe->dvb;
 	int ret;
 
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+	dev_dbg(fe->dvb->device, "\n");
 	if (fe->exit == DVB_FE_DEVICE_REMOVED)
 		return -ENODEV;
 
@@ -2847,7 +2845,7 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int ret;
 
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+	dev_dbg(fe->dvb->device, "\n");
 
 	if ((file->f_flags & O_ACCMODE) != O_RDONLY) {
 		fepriv->release_jiffies = jiffies;
@@ -2895,8 +2893,7 @@ int dvb_frontend_suspend(struct dvb_frontend *fe)
 {
 	int ret = 0;
 
-	dev_dbg(fe->dvb->device, "%s: adap=%d fe=%d\n", __func__, fe->dvb->num,
-		fe->id);
+	dev_dbg(fe->dvb->device, "adap=%d fe=%d\n", fe->dvb->num, fe->id);
 
 	if (fe->ops.tuner_ops.suspend)
 		ret = fe->ops.tuner_ops.suspend(fe);
@@ -2915,8 +2912,7 @@ int dvb_frontend_resume(struct dvb_frontend *fe)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int ret = 0;
 
-	dev_dbg(fe->dvb->device, "%s: adap=%d fe=%d\n", __func__, fe->dvb->num,
-		fe->id);
+	dev_dbg(fe->dvb->device, "adap=%d fe=%d\n", fe->dvb->num, fe->id);
 
 	fe->exit = DVB_FE_DEVICE_RESUME;
 	if (fe->ops.init)
@@ -2954,7 +2950,7 @@ int dvb_register_frontend(struct dvb_adapter *dvb,
 #endif
 	};
 
-	dev_dbg(dvb->device, "%s:\n", __func__);
+	dev_dbg(dvb->device, "\n");
 
 	if (mutex_lock_interruptible(&frontend_mutex))
 		return -ERESTARTSYS;
@@ -3006,7 +3002,7 @@ int dvb_unregister_frontend(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+	dev_dbg(fe->dvb->device, "\n");
 
 	mutex_lock(&frontend_mutex);
 	dvb_frontend_stop(fe);
-- 
2.17.2
