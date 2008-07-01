Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yoshi314@gmail.com>) id 1KDYIo-0005qr-9r
	for linux-dvb@linuxtv.org; Tue, 01 Jul 2008 07:21:19 +0200
Received: by ug-out-1314.google.com with SMTP id m3so354647uge.20
	for <linux-dvb@linuxtv.org>; Mon, 30 Jun 2008 22:21:14 -0700 (PDT)
Date: Tue, 1 Jul 2008 07:20:44 +0200
From: marcin kowalski <yoshi314@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080701052044.GA3846@watanabe>
References: <51029ae90806300203p2d5fbf6bo7a28391b59553599@mail.gmail.com>
	<4868A644.5030806@onelan.co.uk>
	<1214870271.2623.33.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1214870271.2623.33.camel@pc10.localdom.local>
Cc: linux-dvb <linux-dvb@linuxtv.org>
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

On 01:57 Tue 01 Jul     , hermann pitton wrote:
> Hi,
> 
> Am Montag, den 30.06.2008, 10:24 +0100 schrieb Simon Farnsworth:
> > yoshi watanabe wrote:
> > > hello.
> > > 
> > > i'm using hauppauge hvr-1300 to receive video signal from playstation2
> > > console, pal model. video is just fine, but i'm having strange audio
> > > issues, but judging by some searching i did - that's pretty common
> > > with this card , although people have varied experience with the card.
> > > 
> > 
> > I've had similar issues with SAA7134 based cards, which were resolved by 
> >   changing audio parameters.
> > 
> > If your problem is the same as mine was, try:
> > arecord --format=S16 \
> >          --rate=32000 \
> >          --period-size=8192 \
> >          --buffer-size=524288 | aplay
> > 
> > This forces 32kHz sampling, and gives the card lots of buffer space to 
> > play with.
> 
> 32kHz is true for saa713x TV audio dma sampling, saa7130 has no support
> at all for it.
> 
> But 48Khz is default on cx88 stuff.
> 
> Cheers,
> Hermann
> 
i guess that means i'm back to square one. it's pretty strange that noise gets more intense when 
there is more movement in the video (more dynamic scenes = much more noise). but that doesn't mean that when there is 
static screen displayed it works perfectly. it's more random than that.

i wonder whether mpeg encoder might be interfering with the audio signal (audio in mpeg stream is always perfectly 
clear). maybe i should try to disable it (by removing the firmware from /lib/firmware, or the module from the kernel) ?

i guess i'll have to check around the branches, maybe somebody has some interesting patches that didn't make it into 
main v4l-dvb tree yet.

anyway, thanks for your help.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
