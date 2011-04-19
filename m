Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:41989 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754579Ab1DSMSN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 08:18:13 -0400
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
From: Andy Walls <awalls@md.metrocast.net>
To: Eric B Munson <emunson@mgebm.net>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	mchehab@infradead.org, linux-media@vger.kernel.org
In-Reply-To: <20110418224855.GB4611@mgebm.net>
References: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com>
	 <1301922737.5317.7.camel@morgan.silverblock.net>
	 <BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
	 <BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
	 <1302015521.4529.17.camel@morgan.silverblock.net>
	 <BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com>
	 <1302481535.2282.61.camel@localhost> <20110411163239.GA4324@mgebm.net>
	 <20110418141514.GA4611@mgebm.net>
	 <ac791492-7bc5-4a78-92af-503dda599346@email.android.com>
	 <20110418224855.GB4611@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 08:18:43 -0400
Message-ID: <1303215523.2274.27.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-04-18 at 18:48 -0400, Eric B Munson wrote:
> On Mon, 18 Apr 2011, Andy Walls wrote:
> 
> > Eric B Munson <emunson@mgebm.net> wrote:
> > 
> > >On Mon, 11 Apr 2011, Eric B Munson wrote:
> > >
> > >> On Sun, 10 Apr 2011, Andy Walls wrote:
> > >> 
> > >> > On Wed, 2011-04-06 at 13:28 -0400, Eric B Munson wrote:
> > >> > > On Tue, Apr 5, 2011 at 10:58 AM, Andy Walls

> > >
> > >Is there anything else I can provide to help with this?
> > 
> > Eric,
> > 
> > Sorry for not getting back sooner (I've been dealing with a personal
> situation and haven't logged into my dev system for a few weeks).
> > 
> > What rf analog source are you using?
> 
> Sorry, very new to this, I am not sure what you are asking for here.

I mean: analog cable, DTV Set Top Box (STB), VCR, etc.

I have only tested the driver on analog US Broadcast Channel 3, since I
only have a DTV STB as an RF analog TV source.



> > Have you used v4l2-ctl to ensure the tuner is set to the right tv
> standard (my changes default to NTSC-M)?
> 
> emunson@grover:~$ v4l2-ctl -S
> Video Standard = 0x0000b000
> 	NTSC-M/M-JP/M-KR
> emunson@grover:~$ v4l2-ctl -s ntsc
> Standard set to 0000b000
> emunson@grover:~$ v4l2-ctl -S
> Video Standard = 0x0000b000
> 	NTSC-M/M-JP/M-KR
> 
> What should the default be?  NTSC-443?  When I set to NTSC-443 I see
> the same behaviour as below when I try and change channels.

NTSC-M is the default.  Having it set to autodetect the US, Japanese
(-JP), or South Korean (-KR) variants is OK.

Never use NTSC-443 as you likely will never encounter it in your life.
NTSC-443 is never broadcast over the air or cable.  It is a weird
combination of NTSC video usings a PAL color subcarrier frequency.




> > Have you used v4l2-ctl or ivtv-tune to tune to the proper tv channel
> (the driver defaults to US channel 4)?
> 
> emunson@grover:~$ v4l2-ctl -F
> Frequency: 0 (0.000000 MHz)
> emunson@grover:~$ v4l2-ctl -f 259.250
> Frequency set to 4148 (259.250000 MHz)
> emunson@grover:~$ v4l2-ctl -F
> Frequency: 0 (0.000000 MHz)

OK, that doesn't look good.  The tda18271 tuner and/or tda8290 demod
drivers may not be working right.

I'll have to look into that later this week.

BTW, Mike Krufky just submitted some patches that may be relevant:

	http://kernellabs.com/hg/~mkrufky/tda18271-fix


> 
> > Does v4l2-ctl --log-status still show no signal present for the '843 core in the CX23418?
> 
> Yeah,
>    [94465.349721] cx18-0 843: Video signal:              not present

The tuner or demod isn't tuning to a channel or getting a signal.

Can you try channel 3 (61.250 MHz)?  That one works for me.


> > Does mplayer /dev/videoN -cache 8192 have a tv station when set to the rf analog input with v4l2-ctl?
> 
> emunson@grover:~$ mplayer /dev/video0 -cache 8192
> MPlayer 1.0rc4-4.4.5 (C) 2000-2010 MPlayer Team
> 
> Playing /dev/video0.
> Cache fill:  0.00% (0 bytes)
> 
> 
> Exiting... (End of file)

Hmmm.  I would have expected at least a black picture with snow, if not
tuned to a channel.

Does analog S-Video or Composite work?


Regards,
Andy

> > 
> > From what I recall the analog tuner init looked ok.
> > -Andy
> > 


