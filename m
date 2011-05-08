Return-path: <mchehab@gaivota>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:39619 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab1EHPvg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 11:51:36 -0400
From: Steve Kerrison <steve@stevekerrison.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Steve Kerrison <steve@stevekerrison.com>
Subject: [PATCH 1/6] DVB: Add basic API support for DVB-T2 and bump minor version
Date: Sun,  8 May 2011 16:51:08 +0100
Message-Id: <1304869873-9974-2-git-send-email-steve@stevekerrison.com>
In-Reply-To: <4DC417DA.5030107@redhat.com>
References: <4DC417DA.5030107@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Andreas Oberritter <obi@linuxtv.org>

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    7 +++----
 include/linux/dvb/frontend.h              |   20 ++++++++++++++++----
 include/linux/dvb/version.h               |    2 +-
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 31e2c0d..e30beef 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1148,10 +1148,9 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
 		break;
 	}
 
-	if(c->delivery_system == SYS_ISDBT) {
-		/* Fake out a generic DVB-T request so we pass validation in the ioctl */
-		p->frequency = c->frequency;
-		p->inversion = c->inversion;
+	/* Fake out a generic DVB-T request so we pass validation in the ioctl */
+	if ((c->delivery_system == SYS_ISDBT) ||
+	    (c->delivery_system == SYS_DVBT2)) {
 		p->u.ofdm.constellation = QAM_AUTO;
 		p->u.ofdm.code_rate_HP = FEC_AUTO;
 		p->u.ofdm.code_rate_LP = FEC_AUTO;
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 493a2bf..36a3ed6 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -175,14 +175,20 @@ typedef enum fe_transmit_mode {
 	TRANSMISSION_MODE_2K,
 	TRANSMISSION_MODE_8K,
 	TRANSMISSION_MODE_AUTO,
-	TRANSMISSION_MODE_4K
+	TRANSMISSION_MODE_4K,
+	TRANSMISSION_MODE_1K,
+	TRANSMISSION_MODE_16K,
+	TRANSMISSION_MODE_32K,
 } fe_transmit_mode_t;
 
 typedef enum fe_bandwidth {
 	BANDWIDTH_8_MHZ,
 	BANDWIDTH_7_MHZ,
 	BANDWIDTH_6_MHZ,
-	BANDWIDTH_AUTO
+	BANDWIDTH_AUTO,
+	BANDWIDTH_5_MHZ,
+	BANDWIDTH_10_MHZ,
+	BANDWIDTH_1_712_MHZ,
 } fe_bandwidth_t;
 
 
@@ -191,7 +197,10 @@ typedef enum fe_guard_interval {
 	GUARD_INTERVAL_1_16,
 	GUARD_INTERVAL_1_8,
 	GUARD_INTERVAL_1_4,
-	GUARD_INTERVAL_AUTO
+	GUARD_INTERVAL_AUTO,
+	GUARD_INTERVAL_1_128,
+	GUARD_INTERVAL_19_128,
+	GUARD_INTERVAL_19_256,
 } fe_guard_interval_t;
 
 
@@ -305,7 +314,9 @@ struct dvb_frontend_event {
 
 #define DTV_ISDBS_TS_ID		42
 
-#define DTV_MAX_COMMAND				DTV_ISDBS_TS_ID
+#define DTV_DVBT2_PLP_ID	43
+
+#define DTV_MAX_COMMAND				DTV_DVBT2_PLP_ID
 
 typedef enum fe_pilot {
 	PILOT_ON,
@@ -337,6 +348,7 @@ typedef enum fe_delivery_system {
 	SYS_DMBTH,
 	SYS_CMMB,
 	SYS_DAB,
+	SYS_DVBT2,
 } fe_delivery_system_t;
 
 struct dtv_cmds_h {
diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
index 5a7546c..1421cc8 100644
--- a/include/linux/dvb/version.h
+++ b/include/linux/dvb/version.h
@@ -24,6 +24,6 @@
 #define _DVBVERSION_H_
 
 #define DVB_API_VERSION 5
-#define DVB_API_VERSION_MINOR 2
+#define DVB_API_VERSION_MINOR 3
 
 #endif /*_DVBVERSION_H_*/
-- 
1.7.1

