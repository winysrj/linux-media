Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:38258 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756825AbZJ2XkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 19:40:14 -0400
Subject: Re: [PATCH video4linux] For STLabs PCI saa7134 analog receiver card
From: hermann pitton <hermann-pitton@arcor.de>
To: flinkdeldinky <flinkdeldinky@gmail.com>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <200910292307.28202.flinkdeldinky@gmail.com>
References: <200910292307.28202.flinkdeldinky@gmail.com>
Content-Type: text/plain
Date: Fri, 30 Oct 2009 00:38:59 +0100
Message-Id: <1256859539.3270.23.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

Am Donnerstag, den 29.10.2009, 23:07 +0700 schrieb flinkdeldinky:
> The following patch provides functionality for the STLabs PCI TV receiver card. It only adds some information to saa7134.h and saa7134-cards.c
> 
> The card is auto detected as a 10 MOONS card but that will not work.

I still can't see how your card could make it in that way and how Mauro
could make a decision in that direction, assuming you pass patchwork
once.

> I load the saa7134 module with:
> saa7134 card=175 tuner=5

In that case, having the Philips reference boards 0x2001 subdevice twice
now for a saa7130, remove the auto detection for the 10MOONS too and
drop the one for yours.

Also, the tuners are different, but not everybody has the opportunity to
test them on their differences. In this case, tuner=5 and
TUNER_LG_PAL_NEW_TAPC makes a big difference for the UHF switch.
Likely you can't test it and sit on a clone anyway.

See more inline.

> I have not tested the remote control or the s-video.  Everything else works.
> 
> Tuners 3, 5, 14, 20, 28, 29, 48 seem to work equally well.
> 
> diff -r d6c09c3711b5 linux/drivers/media/video/saa7134/saa7134-cards.c          
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Sun Sep 20 15:14:21 2009 +0000                                                                          
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Thu Oct 29 14:54:31 2009 +0700

Run at least "make checkpatch" once on recent mercurial v4l-dvb.

For what I can see, you have spaces instead of tabs in front of your
lines and also you are filling them up with useless spaces at the ends
and for new lines. 

>                                                                           
> @@ -5342,7 +5342,38 @@                                                          
>                         .amux   = LINE2,                                        
>                 } },                                                            
>         },                                                                      
> -                                                                               
> +       [SAA7134_BOARD_STLAB_PCI_TV7130] = {                                    
> +       /* "Aidan Gill" */                                                      
> +               .name = "ST Lab ST Lab PCI-TV7130 ",                            
> +               .audio_clock = 0x00200000,                                      
> +               .tuner_type = TUNER_LG_PAL_NEW_TAPC,                            
> +               .radio_type     = UNSET,                                        
> +               .tuner_addr     = ADDR_UNSET,                                   
> +               .radio_addr     = ADDR_UNSET,                                   
> +               .gpiomask = 0x7000,

There is one unused gpio pin high in that mask, should it be needed for
something ..., don't we have a same card already?

>                                              
> +               .inputs = {{                                                    
> +                       .name = name_tv,                                        
> +                       .vmux = 1,                                              
> +                       .amux = LINE2,                                          
> +                       .gpio = 0x0000,                                         
> +                       .tv = 1,                                                
> +               }, {                                                            
> +                       .name = name_comp1,                                     
> +                       .vmux = 3,                                              
> +                       .amux = LINE1,                                          
> +                       .gpio = 0x2000,                                         
> +               }, {                                                            
> +                       .name = name_svideo,                                    
> +                       .vmux = 0,                                              
> +                       .amux = LINE1,                                          
> +                       .gpio = 0x2000,

Most often comp2 is on vmux 0. S-Video can only be on vmux 6,7,8 or 9.
Put it on 8 and comment it as untested.

>                                          
> +               } },                                                            
> +               .mute = {                                                       
> +                       .name = name_mute,                                      
> +                       .amux = TV,                                             
> +                       .gpio = 0x3000,                                         
> +               },                                                              
> +       },                                                                      
>  };                                                                             
>                                                                                 
>  const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);                
> @@ -6487,6 +6518,12 @@                                                          
>                 .subdevice    = 0x4847,                                         
>                 .driver_data  = SAA7134_BOARD_ASUS_EUROPA_HYBRID,               
>         }, {                                                                    
> +               .vendor       = PCI_VENDOR_ID_PHILIPS,                          
> +               .device       = PCI_DEVICE_ID_PHILIPS_SAA7130,                  
> +               .subvendor    =  PCI_VENDOR_ID_PHILIPS,                         
> +               .subdevice    = 0x2001,
> +               .driver_data  = SAA7134_BOARD_STLAB_PCI_TV7130,
> +       }, {

Throw that away with the 10MOONS stuff, or find some eeprom detection.

>                 /* --- boards without eeprom + subsystem ID --- */
>                 .vendor       = PCI_VENDOR_ID_PHILIPS,
>                 .device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> diff -r d6c09c3711b5 linux/drivers/media/video/saa7134/saa7134.h
> --- a/linux/drivers/media/video/saa7134/saa7134.h       Sun Sep 20 15:14:21 2009 +0000
> +++ b/linux/drivers/media/video/saa7134/saa7134.h       Thu Oct 29 14:54:31 2009 +0700
> @@ -299,6 +299,7 @@
>  #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 172
>  #define SAA7134_BOARD_ZOLID_HYBRID_PCI         173
>  #define SAA7134_BOARD_ASUS_EUROPA_HYBRID       174
> +#define SAA7134_BOARD_STLAB_PCI_TV7130         175
> 
>  #define SAA7134_MAXBOARDS 32
>  #define SAA7134_INPUT_MAX 8
> 
> Signed-off-by: Michael Wellman <flinkdeldinky@gmail.com>

Cheers,
Hermann


