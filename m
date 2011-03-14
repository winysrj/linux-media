Return-path: <mchehab@pedra>
Received: from cantor2.suse.de ([195.135.220.15]:43573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab1CNK31 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 06:29:27 -0400
Date: Mon, 14 Mar 2011 11:29:26 +0100
Message-ID: <s5h1v2ahu61.wl%tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>, jirislaby@gmail.com,
	alsa-devel@alsa-project.org,
	"Kernel development list" <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [alsa-devel] radio-maestro broken (conflicts with snd-es1968)
In-Reply-To: <201103141128.01259.linux@rainbow-software.org>
References: <201103121919.05657.linux@rainbow-software.org>
	<s5hei6ahvtu.wl%tiwai@suse.de>
	<df650e295afbf5651be743e58b06eb5b.squirrel@webmail.xs4all.nl>
	<201103141128.01259.linux@rainbow-software.org>
MIME-Version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-Type: text/plain; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

At Mon, 14 Mar 2011 11:28:01 +0100,
Ondrej Zary wrote:
> 
> On Monday 14 March 2011, Hans Verkuil wrote:
> > > At Sat, 12 Mar 2011 19:52:39 +0100,
> > >
> > > Hans Verkuil wrote:
> > >> On Saturday, March 12, 2011 19:19:00 Ondrej Zary wrote:
> > >> > Hello,
> > >> > the radio-maestro driver is badly broken. It's intended to drive the
> > >>
> > >> radio on
> > >>
> > >> > MediaForte ESS Maestro-based sound cards with integrated radio (like
> > >> > SF64-PCE2-04). But it conflicts with snd_es1968, ALSA driver for the
> > >>
> > >> sound
> > >>
> > >> > chip itself.
> > >> >
> > >> > If one driver is loaded, the other one does not work - because a
> > >>
> > >> driver is
> > >>
> > >> > already registered for the PCI device (there is only one). This was
> > >>
> > >> probably
> > >>
> > >> > broken by conversion of PCI probing in 2006:
> > >> > ttp://lkml.org/lkml/2005/12/31/93
> > >> >
> > >> > How to fix it properly? Include radio functionality in snd-es1968 and
> > >>
> > >> delete
> > >>
> > >> > radio-maestro?
> > >>
> > >> Interesting. I don't know anyone among the video4linux developers who
> > >> has
> > >> this hardware, so the radio-maestro driver hasn't been tested in at
> > >> least
> > >> 6 or 7 years.
> > >>
> > >> The proper fix would be to do it like the fm801.c alsa driver does: have
> > >> the radio functionality as an i2c driver. In fact, it would not surprise
> > >> me at all if you could use the tea575x-tuner.c driver (in
> > >> sound/i2c/other)
> > >> for the es1968 and delete the radio-maestro altogether.
> > >
> > > I guess simply porting radio-maestro codes into snd-es1968 would work
> > > without much hustles, and it's a bit safe way to go for now; smaller
> > > changes have less chance for breakage, and as little people seem using
> > > this driver, it'd be better to take a safer option, IMO.
> >
> > I assume someone has hardware since someone reported this breakage. So try
> > to use tuner-tea575x for the es1968. It shouldn't be too difficult.
> > Additional cleanup should probably wait until we find a tester for the
> > fm801 as well.
> 
> I have the hardware - both ES1968 (SF64-PCE2-04) and FM801 cards (SF64-PCR) 
> with these tuners. I remember fixing mute in tea5757x-tuner back in 2009 
> (testing it on SF64-PCR).
> 
> > I don't like the idea to duplicate code.
> 
> I don't like that either. I've done a quick hack - copied radio support from 
> fm801 and radio_bits_get() and radio_bits_set() from radio-maestro to es1968 
> and it seems to basically work.
> Now I just need some more time to finish it, then move everything good from 
> radio-maestro to tea575x-tuner and delete radio-maestro.

Great!


Takashi
