Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:61156 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab0CUOVl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Mar 2010 10:21:41 -0400
Received: by fxm21 with SMTP id 21so987220fxm.2
        for <linux-media@vger.kernel.org>; Sun, 21 Mar 2010 07:21:39 -0700 (PDT)
Subject: Re: [PATCH] saa7134: add capture boards Hawell HW-404M7 and
 HW-808M7
From: Vladimir Ermakov <vooon341@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1269134920.3222.3.camel@pc07.localdom.local>
References: <1268235897.25823.31.camel@desinto.vehq>
	 <1268954515.24551.15.camel@pc07.localdom.local>
	 <1269097100.17096.12.camel@desinto.vehq>
	 <1269134920.3222.3.camel@pc07.localdom.local>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Mar 2010 17:14:36 +0300
Message-ID: <1269180876.4408.6.camel@desinto.vehq>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann.

Sorry, i forgot it.
Resend patch with SOB.

Signed-off-by: Vladimir Ermakov <vooon341@gmail.com>

# HG changeset patch
# User Vladimir Ermakov <vooon341@gmail.com>
# Date 1269096094 -10800
# Node ID a91db2cf4f5774866c8c5bf906d9ac4faff9173d
# Parent  929298149eba4b6d0696124b9880113c25cd0788
saa7134: fix GPIO HW-404M7

diff -r 929298149eba -r a91db2cf4f57 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Mar 18 23:47:27 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Mar 20 17:41:34 2010 +0300
@@ -5403,12 +5403,12 @@
 		.radio_type    = UNSET,
 		.tuner_addr   = ADDR_UNSET,
 		.radio_addr   = ADDR_UNSET,
-		.gpiomask      = 0x01fc00,
+		.gpiomask      = 0x389c00,
 		.inputs       = {{
 			.name = name_comp1,
 			.vmux = 3,
 			.amux = LINE1,
-			.gpio = 0x389c00,
+			.gpio = 0x01fc00,
 		} },
 	},
 
diff -r 929298149eba -r a91db2cf4f57 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Thu Mar 18 23:47:27 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Sat Mar 20 17:41:34 2010 +0300
@@ -531,7 +531,6 @@
 	switch (dev->board) {
 	case SAA7134_BOARD_FLYVIDEO2000:
 	case SAA7134_BOARD_FLYVIDEO3000:
-	case SAA7134_BOARD_HAWELL_HW_404M7:
 	case SAA7134_BOARD_FLYTVPLATINUM_FM:
 	case SAA7134_BOARD_FLYTVPLATINUM_MINI2:
 	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:


В Вск, 21/03/2010 в 02:28 +0100, hermann pitton пишет:
> Hi Vladimir,
> 
> Am Samstag, den 20.03.2010, 17:58 +0300 schrieb Vladimir Ermakov:
> > Hi Hermann.
> > 
> > 1. It's my mistake. Fixed.
> > 2. Dead code. Removed.
> 
> thanks for looking at it.
> 
> We likely need your SOB line again, since it is a new patch.
> 
> Here is my
> 
> Reviewed-by: hermann pitton <hermann-pitton@arcor.de>
> 
> Cheers,
> Hermann
> 
> > # HG changeset patch
> > # User Vladimir Ermakov <vooon341@gmail.com>
> > # Date 1269096094 -10800
> > # Node ID a91db2cf4f5774866c8c5bf906d9ac4faff9173d
> > # Parent  929298149eba4b6d0696124b9880113c25cd0788
> > saa7134: fix GPIO HW-404M7
> > 
> > diff -r 929298149eba -r a91db2cf4f57 linux/drivers/media/video/saa7134/saa7134-cards.c
> > --- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Mar 18 23:47:27 2010 -0300
> > +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Mar 20 17:41:34 2010 +0300
> > @@ -5403,12 +5403,12 @@
> >  		.radio_type    = UNSET,
> >  		.tuner_addr   = ADDR_UNSET,
> >  		.radio_addr   = ADDR_UNSET,
> > -		.gpiomask      = 0x01fc00,
> > +		.gpiomask      = 0x389c00,
> >  		.inputs       = {{
> >  			.name = name_comp1,
> >  			.vmux = 3,
> >  			.amux = LINE1,
> > -			.gpio = 0x389c00,
> > +			.gpio = 0x01fc00,
> >  		} },
> >  	},
> >  
> > diff -r 929298149eba -r a91db2cf4f57 linux/drivers/media/video/saa7134/saa7134-input.c
> > --- a/linux/drivers/media/video/saa7134/saa7134-input.c	Thu Mar 18 23:47:27 2010 -0300
> > +++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Sat Mar 20 17:41:34 2010 +0300
> > @@ -531,7 +531,6 @@
> >  	switch (dev->board) {
> >  	case SAA7134_BOARD_FLYVIDEO2000:
> >  	case SAA7134_BOARD_FLYVIDEO3000:
> > -	case SAA7134_BOARD_HAWELL_HW_404M7:
> >  	case SAA7134_BOARD_FLYTVPLATINUM_FM:
> >  	case SAA7134_BOARD_FLYTVPLATINUM_MINI2:
> >  	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
> > 
> > 
> > В Птн, 19/03/2010 в 00:21 +0100, hermann pitton пишет:
> > > Hi Vladimir,
> > > 
> > > thanks, your patch is already accepted, but if have a two comments.
> > > 
> > > Am Mittwoch, den 10.03.2010, 18:44 +0300 schrieb Vladimir Ermakov:
> > >> This patch adds new capture boards Hawell HW-404M7 and HW-808M7.
> > >> Those cards have 4 or 8 SAA7130 chips and for the work it only needs initialize registers.
> > >> The value of those registers were dumped under Windows using flytest.
> > >> But board haven't EEPROM.
> > >> 
> > >> For the first chip:
> > >> 
> > >>  SAA7130 (0x7130, SubVenID:1131, SubDevID:0000, Rev: 01)
> > >> 
> > >>  I2C slave devices found:
> > >>  No devices
> > >> 
> > >>  GPIO pins:
> > >>  Mode : 0x00389C00
> > >>  Value: 0x00016C00
> > >
> > > Later in the code you swapped mode (gpio mask) and value (out status).
> > >
> > > This does not cause a functional problem in this case, but is visible
> > > for example with saa7134 gpio_tracking=1.
> > >
> > > Second, you did add the card to the flyvideo remotes in saa7134-input,
> > > but this is only a line of dead code currently.
> > >
> > > If it really has such a remote, you must also add the card to the switch
> > > case dev->has_remote = SAA7134_REMOTE_GPIO in in the function
> > > int saa7134_board_init1 in saa7134-cards.c or please remove it from
> > > saa7134-input.c.
> > >
> > > Thanks,
> > > Hermann
> > >
> > >>  Video input: 3
> > >>  Audio input: Analog Line1
> > >> 
> > >> For other chips:
> > >> 
> > >>  SAA7130 (0x7130, SubVenID:1131, SubDevID:0000, Rev: 01)
> > >> 
> > >>  I2C slave devices found:
> > >>  No devices
> > >> 
> > >>  GPIO pins:
> > >>  Mode : 0x00389200
> > >>  Value: 0x00010000
> > >> 
> > >>  Video input: 3
> > >>  Audio input: Analog Line1
> > >> 
> > >> Signed-off-by: Vladimir Ermakov <vooon341@gmail.com>
> > >> 
> > >> # HG changeset patch
> > >> # User Vladimir Ermakov <vooon341@gmail.com>
> > >> # Date 1268232221 -10800
> > >> # Node ID 072cd67c6aabe0e700a9e4727b50ad6424cb59f5
> > >> # Parent  7a58d924fb049ff1d318514939b3a7e416670c13
> > >> saa7134: add Hawell HW-404M7 & HW-808M7
> > >> 
> > >> diff -r 7a58d924fb04 -r 072cd67c6aab linux/Documentation/video4linux/CARDLIST.saa7134
> > >> --- a/linux/Documentation/video4linux/CARDLIST.saa7134	Tue Mar 09 23:00:59 2010 -0300
> > >> +++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Wed Mar 10 17:43:41 2010 +0300
> > >> @@ -175,3 +175,4 @@
> > >>  174 -> Asus Europa Hybrid OEM                   [1043:4847]
> > >>  175 -> Leadtek Winfast DTV1000S                 [107d:6655]
> > >>  176 -> Beholder BeholdTV 505 RDS                [0000:5051]
> > >> +177 -> Hawell HW-404M7 / HW-808M7
> > >> diff -r 7a58d924fb04 -r 072cd67c6aab linux/drivers/media/video/saa7134/saa7134-cards.c
> > >> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Mar 09 23:00:59 2010 -0300
> > >> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Mar 10 17:43:41 2010 +0300
> > >> @@ -5394,6 +5394,23 @@
> > >>  			.amux = LINE2,
> > >>  		},
> > >>  	},
> > >> +	[SAA7134_BOARD_HAWELL_HW_404M7] = {
> > >> +		/* Hawell HW-404M7 & Hawell HW-808M7  */
> > >> +		/* Bogoslovskiy Viktor <bogovic@bk.ru> */
> > >> +		.name         = "Hawell HW-404M7",
> > >> +		.audio_clock   = 0x00200000,
> > >> +		.tuner_type    = UNSET,
> > >> +		.radio_type    = UNSET,
> > >> +		.tuner_addr   = ADDR_UNSET,
> > >> +		.radio_addr   = ADDR_UNSET,
> > >> +		.gpiomask      = 0x01fc00,
> > >> +		.inputs       = {{
> > >> +			.name = name_comp1,
> > >> +			.vmux = 3,
> > >> +			.amux = LINE1,
> > >> +			.gpio = 0x389c00,
> > >> +		} },
> > >> +	},
> > >>  
> > >>  };
> > >>  
> > >> diff -r 7a58d924fb04 -r 072cd67c6aab linux/drivers/media/video/saa7134/saa7134-input.c
> > >> --- a/linux/drivers/media/video/saa7134/saa7134-input.c	Tue Mar 09 23:00:59 2010 -0300
> > >> +++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Wed Mar 10 17:43:41 2010 +0300
> > >> @@ -529,6 +529,7 @@
> > >>  	switch (dev->board) {
> > >>  	case SAA7134_BOARD_FLYVIDEO2000:
> > >>  	case SAA7134_BOARD_FLYVIDEO3000:
> > >> +	case SAA7134_BOARD_HAWELL_HW_404M7:
> > >>  	case SAA7134_BOARD_FLYTVPLATINUM_FM:
> > >>  	case SAA7134_BOARD_FLYTVPLATINUM_MINI2:
> > >>  	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
> > >> diff -r 7a58d924fb04 -r 072cd67c6aab linux/drivers/media/video/saa7134/saa7134.h
> > >> --- a/linux/drivers/media/video/saa7134/saa7134.h	Tue Mar 09 23:00:59 2010 -0300
> > >> +++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed Mar 10 17:43:41 2010 +0300
> > >> @@ -301,6 +301,7 @@
> > >>  #define SAA7134_BOARD_ASUS_EUROPA_HYBRID	174
> > >>  #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
> > >>  #define SAA7134_BOARD_BEHOLD_505RDS_MK3     176
> > >> +#define SAA7134_BOARD_HAWELL_HW_404M7		177
> > >>  
> > >>  #define SAA7134_MAXBOARDS 32
> > >>  #define SAA7134_INPUT_MAX 8
> > >>
> > 
> 


