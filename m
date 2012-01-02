Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36323 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2ABTcw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 14:32:52 -0500
Received: by eekc4 with SMTP id c4so15413916eek.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 11:32:50 -0800 (PST)
Message-ID: <4F02065E.4060406@gmail.com>
Date: Mon, 02 Jan 2012 20:32:46 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4 16/47] [media] tuner-xc2028: use DVBv5 parameters on
 set_params()
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com> <1324741852-26138-2-git-send-email-mchehab@redhat.com> <1324741852-26138-3-git-send-email-mchehab@redhat.com> <1324741852-26138-4-git-send-email-mchehab@redhat.com> <1324741852-26138-5-git-send-email-mchehab@redhat.com> <1324741852-26138-6-git-send-email-mchehab@redhat.com> <1324741852-26138-7-git-send-email-mchehab@redhat.com> <1324741852-26138-8-git-send-email-mchehab@redhat.com> <1324741852-26138-9-git-send-email-mchehab@redhat.com> <1324741852-26138-10-git-send-email-mchehab@redhat.com> <1324741852-26138-11-git-send-email-mchehab@redhat.com> <1324741852-26138-12-git-send-email-mchehab@redhat.com> <1324741852-26138-13-git-send-email-mchehab@redhat.com> <1324741852-26138-14-git-send-email-mchehab@redhat.com> <1324741852-26138-15-git-send-email-mchehab@redhat.com> <1324741852-26138-16-git-send-email-mchehab@redhat.com> <1324741852-26138-17-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-17-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 24/12/2011 16:50, Mauro Carvalho Chehab ha scritto:
> Instead of using DVBv3 parameters, rely on DVBv5 parameters to
> set the tuner.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/common/tuners/tuner-xc2028.c |   83 ++++++++++++----------------
>  1 files changed, 36 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
> index e531267..8c0dc6a1 100644
> --- a/drivers/media/common/tuners/tuner-xc2028.c
> +++ b/drivers/media/common/tuners/tuner-xc2028.c
> @@ -1087,65 +1087,26 @@ static int xc2028_set_analog_freq(struct dvb_frontend *fe,
>  static int xc2028_set_params(struct dvb_frontend *fe,
>  			     struct dvb_frontend_parameters *p)
>  {
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	u32 delsys = c->delivery_system;
> +	u32 bw = c->bandwidth_hz;
>  	struct xc2028_data *priv = fe->tuner_priv;
>  	unsigned int       type=0;
> -	fe_bandwidth_t     bw = BANDWIDTH_8_MHZ;
>  	u16                demod = 0;
>  
>  	tuner_dbg("%s called\n", __func__);
>  
> -	switch(fe->ops.info.type) {
> -	case FE_OFDM:
> -		bw = p->u.ofdm.bandwidth;
> +	switch (delsys) {
> +	case SYS_DVBT:
> +	case SYS_DVBT2:
>  		/*
>  		 * The only countries with 6MHz seem to be Taiwan/Uruguay.
>  		 * Both seem to require QAM firmware for OFDM decoding
>  		 * Tested in Taiwan by Terry Wu <terrywu2009@gmail.com>
>  		 */
> -		if (bw == BANDWIDTH_6_MHZ)
> +		if (bw <= 6000000)
>  			type |= QAM;
> -		break;
> -	case FE_ATSC:
> -		bw = BANDWIDTH_6_MHZ;
> -		/* The only ATSC firmware (at least on v2.7) is D2633 */
> -		type |= ATSC | D2633;
> -		break;
> -	/* DVB-S and pure QAM (FE_QAM) are not supported */
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	switch (bw) {
> -	case BANDWIDTH_8_MHZ:
> -		if (p->frequency < 470000000)
> -			priv->ctrl.vhfbw7 = 0;
> -		else
> -			priv->ctrl.uhfbw8 = 1;
> -		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV8;
> -		type |= F8MHZ;
> -		break;
> -	case BANDWIDTH_7_MHZ:
> -		if (p->frequency < 470000000)
> -			priv->ctrl.vhfbw7 = 1;
> -		else
> -			priv->ctrl.uhfbw8 = 0;
> -		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV7;
> -		type |= F8MHZ;
> -		break;
> -	case BANDWIDTH_6_MHZ:
> -		type |= DTV6;
> -		priv->ctrl.vhfbw7 = 0;
> -		priv->ctrl.uhfbw8 = 0;
> -		break;
> -	default:
> -		tuner_err("error: bandwidth not supported.\n");
> -	};
>  
> -	/*
> -	  Selects between D2633 or D2620 firmware.
> -	  It doesn't make sense for ATSC, since it should be D2633 on all cases
> -	 */
> -	if (fe->ops.info.type != FE_ATSC) {
>  		switch (priv->ctrl.type) {
>  		case XC2028_D2633:
>  			type |= D2633;
> @@ -1161,6 +1122,34 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>  			else
>  				type |= D2620;
>  		}
> +		break;
> +	case SYS_ATSC:
> +		/* The only ATSC firmware (at least on v2.7) is D2633 */
> +		type |= ATSC | D2633;
> +		break;
> +	/* DVB-S and pure QAM (FE_QAM) are not supported */
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (bw <= 6000000) {
> +		type |= DTV6;
> +		priv->ctrl.vhfbw7 = 0;
> +		priv->ctrl.uhfbw8 = 0;
> +	} else if (bw <= 7000000) {
> +		if (c->frequency < 470000000)
> +			priv->ctrl.vhfbw7 = 1;
> +		else
> +			priv->ctrl.uhfbw8 = 0;
> +		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV7;
> +		type |= F8MHZ;
> +	} else {
> +		if (c->frequency < 470000000)
> +			priv->ctrl.vhfbw7 = 0;
> +		else
> +			priv->ctrl.uhfbw8 = 1;
> +		type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV8;
> +		type |= F8MHZ;
>  	}
>  
>  	/* All S-code tables need a 200kHz shift */
> @@ -1185,7 +1174,7 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>  		 */
>  	}
>  
> -	return generic_set_freq(fe, p->frequency,
> +	return generic_set_freq(fe, c->frequency,
>  				V4L2_TUNER_DIGITAL_TV, type, 0, demod);
>  }
>  

Hi Mauro,
I've tested the new media_build tree with the DVBv5 modifications on my
Terratec Cinergy Hybrid T USB XS (0ccd:0042).

The card works fine, but there is small issue: with the old code the
BASE firmware was loaded only 1 time, now it seems to be loaded each
time a new frequency is tuned (forcing reload of the other firmwares too).

This is a log of the firmware loads after some channel surfing:

OLD CODE:

[ 8701.753768] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[ 8702.804153] xc2028 0-0061: Loading firmware for type=D2633 DTV7 (90),
id 0000000000000000.
[ 8702.819274] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 8758.361730] xc2028 0-0061: Loading firmware for type=D2633 DTV78
(110), id 0000000000000000.
[ 8758.376951] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.

(note that the first frequency was in VHF band, then I switched to a new
frequency in UHF band, so the DTV78 firmware was loaded)

NEW CODE:

[19398.450453] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[19399.563210] xc2028 0-0061: Loading firmware for type=D2633 DTV8
(210), id 0000000000000000.
[19399.579467] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[19458.001144] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[19459.084473] xc2028 0-0061: Loading firmware for type=D2633 DTV8
(210), id 0000000000000000.
[19459.100183] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[19471.695347] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[19472.763449] xc2028 0-0061: Loading firmware for type=D2633 DTV8
(210), id 0000000000000000.
[19472.780660] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[19497.928003] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[19498.999729] xc2028 0-0061: Loading firmware for type=D2633 DTV8
(210), id 0000000000000000.
[19499.015212] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[19510.258833] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[19511.346135] xc2028 0-0061: Loading firmware for type=D2633 DTV78
(110), id 0000000000000000.
[19511.361506] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[19523.956877] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[19525.028394] xc2028 0-0061: Loading firmware for type=D2633 DTV78
(110), id 0000000000000000.
[19525.044622] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[19538.526806] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[19539.602083] xc2028 0-0061: Loading firmware for type=D2633 DTV78
(110), id 0000000000000000.
[19539.617613] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.

(here I started with a UHF frequency, but each time a new frequency is
requested all firmwares are loaded anyway, starting from the BASE one).

Best regards,
Gianluca Gennari
