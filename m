Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38183 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933489Ab0CMKRN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 05:17:13 -0500
Subject: Re: v4l-utils, dvb-utils, xawtv and alevt
From: Chicken Shack <chicken.shack@gmx.de>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <4B9B35E4.7070702@redhat.com>
References: <201003090848.29301.hverkuil@xs4all.nl>
	 <1268197457.3199.17.camel@pc07.localdom.local> <4B98FABB.1040605@gmail.com>
	 <829197381003110631v52410d27m7e13d5438e09cd13@mail.gmail.com>
	 <4B9A6089.4060300@redhat.com>
	 <1a297b361003120820h768bc388n81077a4b6cfe71e6@mail.gmail.com>
	 <1268421039.1971.46.camel@brian.bconsult.de>  <4B9B35E4.7070702@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Mar 2010 11:15:24 +0100
Message-ID: <1268475324.1752.59.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 13.03.2010, 07:51 +0100 schrieb Hans de Goede:
> Hi,
> 
> On 03/12/2010 08:10 PM, Chicken Shack wrote:
> > 1. Alevt 1.7.0 is not just another tool, but it is instead a
> > self-contained videotext application consisting of three parts:
> > a. alevt, b. alevt-date c. alevt-cap
> >
> > While the packed size of alevt is 78770 the complete size of the
> > dvb-apps as a whole ranges around 350000.
> >
> > I am not against hosting this program at linuxtv.org, but if this
> > decision is made the decision should be an intelligent one: alevt is a
> > separate tree, and any other choice is simply a dumb one.
> > Alevt-1.7.0 needs a lot of external dependencies, while the dvb-apps
> > only need the libc6.

Good morning Hans,

> >
> 
> Seems we agree here, becoming a new upstream for alevt is good, merging
> it into another package is not good :)

Yeah, exactly, as we're NOT talking about just another 200-liner........

> > 2. Xawtv-4.0 pre is not usable as a whole. Thus you cannot treat it as a
> > whole. And that's exactly why you cannot discuss it as a whole!
> >
> 
> Actually when I was talking about doing a tree to collect distro packages
> and serve as a new upstream for xawtv I was talking about xawtv version
> 3.95, is that the same as which you call xawtv-4.0 pre ?

Definitely not.
3.95 is analogue only and thus is discontinued as version.
4.0 pre is the alpha-state tarball that you can get here:

http://dl.bytesex.org/cvs-snapshots/xawtv-20081014-100645.tar.gz

Inofficial end of development somewhere in 2005 or 2006, last external
contribution from October 2008.

4.0 pre introduced DVB support for mtt (videotext) and the main program
xawtv.
It also introduced this disgusting slow channel scanner called alexplore
(DVB only) and dvbrowse as a complete new EPG solution for DVB only.
And it introduced dvbradio which would be excellent after some
investigation (-> learn to interpret channels.conf files).

> > The usable parts are:
> >
> > a. mtt: a slave videotext application which is running independently
> > from the master application tuning the channels.
> > Its packed size amounts to 107744.
> >
> > b. dvbrowse: a slave EPG application which is running independently from
> > the master application tuning the channels.
> > Packed Size: 101267.
> >
> > c. dvbradio: a fast and rather stable running application for watching
> > DVB radio streams.
> > Packed Size: 119957.
> > Problem: dvbradio would need investigation to understand channel lists
> > in vdr channels.conf format.
> > As long as this is not the case, the insane slow homebrew scanner called
> > alexplore is necessary to produce a channels list.
> > Gerd implied some vdr modules into thew package, but they are
> > ca. unfinished work
> > cb. for debug purposes only
> >
> >
> > The unusable parts are:
> >
> > a. xawtv itself, the main program.
> > It never ran stable and it is unfinished work.
> > Its graphical capabilities are pure rubbish compared to todays
> > standards.
> >
> 
> ??
> 
> Its UI is not a brilliant piece of work but it is usable and certainly
> is stable. Actually it still is my preffered app for tvcard testing / usage.

Hmmm. I'm not talking about the UI because I avoid discussions about
taste.
If you take a close critical look at the overlay capabilities you must
admit that they are technically reactionary. Not worth to be discussed
at all.
And I really do not know where the reason for the technical limitation
lies. Athena Widgets?
When I am looking TV through a monitor or modern flatscreen I expect a
full screen overlay picture covering the whole monitor's / sreen's size.
xawtv is not capable to offer that. Mplayer offers that f. ex.

The recording function of xawtv is tricky, while tvtime does not offer
any recording function. Thus it's not that easy to say: This one or that
one is best choice for testing / using.....

TVtime is the best compromise for analogue TV, Kaffeine is the best
compromise for DVB TV.
Note that I am stressing "compromise" - I do not say "choice".

> > b. Lots of aged tools like scantv or radio who just have survived
> > somehow but weren't modified.

> If these are really useless we could certainly drop them, as we could
> drop say v4l-ctl once we've got rid of the last v4l1 drivers.

Sure. There is also some obscure webcam tool for adressing USB webcams
via xawtv.
Streamer is exposed to be a quite flexible crossover recording tool for
command line usage, DVB and analogue.

Xawtv as main program runs stable as version 3.95 for analogue usage.
But I was not mentioning outdated analogue stuff.
Xawtv as main program runs highly unstable as version 4.0 pre for DVB
usage. Besides the overlay problem mentioned above I have had many
broken recordings due to its incomplete state.

> Regards,

> Hans

Best Regards

Uwe


