Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:50536 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759340Ab0CNEk5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 23:40:57 -0500
Subject: Re: v4l-utils, dvb-utils, xawtv and alevt
From: hermann pitton <hermann-pitton@arcor.de>
To: Chicken Shack <chicken.shack@gmx.de>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <1268487819.2763.27.camel@brian.bconsult.de>
References: <201003090848.29301.hverkuil@xs4all.nl>
	 <1268197457.3199.17.camel@pc07.localdom.local> <4B98FABB.1040605@gmail.com>
	 <829197381003110631v52410d27m7e13d5438e09cd13@mail.gmail.com>
	 <4B9A6089.4060300@redhat.com>
	 <1a297b361003120820h768bc388n81077a4b6cfe71e6@mail.gmail.com>
	 <1268421039.1971.46.camel@brian.bconsult.de> <4B9B35E4.7070702@redhat.com>
	 <1268475324.1752.59.camel@brian.bconsult.de>  <4B9B8665.9080706@redhat.com>
	 <1268487819.2763.27.camel@brian.bconsult.de>
Content-Type: text/plain
Date: Sun, 14 Mar 2010 06:39:43 +0100
Message-Id: <1268545183.3228.55.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Samstag, den 13.03.2010, 14:43 +0100 schrieb Chicken Shack:
> Am Samstag, den 13.03.2010, 13:34 +0100 schrieb Hans de Goede:
> > Hi,
> > 
> > On 03/13/2010 11:15 AM, Chicken Shack wrote:
> > > Am Samstag, den 13.03.2010, 07:51 +0100 schrieb Hans de Goede:
> > >> Hi,
> > >>
> > >> On 03/12/2010 08:10 PM, Chicken Shack wrote:
> > >>> 1. Alevt 1.7.0 is not just another tool, but it is instead a
> > >>> self-contained videotext application consisting of three parts:
> > >>> a. alevt, b. alevt-date c. alevt-cap
> > >>>
> > >>> While the packed size of alevt is 78770 the complete size of the
> > >>> dvb-apps as a whole ranges around 350000.
> > >>>
> > >>> I am not against hosting this program at linuxtv.org, but if this
> > >>> decision is made the decision should be an intelligent one: alevt is a
> > >>> separate tree, and any other choice is simply a dumb one.
> > >>> Alevt-1.7.0 needs a lot of external dependencies, while the dvb-apps
> > >>> only need the libc6.

More clever would have been never to rename it from alevt-dvb to alevt.
On the prior you don't have any rights and I seriously doubt you have
any on the later.

> > > Good morning Hans,
> > >
> > 
> > Good afternoon :)
> > 
> > > Definitely not.
> > > 3.95 is analogue only and thus is discontinued as version.
> > > 4.0 pre is the alpha-state tarball that you can get here:

No, 3.95 is "official" and right for patching and 4x was never released.

I pointed to mpeg4ip only as a joke.

> > Ah, ok. Well I must honestly say I've no interest in that I'm doing
> > package maintenance for the 3.95 release in Fedora and I know it
> > needs a lot of patching, AFAIK other distros are doing the same,
> > so it would be good to have / become a new upstream for xawtv 3.95,
> > to have a place to gather all the distro patches mostly and release
> > that, and where new patches if needed can accumulate and new
> > releases can be done from.
> > 
> > 
> > > http://dl.bytesex.org/cvs-snapshots/xawtv-20081014-100645.tar.gz
> > >
> > > Inofficial end of development somewhere in 2005 or 2006, last external
> > > contribution from October 2008.

It was on March 08 2005. You even don't know that?

http://linux.bytesex.org/v4l2/maintainer.txt

Maybe improve your Pinnacle stuff first, I can point you to a lot on the
TODO list.

Hermann






