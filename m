Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:39737 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716Ab0E1BK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 21:10:59 -0400
Subject: Re: [PATCH] Compro videomate T750F DVB-T mode works now
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Emard <davoremard@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <20100527141704.46d95f54@pedra>
References: <20100507235024.GA7470@z60m>  <20100527141704.46d95f54@pedra>
Content-Type: text/plain
Date: Fri, 28 May 2010 03:11:27 +0200
Message-Id: <1275009087.7294.2.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Donnerstag, den 27.05.2010, 14:17 -0300 schrieb Mauro Carvalho
Chehab:
> Em Sat, 8 May 2010 01:50:24 +0200
> Emard <davoremard@gmail.com> escreveu:
> 
> > HI
> > 
> > ... tried to post this few times to thhis list I don't know if
> > it has made it maybe this time it will appear on the mailing list....
> > 
> > I have european version of Compro Videomate T750F Vista
> > hybrid dvb-t + tv (PAL) + FM card. In kernels up to date (2.6.33.3)
> > it didn't want to initialize in analog mode (tuner xc2028 always failed).
> > 
> > Here's sligthly adapted patch from
> > http://www.linuxtv.org/pipermail/linux-dvb/2008-May/025945.html
> > that works for me. It disables analog tuner xc2028 which doesn't
> > work (maybe because current driver is only for ntsc version of the
> > card) and enables digital tuner that consists of zarlink 10353 and
> > qt1010. Tested and works on kernel 2.6.33.3
> 
> xc2028 tuner driver supports PAL standards as well. If it is not working fine,
> it is probably because the GPIO's are wrong. You need to run REGSPY.EXE program,
> from DScaler project, to get the proper gpio values for your board.
> 
> Btw, please send your Signed-off-by: on your patches.
> > 
> > Best regards, Emard
> > 
> > --- linux-2.6.33.3/drivers/media/video/saa7134/saa7134-cards.c.orig	2010-05-02 00:06:45.000000000 +0200
> > +++ linux-2.6.33.3/drivers/media/video/saa7134/saa7134-cards.c	2010-05-02 01:20:50.000000000 +0200
> > @@ -4883,10 +4883,11 @@ struct saa7134_board saa7134_boards[] =
> >  		/* John Newbigin <jn@it.swin.edu.au> */
> >  		.name           = "Compro VideoMate T750",
> >  		.audio_clock    = 0x00187de7,
> > -		.tuner_type     = TUNER_XC2028,
> > +		.tuner_type     = TUNER_ABSENT,
> 
> Instead of touching at the existing entry, you should be adding a new one, with
> your board specifics, otherwise your patch would break support for the other
> board variant.
> 
> >  		.radio_type     = UNSET,
> >  		.tuner_addr	= ADDR_UNSET,
> >  		.radio_addr	= ADDR_UNSET,
> > +		.mpeg           = SAA7134_MPEG_DVB,
> >  		.inputs = {{
> >  			.name   = name_tv,
> >  			.vmux   = 3,
> > @@ -7192,6 +7193,7 @@ int saa7134_board_init2(struct saa7134_d
> >  	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
> >  	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
> >  	case SAA7134_BOARD_CREATIX_CTX953:
> > +        case SAA7134_BOARD_VIDEOMATE_T750:
> >  	{
> >  		/* this is a hybrid board, initialize to analog mode
> >  		 * and configure firmware eeprom address
> > --- linux-2.6.33.3/drivers/media/video/saa7134/saa7134-dvb.c.orig	2010-05-01 23:57:08.000000000 +0200
> > +++ linux-2.6.33.3/drivers/media/video/saa7134/saa7134-dvb.c	2010-05-02 00:51:44.000000000 +0200
> > @@ -55,6 +55,7 @@
> >  #include "tda8290.h"
> >  
> >  #include "zl10353.h"
> > +#include "qt1010.h"
> >  
> >  #include "zl10036.h"
> >  #include "zl10039.h"
> > @@ -886,6 +887,17 @@ static struct zl10353_config behold_x7_c
> >  	.disable_i2c_gate_ctrl = 1,
> >  };
> >  
> > +static struct zl10353_config videomate_t750_zl10353_config = {
> > +       .demod_address  = 0x0f,
> > +       .no_tuner = 1,
> > +       .parallel_ts = 1,
> > +};
> > +
> > +static struct qt1010_config videomate_t750_qt1010_config = {
> > +       .i2c_address = 0x62
> > +};
> > +
> > +
> >  /* ==================================================================
> >   * tda10086 based DVB-S cards, helper functions
> >   */
> > @@ -1556,6 +1568,26 @@ static int dvb_init(struct saa7134_dev *
> >  					__func__);
> >  
> >  		break;
> > +        /*FIXME: What frontend does Videomate T750 use? */
> > +        case SAA7134_BOARD_VIDEOMATE_T750:
> > +                printk("Compro VideoMate T750 DVB setup\n");
> > +                fe0->dvb.frontend = dvb_attach(zl10353_attach,
> > +                                                &videomate_t750_zl10353_config,
> > +                                                &dev->i2c_adap);
> > +                if (fe0->dvb.frontend != NULL) {
> > +                        printk("Attaching pll\n");
> > +                        // if there is a gate function then the i2c bus breaks.....!
> > +                        fe0->dvb.frontend->ops.i2c_gate_ctrl = 0;
> > + 
> > +                        if (dvb_attach(qt1010_attach,
> > +                                       fe0->dvb.frontend,
> > +                                       &dev->i2c_adap,
> > +                                       &videomate_t750_qt1010_config) == NULL)
> > +                        {
> > +                                wprintk("error attaching QT1010\n");
> > +                        }
> > +                }
> > +                break;
> >  	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
> >  		fe0->dvb.frontend = dvb_attach(tda10048_attach,
> >  					       &zolid_tda10048_config,

just for reference, here is a link about what we tried last summer.

The followups do have also some regspy logs.

http://www.mail-archive.com/linux-media@vger.kernel.org/msg07478.html

Cheers,
Hermann


