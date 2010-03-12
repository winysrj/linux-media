Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39048 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932808Ab0CLTLl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 14:11:41 -0500
Subject: v4l-utils, dvb-utils, xawtv and alevt (was: v4l-utils: i2c-id.h
 and alevt)
From: Chicken Shack <chicken.shack@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <1a297b361003120820h768bc388n81077a4b6cfe71e6@mail.gmail.com>
References: <201003090848.29301.hverkuil@xs4all.nl>
	 <1268197457.3199.17.camel@pc07.localdom.local> <4B98FABB.1040605@gmail.com>
	 <829197381003110631v52410d27m7e13d5438e09cd13@mail.gmail.com>
	 <4B9A6089.4060300@redhat.com>
	 <1a297b361003120820h768bc388n81077a4b6cfe71e6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 20:10:39 +0100
Message-ID: <1268421039.1971.46.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 12.03.2010, 20:20 +0400 schrieb Manu Abraham:
> On Fri, Mar 12, 2010 at 7:40 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> > Hi,
> >
> > On 03/11/2010 03:31 PM, Devin Heitmueller wrote:
> >>
> >> On Thu, Mar 11, 2010 at 9:14 AM, Douglas Schilling Landgraf
> >> <dougsland@gmail.com>  wrote:
> >>>
> >>> On 03/10/2010 02:04 AM, hermann pitton wrote:
> >>>>
> >>>> Hi Hans, both,
> >>>>
> >>>> Am Dienstag, den 09.03.2010, 08:48 +0100 schrieb Hans Verkuil:
> >>>>>
> >>>>> It's nice to see this new tree, that should be make it easier to
> >>>>> develop
> >>>>> utilities!
> >>>>>
> >>>>> After a quick check I noticed that the i2c-id.h header was copied from
> >>>>> the
> >>>>> kernel. This is not necessary. The only utility that includes this is
> >>>>> v4l2-dbg
> >>>>> and that one no longer needs it. Hans, can you remove this?
> >>>>>
> >>>>> The second question is whether anyone would object if alevt is moved
> >>>>> from
> >>>>> dvb-apps to v4l-utils? It is much more appropriate to have that tool in
> >>>>> v4l-utils.
> >>>>
> >>>> i wonder that this stays such calm, hopefully a good sign.
> >>>>
> >>>> In fact alevt analog should come with almost every distribution, but the
> >>>> former alevt-dvb, named now only alevt, well, might be ok in some
> >>>> future, is enhanced for doing also dvb-t-s and hence there ATM.
> >>>>
> >>>>> Does anyone know of other unmaintained but useful tools that we might
> >>>>> merge
> >>>>> into v4l-utils? E.g. xawtv perhaps?
> >>>>
> >>>> If for xawtv could be some more care, ships also since close to ever
> >>>> with alevtd, that would be fine, but I'm not sure we are talking about
> >>>> tools anymore in such case, since xawtv4x, tvtime and mpeg4ip ;) for
> >>>> example are also there and unmaintained.
> >>>>
> >>>
> >>> I think would be nice to hear a word from Devin, which have been working
> >>> in tvtime. Devin?
> >>
> >> Sorry, I've been sick for the last couple of days and not actively on
> >> email.
> >>
> >> I don't think it's a good idea to consolidate applications like xawtv
> >> and tvtime into the v4l2-utils codebase.  The existing v4l2-utils is
> >> nice because it's small and what the packages provides what it says it
> >> does - v4l2 *utilities*.  I wouldn't consider full blown tv viewing
> >> applications to be "utilities".
> >>
> >> The apps in question are currently packaged by multiple distros today
> >> as standalone packages.  Today distros can decide whether they want
> >> the "bloat" associated with large GUI applications just to get the
> >> benefits of a couple of command line utilities.  Bundling them
> >> together makes that much harder (and would also result in a package
> >> with lots of external dependencies on third party libraries).
> >>
> >> Adding them into v4l2-utils doesn't really solve the real problem -
> >> that there are very few people willing to put in the effort to
> >> extend/improve these applications (something which, as Douglas pointed
> >> out, I'm trying to improve in the case of tvtime).
> >>
> >
> > Ack,
> 
> 
> ACK
> 
> > What would be good to do IMHO is decide for unmaintained apps like xawtv
> > and alevt if we want to adopt them and if we do, to create separate git
> > trees for them, and become a new upstream including doing regular
> > tarbals releases. Some time ago I did a lot of work on the Fedora xawtv
> > packages and I would be willing to pull such an effort for xawtv.
> 
> 
> Simply creating a tree for an application doesn't really help. At
> least it needs a "commitment" to that app to keep it updated. Unless,
> someone really puts in such an effort, creating a tree doesn't really
> help, it simplyt adds to the confusion for a normal user as to where
> he should download his application for his distro, if such a package
> doesn't exist.
> 
> 
> Regards,
> Manu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi people,

just my 1 Euro as contribution here:

Your merging hysteria and the resulting "discussion" is simply nonsense
IMHO.

In how far?

1. Alevt 1.7.0 is not just another tool, but it is instead a
self-contained videotext application consisting of three parts:
a. alevt, b. alevt-date c. alevt-cap

While the packed size of alevt is 78770 the complete size of the
dvb-apps as a whole ranges around 350000.

I am not against hosting this program at linuxtv.org, but if this
decision is made the decision should be an intelligent one: alevt is a
separate tree, and any other choice is simply a dumb one.
Alevt-1.7.0 needs a lot of external dependencies, while the dvb-apps
only need the libc6.

2. Xawtv-4.0 pre is not usable as a whole. Thus you cannot treat it as a
whole. And that's exactly why you cannot discuss it as a whole!

The usable parts are:

a. mtt: a slave videotext application which is running independently
from the master application tuning the channels.
Its packed size amounts to 107744.

b. dvbrowse: a slave EPG application which is running independently from
the master application tuning the channels.
Packed Size: 101267.

c. dvbradio: a fast and rather stable running application for watching
DVB radio streams.
Packed Size: 119957.
Problem: dvbradio would need investigation to understand channel lists
in vdr channels.conf format.
As long as this is not the case, the insane slow homebrew scanner called
alexplore is necessary to produce a channels list.
Gerd implied some vdr modules into thew package, but they are
ca. unfinished work
cb. for debug purposes only


The unusable parts are:

a. xawtv itself, the main program.
It never ran stable and it is unfinished work.
Its graphical capabilities are pure rubbish compared to todays
standards.

b. Lots of aged tools like scantv or radio who just have survived
somehow but weren't modified.


Conclusions:

Alevt and mtt are videotext programs who are self-contained. They both
serve for analogue AND for DVB usage.
In so far the MA decision to merge alevt into dvb-apps was and still
remains idiotic.
The discussion to merge it into the v4l-utils isn't more intelligent
either.

You can maintain this discontinued stuff at linuxtv.org, but if you do
then please stop these completely insane merging activities.

Shall MA merge his vegetarian recipe pap in India - no problem!
But I do not want him to maintain software at linuxtv.org, no matter
what kind of software it may be.
We need reliable maintainers - not moody primadonna-would-like-tos!

Cheers

Uwe


