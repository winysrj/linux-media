Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab0EYQHL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 12:07:11 -0400
Message-ID: <4BFBF5A7.6070703@redhat.com>
Date: Tue, 25 May 2010 13:07:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: vadim.catana@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] TechnoTrend TT-budget T-3000
References: <1273172404.2154.26.camel@xxx>
In-Reply-To: <1273172404.2154.26.camel@xxx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vadim Catana wrote:
> Hi,
> 
> This patch adds support for TechnoTrend TT-budget T-3000
> DVB-T card.

Please send your Signed-off-by together with the patch. Also,
send just one copy of the patch, not line-wrapped, otherwise, it
will fail when trying to apply on my tree.

Cheers,
Mauro.
> 
> 
> 
> diff -r ee9826bc7106 linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Apr 29
> 23:31:06 2010 -0300
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu May 06
> 21:33:14 2010 +0300
> @@ -5411,6 +5411,30 @@
>  			.gpio = 0x01fc00,
>  		} },
>  	},
> +	[SAA7134_BOARD_TECHNOTREND_BUDGET_T3000] = {
> +		.name           = "TechoTrend TT-budget T-3000",
> +		.tuner_type	= TUNER_PHILIPS_TD1316,
> +		.audio_clock    = 0x00187de7,
> +		.radio_type     = UNSET,
> +		.tuner_addr	= 0x63,
> +		.radio_addr	= ADDR_UNSET,
> +		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
> +		.mpeg           = SAA7134_MPEG_DVB,
> +		.inputs = {{
> +			.name   = name_tv,
> +			.vmux   = 3,
> +			.amux   = TV,
> +			.tv     = 1,
> +		}, {
> +			.name   = name_comp1,
> +			.vmux   = 0,
> +			.amux   = LINE2,
> +		}, {
> +			.name   = name_svideo,
> +			.vmux   = 8,
> +			.amux   = LINE2,
> +		} },
> +	},
>  
>  };
>  
> @@ -6568,6 +6592,12 @@
>  		.subdevice    = 0x6655,
>  		.driver_data  = SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S,
>  	}, {
> +		.vendor       = PCI_VENDOR_ID_PHILIPS,
> +		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
> +		.subvendor    = 0x13c2,
> +		.subdevice    = 0x2804,
> +		.driver_data  = SAA7134_BOARD_TECHNOTREND_BUDGET_T3000,
> +	}, {
>  		/* --- boards without eeprom + subsystem ID --- */
>  		.vendor       = PCI_VENDOR_ID_PHILIPS,
>  		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> @@ -7277,6 +7307,7 @@
>  	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
>  	case SAA7134_BOARD_ASUS_EUROPA2_HYBRID:
>  	case SAA7134_BOARD_ASUS_EUROPA_HYBRID:
> +	case SAA7134_BOARD_TECHNOTREND_BUDGET_T3000:
>  	{
>  
>  		/* The Philips EUROPA based hybrid boards have the tuner
> diff -r ee9826bc7106 linux/drivers/media/video/saa7134/saa7134-dvb.c
> --- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Apr 29
> 23:31:06 2010 -0300
> +++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu May 06
> 21:33:14 2010 +0300
> @@ -482,6 +482,18 @@
>  	.request_firmware = philips_tda1004x_request_firmware
>  };
>  
> +static struct tda1004x_config technotrend_budget_t3000_config = {
> +	.demod_address = 0x8,
> +	.invert        = 1,
> +	.invert_oclk   = 0,
> +	.xtal_freq     = TDA10046_XTAL_4M,
> +	.agc_config    = TDA10046_AGC_DEFAULT,
> +	.if_freq       = TDA10046_FREQ_3617,
> +	.tuner_address = 0x63,
> +	.request_firmware = philips_tda1004x_request_firmware
> +};
> +
> +
>  /* ------------------------------------------------------------------
>   * tda 1004x based cards with philips silicon tuner
>   */
> @@ -1169,6 +1181,18 @@
>  			fe0->dvb.frontend->ops.tuner_ops.set_params =
> philips_td1316_tuner_set_params;
>  		}
>  		break;
> +	case SAA7134_BOARD_TECHNOTREND_BUDGET_T3000:
> +		fe0->dvb.frontend = dvb_attach(tda10046_attach,
> +					       &technotrend_budget_t3000_config,
> +					       &dev->i2c_adap);
> +		if (fe0->dvb.frontend) {
> +			dev->original_demod_sleep = fe0->dvb.frontend->ops.sleep;
> +			fe0->dvb.frontend->ops.sleep = philips_europa_demod_sleep;
> +			fe0->dvb.frontend->ops.tuner_ops.init = philips_europa_tuner_init;
> +			fe0->dvb.frontend->ops.tuner_ops.sleep = philips_europa_tuner_sleep;
> +			fe0->dvb.frontend->ops.tuner_ops.set_params =
> philips_td1316_tuner_set_params;
> +		}
> +		break;
>  	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
>  		fe0->dvb.frontend = dvb_attach(tda10046_attach,
>  					       &philips_tu1216_61_config,
> diff -r ee9826bc7106 linux/drivers/media/video/saa7134/saa7134.h
> --- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Apr 29 23:31:06
> 2010 -0300
> +++ b/linux/drivers/media/video/saa7134/saa7134.h	Thu May 06 21:33:14
> 2010 +0300
> @@ -302,6 +302,7 @@
>  #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
>  #define SAA7134_BOARD_BEHOLD_505RDS_MK3     176
>  #define SAA7134_BOARD_HAWELL_HW_404M7		177
> +#define SAA7134_BOARD_TECHNOTREND_BUDGET_T3000 178
>  
>  #define SAA7134_MAXBOARDS 32
>  #define SAA7134_INPUT_MAX 8
> 
> 
> 
> Signed-off-by: Vadim Catana <vadim.catana@gmail.com>
> 
> 
> Best regards,
> Vadim Catana
> 
> 
> 


-- 

Cheers,
Mauro
