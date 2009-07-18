Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:53432 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbZGRA7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 20:59:52 -0400
Subject: Re: Report: Compro Videomate Vista T750F
From: hermann pitton <hermann-pitton@arcor.de>
To: Samuel Rakitnican <semirocket@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <op.uw4gkkks80yj81@localhost>
References: <op.uwycxowt80yj81@localhost>
	 <1247434386.5152.28.camel@pc07.localdom.local>
	 <op.uw4gkkks80yj81@localhost>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 02:58:56 +0200
Message-Id: <1247878736.4268.52.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 15.07.2009, 20:35 +0200 schrieb Samuel Rakitnican:
> On Sun, 12 Jul 2009 23:33:06 +0200, hermann pitton  
> <hermann-pitton@arcor.de> wrote:
> 
> > Hi Samuel,
> >
> > Am Sonntag, den 12.07.2009, 13:30 +0200 schrieb Samuel Rakitnican:
> >> As the card=139 (Compro Videomate T750)
> >>
> >> DVB: Not working, not implemented
> >> Analog: Not working
> >> Audio In: ? (my T750F has additional connector ?)
> >
> > if amux LINE2 doesn't work it is usually LINE1.
> > If both don't work, there is a external gpio controlled switch/mux chip.
> >
> > Default is loop through for external audio in.
> > Means, if the saa7134 driver is unloaded, should be passed through to
> > audio out. If not, there is such a mux chip involved.
> >
> [snip]
> 
> 
> 
> Well, I haven't managed to get sound from Audio In connector, it's  
> possible however that I'm doing something wrong. I tried selecting in  
> tvtime both Composite and S-Video, and I've tried using SoX:
> console$> ls /dev/dsp*
> dsp dsp1
> console$> sox -c 2 -s -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -r 32000  
> /dev/dsp &
> 
> for both .amux = LINE1 and LINE2 in saa7134-cards.c source file.
> 
> 
> 
> 
> RegSpy log:
> 
> I have used RegSpy that comes with DScaler version 4.1.15. I'm hoping that  
> they are of some use for both Analog television and Audio In.
> 
> I have found out values crucial to changing inputs for both audio and  
> video. Note that SAA7134_GPIO_GPSTATUS keeps changing all the time between  
> 84ff00 and 94bf00 nevertheless of the device status.
> 
> I have used VirtualDub (v1.7.7) as capturing application because it gives  
> more control on input selecting (I can change audio input, not depending  
> on video). From that I manage to distinguish values changing between video  
> and audio.
> 
> The crucial value for video seems to be SAA7134_ANALOG_IN_CTRL1 while for  
> audio seems to be values SAA7133_AUDIO_CLOCK_NOMINAL and  
> SAA7133_PLL_CONTROL.
> 
> Changes: State 0 -> State 1: *****************************(Switch: Analog  
> TV -> Composite)
> SAA7134_GPIO_GPSTATUS:           0094ff00 -> 0494ff00  (-----0-- --------  
> -------- --------)
> SAA7134_ANALOG_IN_CTRL1:         83       -> 81        (------1-)
> SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7 -> 43187de7  (-0------ --------  
> -------- --------)
> SAA7133_PLL_CONTROL:             03       -> 43        (-0------)
> 
> Changes: State 1 -> State 2: *****************************(Switch:  
> Composite -> S-Video)
> SAA7134_GPIO_GPSTATUS:           0494ff00 -> 0284ff00  (-----10- ---1----  
> -------- --------)
> SAA7134_ANALOG_IN_CTRL1:         81       -> 88        (----0--1)
> 
> Changes: State 2 -> State 3: ***(Switch: Audio Source -> Audio Tuner  
> (Still in S-Video mode))
> SAA7134_GPIO_GPSTATUS:           0284ff00 -> 0294ff00  (-------- ---0----  
> -------- --------)
> SAA7133_AUDIO_CLOCK_NOMINAL:     43187de7 -> 03187de7  (-1------ --------  
> -------- --------)  (same as 0)
> SAA7133_PLL_CONTROL:             43       -> 03         
> (-1------)                             (same as 0)
> 
> Changes: State 3 -> State 4: ******(Switch: Audio Source -> Audio Line  
> (Still in S-Video mode))
> SAA7134_GPIO_GPSTATUS:           0294ff00 -> 0484ff00  (-----01- ---1----  
> -------- --------)
> SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7 -> 43187de7  (-0------ --------  
> -------- --------)  (same as 1, 2)
> SAA7133_PLL_CONTROL:             03       -> 43         
> (-0------)                             (same as 1, 2)
> 
> (full log: http://pastebin.com/f5f8e6184)

Hi Samuel,

the above link still gives error not found.

For an external audio mux it is always a single gpio pin for that.

It is some same pin in the same state for composite and s-video,
but different for TV mode.

The above seems not to show such a pattern.

Also you missed to print GPIO_GPMODE, which is the gpio mask.
In that, pins actively used for switching are high, but m$ drivers do
often also have for that specific card unrelated pins high.

Gpio 8 to 15 are the remote gpios and gpio18 should be the key
press/release.

The rest above seems not to be consistent for what we are searching for.

If you get some time again, do a cold boot and dump the gpio mode and
state before any application did use the card.

Then dump analog TV, composite and s-video and anything else you can
test. The GPMODE and the GPSTATUS on top of any mode used is what is
really interesting.

It also prints the state of all gpios for each mode in binary, so if you
manually mark the states you used, one can just copy and paste line by
line and see the changing pins.

As said, it should be a pin in the mask/GPMODE being the same for
composite and s-video, but different for analog TV. Maybe better use the
Compro software to get the logs.

Cheers,
Hermann


