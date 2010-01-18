Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32706.mail.mud.yahoo.com ([68.142.207.250]:45925 "HELO
	web32706.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751780Ab0ARHH2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 02:07:28 -0500
Message-ID: <15799.81854.qm@web32706.mail.mud.yahoo.com>
Date: Sun, 17 Jan 2010 23:07:26 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: [Patch 2/3] Kworld 315U
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
In-Reply-To: <647298.8638.qm@web32701.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch with updated GPIOs and enable analog inputs for the Kworld 315U

Signed-off-by: Franklin Meng<fmeng2002@yahoo.com>

diff -r b6b82258cf5e linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c   Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c   Sun Jan 17 22:54:21 2010 -0800
@@ -122,13 +122,31 @@                                                                 
 };                                                                                   
 #endif                                                                               
                                                                                      
+/* Kworld 315U                                                                       
+   GPIO0 - Enable digital power (lgdt3303) - low to enable                           
+   GPIO1 - Enable analog power (saa7113/emp202) - low to enable                      
+   GPIO7 - enables something ?                                                       
+   GOP2  - ?? some sort of reset ?                                                   
+   GOP3  - lgdt3303 reset                                                            
+ */                                                                                  
 /* Board - EM2882 Kworld 315U digital */                                             
 static struct em28xx_reg_seq em2882_kworld_315u_digital[] = {                        
-       {EM28XX_R08_GPIO,       0xff,   0xff,           10},                          
-       {EM28XX_R08_GPIO,       0xfe,   0xff,           10},                          
+       {EM28XX_R08_GPIO,       0x7e,   0xff,           10},                          
        {EM2880_R04_GPO,        0x04,   0xff,           10},                          
        {EM2880_R04_GPO,        0x0c,   0xff,           10},                          
-       {EM28XX_R08_GPIO,       0x7e,   0xff,           10},                          
+       {  -1,                  -1,     -1,             -1},                          
+};                                                                                   
+                                                                                     
+/* Board - EM2882 Kworld 315U analog1 analog tv */                                   
+static struct em28xx_reg_seq em2882_kworld_315u_analog1[] = {                        
+       {EM28XX_R08_GPIO,       0xfd,   0xff,           10},                          
+       {EM28XX_R08_GPIO,       0x7d,   0xff,           10},                          
+       {  -1,                  -1,     -1,             -1},                          
+};                                                                                   
+                                                                                     
+/* Board - EM2882 Kworld 315U analog2 component/svideo */                            
+static struct em28xx_reg_seq em2882_kworld_315u_analog2[] = {                        
+       {EM28XX_R08_GPIO,       0xfd,   0xff,           10},                          
        {  -1,                  -1,     -1,             -1},                          
 };                                                                                   
                                                                                      
@@ -140,6 +158,14 @@                                                                  
        {  -1,                  -1,     -1,             -1},                          
 };                                                                                   
                                                                                      
+/* Board - EM2882 Kworld 315U suspend */                                             
+static struct em28xx_reg_seq em2882_kworld_315u_suspend[] = {                        
+       {EM28XX_R08_GPIO,       0xff,   0xff,           10},                          
+       {EM2880_R04_GPO,        0x08,   0xff,           10},                          
+       {EM2880_R04_GPO,        0x0c,   0xff,           10},                          
+       {  -1,                  -1,     -1,             -1},                          
+};                                                                                   
+                                                                                     
 static struct em28xx_reg_seq kworld_330u_analog[] = {                                
        {EM28XX_R08_GPIO,       0x6d,   ~EM_GPIO_4,     10},                          
        {EM2880_R04_GPO,        0x00,   0xff,           10},                          
@@ -1314,28 +1340,28 @@                                                               
                .decoder        = EM28XX_SAA711X,                                     
                .has_dvb        = 1,                                                  
                .dvb_gpio       = em2882_kworld_315u_digital,                         
+               .suspend_gpio   = em2882_kworld_315u_suspend,                         
                .xclk           = EM28XX_XCLK_FREQUENCY_12MHZ,                        
                .i2c_speed      = EM28XX_I2C_CLK_WAIT_ENABLE,                         
-               /* Analog mode - still not ready */                                   
-               /*.input        = { {                                                 
+               .input        = { {                                                   
                        .type = EM28XX_VMUX_TELEVISION,                               
                        .vmux = SAA7115_COMPOSITE2,                                   
                        .amux = EM28XX_AMUX_VIDEO,                                    
-                       .gpio = em2882_kworld_315u_analog,                            
+                       .gpio = em2882_kworld_315u_analog1,                           
                        .aout = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,          
                }, {                                                                  
                        .type = EM28XX_VMUX_COMPOSITE1,                               
                        .vmux = SAA7115_COMPOSITE0,                                   
                        .amux = EM28XX_AMUX_LINE_IN,                                  
-                       .gpio = em2882_kworld_315u_analog1,                           
+                       .gpio = em2882_kworld_315u_analog2,                           
                        .aout = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,          
                }, {                                                                  
                        .type = EM28XX_VMUX_SVIDEO,                                   
                        .vmux = SAA7115_SVIDEO3,                                      
                        .amux = EM28XX_AMUX_LINE_IN,                                  
-                       .gpio = em2882_kworld_315u_analog1,                           
+                       .gpio = em2882_kworld_315u_analog2,                           
                        .aout = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,          
-               } }, */                                                               
+               } },                                                                  
        },                                                                            
        [EM2880_BOARD_EMPIRE_DUAL_TV] = {                                             
                .name = "Empire dual TV",                                       


      
