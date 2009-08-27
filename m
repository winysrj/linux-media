Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:46404 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbZH0Xdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 19:33:43 -0400
Subject: Re: [PATCH] Add support for RoverMedia TV Link Pro FM v2
From: hermann pitton <hermann-pitton@arcor.de>
To: Eugene Yudin <eugene.yudin@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200908280059.03966.Eugene.Yudin@gmail.com>
References: <200908272104.59221.Eugene.Yudin@gmail.com>
	 <200908280059.03966.Eugene.Yudin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 28 Aug 2009 01:24:28 +0200
Message-Id: <1251415468.3742.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eugene,

Am Freitag, den 28.08.2009, 00:59 +0400 schrieb Eugene Yudin:
> В сообщении от Четверг 27 августа 2009 21:04:59 автор Eugene Yudin написал:
> > Hello.
> > This patch add support for RoverMedia TV Link Pro FM card based on saa7134.
> >...
> 
> Sorry, I forgot some things. All is working now.
> This patch add support for RoverMedia TV Link Pro FM card based on saa7134.

I bet you are still struggling with the tuner.

The FMD1216ME MK3, which has also support for digital TV, is very
unlikely to be found on such a device.

Most likely you have one of the current tuner=38 TCL MK3 clones sitting
on it.

Compared to the original tuner and the known clones, the FMD will have
missing channels and a grainy picture on very low VHF channels. Since
you don't have such an FMD, likely you can't realize that.

I suggest to start with tuner=38, enable debug=2 for tda9887 and switch
between 2 or three channels and try also the radio mode. Is a tda9887
active?

It is important to know, if this could be really some ME (MultiEurope).
Only then I would see an good argument to eventually duplicate all the 
code for a new card entry. The other tuner mess is since ever and
RoverMedia seems to produce a lot of clones, like so many others since
2002. Else only auto detect it and use FV3K entry for it.

Is "four in one" checked on the tuner's sticker?

Cheers,
Hermann


> Signed-off-by: Eugene Yudin <Eugene.Yudin@gmail.com>
> Best Regards, Eugene.
> 
> diff -uprN a/linux/Documentation/video4linux/CARDLIST.saa7134 
> b/linux/Documentation/video4linux/CARDLIST.saa7134
> --- a/linux/Documentation/video4linux/CARDLIST.saa7134	2009-08-26 
> 12:07:09.000000000 +0400
> +++ b/linux/Documentation/video4linux/CARDLIST.saa7134	2009-08-27 
> 20:59:24.946147754 +0400
> @@ -168,3 +168,4 @@
>  167 -> Beholder BeholdTV 609 RDS                [5ace:6092]
>  168 -> Beholder BeholdTV 609 RDS                [5ace:6093]
>  169 -> Compro VideoMate S350/S300               [185b:c900]
> +170 -> RoverMedia TV Link Pro FM                [19d1:0138]
> diff -uprN a/linux/drivers/media/video/saa7134/saa7134-cards.c 
> b/linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-08-27 
> 20:27:10.000000000 +0400
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-08-28 
> 00:57:15.190205787 +0400
> @@ -5182,6 +5182,56 @@ struct saa7134_board saa7134_boards[] = 
>  			.amux	= LINE1
>  		} },
>  	},
> +	[SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM] = {
> +		/* Eugene Yudin <Eugene.Yudin@gmail.com> */
> +		.name		= "RoverMedia TV Link Pro FM",
> +		.audio_clock	= 0x00200000,
> +		.tuner_type	= TUNER_PHILIPS_FMD1216ME_MK3,
> +		.radio_type     = UNSET,
> +		.tuner_addr	= ADDR_UNSET,
> +		.radio_addr	= ADDR_UNSET,
> +		.tda9887_conf   = TDA9887_PRESENT,
> +
> +		.gpiomask       = 0xe000,
> +		.inputs         = {{
> +			.name = name_tv,
> +			.vmux = 1,
> +			.amux = TV,
> +			.gpio = 0x8000,
> +			.tv   = 1,
> +		},{
> +			.name = name_tv_mono,
> +			.vmux = 1,
> +			.amux = LINE2,
> +			.gpio = 0x0000,
> +			.tv   = 1,
> +		},{
> +			.name = name_comp1,
> +			.vmux = 0,
> +			.amux = LINE2,
> +			.gpio = 0x4000,
> +		},{
> +			.name = name_comp2,
> +			.vmux = 3,
> +			.amux = LINE2,
> +			.gpio = 0x4000,
> +		},{
> +			.name = name_svideo,
> +			.vmux = 8,
> +			.amux = LINE2,
> +			.gpio = 0x4000,
> +		}},
> +		.radio = {
> +			.name = name_radio,
> +			.amux = LINE2,
> +			.gpio = 0x2000,
> +		},
> +		.mute = {
> +			.name = name_mute,
> +			.amux = TV,
> +			.gpio = 0x8000,
> +		},
> +	},
>  };
>  
>  const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
> @@ -6296,6 +6346,12 @@ struct pci_device_id saa7134_pci_tbl[] =
>  		.subdevice    = 0xc900,
>  		.driver_data  = SAA7134_BOARD_VIDEOMATE_S350,
>  	}, {
> +		.vendor       = PCI_VENDOR_ID_PHILIPS,
> +		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> +		.subvendor    = 0x19d1, /* RoverMedia */
> +		.subdevice    = 0x0138, /* LifeView FlyTV Prime30 OEM */
> +		.driver_data  = SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM,
> +	}, {
>  		/* --- boards without eeprom + subsystem ID --- */
>  		.vendor       = PCI_VENDOR_ID_PHILIPS,
>  		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> @@ -6656,6 +6712,7 @@ int saa7134_board_init1(struct saa7134_d
>  	case SAA7134_BOARD_REAL_ANGEL_220:
>  	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
>  	case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
> +	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
>  		dev->has_remote = SAA7134_REMOTE_GPIO;
>  		break;
>  	case SAA7134_BOARD_FLYDVBS_LR300:
> diff -uprN a/linux/drivers/media/video/saa7134/saa7134-input.c 
> b/linux/drivers/media/video/saa7134/saa7134-input.c
> --- a/linux/drivers/media/video/saa7134/saa7134-input.c	2009-08-26 
> 12:07:11.000000000 +0400
> +++ b/linux/drivers/media/video/saa7134/saa7134-input.c	2009-08-27 
> 19:49:42.000000000 +0400
> @@ -456,6 +456,7 @@ int saa7134_input_init1(struct saa7134_d
>  	case SAA7134_BOARD_FLYVIDEO3000:
>  	case SAA7134_BOARD_FLYTVPLATINUM_FM:
>  	case SAA7134_BOARD_FLYTVPLATINUM_MINI2:
> +	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
>  		ir_codes     = ir_codes_flyvideo;
>  		mask_keycode = 0xEC00000;
>  		mask_keydown = 0x0040000;
> diff -uprN a/linux/drivers/media/video/saa7134/saa7134.h 
> b/linux/drivers/media/video/saa7134/saa7134.h
> --- a/linux/drivers/media/video/saa7134/saa7134.h	2009-08-26 
> 12:07:11.000000000 +0400
> +++ b/linux/drivers/media/video/saa7134/saa7134.h	2009-08-27 
> 19:50:41.000000000 +0400
> @@ -294,6 +294,7 @@ struct saa7134_format {
>  #define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
>  #define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
>  #define SAA7134_BOARD_VIDEOMATE_S350        169
> +#define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM     170
>  
>  #define SAA7134_MAXBOARDS 32
>  #define SAA7134_INPUT_MAX 8
> 
> 


