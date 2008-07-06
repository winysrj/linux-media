Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yoshi314@gmail.com>) id 1KFT2x-0004Kf-DV
	for linux-dvb@linuxtv.org; Sun, 06 Jul 2008 14:08:52 +0200
Received: by ug-out-1314.google.com with SMTP id m3so1037070uge.20
	for <linux-dvb@linuxtv.org>; Sun, 06 Jul 2008 05:08:47 -0700 (PDT)
Date: Sun, 6 Jul 2008 14:08:00 +0200
From: marcin kowalski <yoshi314@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080706120605.GA20756@localhost>
References: <51029ae90806300203p2d5fbf6bo7a28391b59553599@mail.gmail.com>
	<4868A644.5030806@onelan.co.uk>
	<1214870271.2623.33.camel@pc10.localdom.local>
	<20080701052044.GA3846@watanabe>
	<51029ae90807050218v3c10b69bl261690ac3d9ed680@mail.gmail.com>
	<20080705110322.GA3898@watanabe>
	<1215298603.3237.28.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1215298603.3237.28.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hvr-1300 analog audio question
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

On 00:56 Sun 06 Jul     , hermann pitton wrote:
> Hi yoshi/marcin,
> 
> Am Samstag, den 05.07.2008, 13:03 +0200 schrieb marcin kowalski:
> > On 11:18 Sat 05 Jul     , yoshi watanabe wrote:
> > > one small update. when i run the arecord | aplay combo with these parameters :
> > > 
> > > arecord -D hw:1,0 -c 2 -f S16 --period-size=8192 --buffer-size=524288 | aplay -
> > > 
> > > or with omitting the --period-size=8192 --buffer-size=524288
> > > 
> > > i hear noise. but when i start tvtime, right after video appears on
> > > screen i usually get 1-2 seconds of clear audio, and then noise comes
> > > in. i might be on to something. when i discard the buffering
> > > parameters sometimes arecord or aplay complain about buffer underrun.
> > > tvtime does not use cx88 mixes by default, by if i specify /
> > > 
> > > also this command
> > >  arecord -D hw:1,0 -c 2 -f S16_LE --period-size=65536
> > > --buffer-size=524288 -r 48000| aplay -r 48000 -
> > > 
> > > gives me very few errors now. noise pick ups when the sounds get
> > > louder though, but feel i'm really close now.
> > > 
> > > this is on a freshly installed system with mpeg encoder module
> > > disabled. i'll do some more testing.
> > > 
> > > 
> > this mail got strangely garbled when i sent it. it certainly didn't look like this when i sent it.
> > 
> > the thing is - i'm pretty close to success. i'll try building cx88 modules from ~rmcc branch to see whether they make a 
> > difference.
> 
> garbling always happens, but did not reach me in this case.
> 
> My comment was only meant as a side note.

by garbling i meant that part of the mail vanished and it lacks sense in the middle (around the '\' character). gaah, 
nevermind that :]
> 
> Did you try "sox"? For uncompensated audio clocks it usually works
> better.
> 
i'll see what happens. good idea.

> I'm far away from any playstation stuff.
> 
> AFAIK, it has noninterlaced output on the RF connector, are you on that
> one?
> 
i'm pretty green at this stuff, i'll have to read on what 'RF connector' is before i can answer you ;-) my a/v 
related english vocabulary is really lacking.

> What about the s-video and composite outputs and audio directly
> connected to the sound card input?
> 
> Cheers,
> Hermann
> 

doh! i never thought of that :]

i'll have to re-check my audio inputs and try it - i have on-board nvidia cx804 audio chip (uses snd-intel8x0 driver) 
and it has way too many connectors (at least 8) :]


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
