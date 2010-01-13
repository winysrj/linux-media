Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab0AMVKJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 16:10:09 -0500
Message-ID: <4B4E36AC.7090503@redhat.com>
Date: Wed, 13 Jan 2010 19:10:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Franklin Meng <fmeng2002@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: Kworld 315U and SAA7113?
References: <430160.90047.qm@web32702.mail.mud.yahoo.com>
In-Reply-To: <430160.90047.qm@web32702.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Franklin,

I have no Kworld 315U here for testing, but your patch looked sane on my eyes.
In order to merge this upstream, it would be better if you could submit it as two
separate patches: the first one with the saa7115 changes to support re-energizing
the device, and the second one with the em28xx changes.

Please send your Signed-off-by: on the patches.

Cheers,
Mauro.

Franklin Meng wrote:
> I tweaked the GPIO's a bit more for the Kworld 315U and switching between analog and digital signals is more reliable now.  Attached is an updated diff.  
> 
> diff -r b6b82258cf5e linux/drivers/media/video/em28xx/em28xx-cards.c
> --- a/linux/drivers/media/video/em28xx/em28xx-cards.c   Thu Dec 31 19:14:54 2009 -0200
> +++ b/linux/drivers/media/video/em28xx/em28xx-cards.c   Sat Jan 09 11:29:27 2010 -0800
> @@ -122,13 +122,31 @@                                                                 
>  };                                                                                   
>  #endif                                                                               
>                                                                                       
> +/* Kworld 315U                                                                       
> +   GPIO0 - Enable digital power (lgdt3303) - low to enable                           
> +   GPIO1 - Enable analog power (saa7113/emp202) - low to enable                      
> +   GPIO7 - enables something ?                                                       
> +   GOP2  - ?? some sort of reset ?                                                   
> +   GOP3  - lgdt3303 reset                                                            
> + */                                                                                  
>  /* Board - EM2882 Kworld 315U digital */                                             
>  static struct em28xx_reg_seq em2882_kworld_315u_digital[] = {                        
> -       {EM28XX_R08_GPIO,       0xff,   0xff,           10},                          
> -       {EM28XX_R08_GPIO,       0xfe,   0xff,           10},                          
> +       {EM28XX_R08_GPIO,       0x7e,   0xff,           10},                          
>         {EM2880_R04_GPO,        0x04,   0xff,           10},                          
>         {EM2880_R04_GPO,        0x0c,   0xff,           10},                          
> -       {EM28XX_R08_GPIO,       0x7e,   0xff,           10},                          
> +       {  -1,                  -1,     -1,             -1},                          
> +};                                                                                   
> +                                                                                     
> +/* Board - EM2882 Kworld 315U analog1 analog tv */                                   
> +static struct em28xx_reg_seq em2882_kworld_315u_analog1[] = {                        
> +       {EM28XX_R08_GPIO,       0xfd,   0xff,           10},                          
> +       {EM28XX_R08_GPIO,       0x7d,   0xff,           10},                          
> +       {  -1,                  -1,     -1,             -1},                          
> +};                                                                                   
> +                                                                                     
> +/* Board - EM2882 Kworld 315U analog2 component/svideo */                            
> +static struct em28xx_reg_seq em2882_kworld_315u_analog2[] = {                        
> +       {EM28XX_R08_GPIO,       0xfd,   0xff,           10},                          
>         {  -1,                  -1,     -1,             -1},                          
>  };                                                                                   
>                                                                                       
> @@ -140,6 +158,14 @@                                                                  
>         {  -1,                  -1,     -1,             -1},                          
>  };                                                                                   
>                                                                                       
> +/* Board - EM2882 Kworld 315U suspend */                                             
> +static struct em28xx_reg_seq em2882_kworld_315u_suspend[] = {                        
> +       {EM28XX_R08_GPIO,       0xff,   0xff,           10},                          
> +       {EM2880_R04_GPO,        0x08,   0xff,           10},                          
> +       {EM2880_R04_GPO,        0x0c,   0xff,           10},                          
> +       {  -1,                  -1,     -1,             -1},                          
> +};                                                                                   
> +                                                                                     
>  static struct em28xx_reg_seq kworld_330u_analog[] = {                                
>         {EM28XX_R08_GPIO,       0x6d,   ~EM_GPIO_4,     10},                          
>         {EM2880_R04_GPO,        0x00,   0xff,           10},                          
> @@ -1314,28 +1340,28 @@                                                               
>                 .decoder        = EM28XX_SAA711X,                                     
>                 .has_dvb        = 1,                                                  
>                 .dvb_gpio       = em2882_kworld_315u_digital,                         
> +               .suspend_gpio   = em2882_kworld_315u_suspend,                         
>                 .xclk           = EM28XX_XCLK_FREQUENCY_12MHZ,                        
>                 .i2c_speed      = EM28XX_I2C_CLK_WAIT_ENABLE,                         
> -               /* Analog mode - still not ready */                                   
> -               /*.input        = { {                                                 
> +               .input        = { {                                                   
>                         .type = EM28XX_VMUX_TELEVISION,                               
>                         .vmux = SAA7115_COMPOSITE2,                                   
>                         .amux = EM28XX_AMUX_VIDEO,                                    
> -                       .gpio = em2882_kworld_315u_analog,                            
> +                       .gpio = em2882_kworld_315u_analog1,                           
>                         .aout = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,          
>                 }, {                                                                  
>                         .type = EM28XX_VMUX_COMPOSITE1,                               
>                         .vmux = SAA7115_COMPOSITE0,                                   
>                         .amux = EM28XX_AMUX_LINE_IN,                                  
> -                       .gpio = em2882_kworld_315u_analog1,                           
> +                       .gpio = em2882_kworld_315u_analog2,                           
>                         .aout = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,          
>                 }, {                                                                  
>                         .type = EM28XX_VMUX_SVIDEO,                                   
>                         .vmux = SAA7115_SVIDEO3,                                      
>                         .amux = EM28XX_AMUX_LINE_IN,                                  
> -                       .gpio = em2882_kworld_315u_analog1,                           
> +                       .gpio = em2882_kworld_315u_analog2,                           
>                         .aout = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,          
> -               } }, */                                                               
> +               } },                                                                  
>         },                                                                            
>         [EM2880_BOARD_EMPIRE_DUAL_TV] = {                                             
>                 .name = "Empire dual TV",                                             
> diff -r b6b82258cf5e linux/drivers/media/video/em28xx/em28xx-core.c                   
> --- a/linux/drivers/media/video/em28xx/em28xx-core.c    Thu Dec 31 19:14:54 2009 -0200
> +++ b/linux/drivers/media/video/em28xx/em28xx-core.c    Sat Jan 09 11:29:27 2010 -0800
> @@ -1132,6 +1132,7 @@                                                                 
>   */                                                                                  
>  void em28xx_wake_i2c(struct em28xx *dev)                                             
>  {                                                                                    
> +       v4l2_device_call_all(&dev->v4l2_dev, 0, core,  s_power, 1);                   
>         v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);                     
>         v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,                     
>                         INPUT(dev->ctl_input)->vmux, 0, 0);                           
> diff -r b6b82258cf5e linux/drivers/media/video/saa7115.c                              
> --- a/linux/drivers/media/video/saa7115.c       Thu Dec 31 19:14:54 2009 -0200        
> +++ b/linux/drivers/media/video/saa7115.c       Sat Jan 09 11:29:27 2010 -0800        
> @@ -1338,6 +1338,59 @@                                                                
>         return 0;                                                                     
>  }                                                                                    
>                                                                                       
> +static int saa711x_s_power(struct v4l2_subdev *sd, int val)                          
> +{                                                                                    
> +       struct saa711x_state *state = to_state(sd);                                   
> +                                                                                     
> +       if(val > 1 || val < 0)                                                        
> +               return -EINVAL;                                                       
> +                                                                                     
> +       /* There really isn't a way to put the chip into power saving                 
> +               other than by pulling CE to ground so all we do is return             
> +               out of this function                                                  
> +       */                                                                            
> +       if(val == 0)                                                                  
> +               return 0;                                                             
> +                                                                                     
> +       /* When enabling the chip again we need to reinitialize the                   
> +               all the values                                                        
> +       */                                                                            
> +       state->input = -1;                                                            
> +       state->output = SAA7115_IPORT_ON;                                             
> +       state->enable = 1;                                                            
> +       state->radio = 0;                                                             
> +       state->bright = 128;                                                          
> +       state->contrast = 64;                                                         
> +       state->hue = 0;                                                               
> +       state->sat = 64;                                                              
> +                                                                                     
> +       state->audclk_freq = 48000;                                                   
> +                                                                                     
> +       v4l2_dbg(1, debug, sd, "writing init values s_power\n");                      
> +                                                                                     
> +       /* init to 60hz/48khz */                                                      
> +       state->crystal_freq = SAA7115_FREQ_24_576_MHZ;                                
> +       switch (state->ident) {                                                       
> +       case V4L2_IDENT_SAA7111:                                                      
> +               saa711x_writeregs(sd, saa7111_init);                                  
> +               break;                                                                
> +       case V4L2_IDENT_SAA7113:                                                      
> +               saa711x_writeregs(sd, saa7113_init);
> +               break;
> +       default:
> +               state->crystal_freq = SAA7115_FREQ_32_11_MHZ;
> +               saa711x_writeregs(sd, saa7115_init_auto_input);
> +       }
> +       if (state->ident != V4L2_IDENT_SAA7111)
> +               saa711x_writeregs(sd, saa7115_init_misc);
> +       saa711x_set_v4lstd(sd, V4L2_STD_NTSC);
> +
> +       v4l2_dbg(1, debug, sd, "status: (1E) 0x%02x, (1F) 0x%02x\n",
> +               saa711x_read(sd, R_1E_STATUS_BYTE_1_VD_DEC),
> +               saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC));
> +       return 0;
> +}
> +
>  static int saa711x_reset(struct v4l2_subdev *sd, u32 val)
>  {
>         v4l2_dbg(1, debug, sd, "decoder RESET\n");
> @@ -1513,6 +1566,7 @@
>         .s_std = saa711x_s_std,
>         .reset = saa711x_reset,
>         .s_gpio = saa711x_s_gpio,
> +       .s_power = saa711x_s_power,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>         .g_register = saa711x_g_register,
>         .s_register = saa711x_s_register,
> 
> 
> Thanks,
> Franklin Meng
> 
> --- On Thu, 1/7/10, Franklin Meng <fmeng2002@yahoo.com> wrote:
> 
>> From: Franklin Meng <fmeng2002@yahoo.com>
>> Subject: Kworld 315U and SAA7113?
>> To: linux-media@vger.kernel.org
>> Date: Thursday, January 7, 2010, 7:48 PM
>> After some work I have finally gotten
>> the analog inputs to work with the Kworld 315U device.  I
>> have attached the changes/updates to the em28xx driver.
>> Note: I still don't have analog sound working yet..
>>
>> I am hoping someone can comment on the changes in
>> saa7115.c.  I added a s_power routine to reinitialize the
>> device.  The reason I am reinitializing this device is
>> because
>>
>> 1. I cannot keep both the LG demod and the SAA powered on
>> at the same time for my device
>>
>> 2. The SAA datasheet seems to suggest that after a
>> reset/power-on the chip needs to be reinitialized.  
>>
>> 3. Reinitializing causes the analog inputs to work
>> correctly. 
>>
>> Here's what is says in the SAA7113 datasheet.. 
>> ....
>> Status after power-on
>> control sequence
>>
>> VPO7 to VPO0, RTCO, RTS0 and RTS1
>> are held in high-impedance state
>>
>> after power-on (reset
>> sequence) a complete
>> I2C-bus transmission is
>> required
>> ...
>> The above is really suppose to be arranged horizontally in
>> 3 columns.  Anyways, the last part describes that "a
>> complete I2C bus transmission is required"  This is why
>> I think the chip needs to be reinitialized.  
>>
>>
>> Last thing is that the initialization routing uses these
>> defaults:
>>
>>        state->bright = 128;
>>        state->contrast = 64;
>>        state->hue = 0;
>>        state->sat = 64;
>>
>> I was wondering if we should just read the back the values
>> that were initialized by the initialization routine and use
>> those values instead.The reason is because it seems like the
>> different SAA's use slightly different values when
>> initializing.  
>>
>> Thanks,
>> Franklin Meng
>>
>>
>>      
> 
> 
>       
> 

