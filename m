Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47078 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751824Ab0CMNol (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 08:44:41 -0500
Subject: Re: v4l-utils, dvb-utils, xawtv and alevt
From: Chicken Shack <chicken.shack@gmx.de>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <4B9B8665.9080706@redhat.com>
References: <201003090848.29301.hverkuil@xs4all.nl>
	 <1268197457.3199.17.camel@pc07.localdom.local> <4B98FABB.1040605@gmail.com>
	 <829197381003110631v52410d27m7e13d5438e09cd13@mail.gmail.com>
	 <4B9A6089.4060300@redhat.com>
	 <1a297b361003120820h768bc388n81077a4b6cfe71e6@mail.gmail.com>
	 <1268421039.1971.46.camel@brian.bconsult.de> <4B9B35E4.7070702@redhat.com>
	 <1268475324.1752.59.camel@brian.bconsult.de>  <4B9B8665.9080706@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Mar 2010 14:43:39 +0100
Message-ID: <1268487819.2763.27.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 13.03.2010, 13:34 +0100 schrieb Hans de Goede:
> Hi,
> 
> On 03/13/2010 11:15 AM, Chicken Shack wrote:
> > Am Samstag, den 13.03.2010, 07:51 +0100 schrieb Hans de Goede:
> >> Hi,
> >>
> >> On 03/12/2010 08:10 PM, Chicken Shack wrote:
> >>> 1. Alevt 1.7.0 is not just another tool, but it is instead a
> >>> self-contained videotext application consisting of three parts:
> >>> a. alevt, b. alevt-date c. alevt-cap
> >>>
> >>> While the packed size of alevt is 78770 the complete size of the
> >>> dvb-apps as a whole ranges around 350000.
> >>>
> >>> I am not against hosting this program at linuxtv.org, but if this
> >>> decision is made the decision should be an intelligent one: alevt is a
> >>> separate tree, and any other choice is simply a dumb one.
> >>> Alevt-1.7.0 needs a lot of external dependencies, while the dvb-apps
> >>> only need the libc6.
> >
> > Good morning Hans,
> >
> 
> Good afternoon :)
> 
> > Definitely not.
> > 3.95 is analogue only and thus is discontinued as version.
> > 4.0 pre is the alpha-state tarball that you can get here:
> >
> 
> Ah, ok. Well I must honestly say I've no interest in that I'm doing
> package maintenance for the 3.95 release in Fedora and I know it
> needs a lot of patching, AFAIK other distros are doing the same,
> so it would be good to have / become a new upstream for xawtv 3.95,
> to have a place to gather all the distro patches mostly and release
> that, and where new patches if needed can accumulate and new
> releases can be done from.
> 
> 
> > http://dl.bytesex.org/cvs-snapshots/xawtv-20081014-100645.tar.gz
> >
> > Inofficial end of development somewhere in 2005 or 2006, last external
> > contribution from October 2008.
> >
> > 4.0 pre introduced DVB support for mtt (videotext) and the main program
> > xawtv.
> > It also introduced this disgusting slow channel scanner called alexplore
> > (DVB only) and dvbrowse as a complete new EPG solution for DVB only.
> > And it introduced dvbradio which would be excellent after some
> > investigation (->  learn to interpret channels.conf files).
> >
> 
> I see, well if there is an interest in bits of the 4.0 code base, then
> grabbing those bits and having a tree with them and doing regular
> tarbal releases for distro's to consume might be in interesting project
> for some one. I would like to advocate to not call this xawtv, as AFAIK
> all distros are still shipping 3.95, and as you said the xawtv part of 4.0
> is broken so likely would not be included, at which point it
> would be good to no longer call the resulting project xawtv.
> 
> Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Good afternoon Hans :)

"and as you said the xawtv part of 4.0 is broken so likely would not be
included, at which point it would be good to no longer call the
resulting project xawtv."

Pooh! Guess you got me wrong again.....

You can watch TV with xawtv 4.0 pre in analogue mode.
But if you want to record a film parallely you need
to execute streamer on the command line, as the graphical support
for starting the recording session will not work at all.

In DVB mode parallel tasking works.
The fact that I had many broken recordings can also be due to a
former bad kernel / bad DVB driver. This happened years ago and
thus I lost interest in xawtv as a common.
In the meantime the kernel drivers have become more mature and
I do not work with the same DVB card any longer.
Got a better card now and better drivers (Flexcop Technisat).
In spite of all changes the overlay capabilities of xawtv still remain a mess.

There should be a separate tree for alevt plus one separate tree called
"hybrid tools" combining all the orphaned software that does not fit into the
200-liner-scheme of v4l-utils and / or dvb-utils.

Linuxtv.org should not be a cemetery for orphaned software and it shouldn't
be reduced to a highly specialized milk farm for kernel drivers only where
the cows go "Mauro, please pull...".

There should be enough appropriate people to establish a functionable service
mode in which discussed issues also are being put into practice.....

Cheers

Uwe


