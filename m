Return-path: <linux-media-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:46982 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZA1VBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 16:01:30 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1363270nfc.21
        for <linux-media@vger.kernel.org>; Wed, 28 Jan 2009 13:01:27 -0800 (PST)
Date: Wed, 28 Jan 2009 22:01:07 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Tobias Stoeber <tobi@to-st.de>
cc: linux-media@vger.kernel.org,
	DVB mailin' list <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
In-Reply-To: <498055A4.2090106@to-st.de>
Message-ID: <alpine.DEB.2.00.0901281801350.15738@ybpnyubfg.ybpnyqbznva>
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva> <497A27F7.8020201@to-st.de> <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva> <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com> <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>
 <497EC855.7050301@to-st.de> <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com> <497EF972.6090207@to-st.de> <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva> <498055A4.2090106@to-st.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 28 Jan 2009, Tobias Stoeber wrote:

> > > should (ideally) use a 8 MHz width space from 559.25 MHz to 567.25 MHz for
> > > Ch 32.
> > 
> > Is this correct, or should the range be from 558 to 566MHz,
> > apart from locations (such as the UK and Australia) where an
> > offset may be used?
> 
> Well, you may be right ... I recalled that from former norms (analogue) and
> the fact, that the digital channels were expected to use the existing
> boundaries.

Well, the thing is, that where I came from and where I was
working as a broadcast technician many decades ago, where a
grandfathered norm was in use that makes a good PAL signal
appear to be practically high-definition in comparison...

The reason for the offset was due to the use of analogue
modulation on the video carrier, which causes a sideband
to be created on either side of this carrier, corresponding
to the frequency of the modulating signal.

For simplicity, I'll say that this blurry-o-vision would
have a bandwidth of about 3MHz, with some vague colour info
squezed above this, and then a separate audio carrier with
an offset of 4,5MHz from the video carrier.

So, *very* roughly, in ASCII graphics, the frequency spectrum
of the modulated carrier could be seen like this...
      _____ I _____
     /     |I|     \    ignoring the colour and sound.
  __/      \I/      \__
   F-3      F      F+3

This would require twice the bandwidth of the actual
information, or 6MHz for 3MHz baseband video, and 9MHz
when you add in the sound.

Strictly seen, the carrier F - modulation frequency f
carries the same information as F + f, so one can
transmit only the upper sideband without losing any
information, and filter out the lower sideband.

Because the filter is not perfect, and I've long since
drank the precise values from memory, there still will
remain a bit of the lower sideband...

          _ I _____
         / |I|     \
  ______|  \I/      \__
   F-3      F      F+3

Thus the 1,25MHz offset of F from the lower bound of
the frequency range.

And the upper bound will not be 8MHz higher, as that's
the step to the next carrier frequency here.  Those
1,25MHz belong to the leftovers of the lower sideband
of the next channel up.  So the maximum available
bandwidth will be based on 8MHz minus the 1,25MHz, minus
a bit for additional services -- I've never grasped
the details of the differing norms for audio, as I've
never had the need, only having picked up the above
as a side-effect from my work outside of television.


> http://www.kathrein.de/en/hfc/techn-infos/download/TA-163-164.pdf
> it seems, that you are correct (or how to you read the info in the pdf?).

I'll have to get to this later with a better net
connection...  But my basic understanding is that
the CODFM signal can be vaguely seen as some 8192
carriers packed within that 8MHz bandwidth (or 2k
in early-adopter parts of the UK), and there is
not the waste of a leftover bit of sideband that
needs the 1,25MHz offset -- instead you could view
the carrier as the center of the 8MHz range, as is
done.

Now there is no guarantee that any of this is right,
as I haven't attempted to absorb the multitude of
information I've come across to reach the `Aha!'
moment of enlightenment that I need.


> > Maybe.  It's better, in my mind, than the existing case of
> > individual sites, which again, may or may not cover the case
> > of nearby areas.
> 
> Well, the old style of de-transmitter_region scan file had the charme, that it
> is easier (at least for me) to select the transmitter sites in my direct
> surrounding and I've no real use of de-federal_state.

You also have the advantage of being familiar with the sites
you can receive, as well as your local geography.  If I were
to suddenly be plopped into your general area, I'd have to
dig out a map to try and see what might be nearby.  I'm an
outsider and don't have the background of a native, except
in a few places where I've spent more time than I should
have.  I've only once passed through Braunschweig on the
way to Danmark from the sunny south, and it won't be until
I take the time to do the research, thus familiarising
myself with a region which does not immediately bring to
mind Weisswurst or Spätzle, that the individual site files
(when they even exist, or when they are even accurate)
would be as useful to me.

Take a look at fr-*.  That's (in my out-of-date mirror)
over 100 sites.  One reason this is needed is due to the
fact that they chose not to make use of Single-Frequency
Networks, and so nearby towns are assigned different
frequencies, rather than the reuse that I've noted in my
comments for B-W.

Counting the number of ZDF sites on the ten pages of
teletext, I come up with over 130 transmitters, most of
which are shared with the ARD and others.  But this is
not always true, as there are a handful of sites, most
in edge cases, where only the ARD/Dritte stations are
being sent, so I'll estimate that Christoph will need
some 130 to 140 different files just to cover all the
sites, or regions if you prefer.

Then there is the problem that the sites do not always
match a large metro area, and unless you're working as
a TV installer, chances are you're not going to know
the names and coördinates of the actual transmitters,
though it is far better than the analogue case of
several thousand sites, including filler/repeater
transmitters...


> Take a large geographical area like Niedersachsen, so you come to the
> conclusion, that in most areas you won't need the overwhelming majority of
> entries in de-Niedersachsen (because transmitters are to far away), but you
> will in most cases need entries from the [regional?] [ de-federal_state ]
files.

I presume you meant to say you'd need regional site
files.

It's a tradeoff.  Do you want the 32 de-* files in my
out-of-date mirror, including one obviously-wrong
file, the regions Ostbayern and Ruhrgebiet, or do you
want maybe around five times as many, but up-to-date
and correct, or do you want, say, 20 files, with the
largest cities and separate or perhaps combined
Bundesländer, automagically generated?  Or would you
rather have about 20 files total, with the Bundesland
files at least partly massaged by me to add more info,
and applicable out-of-area info?

The thing which may not be immediately obvious is how
a SFN simplifies combined lists.  The B-W file you
reviewed replaces 13 (soon 14) individual region files,
most with three frequencies.  This is, however, cut
to a fifteen-line scanfile, rather than 39 total lines.
Depending on area, one could need to pull in three
or four site files, and that's not even including
out-of-area broadcasts -- Grünten, as eventually you
can see from its elevation and mast height, blasts
into areas one might not expect.


> > I've posted in the past my suggestion for a de-BW file, made
> > by hand, which tries to address this issue, as well as provide
> > an overview for anyone trying to make sense of the frequencies
> > and broadcast policies, as well as to help with antenna
> > orientation, towerspotting, or anything else that might interest
> > me, in a single location.

> Well, I had to look in may list archive, but did find it (your posting from 02
> Dec 2008). First, I looks like a lot of wrok, especially because  this area
> not only benefits from other federal staes but also from France and
> Switzerland.

Thanks for looking at it.  It could be seen as true, that it
would be a lot of work for someone coming from outside and
being told to do it, but in reality, I was already doing
this work, or had been, but into about five or six different
text files on three different computers.

Putting all the info into one place was a way to make it less
work for me, in the long run.

The thing is, I'm an outsider.  Just as others have their
own reasons for following linux development, there are a
number of things I like to do without considering the amount
of work, just because I'm interested, and these often are
related to technology and other technical matters.  Not to
mention my background of climbing antenna masts to cook my
brain, and guarantee I'll never be the father of my children.

As I was not familiar with the details that are made available
via teletext (a convenient offline medium when I haven't
had Internet access for remaining somewhat with-it), I
needed to do research to answer the questions I had, which
raised more questions, and on and on...  This included
trying to locate the antenna sites by name on printed
maps, then becoming intrigued by the alien (to me) concept
of SFNs, with my analogue background.

Anyway, the result was that I had made a bunch of different
sets of notes, in the unlikely event that someone might
consider hiring me for my areas of interest, but I thought
it might interest others in case they had the same view,
as an outsider, if I made it public -- particularly as
the BaWü scanfiles were largely missing, or inaccurate.

So why not try to transfer my mental overview into a
more permanent form, that I won't be able to drink away
so easily, and to see if I actually have a clue as to
what I think I know (which failed miserably in my
disinterested-outsider overview of german DVB-T  ;-)

The one thing I'd really like to include would be a
simple ASCII map that one can use as orientation for
transmitter locations.  In the absence of this, I've
tried to partner each site with a somewhat-large nearby
Dorf that can be seen on most maps that use most of a
page to cover the Bundesland -- which has not always met
my satisfaction, as an outsider, intimately familiar
with areas I've bicycled through, but not always having
had years of familiarity with, say, the PTB or other
locations that immediately ring bells with natives.


The thing is, the benefit from other areas is a result
of also understanding those areas.  That is, I added
Bayern without really understanding it, simply because
a BR coverage map pointed me at potential overlap.
Work to get an overview of Bayern will come later.  That
needs an overview of part of Austria (though info from
Bayerischer Rundfunk helps, but, um, do signals from
Linz really reach into Bayern?) where the switchover is
well underway, and the Czech Republic, which is
presently in the process of switching, but has not
reached the final step as in Germany.


Actually, the details of Switzerland may not be so easy,
but the overall view today is easy to describe in a few
words, quite the opposite of Germany.  I think I did
that in the file:  one multiplex, if you're around here,
this frequency, and a bonus DVB-H to go with it, and no
plans to make further use of the eight or so UHF GE06
frequencies available in each area that I've heard of.

France was easy too, because I had done my homework
in the hopes of receiving these channels when making a
holiday in the Kaiserstuhl, but it was too early for
that.


> > A Bundesland-based set of files is a region-based set, or can
> > you better describe the regions you are thinking of?  In any

> I actually meant scan files for specific DVB-T region like de-Berlin,
> de-Munich, de-Nuernberg etc.

I will argue that Berlin (also being its Bundesland) should
remain, and likewise Muenchen, for the poor out-of-area souls
who never make it anywhere else, and who would stare blankly
at me if I told them they were in Bayern, dude, you know, Ba-
vay-ree-yah.  There are things to see.

I'll need to make my overview of Bayern before I can suggest
how to handle Nuernberg.  It's an early adopter, needs some
explanation of the reception situation and such, and so far
I really don't have a good idea...


> > But that's just my idea, and really, I would like to hear
> > what you think of the contents of my de-BW file, as the
> > single bit of feedback I got on it was negative.
> 
> Well, as a (mostly?) complete collection of all transmitting sites that could
> possibly be received, it's good work, that I would appreciate.

I've since realized that I need to add more from Hessen.  I
made this file based only on looking at maps, and trying to
fit my limited experience in the field with what someone
might expect to see...

Ideally it will be complete.  The switchover is complete in
germany (save for a few frequency tweaks), switzerland, and
the nearby area of austria, though I'm not as up-to-date on
plans there for additional multiplexes, so the information
should not go out-of-date anytime soon -- though the swiss
could do an about-face and start a second DVB-T2 multiplex
with HD Suisse, just to spite me.  Or a second multiplex to
provide the missing second programmes and give more bandwidth
to improve the picture quality of the existing channels.
Anything is possible within the GE06 agreement, which is not
completely covered by my handcrafted scanfile.


> On the other hand, I am not so good in geography, so that I would have to use
> some sort of map to find out, what distances are between my location in
> Baden-Wuerttemberg (lets for instance say Ulm or Biberach) and the out of area
> sites. I would say, that for Biberach additonally sites from Bavaria (Bayern)
> or Switzerland may be correct.

No worries, you are no different from me.  Of course, I would
not need a map to tell you that in Ulm, you are practically
in Bayern (unless you are in Neu-Ulm) and due to the flat
nature of the land in that direction, you can expect to
receive signals from into the Alps or thereabouts.

The thing about the signals from Switzerland is that while
earlier the Säntis was known for clean strong signals that
would penetrate well into germany, hundreds of km away,
in part due to using one VHF frequency, as part of the
switch to DVB-T, the radiation pattern was greatly changed
to send as little signal as possible towards Muenchen and
other areas which got either a good or watchable signal.

I have the following rather-old and from-unknown-source
prediction of the radiation pattern...
29.2 27.2 25.2 24.2 22.2 20.2 16.2 16.2 16.2  6.2 14.2 24.2 28.2 
28.2 24.2 14.2  9.2 17.2 17.2 17.2 20.2 22.2 24.2 26.2 29.2 33.2 
36.2 35.2 17.2 38.2 44.2 46.2 44.2 39.2 25.2 27.2
which shows it is far from omnidirectional these days, as
is confirmed by reception reports.

The signals do travel well from Basel northwards along
the Rhein, as I had no problems receiving them while on
holiday in the Kaiserstuhl with a simple portable receiver
and stub antenna, both french and german bouquets.

The geography of the Schwarzwald, as well as the planning
to use a large number of lower-powered sites as part of
the SFNs, mean that people who used to receive the
programming from, say, Zürich (also VHF) nowadays can
receive nothing, in spite of being a few minutes from
the border.  In other words, apart from the Oberrhein
from Basel to Freiburg im Breisgau and beyond, unless one
is on a hilltop or pretty close to the border, one may
not receive the swiss multiplex at all, while the non-
directional high-power german transmitters may come
in clearly.


Of course, the easiest solution is to uncomment all the
out-of-area frequencies, as well as those used within
the area, and do your scan based on that.  Then, if I
have done my homework, you will receive everything.

And do enjoy your stay ;-)  Be sure to take your DVB-T
receiver with you as you climb to the top of the Ulmer
Münster, if you are not afraid of heights.  And as you
head to Biberach (which one, by the way?) do not forget
to take the long way, stopping at a Hausbrennerei,
trying a good home-cooked meal, sampling the local wines,
relax in a thermal spa, suffer through the Alemannische
Fasnacht, and promise to return, eh?


> I like it, could imagine to do a similar file at least for my Bundesland.

Allow me to offer to volunteer.  First I need to pull out
my maps, and try to get an overview of your area...

But do not expect me to have it complete by tomorrow.
As always, I have too many things to and too little time
and too many other things getting in the way...


> Interestingly you also list the height above see level and antenne height of
> the BW sites.

Like I said, I wanted to put it all in one place.  Such
technical data is easy to find, and quite helpful.  For
example, I used to think that the `Hochrhein' antenna
was the impressive concrete structure that one sees
prominently when heading out of Zürich.  Likewise the
listing for de-Loerrach, the imposing antenna is actually
in Switzerland, St.Chrischona, and according to my old
plans, transmits the swiss-german multiplex, not even
listed in this scanfile.

Having this info at hand, I can guess at coverage over
hills in the area of a certain site, when studying a map
with some topographic information.  A single hill of a
couple hundred metres can make the difference between
a signal I receive with just my finger, and no reception
at all even with a directional antenna, when placed
between me and a transmitter.


> reception borders for indoor / outdoor / roof antenna) and about the
> topography, so that one could estimate for a given geographical location
> (retrieved by GPS or from a map oder Google), which transmitters may be in
> reach. ;o)

The reception estimates are, in my opinion, highly
suspect, particularly if you download those from SWR
for B-W, due to the nature of the deep valleys that
cause that map to appear like some modern art with
green ink on a white background for a large area, but
then, I haven't wired my portable receiver for battery
operation to let me climb a few hundred metres and see
if some sites that might be in range are able to be
received clearly, or if there is some directionality
at the transmitting site.

That's another thing I don't mention.  I could be
sitting along the Bodensee now, dipping my toes into
the water in an attempt to get frostbite, staring at
the red glow atop the Säntis and wondering why I'm not
getting a strong signal, while much further away along
the Kaiserstuhl, without sight to the antenna, I'm
hardly able to miss the comparable mux.  Perhaps I
could add this to my comments, if I appear to be leading
people to think that coverage figures will be similar.


> There are indeed so many factors in real life, that play a role regarding
> DVB-T reception (and scanning), like type and placement of antenna,
> sensitivity of the tuner etc. ... which are in fact not a problem of either
> auto scan nor a scan file  :-/

As far as the antenna is concerned, I'm hoping that the
comments within are helpful.  For example, the situation
in switzerland is that now transmissions are vertical;
before they were horizontal, and there are still many
rooftop antennae with the wrong polarisation for that
direction -- similarly in B-W, a good number of areas
were served by vertically polarised filler transmitters
that now receive signal from a horizontal Grundnetzsender,
and antenna orientations are mostly unchanged.

That actually isn't so much an issue with DVB-T, apart
from fringe areas, as it's capable of delivering nearly
a perfect signal where analogue had visible multipath,
but it could also be that these rooftop antennae have
been unused for years, as pretty much every house has
sprouted a satellite dish.


Well, that has kept me from actually doing research to
add info to your überregional scanfile  :-)

barry bouwsma
longwinded
