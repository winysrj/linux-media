Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47832 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2APQo2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 11:44:28 -0500
Received: by wgbdq11 with SMTP id dq11so890465wgb.1
        for <linux-media@vger.kernel.org>; Mon, 16 Jan 2012 08:44:27 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH RFCv2] add DTMB support for DVB API
Date: Mon, 16 Jan 2012 17:44:21 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Andreas Oberritter <obi@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <4F119FC4.3090103@iki.fi>
In-Reply-To: <4F119FC4.3090103@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161744.21618.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 14 January 2012 16:31:16 Antti Palosaari wrote:
> Version 2. I have made some changes from feedback got and
> what I myself found better. I will add documentation later
> after API issues are resolved.
> Thanks to Andreas, Patrick and Mauro.
> 
> Cc: Patrick Boettcher <pboettcher@kernellabs.com>
> Cc: Andreas Oberritter <obi@linuxtv.org>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/dvb/dvb-core/dvb_frontend.c |   14 +++++++++++---
>   drivers/media/dvb/dvb-core/dvb_frontend.h |    2 ++
>   drivers/media/dvb/frontends/atbm8830.c    |    2 +-
>   drivers/media/dvb/frontends/lgs8gl5.c     |    2 +-
>   drivers/media/dvb/frontends/lgs8gxx.c     |    2 +-
>   include/linux/dvb/frontend.h              |   22
> +++++++++++++++++++--- include/linux/dvb/version.h               |  
>  2 +-
>   7 files changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c
> b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index b15db4f..abdc203 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -177,7 +177,7 @@ static enum dvbv3_emulation_type dvbv3_type(u32
> delivery_system)
>   	case SYS_DVBT:
>   	case SYS_DVBT2:
>   	case SYS_ISDBT:
> -	case SYS_DMBTH:
> +	case SYS_DTMB:
>   		return DVBV3_OFDM;
>   	case SYS_ATSC:
>   	case SYS_DVBC_ANNEX_B:
> @@ -989,6 +989,7 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND
> + 1] = {
>   	_DTV_CMD(DTV_CODE_RATE_LP, 1, 0),
>   	_DTV_CMD(DTV_GUARD_INTERVAL, 1, 0),
>   	_DTV_CMD(DTV_TRANSMISSION_MODE, 1, 0),
> +	_DTV_CMD(DTV_INTERLEAVING, 1, 0),
> 
>   	_DTV_CMD(DTV_ISDBT_PARTIAL_RECEPTION, 1, 0),
>   	_DTV_CMD(DTV_ISDBT_SOUND_BROADCASTING, 1, 0),
> @@ -1039,6 +1040,7 @@ static struct dtv_cmds_h
> dtv_cmds[DTV_MAX_COMMAND + 1] = {
>   	_DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
>   	_DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
>   	_DTV_CMD(DTV_HIERARCHY, 0, 0),
> +	_DTV_CMD(DTV_INTERLEAVING, 0, 0),
> 
>   	_DTV_CMD(DTV_ENUM_DELSYS, 0, 0),
>   };
> @@ -1316,6 +1318,9 @@ static int dtv_property_process_get(struct
> dvb_frontend *fe,
>   	case DTV_HIERARCHY:
>   		tvp->u.data = c->hierarchy;
>   		break;
> +	case DTV_INTERLEAVING:
> +		tvp->u.data = c->interleaving;
> +		break;
> 
>   	/* ISDB-T Support here */
>   	case DTV_ISDBT_PARTIAL_RECEPTION:
> @@ -1503,7 +1508,7 @@ static int set_delivery_system(struct
> dvb_frontend *fe, u32 desired_system)
>   	 * The DVBv3 or DVBv5 call is requesting a different system. So,
>   	 * emulation is needed.
>   	 *
> -	 * Emulate newer delivery systems like ISDBT, DVBT and DMBTH
> +	 * Emulate newer delivery systems like ISDBT, DVBT and DTMB
>   	 * for older DVBv5 applications. The emulation will try to use
>   	 * the auto mode for most things, and will assume that the desired
>   	 * delivery system is the last one at the ops.delsys[] array
> @@ -1625,6 +1630,9 @@ static int dtv_property_process_set(struct
> dvb_frontend *fe,
>   	case DTV_HIERARCHY:
>   		c->hierarchy = tvp->u.data;
>   		break;
> +	case DTV_INTERLEAVING:
> +		c->interleaving = tvp->u.data;
> +		break;
> 
>   	/* ISDB-T Support here */
>   	case DTV_ISDBT_PARTIAL_RECEPTION:
> @@ -1896,7 +1904,7 @@ static int dtv_set_frontend(struct dvb_frontend
> *fe) case SYS_DVBT:
>   		case SYS_DVBT2:
>   		case SYS_ISDBT:
> -		case SYS_DMBTH:
> +		case SYS_DTMB:
>   			fepriv->min_delay = HZ / 20;
>   			fepriv->step_size = fe->ops.info.frequency_stepsize * 2;
>   			fepriv->max_drift = (fe->ops.info.frequency_stepsize * 2) + 
1;
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h
> b/drivers/media/dvb/dvb-core/dvb_frontend.h
> index d63a821..fb2d57c 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
> @@ -353,6 +353,8 @@ struct dtv_frontend_properties {
> 
>   	fe_delivery_system_t	delivery_system;
> 
> +	fe_interleaving_t       interleaving;
> +
>   	/* ISDB-T specifics */
>   	u8			isdbt_partial_reception;
>   	u8			isdbt_sb_mode;
> diff --git a/drivers/media/dvb/frontends/atbm8830.c
> b/drivers/media/dvb/frontends/atbm8830.c
> index a2261ea..4e11dc4 100644
> --- a/drivers/media/dvb/frontends/atbm8830.c
> +++ b/drivers/media/dvb/frontends/atbm8830.c
> @@ -428,7 +428,7 @@ static int atbm8830_i2c_gate_ctrl(struct
> dvb_frontend *fe, int enable)
>   }
> 
>   static struct dvb_frontend_ops atbm8830_ops = {
> -	.delsys = { SYS_DMBTH },
> +	.delsys = { SYS_DTMB },
>   	.info = {
>   		.name = "AltoBeam ATBM8830/8831 DMB-TH",
>   		.frequency_min = 474000000,
> diff --git a/drivers/media/dvb/frontends/lgs8gl5.c
> b/drivers/media/dvb/frontends/lgs8gl5.c
> index 2cec804..416cce3 100644
> --- a/drivers/media/dvb/frontends/lgs8gl5.c
> +++ b/drivers/media/dvb/frontends/lgs8gl5.c
> @@ -412,7 +412,7 @@ EXPORT_SYMBOL(lgs8gl5_attach);
> 
> 
>   static struct dvb_frontend_ops lgs8gl5_ops = {
> -	.delsys = { SYS_DMBTH },
> +	.delsys = { SYS_DTMB },
>   	.info = {
>   		.name			= "Legend Silicon LGS-8GL5 DMB-TH",
>   		.frequency_min		= 474000000,
> diff --git a/drivers/media/dvb/frontends/lgs8gxx.c
> b/drivers/media/dvb/frontends/lgs8gxx.c
> index 4de1d35..333fd6d 100644
> --- a/drivers/media/dvb/frontends/lgs8gxx.c
> +++ b/drivers/media/dvb/frontends/lgs8gxx.c
> @@ -994,7 +994,7 @@ static int lgs8gxx_i2c_gate_ctrl(struct
> dvb_frontend *fe, int enable)
>   }
> 
>   static struct dvb_frontend_ops lgs8gxx_ops = {
> -	.delsys = { SYS_DMBTH },
> +	.delsys = { SYS_DTMB },
>   	.info = {
>   		.name = "Legend Silicon LGS8913/LGS8GXX DMB-TH",
>   		.frequency_min = 474000000,
> diff --git a/include/linux/dvb/frontend.h
> b/include/linux/dvb/frontend.h index cb4428a..1835c11 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -152,6 +152,9 @@ typedef enum fe_code_rate {
>   	FEC_AUTO,
>   	FEC_3_5,
>   	FEC_9_10,
> +	FEC_04,
> +	FEC_06,
> +	FEC_08,
>   } fe_code_rate_t;
> 
> 
> @@ -169,6 +172,7 @@ typedef enum fe_modulation {
>   	APSK_16,
>   	APSK_32,
>   	DQPSK,
> +	QAM_4_NR,
>   } fe_modulation_t;
> 
>   typedef enum fe_transmit_mode {
> @@ -179,6 +183,8 @@ typedef enum fe_transmit_mode {
>   	TRANSMISSION_MODE_1K,
>   	TRANSMISSION_MODE_16K,
>   	TRANSMISSION_MODE_32K,
> +	TRANSMISSION_MODE_C1,
> +	TRANSMISSION_MODE_C3780,
>   } fe_transmit_mode_t;
> 
>   #if defined(__DVB_CORE__) || !defined (__KERNEL__)
> @@ -202,6 +208,9 @@ typedef enum fe_guard_interval {
>   	GUARD_INTERVAL_1_128,
>   	GUARD_INTERVAL_19_128,
>   	GUARD_INTERVAL_19_256,
> +	GUARD_INTERVAL_PN420,
> +	GUARD_INTERVAL_PN595,
> +	GUARD_INTERVAL_PN945,
>   } fe_guard_interval_t;
> 
> 
> @@ -213,6 +222,11 @@ typedef enum fe_hierarchy {
>   	HIERARCHY_AUTO
>   } fe_hierarchy_t;
> 
> +typedef enum fe_interleaving {
> +	INTERLEAVING_NONE,
> +	INTERLEAVING_240,
> +	INTERLEAVING_720,
> +} fe_interleaving_t;
> 
>   #if defined(__DVB_CORE__) || !defined (__KERNEL__)
>   struct dvb_qpsk_parameters {
> @@ -319,8 +333,9 @@ struct dvb_frontend_event {
>   #define DTV_DVBT2_PLP_ID	43
> 
>   #define DTV_ENUM_DELSYS		44
> +#define DTV_INTERLEAVING			45
> 
> -#define DTV_MAX_COMMAND				DTV_ENUM_DELSYS
> +#define DTV_MAX_COMMAND				DTV_INTERLEAVING
> 
>   typedef enum fe_pilot {
>   	PILOT_ON,
> @@ -349,7 +364,7 @@ typedef enum fe_delivery_system {
>   	SYS_ISDBC,
>   	SYS_ATSC,
>   	SYS_ATSCMH,
> -	SYS_DMBTH,
> +	SYS_DTMB,
>   	SYS_CMMB,
>   	SYS_DAB,
>   	SYS_DVBT2,
> @@ -357,8 +372,9 @@ typedef enum fe_delivery_system {
>   	SYS_DVBC_ANNEX_C,
>   } fe_delivery_system_t;
> 
> -
> +/* backward compatibility */
>   #define SYS_DVBC_ANNEX_AC	SYS_DVBC_ANNEX_A
> +#define SYS_DMBTH SYS_DTMB /* DMB-TH is legacy name, use DTMB
> instead */
> 
> 
>   struct dtv_cmds_h {
> diff --git a/include/linux/dvb/version.h
> b/include/linux/dvb/version.h index 0559e2b..43d9e8d 100644
> --- a/include/linux/dvb/version.h
> +++ b/include/linux/dvb/version.h
> @@ -24,6 +24,6 @@
>   #define _DVBVERSION_H_
> 
>   #define DVB_API_VERSION 5
> -#define DVB_API_VERSION_MINOR 5
> +#define DVB_API_VERSION_MINOR 6
> 
>   #endif /*_DVBVERSION_H_*/

If you like you can add, good work.

Acked-by: Patrick Boettcher <pboettcher@kernellabs.com>


--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/
