Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab2AAULY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jan 2012 15:11:24 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q01KBO6T002853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Jan 2012 15:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/9] [media] dvb_frontend: Fix DVBv3 emulation
Date: Sun,  1 Jan 2012 18:11:14 -0200
Message-Id: <1325448678-13001-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For frontends with ISDB-T, DVB-T2, CMDBTH, etc, some code is
needed, in order to provide emulation. Add such code, and check
if the desired delivery system is supported by the frontend.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |  140 ++++++++++++++++++++++++++++-
 1 files changed, 139 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 7f6ce06..c1b3b30 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1422,6 +1422,139 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 
 static int dtv_set_frontend(struct dvb_frontend *fe);
 
+static bool is_dvbv3_delsys(u32 delsys)
+{
+	bool status;
+
+	status = (delsys == SYS_DVBT) || (delsys == SYS_DVBC_ANNEX_A) ||
+		 (delsys == SYS_DVBS) || (delsys == SYS_ATSC);
+
+	return status;
+}
+
+static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
+{
+	int ncaps, i;
+	u32 delsys = SYS_UNDEFINED;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	enum dvbv3_emulation_type type;
+
+	if (desired_system == SYS_UNDEFINED) {
+		/*
+		 * A DVBv3 call doesn't know what's the desired system.
+		 * So, don't change the current delivery system. Instead,
+		 * find the closest DVBv3 system that matches the delivery
+		 * system.
+		 */
+		if (is_dvbv3_delsys(c->delivery_system)) {
+			dprintk("%s() Using delivery system to %d\n",
+				__func__, c->delivery_system);
+			return 0;
+		}
+		type = dvbv3_type(c->delivery_system);
+		switch (type) {
+		case DVBV3_QPSK:
+			desired_system = FE_QPSK;
+			break;
+		case DVBV3_QAM:
+			desired_system = FE_QAM;
+			break;
+		case DVBV3_ATSC:
+			desired_system = FE_ATSC;
+			break;
+		case DVBV3_OFDM:
+			desired_system = FE_OFDM;
+			break;
+		default:
+			dprintk("%s(): This frontend doesn't support DVBv3 calls\n",
+				__func__);
+			return -EINVAL;
+		}
+		delsys = c->delivery_system;
+	} else {
+		/*
+		 * Check if the desired delivery system is supported
+		 */
+		ncaps = 0;
+		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+			if (fe->ops.delsys[ncaps] == desired_system) {
+				c->delivery_system = desired_system;
+				dprintk("%s() Changing delivery system to %d\n",
+					__func__, desired_system);
+				return 0;
+			}
+		}
+		type = dvbv3_type(desired_system);
+
+		/*
+		 * The delivery system is not supported. See if it can be
+		 * emulated.
+		 * The emulation only works if the desired system is one of the
+		 * DVBv3 delivery systems
+		 */
+		if (!is_dvbv3_delsys(desired_system)) {
+			dprintk("%s() can't use a DVBv3 FE_SET_FRONTEND call on this frontend\n",
+				__func__);
+			return -EINVAL;
+		}
+
+		/*
+		 * Get the last non-DVBv3 delivery system that has the same type
+		 * of the desired system
+		 */
+		ncaps = 0;
+		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+			if ((dvbv3_type(fe->ops.delsys[ncaps]) == type) &&
+			    !is_dvbv3_delsys(fe->ops.delsys[ncaps]))
+				delsys = fe->ops.delsys[ncaps];
+			ncaps++;
+		}
+		/* There's nothing compatible with the desired delivery system */
+		if (delsys == SYS_UNDEFINED) {
+			dprintk("%s() Incompatible DVBv3 FE_SET_FRONTEND call for this frontend\n",
+				__func__);
+			return -EINVAL;
+		}
+		c->delivery_system = delsys;
+	}
+
+	/*
+	 * Emulate newer delivery systems like ISDBT, DVBT and DMBTH
+	 * for older DVBv5 applications. The emulation will try to use
+	 * the auto mode for most things, and will assume that the desired
+	 * delivery system is the last one at the ops.delsys[] array
+	 */
+	dprintk("%s() Using delivery system %d emulated as if it were a %d\n",
+		__func__, delsys, desired_system);
+
+	/*
+	 * For now, uses it for ISDB-T, DMBTH and DVB-T2
+	 * For DVB-S2 and DVB-TURBO, assumes that the DVB-S parameters are enough.
+	 */
+	if (type == DVBV3_OFDM) {
+		c->modulation = QAM_AUTO;
+		c->code_rate_HP = FEC_AUTO;
+		c->code_rate_LP = FEC_AUTO;
+		c->transmission_mode = TRANSMISSION_MODE_AUTO;
+		c->guard_interval = GUARD_INTERVAL_AUTO;
+		c->hierarchy = HIERARCHY_AUTO;
+
+		c->isdbt_partial_reception = -1;
+		c->isdbt_sb_mode = -1;
+		c->isdbt_sb_subchannel = -1;
+		c->isdbt_sb_segment_idx = -1;
+		c->isdbt_sb_segment_count = -1;
+		c->isdbt_layer_enabled = 0x7;
+		for (i = 0; i < 3; i++) {
+			c->layer[i].fec = FEC_AUTO;
+			c->layer[i].modulation = QAM_AUTO;
+			c->layer[i].interleaving = -1;
+			c->layer[i].segment_count = -1;
+		}
+	}
+	return 0;
+}
+
 static int dtv_property_process_set(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
 				    struct file *file)
@@ -1484,7 +1617,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		c->rolloff = tvp->u.data;
 		break;
 	case DTV_DELIVERY_SYSTEM:
-		c->delivery_system = tvp->u.data;
+		r = set_delivery_system(fe, tvp->u.data);
 		break;
 	case DTV_VOLTAGE:
 		c->voltage = tvp->u.data;
@@ -2043,6 +2176,11 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		/* Synchronise DVBv5 parameters from DVBv3 */
 		memcpy (&fepriv->parameters_in, parg,
 			sizeof (struct dvb_frontend_parameters));
+
+		err = set_delivery_system(fe, SYS_UNDEFINED);
+		if (err)
+			break;
+
 		err = dtv_property_cache_sync(fe, c, &fepriv->parameters_in);
 		if (err)
 			break;
-- 
1.7.8.352.g876a6

