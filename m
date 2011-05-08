Return-path: <mchehab@gaivota>
Received: from mail.dream-property.net ([82.149.226.172]:52926 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab1EHXNX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 19:13:23 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Thierry LELEGARD <tlelegard@logiways.com>
Subject: [PATCH 6/8] DVB: dvb_frontend: use shortcut to access fe->dtv_property_cache
Date: Sun,  8 May 2011 23:03:39 +0000
Message-Id: <1304895821-21642-7-git-send-email-obi@linuxtv.org>
In-Reply-To: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
References: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |  211 +++++++++++++++--------------
 1 files changed, 108 insertions(+), 103 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 9775cdc..d4485c8 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -858,34 +858,34 @@ static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
 
 static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int i;
 
-	memset(&(fe->dtv_property_cache), 0,
-			sizeof(struct dtv_frontend_properties));
-
-	fe->dtv_property_cache.state = DTV_CLEAR;
-	fe->dtv_property_cache.delivery_system = SYS_UNDEFINED;
-	fe->dtv_property_cache.inversion = INVERSION_AUTO;
-	fe->dtv_property_cache.fec_inner = FEC_AUTO;
-	fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_AUTO;
-	fe->dtv_property_cache.bandwidth_hz = BANDWIDTH_AUTO;
-	fe->dtv_property_cache.guard_interval = GUARD_INTERVAL_AUTO;
-	fe->dtv_property_cache.hierarchy = HIERARCHY_AUTO;
-	fe->dtv_property_cache.symbol_rate = QAM_AUTO;
-	fe->dtv_property_cache.code_rate_HP = FEC_AUTO;
-	fe->dtv_property_cache.code_rate_LP = FEC_AUTO;
-
-	fe->dtv_property_cache.isdbt_partial_reception = -1;
-	fe->dtv_property_cache.isdbt_sb_mode = -1;
-	fe->dtv_property_cache.isdbt_sb_subchannel = -1;
-	fe->dtv_property_cache.isdbt_sb_segment_idx = -1;
-	fe->dtv_property_cache.isdbt_sb_segment_count = -1;
-	fe->dtv_property_cache.isdbt_layer_enabled = 0x7;
+	memset(c, 0, sizeof(struct dtv_frontend_properties));
+
+	c->state = DTV_CLEAR;
+	c->delivery_system = SYS_UNDEFINED;
+	c->inversion = INVERSION_AUTO;
+	c->fec_inner = FEC_AUTO;
+	c->transmission_mode = TRANSMISSION_MODE_AUTO;
+	c->bandwidth_hz = BANDWIDTH_AUTO;
+	c->guard_interval = GUARD_INTERVAL_AUTO;
+	c->hierarchy = HIERARCHY_AUTO;
+	c->symbol_rate = QAM_AUTO;
+	c->code_rate_HP = FEC_AUTO;
+	c->code_rate_LP = FEC_AUTO;
+
+	c->isdbt_partial_reception = -1;
+	c->isdbt_sb_mode = -1;
+	c->isdbt_sb_subchannel = -1;
+	c->isdbt_sb_segment_idx = -1;
+	c->isdbt_sb_segment_count = -1;
+	c->isdbt_layer_enabled = 0x7;
 	for (i = 0; i < 3; i++) {
-		fe->dtv_property_cache.layer[i].fec = FEC_AUTO;
-		fe->dtv_property_cache.layer[i].modulation = QAM_AUTO;
-		fe->dtv_property_cache.layer[i].interleaving = -1;
-		fe->dtv_property_cache.layer[i].segment_count = -1;
+		c->layer[i].fec = FEC_AUTO;
+		c->layer[i].modulation = QAM_AUTO;
+		c->layer[i].interleaving = -1;
+		c->layer[i].segment_count = -1;
 	}
 
 	return 0;
@@ -1194,121 +1194,122 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
 				    struct file *file)
 {
+	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int r;
 
 	switch(tvp->cmd) {
 	case DTV_FREQUENCY:
-		tvp->u.data = fe->dtv_property_cache.frequency;
+		tvp->u.data = c->frequency;
 		break;
 	case DTV_MODULATION:
-		tvp->u.data = fe->dtv_property_cache.modulation;
+		tvp->u.data = c->modulation;
 		break;
 	case DTV_BANDWIDTH_HZ:
-		tvp->u.data = fe->dtv_property_cache.bandwidth_hz;
+		tvp->u.data = c->bandwidth_hz;
 		break;
 	case DTV_INVERSION:
-		tvp->u.data = fe->dtv_property_cache.inversion;
+		tvp->u.data = c->inversion;
 		break;
 	case DTV_SYMBOL_RATE:
-		tvp->u.data = fe->dtv_property_cache.symbol_rate;
+		tvp->u.data = c->symbol_rate;
 		break;
 	case DTV_INNER_FEC:
-		tvp->u.data = fe->dtv_property_cache.fec_inner;
+		tvp->u.data = c->fec_inner;
 		break;
 	case DTV_PILOT:
-		tvp->u.data = fe->dtv_property_cache.pilot;
+		tvp->u.data = c->pilot;
 		break;
 	case DTV_ROLLOFF:
-		tvp->u.data = fe->dtv_property_cache.rolloff;
+		tvp->u.data = c->rolloff;
 		break;
 	case DTV_DELIVERY_SYSTEM:
-		tvp->u.data = fe->dtv_property_cache.delivery_system;
+		tvp->u.data = c->delivery_system;
 		break;
 	case DTV_VOLTAGE:
-		tvp->u.data = fe->dtv_property_cache.voltage;
+		tvp->u.data = c->voltage;
 		break;
 	case DTV_TONE:
-		tvp->u.data = fe->dtv_property_cache.sectone;
+		tvp->u.data = c->sectone;
 		break;
 	case DTV_API_VERSION:
 		tvp->u.data = (DVB_API_VERSION << 8) | DVB_API_VERSION_MINOR;
 		break;
 	case DTV_CODE_RATE_HP:
-		tvp->u.data = fe->dtv_property_cache.code_rate_HP;
+		tvp->u.data = c->code_rate_HP;
 		break;
 	case DTV_CODE_RATE_LP:
-		tvp->u.data = fe->dtv_property_cache.code_rate_LP;
+		tvp->u.data = c->code_rate_LP;
 		break;
 	case DTV_GUARD_INTERVAL:
-		tvp->u.data = fe->dtv_property_cache.guard_interval;
+		tvp->u.data = c->guard_interval;
 		break;
 	case DTV_TRANSMISSION_MODE:
-		tvp->u.data = fe->dtv_property_cache.transmission_mode;
+		tvp->u.data = c->transmission_mode;
 		break;
 	case DTV_HIERARCHY:
-		tvp->u.data = fe->dtv_property_cache.hierarchy;
+		tvp->u.data = c->hierarchy;
 		break;
 
 	/* ISDB-T Support here */
 	case DTV_ISDBT_PARTIAL_RECEPTION:
-		tvp->u.data = fe->dtv_property_cache.isdbt_partial_reception;
+		tvp->u.data = c->isdbt_partial_reception;
 		break;
 	case DTV_ISDBT_SOUND_BROADCASTING:
-		tvp->u.data = fe->dtv_property_cache.isdbt_sb_mode;
+		tvp->u.data = c->isdbt_sb_mode;
 		break;
 	case DTV_ISDBT_SB_SUBCHANNEL_ID:
-		tvp->u.data = fe->dtv_property_cache.isdbt_sb_subchannel;
+		tvp->u.data = c->isdbt_sb_subchannel;
 		break;
 	case DTV_ISDBT_SB_SEGMENT_IDX:
-		tvp->u.data = fe->dtv_property_cache.isdbt_sb_segment_idx;
+		tvp->u.data = c->isdbt_sb_segment_idx;
 		break;
 	case DTV_ISDBT_SB_SEGMENT_COUNT:
-		tvp->u.data = fe->dtv_property_cache.isdbt_sb_segment_count;
+		tvp->u.data = c->isdbt_sb_segment_count;
 		break;
 	case DTV_ISDBT_LAYER_ENABLED:
-		tvp->u.data = fe->dtv_property_cache.isdbt_layer_enabled;
+		tvp->u.data = c->isdbt_layer_enabled;
 		break;
 	case DTV_ISDBT_LAYERA_FEC:
-		tvp->u.data = fe->dtv_property_cache.layer[0].fec;
+		tvp->u.data = c->layer[0].fec;
 		break;
 	case DTV_ISDBT_LAYERA_MODULATION:
-		tvp->u.data = fe->dtv_property_cache.layer[0].modulation;
+		tvp->u.data = c->layer[0].modulation;
 		break;
 	case DTV_ISDBT_LAYERA_SEGMENT_COUNT:
-		tvp->u.data = fe->dtv_property_cache.layer[0].segment_count;
+		tvp->u.data = c->layer[0].segment_count;
 		break;
 	case DTV_ISDBT_LAYERA_TIME_INTERLEAVING:
-		tvp->u.data = fe->dtv_property_cache.layer[0].interleaving;
+		tvp->u.data = c->layer[0].interleaving;
 		break;
 	case DTV_ISDBT_LAYERB_FEC:
-		tvp->u.data = fe->dtv_property_cache.layer[1].fec;
+		tvp->u.data = c->layer[1].fec;
 		break;
 	case DTV_ISDBT_LAYERB_MODULATION:
-		tvp->u.data = fe->dtv_property_cache.layer[1].modulation;
+		tvp->u.data = c->layer[1].modulation;
 		break;
 	case DTV_ISDBT_LAYERB_SEGMENT_COUNT:
-		tvp->u.data = fe->dtv_property_cache.layer[1].segment_count;
+		tvp->u.data = c->layer[1].segment_count;
 		break;
 	case DTV_ISDBT_LAYERB_TIME_INTERLEAVING:
-		tvp->u.data = fe->dtv_property_cache.layer[1].interleaving;
+		tvp->u.data = c->layer[1].interleaving;
 		break;
 	case DTV_ISDBT_LAYERC_FEC:
-		tvp->u.data = fe->dtv_property_cache.layer[2].fec;
+		tvp->u.data = c->layer[2].fec;
 		break;
 	case DTV_ISDBT_LAYERC_MODULATION:
-		tvp->u.data = fe->dtv_property_cache.layer[2].modulation;
+		tvp->u.data = c->layer[2].modulation;
 		break;
 	case DTV_ISDBT_LAYERC_SEGMENT_COUNT:
-		tvp->u.data = fe->dtv_property_cache.layer[2].segment_count;
+		tvp->u.data = c->layer[2].segment_count;
 		break;
 	case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
-		tvp->u.data = fe->dtv_property_cache.layer[2].interleaving;
+		tvp->u.data = c->layer[2].interleaving;
 		break;
 	case DTV_ISDBS_TS_ID:
-		tvp->u.data = fe->dtv_property_cache.isdbs_ts_id;
+		tvp->u.data = c->isdbs_ts_id;
 		break;
 	case DTV_DVBT2_PLP_ID:
-		tvp->u.data = fe->dtv_property_cache.dvbt2_plp_id;
+		tvp->u.data = c->dvbt2_plp_id;
 		break;
 	default:
 		return -EINVAL;
@@ -1331,6 +1332,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 				    struct file *file)
 {
 	int r = 0;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	dtv_property_dump(tvp);
 
@@ -1354,7 +1356,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		 * tunerequest so we can pass validation in the FE_SET_FRONTEND
 		 * ioctl.
 		 */
-		fe->dtv_property_cache.state = tvp->cmd;
+		c->state = tvp->cmd;
 		dprintk("%s() Finalised property cache\n", __func__);
 		dtv_property_cache_submit(fe);
 
@@ -1362,118 +1364,118 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 			&fepriv->parameters_in);
 		break;
 	case DTV_FREQUENCY:
-		fe->dtv_property_cache.frequency = tvp->u.data;
+		c->frequency = tvp->u.data;
 		break;
 	case DTV_MODULATION:
-		fe->dtv_property_cache.modulation = tvp->u.data;
+		c->modulation = tvp->u.data;
 		break;
 	case DTV_BANDWIDTH_HZ:
-		fe->dtv_property_cache.bandwidth_hz = tvp->u.data;
+		c->bandwidth_hz = tvp->u.data;
 		break;
 	case DTV_INVERSION:
-		fe->dtv_property_cache.inversion = tvp->u.data;
+		c->inversion = tvp->u.data;
 		break;
 	case DTV_SYMBOL_RATE:
-		fe->dtv_property_cache.symbol_rate = tvp->u.data;
+		c->symbol_rate = tvp->u.data;
 		break;
 	case DTV_INNER_FEC:
-		fe->dtv_property_cache.fec_inner = tvp->u.data;
+		c->fec_inner = tvp->u.data;
 		break;
 	case DTV_PILOT:
-		fe->dtv_property_cache.pilot = tvp->u.data;
+		c->pilot = tvp->u.data;
 		break;
 	case DTV_ROLLOFF:
-		fe->dtv_property_cache.rolloff = tvp->u.data;
+		c->rolloff = tvp->u.data;
 		break;
 	case DTV_DELIVERY_SYSTEM:
-		fe->dtv_property_cache.delivery_system = tvp->u.data;
+		c->delivery_system = tvp->u.data;
 		break;
 	case DTV_VOLTAGE:
-		fe->dtv_property_cache.voltage = tvp->u.data;
+		c->voltage = tvp->u.data;
 		r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
-			(void *)fe->dtv_property_cache.voltage);
+			(void *)c->voltage);
 		break;
 	case DTV_TONE:
-		fe->dtv_property_cache.sectone = tvp->u.data;
+		c->sectone = tvp->u.data;
 		r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
-			(void *)fe->dtv_property_cache.sectone);
+			(void *)c->sectone);
 		break;
 	case DTV_CODE_RATE_HP:
-		fe->dtv_property_cache.code_rate_HP = tvp->u.data;
+		c->code_rate_HP = tvp->u.data;
 		break;
 	case DTV_CODE_RATE_LP:
-		fe->dtv_property_cache.code_rate_LP = tvp->u.data;
+		c->code_rate_LP = tvp->u.data;
 		break;
 	case DTV_GUARD_INTERVAL:
-		fe->dtv_property_cache.guard_interval = tvp->u.data;
+		c->guard_interval = tvp->u.data;
 		break;
 	case DTV_TRANSMISSION_MODE:
-		fe->dtv_property_cache.transmission_mode = tvp->u.data;
+		c->transmission_mode = tvp->u.data;
 		break;
 	case DTV_HIERARCHY:
-		fe->dtv_property_cache.hierarchy = tvp->u.data;
+		c->hierarchy = tvp->u.data;
 		break;
 
 	/* ISDB-T Support here */
 	case DTV_ISDBT_PARTIAL_RECEPTION:
-		fe->dtv_property_cache.isdbt_partial_reception = tvp->u.data;
+		c->isdbt_partial_reception = tvp->u.data;
 		break;
 	case DTV_ISDBT_SOUND_BROADCASTING:
-		fe->dtv_property_cache.isdbt_sb_mode = tvp->u.data;
+		c->isdbt_sb_mode = tvp->u.data;
 		break;
 	case DTV_ISDBT_SB_SUBCHANNEL_ID:
-		fe->dtv_property_cache.isdbt_sb_subchannel = tvp->u.data;
+		c->isdbt_sb_subchannel = tvp->u.data;
 		break;
 	case DTV_ISDBT_SB_SEGMENT_IDX:
-		fe->dtv_property_cache.isdbt_sb_segment_idx = tvp->u.data;
+		c->isdbt_sb_segment_idx = tvp->u.data;
 		break;
 	case DTV_ISDBT_SB_SEGMENT_COUNT:
-		fe->dtv_property_cache.isdbt_sb_segment_count = tvp->u.data;
+		c->isdbt_sb_segment_count = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYER_ENABLED:
-		fe->dtv_property_cache.isdbt_layer_enabled = tvp->u.data;
+		c->isdbt_layer_enabled = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERA_FEC:
-		fe->dtv_property_cache.layer[0].fec = tvp->u.data;
+		c->layer[0].fec = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERA_MODULATION:
-		fe->dtv_property_cache.layer[0].modulation = tvp->u.data;
+		c->layer[0].modulation = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERA_SEGMENT_COUNT:
-		fe->dtv_property_cache.layer[0].segment_count = tvp->u.data;
+		c->layer[0].segment_count = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERA_TIME_INTERLEAVING:
-		fe->dtv_property_cache.layer[0].interleaving = tvp->u.data;
+		c->layer[0].interleaving = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERB_FEC:
-		fe->dtv_property_cache.layer[1].fec = tvp->u.data;
+		c->layer[1].fec = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERB_MODULATION:
-		fe->dtv_property_cache.layer[1].modulation = tvp->u.data;
+		c->layer[1].modulation = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERB_SEGMENT_COUNT:
-		fe->dtv_property_cache.layer[1].segment_count = tvp->u.data;
+		c->layer[1].segment_count = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERB_TIME_INTERLEAVING:
-		fe->dtv_property_cache.layer[1].interleaving = tvp->u.data;
+		c->layer[1].interleaving = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERC_FEC:
-		fe->dtv_property_cache.layer[2].fec = tvp->u.data;
+		c->layer[2].fec = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERC_MODULATION:
-		fe->dtv_property_cache.layer[2].modulation = tvp->u.data;
+		c->layer[2].modulation = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERC_SEGMENT_COUNT:
-		fe->dtv_property_cache.layer[2].segment_count = tvp->u.data;
+		c->layer[2].segment_count = tvp->u.data;
 		break;
 	case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
-		fe->dtv_property_cache.layer[2].interleaving = tvp->u.data;
+		c->layer[2].interleaving = tvp->u.data;
 		break;
 	case DTV_ISDBS_TS_ID:
-		fe->dtv_property_cache.isdbs_ts_id = tvp->u.data;
+		c->isdbs_ts_id = tvp->u.data;
 		break;
 	case DTV_DVBT2_PLP_ID:
-		fe->dtv_property_cache.dvbt2_plp_id = tvp->u.data;
+		c->dvbt2_plp_id = tvp->u.data;
 		break;
 	default:
 		return -EINVAL;
@@ -1487,6 +1489,7 @@ static int dvb_frontend_ioctl(struct file *file,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err = -EOPNOTSUPP;
 
@@ -1506,7 +1509,7 @@ static int dvb_frontend_ioctl(struct file *file,
 	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
 		err = dvb_frontend_ioctl_properties(file, cmd, parg);
 	else {
-		fe->dtv_property_cache.state = DTV_UNDEFINED;
+		c->state = DTV_UNDEFINED;
 		err = dvb_frontend_ioctl_legacy(file, cmd, parg);
 	}
 
@@ -1519,6 +1522,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int err = 0;
 
 	struct dtv_properties *tvps = NULL;
@@ -1556,7 +1560,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 			(tvp + i)->result = err;
 		}
 
-		if(fe->dtv_property_cache.state == DTV_TUNE)
+		if (c->state == DTV_TUNE)
 			dprintk("%s() Property cache is full, tuning\n", __func__);
 
 	} else
@@ -1787,9 +1791,10 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		break;
 
 	case FE_SET_FRONTEND: {
+		struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 		struct dvb_frontend_tune_settings fetunesettings;
 
-		if(fe->dtv_property_cache.state == DTV_TUNE) {
+		if (c->state == DTV_TUNE) {
 			if (dvb_frontend_check_parameters(fe, &fepriv->parameters_in) < 0) {
 				err = -EINVAL;
 				break;
-- 
1.7.2.5

