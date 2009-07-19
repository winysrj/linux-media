Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:32814 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbZGSXVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 19:21:44 -0400
Subject: Re: Report: Compro Videomate Vista T750F
From: hermann pitton <hermann-pitton@arcor.de>
To: Samuel =?UTF-8?Q?Rakitni=C4=8Dan?= <semirocket@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <op.uw9ek3vot7szun@crni.lan>
References: <op.uwycxowt80yj81@localhost>
	 <1247434386.5152.28.camel@pc07.localdom.local>
	 <op.uw4gkkks80yj81@localhost>
	 <1247878736.4268.52.camel@pc07.localdom.local> <op.uw9ek3vot7szun@crni.lan>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Jul 2009 01:16:27 +0200
Message-Id: <1248045387.10911.13.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Samuel,

Am Samstag, den 18.07.2009, 12:40 +0200 schrieb Samuel Rakitničan:
> Hi,
> 
> On Sat, 18 Jul 2009 02:58:56 +0200, hermann pitton  
> <hermann-pitton@arcor.de> wrote:
> 
> >> (full log: http://pastebin.com/f5f8e6184)
> >
> > Hi Samuel,
> >
> > the above link still gives error not found.
> >
> 
> Strange, because to me works just fine. I'm going to add it directly as an  
> email attachement this time.

oops, it was just that bracket in that link.

> > For an external audio mux it is always a single gpio pin for that.
> >
> > It is some same pin in the same state for composite and s-video,
> > but different for TV mode.
> >
> > The above seems not to show such a pattern.
> >
> > Also you missed to print GPIO_GPMODE, which is the gpio mask.
> > In that, pins actively used for switching are high, but m$ drivers do
> > often also have for that specific card unrelated pins high.
> >
> > Gpio 8 to 15 are the remote gpios and gpio18 should be the key
> > press/release.
> >
> > The rest above seems not to be consistent for what we are searching for.
> >
> > If you get some time again, do a cold boot and dump the gpio mode and
> > state before any application did use the card.
> >
> > Then dump analog TV, composite and s-video and anything else you can
> > test. The GPMODE and the GPSTATUS on top of any mode used is what is
> > really interesting.
> >
> 
> As I mentioned before GPSTATUS keeps changing all the time (And I mean  
> frequent, measurable in miliseconds), and it seems that it hasn't any  
> connection between other values.
> 
> > It also prints the state of all gpios for each mode in binary, so if you
> > manually mark the states you used, one can just copy and paste line by
> > line and see the changing pins.
> >
> > As said, it should be a pin in the mask/GPMODE being the same for
> > composite and s-video, but different for analog TV. Maybe better use the
> > Compro software to get the logs.
> >
> 
> The mask/GPMODE doesn't change at all.

That is at least good ;)
Mask changes have been seen previously too.

> I have used Compro software this time.

Looked at it yesterday, but for an external gpio driven amux it seems
not to have anything consistent.

gpio dumps with virtualdub

8082c000   (10000000 10000010 11000000 00000000) gpio_mask

0094ff00 * (00000000 10010100 11111111 00000000) TV
0494ff00 * (00000100 10010100 11111111 00000000) Composite
0284ff00 * (00000010 10000100 11111111 00000000) S-Video

0294ff00 * (00000010 10010100 11111111 00000000) audio tuner still in S-Video
0484ff00 * (00000100 10000100 11111111 00000000) audio line still in S-Video

-------------------------------------------

gpio dumps with Compro software

8082c000   (10000000 10000010 11000000 00000000) gpio mask

0284ff00 * (00000010 10000100 11111111 00000000) nothing runs
0694ff00 * (00000110 10010100 11111111 00000000) nothing runs
0294ff00 * (00000010 10010100 11111111 00000000) nothing runs
0084ff00 * (00000000 10000100 11111111 00000000) nothing runs
0494ff00 * (00000100 10010100 11111111 00000000) nothing runs
0884ff00 * (00001000 10000100 11111111 00000000) analog TV
0494ff00 * (00000100 10010100 11111111 00000000) Composite
0084ff00 * (00000000 10000100 11111111 00000000) S-Video
0694ff00 * (00000110 10010100 11111111 00000000) DVB-T
0c84ff00 * (00001100 10000100 11111111 00000000) back to analog

For an gpio switch of an external amux, that pin would be high in the
mask for all what was seen previously. Nothing like that.

Eventually gpio-27 high could mean something for the tuner, but why it
should mean something when virtualdub works for the tuner without it?

I leave it to those more experienced.

Cheers,
Hermann






