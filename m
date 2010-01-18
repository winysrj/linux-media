Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32701.mail.mud.yahoo.com ([68.142.207.245]:37530 "HELO
	web32701.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751715Ab0ARHDa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 02:03:30 -0500
Message-ID: <647298.8638.qm@web32701.mail.mud.yahoo.com>
Date: Sun, 17 Jan 2010 23:03:29 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: [Patch 1/3] Kworld 315U
To: linux-media@vger.kernel.org
Cc: " Mauro Carvalho ChehabDevin Heitmueller <dheitmueller@kernellabs.com>"
	<mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch to add the s_power function to the saa7115.c code.

Signed-off-by: Franklin Meng<fmeng2002@yahoo.com>


diff -r b6b82258cf5e linux/drivers/media/video/saa7115.c                              
--- a/linux/drivers/media/video/saa7115.c       Thu Dec 31 19:14:54 2009 -0200        
+++ b/linux/drivers/media/video/saa7115.c       Sun Jan 17 22:54:21 2010 -0800        
@@ -1338,6 +1338,59 @@                                                                
        return 0;                                                                     
 }                                                                                    
                                                                                      
+static int saa711x_s_power(struct v4l2_subdev *sd, int val)                          
+{                                                                                    
+       struct saa711x_state *state = to_state(sd);                                   
+                                                                                     
+       if(val > 1 || val < 0)                                                        
+               return -EINVAL;                                                       
+                                                                                     
+       /* There really isn't a way to put the chip into power saving                 
+               other than by pulling CE to ground so all we do is return             
+               out of this function                                                  
+       */                                                                            
+       if(val == 0)                                                                  
+               return 0;                                                             
+                                                                                     
+       /* When enabling the chip again we need to reinitialize the                   
+               all the values                                                        
+       */                                                                            
+       state->input = -1;                                                            
+       state->output = SAA7115_IPORT_ON;                                             
+       state->enable = 1;                                                            
+       state->radio = 0;                                                             
+       state->bright = 128;                                                          
+       state->contrast = 64;                                                         
+       state->hue = 0;                                                               
+       state->sat = 64;                                                              
+                                                                                     
+       state->audclk_freq = 48000;                                                   
+                                                                                     
+       v4l2_dbg(1, debug, sd, "writing init values s_power\n");                      
+                                                                                     
+       /* init to 60hz/48khz */                                                      
+       state->crystal_freq = SAA7115_FREQ_24_576_MHZ;                                
+       switch (state->ident) {                                                       
+       case V4L2_IDENT_SAA7111:                                                      
+               saa711x_writeregs(sd, saa7111_init);                                  
+               break;                                                                
+       case V4L2_IDENT_SAA7113:                                                      
+               saa711x_writeregs(sd, saa7113_init);
+               break;
+       default:
+               state->crystal_freq = SAA7115_FREQ_32_11_MHZ;
+               saa711x_writeregs(sd, saa7115_init_auto_input);
+       }
+       if (state->ident != V4L2_IDENT_SAA7111)
+               saa711x_writeregs(sd, saa7115_init_misc);
+       saa711x_set_v4lstd(sd, V4L2_STD_NTSC);
+
+       v4l2_dbg(1, debug, sd, "status: (1E) 0x%02x, (1F) 0x%02x\n",
+               saa711x_read(sd, R_1E_STATUS_BYTE_1_VD_DEC),
+               saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC));
+       return 0;
+}
+
 static int saa711x_reset(struct v4l2_subdev *sd, u32 val)
 {
        v4l2_dbg(1, debug, sd, "decoder RESET\n");
@@ -1513,6 +1566,7 @@
        .s_std = saa711x_s_std,
        .reset = saa711x_reset,
        .s_gpio = saa711x_s_gpio,
+       .s_power = saa711x_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
        .g_register = saa711x_g_register,
        .s_register = saa711x_s_register,








      
