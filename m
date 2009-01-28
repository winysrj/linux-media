Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:24298 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZA1CtO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 21:49:14 -0500
Received: by ug-out-1314.google.com with SMTP id 39so274415ugf.37
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2009 18:49:12 -0800 (PST)
Date: Wed, 28 Jan 2009 03:49:03 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: DVB mailin' list thingy <linux-dvb@linuxtv.org>
cc: linux-media@vger.kernel.org
Subject: Unicode Teletext (was: Re: [linux-dvb] getting started with msi tv
 card)
In-Reply-To: <20090127204817.GB4254@debian-hp.lan>
Message-ID: <alpine.DEB.2.00.0901280322240.15738@ybpnyubfg.ybpnyqbznva>
References: <4975B5F1.7000306@iki.fi> <20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi> <20090121003915.GA6120@debian-hp.lan> <4977088F.5080505@iki.fi> <20090122092844.GB14123@debian-hp.lan> <alpine.DEB.2.00.0901222327370.13623@ybpnyubfg.ybpnyqbznva>
 <alpine.DEB.2.00.0901230956260.13623@ybpnyubfg.ybpnyqbznva> <20090127110710.GA10439@debian-hp.lan> <alpine.DEB.2.00.0901271537480.15738@ybpnyubfg.ybpnyqbznva> <20090127204817.GB4254@debian-hp.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 28 Jan 2009, Daniel Dalton wrote:

> > Maybe a full Unicode X font will include such characters
> > and I can simply map them to UTF8, but I'm primarily
> > interested in the text content information on my text console.
> > 
> > Here's the pr0n...
> > 
> >                       ???X???X*XX*???*???????           XXX*    AMI
> >                       ???X??????*??? ???X?* ???          **XXXX
> > 
> > No, this is not going to work.  There are too many characters
> > which are not yet converted to something and I'm having to add

> ah, ok... I kinda get it... :-)

Actually, your `mutt' mailer has managed to convert the
UTF-8 encoding which I hope you received into ASCII and
substituted its own `?' for those block characters which
should have appeared as correct UTF-8, though I'll need to
check an archive.

And after quite a few too many hours, I still don't get it,
and I'm going to have to ask help from the collective
knowledge pooled here.

I've seen that the 10646 encoded fonts available usually
have the familiar box-drawing and related characters I've
partly been able to use for a few of the graphics.

Unfortunately, these seem to be either based on a 2x2 set
of quads, or a 3x4 array.  While the teletext graphics in
use uses a 2x3 array.

I've come upon two sets of fonts which supposedly cover
the teletext character set with a 10646 encoding.  But
the first one, which does include the 2x3 graphics chars
that otherwise need a `fontspecific' encoding, seems to
have hijacked existing assigned unicode characters in
order to display the graphics.

That is, with this font, these characters no longer display
properly (selection limited due to pasting from a 512-char
console font)
[◆]  U+25C6   &#9670;  BLACK DIAMOND
[◊]  U+25CA   &#9674;  LOZENGE
This is matched by reading the code:
const wchar_t graphutf8[128] = { // Graphic characters on an unicode terminal ISO-10646
[...]
        0x25A0,0x25A1,0x25A2,0x25A3,0x25A4,0x25A5,0x25A6,0x25A7, 
[...]
        0x25B0,0x25B1,0x25B2,0x25B3,0x25B4,0x25B5,0x25B6,0x25B7, 
[...]
        0x25C0,0x25C1,0x25C2,0x25c3,0x25C4,0x25C5,0x25C6,0x25C7, 
[...]
0x25D8,0x25D9,0x25DA,0x25DB,0x25DC,0x25DD,0x25DE,0x25DF,
};

I'm still trying to determine whether the second font has any
graphics and where they would be hidden -- even the handy
[█]  U+2588   &#9608;  FULL BLOCK
character is missing.


Does anyone know whether the various 2x3 graphics used in
teletext fonts are in fact present in Unicode?  I haven't
been able to convince google to give me the answer I want.
I would think that with everything I do see with a unifont
font, that such widely-used characters wouldn't have been
left out...


thanks for any pointers,
barry bouwsma
