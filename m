Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LKAho-0002Xp-4Y
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 13:06:45 +0100
Received: by ug-out-1314.google.com with SMTP id x30so1401935ugc.16
	for <linux-dvb@linuxtv.org>; Tue, 06 Jan 2009 04:06:40 -0800 (PST)
Date: Tue, 6 Jan 2009 13:06:29 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Yusuf Altin <yusuf.altin@t-online.de>
In-Reply-To: <1231240910.3778.9.camel@yusuf.laptop>
Message-ID: <alpine.DEB.2.00.0901061251250.16894@ybpnyubfg.ybpnyqbznva>
References: <1231015340.2963.7.camel@yusuf.laptop>
	<ea4209750901040640k532f2dc0rf918fb4967a4a19d@mail.gmail.com>
	<1231145794.2968.15.camel@yusuf.laptop>
	<ea4209750901050252i76e0e6cdvd4ae7ea142facc25@mail.gmail.com>
	<1231208271.27507.18.camel@yusuf.laptop>
	<ea4209750901060317m2035e6d6k556327f1170ec0f@mail.gmail.com>
	<1231240910.3778.9.camel@yusuf.laptop>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy T Express
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

On Tue, 6 Jan 2009, Yusuf Altin wrote:

> just in time I find out, if I keep my flagpol antenna horizontal, every
> channel works fine and without artefacts.

First of all, may I *please* *please* *please* ask that
both of you follow some basic netiquette, to make it more
likely that people will read and perhaps follow-up to your
posts.

First, do not top post unless absolutely necessary.

And second, trim away material you're replying to, to leave
just the relevant parts.  There's no need to send ten lines
of new content in addition to some hundred of quoted content
which we've already seen several times -- and worse is to
do the same in HTML <spit> where everything is duplicated
for no real benefit, filling people's mailboxes and taking
time to download over slow links.

Sorry, I'm an old fart from back before the web was even
invented and mail and news were plain text, and it's just
gotten on me tits lately...

Anyway...


> Is it possible to change the polarisation in the source code?

You are presumably somewhere in germany, where the majority
of all DVB-T is sent hor polarisation, as determined by the
physical characteristics of the sending antenna.  But not all.
Unfortunately, the channel lists don't provide the hints you
need to know to set up your antenna correctly.

You need to orient your receiving antenna horizontally; there
are no tweaks in the source code for this as there is no way
to switch between different antennae in the way that satellite
transmission is configured that one LNB can tune complementary
polarisations.  Traditionally a rooftop antenna installation
is composed of several different antennae for the different
bands, and the different transmitter sites, where under the
analogue transmissions, vertical polarisation was used by the
numerous filler stations that have been shut off, leaving the
Grundnetzsender locations which largely are horizontally
polarised.  Those are all mixed into a single feed.

Hope that clears things up, and thanks in advance for following
the conventions of this mailing list.

barry bouwsma
[snip] more lines than I care to count

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
