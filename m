Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:33952 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbZIUBWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 21:22:05 -0400
Subject: Re: [PATCH] Add support for Asus Europa Hybrid DVB-T card (SAA7134
	SubVendor ID: 0x1043 Device ID: 0x4847)
From: hermann pitton <hermann-pitton@arcor.de>
To: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1253491552.27219.6.camel@AcerAspire4710>
References: <4AB646CD.3030909@gmail.com>
	 <1253491552.27219.6.camel@AcerAspire4710>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Sep 2009 03:08:57 +0200
Message-Id: <1253495337.3257.3.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pham,

Am Montag, den 21.09.2009, 07:05 +0700 schrieb Pham Thanh Nam:
> Hi, Danny
> Please add an entry in:
> linux/Documentation/video4linux/CARDLIST.saa7134
> Regards.

that is not so important.

It will be auto magically created by scripts, if Mauro pulls it in.

Cheers,
Hermann 

> Vào CN, ngày 20, 09 năm 2009 lúc 16:14 +0100, Danny Wood viết:
> > Adds the device IDs and driver linking to allow the Asus Europa DVB-T
> > card to operate with these drivers.
> > The device has a SAA7134 chipset with a TD1316 Hybrid Tuner.
> > All inputs work on the card including switching between DVB-T and
> > Analogue TV, there is also no IR with this card.
> > 
> > (Resent with fixed email formatting)
> > 
> > Signed-off-by: Danny Wood <danwood76@gmail.com>
> > diff -ruN a/linux/drivers/media/video/saa7134/saa7134-cards.c b/linux/drivers/media/video/saa7134/saa7134-cards.c
> > --- a/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-09-20 09:10:03.000000000 +0100
> > +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-09-20 09:07:21.000000000 +0100
> > @@ -5317,6 +5317,30 @@
> >  			.amux = TV,
> >  		},
> >  	},
> > +	[SAA7134_BOARD_ASUS_EUROPA_HYBRID] = {
> > +		.name           = "Asus Europa Hybrid OEM",
> > +		.audio_clock    = 0x00187de7,
> > +		.tuner_type     = TUNER_PHILIPS_TD1316,
> > +		.radio_type     = UNSET,
> > +		.tuner_addr	= 0x61,
> > +		.radio_addr	= ADDR_UNSET,
> > +		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
> > +		.mpeg           = SAA7134_MPEG_DVB,
> > +		.inputs = {{
> > +			.name   = name_tv,
> > +			.vmux   = 3,
> > +			.amux   = TV,
> > +			.tv     = 1,
> > +		},{
> > +			.name   = name_comp1,
> > +			.vmux   = 4,
> > +			.amux   = LINE2,
> > +		},{
> > +			.name   = name_svideo,
> > +			.vmux   = 8,
> > +			.amux   = LINE2,
> > +		}},
> > +	},
> >  
> >  };
> >  
> > @@ -6455,6 +6479,12 @@
> >  		.subvendor    = PCI_VENDOR_ID_PHILIPS,
> >  		.subdevice    = 0x2004,
> >  		.driver_data  = SAA7134_BOARD_ZOLID_HYBRID_PCI,
> > +	},{
> > +		.vendor       = PCI_VENDOR_ID_PHILIPS,
> > +		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> > +		.subvendor    = 0x1043,
> > +		.subdevice    = 0x4847,
> > +		.driver_data  = SAA7134_BOARD_ASUS_EUROPA_HYBRID,
> >  	}, {
> >  		/* --- boards without eeprom + subsystem ID --- */
> >  		.vendor       = PCI_VENDOR_ID_PHILIPS,
> > @@ -7162,6 +7192,7 @@
> >  		/* break intentionally omitted */
> >  	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
> >  	case SAA7134_BOARD_ASUS_EUROPA2_HYBRID:
> > +	case SAA7134_BOARD_ASUS_EUROPA_HYBRID:
> >  	{
> >  
> >  		/* The Philips EUROPA based hybrid boards have the tuner
> > diff -ruN a/linux/drivers/media/video/saa7134/saa7134-dvb.c b/linux/drivers/media/video/saa7134/saa7134-dvb.c
> > --- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	2009-09-20 09:10:03.000000000 +0100
> > +++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	2009-09-20 08:58:51.000000000 +0100
> > @@ -1116,6 +1116,7 @@
> >  		break;
> >  	case SAA7134_BOARD_PHILIPS_EUROPA:
> >  	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
> > +	case SAA7134_BOARD_ASUS_EUROPA_HYBRID:
> >  		fe0->dvb.frontend = dvb_attach(tda10046_attach,
> >  					       &philips_europa_config,
> >  					       &dev->i2c_adap);
> > diff -ruN a/linux/drivers/media/video/saa7134/saa7134.h b/linux/drivers/media/video/saa7134/saa7134.h
> > --- a/linux/drivers/media/video/saa7134/saa7134.h	2009-09-20 09:10:03.000000000 +0100
> > +++ b/linux/drivers/media/video/saa7134/saa7134.h	2009-09-20 09:08:15.000000000 +0100
> > @@ -298,6 +298,7 @@
> >  #define SAA7134_BOARD_BEHOLD_X7             171
> >  #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 172
> >  #define SAA7134_BOARD_ZOLID_HYBRID_PCI		173
> > +#define SAA7134_BOARD_ASUS_EUROPA_HYBRID	174
> >  
> >  #define SAA7134_MAXBOARDS 32
> >  #define SAA7134_INPUT_MAX 8
> > 


