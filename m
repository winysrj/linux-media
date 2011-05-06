Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:57121 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab1EFKBf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2011 06:01:35 -0400
Message-ID: <4DC3C6FA.8070505@linuxtv.org>
Date: Fri, 06 May 2011 12:01:30 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] Sony CXD2820R DVB-T/T2/C	demodulator
 driver
References: <E1QHwSm-0006hA-A9@www.linuxtv.org>
In-Reply-To: <E1QHwSm-0006hA-A9@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/05/2011 12:53 PM, Mauro Carvalho Chehab wrote:
> +		switch (priv->delivery_system) {
> +		case SYS_UNDEFINED:
> +			if (c->delivery_system == SYS_DVBT) {
> +				/* SLEEP => DVB-T */
> +				ret = cxd2820r_set_frontend_t(fe, p);
> +			} else {
> +				/* SLEEP => DVB-T2 */
> +				ret = cxd2820r_set_frontend_t2(fe, p);
> +			}
> +			break;
> +		case SYS_DVBT:
> +			if (c->delivery_system == SYS_DVBT) {
> +				/* DVB-T => DVB-T */
> +				ret = cxd2820r_set_frontend_t(fe, p);
> +			} else if (c->delivery_system == SYS_DVBT2) {
> +				/* DVB-T => DVB-T2 */
> +				ret = cxd2820r_sleep_t(fe);
> +				ret = cxd2820r_set_frontend_t2(fe, p);
> +			}
> +			break;
> +		case SYS_DVBT2:
> +			if (c->delivery_system == SYS_DVBT2) {

Is this driver compilable? I don't see the necessary changes to
linux/dvb/frontend.h to add SYS_DVBT2 in your tree.

See below for a patch that I used for testing DVB-T2 internally.

Regards,
Andreas

--
commit e89f95641f29b7a4457e7a68649f4374933e36a2
Author: Andreas Oberritter <obi@linuxtv.org>
Date:   Mon Mar 15 14:43:52 2010 +0100

    DVB: Add basic API support for DVB-T2 and bump minor version
    
    Signed-off-by: Andreas Oberritter <obi@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index f5016ae..6f06efe 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1141,10 +1141,9 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
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
