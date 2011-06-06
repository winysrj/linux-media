Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab1FFUK0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 16:10:26 -0400
Message-ID: <4DED342E.2070605@redhat.com>
Date: Mon, 06 Jun 2011 17:10:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Istvan Varga <istvan_v@mailbox.hu>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] XC4000: removed card_type
References: <201106061803.44293.istvan_v@mailbox.hu>
In-Reply-To: <201106061803.44293.istvan_v@mailbox.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 06-06-2011 13:03, Istvan Varga escreveu:
> Removed the use of 'card_type' from the tuner configuration structure, and
> replaced it with separate parameters to set board-specific configuration.

Ok, with respect to xc4000 patches, I'm happy with what we currently have.
I'm applying those patches plus my checkpatch.pl fix into the main tree.

Please solve the firmware issue before the next merge window.

Thanks,
Mauro.

> 
> Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>
> 
> diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
> --- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-06 15:02:03.000000000 +0200
> +++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-06 16:53:27.000000000 +0200
> @@ -92,14 +92,16 @@
>  	struct list_head hybrid_tuner_instance_list;
>  	struct firmware_description *firm;
>  	int	firm_size;
> -	__u16	firm_version;
>  	u32	if_khz;
>  	u32	freq_hz;
>  	u32	bandwidth;
>  	u8	video_standard;
>  	u8	rf_mode;
> -	u8	card_type;
> +	u8	default_pm;
> +	u8	dvb_amplitude;
> +	u8	set_smoothedcvbs;
>  	u8	ignore_i2c_write_errors;
> +	__u16	firm_version;
>  	struct firmware_properties cur_fw;
>  	__u16	hwmodel;
>  	__u16	hwvers;
> @@ -1226,19 +1228,22 @@
>  		}
>  	}
>  
> -	if (priv->card_type == XC4000_CARD_WINFAST_CX88) {
> -		if (xc_write_reg(priv, XREG_D_CODE, 0) == 0)
> -			ret = 0;
> +	if (xc_write_reg(priv, XREG_D_CODE, 0) == 0)
> +		ret = 0;
> +	if (priv->dvb_amplitude != 0) {
>  		if (xc_write_reg(priv, XREG_AMPLITUDE,
> -				 (priv->firm_version == 0x0102 ? 132 : 134))
> -		    != 0)
> +				 (priv->firm_version != 0x0102 ||
> +				  priv->dvb_amplitude != 134 ?
> +				  priv->dvb_amplitude : 132)) != 0)
>  			ret = -EREMOTEIO;
> +	}
> +	if (priv->set_smoothedcvbs != 0) {
>  		if (xc_write_reg(priv, XREG_SMOOTHEDCVBS, 1) != 0)
>  			ret = -EREMOTEIO;
> -		if (ret != 0) {
> -			printk(KERN_ERR "xc4000: setting registers failed\n");
> -			/* goto fail; */
> -		}
> +	}
> +	if (ret != 0) {
> +		printk(KERN_ERR "xc4000: setting registers failed\n");
> +		/* goto fail; */
>  	}
>  
>  	xc_tune_channel(priv, priv->freq_hz);
> @@ -1412,8 +1417,7 @@
>  			if (type & NOGD)
>  				video_mode &= 0xFF7F;
>  		} else if (priv->video_standard < XC4000_I_PAL_NICAM) {
> -			if (priv->card_type == XC4000_CARD_WINFAST_CX88 &&
> -			    priv->firm_version == 0x0102)
> +			if (priv->firm_version == 0x0102)
>  				video_mode &= 0xFEFF;
>  			if (audio_std & XC4000_AUDIO_STD_B)
>  				video_mode |= 0x0080;
> @@ -1425,17 +1429,17 @@
>  		}
>  	}
>  
> -	if (priv->card_type == XC4000_CARD_WINFAST_CX88) {
> -		if (xc_write_reg(priv, XREG_D_CODE, 0) == 0)
> -			ret = 0;
> -		if (xc_write_reg(priv, XREG_AMPLITUDE, 1) != 0)
> -			ret = -EREMOTEIO;
> +	if (xc_write_reg(priv, XREG_D_CODE, 0) == 0)
> +		ret = 0;
> +	if (xc_write_reg(priv, XREG_AMPLITUDE, 1) != 0)
> +		ret = -EREMOTEIO;
> +	if (priv->set_smoothedcvbs != 0) {
>  		if (xc_write_reg(priv, XREG_SMOOTHEDCVBS, 1) != 0)
>  			ret = -EREMOTEIO;
> -		if (ret != 0) {
> -			printk(KERN_ERR "xc4000: setting registers failed\n");
> -			goto fail;
> -		}
> +	}
> +	if (ret != 0) {
> +		printk(KERN_ERR "xc4000: setting registers failed\n");
> +		goto fail;
>  	}
>  
>  	xc_tune_channel(priv, priv->freq_hz);
> @@ -1516,8 +1520,7 @@
>  
>  	/* Avoid firmware reload on slow devices */
>  	if ((no_poweroff == 2 ||
> -	     (no_poweroff == 0 &&
> -	      priv->card_type != XC4000_CARD_WINFAST_CX88)) &&
> +	     (no_poweroff == 0 && priv->default_pm != 0)) &&
>  	    (priv->cur_fw.type & BASE) != 0) {
>  		/* force reset and firmware reload */
>  		priv->cur_fw.type = XC_POWERED_DOWN;
> @@ -1588,16 +1591,6 @@
>  	int	instance;
>  	u16	id = 0;
>  
> -	if (cfg->card_type != XC4000_CARD_GENERIC) {
> -		if (cfg->card_type == XC4000_CARD_WINFAST_CX88) {
> -			cfg->i2c_address = 0x61;
> -			cfg->if_khz = 4560;
> -		} else {			/* default to PCTV 340E */
> -			cfg->i2c_address = 0x61;
> -			cfg->if_khz = 5400;
> -		}
> -	}
> -
>  	dprintk(1, "%s(%d-%04x)\n", __func__,
>  		i2c ? i2c_adapter_id(i2c) : -1,
>  		cfg ? cfg->i2c_address : -1);
> @@ -1607,8 +1600,6 @@
>  	instance = hybrid_tuner_request_state(struct xc4000_priv, priv,
>  					      hybrid_tuner_instance_list,
>  					      i2c, cfg->i2c_address, "xc4000");
> -	if (cfg->card_type != XC4000_CARD_GENERIC)
> -		priv->card_type = cfg->card_type;
>  	switch (instance) {
>  	case 0:
>  		goto fail;
> @@ -1616,6 +1607,11 @@
>  	case 1:
>  		/* new tuner instance */
>  		priv->bandwidth = BANDWIDTH_6_MHZ;
> +		/* set default configuration */
> +		priv->if_khz = 4560;
> +		priv->default_pm = 0;
> +		priv->dvb_amplitude = 134;
> +		priv->set_smoothedcvbs = 1;
>  		mutex_init(&priv->lock);
>  		fe->tuner_priv = priv;
>  		break;
> @@ -1626,10 +1622,11 @@
>  	}
>  
>  	if (cfg->if_khz != 0) {
> -		/* If the IF hasn't been set yet, use the value provided by
> -		   the caller (occurs in hybrid devices where the analog
> -		   call to xc4000_attach occurs before the digital side) */
> +		/* copy configuration if provided by the caller */
>  		priv->if_khz = cfg->if_khz;
> +		priv->default_pm = cfg->default_pm;
> +		priv->dvb_amplitude = cfg->dvb_amplitude;
> +		priv->set_smoothedcvbs = cfg->set_smoothedcvbs;
>  	}
>  
>  	/* Check if firmware has been loaded. It is possible that another
> diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.h xc4000/drivers/media/common/tuners/xc4000.h
> --- xc4000_orig/drivers/media/common/tuners/xc4000.h	2011-06-06 14:10:12.000000000 +0200
> +++ xc4000/drivers/media/common/tuners/xc4000.h	2011-06-06 16:44:01.000000000 +0200
> @@ -27,13 +27,15 @@
>  struct dvb_frontend;
>  struct i2c_adapter;
>  
> -#define XC4000_CARD_GENERIC		0
> -#define XC4000_CARD_PCTV_340E		1
> -#define XC4000_CARD_WINFAST_CX88	2
> -
>  struct xc4000_config {
> -	u8	card_type;	/* if card type is not generic, all other */
> -	u8	i2c_address;	/* parameters are automatically set */
> +	u8	i2c_address;
> +	/* if non-zero, power management is enabled by default */
> +	u8	default_pm;
> +	/* value to be written to XREG_AMPLITUDE in DVB-T mode (0: no write) */
> +	u8	dvb_amplitude;
> +	/* if non-zero, register 0x0E is set to filter analog TV video output */
> +	u8	set_smoothedcvbs;
> +	/* IF for DVB-T */
>  	u32	if_khz;
>  };
>  
> diff -uNr xc4000_orig/drivers/media/dvb/dvb-usb/dib0700_devices.c xc4000/drivers/media/dvb/dvb-usb/dib0700_devices.c
> --- xc4000_orig/drivers/media/dvb/dvb-usb/dib0700_devices.c	2011-06-06 14:40:53.000000000 +0200
> +++ xc4000/drivers/media/dvb/dvb-usb/dib0700_devices.c	2011-06-06 16:45:51.000000000 +0200
> @@ -2778,10 +2778,12 @@
>  	return adap->fe == NULL ? -ENODEV : 0;
>  }
>  
> -
>  static struct xc4000_config dib7000p_xc4000_tunerconfig = {
> -	.i2c_address      = 0x61,
> -	.if_khz           = 5400,
> +	.i2c_address	  = 0x61,
> +	.default_pm	  = 1,
> +	.dvb_amplitude	  = 0,
> +	.set_smoothedcvbs = 0,
> +	.if_khz		  = 5400
>  };
>  
>  static int xc4000_tuner_attach(struct dvb_usb_adapter *adap)
> diff -uNr xc4000_orig/drivers/media/video/tuner-core.c xc4000/drivers/media/video/tuner-core.c
> --- xc4000_orig/drivers/media/video/tuner-core.c	2011-06-06 14:10:15.000000000 +0200
> +++ xc4000/drivers/media/video/tuner-core.c	2011-06-06 16:51:22.000000000 +0200
> @@ -396,8 +396,12 @@
>  	{
>  		struct xc4000_config xc4000_cfg = {
>  			.i2c_address	  = t->i2c->addr,
> -			/* if_khz will be set when the digital dvb_attach() occurs */
> -			.if_khz	  = 0,
> +			/* FIXME: the correct parameters will be set */
> +			/* only when the digital dvb_attach() occurs */
> +			.default_pm	  = 0,
> +			.dvb_amplitude	  = 0,
> +			.set_smoothedcvbs = 0,
> +			.if_khz		  = 0
>  		};
>  		if (!dvb_attach(xc4000_attach,
>  				&t->fe, t->i2c->adapter, &xc4000_cfg))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

