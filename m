Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32942 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757624Ab2HQBfq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 21:35:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/6] add LNA support for DVB API
Date: Fri, 17 Aug 2012 04:35:05 +0300
Message-Id: <1345167310-8738-2-git-send-email-crope@iki.fi>
In-Reply-To: <1345167310-8738-1-git-send-email-crope@iki.fi>
References: <1345167310-8738-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb_frontend.c | 5 +++++
 drivers/media/dvb-core/dvb_frontend.h | 1 +
 include/linux/dvb/frontend.h          | 4 +++-
 include/linux/dvb/version.h           | 2 +-
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 7d079fb..d29d41a 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1023,6 +1023,7 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 
 	_DTV_CMD(DTV_ISDBS_TS_ID, 1, 0),
 	_DTV_CMD(DTV_DVBT2_PLP_ID, 1, 0),
+	_DTV_CMD(DTV_LNA, 1, 0),
 
 	/* Get */
 	_DTV_CMD(DTV_DISEQC_SLAVE_REPLY, 0, 1),
@@ -1731,6 +1732,10 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	case DTV_INTERLEAVING:
 		c->interleaving = tvp->u.data;
 		break;
+	case DTV_LNA:
+		if (fe->ops.set_lna)
+			r = fe->ops.set_lna(fe, tvp->u.data);
+		break;
 
 	/* ISDB-T Support here */
 	case DTV_ISDBT_PARTIAL_RECEPTION:
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index db309db..74ba563 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -303,6 +303,7 @@ struct dvb_frontend_ops {
 	int (*dishnetwork_send_legacy_command)(struct dvb_frontend* fe, unsigned long cmd);
 	int (*i2c_gate_ctrl)(struct dvb_frontend* fe, int enable);
 	int (*ts_bus_ctrl)(struct dvb_frontend* fe, int acquire);
+	int (*set_lna)(struct dvb_frontend *, int);
 
 	/* These callbacks are for devices that implement their own
 	 * tuning algorithms, rather than a simple swzigzag
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index bb51edf..4098021 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -362,8 +362,9 @@ struct dvb_frontend_event {
 #define DTV_ATSCMH_SCCC_CODE_MODE_D	59
 
 #define DTV_INTERLEAVING			60
+#define DTV_LNA					61
 
-#define DTV_MAX_COMMAND				DTV_INTERLEAVING
+#define DTV_MAX_COMMAND				DTV_LNA
 
 typedef enum fe_pilot {
 	PILOT_ON,
@@ -436,6 +437,7 @@ enum atscmh_rs_code_mode {
 	ATSCMH_RSCODE_RES        = 3,
 };
 
+#define LNA_AUTO INT_MIN
 
 struct dtv_cmds_h {
 	char	*name;		/* A display name for debugging purposes */
diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
index 70c2c7e..20e5eac 100644
--- a/include/linux/dvb/version.h
+++ b/include/linux/dvb/version.h
@@ -24,6 +24,6 @@
 #define _DVBVERSION_H_
 
 #define DVB_API_VERSION 5
-#define DVB_API_VERSION_MINOR 7
+#define DVB_API_VERSION_MINOR 8
 
 #endif /*_DVBVERSION_H_*/
-- 
1.7.11.2

