Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:42836 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbZA0Ocd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 09:32:33 -0500
Received: by ewy14 with SMTP id 14so1766934ewy.13
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2009 06:32:31 -0800 (PST)
Date: Tue, 27 Jan 2009 15:32:17 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: =?UTF-8?Q?Tobias_St=C3=B6ber?= <tobi@to-st.de>
cc: linux-media@vger.kernel.org,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
In-Reply-To: <497EC619.8070601@to-st.de>
Message-ID: <alpine.DEB.2.00.0901271252330.15738@ybpnyubfg.ybpnyqbznva>
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva> <497A27F7.8020201@to-st.de> <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva> <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com> <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>
 <497EC619.8070601@to-st.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Grüezi mitenand!

*Whew*, that was a lot....

On Tue, 27 Jan 2009, Tobias Stöber wrote:

> ... and sorry Barry that I've to correct you on some parts of your
> summarization ;) I hope you don't mind.

No worries.  I've tried to give a view that an outsider could
use to better understand the situation and place a logic onto
the channel assignments, as it is a bit more detailed than the
situation in, say, Switzerland.  Or France.


> > exist national public service, regional public
> > service,national/regional private commercial, and local broadcasters.
> 
> So what do you mean with local broadcasters? Or what is the difference in
> regional private versus local?

Local broadcasters here would include, as examples, HH1, only
available in the Hamburg region, or perhaps some of what can
be seen in Leipzig, though that appears not to be included in
the .pdf file frequency list.  Likewise I'd include the
different services which can be seen via DVB satellite making
up FrankenSat and the like -- simply because I'm not familiar
enough with them and their reach -- I'd assume TRP is available
in Passau, but not throughout Oberbayern, for example.

By a region, I mean either a Bundesland, as opposed to those
which cover just a large city (Berlin, HH, Bremen...) or a
large part thereof.  For example, RTL has available a service
for Austria and the german part of Switzerland, and for HH SH
and HB NDS available via satellite, as does Sat1 with services
SAT1 National, SAT1 NRW, SAT1 NS/Bremen, SAT1 HH/SH,
SAT1 RhlPf/Hessen, and for Bayern, Test BY.  (info may be some
months out-of-date)

Unfortunately, I am not very familiar with the multitude of
private broadcasters out there and their coverage areas, due
to receiving satellite signals, which lack most of these.
Only occasionally will something catch my interest -- for
example, was tm3 a local München service, which happened to
be available nationally before it perverted into Neun Live
and wormed its way into DVB-T multiplexes?  And likewise, the
service which Hornauer took over before finally sputtering off
satellite after a shell game into Austria, whose original name
I can no longer remember...


> The stations must also be licensed in one of the federal states and are
> required to broadcast are local/regional programme there(!), which results in
> the fact, that on DVB-T (and before on analogue TV) there are programmes
> targeted to the region and which are not available on satellite TV. For RTL in
> Niedersachen/Bremen there is a programme called "Guten Abend RTL" between
> 18h00 and 18h30, or on Sat.1 there is then a programme called "Sat1 - 17.30
> live NDS/Bremen" between 17h30 and 18h00.

Actually, these services are now available nationally (and through
europe) via DVB-S.  Earlier, these were sent at least in part via
low-bandwidth transponders in the style of SNG feeds; today they
make use of dynamic PMT switching within a full-bandwidth 
multiplex, in the same way that WDR in particular switches to its
many regions for part of the day.


> There are then also some special local DVB-T phenomena, like radio stations
> over DVB-T in Berlin or special projects like the private "Leipzig 1" -
> multiplex which experiments with a small cell SFN nework of low-power
> transmitters within a very small area (area of the city of Leipzig) with 6
> transmitters in that (Leipzig-Mitte, Leipzig-Messe, Leipzig-Grünau,
> Leipzig-Markkleeberg and Leipzig-Lößnig). This project does include TV and
> radio stations (Leipzig Fernsehen, Infokanal Leipzig, BBC World, Bibel TV,
> Radio Horeb, Radio Leipzig).

If I remember, there is also an occasional multiplex in, if I
remember, Nürnberg...  I do need to look more in detail at these
projects.

What I do notice is that in the frequency list, Leipzig includes
only the three PSB multiplexes, including one on VHF channel 9,
which eventually should be moved, I would expect.

Also of note is that the dvb-apps scanfile for Leipzig does not
include the frequency for that low-power network.  I think I
need to do some homework...


> > The practical example of this would be that while onecan see the same
> > content via ZDFmobil anywhere, theso-called ARD multiplex may
> > contain, by region, EinsPlusor EinsFestival, or perhaps in that
> > region, that regionalmanager's so-called ``Dritte'' (third, after ARD
> > beingfirst and ZDF being second) programme.
> 
> Not correct, the ARD-Das Erste multiplex does NOT contain regional ("third")
> programmes! There is always a seperate multiplex for the "third" programmes.

I hate to disagree, but Brandenburg appears to mix rbb-Brandenburg
with ARD, with the `dritte' multiplex containing `arte'; this is
also the same for Berlin and rbb-Berlin -- I'm not sure if the PMT
switching is used here to make the Brandenburg and Berlin local
programming available through the entire area for the few hours
per day when they differ.

Similarly in Bremen, Radio Bremen TV is found where one normally
would see one of the EinsFoo digital services.

Hessen is the most obvious example, and the first I came across
when researching frequency plans based solely on offline sources
(teletext services).  ZDF lists its nationwide transmitter sites
and some details, in ten subpages of teletext page 779.  ARD does
not have this info anywhere I've seen, but instead the regional
Dritte programme teletext service lists frequencies, typically
for the `dritte' as well as the ARD multiplexes.  In the case of
NDR, this is on four subpages of page 667, but here only lists
one of the two non-ZDF public frequencies.

For Hessen, the frequencies listed on teletext page 399 is that
of the multiplex shared by ARD and hr-fernsehen, and apparently
there is only a third service available, making far more bandwidth
available for better video quality, or, say, additional AC3 and
narrative audio channels.

The situation is now better than it was years ago, with page 642
in hr-text listing the frequencies in use by the third multiplex
as well as the programming (shared by four programmes, usually
Phoenix and three out-of-region public-service broadcasters).

In Mecklenburg-Vorpommern, the entire area appears to be covered
by only two multiplexes, with ARD sharing space with three 
regionals, and nowhere are Phoenix, arte, and the like to be
found.  Interesting -- I learn something new each day.

Also in the Saarland, SR takes the place in the ARD multiplex
of EinsFoo.


Anyway, it might be interesting for me to learn how things have
changed in the distribution of programming since the rollout
of DVB-T and the adoption of fibre networks and such.  I have
read that apparently the regionalisation of the ARD programme
has suffered, with local mascots such as Onkel Otto, and Äffle
und Pferdle having disappeared as the source is taken from
satellite.  Time to figure out how I can book myself into some
tours behind the scenes...


> > Now, while ZDF has a unified national service, the sameis not
> > necessarily true for what you can receive ina selected Bundesland.
> > For example, in Hessen, dependingon where you are, you may be able to
> > receive the localprogramming from the nearest Bundesland; in the
> > southof Bayern you can see SWR Baden-Württemberg but temporarilynot
> > Hessen (or the DVB-H which replaced it), while inthe north you will
> > instead see `mdr', although you mayhave previously received SWR,
> > which is the reason thatBad Mergentheim in BaWü, near the border,
> > will need itsown DVB-T transmitter sometime this year.
> 
> I don't get this info or what you want to really say into my head. So what's
> your point?

Heh, good question...  I wish I could remember writing that...

I think my point was to try to say that one nationally-available
multiplex carries the same programming.  The (usually) two other
public multiplexes do not, when seen from a national perspective.
(The ARD multiplex in, say, Hamburg, is not the same as the mux
in Baden-Württemberg (EinsExtra v. EinsPlus) or Hessen (where hr
is included.)  However, while one of these multiplexes is the
same throughout all sites in Hessen, the third multiplex in the
case of Hessen exists in four slightly differing flavours.

In Baden-Württemberg, all three multiplexes do carry the same
content throughout the entire Bundesland, but this general
observation does not always carry over to other regions.


> > So, anyway, there's been forces to cause merging of thedifferent
> > regional broadcasters; NDR covers severalBundesländer, with Radio
> > Bremen retaining a bit ofindependence; 
> 
> Radio Bremen is independent! But, because it covers a very small area,

Well, yes.  I was looking at it as seen from a content point
of view, where apart from the logo, there exists very little
reason for me to choose it over the higher bandwidth available
from PIDs starting with 2600 via satellite...


> > leaving most of the land by area dependentupon satellite reception
> > for these programmes.
> 
> See first part. A part from sat reception there is also a widespread coverage
> with cable.

How extensive is the penetration of cable?  My experience is
that at least in some areas, apart from larger towns, many
places have no access to cable.  This is in contrast with, say,
Switzerland, where cable is available in what superficially
appear to be sleepy farming villages and is in fact the most
highly-used means of distribution.

These same areas are also out of range of the Telekom DSL
service, so with no cable, and no easy high-speed internet
in communities of thousands, one wonders how people live...


> The problem as such is, that in topographically flat areas like say Hamburg it
> is difficult to sort out what stations you receive from what transmitter site
> when actually using DVB-T.
> 
> This may also be true for areas, where the borders of different federal states
> meet, because you do not only receive your areas programmes and transmitters
> but also other sites.
> 
> To really verify those information you would have to rely on "official"
> documents and maybe have access to a directional antenna (aerial), where you
> could try to "locate" (or at least determine a direction) from where you
> receive the mux.

I need to parse some NIT table data again.  The last time I
did that, the information contained within was incorrect for
that particular DVB-T site.  For a DVB-H multiplex, I just 
got the coördinates of the box in which several transmitters
were located, and no clue apart from the direction of my
receiving antenna which it might have been.  This would also
depend on whether use is made of a SFN.


> > If I ever get around to a more detailed study of eachBundesland, I'll
> > offer more feedback, although I haven'treceived any concerning my
> > proposed enhancements to B-Wsome months ago, so it may not matter...
> 
> Well, the only I can do is, offering you my help on the areas that I live and

Much appreciated.  I used to travel a lot more, but that was
before getting old and taking an interest in digital broadcast
distribution.  I tend to focus more on the technical side, and
have less interest in politics and the like, as you could
clearly see from how badly I botched the description I tried
to give.


> http://www.dvb-t-nord.de/empfangsgebiete/media/111108_h_bs_parameter.pdf
> It does also contain information which out-of-area transmitters can be
> received.

Interesting.  The first example of such a thing which I've
seen  :-)


Maybe I need to spend some more time on this here Internet
thing.  Who knows, maybe I'll learn something...

Uf Wiederluegen,
barry bouwsma
