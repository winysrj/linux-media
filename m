Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab1FCNRR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 09:17:17 -0400
Message-ID: <4DE8DED3.1010809@redhat.com>
Date: Fri, 03 Jun 2011 10:17:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Dmitri Belimov <d.belimov@gmail.com>, thunder.m@email.cz,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: XC4000: added card_type
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com> <4DE8D5AC.7060002@mailbox.hu>
In-Reply-To: <4DE8D5AC.7060002@mailbox.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-06-2011 09:38, istvan_v@mailbox.hu escreveu:
> This patch adds support for selecting a card type in struct
> xc4000_config, to allow for implementing some card specific code
> in the driver.

Hi Istvan,

Please send your patches to linux-media@vger.kernel.org. The linux-dvb
ML is obsolete. I didn't remove it from the server just to avoid loosing
the mail history.

With respect to this specific patch, as Devin pointed, the proper way is to
set the configurable data via the boards entries, and not inside xc4000.

So, feel free to send us patches to cx88 and other bridge drivers whose
boards require different configs, in order to work with xc4000.

Thanks,
Mauro

> 
> Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>
> 
> 
> xc4000_card_type.patch
> 
> 
> diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
> --- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-03 11:54:19.000000000 +0200
> +++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-03 14:32:59.000000000 +0200
> @@ -85,6 +85,7 @@
>  	u32	bandwidth;
>  	u8	video_standard;
>  	u8	rf_mode;
> +	u8	card_type;
>  	u8	ignore_i2c_write_errors;
>   /*	struct xc2028_ctrl	ctrl; */
>  	struct firmware_properties cur_fw;
> @@ -1426,6 +1427,16 @@
>  	int	instance;
>  	u16	id = 0;
>  
> +	if (cfg->card_type != XC4000_CARD_GENERIC) {
> +		if (cfg->card_type == XC4000_CARD_WINFAST_CX88) {
> +			cfg->i2c_address = 0x61;
> +			cfg->if_khz = 4560;
> +		} else {			/* default to PCTV 340E */
> +			cfg->i2c_address = 0x61;
> +			cfg->if_khz = 5400;
> +		}
> +	}
> +
>  	dprintk(1, "%s(%d-%04x)\n", __func__,
>  		i2c ? i2c_adapter_id(i2c) : -1,
>  		cfg ? cfg->i2c_address : -1);
> @@ -1435,6 +1446,8 @@
>  	instance = hybrid_tuner_request_state(struct xc4000_priv, priv,
>  					      hybrid_tuner_instance_list,
>  					      i2c, cfg->i2c_address, "xc4000");
> +	if (cfg->card_type != XC4000_CARD_GENERIC)
> +		priv->card_type = cfg->card_type;
>  	switch (instance) {
>  	case 0:
>  		goto fail;
> @@ -1450,7 +1463,7 @@
>  		break;
>  	}
>  
> -	if (priv->if_khz == 0) {
> +	if (cfg->if_khz != 0) {
>  		/* If the IF hasn't been set yet, use the value provided by
>  		   the caller (occurs in hybrid devices where the analog
>  		   call to xc4000_attach occurs before the digital side) */
> diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.h xc4000/drivers/media/common/tuners/xc4000.h
> --- xc4000_orig/drivers/media/common/tuners/xc4000.h	2011-06-03 11:54:19.000000000 +0200
> +++ xc4000/drivers/media/common/tuners/xc4000.h	2011-06-03 14:29:32.000000000 +0200
> @@ -27,8 +27,13 @@
>  struct dvb_frontend;
>  struct i2c_adapter;
>  
> +#define XC4000_CARD_GENERIC		0
> +#define XC4000_CARD_PCTV_340E		1
> +#define XC4000_CARD_WINFAST_CX88	2
> +
>  struct xc4000_config {
> -	u8	i2c_address;
> +	u8	card_type;	/* if card type is not generic, all other */
> +	u8	i2c_address;	/* parameters are automatically set */
>  	u32	if_khz;
>  };
>  

