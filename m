Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:33101 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZA0PrO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 10:47:14 -0500
Received: by ug-out-1314.google.com with SMTP id 39so228985ugf.37
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2009 07:47:12 -0800 (PST)
Date: Tue, 27 Jan 2009 16:46:02 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Daniel Dalton <d.dalton@iinet.net.au>
cc: linux-media@vger.kernel.org,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] getting started with msi tv card
In-Reply-To: <20090127110710.GA10439@debian-hp.lan>
Message-ID: <alpine.DEB.2.00.0901271537480.15738@ybpnyubfg.ybpnyqbznva>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi> <20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi> <20090121003915.GA6120@debian-hp.lan> <4977088F.5080505@iki.fi> <20090122092844.GB14123@debian-hp.lan>
 <alpine.DEB.2.00.0901222327370.13623@ybpnyubfg.ybpnyqbznva> <alpine.DEB.2.00.0901230956260.13623@ybpnyubfg.ybpnyqbznva> <20090127110710.GA10439@debian-hp.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Jan 2009, Daniel Dalton wrote:

    [Now, ideally, a teletext service, being text-based, can be]
> > trivially converted to braille or spoken.  I'm not sure about
> 
> Braille..., what format do they originate in? Is it tv signal, or some
> kind of text guide or something?

The teletext service I hope you would be able to get, is sent
as part of the digital service.  Here I will quickly explain
that a Transport Stream, which is used by DVB-T, mixes together
digital versions of several services, including audio soundtrack,
or radio, as well as video signals, and additional data services,
with each component being able to be identified by its own ID.

A conventional set-top-box will convert the video from its
digital form to an analogue equivalent, then convert the audio
soundtrack into its analogue form, and decode and add the
teletext to the video signal, perhaps also including its own
internal teletext decoder for user convenience.

Then these analogue signals are delivered to your tv by one of
many means, be it as an RGB signal through a SCART connector,
or in the worst case, by modulating an RF carrier.

But your Linux machine will be working with the Transport
Stream directly, selecting the particular IDs of interest.
When you look at that particular ID, you see merely a
datastream including the payload.

So, just as your TV audio will be carried in a form which
will be similar to the mp3 files you've certainly used, or
whatever format, you can also write the teletext data to
a file and work with that.

When you get your tuner working, or one that does, if you
do receive a teletext service, I'll guide you through the
steps needed to actually see the content being broadcast.

As a little teaser, I will paste part of a hexdump of an
update to today's rates of the example I posted earlier.

000001c0  20 20 20 20 20 cb 61 6e  61 64 61 ae ae ae ae 20  |     .anada.... |
000001d0  a8 43 c1 c4 29 83 20 20  31 2c b6 31 38 37 02 20  |.C..).  1,.187. |
000001e0  ab b0 2c b3 37 25 07 31  32 ba b0 37 20 d3 fd 64  |..,.7%.12..7 ..d|
000001f0  61 e6 f2 e9 6b 61 ae 20  a8 da c1 52 29 83 20 31  |a...ka. ...R). 1|
00000200  b3 2c b3 37 b6 31 02 20  ab b0 2c b5 b6 25 07 31  |.,.7.1. ..,..%.1|
00000210  31 ba b5 b0 20 c8 ef 6e  67 6b ef 6e 67 ae ae 20  |1... ..ngk.ng.. |
00000220  a8 c8 cb c4 29 83 20 31  b0 2c 32 b5 b6 37 02 20  |....). 1.,2..7. |
00000230  ab b0 2c 31 b6 25 07 31  31 ba 34 b9 20 d3 e9 6e  |..,1.%.11.4. ..n|

There are some readable parts of words (Canada, Hongkong)
to be seen in the ASCII dump at the right, but it is not
quite a simple text dump.

The program I hacked to display this in text form does
the conversion into ASCII with the added characters for
the particular language in use.

So, to answer your question, essentially it is a text
guide.


Now, the MHEG service, in contrast, is Java based, and I
have downloaded a good number of files, both text and
binary, that would be used to display a particular page.
However, I can't see a simple way to get at the text
info within and display it.  That would be for someone
who has studied and understands this service.


> Thanks, that looks interesting, so does it all depend on what service is
> available here in Australia?

That is correct.  One more thing I should note, is that
this text type of teletext supports, and broadcasters
generally make heavy use of, features such as colours,
double-height and blinking characters, and in particular,
parts of character blocks that can be used to create
simple graphics.  Think of some sort of ASCII art, or,
with the most common use made of these graphics by
commercial broadcasters, ASCII pr0n.

DANGER!  ASCII PR0N PASTED BELOW!  SENSITIVE READERS
SHOULD AVERT THEIR GAZE OR SKIP TO THE NEXT MESSAGE!
^L
I MEAN IT!  IT COULD QUALIFY AS EXTREME PORN!
^L
THAT'S IT, I TAKE NO RESPONSIBILITY FOR YOUR ACTIONS!

This pr0n is made worse by the fact that my console font
does not include the full range of teletext partial blocks,
so I've substituted characters such as `*' and `X' to try
and give a feel for how the graphics should appear.
Maybe a full Unicode X font will include such characters
and I can simply map them to UTF8, but I'm primarily
interested in the text content information on my text console.

Here's the pr0n...

                      █X█X*XX*???*?██           XXX*    AMI
                      █X?█??*█ █X?* █          **XXXX

No, this is not going to work.  There are too many characters
which are not yet converted to something and I'm having to add
as `?' by hand.  Anyway, the blocks on the left are used to
form words; to the right the blocks would be forming the top
of a female head.

                     auszuziehen.Magst     *X*███XX*██
                     Du mir die Kleider     *XX████X* ██
                     vom Leib reissen?     XX██████* X█*

At the right, part of a stomach and arm

Well, anyway, if these non-ASCII full blocks have made it
through intact and are diplaying correctly anywhere, that
is an example of the crude (in more than one sense of the
word) images one can make from the text medium of teletext.

And as far as colour -- the background would be black,
with the blocks-forming-letters as well as the text yellow,
and the female image formed from red partial blocks.


Ah, another UTF8 project for me to add to my list...

barry bouwsma
