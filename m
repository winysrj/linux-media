Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:41411 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915AbZGCPMw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 11:12:52 -0400
Received: by ewy11 with SMTP id 11so1142079ewy.37
        for <linux-media@vger.kernel.org>; Fri, 03 Jul 2009 08:12:54 -0700 (PDT)
Date: Fri, 3 Jul 2009 17:12:39 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Andrej Falout <andrej@falout.org>
cc: linux-media@vger.kernel.org
Subject: Re: Digital Audio Broadcast (DAB) devices support
In-Reply-To: <c21478f30907010112v5780b345icb22fdbb94dd84dd@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.0907031558540.2210@ybpnyubfg.ybpnyqbznva>
References: <c21478f30906301936u40ac989fj9e2824b209ab2346@mail.gmail.com> <alpine.DEB.2.01.0907010911570.5262@ybpnyubfg.ybpnyqbznva> <c21478f30907010112v5780b345icb22fdbb94dd84dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hmmm, seems my original reply didn't make it into the archive I 
use, or else the list...  No matter...  Anyway, sorry for the
delay in this reply:

On Wed, 1 Jul 2009, Andrej Falout wrote:

> Thanks for that Barry, it seems Terratec Cinergy Piranha was indeed
> discontinued, as I cant find it in shops anywhere? It's still on the
> web site (http://www.terratec.net/en/products/Cinergy_Piranha_1668.html)

These days you will probably have the best luck via ebay or
similar, though I had seen some shops which appeared to be
wanting to clear out their old inventory -- this may depend on
where you search, though.


> But on Terratec site, there is no mention of Linux drivers for this product.

This is -- to me, with background knowledge -- no big surprise, as
the support which exists is not so much `drivers' as you might
expect to find packaged on a CDROM with loads of other useless
drivel, but rather, more of an expert-playground thing where the
linux driver is patched to give access to a proprietary API which
gives you access to be able to tune into the DAB family of
broadcasts.

There does not even exist an official application for tuning into
a particular broadcast stream, although for someone familiar with
DAB broadcasting and the API which Siano has made available, this
should be no problem -- one list subscriber had in fact written a
somewhat primitive tuning application which I've been using (and
many thanks, you know who you are), though it in no way matches
the needs of today's GUI-infested youth.

You will want to search the linux-dvb mailing lists for posts
from one Uri Shkolnik to find pointers to the needed patches
that can be used with the Siano devices.  But as I say, if you
want a polished product that you can plug in and use, that is
likely still a way off.  What Uri, Siano, and the author of the
utility I use to tune, have provided, is a ground-level 
introduction to the DAB family, that can be scripted for tuning
a particular service, but which is unsuitable for channel zapping
or other non-dedicated listening.

I suspect that what Siano has made available is intended more for
suppliers who include their chipsets in integrated handy devices
or similar receivers which hide their function from the end-user.

Still, if you have a particular service you wish to receive via
the DAB family, with minimal interest in zapping to other stations
during advertising or tediously-repeated songs, then the ``hacker-
oriented'' solution made available to the not-faint-hearted may
be a good solution.  Obligatory disclaimer:  ``It werkz fer me''
so for the masses, fergiddabou'it.


> Anyone else know of something equivalent that works on Linux?

For laughs, I g00gled again to see what is new in the last months.
There appear to be a number of chinese products out there which
can tune DBM as well as the DAB family.  However, I see no mention
of chip manufacturer.  Probably the best one can do here is to
plug in such a device -- if readily available -- and see if the
USB ID corresponds to Siano or some similar manufacturer.

I don't know how widespread these devices are, nor do I know if
any of today's devices include the chip announced by (I believe)
Dibcom a year or more ago.  Apart from the handful of Siano
devices, I am not aware of any DAB-family devices with any sort
of linux support, but I would hope that as this form of 
broadcasting gains prominence in certain countries, that more
devices will make available support for linux.  With the current
political situation, this appears to focus on chinese and
similar manufacturers, even where development is mandated for
France, Switzerland, Germany, and other european countries.


As far as the V4L or linux-dvb interface is concerned, as the
Eureka 147 family of broadcasts is very different from the DVB
family, there is not yet any provision for any application to
access the former, so for now, you will have to make do with
the API offered via Siano for their devices.  Whether this will
change is up to the manufacturers or distributors of any such
devices, or an expert on the Eureka-147 family, and whether
such changes can get added into the appropriate Linux API.


barry bouwsma
