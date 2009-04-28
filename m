Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.foxt.com ([192.71.43.9]:46774 "ehlo test"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754218AbZD1JNH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 05:13:07 -0400
Date: Tue, 28 Apr 2009 11:05:57 +0200 (CEST)
From: kirin_e@users.sourceforge.net
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: TV-8532A/ICM532B compression and modes
In-Reply-To: <20090426120512.6404e900@free.fr>
Message-ID: <Pine.GSO.4.58.0904281052450.28274@zvygba.sbkg.pbz>
References: <Pine.GSO.4.58.0904242256500.7228@zvygba.sbkg.pbz>
 <20090426120512.6404e900@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Sun, 26 Apr 2009, Jean-Francois Moine wrote:

> On Fri, 24 Apr 2009 23:16:12 +0200 (CEST)
> kirin_e@users.sourceforge.net wrote:
>
> > Hi,
>
> Hi Kirin,
>
> > a couple of months ago i did some hacking on the tv8532 gspca driver
> > for my TV-8532A/ICM532B based webcam, to the point where i got
> > decompression and most modes working. But i've kind of lost interest
> > at this point, so haven't bothered to clean everything up for a real
> > patch(also noticed it doesn't apply cleanly on 2.6.29 anymore).
> >=20
> > In case it could be of help to someone else i've attached my two
> > patches against the 2.6.28 kernel driver. First one fixes packet
> > handling so it works with the different modes, the second add the
> > actual modes i've been using + some misc changes i've been playing
> > around with. Feel free to use or ignore as you will.
> >=20
> > And probably the more useful part of my hacking, here's my notes on
> > the compression used(got working decompression code, but not in a
> > state i'd like to release):
>                [snip]
>
> Your patches seem very interesting! I would have merge it by myself,
> but I have too much work. May you do patches for my test repository
> (http://linuxtv.org/hg/~jfrancois/gspca)?

Hi Jean-Francois,

i'll see if can get around to making a working patch against your
repository sometime. At the moment i have the same problem as you, too
much other stuff taking my time and interest.

Btw, if you've been working with the gspca drivers do you have any opinion
on where to put the decompression code? I know libv4lconvert exists so it
shouldn't be done in the kernel. But what to do if decompression is
depending on driver state like quantization settings and packet headers,
should the settings just be sent along with the image data to
libv4lconvert so it can do the correct thing? For now i've been doing it
all in the driver.

//kirin
p]
>
> Your patches seem very interesting! I would have merge it by myself,
> but I have too much work. May you do patches for my test repository
> (http://linuxtv.org/hg/~jfrancois/gspca)?

Hi Jean-Francois,

i'll see if can get around to making a working patch against your
repository sometime. At the moment i have the same problem as you, too
much other stuff taking my time and interest.

Btw, if you've been working with the gspca drivers do you have any opinion
on where to put the decompression code? I know libv4lconvert exists so it
shouldn't be done in the kernel. But what to do if decompression is
depending on driver state like quantization settings and packet headers,
should the settings just be sent along with the image data to
libv4lconvert so it can do the correct thing? For now i've been doing it
all in the driver.

//kirin
