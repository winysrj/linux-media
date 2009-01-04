Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n04MTuR9015670
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 17:29:56 -0500
Received: from web32702.mail.mud.yahoo.com (web32702.mail.mud.yahoo.com
	[68.142.207.246])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n04MTeo6012329
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 17:29:40 -0500
Date: Sun, 4 Jan 2009 14:29:39 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
To: video4linux-list@redhat.com
In-Reply-To: <953661.22009.qm@web32704.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <229931.28185.qm@web32702.mail.mud.yahoo.com>
Subject: Re: Kworld 315U help?
Reply-To: fmeng2002@yahoo.com
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Here is what I have modified in the driver. 

franklin@sumomo:~/dev/tv/v4l-dvb$ hg diff
diff -r 211ae674f601 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c   Fri Jan 02 18:34:28 2009 -0200                                                                          
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c   Sun Jan 04 14:24:15 2009 -0800                                                                          
@@ -1282,6 +1282,31 @@                                                          
                        .amux     = EM28XX_AMUX_LINE_IN,                        
                } },                                                            
        },                                                                      
+/* Franklin */                                                                 
+       [EM2882_BOARD_KWORLD_ATSC_315U] = {                                     
+               .name         = "KWorld ATSC 315U HDTV TV Box",                 
+               .valid        = EM28XX_BOARD_NOT_VALIDATED,                     
+               .tuner_type   = TUNER_THOMSON_DTT761X,                          
+               .tuner_gpio   = default_tuner_gpio,                             
+               .tda9887_conf = TDA9887_PRESENT,                                
+               .decoder      = EM28XX_SAA711X,                                 
+               .has_dvb      = 1,                                              
+               .dvb_gpio     = default_digital,                                
+               .input        = { {                                             
+                       .type     = EM28XX_VMUX_TELEVISION,                     
+                       .vmux     = SAA7115_COMPOSITE2,                         
+                       .amux     = EM28XX_AMUX_VIDEO,                          
+               }, {                                                            
+                       .type     = EM28XX_VMUX_COMPOSITE1,                     
+                       .vmux     = SAA7115_COMPOSITE0,                         
+                       .amux     = EM28XX_AMUX_LINE_IN,                        
+               }, {                                                            
+                       .type     = EM28XX_VMUX_SVIDEO,                         
+                       .vmux     = SAA7115_SVIDEO3,                            
+                       .amux     = EM28XX_AMUX_LINE_IN,                        
+               } },                                                            
+       },                                                                      
+/* Franklin */                                                                 
 };                                                                             
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);                  
                                                                                
@@ -1383,6 +1408,10 @@                                                          
                        .driver_info = EM2800_BOARD_LEADTEK_WINFAST_USBII },    
        { USB_DEVICE(0x093b, 0xa005),                                           
                        .driver_info = EM2861_BOARD_PLEXTOR_PX_TV100U },        
+/* Franklin */                                                                 
+       { USB_DEVICE(0xeb1a, 0xa313),                                           
+                       .driver_info = EM2882_BOARD_KWORLD_ATSC_315U },         
+/* Franklin */                                                                 
        { },                                                                    
 };                                                                             
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);                                     
diff -r 211ae674f601 linux/drivers/media/video/em28xx/em28xx-dvb.c              
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c     Fri Jan 02 18:34:28 2009 -0200                                                                          
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c     Sun Jan 04 14:24:15 2009 -0800                                                                          
@@ -410,6 +410,13 @@                                                            
        em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);                              
        /* init frontend */                                                     
        switch (dev->model) {                                                   
+/* Franklin */                                                                 
+       case EM2882_BOARD_KWORLD_ATSC_315U:                                     
+/* Franklin */                                                                 
+               dvb->frontend = dvb_attach(lgdt330x_attach,                     
+                                          &em2880_lgdt3303_dev,                
+                                          &dev->i2c_adap);                     
+               break;                                                          
        case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850:                              
        case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950:                              
        case EM2880_BOARD_PINNACLE_PCTV_HD_PRO:                                 
diff -r 211ae674f601 linux/drivers/media/video/em28xx/em28xx.h                  
--- a/linux/drivers/media/video/em28xx/em28xx.h Fri Jan 02 18:34:28 2009 -0200  
+++ b/linux/drivers/media/video/em28xx/em28xx.h Sun Jan 04 14:24:15 2009 -0800  
@@ -99,6 +99,9 @@                                                               
 #define EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU     58                            
 #define EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850     60                            
 #define EM2820_BOARD_PROLINK_PLAYTV_BOX4_USB2    61                            
+/* Franklin */                                                                 
+#define EM2882_BOARD_KWORLD_ATSC_315U     62                                   
+/* Franklin */                                                                 
                                                                                
 /* Limits minimum and default number of buffers */                             
 #define EM28XX_MIN_BUF 4                                               

Thanks,
Franklin 


--- On Sun, 1/4/09, Franklin Meng <fmeng2002@yahoo.com> wrote:

> From: Franklin Meng <fmeng2002@yahoo.com>
> Subject: Kworld 315U help?
> To: video4linux-list@redhat.com
> Date: Sunday, January 4, 2009, 2:04 PM
> I was wondering if someone can help me get the Kworld 315U
> supported under
> linux?  Information about the device is located here:
> http://linuxtv.org/wiki/index.php/KWorld_ATSC_315U
> 
> I have spent some time modifying the driver though I
> haven't gotten anything working yet.  If someone can
> give me some pointers or help it would be greatly
> appreciated.  I think I have all the chips of interest
> detected but I don't know what to do now.  
> 
> Here's an output of my kernel logs showing the device. 
> Hopefully I'm on the right track. 
> 
> [  569.663960] Linux video capture interface: v2.00        
>                     
> [  569.717312] em28xx: New device USB 2883 Device @ 480
> Mbps (eb1a:a313, interface 0, class 0)                      
>                                            
> [  569.719319] em28xx #0: Identified as KWorld ATSC 315U
> HDTV TV Box (card=62)  
> [  569.719407] em28xx #0: chip ID is em2882/em2883         
>                     
> [  569.846878] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb
> 13 a3 d0 13 5a 03 6a 22 00 00                               
>                                         
> [  569.846911] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07
> 01 00 00 00 00 00 00 00 00 00                               
>                                         
> [  569.846942] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10
> 01 00 00 00 00 00 5b 1c 00 00                               
>                                         
> [  569.846971] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80
> 02 20 01 01 00 00 00 00 00 00                               
>                                         
> [  569.847000] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00                               
>                                         
> [  569.847028] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00                               
>                                         
> [  569.847056] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00
> 00 00 00 00 22 03 55 00 53 00                               
>                                         
> [  569.847086] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00
> 38 00 38 00 33 00 20 00 44 00                               
>                                         
> [  569.847116] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00
> 63 00 65 00 00 00 00 00 00 00                               
>                                         
> [  569.847145] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00                               
>                                         
> [  569.847173] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00                               
>                                         
> [  569.847202] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00                               
>                                         
> [  569.847230] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00                               
>                                         
> [  569.847259] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00                               
>                                         
> [  569.847288] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00                               
>                                         
> [  569.847317] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00                               
>                                         
> [  569.847348] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM
> hash = 0x98330201       
> [  569.847353] em28xx #0: EEPROM info:                     
>                     
> [  569.847357] em28xx #0:       AC97 audio (5 sample rates)
>                     
> [  569.847362] em28xx #0:       500mA max power            
>                     
> [  569.847367] em28xx #0:       Table at 0x04,
> strings=0x226a, 0x0000, 0x0000   
> [  569.847373] em28xx #0:                                  
>                     
> [  569.847376]                                             
>                     
> [  569.847382] em28xx #0: The support for this board
> weren't valid yet.         
> [  569.847387] em28xx #0: Please send a report of having
> this working           
> [  569.847393] em28xx #0: not to V4L mailing list (and/or
> to other addresses)   
> [  569.847396]                                             
>                     
> [  569.882876] saa7115' 0-0025: saa7113 found
> (1f7113d0e100000) @ 0x4a (em28xx #0)                        
>                                                      
> [  569.955345] tuner' 0-0043: chip found @ 0x86 (em28xx
> #0)                     
> [  569.979876] tda9887 0-0043: creating new instance       
>                     
> [  569.979894] tda9887 0-0043: tda988[5/6/7] found         
>                     
> [  569.980772] tda9887 0-0043: destroying instance         
>                     
> [  569.980993] tda9887 0-0043: creating new instance       
>                     
> [  569.980999] tda9887 0-0043: tda988[5/6/7] found         
>                     
> [  569.983857] tuner' 0-0061: chip found @ 0xc2 (em28xx
> #0)                     
> [  570.018607] tuner-simple 0-0061: creating new instance  
>                     
> [  570.018622] tuner-simple 0-0061: type set to 60 (Thomson
> DTT 761X (ATSC/NTSC))                                       
>                                        
> [  570.025349] em28xx #0: Config register raw data: 0xd0   
>                     
> [  570.026360] em28xx #0: AC97 vendor ID = 0xffffffff      
>                     
> [  570.026747] em28xx #0: AC97 features = 0x6a90           
>                     
> [  570.026752] em28xx #0: Empia 202 AC97 audio processor
> detected               
> [  570.060722] em28xx #0: v4l2 driver version 0.1.1        
>                     
> [  570.093645] em28xx #0: V4L2 device registered as
> /dev/video0 and /dev/vbi0   
> [  570.093729] usbcore: registered new interface driver
> em28xx                  
> [  570.093737] em28xx driver loaded                        
>                     
> [  570.126733] em28xx-audio.c: probing for em28x1 non
> standard usbaudio         
> [  570.126743] em28xx-audio.c: Copyright (C) 2006 Markus
> Rechberger             
> [  570.128744] Em28xx: Initialized (Em28xx Audio Extension)
> extension           
> [  570.303684] DVB: registering new adapter (em28xx #0)    
>                     
> [  570.305475] DVB: registering adapter 0 frontend 0 (LG
> Electronics LGDT3303 VSB/QAM Frontend)...                   
>                                           
> [  570.307037] Successfully loaded em28xx-dvb              
>                     
> [  570.307051] Em28xx: Initialized (Em28xx dvb Extension)
> extension             
> 
> Thanks,
> Franklin
> 
> 
>       
> 
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
