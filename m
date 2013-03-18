Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab3CRTZo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 15:25:44 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2IJPi31014260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 18 Mar 2013 15:25:44 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] dvb_frontend: Simplify the emulation logic
Date: Mon, 18 Mar 2013 16:25:37 -0300
Message-Id: <1363634737-22550-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363634737-22550-1-git-send-email-mchehab@redhat.com>
References: <1363634737-22550-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current logic was broken and too complex; while it works
fine for DVB-S2/DVB-S, it is broken for ISDB-T.

Make the logic simpler, fixes it for ISDB-T and make it clearer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 219 +++++++++++++++++-----------------
 1 file changed, 109 insertions(+), 110 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index bbc1965..a7317ae 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1509,9 +1509,17 @@ static bool is_dvbv3_delsys(u32 delsys)
 	return status;
 }
 
-static int emulate_delivery_system(struct dvb_frontend *fe,
-				   enum dvbv3_emulation_type type,
-				   u32 delsys, u32 desired_system)
+/**
+ * emulate_delivery_system - emulate a DVBv5 delivery system with a DVBv3 type
+ * @fe:			struct frontend;
+ * @desired_system:	DVBv5 type that will be used for emulation
+ *
+ * Provides emulation for delivery systems that are compatible with the old
+ * DVBv3 call. Among its usages, it provices support for ISDB-T, and allows
+ * using a DVB-S2 only frontend just like it were a DVB-S, if the frontent
+ * parameters are compatible with DVB-S spec.
+ */
+static int emulate_delivery_system(struct dvb_frontend *fe, u32 delsys)
 {
 	int i;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -1519,51 +1527,52 @@ static int emulate_delivery_system(struct dvb_frontend *fe,
 	c->delivery_system = delsys;
 
 	/*
-	 * The DVBv3 or DVBv5 call is requesting a different system. So,
-	 * emulation is needed.
-	 *
-	 * Emulate newer delivery systems like ISDBT, DVBT and DTMB
-	 * for older DVBv5 applications. The emulation will try to use
-	 * the auto mode for most things, and will assume that the desired
-	 * delivery system is the last one at the ops.delsys[] array
+	 * If the call is for ISDB-T, put it into full-seg, auto mode, TV
 	 */
-	dev_dbg(fe->dvb->device,
-		"%s: Using delivery system %d emulated as if it were a %d\n",
-		__func__, delsys, desired_system);
+	if (c->delivery_system == SYS_ISDBT) {
+		dev_dbg(fe->dvb->device,
+			"%s: Using defaults for SYS_ISDBT\n",
+			__func__);
 
-	/*
-	 * For now, handles ISDB-T calls. More code may be needed here for the
-	 * other emulated stuff
-	 */
-	if (type == DVBV3_OFDM) {
-		if (c->delivery_system == SYS_ISDBT) {
-			dev_dbg(fe->dvb->device,
-					"%s: Using defaults for SYS_ISDBT\n",
-					__func__);
-
-			if (!c->bandwidth_hz)
-				c->bandwidth_hz = 6000000;
-
-			c->isdbt_partial_reception = 0;
-			c->isdbt_sb_mode = 0;
-			c->isdbt_sb_subchannel = 0;
-			c->isdbt_sb_segment_idx = 0;
-			c->isdbt_sb_segment_count = 0;
-			c->isdbt_layer_enabled = 0;
-			for (i = 0; i < 3; i++) {
-				c->layer[i].fec = FEC_AUTO;
-				c->layer[i].modulation = QAM_AUTO;
-				c->layer[i].interleaving = 0;
-				c->layer[i].segment_count = 0;
-			}
+		if (!c->bandwidth_hz)
+			c->bandwidth_hz = 6000000;
+
+		c->isdbt_partial_reception = 0;
+		c->isdbt_sb_mode = 0;
+		c->isdbt_sb_subchannel = 0;
+		c->isdbt_sb_segment_idx = 0;
+		c->isdbt_sb_segment_count = 0;
+		c->isdbt_layer_enabled = 7;
+		for (i = 0; i < 3; i++) {
+			c->layer[i].fec = FEC_AUTO;
+			c->layer[i].modulation = QAM_AUTO;
+			c->layer[i].interleaving = 0;
+			c->layer[i].segment_count = 0;
 		}
 	}
 	dev_dbg(fe->dvb->device, "%s: change delivery system on cache to %d\n",
-			__func__, c->delivery_system);
+		__func__, c->delivery_system);
 
 	return 0;
 }
 
+/**
+ * dvbv5_set_delivery_system - Sets the delivery system for a DVBv5 API call
+ * @fe:			frontend struct
+ * @desired_system:	delivery system requested by the user
+ *
+ * A DVBv5 call know what's the desired system it wants. So, set it.
+ *
+ * There are, however, a few known issues with early DVBv5 applications that
+ * are also handled by this logic:
+ *
+ * 1) Some early apps use SYS_UNDEFINED as the desired delivery system.
+ *    This is an API violation, but, as we don't want to break userspace,
+ *    convert it to the first supported delivery system.
+ * 2) Some apps might be using a DVBv5 call in a wrong way, passing, for
+ *    example, SYS_DVBT instead of SYS_ISDBT. This is because early usage of
+ *    ISDB-T provided backward compat with DVB-T.
+ */
 static int dvbv5_set_delivery_system(struct dvb_frontend *fe,
 				     u32 desired_system)
 {
@@ -1578,15 +1587,14 @@ static int dvbv5_set_delivery_system(struct dvb_frontend *fe,
 	 * assume that the application wants to use the first supported
 	 * delivery system.
 	 */
-	if (c->delivery_system == SYS_UNDEFINED)
-	        c->delivery_system = fe->ops.delsys[0];
+	if (desired_system == SYS_UNDEFINED)
+	        desired_system = fe->ops.delsys[0];
 
 	/*
-	* This is a DVBv5 call. So, it likely knows the supported
-	* delivery systems.
-	*/
-
-	/* Check if the desired delivery system is supported */
+	 * This is a DVBv5 call. So, it likely knows the supported
+	 * delivery systems. So, check if the desired delivery system is
+	 * supported
+	 */
 	ncaps = 0;
 	while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
 		if (fe->ops.delsys[ncaps] == desired_system) {
@@ -1600,70 +1608,86 @@ static int dvbv5_set_delivery_system(struct dvb_frontend *fe,
 	}
 
 	/*
-	 * Need to emulate a delivery system
+	 * The requested delivery system isn't supported. Maybe userspace
+	 * is requesting a DVBv3 compatible delivery system.
+	 *
+	 * The emulation only works if the desired system is one of the
+	 * delivery systems supported by DVBv3 API
 	 */
-
-	type = dvbv3_type(desired_system);
-
-	/*
-	* The delivery system is not supported. See if it can be
-	* emulated.
-	* The emulation only works if the desired system is one of the
-	* DVBv3 delivery systems
-	*/
 	if (!is_dvbv3_delsys(desired_system)) {
 		dev_dbg(fe->dvb->device,
-			"%s: can't use a DVBv3 FE_SET_FRONTEND call for this frontend\n",
-			__func__);
+			"%s: Delivery system %d not supported.\n",
+			__func__, desired_system);
 		return -EINVAL;
 	}
 
+	type = dvbv3_type(desired_system);
+
 	/*
 	* Get the last non-DVBv3 delivery system that has the same type
 	* of the desired system
 	*/
 	ncaps = 0;
 	while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
-		if ((dvbv3_type(fe->ops.delsys[ncaps]) == type) &&
-		    !is_dvbv3_delsys(fe->ops.delsys[ncaps]))
+		if (dvbv3_type(fe->ops.delsys[ncaps]) == type)
 			delsys = fe->ops.delsys[ncaps];
 		ncaps++;
 	}
+
 	/* There's nothing compatible with the desired delivery system */
 	if (delsys == SYS_UNDEFINED) {
 		dev_dbg(fe->dvb->device,
-				"%s: Incompatible DVBv3 FE_SET_FRONTEND call for this frontend\n",
-				__func__);
+			"%s: Delivery system %d not supported on emulation mode.\n",
+			__func__, desired_system);
 		return -EINVAL;
 	}
 
-	return emulate_delivery_system(fe, type, delsys, desired_system);
+	dev_dbg(fe->dvb->device,
+		"%s: Using delivery system %d emulated as if it were %d\n",
+		__func__, delsys, desired_system);
+
+	return emulate_delivery_system(fe, desired_system);
 }
 
+/**
+ * dvbv3_set_delivery_system - Sets the delivery system for a DVBv3 API call
+ * @fe:	frontend struct
+ *
+ * A DVBv3 call doesn't know what's the desired system it wants. It also
+ * doesn't allow to switch between different types. Due to that, userspace
+ * should use DVBv5 instead.
+ * However, in order to avoid breaking userspace API, limited backward
+ * compatibility support is provided.
+ *
+ * There are some delivery systems that are incompatible with DVBv3 calls.
+ *
+ * This routine should work fine for frontends that support just one delivery
+ * system.
+ *
+ * For frontends that support multiple frontends:
+ * 1) It defaults to use the first supported delivery system. There's an
+ *    userspace application that allows changing it at runtime;
+ *
+ * 2) If the current delivery system is not compatible with DVBv3, it gets
+ *    the first one that it is compatible.
+ *
+ * NOTE: in order for this to work with applications like Kaffeine that
+ *	uses a DVBv5 call for DVB-S2 and a DVBv3 call to go back to
+ *	DVB-S, drivers that support both DVB-S and DVB-S2 should have the
+ * 	SYS_DVBS entry before the SYS_DVBS2, otherwise it won't switch back
+ *	to DVB-S.
+ */
 static int dvbv3_set_delivery_system(struct dvb_frontend *fe)
 {
 	int ncaps;
-	u32 desired_system;
 	u32 delsys = SYS_UNDEFINED;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	enum dvbv3_emulation_type type;
 
 	/* If not set yet, defaults to the first supported delivery system */
 	if (c->delivery_system == SYS_UNDEFINED)
 	        c->delivery_system = fe->ops.delsys[0];
 
 	/*
-	 * A DVBv3 call doesn't know what's the desired system.
-	 * Also, DVBv3 applications don't know that ops.info->type
-	 * could be changed, and they simply don't tune when it doesn't
-	 * match.
-	 * So, don't change the current delivery system, as it
-	 * may be trying to do the wrong thing, like setting an
-	 * ISDB-T frontend as DVB-T. Instead, find the closest
-	 * DVBv3 system that matches the delivery system.
-	 */
-
-	/*
 	 * Trivial case: just use the current one, if it already a DVBv3
 	 * delivery system
 	 */
@@ -1674,50 +1698,25 @@ static int dvbv3_set_delivery_system(struct dvb_frontend *fe)
 		return 0;
 	}
 
-	/* Convert from DVBv3 into DVBv5 namespace */
-	type = dvbv3_type(c->delivery_system);
-	switch (type) {
-	case DVBV3_QPSK:
-		desired_system = SYS_DVBS;
-		break;
-	case DVBV3_QAM:
-		desired_system = SYS_DVBC_ANNEX_A;
-		break;
-	case DVBV3_ATSC:
-		desired_system = SYS_ATSC;
-		break;
-	case DVBV3_OFDM:
-		desired_system = SYS_DVBT;
-		break;
-	default:
-		dev_dbg(fe->dvb->device, "%s: This frontend doesn't support DVBv3 calls\n",
-				__func__);
-		return -EINVAL;
-	}
-
 	/*
-	 * Get a delivery system that is compatible with DVBv3
-	 * NOTE: in order for this to work with softwares like Kaffeine that
-	 *	uses a DVBv5 call for DVB-S2 and a DVBv3 call to go back to
-	 *	DVB-S, drivers that support both should put the SYS_DVBS entry
-	 *	before the SYS_DVBS2, otherwise it won't switch back to DVB-S.
-	 *	The real fix is that userspace applications should not use DVBv3
-	 *	and not trust on calling FE_SET_FRONTEND to switch the delivery
-	 *	system.
+	 * Seek for the first delivery system that it is compatible with a
+	 * DVBv3 standard
 	 */
 	ncaps = 0;
 	while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
-		if (fe->ops.delsys[ncaps] == desired_system) {
-			delsys = desired_system;
+		if (dvbv3_type(fe->ops.delsys[ncaps]) != DVBV3_UNKNOWN) {
+			delsys = fe->ops.delsys[ncaps];
 			break;
 		}
 		ncaps++;
 	}
 	if (delsys == SYS_UNDEFINED) {
-		dev_dbg(fe->dvb->device, "%s: Couldn't find a delivery system that matches %d\n",
-			__func__, desired_system);
+		dev_dbg(fe->dvb->device,
+			"%s: Couldn't find a delivery system that works with FE_SET_FRONTEND\n",
+			__func__);
+		return -EINVAL;
 	}
-	return emulate_delivery_system(fe, type, delsys, desired_system);
+	return emulate_delivery_system(fe, delsys);
 }
 
 static int dtv_property_process_set(struct dvb_frontend *fe,
-- 
1.8.1.4

