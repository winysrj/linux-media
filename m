Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KDTIf-0003F3-3U
	for linux-dvb@linuxtv.org; Tue, 01 Jul 2008 02:00:51 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
In-Reply-To: <4868A644.5030806@onelan.co.uk>
References: <51029ae90806300203p2d5fbf6bo7a28391b59553599@mail.gmail.com>
	<4868A644.5030806@onelan.co.uk>
Date: Tue, 01 Jul 2008 01:57:51 +0200
Message-Id: <1214870271.2623.33.camel@pc10.localdom.local>
Mime-Version: 1.0
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

Hi,

Am Montag, den 30.06.2008, 10:24 +0100 schrieb Simon Farnsworth:
> yoshi watanabe wrote:
> > hello.
> > 
> > i'm using hauppauge hvr-1300 to receive video signal from playstation2
> > console, pal model. video is just fine, but i'm having strange audio
> > issues, but judging by some searching i did - that's pretty common
> > with this card , although people have varied experience with the card.
> > 
> 
> I've had similar issues with SAA7134 based cards, which were resolved by 
>   changing audio parameters.
> 
> If your problem is the same as mine was, try:
> arecord --format=S16 \
>          --rate=32000 \
>          --period-size=8192 \
>          --buffer-size=524288 | aplay
> 
> This forces 32kHz sampling, and gives the card lots of buffer space to 
> play with.

32kHz is true for saa713x TV audio dma sampling, saa7130 has no support
at all for it.

But 48Khz is default on cx88 stuff.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
