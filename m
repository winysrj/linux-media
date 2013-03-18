Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab3CRTZo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 15:25:44 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2IJPiTg014258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 18 Mar 2013 15:25:44 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] dvb-frontend: split set_delivery_system()
Date: Mon, 18 Mar 2013 16:25:36 -0300
Message-Id: <1363634737-22550-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function is complex, and has different workflows, one for
DVBv3 calls, and another one for DVBv5 calls. Break it into 3
functions, in order to make easier to understand what each
block does.

No functional changes so far. A few comments got improved.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 292 +++++++++++++++++++---------------
 1 file changed, 164 insertions(+), 128 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 6e50a75..bbc1965 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1509,132 +1509,12 @@ static bool is_dvbv3_delsys(u32 delsys)
 	return status;
 }
 
-static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
+static int emulate_delivery_system(struct dvb_frontend *fe,
+				   enum dvbv3_emulation_type type,
+				   u32 delsys, u32 desired_system)
 {
-	int ncaps, i;
-	u32 delsys = SYS_UNDEFINED;
+	int i;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	enum dvbv3_emulation_type type;
-
-	/*
-	 * It was reported that some old DVBv5 applications were
-	 * filling delivery_system with SYS_UNDEFINED. If this happens,
-	 * assume that the application wants to use the first supported
-	 * delivery system.
-	 */
-	if (c->delivery_system == SYS_UNDEFINED)
-	        c->delivery_system = fe->ops.delsys[0];
-
-	if (desired_system == SYS_UNDEFINED) {
-		/*
-		 * A DVBv3 call doesn't know what's the desired system.
-		 * Also, DVBv3 applications don't know that ops.info->type
-		 * could be changed, and they simply dies when it doesn't
-		 * match.
-		 * So, don't change the current delivery system, as it
-		 * may be trying to do the wrong thing, like setting an
-		 * ISDB-T frontend as DVB-T. Instead, find the closest
-		 * DVBv3 system that matches the delivery system.
-		 */
-		if (is_dvbv3_delsys(c->delivery_system)) {
-			dev_dbg(fe->dvb->device,
-					"%s: Using delivery system to %d\n",
-					__func__, c->delivery_system);
-			return 0;
-		}
-		type = dvbv3_type(c->delivery_system);
-		switch (type) {
-		case DVBV3_QPSK:
-			desired_system = SYS_DVBS;
-			break;
-		case DVBV3_QAM:
-			desired_system = SYS_DVBC_ANNEX_A;
-			break;
-		case DVBV3_ATSC:
-			desired_system = SYS_ATSC;
-			break;
-		case DVBV3_OFDM:
-			desired_system = SYS_DVBT;
-			break;
-		default:
-			dev_dbg(fe->dvb->device, "%s: This frontend doesn't support DVBv3 calls\n",
-					__func__);
-			return -EINVAL;
-		}
-		/*
-		 * Get a delivery system that is compatible with DVBv3
-		 * NOTE: in order for this to work with softwares like Kaffeine that
-		 *	uses a DVBv5 call for DVB-S2 and a DVBv3 call to go back to
-		 *	DVB-S, drivers that support both should put the SYS_DVBS entry
-		 *	before the SYS_DVBS2, otherwise it won't switch back to DVB-S.
-		 *	The real fix is that userspace applications should not use DVBv3
-		 *	and not trust on calling FE_SET_FRONTEND to switch the delivery
-		 *	system.
-		 */
-		ncaps = 0;
-		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
-			if (fe->ops.delsys[ncaps] == desired_system) {
-				delsys = desired_system;
-				break;
-			}
-			ncaps++;
-		}
-		if (delsys == SYS_UNDEFINED) {
-			dev_dbg(fe->dvb->device, "%s: Couldn't find a delivery system that matches %d\n",
-					__func__, desired_system);
-		}
-	} else {
-		/*
-		 * This is a DVBv5 call. So, it likely knows the supported
-		 * delivery systems.
-		 */
-
-		/* Check if the desired delivery system is supported */
-		ncaps = 0;
-		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
-			if (fe->ops.delsys[ncaps] == desired_system) {
-				c->delivery_system = desired_system;
-				dev_dbg(fe->dvb->device,
-						"%s: Changing delivery system to %d\n",
-						__func__, desired_system);
-				return 0;
-			}
-			ncaps++;
-		}
-		type = dvbv3_type(desired_system);
-
-		/*
-		 * The delivery system is not supported. See if it can be
-		 * emulated.
-		 * The emulation only works if the desired system is one of the
-		 * DVBv3 delivery systems
-		 */
-		if (!is_dvbv3_delsys(desired_system)) {
-			dev_dbg(fe->dvb->device,
-					"%s: can't use a DVBv3 FE_SET_FRONTEND call on this frontend\n",
-					__func__);
-			return -EINVAL;
-		}
-
-		/*
-		 * Get the last non-DVBv3 delivery system that has the same type
-		 * of the desired system
-		 */
-		ncaps = 0;
-		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
-			if ((dvbv3_type(fe->ops.delsys[ncaps]) == type) &&
-			    !is_dvbv3_delsys(fe->ops.delsys[ncaps]))
-				delsys = fe->ops.delsys[ncaps];
-			ncaps++;
-		}
-		/* There's nothing compatible with the desired delivery system */
-		if (delsys == SYS_UNDEFINED) {
-			dev_dbg(fe->dvb->device,
-					"%s: Incompatible DVBv3 FE_SET_FRONTEND call for this frontend\n",
-					__func__);
-			return -EINVAL;
-		}
-	}
 
 	c->delivery_system = delsys;
 
@@ -1648,8 +1528,8 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 	 * delivery system is the last one at the ops.delsys[] array
 	 */
 	dev_dbg(fe->dvb->device,
-			"%s: Using delivery system %d emulated as if it were a %d\n",
-			__func__, delsys, desired_system);
+		"%s: Using delivery system %d emulated as if it were a %d\n",
+		__func__, delsys, desired_system);
 
 	/*
 	 * For now, handles ISDB-T calls. More code may be needed here for the
@@ -1684,6 +1564,162 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 	return 0;
 }
 
+static int dvbv5_set_delivery_system(struct dvb_frontend *fe,
+				     u32 desired_system)
+{
+	int ncaps;
+	u32 delsys = SYS_UNDEFINED;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	enum dvbv3_emulation_type type;
+
+	/*
+	 * It was reported that some old DVBv5 applications were
+	 * filling delivery_system with SYS_UNDEFINED. If this happens,
+	 * assume that the application wants to use the first supported
+	 * delivery system.
+	 */
+	if (c->delivery_system == SYS_UNDEFINED)
+	        c->delivery_system = fe->ops.delsys[0];
+
+	/*
+	* This is a DVBv5 call. So, it likely knows the supported
+	* delivery systems.
+	*/
+
+	/* Check if the desired delivery system is supported */
+	ncaps = 0;
+	while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+		if (fe->ops.delsys[ncaps] == desired_system) {
+			c->delivery_system = desired_system;
+			dev_dbg(fe->dvb->device,
+					"%s: Changing delivery system to %d\n",
+					__func__, desired_system);
+			return 0;
+		}
+		ncaps++;
+	}
+
+	/*
+	 * Need to emulate a delivery system
+	 */
+
+	type = dvbv3_type(desired_system);
+
+	/*
+	* The delivery system is not supported. See if it can be
+	* emulated.
+	* The emulation only works if the desired system is one of the
+	* DVBv3 delivery systems
+	*/
+	if (!is_dvbv3_delsys(desired_system)) {
+		dev_dbg(fe->dvb->device,
+			"%s: can't use a DVBv3 FE_SET_FRONTEND call for this frontend\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	/*
+	* Get the last non-DVBv3 delivery system that has the same type
+	* of the desired system
+	*/
+	ncaps = 0;
+	while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+		if ((dvbv3_type(fe->ops.delsys[ncaps]) == type) &&
+		    !is_dvbv3_delsys(fe->ops.delsys[ncaps]))
+			delsys = fe->ops.delsys[ncaps];
+		ncaps++;
+	}
+	/* There's nothing compatible with the desired delivery system */
+	if (delsys == SYS_UNDEFINED) {
+		dev_dbg(fe->dvb->device,
+				"%s: Incompatible DVBv3 FE_SET_FRONTEND call for this frontend\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	return emulate_delivery_system(fe, type, delsys, desired_system);
+}
+
+static int dvbv3_set_delivery_system(struct dvb_frontend *fe)
+{
+	int ncaps;
+	u32 desired_system;
+	u32 delsys = SYS_UNDEFINED;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	enum dvbv3_emulation_type type;
+
+	/* If not set yet, defaults to the first supported delivery system */
+	if (c->delivery_system == SYS_UNDEFINED)
+	        c->delivery_system = fe->ops.delsys[0];
+
+	/*
+	 * A DVBv3 call doesn't know what's the desired system.
+	 * Also, DVBv3 applications don't know that ops.info->type
+	 * could be changed, and they simply don't tune when it doesn't
+	 * match.
+	 * So, don't change the current delivery system, as it
+	 * may be trying to do the wrong thing, like setting an
+	 * ISDB-T frontend as DVB-T. Instead, find the closest
+	 * DVBv3 system that matches the delivery system.
+	 */
+
+	/*
+	 * Trivial case: just use the current one, if it already a DVBv3
+	 * delivery system
+	 */
+	if (is_dvbv3_delsys(c->delivery_system)) {
+		dev_dbg(fe->dvb->device,
+				"%s: Using delivery system to %d\n",
+				__func__, c->delivery_system);
+		return 0;
+	}
+
+	/* Convert from DVBv3 into DVBv5 namespace */
+	type = dvbv3_type(c->delivery_system);
+	switch (type) {
+	case DVBV3_QPSK:
+		desired_system = SYS_DVBS;
+		break;
+	case DVBV3_QAM:
+		desired_system = SYS_DVBC_ANNEX_A;
+		break;
+	case DVBV3_ATSC:
+		desired_system = SYS_ATSC;
+		break;
+	case DVBV3_OFDM:
+		desired_system = SYS_DVBT;
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: This frontend doesn't support DVBv3 calls\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * Get a delivery system that is compatible with DVBv3
+	 * NOTE: in order for this to work with softwares like Kaffeine that
+	 *	uses a DVBv5 call for DVB-S2 and a DVBv3 call to go back to
+	 *	DVB-S, drivers that support both should put the SYS_DVBS entry
+	 *	before the SYS_DVBS2, otherwise it won't switch back to DVB-S.
+	 *	The real fix is that userspace applications should not use DVBv3
+	 *	and not trust on calling FE_SET_FRONTEND to switch the delivery
+	 *	system.
+	 */
+	ncaps = 0;
+	while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+		if (fe->ops.delsys[ncaps] == desired_system) {
+			delsys = desired_system;
+			break;
+		}
+		ncaps++;
+	}
+	if (delsys == SYS_UNDEFINED) {
+		dev_dbg(fe->dvb->device, "%s: Couldn't find a delivery system that matches %d\n",
+			__func__, desired_system);
+	}
+	return emulate_delivery_system(fe, type, delsys, desired_system);
+}
+
 static int dtv_property_process_set(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
 				    struct file *file)
@@ -1742,7 +1778,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		c->rolloff = tvp->u.data;
 		break;
 	case DTV_DELIVERY_SYSTEM:
-		r = set_delivery_system(fe, tvp->u.data);
+		r = dvbv5_set_delivery_system(fe, tvp->u.data);
 		break;
 	case DTV_VOLTAGE:
 		c->voltage = tvp->u.data;
@@ -2335,7 +2371,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		break;
 
 	case FE_SET_FRONTEND:
-		err = set_delivery_system(fe, SYS_UNDEFINED);
+		err = dvbv3_set_delivery_system(fe);
 		if (err)
 			break;
 
-- 
1.8.1.4

