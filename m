Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:64793 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZBJLGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 06:06:23 -0500
Received: by bwz5 with SMTP id 5so2499241bwz.13
        for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 03:06:20 -0800 (PST)
Date: Tue, 10 Feb 2009 12:06:09 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Christoph Pfister <christophpfister@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
In-Reply-To: <19a3b7a80902071053j2a428517vca07611cf16b882c@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.0902100404350.1147@ybpnyubfg.ybpnyqbznva>
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva> <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva> <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com> <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>
 <497EC855.7050301@to-st.de> <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com> <497EF972.6090207@to-st.de> <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva> <19a3b7a80901290232p3b2dd1a1y42f7276dedfebf43@mail.gmail.com>
 <alpine.DEB.2.00.0901291222020.11385@ybpnyubfg.ybpnyqbznva> <19a3b7a80902071053j2a428517vca07611cf16b882c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 7 Feb 2009, Christoph Pfister wrote:

> Sorry for the late answer,

No worries, I've been keeping busy by discovering yet more
info.  Discovering a site where not only does everyone know
more than me and where all the info I could possibly want
is there for the taking, but where I feel more unworthy
than usual.

So, while I still have yet to mangle the machine-generated
output, I did observe the following:

It seems that the info for Hansestadt Bremen (Radio Bremen)
can be merged into that for Niedersachsen, as the presence
of an RB multiplex in the latter disturbed me, until I
noted that apparently all the (Bundesland) Bremen frequencies
are also used in Bremerhaven.  So, one less file to maintain.


Not only is Hansestadt Hamburg migrating away from the VHF
Band III allocation which kicked off this too-long-running
thread, but at some yet unspecified time this year (2009),
most if not all of the remaining Band III DVB-T transmitters
will also relocate.  This affects primarily Bayern, but also
a few other sites (FFM, Berlin...)

I don't know if the frequencies I've read are confirmed, or
mere speculation; further, I know no fixed planned dates.
But more importantly, I don't know if it's worth it for me
to bother to announce known and confirmed changes, or if I
should relax and let the official channels publish the info
to be massaged into scanfiles.

Any residents who might happen to read the info I post are
almost certain to have already been made aware of any such
changes through other media...


My claim that the information for each Bundesland was not
likely to change, could be an untruth.  I've seen mention
of additional frequency changes that were unknown to me,
in addition to vacating VHF DVB-T frequencies to make
available more DAB/DMB/DVB-T2 multiplexes nationally and
regionally.


Apparently Bundesland B-W will not only start two more
ARD/SWR multiplexes in Bad Mergentheim at a lower power
than the other transmitter sites, but will also start a
handful of other lower power sort-of-filler sites,
apparently not coordinated with ZDF.  (May be R-P; my
geography is poor).  And there should also be some sort
of pilot or comparable introduction of a Private MUX in
Stuttgart, quite possibly incompatible with existing
practice throughout Germany (may be use of MPEG-4 video,
or perhaps DVB-T2, or maybe encryption)...



> case you need to mark the individual transmitters). Actually I don't
> care about the arrangement, as long as there are machine-implementable
> rules for the update.

Of course, first of all, I need to get off my lazy butt
and actually start sorting the info you've compiled into
something that will help me get an overview.  Say, for
Bayern, which, from the Bayerischer Rundfunk perspective,
is divided into North (Franken) and South (also with good
beer); to which are added a few Privates in scattered
areas, partly using the same frequencies, though widely
spaced...

As a tradeoff, it could possibly be that some Bundesland
files could be merged into a super-region -- notably the
NDR and mdr regions, though this is pure speculation as I
haven't rearranged any files to imbed them in my brain,
and is only suggested at by the Bremen/Bremerhaven union.
Talk is cheap.


> >> They shouldn't be too excessive,
> 
> I meant the number of transmitters, not the size of the file.

Ah, fine, fine.  As a comparison, I'll offer Helvetia.
The last list of DVB-T transmitters in service I bothered
to download includes some 25 pages, each with around 20
or so listed sites, for that small land.  No way would
I consider attempting to list these -- or even those
for a particular language region or SFN part thereof, in
a scanfile.


> > I just updated overnight, and de-Leipzig no longer exists!
> > Aieee!@  Good thing I made a backup copy of that directory
> > before I updated
> 
> hg has a good memory as well :)

At my age, it's hard to unlearn the convenience of such
advanced tools as `grep' and `less' on simple foo,v text
files (and Attic directories) to trace a file through
time.  However, you're right -- I do believe that I had
problems with `git' on renamed or obsolete files, and
subversion appears hopeless for anything but remaining
up-to-date offline, though I have enough SOCKS and https
problems with that, so that I'm no longer bothered...

Like they say, I learn something new every day.  Pity
that most days it's the same thing I learned on several
previous occasions, when not each day the past week...



Anyway, let this be a fore-warning that you will be
likely to need to update the files for various Laender
a few times this year to keep up-to-date -- and that is
not to include changes to MUX contents (renaming one
ZDF digital channel, or changes in Private Muxen).

So I'm off to the Bundesnetzagentur to see if I can
get accurate info about upcoming changes and allocations,
though I believe this source will be more suitable for
planning, than to generate up-to-the-minute scanfiles.


barry bouwsma
