Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L7bZH-0007cR-Em
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 21:10:01 +0100
Received: by ug-out-1314.google.com with SMTP id x30so3115750ugc.16
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 12:09:55 -0800 (PST)
Date: Tue, 2 Dec 2008 21:09:43 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Christoph Pfister <christophpfister@gmail.com>
In-Reply-To: <19a3b7a80812020821udb493a1m3e4d2733a54e87f0@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0812021931570.9198@ybpnyubfg.ybpnyqbznva>
References: <19a3b7a80812020821udb493a1m3e4d2733a54e87f0@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] changes for de-Nuernberg and de-Stuttgart;
 de-Baden-Wuerttemberg
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

On Tue, 2 Dec 2008, Christoph Pfister wrote:

> Changes collected by Barry. The de-Baden-Wuerttemberg is a combination
> of different transmitters and although I tend not to include it in the
> repository (quite hard to maintain)

Actually, I expect that -- apart from Bad Mergentheim as
noted, exact frequencies not yet discovered -- there should
be no changes needed for quite some time.  Here's why:

As of November 2008, nearly the last of the analogue
transmitters in Deutschland were switched over to DVB-T
or in the case of filler repeaters, switched off.  In
addition to the Taubertal, I'm aware that in Bayern, the
same will happen to GAP if not one other location.

The changed frequencies here as well as in other Bundeslaender
now match those assigned in Geneve in 2006, so throughout
all the scanfiles, there should be no new changes needed,
apart from:

A few transmitters are still using Band III VHF channels;
these will be changed so that all DVB-T in Germany will be
on UHF frequencies.  Those are not in this file but to be
found in other Bundeslaender.  These allocations, resulting
from GE06 or RRC06, however you wish to search for it, are
expected to suffice for the next 20 or 30 years.  (Heh.)

Unlike France, which makes use of Multi-Frequency Networks
and so every town with transmitter requires a separate
scanfile, you can see the re-used frequencies of several
SFNs, simplifying the uncommented portion of this list
compared with trying to maintain redundant files for each
transmitter site.

The GE06 frequency plan allocated six plus one UHF frequencies
for DVB-T (or DVB-H or other 8MHz bandwidth use), so that in
the current frequency layout, three multiplexes are assigned
to the oeffentlich-rechtliche broadcasters (PSB), and three
reserved for private commercial broadcasters -- the dual
system or whatever they call it.  Unfortunately, I haven't
found readable maps to show the areas and channels assigned
for germany (while I have for Suisse).

Unlike in, say, France, where private broadcasters are
present at each transmitter site, in Germany, the privates
have chosen to restrict themselves to a few larger metropolitan
areas, such as Muenchen, Hamburg, Frankfurt/Main, and so on,
and have shown no interest in even Stuttgart, apparently
preferring to rely on CableTV and Satellite, or throwing
around the idea, presently on ice, of encrypting their
signals, even via DVB-T, and charging a subscription fee.
Nor am I aware of any plans for local broadcasts, or any
private broadcasts outside of Stuttgart, that don't rely
heavily on a government helping hand or are near any sort
of realisation.

If these assigned and reserved frequencies come into use
eventually, they can be added as appropriate -- if I get off
my lazy arse and compile the list for Bayern or Hessen, you'll
then see those frequencies.  Most likely, the ex-Bundespost-
Telekom-whoever-they-are-now that manage the broadcast towers
and transmitters will use the same locations listed here.

The current allocation of three oe-r Muxen and three reserved
privates is unlikely to see the parameters changed soon, as
DVB-T is not seen as the primary distribution that analogue
used to be until the last decade.  The Guard Interval matches
the SFNs covering a wide area, and the use of almost exclusively
high-powered widely-spaced transmitters without fillers needs
a robust set of parameters that trade potential bitrate for
a better signal under marginal reception (cf. the QAM and FEC
used in the Alsace, where I read reports that the quality is
readily affected adversely at comparable distances).

While HD broadcasts in various forms have started and are due
to start within years, I have heard nothing about plans to use
DVB-T for them, either by adopting the existing Muxen for them,
or taking over the remaining allocated but yet unused channels,
possibly using DVB-T2 for that (the existing base of receivers
is entirely DVB-T+MPEG-2, unlike in some countries, so a DVB-T+
H.264 hybrid is highly unlikely).  Presently satellite is expected
to be the primary distribution for HDTV (and thus CATV).

This is of course based on what little I know of the broadcasters
and I hope you won't hold me to my word if changes are made soon
which I've not predicted here.


As far as the neighbouring countries, France has started the
five or six Muxen assigned by GE06, yet there continue to be
some analogue broadcasts receivable along the Oberrhein, until
something like 2012 or so.  As there are only two MFN transmitter
sites which I list, if there are changes made to them in the
coming years, that's somewhat easy to fix -- and as I noted as
a comment, one of those two scanfiles presently doesn't even
give frequencies in useful form.

Switzerland has officially* stated there will be only a single
frequency used for DVB-T per region, in spite of having received
eight frequencies allocated (if I remember right) and has further
stated* that DVB-T will remain SD, and HD will not be broadcast
terrestrially.  A second frequency is used in several areas for
DVB-H with little consumer acceptance at present.  Whether those
proclamations will stand the test of time and still be true in
five or ten years, I won't guess.  In Suisse, Cable is the
primary means of content distribution of broadcast; presumably
other non-over-the-air means will also see heavy use (DSL and
other IP technologies).  Those frequencies shouldn't need any
changes -- unless some parameter tweaks are needed to accomplish
the stated plans of fitting five programmes onto a single SFN
multiplex, which may have happened, I don't know...

(*Well, I read it in an interview, and I'm no insider)

Also, the existing CH Muxen are the PSB channels, except in
some areas far from reach of BaWue; *possibly* there may be
use by private broadcasters in areas like Basel or Zuerich if
there gets to be enough interest -- presently all local or
regional/national(?) private broadcasters are carried exclusively
via cable.  There is currently more in the way of privates
joining a DAB+ radio multiplex...  I also know of no plans to
add the missing second of each of the language region TV
broadcasters to a second DVB-T multiplex or using the same
to allow an increased bitrate and quality for the existing
channels on the present multiplex.

Apart from some spillage from Austria near the Bodensee region,
the other areas receiving out-of-area coverage do so from other
regions of Germany.  Any needed tweaks to the parameters will
certainly be effective for all of germany, as of the three PSB
Muxen, one (ZDFmobil) is identical throughout all of Germany;
the other two are regionally mixed from local PSB broadcasters
or the regionalisation of the other national broadcaster (ARD
Das Erste).

Unlike the switchover in the UK for example, which is being
carried out in steps, resulting in the need to change every
frequency list (change in ERP, modulation and FFT, frequencies,
does the offset disappear?), these frequencies listed here
are basically those initially put into service, and, apart
from the frequency tweaking (to match GE06; why this was not
initially the case is unknown to me), low-maintenance.



The alternative I see to this single file is to break it into
the 14 sites in BaWue from which DVB-T (will) radiates, which
is a lot more work for redundant info, and also makes it hard
for those out in the boonies to find a suitable transmitter
(quick, where's Brandenkopf or how would you name it instead,
and would you even know it's in BaWue if you're not a native
of that specific area or a TV/Radio installer?)

The other alternative I have is to create a de-all, similar to
the ch-all; the latter of which seems to just list the GE06
allocations and makes no mention of what regions see which
frequencies -- eventually after I learn the details of all
the other Bundeslaender, I might create such a file.


The intent of this file is to share what I would create for
myself for use when travelling to different regions, as well
as to try to present the mental picture of what I create for
each region in the unlikely event that anyone would ever
hire me back into the broadcasting world where such an
overview could be useful.  Or something.

If anyone else thinks I'm just wasting my time, I'll probably
put it on hold until the next time I find myself hitting the
road, so feel free to voice your opinions.



JEEZ do I write a lot, when I could be reverse-engineering
drivers, or doing something useful...

barry bouwsma
oh, by the way, all I wrote above is from memory without
bothering to verify what I vaguely recall reading months ago
when unable to sleep, and filtered through an inebriated haze,
so trust and believe at your own risk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
