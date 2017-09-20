Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:41724 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751011AbdITFPm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 01:15:42 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20170920051541epoutp0300acc1b5c4a5959bbcba3fdb6507b749~l_gMFd11w0116701167epoutp03F
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 05:15:41 +0000 (GMT)
From: Satendra Singh Thakur <satendra.t@samsung.com>
To: mchehab@kernel.org
Cc: satendra.t@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5] [DVB][FRONTEND] Modified the code related to
 FE_SET_PROPERTY ioctl
Date: Wed, 20 Sep 2017 01:15:08 -0400
Message-Id: <1505884508-496-1-git-send-email-satendra.t@samsung.com>
In-Reply-To: <20170919063320.17cba1b6@vento.lan>
Content-Type: text/plain; charset="utf-8"
References: <20170919063320.17cba1b6@vento.lan>
        <CGME20170920051539epcas5p2cd7f0cca8120dcb87c576f3bd8778aa2@epcas5p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-Since all the properties in the func dtv_property_process_set
 are 4 bytes, We have added 2 new arguments u32 cmd and u32 data;
 in place of older argument struct dtv_property *tvp.
-We have removed property validation in function
 dtv_property_process_set because most of the frontend drivers in
 linux source are not using the method ops.set_property.
-In place of dtv_property_dump, we have added own logic
 to dump cmd and data of the incoming property
-We have also re-named dtv_property_dump to dtv_get_property_dump.
-We have modified logs in this func to be suitable only for getting
 properties.
Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 135 ++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 62 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2fcba16..013476e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1092,22 +1092,19 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_STAT_TOTAL_BLOCK_COUNT, 0, 0),
 };
 
-static void dtv_property_dump(struct dvb_frontend *fe,
-			      bool is_set,
+static void dtv_get_property_dump(struct dvb_frontend *fe,
 			      struct dtv_property *tvp)
 {
 	int i;
 
 	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
-		dev_warn(fe->dvb->device, "%s: %s tvp.cmd = 0x%08x undefined\n",
-				__func__,
-				is_set ? "SET" : "GET",
+		dev_warn(fe->dvb->device, "%s: GET tvp.cmd = 0x%08x undefined\n"
+				, __func__,
 				tvp->cmd);
 		return;
 	}
 
-	dev_dbg(fe->dvb->device, "%s: %s tvp.cmd    = 0x%08x (%s)\n", __func__,
-		is_set ? "SET" : "GET",
+	dev_dbg(fe->dvb->device, "%s: GET tvp.cmd    = 0x%08x (%s)\n", __func__,
 		tvp->cmd,
 		dtv_cmds[tvp->cmd].name);
 
@@ -1526,7 +1523,7 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 			return r;
 	}
 
-	dtv_property_dump(fe, false, tvp);
+	dtv_get_property_dump(fe, tvp);
 
 	return 0;
 }
@@ -1749,23 +1746,35 @@ static int dvbv3_set_delivery_system(struct dvb_frontend *fe)
 	return emulate_delivery_system(fe, delsys);
 }
 
+/**
+ * dtv_property_process_set -  Sets a single DTV property
+ * @fe:		Pointer to &struct dvb_frontend
+ * @file:	Pointer to &struct file
+ * @cmd:	Digital TV command
+ * @data:	An unsigned 32-bits number
+ *
+ * This routine assigns the property
+ * value to the corresponding member of
+ * &struct dtv_frontend_properties
+ *
+ * Returns:
+ * Zero on success, negative errno on failure.
+ */
 static int dtv_property_process_set(struct dvb_frontend *fe,
-				    struct dtv_property *tvp,
-				    struct file *file)
+					struct file *file,
+					u32 cmd, u32 data)
 {
 	int r = 0;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-
-	/* Allow the frontend to validate incoming properties */
-	if (fe->ops.set_property) {
-		r = fe->ops.set_property(fe, tvp);
-		if (r < 0)
-			return r;
-	}
-
-	dtv_property_dump(fe, true, tvp);
-
-	switch(tvp->cmd) {
+	/** Dump DTV command name and value*/
+	if (!cmd || cmd > DTV_MAX_COMMAND)
+		dev_warn(fe->dvb->device, "%s: SET cmd 0x%08x undefined\n",
+				 __func__, cmd);
+	else
+		dev_dbg(fe->dvb->device,
+				"%s: SET cmd 0x%08x (%s) to 0x%08x\n",
+				__func__, cmd, dtv_cmds[cmd].name, data);
+	switch (cmd) {
 	case DTV_CLEAR:
 		/*
 		 * Reset a cache of data specific to the frontend here. This does
@@ -1778,140 +1787,140 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		 * tunerequest so we can pass validation in the FE_SET_FRONTEND
 		 * ioctl.
 		 */
-		c->state = tvp->cmd;
+		c->state = cmd;
 		dev_dbg(fe->dvb->device, "%s: Finalised property cache\n",
 				__func__);
 
 		r = dtv_set_frontend(fe);
 		break;
 	case DTV_FREQUENCY:
-		c->frequency = tvp->u.data;
+		c->frequency = data;
 		break;
 	case DTV_MODULATION:
-		c->modulation = tvp->u.data;
+		c->modulation = data;
 		break;
 	case DTV_BANDWIDTH_HZ:
-		c->bandwidth_hz = tvp->u.data;
+		c->bandwidth_hz = data;
 		break;
 	case DTV_INVERSION:
-		c->inversion = tvp->u.data;
+		c->inversion = data;
 		break;
 	case DTV_SYMBOL_RATE:
-		c->symbol_rate = tvp->u.data;
+		c->symbol_rate = data;
 		break;
 	case DTV_INNER_FEC:
-		c->fec_inner = tvp->u.data;
+		c->fec_inner = data;
 		break;
 	case DTV_PILOT:
-		c->pilot = tvp->u.data;
+		c->pilot = data;
 		break;
 	case DTV_ROLLOFF:
-		c->rolloff = tvp->u.data;
+		c->rolloff = data;
 		break;
 	case DTV_DELIVERY_SYSTEM:
-		r = dvbv5_set_delivery_system(fe, tvp->u.data);
+		r = dvbv5_set_delivery_system(fe, data);
 		break;
 	case DTV_VOLTAGE:
-		c->voltage = tvp->u.data;
+		c->voltage = data;
 		r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
 			(void *)c->voltage);
 		break;
 	case DTV_TONE:
-		c->sectone = tvp->u.data;
+		c->sectone = data;
 		r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
 			(void *)c->sectone);
 		break;
 	case DTV_CODE_RATE_HP:
-		c->code_rate_HP = tvp->u.data;
+		c->code_rate_HP = data;
 		break;
 	case DTV_CODE_RATE_LP:
-		c->code_rate_LP = tvp->u.data;
+		c->code_rate_LP = data;
 		break;
 	case DTV_GUARD_INTERVAL:
-		c->guard_interval = tvp->u.data;
+		c->guard_interval = data;
 		break;
 	case DTV_TRANSMISSION_MODE:
-		c->transmission_mode = tvp->u.data;
+		c->transmission_mode = data;
 		break;
 	case DTV_HIERARCHY:
-		c->hierarchy = tvp->u.data;
+		c->hierarchy = data;
 		break;
 	case DTV_INTERLEAVING:
-		c->interleaving = tvp->u.data;
+		c->interleaving = data;
 		break;
 
 	/* ISDB-T Support here */
 	case DTV_ISDBT_PARTIAL_RECEPTION:
-		c->isdbt_partial_reception = tvp->u.data;
+		c->isdbt_partial_reception = data;
 		break;
 	case DTV_ISDBT_SOUND_BROADCASTING:
-		c->isdbt_sb_mode = tvp->u.data;
+		c->isdbt_sb_mode = data;
 		break;
 	case DTV_ISDBT_SB_SUBCHANNEL_ID:
-		c->isdbt_sb_subchannel = tvp->u.data;
+		c->isdbt_sb_subchannel = data;
 		break;
 	case DTV_ISDBT_SB_SEGMENT_IDX:
-		c->isdbt_sb_segment_idx = tvp->u.data;
+		c->isdbt_sb_segment_idx = data;
 		break;
 	case DTV_ISDBT_SB_SEGMENT_COUNT:
-		c->isdbt_sb_segment_count = tvp->u.data;
+		c->isdbt_sb_segment_count = data;
 		break;
 	case DTV_ISDBT_LAYER_ENABLED:
-		c->isdbt_layer_enabled = tvp->u.data;
+		c->isdbt_layer_enabled = data;
 		break;
 	case DTV_ISDBT_LAYERA_FEC:
-		c->layer[0].fec = tvp->u.data;
+		c->layer[0].fec = data;
 		break;
 	case DTV_ISDBT_LAYERA_MODULATION:
-		c->layer[0].modulation = tvp->u.data;
+		c->layer[0].modulation = data;
 		break;
 	case DTV_ISDBT_LAYERA_SEGMENT_COUNT:
-		c->layer[0].segment_count = tvp->u.data;
+		c->layer[0].segment_count = data;
 		break;
 	case DTV_ISDBT_LAYERA_TIME_INTERLEAVING:
-		c->layer[0].interleaving = tvp->u.data;
+		c->layer[0].interleaving = data;
 		break;
 	case DTV_ISDBT_LAYERB_FEC:
-		c->layer[1].fec = tvp->u.data;
+		c->layer[1].fec = data;
 		break;
 	case DTV_ISDBT_LAYERB_MODULATION:
-		c->layer[1].modulation = tvp->u.data;
+		c->layer[1].modulation = data;
 		break;
 	case DTV_ISDBT_LAYERB_SEGMENT_COUNT:
-		c->layer[1].segment_count = tvp->u.data;
+		c->layer[1].segment_count = data;
 		break;
 	case DTV_ISDBT_LAYERB_TIME_INTERLEAVING:
-		c->layer[1].interleaving = tvp->u.data;
+		c->layer[1].interleaving = data;
 		break;
 	case DTV_ISDBT_LAYERC_FEC:
-		c->layer[2].fec = tvp->u.data;
+		c->layer[2].fec = data;
 		break;
 	case DTV_ISDBT_LAYERC_MODULATION:
-		c->layer[2].modulation = tvp->u.data;
+		c->layer[2].modulation = data;
 		break;
 	case DTV_ISDBT_LAYERC_SEGMENT_COUNT:
-		c->layer[2].segment_count = tvp->u.data;
+		c->layer[2].segment_count = data;
 		break;
 	case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
-		c->layer[2].interleaving = tvp->u.data;
+		c->layer[2].interleaving = data;
 		break;
 
 	/* Multistream support */
 	case DTV_STREAM_ID:
 	case DTV_DVBT2_PLP_ID_LEGACY:
-		c->stream_id = tvp->u.data;
+		c->stream_id = data;
 		break;
 
 	/* ATSC-MH */
 	case DTV_ATSCMH_PARADE_ID:
-		fe->dtv_property_cache.atscmh_parade_id = tvp->u.data;
+		fe->dtv_property_cache.atscmh_parade_id = data;
 		break;
 	case DTV_ATSCMH_RS_FRAME_ENSEMBLE:
-		fe->dtv_property_cache.atscmh_rs_frame_ensemble = tvp->u.data;
+		fe->dtv_property_cache.atscmh_rs_frame_ensemble = data;
 		break;
 
 	case DTV_LNA:
-		c->lna = tvp->u.data;
+		c->lna = data;
 		if (fe->ops.set_lna)
 			r = fe->ops.set_lna(fe);
 		if (r < 0)
@@ -1990,7 +1999,9 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 			return PTR_ERR(tvp);
 
 		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_set(fe, tvp + i, file);
+			err = dtv_property_process_set(fe, file,
+							(tvp + i)->cmd,
+							(tvp + i)->u.data);
 			if (err < 0)
 				goto out;
 			(tvp + i)->result = err;
-- 
2.7.4
