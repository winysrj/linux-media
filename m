Return-path: <mchehab@gaivota>
Received: from ffm.saftware.de ([83.141.3.46]:43968 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab1EHWWm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 18:22:42 -0400
Message-ID: <4DC717AD.8030609@linuxtv.org>
Date: Mon, 09 May 2011 00:22:37 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] DVB: Add basic API support for DVB-T2 and bump
 minor version
References: <4DC6BF28.8070006@redhat.com> <1304882240-23044-2-git-send-email-steve@stevekerrison.com>
In-Reply-To: <1304882240-23044-2-git-send-email-steve@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 05/08/2011 09:17 PM, Steve Kerrison wrote:
> From: Andreas Oberritter <obi@linuxtv.org>
> 
> steve@stevekerrison.com: Remove private definitions from cxd2820r that existed before API was defined
> 
> Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
> Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c   |    7 +++----
>  drivers/media/dvb/frontends/cxd2820r_priv.h |   12 ------------
>  include/linux/dvb/frontend.h                |   20 ++++++++++++++++----
>  include/linux/dvb/version.h                 |    2 +-
>  4 files changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 31e2c0d..e30beef 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -1148,10 +1148,9 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
>  		break;
>  	}
>  
> -	if(c->delivery_system == SYS_ISDBT) {
> -		/* Fake out a generic DVB-T request so we pass validation in the ioctl */
> -		p->frequency = c->frequency;
> -		p->inversion = c->inversion;
> +	/* Fake out a generic DVB-T request so we pass validation in the ioctl */
> +	if ((c->delivery_system == SYS_ISDBT) ||
> +	    (c->delivery_system == SYS_DVBT2)) {
>  		p->u.ofdm.constellation = QAM_AUTO;
>  		p->u.ofdm.code_rate_HP = FEC_AUTO;
>  		p->u.ofdm.code_rate_LP = FEC_AUTO;
> diff --git a/drivers/media/dvb/frontends/cxd2820r_priv.h b/drivers/media/dvb/frontends/cxd2820r_priv.h
> index d4e2e0b..25adbee 100644
> --- a/drivers/media/dvb/frontends/cxd2820r_priv.h
> +++ b/drivers/media/dvb/frontends/cxd2820r_priv.h
> @@ -40,18 +40,6 @@
>  #undef warn
>  #define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
>  
> -/*
> - * FIXME: These are totally wrong and must be added properly to the API.
> - * Only temporary solution in order to get driver compile.
> - */
> -#define SYS_DVBT2             SYS_DAB
> -#define TRANSMISSION_MODE_1K  0
> -#define TRANSMISSION_MODE_16K 0
> -#define TRANSMISSION_MODE_32K 0
> -#define GUARD_INTERVAL_1_128  0
> -#define GUARD_INTERVAL_19_128 0
> -#define GUARD_INTERVAL_19_256 0
> -
>  struct reg_val_mask {
>  	u32 reg;
>  	u8  val;
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index 493a2bf..36a3ed6 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -175,14 +175,20 @@ typedef enum fe_transmit_mode {
>  	TRANSMISSION_MODE_2K,
>  	TRANSMISSION_MODE_8K,
>  	TRANSMISSION_MODE_AUTO,
> -	TRANSMISSION_MODE_4K
> +	TRANSMISSION_MODE_4K,
> +	TRANSMISSION_MODE_1K,
> +	TRANSMISSION_MODE_16K,
> +	TRANSMISSION_MODE_32K,
>  } fe_transmit_mode_t;
>  
>  typedef enum fe_bandwidth {
>  	BANDWIDTH_8_MHZ,
>  	BANDWIDTH_7_MHZ,
>  	BANDWIDTH_6_MHZ,
> -	BANDWIDTH_AUTO
> +	BANDWIDTH_AUTO,
> +	BANDWIDTH_5_MHZ,
> +	BANDWIDTH_10_MHZ,
> +	BANDWIDTH_1_712_MHZ,
>  } fe_bandwidth_t;
>  
>  
> @@ -191,7 +197,10 @@ typedef enum fe_guard_interval {
>  	GUARD_INTERVAL_1_16,
>  	GUARD_INTERVAL_1_8,
>  	GUARD_INTERVAL_1_4,
> -	GUARD_INTERVAL_AUTO
> +	GUARD_INTERVAL_AUTO,
> +	GUARD_INTERVAL_1_128,
> +	GUARD_INTERVAL_19_128,
> +	GUARD_INTERVAL_19_256,
>  } fe_guard_interval_t;
>  
>  
> @@ -305,7 +314,9 @@ struct dvb_frontend_event {
>  
>  #define DTV_ISDBS_TS_ID		42
>  
> -#define DTV_MAX_COMMAND				DTV_ISDBS_TS_ID
> +#define DTV_DVBT2_PLP_ID	43
> +
> +#define DTV_MAX_COMMAND				DTV_DVBT2_PLP_ID
>  
>  typedef enum fe_pilot {
>  	PILOT_ON,
> @@ -337,6 +348,7 @@ typedef enum fe_delivery_system {
>  	SYS_DMBTH,
>  	SYS_CMMB,
>  	SYS_DAB,
> +	SYS_DVBT2,
>  } fe_delivery_system_t;
>  
>  struct dtv_cmds_h {
> diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
> index 5a7546c..1421cc8 100644
> --- a/include/linux/dvb/version.h
> +++ b/include/linux/dvb/version.h
> @@ -24,6 +24,6 @@
>  #define _DVBVERSION_H_
>  
>  #define DVB_API_VERSION 5
> -#define DVB_API_VERSION_MINOR 2
> +#define DVB_API_VERSION_MINOR 3
>  
>  #endif /*_DVBVERSION_H_*/

Please also include the following (only compile-tested) lines within this commit:

>From 4329b836a6590421b178710160fcca3b39f64e18 Mon Sep 17 00:00:00 2001
From: Andreas Oberritter <obi@linuxtv.org>
Date: Sun, 8 May 2011 22:14:07 +0000
Subject: [PATCH] DVB: dvb_frontend: add PLP ID to property cache

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    6 ++++++
 drivers/media/dvb/dvb-core/dvb_frontend.h |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index dc3457c..5af1d67 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1323,6 +1323,9 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 	case DTV_ISDBS_TS_ID:
 		tvp->u.data = fe->dtv_property_cache.isdbs_ts_id;
 		break;
+	case DTV_DVBT2_PLP_ID:
+		tvp->u.data = c->dvbt2_plp_id;
+		break;
 	default:
 		r = -1;
 	}
@@ -1478,6 +1481,9 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	case DTV_ISDBS_TS_ID:
 		fe->dtv_property_cache.isdbs_ts_id = tvp->u.data;
 		break;
+	case DTV_DVBT2_PLP_ID:
+		c->dvbt2_plp_id = tvp->u.data;
+		break;
 	default:
 		r = -1;
 	}
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 3b86050..fb2b13f 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -358,6 +358,9 @@ struct dtv_frontend_properties {
 
 	/* ISDB-T specifics */
 	u32			isdbs_ts_id;
+
+	/* DVB-T2 specifics */
+	u32			dvbt2_plp_id;
 };
 
 struct dvb_frontend {
-- 
1.7.2.5


