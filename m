Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:44973 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908Ab0CTAtR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 20:49:17 -0400
Subject: Re: Add AverTV Studio 509UA
From: hermann pitton <hermann-pitton@arcor.de>
To: =?UTF-8?Q?=D0=95=D0=B2=D0=B3=D0=B5=D0=BD=D0=B8=D0=B9_?=
	 =?UTF-8?Q?=D0=91=D0=B0=D1=86=D0=BC=D0=B0=D0=BD?=
	<evgenbatsman@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <6137756e1003191132t45bb29ddra5e9344f84faf86@mail.gmail.com>
References: <6137756e1003191132t45bb29ddra5e9344f84faf86@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 20 Mar 2010 01:38:13 +0100
Message-Id: <1269045493.5275.3.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Евгений,

is there any reason, why you set the charge pump bit to low and slow
tuning on a non FM tuner?

Cheers,
Hermann


Am Freitag, den 19.03.2010, 20:32 +0200 schrieb Евгений Бацман:
> A add tv tuner AverTV Studio 509UA but radio now not
> work(tuner_tea5764hn not in kernel)
> 
> 
> 
> diff -r a/linux/drivers/media/common/tuners/tuner-types.c
> --- a/linux/drivers/media/common/tuners/tuner-types.c	2010-03-17
> 20:38:10.000000000 +0200
> +++ b/linux/drivers/media/common/tuners/tuner-types.c	2010-03-19
> 14:25:24.000000000 +0200
> @@ -1353,6 +1353,30 @@
>  		.count  = ARRAY_SIZE(tuner_sony_btf_pxn01z_ranges),
>  	},
>  };
> +/* ------------ TUNER_PHILIPS_FQ1216ME_MK5 - Philips PAL ------------ */
> +
> +static struct tuner_range tuner_fq1216me_mk5_pal_ranges[] = {
> +	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
> +	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
> +	{ 16 * 999.99        , 0x8e, 0x04, },
> +};
> +
> +static struct tuner_params tuner_fq1216me_mk5_params[] = {
> +	{
> +		.type   = TUNER_PARAM_TYPE_PAL,
> +		.ranges = tuner_fq1216me_mk5_pal_ranges,
> +		.count  = ARRAY_SIZE(tuner_fq1216me_mk5_pal_ranges),
> +		.cb_first_if_lower_freq = 1,
> +		.has_tda9887 = 1,
> +		.port1_active = 1,
> +		.port2_active = 1,
> +		.port2_invert_for_secam_lc = 1,
> +		.default_top_mid = -2,
> +		.default_top_secam_low = -2,
> +		.default_top_secam_mid = -2,
> +		.default_top_secam_high = -2,
> +	},
> +};
> 
>  /* --------------------------------------------------------------------- */
> 
> @@ -1827,6 +1851,11 @@
>  		.params = tuner_sony_btf_pxn01z_params,
>  		.count  = ARRAY_SIZE(tuner_sony_btf_pxn01z_params),
>  	},
> +	[TUNER_PHILIPS_FQ1216ME_MK5] = { /* Philips PAL */
> +		.name   = "Philips PAL/SECAM multi (FQ1216ME MK5)",
> +		.params = tuner_fq1216me_mk5_params,
> +		.count  = ARRAY_SIZE(tuner_fq1216me_mk5_params),
> +	},
>  };
>  EXPORT_SYMBOL(tuners);
> 
> diff -r a/linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-03-17
> 20:38:10.000000000 +0200
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-03-19
> 16:34:17.000000000 +0200
> @@ -5411,7 +5411,44 @@
>  			.gpio = 0x389c00,
>  		} },
>  	},
> -
> +	[SAA7134_BOARD_AVERMEDIA_STUDIO_509UA] = {
> +		/* Evgen Batsman <evgenbatsman@gmail.com> */
> +		.name           = "Avermedia AVerTV Studio 509UA",
> +		.audio_clock    = 0x00187de7,
> +		.tuner_type     = TUNER_PHILIPS_FQ1216ME_MK5,
> +		.radio_type     = UNSET,
> +		.tuner_addr     = ADDR_UNSET,
> +		.radio_addr     = ADDR_UNSET,
> +		.tda9887_conf   = TDA9887_PRESENT,
> +		.gpiomask       = 0x03,
> +		.inputs         = { {
> +			.name = name_tv,
> +			.vmux = 1,
> +			.amux = TV,
> +			.tv   = 1,
> +			.gpio = 0x00,
> +		}, {
> +			.name = name_comp1,
> +			.vmux = 3,
> +			.amux = LINE1,
> +			.gpio = 0x00,
> +		}, {
> +			.name = name_svideo,
> +			.vmux = 8,
> +			.amux = LINE1,
> +			.gpio = 0x00,
> +		} },
> +		.radio = {
> +			.name = name_radio,
> +			.amux = LINE2,
> +			.gpio = 0x01,
> +		},
> +		.mute  = {
> +			.name = name_mute,
> +			.amux = LINE1,
> +			.gpio = 0x00,
> +		},
> +	},
>  };
> 
>  const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
> @@ -6567,6 +6604,12 @@
>  		.subvendor    = 0x107d,
>  		.subdevice    = 0x6655,
>  		.driver_data  = SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S,
> +	},{
> +		.vendor       = PCI_VENDOR_ID_PHILIPS,
> +		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
> +		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
> +		.subdevice    = 0xa14b,
> +		.driver_data  = SAA7134_BOARD_AVERMEDIA_STUDIO_509UA,
>  	}, {
>  		/* --- boards without eeprom + subsystem ID --- */
>  		.vendor       = PCI_VENDOR_ID_PHILIPS,
> diff -r a/linux/drivers/media/video/saa7134/saa7134.h
> --- a/linux/drivers/media/video/saa7134/saa7134.h	2010-03-17
> 20:38:10.000000000 +0200
> +++ b/linux/drivers/media/video/saa7134/saa7134.h	2010-03-19
> 13:13:00.000000000 +0200
> @@ -302,6 +302,7 @@
>  #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
>  #define SAA7134_BOARD_BEHOLD_505RDS_MK3     176
>  #define SAA7134_BOARD_HAWELL_HW_404M7		177
> +#define SAA7134_BOARD_AVERMEDIA_STUDIO_509UA 178
> 
>  #define SAA7134_MAXBOARDS 32
>  #define SAA7134_INPUT_MAX 8
> diff -r a/linux/drivers/media/video/saa7134/saa7134-input.c
> --- a/linux/drivers/media/video/saa7134/saa7134-input.c	2010-03-17
> 20:38:10.000000000 +0200
> +++ b/linux/drivers/media/video/saa7134/saa7134-input.c	2010-03-19
> 13:09:44.000000000 +0200
> @@ -569,6 +569,7 @@
>  	case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
>  	case SAA7134_BOARD_AVERMEDIA_STUDIO_507:
>  	case SAA7134_BOARD_AVERMEDIA_STUDIO_507UA:
> +	case SAA7134_BOARD_AVERMEDIA_STUDIO_509UA:
>  	case SAA7134_BOARD_AVERMEDIA_GO_007_FM:
>  	case SAA7134_BOARD_AVERMEDIA_M102:
>  	case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
> diff -r a/linux/include/media/tuner.h b/linux/include/media/tuner.h
> --- a/linux/include/media/tuner.h	2010-03-17 20:38:10.000000000 +0200
> +++ b/linux/include/media/tuner.h	2010-03-19 14:31:02.000000000 +0200
> @@ -130,6 +130,7 @@
>  #define TUNER_PHILIPS_CU1216L           82
>  #define TUNER_NXP_TDA18271		83
>  #define TUNER_SONY_BTF_PXN01Z		84
> +#define TUNER_PHILIPS_FQ1216ME_MK5      85
> 
>  /* tv card specific */
>  #define TDA9887_PRESENT 		(1<<0)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

