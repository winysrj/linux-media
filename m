Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweb6.versatel.de ([82.140.32.146]:34486 "EHLO
	mxweb6.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1I1Tvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 15:51:47 -0400
Received: from cinnamon-sage.de (i577A8D1D.versanet.de [87.122.141.29])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id p8SJpiE9019469
	for <linux-media@vger.kernel.org>; Wed, 28 Sep 2011 21:51:44 +0200
Received: from 192.168.23.2:49983 by cinnamon-sage.de for <chb@muc.de>,<linux-media@vger.kernel.org>,<thomas.schloeter@gmx.net> ; 28.09.2011 21:51:43
Message-ID: <4E837ACF.60804@flensrocker.de>
Date: Wed, 28 Sep 2011 21:51:43 +0200
From: "L. Hanisch" <dvb@flensrocker.de>
MIME-Version: 1.0
To: Christian Brunner <chb@muc.de>
CC: linux-media@vger.kernel.org, thomas.schloeter@gmx.net
Subject: Re: [PATCH] dvb: satellite channel routing (unicable) support
References: <20110928190421.GA13539@sir.fritz.box>
In-Reply-To: <20110928190421.GA13539@sir.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am 28.09.2011 21:04, schrieb Christian Brunner:
> This is an updated version of the unicable patch by Thomas Schloeter
> for linux 3.1.
>
> The patch is an addition to the dvb_frontend code, that adds fully
> transparent support for SCR to arbitrary applications that use the
> DVB API.
>
> I know that this patch has been rejected, because unicable support
> can be implemented in userspace, too. However I like it anyway,
> because there is a lot of software without unicable support out
> there. I'm just sending it, because I think it could be usefull
> for others.
>
> DVB satellite channel routing (aka "SCR", "Unicable", "EN50494") is
> a standard, where all satellite tuners share the sam cable and each of
> them has a fixed intermediate frequency it is supposed to tune to.
> Zapping is done by sending a special DiSEqC message while SEC voltage
> is temporarily pulled from 14 to 18 volts. This message includes the
> tuner's ID from 0 to 7, the frequency, band and polarisation to tune
> to as well as one out of two satellite positions.
>
> By default SCR support is disabled and has to be enabled explicitly
> via an ioctl command. At the same time you set the tuner's ID, the
> frequency and other parameters. Thomas developed an utility
> (dvb-scr-setup) to accomplish this task. It can be used unmodified.
>
> I'm using this patch successfully with a DUR-LINE UK 101 unicable LNB.

  That would be awesome to have this functionality in the kernel. I maintained the "unicable"-patch for the vdr (written 
by some guy from the vdr-portal.de who sadly doesn't seem to respond to mails via that forum anymore).
  It would be great if all the work could be summarized in one ioctl.

  I have one comment, see below.

>
> Regards,
> Christian
> ---
>   drivers/media/dvb/dvb-core/dvb_frontend.c |  186 +++++++++++++++++++++++++++-
>   include/linux/dvb/frontend.h              |   20 +++
>   2 files changed, 199 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index efe9c30..62316be 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -9,6 +9,8 @@
>    *
>    * Copyright (C) 2004 Andrew de Quincey (tuning thread cleanup)
>    *
> + * Copyright (C) 2011 Thomas Schloeter (satellite channel routing)
> + *
>    * This program is free software; you can redistribute it and/or
>    * modify it under the terms of the GNU General Public License
>    * as published by the Free Software Foundation; either version 2
> @@ -50,6 +52,8 @@ static int dvb_override_tune_delay;
>   static int dvb_powerdown_on_sleep = 1;
>   static int dvb_mfe_wait_time = 5;
>
> +int scr_send_tune_cmd(struct dvb_frontend*);
> +
>   module_param_named(frontend_debug, dvb_frontend_debug, int, 0644);
>   MODULE_PARM_DESC(frontend_debug, "Turn on/off frontend core debugging (default:off).");
>   module_param(dvb_shutdown_timeout, int, 0644);
> @@ -122,6 +126,10 @@ struct dvb_frontend_private {
>   	int tone;
>   	int voltage;
>
> +	/* satellite channel routing */
> +	struct dvb_scr_params dvbscr;
> +	__u32 frequency_orig;
> +
>   	/* swzigzag values */
>   	unsigned int state;
>   	unsigned int bending;
> @@ -1027,7 +1035,12 @@ static void dtv_property_cache_sync(struct dvb_frontend *fe,
>   				    struct dtv_frontend_properties *c,
>   				    const struct dvb_frontend_parameters *p)
>   {
> -	c->frequency = p->frequency;
> +	struct dvb_frontend_private *fepriv = fe->frontend_priv;
> +
> +	if (fepriv->dvbscr.scr_enable == SCR_ON)
> +		c->frequency = fepriv->frequency_orig;
> +	else
> +		c->frequency = p->frequency;
>   	c->inversion = p->inversion;
>
>   	switch (fe->ops.info.type) {
> @@ -1081,6 +1094,7 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
>   	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>   	struct dvb_frontend_parameters *p =&fepriv->parameters_in;
>
> +	fepriv->frequency_orig = c->frequency;
>   	p->frequency = c->frequency;
>   	p->inversion = c->inversion;
>
> @@ -1129,6 +1143,7 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
>   	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>   	struct dvb_frontend_parameters *p =&fepriv->parameters_in;
>
> +	fepriv->frequency_orig = c->frequency;
>   	p->frequency = c->frequency;
>   	p->inversion = c->inversion;
>
> @@ -1354,10 +1369,15 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
>   	dtv_property_dump(tvp);
>
>   	/* Allow the frontend to validate incoming properties */
> -	if (fe->ops.set_property) {
> -		r = fe->ops.set_property(fe, tvp);
> -		if (r<  0)
> -			return r;
> +	if ((fepriv->dvbscr.scr_enable != SCR_ON) ||
> +	    (tvp->cmd != DTV_FREQUENCY) ||
> +	    (tvp->cmd != DTV_VOLTAGE) ||
> +	    (tvp->cmd != DTV_TONE)) {
> +		if (fe->ops.set_property) {
> +			r = fe->ops.set_property(fe, tvp);
> +			if (r<  0)
> +				return r;
> +		}
>   	}
>
>   	switch(tvp->cmd) {
> @@ -1631,6 +1651,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>   	struct dvb_frontend *fe = dvbdev->priv;
>   	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>   	int cb_err, err = -EOPNOTSUPP;
> +	u32 fe_freq_min, fe_freq_max;
>
>   	if (fe->dvb->fe_ioctl_override) {
>   		cb_err = fe->dvb->fe_ioctl_override(fe, cmd, parg,
> @@ -1702,6 +1723,11 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>   		break;
>
>   	case FE_DISEQC_SEND_MASTER_CMD:
> +		if (fepriv->dvbscr.scr_enable == SCR_ON) {
> +			dprintk("DVB: %s: Operation not available when SCR enabled\n", __FUNCTION__);
> +			err = 0;
> +			break;
> +		}
>   		if (fe->ops.diseqc_send_master_cmd) {
>   			err = fe->ops.diseqc_send_master_cmd(fe, (struct dvb_diseqc_master_cmd*) parg);
>   			fepriv->state = FESTATE_DISEQC;
> @@ -1710,6 +1736,11 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>   		break;
>
>   	case FE_DISEQC_SEND_BURST:
> +		if (fepriv->dvbscr.scr_enable == SCR_ON) {
> +			dprintk("DVB: %s: Operation not available when SCR enabled\n", __FUNCTION__);
> +			err = 0;
> +			break;
> +		}
>   		if (fe->ops.diseqc_send_burst) {
>   			err = fe->ops.diseqc_send_burst(fe, (fe_sec_mini_cmd_t) parg);
>   			fepriv->state = FESTATE_DISEQC;
> @@ -1717,9 +1748,65 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>   		}
>   		break;
>
> +	case FE_SET_SCR: {
> +		struct dtv_frontend_properties *c =&fe->dtv_property_cache;
> +
> +		if (fe->ops.info.type != FE_QPSK) {
> +			dprintk("DVB: %s: SCR is supported on QPSK frontends only!\n", __FUNCTION__);
> +			err = -EINVAL;
> +			break;
> +		}
> +		fepriv->dvbscr.scr_enable = ((struct dvb_scr_params *) parg)->scr_enable;
> +		fepriv->dvbscr.scr_id = ((struct dvb_scr_params *) parg)->scr_id;
> +		fepriv->dvbscr.scr_position = ((struct dvb_scr_params *) parg)->scr_position;
> +		fepriv->dvbscr.scr_frequency = ((struct dvb_scr_params *) parg)->scr_frequency;
> +		err = 0;
> +		if ((fepriv->dvbscr.scr_enable != SCR_ON)&&  (fepriv->dvbscr.scr_enable != SCR_OFF)) {
> +			fepriv->dvbscr.scr_enable = SCR_OFF;
> +			err = -EINVAL;
> +			dprintk("DVB: %s: Invalid value for SCR_ON in ioctl\n", __FUNCTION__);
> +		}
> +		dvb_frontend_get_frequency_limits(fe,&fe_freq_min,&fe_freq_max);
> +		if ((fepriv->dvbscr.scr_frequency<  fe_freq_min / 1000) || (fepriv->dvbscr.scr_frequency>  fe_freq_max / 1000)) {
> +			fepriv->dvbscr.scr_enable = SCR_OFF;
> +			fepriv->dvbscr.scr_frequency = 1400;
> +			err = -EINVAL;
> +			dprintk("DVB: %s: Invalid value for SCR_FREQ in ioctl\n", __FUNCTION__);
> +		}
> +		if ((fepriv->dvbscr.scr_position != SCR_POS_A)&&  (fepriv->dvbscr.scr_position != SCR_POS_B)) {
> +			fepriv->dvbscr.scr_enable = SCR_OFF;
> +			fepriv->dvbscr.scr_position = SCR_POS_A;
> +			err = -EINVAL;
> +			dprintk("DVB: %s: Invalid value for SCR_POSITION in ioctl\n", __FUNCTION__);
> +		}
> +		if (fepriv->dvbscr.scr_id>  7) {
> +			fepriv->dvbscr.scr_enable = SCR_OFF;
> +			fepriv->dvbscr.scr_id = 0;
> +			err = -EINVAL;
> +			dprintk("DVB: %s: Invalid value for SCR_ID in ioctl\n", __FUNCTION__);
> +		}
> +		if (fe->ops.set_voltage)
> +			fe->ops.set_voltage(fe, SEC_VOLTAGE_13);
> +		else {
> +			dprintk("DVB: %s: Set Voltage not supported. SCR not possible.\n", __FUNCTION__);
> +			fepriv->dvbscr.scr_enable = SCR_OFF;
> +		}
> +		if (fe->ops.set_tone)
> +			fe->ops.set_tone(fe, SEC_TONE_OFF);
> +		else {
> +			dprintk("DVB: %s: Set Tone not supported. SCR not possible.\n", __FUNCTION__);
> +			fepriv->dvbscr.scr_enable = SCR_OFF;
> +		}
> +		dtv_property_cache_sync(fe, c,&fepriv->parameters_in);
> +		break;
> +	}
> +
>   	case FE_SET_TONE:
>   		if (fe->ops.set_tone) {
> -			err = fe->ops.set_tone(fe, (fe_sec_tone_mode_t) parg);
> +			if (fepriv->dvbscr.scr_enable == SCR_ON)
> +				err = fe->ops.set_tone(fe, SEC_TONE_OFF);
> +			else
> +				err = fe->ops.set_tone(fe, (fe_sec_tone_mode_t) parg);
>   			fepriv->tone = (fe_sec_tone_mode_t) parg;
>   			fepriv->state = FESTATE_DISEQC;
>   			fepriv->status = 0;
> @@ -1728,7 +1815,10 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>
>   	case FE_SET_VOLTAGE:
>   		if (fe->ops.set_voltage) {
> -			err = fe->ops.set_voltage(fe, (fe_sec_voltage_t) parg);
> +			if (fepriv->dvbscr.scr_enable == SCR_ON)
> +				err = fe->ops.set_voltage(fe, SEC_VOLTAGE_13);
> +			else
> +				err = fe->ops.set_voltage(fe, (fe_sec_voltage_t) parg);
>   			fepriv->voltage = (fe_sec_voltage_t) parg;
>   			fepriv->state = FESTATE_DISEQC;
>   			fepriv->status = 0;
> @@ -1736,6 +1826,11 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>   		break;
>
>   	case FE_DISHNETWORK_SEND_LEGACY_CMD:
> +		if (fepriv->dvbscr.scr_enable == SCR_ON) {
> +			dprintk("DVB: %s: Operation not available when SCR enabled\n", __FUNCTION__);
> +			err = 0;
> +			break;
> +		}
>   		if (fe->ops.dishnetwork_send_legacy_command) {
>   			err = fe->ops.dishnetwork_send_legacy_command(fe, (unsigned long) parg);
>   			fepriv->state = FESTATE_DISEQC;
> @@ -1827,6 +1922,10 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>   			dtv_property_cache_sync(fe, c,&fepriv->parameters_in);
>   		}
>
> +		/* intercept tuning info and replace with SCR parameters */
> +		if (fepriv->dvbscr.scr_enable == SCR_ON)
> +		scr_send_tune_cmd(fe);
> +
>   		memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
>   		memcpy(&fetunesettings.parameters, parg,
>   		       sizeof (struct dvb_frontend_parameters));
> @@ -1899,6 +1998,10 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>   		if (fe->ops.get_frontend) {
>   			err = fe->ops.get_frontend(fe,&fepriv->parameters_out);
>   			memcpy(parg,&fepriv->parameters_out, sizeof(struct dvb_frontend_parameters));
> +			if (fepriv->dvbscr.scr_enable == SCR_ON) {
> +				((struct dvb_frontend_parameters*) parg)->frequency =
> +					fepriv->frequency_orig;
> +			}
>   		}
>   		break;
>
> @@ -2098,6 +2201,12 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
>   	fe->dvb = dvb;
>   	fepriv->inversion = INVERSION_OFF;
>
> +	/* initialize SCR parameters */
> +	fepriv->dvbscr.scr_enable = SCR_OFF;
> +	fepriv->dvbscr.scr_id = 0;
> +	fepriv->dvbscr.scr_frequency = 1400;
> +	fepriv->dvbscr.scr_position = SCR_POS_A;
> +
>   	printk ("DVB: registering adapter %i frontend %i (%s)...\n",
>   		fe->dvb->num,
>   		fe->id,
> @@ -2171,3 +2280,66 @@ void dvb_frontend_detach(struct dvb_frontend* fe)
>   }
>   #endif
>   EXPORT_SYMBOL(dvb_frontend_detach);
> +
> +int scr_send_tune_cmd(struct dvb_frontend * fe) {
> +	struct dvb_frontend_private *fepriv = fe->frontend_priv;
> +	int err = 0;
> +	struct timeval waketime;
> +	struct dvb_diseqc_master_cmd tunecmd;
> +	uint8_t channel_byte_1, channel_byte_2;
> +	uint16_t t;
> +
> +	dprintk ("DVB: Tuning to %u, %s, %s using SCR. ID=%u, POS=%s, FREQ=%u\n",
> +		fepriv->parameters_in.frequency,
> +		((fepriv->voltage == SEC_VOLTAGE_18) ? "H" :
> +		((fepriv->voltage == SEC_VOLTAGE_13) ? "V" : "?")),
> +		((fepriv->tone == SEC_TONE_ON) ? "HiBand" : "LoBand"),
> +		fepriv->dvbscr.scr_id,
> +		((fepriv->dvbscr.scr_position == SCR_POS_A) ? "A" : "B"),
> +		fepriv->dvbscr.scr_frequency);
> +
> +	if (fepriv->dvbscr.scr_id>  7) {
> +		dprintk ("DVB: %s - wrong SCR ID\n", __FUNCTION__);
> +		fepriv->dvbscr.scr_id = 0;
> +	}
> +
> +	channel_byte_1 = (uint8_t) (fepriv->dvbscr.scr_id<<  5);
> +
> +	if (fepriv->dvbscr.scr_position != SCR_POS_A)
> +		channel_byte_1 |= (1<<  4);
> +
> +	if (fepriv->voltage == SEC_VOLTAGE_18) /* horizontal*/
> +		channel_byte_1 |= (1<<  3);
> +
> +	if (fepriv->tone == SEC_TONE_ON) /* high band*/
> +		channel_byte_1 |= (1<<  2);
> +
> +	if (fepriv->frequency_orig == 0) {
> +		dprintk ("DVB: %s - invalid SCR tuning\n", __FUNCTION__);
> +	}
> +
> +	t = (uint16_t) ((((fepriv->parameters_in.frequency / 1000) + fepriv->dvbscr.scr_frequency + 2) / 4) - 350);
> +	channel_byte_1 |= (((uint8_t) (t>>  8))&  0x03);
> +	channel_byte_2 = (uint8_t) (t&  0x00FF);
> +
> +	fepriv->frequency_orig = fepriv->parameters_in.frequency;
> +	fepriv->parameters_in.frequency = (uint32_t) ((t + 350) * 4) * 1000 - fepriv->frequency_orig;
> +
> +	// Send DiSEqC code E0 10 5A channel_byte_1 channel_byte_2
> +	tunecmd.msg_len = 5;
> +	tunecmd.msg[0] = 0xE0;
> +	tunecmd.msg[1] = 0x10;
> +	tunecmd.msg[2] = 0x5A;
> +	tunecmd.msg[3] = channel_byte_1;
> +	tunecmd.msg[4] = channel_byte_2;

  The vdr-unicable-patch makes it possible to configure a "pin" which is sent as a sixth byte (value ranges from 0 to 
255). Also the third byte is modified to 0x5C. For example it is used in multi-family houses so only the receiver with 
the assigned id can tune on its intermediate frequency. I don't know if it's part of any spec or not.

> +
> +	do_gettimeofday(&waketime);
> +	if ((err = fe->ops.set_voltage(fe, SEC_VOLTAGE_18)) != 0) return err;
> +	dvb_frontend_sleep_until(&waketime, 10000);
> +	if ((err = fe->ops.diseqc_send_master_cmd(fe,&tunecmd)) != 0) return err;
> +	do_gettimeofday(&waketime);
> +	dvb_frontend_sleep_until(&waketime, 10000);
> +	if ((err = fe->ops.set_voltage(fe, SEC_VOLTAGE_13)) != 0) return err;
> +
> +	return 0;
> +}
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index 36a3ed6..570b3bd 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -212,6 +212,23 @@ typedef enum fe_hierarchy {
>   	HIERARCHY_AUTO
>   } fe_hierarchy_t;
>
> +/* satellite channel routing */
> +typedef enum scr_status {
> +	SCR_OFF,
> +	SCR_ON
> +} scr_status_t;
> +
> +typedef enum scr_positions {
> +	SCR_POS_A,
> +	SCR_POS_B
> +} scr_position_t;
> +
> +struct dvb_scr_params {
> +	scr_status_t		scr_enable;		/* enable or disable SCR */
> +	__u8			scr_id;			/* internal SCR id */
> +	scr_position_t		scr_position;		/* SCR satellite position (A or B) */
> +	__u32			scr_frequency;		/* SCR frequency we tune to */
> +};

  That would mean, that this struct has to be extended with a byte for the pin and a bit if the pin should be used.

  Of course this can be done in userspace, but to be honest, it isn't. It's not trivial and must be reinvented in every 
application that is supposed to work with SCR. Maybe it can be integrated in some library but how should that be 
integrated in the various applications flying around?
  If it's just an ioctl part of the dvb spec, all app-developers will stumble upon it and it would be easy to use. And 
it would be used.

  Thanks for this!

Lars.

>
>   struct dvb_qpsk_parameters {
>   	__u32		symbol_rate;  /* symbol rate in Symbols per second */
> @@ -423,4 +440,7 @@ struct dtv_properties {
>
>   #define FE_DISHNETWORK_SEND_LEGACY_CMD _IO('o', 80) /* unsigned int */
>
> +/* satellite channel routing */
> +#define FE_SET_SCR                 _IOW('o', 120, struct dvb_scr_params)
> +
>   #endif /*_DVBFRONTEND_H_*/
