Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:56244 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbZKRDmL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 22:42:11 -0500
Subject: Re: [PATCH] Multifrontend support for saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: =?UTF-8?Q?Luk=C3=A1=C5=A1?= Karas <lukas.karas@centrum.cz>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200911171506.37145.lukas.karas@centrum.cz>
References: <200910312121.21926.lukas.karas@centrum.cz>
	 <200911051939.34222.lukas.karas@centrum.cz>
	 <1257473805.3290.40.camel@pc07.localdom.local>
	 <200911171506.37145.lukas.karas@centrum.cz>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Nov 2009 04:40:41 +0100
Message-Id: <1258515641.3255.39.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lukáš,

Am Dienstag, den 17.11.2009, 15:06 +0100 schrieb Lukáš Karas:
> Hi Hermann
> 
> At first, sorry for my late reaction, I havn't enough time for hacking...
> 
> Thank you for detailed subscription. So, the main problem probably is LNB supply 
> as I understand, yes?
> 
> Please, try modified patch, that turn on (off) LNB supply after software reset. 
> I don't know if I do it right. Hacking without access to hardware is hard. 

well, it is totally unchanged, also I had at least some Asus 3in1 up on
some F11 with the same results.

We need someone with some time and skills going through it.

If the i2c traffic is not corrupted, should be doable, else also ;)

I would not say, that MFE support on such an old driver has high prio.

Looking back on it, you see of course the roots for later stuff.

But given the low level of feedback, and they are already through on m$
now and bought the cx remains, means a now most likely working hardware
concept is already there, though.

If you, or likely even better Jean or both, have some time for it, I do
happily provide you with such hardware.

And can read some new book, eventually ;)

Cheers,
Hermann


> Lukas
> 
> 
> diff -uprN linux-a76d06e9ff9b/drivers/media/video/saa7134/saa7134-cards.c linux/drivers/media/video/saa7134/saa7134-
> cards.c
> --- linux-a76d06e9ff9b/drivers/media/video/saa7134/saa7134-cards.c	2009-10-31 10:40:46.000000000 +0100
> +++ linux/drivers/media/video/saa7134/saa7134-cards.c	2009-10-31 17:47:51.000000000 +0100
> @@ -614,6 +614,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tda9887_conf   = TDA9887_PRESENT,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_tv,
>  			.vmux   = 1,
> @@ -1352,6 +1353,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr     = ADDR_UNSET,
>  		.radio_addr     = ADDR_UNSET,
>  		 .mpeg           = SAA7134_MPEG_DVB,
> +		 .num_frontends  = 1,
>  		 .inputs         = {{
>  			 .name = name_tv,
>  			 .vmux = 1,
> @@ -1895,6 +1897,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tda9887_conf   = TDA9887_PRESENT | TDA9887_INTERCARRIER | TDA9887_PORT2_INACTIVE,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = {{
>  			.name = name_tv,
>  			.vmux = 3,
> @@ -1987,6 +1990,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.gpiomask	= 0x00200000,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = {{
>  			.name = name_tv,
>  			.vmux = 1,
> @@ -2020,6 +2024,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_comp1,
>  			.vmux   = 0,
> @@ -2126,6 +2131,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask	= 0x00200000,
>  		.inputs         = {{
>  			.name = name_tv,
> @@ -2426,6 +2432,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_tv,
>  			.vmux   = 3,
> @@ -2450,6 +2457,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_tv,
>  			.vmux   = 3,
> @@ -2473,6 +2481,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_comp1,
>  			.vmux   = 0,
> @@ -2596,6 +2605,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr     = ADDR_UNSET,
>  		.radio_addr     = ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = {{
>  			.name = name_comp1,
>  			.vmux = 3,
> @@ -2670,6 +2680,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.gpiomask	= 1 << 21,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = {{
>  			.name = name_tv,
>  			.vmux = 1,
> @@ -2761,6 +2772,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tuner_config   = 0,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask       = 0x0200000,
>  		.inputs = {{
>  			.name   = name_tv,
> @@ -2853,6 +2865,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.gpiomask	= 0x00200000,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 2,
>  		.inputs         = {{
>  			.name = name_tv,	/* Analog broadcast/cable TV */
>  			.vmux = 1,
> @@ -2886,6 +2899,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_comp1,
>  			.vmux   = 1,
> @@ -2906,6 +2920,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = {{
>  			.name = name_comp1,	/* Composite input */
>  			.vmux = 3,
> @@ -2924,6 +2939,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask       = 0x00600000, /* Bit 21 0=Radio, Bit 22 0=TV */
>  		.inputs = {{
>  			.name   = name_tv,
> @@ -2941,6 +2957,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr     = ADDR_UNSET,
>  		.radio_addr     = ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask       = 1 << 21,
>  		.inputs = {{
>  			.name   = name_tv,
> @@ -2974,6 +2991,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask       = 1 << 21,
>  		.inputs = {{
>  			.name   = name_tv,
> @@ -3004,6 +3022,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr     = ADDR_UNSET,
>  		.tda9887_conf   = TDA9887_PRESENT,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = {{
>  			.name = name_tv,
>  			.vmux = 1,
> @@ -3107,6 +3126,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1
>  	},
>  	[SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS] = {
>  		.name		= "LifeView FlyDVB-T Hybrid Cardbus/MSI TV @nywhere A/D NB",
> @@ -3116,6 +3136,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask       = 0x00600000, /* Bit 21 0=Radio, Bit 22 0=TV */
>  		.inputs         = {{
>  			.name = name_tv,
> @@ -3199,6 +3220,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr     = ADDR_UNSET,
>  		.radio_addr     = ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 2,
>  		.inputs = {{
>  			.name   = name_tv,
>  			.vmux   = 1,
> @@ -3224,6 +3246,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = {{
>  			.name = name_comp1,	/* Composite input */
>  			.vmux = 3,
> @@ -3275,6 +3298,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr     = 0x60,
>  		.tda9887_conf   = TDA9887_PRESENT,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = {{
>  			.name = name_tv,
>  			.vmux = 1,
> @@ -3303,6 +3327,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tda9887_conf   = TDA9887_PRESENT| TDA9887_PORT1_ACTIVE | TDA9887_PORT2_ACTIVE,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_tv,
>  			.vmux   = 3,
> @@ -3331,6 +3356,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr     = ADDR_UNSET,
>  		.tuner_config   = 1,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask       = 0x000200000,
>  		.inputs         = {{
>  			.name = name_tv,
> @@ -3409,6 +3435,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_tv,
>  			.vmux   = 3,
> @@ -3435,6 +3462,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr     = ADDR_UNSET,
>  		.tuner_config   = 1,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask       = 0x0200100,
>  		.inputs         = {{
>  			.name = name_tv,
> @@ -3466,6 +3494,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr     = ADDR_UNSET,
>  		.tuner_config   = 3,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.ts_type	= SAA7134_MPEG_TS_SERIAL,
>  		.gpiomask       = 0x0800100, /* GPIO 21 is an INPUT */
>  		.inputs         = {{
> @@ -3498,6 +3527,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr     = ADDR_UNSET,
>  		.tuner_config   = 3,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.ts_type	= SAA7134_MPEG_TS_SERIAL,
>  		.gpiomask       = 0x0800100, /* GPIO 21 is an INPUT */
>  		.inputs         = {{
> @@ -3529,6 +3559,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_tv,
>  			.vmux   = 1,
> @@ -3666,6 +3697,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_tv,
>  			.vmux   = 1,
> @@ -3690,6 +3722,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tuner_config   = 2,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask       = 0x0200000,
>  		.inputs = {{
>  			.name   = name_tv,
> @@ -3743,6 +3776,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tuner_config   = 2,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask       = 0x0200000,
>  		.inputs = {{
>  			.name   = name_tv,
> @@ -3762,6 +3796,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_config   = 2,
>  		.gpiomask	= 1 << 21,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = {{
>  			.name = name_tv,
>  			.vmux = 1,
> @@ -3894,6 +3929,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr     = ADDR_UNSET,
>  		.tuner_config   = 0,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_tv, /* FIXME: analog tv untested */
>  			.vmux   = 1,
> @@ -4777,6 +4813,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr     = ADDR_UNSET,
>  		.radio_addr     = ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = {{
>  			.name   = name_comp1,
>  			.vmux   = 3,
> @@ -4796,6 +4833,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr   = ADDR_UNSET,
>  		.tuner_config = 0,
>  		.mpeg         = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs       = {{
>  			.name = name_tv,
>  			.vmux = 1,
> @@ -4820,6 +4858,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tuner_config   = 2,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask       = 0x0200000,
>  		.inputs = { {
>  			.name   = name_tv,
> @@ -4849,6 +4888,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		 .mpeg           = SAA7134_MPEG_DVB,
> +		 .num_frontends  = 1,
>  		 .inputs         = {{
>  			 .name = name_tv,
>  			 .vmux = 1,
> @@ -4876,6 +4916,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = {{
>  			.name = name_tv,
>  			.vmux = 1,
> @@ -4953,6 +4994,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr     = ADDR_UNSET,
>  		.radio_addr     = ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = { {
>  			.name = name_comp,
>  			.vmux = 1,
> @@ -4972,6 +5014,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr     = ADDR_UNSET,
>  		.radio_addr     = ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = { {
>  			.name   = name_tv,
>  			.vmux   = 4,
> @@ -5001,6 +5044,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr     = ADDR_UNSET,
>  		.tda9887_conf   = TDA9887_PRESENT,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = {{
>  			.name = name_tv,
>  			.vmux = 3,
> @@ -5030,6 +5074,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_config   = 2,
>  		.gpiomask       = 1 << 21,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 2,
>  		.inputs         = {{
>  			.name = name_tv,
>  			.vmux = 1,
> @@ -5094,6 +5139,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr     = ADDR_UNSET,
>  		.tda9887_conf   = TDA9887_PRESENT,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = { {
>  			.name = name_tv,
>  			.vmux = 1,
> @@ -5118,6 +5164,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tuner_config   = 0,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.gpiomask       = 0x0200000,
>  		.inputs = { {
>  			.name   = name_tv,
> @@ -5259,6 +5306,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
>  		.mpeg		= SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = { {
>  			.name	= name_comp1,
>  			.vmux	= 0,
> @@ -5278,6 +5326,7 @@ struct saa7134_board saa7134_boards[] =
>  		.tuner_addr     = ADDR_UNSET,
>  		.radio_addr     = ADDR_UNSET,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs         = { {
>  			.name = name_tv,
>  			.vmux = 2,
> @@ -5306,6 +5355,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr     = ADDR_UNSET,
>  		.tuner_config   = 0,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
>  		.inputs         = {{
>  			.name = name_tv,
> @@ -5327,6 +5377,7 @@ struct saa7134_board saa7134_boards[] =
>  		.radio_addr	= ADDR_UNSET,
>  		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
>  		.mpeg           = SAA7134_MPEG_DVB,
> +		.num_frontends  = 1,
>  		.inputs = { {
>  			.name   = name_tv,
>  			.vmux   = 3,
> diff -uprN linux-a76d06e9ff9b/drivers/media/video/saa7134/saa7134-dvb.c linux/drivers/media/video/saa7134/saa7134-dvb.c
> --- linux-a76d06e9ff9b/drivers/media/video/saa7134/saa7134-dvb.c	2009-10-31 10:40:46.000000000 +0100
> +++ linux/drivers/media/video/saa7134/saa7134-dvb.c	2009-11-17 14:04:41.000000000 +0100
> @@ -68,10 +68,6 @@ static unsigned int antenna_pwr;
>  module_param(antenna_pwr, int, 0444);
>  MODULE_PARM_DESC(antenna_pwr,"enable antenna power (Pinnacle 300i)");
> 
> -static int use_frontend;
> -module_param(use_frontend, int, 0644);
> -MODULE_PARM_DESC(use_frontend,"for cards with multiple frontends (0: terrestrial, 1: satellite)");
> -
>  static int debug;
>  module_param(debug, int, 0644);
>  MODULE_PARM_DESC(debug, "Turn on/off module debugging (default:off).");
> @@ -543,19 +539,15 @@ static int philips_tda827x_tuner_sleep(s
>  }
> 
>  static int configure_tda827x_fe(struct saa7134_dev *dev,
> +				struct videobuf_dvb_frontend *fe,
>  				struct tda1004x_config *cdec_conf,
>  				struct tda827x_config *tuner_conf)
>  {
> -	struct videobuf_dvb_frontend *fe0;
> -
> -	/* Get the first frontend */
> -	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
> -
> -	fe0->dvb.frontend = dvb_attach(tda10046_attach, cdec_conf, &dev->i2c_adap);
> -	if (fe0->dvb.frontend) {
> +	fe->dvb.frontend = dvb_attach(tda10046_attach, cdec_conf, &dev->i2c_adap);
> +	if (fe->dvb.frontend) {
>  		if (cdec_conf->i2c_gate)
> -			fe0->dvb.frontend->ops.i2c_gate_ctrl = tda8290_i2c_gate_ctrl;
> -		if (dvb_attach(tda827x_attach, fe0->dvb.frontend,
> +			fe->dvb.frontend->ops.i2c_gate_ctrl = tda8290_i2c_gate_ctrl;
> +		if (dvb_attach(tda827x_attach, fe->dvb.frontend,
>  			       cdec_conf->tuner_address,
>  			       &dev->i2c_adap, tuner_conf))
>  			return 0;
> @@ -1075,193 +1067,268 @@ static struct tda18271_config dtv1000s_t
>   * Core code
>   */
> 
> +static int saa7134_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
> +{
> +	struct saa7134_dev *dev = fe->dvb->priv;
> +	int ret = 0;
> +	int fe_id;
> +
> +	printk("%s(acquire=%d)\n", __func__, acquire);
> +
> +	fe_id = videobuf_dvb_find_frontend(&dev->frontends, fe);
> +	if (!fe_id) {
> +		printk("%s() No frontend found\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	if(acquire) {
> +		if (dev->frontends.active_fe_id != 0){
> +			printk("%s() Frontend id %d is busy, active %d\n", __func__,fe_id, dev->frontends.active_fe_id);
> +			return -EBUSY;
> +		}else
> +			dev->frontends.active_fe_id = fe_id;
> +
> +		if (dev->frontends.active_fe_id == 1) {
> +			/* try to reset the hardware (SWRST) */
> +			saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
> +			msleep(10);
> +			saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
> +			udelay(1000);
> +		}
> +		if (dev->frontends.active_fe_id == 2) {
> +			/* try to reset the hardware (SWRST) */
> +			saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
> +			msleep(10);
> +			saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
> +			udelay(1000);
> +
> +			if (dev->board == SAA7134_BOARD_MEDION_MD8800_QUADRO && dev->eedata[2] == 0x07 ){
> +				/* turn on the 2nd lnb supply */
> +				u8 data = 0xc4;
> +				struct i2c_msg msg = {.addr = 0x08, .buf = &data, .flags = 0, .len = 1};
> +				if (fe->ops.i2c_gate_ctrl) {
> +					fe->ops.i2c_gate_ctrl(fe, 1);
> +					i2c_transfer(&dev->i2c_adap, &msg, 1);
> +					fe->ops.i2c_gate_ctrl(fe, 0);
> +				}
> +			}
> +		}
> +	} else {
> +		if (dev->board == SAA7134_BOARD_MEDION_MD8800_QUADRO && dev->eedata[2] == 0x07 && fe_id == 2) {
> +			/* turn off the 2nd lnb supply */
> +			u8 data = 0x80;
> +			struct i2c_msg msg = {.addr = 0x08, .buf = &data, .flags = 0, .len = 1};
> +			if (fe->ops.i2c_gate_ctrl) {
> +				fe->ops.i2c_gate_ctrl(fe, 1);
> +				i2c_transfer(&dev->i2c_adap, &msg, 1);
> +				fe->ops.i2c_gate_ctrl(fe, 0);
> +			}
> +		}
> +		dev->frontends.active_fe_id = 0;
> +	}
> +
> +	printk("%s(acquire=%d) for fe_id = %d returns %d\n", __func__, acquire, fe_id, ret);
> +	return ret;
> +}
> +
>  static int dvb_init(struct saa7134_dev *dev)
>  {
> -	int ret;
> +	int ret, i;
>  	int attach_xc3028 = 0;
> -	struct videobuf_dvb_frontend *fe0;
> +	struct videobuf_dvb_frontend *last_fe = NULL;
> +	struct videobuf_dvb_frontend *fe;
> 
> -	/* FIXME: add support for multi-frontend */
>  	mutex_init(&dev->frontends.lock);
>  	INIT_LIST_HEAD(&dev->frontends.felist);
> 
> -	printk(KERN_INFO "%s() allocating 1 frontend\n", __func__);
> -	fe0 = videobuf_dvb_alloc_frontend(&dev->frontends, 1);
> -	if (!fe0) {
> -		printk(KERN_ERR "%s() failed to alloc\n", __func__);
> -		return -ENOMEM;
> +	if (!saa7134_boards[dev->board].num_frontends) {
> +		printk(KERN_ERR "%s() .num_frontends should be non-zero\n", __func__);
> +		return -ENODEV;
>  	}
> -
> +
>  	/* init struct videobuf_dvb */
>  	dev->ts.nr_bufs    = 32;
>  	dev->ts.nr_packets = 32*4;
> -	fe0->dvb.name = dev->name;
> -	videobuf_queue_sg_init(&fe0->dvb.dvbq, &saa7134_ts_qops,
> -			    &dev->pci->dev, &dev->slock,
> -			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -			    V4L2_FIELD_ALTERNATE,
> -			    sizeof(struct saa7134_buf),
> -			    dev);
> 
> +	/* init frontends */
> +	printk(KERN_ERR "%s() allocating %d frontends\n", __func__, saa7134_boards[dev->board].num_frontends);
> +	for (i = 1; i <= saa7134_boards[dev->board].num_frontends; i++) {
> +		last_fe = videobuf_dvb_alloc_frontend(&dev->frontends, i);
> +		if(last_fe == NULL) {
> +			printk(KERN_ERR "%s() failed to alloc\n", __func__);
> +			goto dettach_frontend;
> +		}
> +		last_fe->dvb.name = dev->name;
> +		videobuf_queue_sg_init(&last_fe->dvb.dvbq, &saa7134_ts_qops,
> +								&dev->pci->dev, &dev->slock,
> +								V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +								V4L2_FIELD_ALTERNATE,
> +								sizeof(struct saa7134_buf),
> +								dev);
> +	}
> +
>  	switch (dev->board) {
>  	case SAA7134_BOARD_PINNACLE_300I_DVBT_PAL:
>  		dprintk("pinnacle 300i dvb setup\n");
> -		fe0->dvb.frontend = dvb_attach(mt352_attach, &pinnacle_300i,
> +		last_fe->dvb.frontend = dvb_attach(mt352_attach, &pinnacle_300i,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			fe0->dvb.frontend->ops.tuner_ops.set_params = mt352_pinnacle_tuner_set_params;
> +		if (last_fe->dvb.frontend) {
> +			last_fe->dvb.frontend->ops.tuner_ops.set_params = mt352_pinnacle_tuner_set_params;
>  		}
>  		break;
>  	case SAA7134_BOARD_AVERMEDIA_777:
>  	case SAA7134_BOARD_AVERMEDIA_A16AR:
>  		dprintk("avertv 777 dvb setup\n");
> -		fe0->dvb.frontend = dvb_attach(mt352_attach, &avermedia_777,
> +		last_fe->dvb.frontend = dvb_attach(mt352_attach, &avermedia_777,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend) {
> +			dvb_attach(simple_tuner_attach, last_fe->dvb.frontend,
>  				   &dev->i2c_adap, 0x61,
>  				   TUNER_PHILIPS_TD1316);
>  		}
>  		break;
>  	case SAA7134_BOARD_AVERMEDIA_A16D:
>  		dprintk("AverMedia A16D dvb setup\n");
> -		fe0->dvb.frontend = dvb_attach(mt352_attach,
> +		last_fe->dvb.frontend = dvb_attach(mt352_attach,
>  						&avermedia_xc3028_mt352_dev,
>  						&dev->i2c_adap);
>  		attach_xc3028 = 1;
>  		break;
>  	case SAA7134_BOARD_MD7134:
> -		fe0->dvb.frontend = dvb_attach(tda10046_attach,
> +		last_fe->dvb.frontend = dvb_attach(tda10046_attach,
>  					       &medion_cardbus,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend) {
> +			dvb_attach(simple_tuner_attach, last_fe->dvb.frontend,
>  				   &dev->i2c_adap, medion_cardbus.tuner_address,
>  				   TUNER_PHILIPS_FMD1216ME_MK3);
>  		}
>  		break;
>  	case SAA7134_BOARD_PHILIPS_TOUGH:
> -		fe0->dvb.frontend = dvb_attach(tda10046_attach,
> +		last_fe->dvb.frontend = dvb_attach(tda10046_attach,
>  					       &philips_tu1216_60_config,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			fe0->dvb.frontend->ops.tuner_ops.init = philips_tu1216_init;
> -			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_tda6651_pll_set;
> +		if (last_fe->dvb.frontend) {
> +			last_fe->dvb.frontend->ops.tuner_ops.init = philips_tu1216_init;
> +			last_fe->dvb.frontend->ops.tuner_ops.set_params = philips_tda6651_pll_set;
>  		}
>  		break;
>  	case SAA7134_BOARD_FLYDVBTDUO:
>  	case SAA7134_BOARD_FLYDVBT_DUO_CARDBUS:
> -		if (configure_tda827x_fe(dev, &tda827x_lifeview_config,
> +		if (configure_tda827x_fe(dev, last_fe, &tda827x_lifeview_config,
>  					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_PHILIPS_EUROPA:
>  	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
>  	case SAA7134_BOARD_ASUS_EUROPA_HYBRID:
> -		fe0->dvb.frontend = dvb_attach(tda10046_attach,
> +		last_fe->dvb.frontend = dvb_attach(tda10046_attach,
>  					       &philips_europa_config,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			dev->original_demod_sleep = fe0->dvb.frontend->ops.sleep;
> -			fe0->dvb.frontend->ops.sleep = philips_europa_demod_sleep;
> -			fe0->dvb.frontend->ops.tuner_ops.init = philips_europa_tuner_init;
> -			fe0->dvb.frontend->ops.tuner_ops.sleep = philips_europa_tuner_sleep;
> -			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_td1316_tuner_set_params;
> +		if (last_fe->dvb.frontend) {
> +			dev->original_demod_sleep = last_fe->dvb.frontend->ops.sleep;
> +			last_fe->dvb.frontend->ops.sleep = philips_europa_demod_sleep;
> +			last_fe->dvb.frontend->ops.tuner_ops.init = philips_europa_tuner_init;
> +			last_fe->dvb.frontend->ops.tuner_ops.sleep = philips_europa_tuner_sleep;
> +			last_fe->dvb.frontend->ops.tuner_ops.set_params = philips_td1316_tuner_set_params;
>  		}
>  		break;
>  	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
> -		fe0->dvb.frontend = dvb_attach(tda10046_attach,
> +		last_fe->dvb.frontend = dvb_attach(tda10046_attach,
>  					       &philips_tu1216_61_config,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			fe0->dvb.frontend->ops.tuner_ops.init = philips_tu1216_init;
> -			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_tda6651_pll_set;
> +		if (last_fe->dvb.frontend) {
> +			last_fe->dvb.frontend->ops.tuner_ops.init = philips_tu1216_init;
> +			last_fe->dvb.frontend->ops.tuner_ops.set_params = philips_tda6651_pll_set;
>  		}
>  		break;
>  	case SAA7134_BOARD_KWORLD_DVBT_210:
> -		if (configure_tda827x_fe(dev, &kworld_dvb_t_210_config,
> +		if (configure_tda827x_fe(dev, last_fe, &kworld_dvb_t_210_config,
>  					 &tda827x_cfg_2) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_HAUPPAUGE_HVR1120:
> -		fe0->dvb.frontend = dvb_attach(tda10048_attach,
> +		last_fe->dvb.frontend = dvb_attach(tda10048_attach,
>  					       &hcw_tda10048_config,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend != NULL) {
> -			dvb_attach(tda829x_attach, fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend != NULL) {
> +			dvb_attach(tda829x_attach, last_fe->dvb.frontend,
>  				   &dev->i2c_adap, 0x4b,
>  				   &tda829x_no_probe);
> -			dvb_attach(tda18271_attach, fe0->dvb.frontend,
> +			dvb_attach(tda18271_attach, last_fe->dvb.frontend,
>  				   0x60, &dev->i2c_adap,
>  				   &hcw_tda18271_config);
>  		}
>  		break;
>  	case SAA7134_BOARD_PHILIPS_TIGER:
> -		if (configure_tda827x_fe(dev, &philips_tiger_config,
> +		if (configure_tda827x_fe(dev, last_fe, &philips_tiger_config,
>  					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_PINNACLE_PCTV_310i:
> -		if (configure_tda827x_fe(dev, &pinnacle_pctv_310i_config,
> +		if (configure_tda827x_fe(dev, last_fe, &pinnacle_pctv_310i_config,
>  					 &tda827x_cfg_1) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
> -		if (configure_tda827x_fe(dev, &hauppauge_hvr_1110_config,
> +		if (configure_tda827x_fe(dev, last_fe, &hauppauge_hvr_1110_config,
>  					 &tda827x_cfg_1) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
> -		fe0->dvb.frontend = dvb_attach(lgdt3305_attach,
> +		last_fe->dvb.frontend = dvb_attach(lgdt3305_attach,
>  					       &hcw_lgdt3305_config,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			dvb_attach(tda829x_attach, fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend) {
> +			dvb_attach(tda829x_attach, last_fe->dvb.frontend,
>  				   &dev->i2c_adap, 0x4b,
>  				   &tda829x_no_probe);
> -			dvb_attach(tda18271_attach, fe0->dvb.frontend,
> +			dvb_attach(tda18271_attach, last_fe->dvb.frontend,
>  				   0x60, &dev->i2c_adap,
>  				   &hcw_tda18271_config);
>  		}
>  		break;
>  	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
> -		if (configure_tda827x_fe(dev, &asus_p7131_dual_config,
> +		if (configure_tda827x_fe(dev, last_fe, &asus_p7131_dual_config,
>  					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_FLYDVBT_LR301:
> -		if (configure_tda827x_fe(dev, &tda827x_lifeview_config,
> +		if (configure_tda827x_fe(dev, last_fe, &tda827x_lifeview_config,
>  					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_FLYDVB_TRIO:
> -		if (!use_frontend) {	/* terrestrial */
> -			if (configure_tda827x_fe(dev, &lifeview_trio_config,
> -						 &tda827x_cfg_0) < 0)
> +		/* terrestrial */
> +		fe = videobuf_dvb_get_frontend(&dev->frontends, 1);
> +		if (configure_tda827x_fe(dev, fe, &lifeview_trio_config,
> +						&tda827x_cfg_0) < 0)
> +			goto dettach_frontend;
> +
> +		/* satellite */
> +		fe = videobuf_dvb_get_frontend(&dev->frontends, 2);
> +		fe->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs, &dev->i2c_adap);
> +		if (fe->dvb.frontend) {
> +			fe->dvb.frontend->id = 1;
> +			if (dvb_attach(tda826x_attach, fe->dvb.frontend, 0x63,
> +								&dev->i2c_adap, 0) == NULL) {
> +				wprintk("%s: Lifeview Trio, No tda826x found!\n", __func__);
> +				goto dettach_frontend;
> +			}
> +			if (dvb_attach(isl6421_attach, fe->dvb.frontend, &dev->i2c_adap,
> +									0x08, 0, 0) == NULL) {
> +				wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
>  				goto dettach_frontend;
> -		} else {  		/* satellite */
> -			fe0->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs, &dev->i2c_adap);
> -			if (fe0->dvb.frontend) {
> -				if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x63,
> -									&dev->i2c_adap, 0) == NULL) {
> -					wprintk("%s: Lifeview Trio, No tda826x found!\n", __func__);
> -					goto dettach_frontend;
> -				}
> -				if (dvb_attach(isl6421_attach, fe0->dvb.frontend, &dev->i2c_adap,
> -										0x08, 0, 0) == NULL) {
> -					wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
> -					goto dettach_frontend;
> -				}
>  			}
>  		}
>  		break;
>  	case SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331:
>  	case SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS:
> -		fe0->dvb.frontend = dvb_attach(tda10046_attach,
> +		last_fe->dvb.frontend = dvb_attach(tda10046_attach,
>  					       &ads_tech_duo_config,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			if (dvb_attach(tda827x_attach,fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend) {
> +			if (dvb_attach(tda827x_attach,last_fe->dvb.frontend,
>  				   ads_tech_duo_config.tuner_address, &dev->i2c_adap,
>  								&ads_duo_cfg) == NULL) {
>  				wprintk("no tda827x tuner found at addr: %02x\n",
> @@ -1272,83 +1339,86 @@ static int dvb_init(struct saa7134_dev *
>  			wprintk("failed to attach tda10046\n");
>  		break;
>  	case SAA7134_BOARD_TEVION_DVBT_220RF:
> -		if (configure_tda827x_fe(dev, &tevion_dvbt220rf_config,
> +		if (configure_tda827x_fe(dev, last_fe, &tevion_dvbt220rf_config,
>  					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_MEDION_MD8800_QUADRO:
> -		if (!use_frontend) {     /* terrestrial */
> -			if (configure_tda827x_fe(dev, &md8800_dvbt_config,
> -						 &tda827x_cfg_0) < 0)
> -				goto dettach_frontend;
> -		} else {        /* satellite */
> -			fe0->dvb.frontend = dvb_attach(tda10086_attach,
> -							&flydvbs, &dev->i2c_adap);
> -			if (fe0->dvb.frontend) {
> -				struct dvb_frontend *fe = fe0->dvb.frontend;
> -				u8 dev_id = dev->eedata[2];
> -				u8 data = 0xc4;
> -				struct i2c_msg msg = {.addr = 0x08, .flags = 0, .len = 1};
> +		/* terrestrial */
> +		fe = videobuf_dvb_get_frontend(&dev->frontends, 1);
> +		if (configure_tda827x_fe(dev, fe, &md8800_dvbt_config,
> +						&tda827x_cfg_0) < 0)
> +			goto dettach_frontend;
> 
> -				if (dvb_attach(tda826x_attach, fe0->dvb.frontend,
> -						0x60, &dev->i2c_adap, 0) == NULL) {
> -					wprintk("%s: Medion Quadro, no tda826x "
> +		/* satellite */
> +		fe = videobuf_dvb_get_frontend(&dev->frontends, 2);
> +		fe->dvb.frontend = dvb_attach(tda10086_attach,
> +						&flydvbs, &dev->i2c_adap);
> +		if (fe->dvb.frontend) {
> +			struct dvb_frontend *dvb_fe = fe->dvb.frontend;
> +			u8 dev_id = dev->eedata[2];
> +			u8 data = 0xc4;
> +			struct i2c_msg msg = {.addr = 0x08, .flags = 0, .len = 1};
> +			dvb_fe->id = 1;
> +
> +			if (dvb_attach(tda826x_attach, dvb_fe,
> +					0x60, &dev->i2c_adap, 0) == NULL) {
> +				wprintk("%s: Medion Quadro, no tda826x "
> +					"found !\n", __func__);
> +				goto dettach_frontend;
> +			}
> +			if (dev_id != 0x08) {
> +				/* we need to open the i2c gate (we know it exists) */
> +				dvb_fe->ops.i2c_gate_ctrl(dvb_fe, 1);
> +				if (dvb_attach(isl6405_attach, dvb_fe,
> +						&dev->i2c_adap, 0x08, 0, 0) == NULL) {
> +					wprintk("%s: Medion Quadro, no ISL6405 "
>  						"found !\n", __func__);
>  					goto dettach_frontend;
>  				}
> -				if (dev_id != 0x08) {
> -					/* we need to open the i2c gate (we know it exists) */
> -					fe->ops.i2c_gate_ctrl(fe, 1);
> -					if (dvb_attach(isl6405_attach, fe,
> -							&dev->i2c_adap, 0x08, 0, 0) == NULL) {
> -						wprintk("%s: Medion Quadro, no ISL6405 "
> -							"found !\n", __func__);
> -						goto dettach_frontend;
> -					}
> -					if (dev_id == 0x07) {
> -						/* fire up the 2nd section of the LNB supply since
> -						   we can't do this from the other section */
> -						msg.buf = &data;
> -						i2c_transfer(&dev->i2c_adap, &msg, 1);
> -					}
> -					fe->ops.i2c_gate_ctrl(fe, 0);
> -					dev->original_set_voltage = fe->ops.set_voltage;
> -					fe->ops.set_voltage = md8800_set_voltage;
> -					dev->original_set_high_voltage = fe->ops.enable_high_lnb_voltage;
> -					fe->ops.enable_high_lnb_voltage = md8800_set_high_voltage;
> -				} else {
> -					fe->ops.set_voltage = md8800_set_voltage2;
> -					fe->ops.enable_high_lnb_voltage = md8800_set_high_voltage2;
> +				if (dev_id == 0x07) {
> +					/* fire up the 2nd section of the LNB supply since
> +						we can't do this from the other section */
> +					msg.buf = &data;
> +					i2c_transfer(&dev->i2c_adap, &msg, 1);
>  				}
> +				dvb_fe->ops.i2c_gate_ctrl(dvb_fe, 0);
> +				dev->original_set_voltage = dvb_fe->ops.set_voltage;
> +				dvb_fe->ops.set_voltage = md8800_set_voltage;
> +				dev->original_set_high_voltage = dvb_fe->ops.enable_high_lnb_voltage;
> +				dvb_fe->ops.enable_high_lnb_voltage = md8800_set_high_voltage;
> +			} else {
> +				dvb_fe->ops.set_voltage = md8800_set_voltage2;
> +				dvb_fe->ops.enable_high_lnb_voltage = md8800_set_high_voltage2;
>  			}
>  		}
>  		break;
>  	case SAA7134_BOARD_AVERMEDIA_AVERTVHD_A180:
> -		fe0->dvb.frontend = dvb_attach(nxt200x_attach, &avertvhda180,
> +		last_fe->dvb.frontend = dvb_attach(nxt200x_attach, &avertvhda180,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend)
> -			dvb_attach(dvb_pll_attach, fe0->dvb.frontend, 0x61,
> +		if (last_fe->dvb.frontend)
> +			dvb_attach(dvb_pll_attach, last_fe->dvb.frontend, 0x61,
>  				   NULL, DVB_PLL_TDHU2);
>  		break;
>  	case SAA7134_BOARD_ADS_INSTANT_HDTV_PCI:
>  	case SAA7134_BOARD_KWORLD_ATSC110:
> -		fe0->dvb.frontend = dvb_attach(nxt200x_attach, &kworldatsc110,
> +		last_fe->dvb.frontend = dvb_attach(nxt200x_attach, &kworldatsc110,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend)
> -			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend)
> +			dvb_attach(simple_tuner_attach, last_fe->dvb.frontend,
>  				   &dev->i2c_adap, 0x61,
>  				   TUNER_PHILIPS_TUV1236D);
>  		break;
>  	case SAA7134_BOARD_FLYDVBS_LR300:
> -		fe0->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
> +		last_fe->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x60,
> +		if (last_fe->dvb.frontend) {
> +			if (dvb_attach(tda826x_attach, last_fe->dvb.frontend, 0x60,
>  				       &dev->i2c_adap, 0) == NULL) {
>  				wprintk("%s: No tda826x found!\n", __func__);
>  				goto dettach_frontend;
>  			}
> -			if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
> +			if (dvb_attach(isl6421_attach, last_fe->dvb.frontend,
>  				       &dev->i2c_adap, 0x08, 0, 0) == NULL) {
>  				wprintk("%s: No ISL6421 found!\n", __func__);
>  				goto dettach_frontend;
> @@ -1356,72 +1426,72 @@ static int dvb_init(struct saa7134_dev *
>  		}
>  		break;
>  	case SAA7134_BOARD_ASUS_EUROPA2_HYBRID:
> -		fe0->dvb.frontend = dvb_attach(tda10046_attach,
> +		last_fe->dvb.frontend = dvb_attach(tda10046_attach,
>  					       &medion_cardbus,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			dev->original_demod_sleep = fe0->dvb.frontend->ops.sleep;
> -			fe0->dvb.frontend->ops.sleep = philips_europa_demod_sleep;
> +		if (last_fe->dvb.frontend) {
> +			dev->original_demod_sleep = last_fe->dvb.frontend->ops.sleep;
> +			last_fe->dvb.frontend->ops.sleep = philips_europa_demod_sleep;
> 
> -			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
> +			dvb_attach(simple_tuner_attach, last_fe->dvb.frontend,
>  				   &dev->i2c_adap, medion_cardbus.tuner_address,
>  				   TUNER_PHILIPS_FMD1216ME_MK3);
>  		}
>  		break;
>  	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
> -		fe0->dvb.frontend = dvb_attach(tda10046_attach,
> +		last_fe->dvb.frontend = dvb_attach(tda10046_attach,
>  				&philips_europa_config,
>  				&dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			fe0->dvb.frontend->ops.tuner_ops.init = philips_td1316_tuner_init;
> -			fe0->dvb.frontend->ops.tuner_ops.set_params = philips_td1316_tuner_set_params;
> +		if (last_fe->dvb.frontend) {
> +			last_fe->dvb.frontend->ops.tuner_ops.init = philips_td1316_tuner_init;
> +			last_fe->dvb.frontend->ops.tuner_ops.set_params = philips_td1316_tuner_set_params;
>  		}
>  		break;
>  	case SAA7134_BOARD_CINERGY_HT_PCMCIA:
> -		if (configure_tda827x_fe(dev, &cinergy_ht_config,
> +		if (configure_tda827x_fe(dev, last_fe, &cinergy_ht_config,
>  					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_CINERGY_HT_PCI:
> -		if (configure_tda827x_fe(dev, &cinergy_ht_pci_config,
> +		if (configure_tda827x_fe(dev, last_fe, &cinergy_ht_pci_config,
>  					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_PHILIPS_TIGER_S:
> -		if (configure_tda827x_fe(dev, &philips_tiger_s_config,
> +		if (configure_tda827x_fe(dev, last_fe, &philips_tiger_s_config,
>  					 &tda827x_cfg_2) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_ASUS_P7131_4871:
> -		if (configure_tda827x_fe(dev, &asus_p7131_4871_config,
> +		if (configure_tda827x_fe(dev, last_fe, &asus_p7131_4871_config,
>  					 &tda827x_cfg_2) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
> -		if (configure_tda827x_fe(dev, &asus_p7131_hybrid_lna_config,
> +		if (configure_tda827x_fe(dev, last_fe, &asus_p7131_hybrid_lna_config,
>  					 &tda827x_cfg_2) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
> -		if (configure_tda827x_fe(dev, &avermedia_super_007_config,
> +		if (configure_tda827x_fe(dev, last_fe, &avermedia_super_007_config,
>  					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
> -		if (configure_tda827x_fe(dev, &twinhan_dtv_dvb_3056_config,
> +		if (configure_tda827x_fe(dev, last_fe, &twinhan_dtv_dvb_3056_config,
>  					 &tda827x_cfg_2_sw42) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_PHILIPS_SNAKE:
> -		fe0->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
> +		last_fe->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
>  						&dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x60,
> +		if (last_fe->dvb.frontend) {
> +			if (dvb_attach(tda826x_attach, last_fe->dvb.frontend, 0x60,
>  					&dev->i2c_adap, 0) == NULL) {
>  				wprintk("%s: No tda826x found!\n", __func__);
>  				goto dettach_frontend;
>  			}
> -			if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
> +			if (dvb_attach(lnbp21_attach, last_fe->dvb.frontend,
>  					&dev->i2c_adap, 0, 0) == NULL) {
>  				wprintk("%s: No lnbp21 found!\n", __func__);
>  				goto dettach_frontend;
> @@ -1429,12 +1499,12 @@ static int dvb_init(struct saa7134_dev *
>  		}
>  		break;
>  	case SAA7134_BOARD_CREATIX_CTX953:
> -		if (configure_tda827x_fe(dev, &md8800_dvbt_config,
> +		if (configure_tda827x_fe(dev, last_fe, &md8800_dvbt_config,
>  					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_MSI_TVANYWHERE_AD11:
> -		if (configure_tda827x_fe(dev, &philips_tiger_s_config,
> +		if (configure_tda827x_fe(dev, last_fe, &philips_tiger_s_config,
>  					 &tda827x_cfg_2) < 0)
>  			goto dettach_frontend;
>  		break;
> @@ -1443,7 +1513,7 @@ static int dvb_init(struct saa7134_dev *
>  		saa7134_set_gpio(dev, 25, 0);
>  		msleep(10);
>  		saa7134_set_gpio(dev, 25, 1);
> -		fe0->dvb.frontend = dvb_attach(mt352_attach,
> +		last_fe->dvb.frontend = dvb_attach(mt352_attach,
>  						&avermedia_xc3028_mt352_dev,
>  						&dev->i2c_adap);
>  		attach_xc3028 = 1;
> @@ -1453,18 +1523,18 @@ static int dvb_init(struct saa7134_dev *
>  	case SAA7134_BOARD_VIDEOMATE_T750:
>  #endif
>  	case SAA7134_BOARD_MD7134_BRIDGE_2:
> -		fe0->dvb.frontend = dvb_attach(tda10086_attach,
> +		last_fe->dvb.frontend = dvb_attach(tda10086_attach,
>  						&sd1878_4m, &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> +		if (last_fe->dvb.frontend) {
>  			struct dvb_frontend *fe;
> -			if (dvb_attach(dvb_pll_attach, fe0->dvb.frontend, 0x60,
> +			if (dvb_attach(dvb_pll_attach, last_fe->dvb.frontend, 0x60,
>  				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL) {
>  				wprintk("%s: MD7134 DVB-S, no SD1878 "
>  					"found !\n", __func__);
>  				goto dettach_frontend;
>  			}
>  			/* we need to open the i2c gate (we know it exists) */
> -			fe = fe0->dvb.frontend;
> +			fe = last_fe->dvb.frontend;
>  			fe->ops.i2c_gate_ctrl(fe, 1);
>  			if (dvb_attach(isl6405_attach, fe,
>  					&dev->i2c_adap, 0x08, 0, 0) == NULL) {
> @@ -1483,67 +1553,70 @@ static int dvb_init(struct saa7134_dev *
>  		saa7134_set_gpio(dev, 25, 0);
>  		msleep(10);
>  		saa7134_set_gpio(dev, 25, 1);
> -		fe0->dvb.frontend = dvb_attach(mt352_attach,
> +		last_fe->dvb.frontend = dvb_attach(mt352_attach,
>  						&avermedia_xc3028_mt352_dev,
>  						&dev->i2c_adap);
>  		attach_xc3028 = 1;
>  		break;
>  	case SAA7134_BOARD_ASUSTeK_TIGER_3IN1:
> -		if (!use_frontend) {     /* terrestrial */
> -			if (configure_tda827x_fe(dev, &asus_tiger_3in1_config,
> -							&tda827x_cfg_2) < 0)
> +		/* terrestrial */
> +		fe = videobuf_dvb_get_frontend(&dev->frontends, 1);
> +		if (configure_tda827x_fe(dev, fe, &asus_tiger_3in1_config,
> +						&tda827x_cfg_2) < 0)
> +			goto dettach_frontend;
> +
> +		/* satellite */
> +		fe = videobuf_dvb_get_frontend(&dev->frontends, 2);
> +		fe->dvb.frontend = dvb_attach(tda10086_attach,
> +					&flydvbs, &dev->i2c_adap);
> +		if (fe->dvb.frontend) {
> +			fe->dvb.frontend->id = 1;
> +			if (dvb_attach(tda826x_attach,
> +					fe->dvb.frontend, 0x60,
> +					&dev->i2c_adap, 0) == NULL) {
> +				wprintk("%s: Asus Tiger 3in1, no "
> +					"tda826x found!\n", __func__);
> +				goto dettach_frontend;
> +			}
> +			if (dvb_attach(lnbp21_attach, fe->dvb.frontend,
> +					&dev->i2c_adap, 0, 0) == NULL) {
> +				wprintk("%s: Asus Tiger 3in1, no lnbp21"
> +					" found!\n", __func__);
>  				goto dettach_frontend;
> -		} else {  		/* satellite */
> -			fe0->dvb.frontend = dvb_attach(tda10086_attach,
> -						&flydvbs, &dev->i2c_adap);
> -			if (fe0->dvb.frontend) {
> -				if (dvb_attach(tda826x_attach,
> -						fe0->dvb.frontend, 0x60,
> -						&dev->i2c_adap, 0) == NULL) {
> -					wprintk("%s: Asus Tiger 3in1, no "
> -						"tda826x found!\n", __func__);
> -					goto dettach_frontend;
> -				}
> -				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
> -						&dev->i2c_adap, 0, 0) == NULL) {
> -					wprintk("%s: Asus Tiger 3in1, no lnbp21"
> -						" found!\n", __func__);
> -					goto dettach_frontend;
> -				}
>  			}
>  		}
>  		break;
>  	case SAA7134_BOARD_ASUSTeK_TIGER:
> -		if (configure_tda827x_fe(dev, &philips_tiger_config,
> +		if (configure_tda827x_fe(dev, last_fe, &philips_tiger_config,
>  					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_BEHOLD_H6:
> -		fe0->dvb.frontend = dvb_attach(zl10353_attach,
> +		last_fe->dvb.frontend = dvb_attach(zl10353_attach,
>  						&behold_h6_config,
>  						&dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend) {
> +			dvb_attach(simple_tuner_attach, last_fe->dvb.frontend,
>  				   &dev->i2c_adap, 0x61,
>  				   TUNER_PHILIPS_FMD1216MEX_MK3);
>  		}
>  		break;
>  	case SAA7134_BOARD_BEHOLD_X7:
> -		fe0->dvb.frontend = dvb_attach(zl10353_attach,
> +		last_fe->dvb.frontend = dvb_attach(zl10353_attach,
>  						&behold_x7_config,
>  						&dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			dvb_attach(xc5000_attach, fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend) {
> +			dvb_attach(xc5000_attach, last_fe->dvb.frontend,
>  				   &dev->i2c_adap, &behold_x7_tunerconfig);
>  		}
>  		break;
>  	case SAA7134_BOARD_AVERMEDIA_A700_PRO:
>  	case SAA7134_BOARD_AVERMEDIA_A700_HYBRID:
>  		/* Zarlink ZL10313 */
> -		fe0->dvb.frontend = dvb_attach(mt312_attach,
> +		last_fe->dvb.frontend = dvb_attach(mt312_attach,
>  			&avertv_a700_mt312, &dev->i2c_adap);
> -		if (fe0->dvb.frontend) {
> -			if (dvb_attach(zl10036_attach, fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend) {
> +			if (dvb_attach(zl10036_attach, last_fe->dvb.frontend,
>  					&avertv_a700_tuner, &dev->i2c_adap) == NULL) {
>  				wprintk("%s: No zl10036 found!\n",
>  					__func__);
> @@ -1551,37 +1624,37 @@ static int dvb_init(struct saa7134_dev *
>  		}
>  		break;
>  	case SAA7134_BOARD_VIDEOMATE_S350:
> -		fe0->dvb.frontend = dvb_attach(mt312_attach,
> +		last_fe->dvb.frontend = dvb_attach(mt312_attach,
>  				&zl10313_compro_s350_config, &dev->i2c_adap);
> -		if (fe0->dvb.frontend)
> -			if (dvb_attach(zl10039_attach, fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend)
> +			if (dvb_attach(zl10039_attach, last_fe->dvb.frontend,
>  					0x60, &dev->i2c_adap) == NULL)
>  				wprintk("%s: No zl10039 found!\n",
>  					__func__);
> 
>  		break;
>  	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
> -		fe0->dvb.frontend = dvb_attach(tda10048_attach,
> +		last_fe->dvb.frontend = dvb_attach(tda10048_attach,
>  					       &zolid_tda10048_config,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend != NULL) {
> -			dvb_attach(tda829x_attach, fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend != NULL) {
> +			dvb_attach(tda829x_attach, last_fe->dvb.frontend,
>  				   &dev->i2c_adap, 0x4b,
>  				   &tda829x_no_probe);
> -			dvb_attach(tda18271_attach, fe0->dvb.frontend,
> +			dvb_attach(tda18271_attach, last_fe->dvb.frontend,
>  				   0x60, &dev->i2c_adap,
>  				   &zolid_tda18271_config);
>  		}
>  		break;
>  	case SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S:
> -		fe0->dvb.frontend = dvb_attach(tda10048_attach,
> +		last_fe->dvb.frontend = dvb_attach(tda10048_attach,
>  					       &dtv1000s_tda10048_config,
>  					       &dev->i2c_adap);
> -		if (fe0->dvb.frontend != NULL) {
> -			dvb_attach(tda829x_attach, fe0->dvb.frontend,
> +		if (last_fe->dvb.frontend != NULL) {
> +			dvb_attach(tda829x_attach, last_fe->dvb.frontend,
>  				   &dev->i2c_adap, 0x4b,
>  				   &tda829x_no_probe);
> -			dvb_attach(tda18271_attach, fe0->dvb.frontend,
> +			dvb_attach(tda18271_attach, last_fe->dvb.frontend,
>  				   0x60, &dev->i2c_adap,
>  				   &dtv1000s_tda18271_config);
>  		}
> @@ -1598,10 +1671,10 @@ static int dvb_init(struct saa7134_dev *
>  			.i2c_addr  = 0x61,
>  		};
> 
> -		if (!fe0->dvb.frontend)
> +		if (!last_fe->dvb.frontend)
>  			goto dettach_frontend;
> 
> -		fe = dvb_attach(xc2028_attach, fe0->dvb.frontend, &cfg);
> +		fe = dvb_attach(xc2028_attach, last_fe->dvb.frontend, &cfg);
>  		if (!fe) {
>  			printk(KERN_ERR "%s/2: xc3028 attach failed\n",
>  			       dev->name);
> @@ -1609,27 +1682,40 @@ static int dvb_init(struct saa7134_dev *
>  		}
>  	}
> 
> -	if (NULL == fe0->dvb.frontend) {
> -		printk(KERN_ERR "%s/dvb: frontend initialization failed\n", dev->name);
> -		goto dettach_frontend;
> +	for (i = 1; i <= saa7134_boards[dev->board].num_frontends; i++) {
> +		fe = videobuf_dvb_get_frontend(&dev->frontends, i);
> +		if ((!fe) || (NULL == fe->dvb.frontend)){
> +			printk(KERN_ERR "%s/dvb: frontend %d initialization failed\n", dev->name, i);
> +			goto dettach_frontend;
> +		}
> +
> +		/* define general-purpose callback pointer */
> +		fe->dvb.frontend->callback = saa7134_tuner_callback;
> +
> +		/* override bus control */
> +		fe->dvb.frontend->ops.ts_bus_ctrl = saa7134_dvb_bus_ctrl;
>  	}
> -	/* define general-purpose callback pointer */
> -	fe0->dvb.frontend->callback = saa7134_tuner_callback;
> 
>  	/* register everything else */
>  	ret = videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
>  					&dev->pci->dev, adapter_nr, 0, NULL);
> +	if (ret) {
> +		printk(KERN_ERR "%s/dvb: register frontend(s) failed\n", dev->name);
> +		goto dettach_frontend;
> +	}
> 
> -	/* this sequence is necessary to make the tda1004x load its firmware
> -	 * and to enter analog mode of hybrid boards
> -	 */
> -	if (!ret) {
> -		if (fe0->dvb.frontend->ops.init)
> -			fe0->dvb.frontend->ops.init(fe0->dvb.frontend);
> -		if (fe0->dvb.frontend->ops.sleep)
> -			fe0->dvb.frontend->ops.sleep(fe0->dvb.frontend);
> -		if (fe0->dvb.frontend->ops.tuner_ops.sleep)
> -			fe0->dvb.frontend->ops.tuner_ops.sleep(fe0->dvb.frontend);
> +	for (i = 1; i <= saa7134_boards[dev->board].num_frontends; i++) {
> +		fe = videobuf_dvb_get_frontend(&dev->frontends, i);
> +
> +		/* this sequence is necessary to make the tda1004x load its firmware
> +		* and to enter analog mode of hybrid boards
> +		*/
> +		if (fe->dvb.frontend->ops.init)
> +			fe->dvb.frontend->ops.init(fe->dvb.frontend);
> +		if (fe->dvb.frontend->ops.sleep)
> +			fe->dvb.frontend->ops.sleep(fe->dvb.frontend);
> +		if (fe->dvb.frontend->ops.tuner_ops.sleep)
> +			fe->dvb.frontend->ops.tuner_ops.sleep(fe->dvb.frontend);
>  	}
>  	return ret;
> 
> @@ -1640,37 +1726,41 @@ dettach_frontend:
> 
>  static int dvb_fini(struct saa7134_dev *dev)
>  {
> -	struct videobuf_dvb_frontend *fe0;
> -
> -	/* Get the first frontend */
> -	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
> -	if (!fe0)
> -		return -EINVAL;
> +	int i;
> +	struct videobuf_dvb_frontend *fe;
> 
> -	/* FIXME: I suspect that this code is bogus, since the entry for
> -	   Pinnacle 300I DVB-T PAL already defines the proper init to allow
> -	   the detection of mt2032 (TDA9887_PORT2_INACTIVE)
> -	 */
> -	if (dev->board == SAA7134_BOARD_PINNACLE_300I_DVBT_PAL) {
> -		struct v4l2_priv_tun_config tda9887_cfg;
> -		static int on  = TDA9887_PRESENT | TDA9887_PORT2_INACTIVE;
> -
> -		tda9887_cfg.tuner = TUNER_TDA9887;
> -		tda9887_cfg.priv  = &on;
> -
> -		/* otherwise we don't detect the tuner on next insmod */
> -		saa_call_all(dev, tuner, s_config, &tda9887_cfg);
> -	} else if (dev->board == SAA7134_BOARD_MEDION_MD8800_QUADRO) {
> -		if ((dev->eedata[2] == 0x07) && use_frontend) {
> -			/* turn off the 2nd lnb supply */
> -			u8 data = 0x80;
> -			struct i2c_msg msg = {.addr = 0x08, .buf = &data, .flags = 0, .len = 1};
> -			struct dvb_frontend *fe;
> -			fe = fe0->dvb.frontend;
> -			if (fe->ops.i2c_gate_ctrl) {
> -				fe->ops.i2c_gate_ctrl(fe, 1);
> -				i2c_transfer(&dev->i2c_adap, &msg, 1);
> -				fe->ops.i2c_gate_ctrl(fe, 0);
> +	for (i = 1; i <= saa7134_boards[dev->board].num_frontends; i++) {
> +		fe = videobuf_dvb_get_frontend(&dev->frontends, i);
> +		if (!fe){
> +			printk(KERN_ERR "%s() failed to get frontend(%d)\n", __func__, i);
> +			continue;
> +		}
> +
> +		/* FIXME: I suspect that this code is bogus, since the entry for
> +		Pinnacle 300I DVB-T PAL already defines the proper init to allow
> +		the detection of mt2032 (TDA9887_PORT2_INACTIVE)
> +		*/
> +		if (dev->board == SAA7134_BOARD_PINNACLE_300I_DVBT_PAL) {
> +			struct v4l2_priv_tun_config tda9887_cfg;
> +			static int on  = TDA9887_PRESENT | TDA9887_PORT2_INACTIVE;
> +
> +			tda9887_cfg.tuner = TUNER_TDA9887;
> +			tda9887_cfg.priv  = &on;
> +
> +			/* otherwise we don't detect the tuner on next insmod */
> +			saa_call_all(dev, tuner, s_config, &tda9887_cfg);
> +		} else if (dev->board == SAA7134_BOARD_MEDION_MD8800_QUADRO) {
> +			if ((dev->eedata[2] == 0x07) && (fe->id == 2)) {
> +				/* turn off the 2nd lnb supply */
> +				u8 data = 0x80;
> +				struct i2c_msg msg = {.addr = 0x08, .buf = &data, .flags = 0, .len = 1};
> +				struct dvb_frontend *dvb_fe;
> +				dvb_fe = fe->dvb.frontend;
> +				if (dvb_fe->ops.i2c_gate_ctrl) {
> +					dvb_fe->ops.i2c_gate_ctrl(dvb_fe, 1);
> +					i2c_transfer(&dev->i2c_adap, &msg, 1);
> +					dvb_fe->ops.i2c_gate_ctrl(dvb_fe, 0);
> +				}
>  			}
>  		}
>  	}
> diff -uprN linux-a76d06e9ff9b/drivers/media/video/saa7134/saa7134.h linux/drivers/media/video/saa7134/saa7134.h
> --- linux-a76d06e9ff9b/drivers/media/video/saa7134/saa7134.h	2009-10-31 10:40:46.000000000 +0100
> +++ linux/drivers/media/video/saa7134/saa7134.h	2009-10-31 17:22:48.000000000 +0100
> @@ -359,6 +359,7 @@ struct saa7134_board {
>  	unsigned int            tuner_config;
> 
>  	/* peripheral I/O */
> +	unsigned char 		num_frontends;
>  	enum saa7134_video_out  video_out;
>  	enum saa7134_mpeg_type  mpeg;
>  	enum saa7134_mpeg_ts_type ts_type;

