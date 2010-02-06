Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:39600 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0BFMCi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 07:02:38 -0500
Received: by ewy28 with SMTP id 28so903865ewy.28
        for <linux-media@vger.kernel.org>; Sat, 06 Feb 2010 04:02:36 -0800 (PST)
Date: Sat, 6 Feb 2010 13:02:18 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: Need to discuss method for multiple, multiple-PID TS's from same
 demux (Re: Videotext application crashes the kernel due to DVB-demux
 patch)
In-Reply-To: <1265415910.2558.17.camel@localhost>
Message-ID: <alpine.DEB.2.01.1002061150060.10376@ybpnyubfg.ybpnyqbznva>
References: <1265018173.2449.19.camel@brian.bconsult.de>  <1265028110.3098.3.camel@palomino.walls.org>  <1265076008.3120.96.camel@palomino.walls.org>  <1265101869.1721.28.camel@brian.bconsult.de>  <1265115172.3104.17.camel@palomino.walls.org>
 <1265158862.3194.22.camel@pc07.localdom.local>  <1265288042.3928.9.camel@palomino.walls.org>  <1265292421.3258.53.camel@brian.bconsult.de>  <1265336477.3071.29.camel@palomino.walls.org>  <4B6C1AF7.2090503@linuxtv.org>  <1265397736.6310.98.camel@palomino.walls.org>
  <4B6C7F1B.7080100@linuxtv.org>  <4B6C88AD.4010708@redhat.com>  <1265409155.2692.61.camel@brian.bconsult.de>  <1265411523.4064.23.camel@localhost>  <1265413149.2063.20.camel@brian.bconsult.de> <1265415910.2558.17.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm not even trying to follow this discussion at all, but I
feel I have to chime in to be off-topic...

On Sat, 6 Feb 2010, hermann pitton wrote:

> > > > Bye bye Teletext. Nothing for future kernels, huh?
> > > 
> > > Yes, you say it. It definitely will go away and we do have not any
> > > influence on that! Did you not notice the very slow update rate these
> > > days?
> > 
> > a. NOTHING "will go away". This is empty rant, nothing else it is!
> > In US teletext is dead, yes. In Europe analogue television is close to
> > dead. Yes.
> > But I have found no information source that teletext will disappear in
> > general. At least not in Europe or Germany.
> > So if you keep that up then prove the assertion please.
> 
> In the UK too. And after world war II we always followed BBC.
> Not that bad ...

The BBC has switched over to ``Digital Text'' via the Red Button
service on Freeview.  This is based on MHEG, and has the advantage
that pretty much all receivers are built around a particular 
platform which specifies inclusion of the Red Button services,
a particular EPG, LCNs, and so on.  Be that platform Freeview, or
Sky, or Freesat.

This is not the case in your country -- the public broadcasters
have adopted MHP which has gone over about as well as a lead 
balloon.  There is also not a specified platform, but rather any
manufacturer can offer a receiver based on the DVB specifications.
Usually teletext support will be built-in to the decoder; also, 
most boxes pass the DVB Teletext information to the television
regenerated as the analogue VBI interval which pretty much every
set supports.

As far as I know, the proposed Eutelsat Viseo platform being 
pushed does not specify a MHP- or MHEG-based replacement for
teletext, nor am I aware of any alternative platforms to take
over and mandate a replacement of the current level teletext.

Can you even find a MHP-capable settop box in the shops today?
Also, as far as I know, the national MHP service was dropped from
terrestrial broadcasting some years ago, and at best there may
be still a regional and minimal service offered by Bayerischer
Rundfunk, but nothing like one finds on Freeview.

Conditions have diverged too much between the two countries these
days.  In the UK, Sky has a lion's share of the market, while I've
barely seen anything but a few sports bars with a Premiere 
subscription.  Also while the commercial public service 
broadcasters in the UK have relied on terrestrial service through
the country, this has not been true of the comparable private
commercial broadcasters in germany, who are not even participating
in terrestrial broadcasting outside of a handful of strategic
centres.  Also, teletext in germany is a service of the individual
broadcasters or contracted out in the commercial case, while the
Teletext and Teletext Holidays and such closing in the UK is its 
own service.


Without support already in place for a transition away from VBI-
based teletext over the coming years, I can't see it happening.
I know that Austria made a big deal of their MHP-based ORF text
service, but I don't know how great a penetration it has.  I've
read tht it requires significant bandwidth of the terrestrial
multiplexes, while conventional teletext requires around that of
an audio channel -- back when ZDFvision was sending MHP data plus
AC3 streams terrestrially, I clocked four MHP streams each with a
data rate comparable to a lower-quality audio stream, together
some twice the data rate of each of the three separate teletext
streams.



> > What slow update rate please?
> > What the hell are you talking about, man?
> 
> Previously information available there was updated within minutes, now
> in best case every six hours it seems to me.

I don't know what services you are viewing; those which I use
are updated within seconds of updated data, and happen to be the
first place I turn to for current information.  The amount and
quality of information I get from conventional teletext is far
more impressive than what I see on the BBC's Red Button service.


barry bouwsma
