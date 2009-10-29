Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48376 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbZJ2QHE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 12:07:04 -0400
Received: by bwz27 with SMTP id 27so2489061bwz.21
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2009 09:07:08 -0700 (PDT)
To: linux-media@vger.kernel.org
Subject: [PATCH video4linux] For STLabs PCI saa7134 analog receiver card
From: flinkdeldinky <flinkdeldinky@gmail.com>
Date: Thu, 29 Oct 2009 23:07:28 +0700
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910292307.28202.flinkdeldinky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch provides functionality for the STLabs PCI TV receiver card. It only adds some information to saa7134.h and saa7134-cards.c

The card is auto detected as a 10 MOONS card but that will not work.

I load the saa7134 module with:
saa7134 card=175 tuner=5

I have not tested the remote control or the s-video.  Everything else works.

Tuners 3, 5, 14, 20, 28, 29, 48 seem to work equally well.

diff -r d6c09c3711b5 linux/drivers/media/video/saa7134/saa7134-cards.c          
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c Sun Sep 20 15:14:21 2009 +0000                                                                          
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Thu Oct 29 14:54:31 2009 +0700                                                                          
@@ -5342,7 +5342,38 @@                                                          
                        .amux   = LINE2,                                        
                } },                                                            
        },                                                                      
-                                                                               
+       [SAA7134_BOARD_STLAB_PCI_TV7130] = {                                    
+       /* "Aidan Gill" */                                                      
+               .name = "ST Lab ST Lab PCI-TV7130 ",                            
+               .audio_clock = 0x00200000,                                      
+               .tuner_type = TUNER_LG_PAL_NEW_TAPC,                            
+               .radio_type     = UNSET,                                        
+               .tuner_addr     = ADDR_UNSET,                                   
+               .radio_addr     = ADDR_UNSET,                                   
+               .gpiomask = 0x7000,                                             
+               .inputs = {{                                                    
+                       .name = name_tv,                                        
+                       .vmux = 1,                                              
+                       .amux = LINE2,                                          
+                       .gpio = 0x0000,                                         
+                       .tv = 1,                                                
+               }, {                                                            
+                       .name = name_comp1,                                     
+                       .vmux = 3,                                              
+                       .amux = LINE1,                                          
+                       .gpio = 0x2000,                                         
+               }, {                                                            
+                       .name = name_svideo,                                    
+                       .vmux = 0,                                              
+                       .amux = LINE1,                                          
+                       .gpio = 0x2000,                                         
+               } },                                                            
+               .mute = {                                                       
+                       .name = name_mute,                                      
+                       .amux = TV,                                             
+                       .gpio = 0x3000,                                         
+               },                                                              
+       },                                                                      
 };                                                                             
                                                                                
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);                
@@ -6487,6 +6518,12 @@                                                          
                .subdevice    = 0x4847,                                         
                .driver_data  = SAA7134_BOARD_ASUS_EUROPA_HYBRID,               
        }, {                                                                    
+               .vendor       = PCI_VENDOR_ID_PHILIPS,                          
+               .device       = PCI_DEVICE_ID_PHILIPS_SAA7130,                  
+               .subvendor    =  PCI_VENDOR_ID_PHILIPS,                         
+               .subdevice    = 0x2001,
+               .driver_data  = SAA7134_BOARD_STLAB_PCI_TV7130,
+       }, {
                /* --- boards without eeprom + subsystem ID --- */
                .vendor       = PCI_VENDOR_ID_PHILIPS,
                .device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
diff -r d6c09c3711b5 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h       Sun Sep 20 15:14:21 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134.h       Thu Oct 29 14:54:31 2009 +0700
@@ -299,6 +299,7 @@
 #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 172
 #define SAA7134_BOARD_ZOLID_HYBRID_PCI         173
 #define SAA7134_BOARD_ASUS_EUROPA_HYBRID       174
+#define SAA7134_BOARD_STLAB_PCI_TV7130         175

 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

Signed-off-by: Michael Wellman <flinkdeldinky@gmail.com>
