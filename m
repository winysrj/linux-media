Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Tue, 30 Sep 2008 11:11:29 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <e32e0e5d0809291902x7d18ffaep2a02384113f3d8af@mail.gmail.com>
To: Tim Lucas <lucastim@gmail.com>
Message-id: <48E241A1.7090404@linuxtv.org>
MIME-version: 1.0
References: <e32e0e5d0809171545r3c2e58beh62d58fa6d04dae71@mail.gmail.com>
	<48D34C69.6050700@linuxtv.org>
	<e32e0e5d0809232045j56bef9ah1ec3ac59401de0d5@mail.gmail.com>
	<e32e0e5d0809232050s1d0257e3m30c9c055e9d32dd6@mail.gmail.com>
	<48DA9330.6070005@linuxtv.org>
	<e32e0e5d0809241315rd423c0dj553812167194d4a3@mail.gmail.com>
	<48DADA06.9000105@linuxtv.org>
	<e32e0e5d0809251807l6f0080c3j673af97821454581@mail.gmail.com>
	<e32e0e5d0809280829l690d076epe62f4d131806a65a@mail.gmail.com>
	<48E118F5.5090501@linuxtv.org>
	<e32e0e5d0809291902x7d18ffaep2a02384113f3d8af@mail.gmail.com>
Cc: linux dvb <linux-dvb@linuxtv.org>, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] Porting analog support from HVR-1500 to the DViCO
 FusionHDTV7 Dual Express (Read this one)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Tim Lucas wrote:
> On Mon, Sep 29, 2008 at 11:05 AM, Steven Toth <stoth@linuxtv.org 
> <mailto:stoth@linuxtv.org>> wrote:
> 
>     Tim Lucas wrote:
> 
>         On Thu, Sep 25, 2008 at 6:07 PM, Tim Lucas <lucastim@gmail.com
>         <mailto:lucastim@gmail.com> <mailto:lucastim@gmail.com
>         <mailto:lucastim@gmail.com>>> wrote:
> 
>            OK, so I tested both s-video and composite inputs.  I get
>         video for
>            s-video, but not composite.  The video seems to flicker a
>         little bit
>            in tv time.  I just have standard rca cables plugged in for
>         audio,
>            but I can;t get any sound.
>            I tried changing the "tuner-type" to 0xc2, 0xc4, and 0x61.  All
>            three gave the same results.
> 
>                 --Tim
> 
> 
>         So the good news was that the s-video was working.  I want to
>         make sure that I hooked up the sound correctly.  I can't imagine
>         that there is any other way than the rca cables.  So what is next?
> 
> 
>     That's a great step forward. That means the tv input will probably
>     produce the correct input if the tuner is set correctly.
> 
>     Switch to this tree http://linuxtv.org/hg/~stoth/cx23885-audio and
>     try again with the svideo and audio tests.
> 
>     Mijhail Moreyra wrote some HVR1500 audio patches, which I have not
>     tested yet. Do these produce audio for you via the svideo and
>     breakout RCA audio input cable?
> 
> 
>         The only things that I can adjust in cx23885-cards.c is the
>         "tuner-type"  I've tried various suggestions, but had no luck.
>          Are there other parameters that can be changed?  
> 
> 
>     Look at how the HVR1500 analog tuner is setup in this tree, it may
>     help - especially with the tuner setup.
> 
>     - Steve
> 
> 
> I have been using the cx23885-audio branch the entire time.  I still do 
> not get audio.

OK.

> 
> I have a thought about the setup. I was looking at this part of the 
> HVR-1500 driver
> 
> .input          = {{
> .type   = CX23885_VMUX_TELEVISION,
>                         .vmux   =       CX25840_VIN7_CH3 |
>                                         CX25840_VIN5_CH2 |
>                                         CX25840_VIN2_CH1,
> .gpio0  = 0,
>                 }, {
>                         .type   = CX23885_VMUX_COMPOSITE1,
>                         .vmux   =       CX25840_VIN7_CH3 |
>                                         CX25840_VIN4_CH2 |
>                                         CX25840_VIN6_CH1,
>                         .gpio0  = 0,
>                 }, {
>                         .type   = CX23885_VMUX_SVIDEO,
>                         .vmux   =       CX25840_VIN7_CH3 |
>                                         CX25840_VIN4_CH2 |
>                                         CX25840_VIN8_CH1 |
>                                         CX25840_SVIDEO_ON,
>                         .gpio0  = 0,
>                 } },
> 
> 
> The DVICO FusionHDTV5 board has the following
> 
> [CX88_BOARD_DVICO_FUSIONHDTV_5_GOLD] = {
>                 .name           = "DViCO FusionHDTV 5 Gold",
>                 .tuner_type     = TUNER_LG_TDVS_H06XF, /* TDVS-H062F */
>                 .radio_type     = UNSET,
>                 .tuner_addr     = ADDR_UNSET,
>                 .radio_addr     = ADDR_UNSET,
>                 .tda9887_conf   = TDA9887_PRESENT,
>                 .input          = {{
>                         .type   = CX88_VMUX_TELEVISION,
>                         .vmux   = 0,
>                         .gpio0  = 0x87fd,
>                 },{
>                         .type   = CX88_VMUX_COMPOSITE1,
>                         .vmux   = 1,
>                         .gpio0  = 0x87f9,
>                 },{
>                         .type   = CX88_VMUX_SVIDEO,
>                         .vmux   = 2,
>                         .gpio0  = 0x87f9,
>                 }},
>                 .mpeg           = CX88_MPEG_DVB,
>         },
> 
> Notice that .vmux and .gpio0 are set very differently.  Evidently these 
> values were set according to the rules
> 
>  /*                                                                     
>                             
>                    GPIO[0] resets DT3302 DTV receiver                   
>                                            
>                     0 - reset asserted                                   
>                                           
>                     1 - normal operation                                 
>                                           
>                    GPIO[1] mutes analog audio output connector           
>                                           
>                     0 - enable selected source                           
>                                           
>                     1 - mute                                             
>                                           
>                    GPIO[2] selects source for analog audio output 
> connector                                        
>                     0 - analog audio input connector on tab             
>                                            
>                     1 - analog DAC output from CX23881 chip             
>                                            
>                    GPIO[3] selects RF input connector on tuner module   
>                                            
>                     0 - RF connector labeled CABLE                       
>                                           
>                     1 - RF connector labeled ANT                         
>                                           
>                    GPIO[4] selects high RF for QAM256 mode               
>                                           
>                     0 - normal RF                                       
>                                            
>                     1 - high RF                                         
>                                            
>                 */
> 
> which are found in the dvico fusionhdtv 3 section.  Of course, I could 
> just be grasping at straws.  I have included Michael on this email to 
> possibly shed some light on this.  I figure that .vmux and .gpio0 have 
> to be set differently so that it uses settings from the dvico board, but 
> then if I changed those values, it wouldn't be using settings from the 
> cx25840 driver.    

Well, you are grasping at straws but so is everyone else. :) You're the 
only person with the hardware and everyone else is working blind - so 
things are very slow moving. It's the best we can expect at this point.

You've raised an interesting point. Given that dvico have two gpio's 
that are audio related on another product it could well be that this 
card has a yet-unknown customer GPIO audio related configuration. RegSpy 
would show the GPIO configurations when running under windows, and this 
may help if we think it's GPIO related.

Other than that I'm drowning in 3 other Linux projects and I'm trying to 
support you with occasional emails, so if the responses feel limited 
it's largely because that's the only time I can give you right now. I 
don't have the hardware and this is pretty much a guess game - using a 
tree that I haven't even tested myself - which could have many other issues.

I would like to see this supported, but unless someone has a bright idea 
then I can't offer much other advise until my workload clears and I can 
get some quality time to look at the -audio tree generally.

If the work appears to stall, the best thing to do is to grab as much 
information as possible (regspy register dumps, important debug 
messages) and get the wiki up to date, so that when someone has time to 
dig back into this - the wiki will be a one-stop-shop for getting back 
up to speed.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
