Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:46433 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZBQIon (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 03:44:43 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: Jonathan Isom <jeisom@gmail.com>
Subject: Re: firmware
Date: Tue, 17 Feb 2009 09:44:37 +0100
Cc: CityK <cityk@rogers.com>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Michele <aspeltami@gmail.com>, linux-media@vger.kernel.org
References: <200902152115.58993.aspeltami@gmail.com> <4999A9A6.2080809@rogers.com> <1767e6740902161024y2820036dhcd461c40edf30e82@mail.gmail.com>
In-Reply-To: <1767e6740902161024y2820036dhcd461c40edf30e82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170944.37882.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Montag, 16. Februar 2009, Jonathan Isom wrote:
> --------------------------------------------------------------------
> ASUS m3a78 mothorboard
> AMD Athlon64 X2 Dual Core Processor 6000+ 3.1Ghz
> Gigabyte NVidia 9400gt  Graphics adapter
> Kworld ATSC 110 TV Capture Card
> Kworld ATSC 115 TV Capture Card
> --------------------------------------------------------------------
>
> On Mon, Feb 16, 2009 at 12:00 PM, CityK <cityk@rogers.com> wrote:
> > Matthias Schwarzott  wrote:
> >> I don't get you.
> >
> > I was having a little fun.  My remarks contained references to Lewis
> > Carroll's "Alice's Adventures in Wonderland".
> >
> > Nowadays, the expression "follow the rabbit" (which, stemming from
> > Alice's Adventures, is actually  abbreviated from the act of following
> > the rabbit down the hole) implies that one will discover something by
> > following the metaphorical rabbit (which, in this case, was the link to
> > wiki article on firmware, which itself  contained links to the xc3028 IC
> > family article).
> >
> > Though perhaps not a particularly common expression, I'm sure that most
> > are familiar with it or have come across it in other forms and
> > presentations.  Pop culture, for example, has many such references --
> > take the movie "The Matrix", for example, in which, IIRC, the character
> > Morphieus invites Neo to "follow the rabbit"
> >
Ah yes, now it's clear.

Btw. I also had a longer look at the firmeware page in wiki and removed that 
note about gentoo using hotplug-scripts as that is false since a long time. 
CityK you are right, I think most (if not all) current distributions use udev 
to create device nodes and upload firmware into the kernel.


Yes this ebuild is there. But it is in some respect outdated, due to lack of 
maintaining. This ebuild fetches the original files get_dvb_firmware also 
fetches and the runs get_firmware to unpack them. (All this due to 
license/re-distribution issues as you all know).

But: These URLs tend to no longer work after some time, as manufacturers 
update their drivers or web-pages :(

So there should either be someone continuously updating them (in 
get_dvb_firmware and also here in copy).
Or: We find someone ignoring the licenses and hosting the extracted files 
somewhere.

Regards
Matthias
