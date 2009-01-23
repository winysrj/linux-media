Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:27577 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbZAWAmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 19:42:05 -0500
Received: by ug-out-1314.google.com with SMTP id 39so589471ugf.37
        for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 16:42:02 -0800 (PST)
Date: Fri, 23 Jan 2009 01:41:41 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Daniel Dalton <d.dalton@iinet.net.au>, linux-media@vger.kernel.org
cc: DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] getting started with msi tv card
In-Reply-To: <20090122092844.GB14123@debian-hp.lan>
Message-ID: <alpine.DEB.2.00.0901222327370.13623@ybpnyubfg.ybpnyqbznva>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi> <20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi> <20090121003915.GA6120@debian-hp.lan> <4977088F.5080505@iki.fi> <20090122092844.GB14123@debian-hp.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel, I'm combining the replies to several messages
into one response.  This includes private mail for which
there is no on-list content, but I hope that for the sake
of other list-victims, I have included sufficient context...


On Thu, 22 Jan 2009, Daniel Dalton wrote:

> >>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
> >>> tuning status == 0x04
> >>> tuning status == 0x06
> >>> tuning status == 0x06
> >>> tuning status == 0x06
> >>> tuning status == 0x00
> >>> tuning status == 0x06
> >>> tuning status == 0x06
> >>> tuning status == 0x06
> >>> tuning status == 0x00
> >>> tuning status == 0x06
> WARNING: >>> tuning failed!!!

As I noted earlier (privately), the `tuning status' value gives an 
indication of what sort of signal your USB stick is seeing.

I've cut most of the following frequencies, because they
mirror the above values -- you either see 0x0, 0x4, or 0x6.

Except...

> >>> tuning status == 0x1e
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x0010

On this particular (UHF) frequency, you actually were able
to lock onto a signal.  Sadly, this was not enough to get
any information from it...


> So I assume there is no signal? I'm plugging into a co-axle plug in my
> house, which we plug our tv into.
> So do you think my problem is with the card?

A status value of 0x0 means no signal whatsoever.  The
values, if you are interested, can be seen in the source
file /usr/local/src/linux-2.6.27-rc4/include/linux/dvb/frontend.h
(adjust to match your path to the source -- if you are
interested, and it is fine if you are not...)

typedef enum fe_status {
        FE_HAS_SIGNAL   = 0x01,   /*  found something above the noise level */
        FE_HAS_CARRIER  = 0x02,   /*  found a DVB signal  */
        FE_HAS_VITERBI  = 0x04,   /*  FEC is stable  */
        FE_HAS_SYNC     = 0x08,   /*  found sync bytes  */
        FE_HAS_LOCK     = 0x10,   /*  everything's working... */


The value 0x6 is obtained by ORing the above CARRIER and
VITERBI values.  Normally one first gets signal, from which
carrier, viterbi, sync, and finally lock follow in quick
succession.

Basically, this all means that your tuner sees something,
but it can't quite lock onto it.


> Am I better getting a new card? I got this a couple of years ago when I
> was on windows, and never used it, so yeh I don't have the original
> aerial that came with it or the original disks...

As Antti has suggested, you may have better luck with a
new different card.

As an offside, supposedly the linux-dvb mailing list has
been abandoned by every developer, and only a few DVB-freak
luddites remain, and in theory, by posting this to the
linux-media list I should magically reach thousands of
developers who can fix the support for your card.  Riiiight.

For these developers, seeing this for the first time, the
history behind this thread, including details about the
card being discussed, are safely archived on the linux-dvb
mailing list over the past three-or-so days.


Personally, I don't expect support for your card to
magically materialise, though I'd love to be proved
wrong.  Generally it's due to lack of adequate documentation
provided by the device or chipset manufacturers.  I am far
removed from this, sad to say.


> I'm chopping out the script, just to cut the size of this reply
> down. But, thanks very much for sending the script, it looks good, and
> yep, I think I'll find that very useful once I get tv going on my box.

As I always say, my script itself is probably useless,
while the ideas which went into it have value.  The
general idea is that you use the Unix-type way of thinking
of using basic building-block tools stacked together to
come up with the desired result.

This requires one to think at the building-block level,
which may not yet be at your level -- but once you reach
it, if you do, then you have an understanding which almost
brings you to the level of `master of the known universe'.

I'll go over this quickly...

First of all, from the transmitter to your tuner is
something which I will just say is a black box for now,
and you don't need to know more about it, because that
won't help you under Linux -- though it would if you
were to be an engineer or hardware developer, and you
need to know details of modulation and the like.

Where Linux comes into play is the payload carried by
the broadcast.  This is in the form of a (partial)
Transport Stream, which you will be able to obtain from
your device.

There are many different ways to get at this stream,
for example, `tzap' and `cat' from the DVB device, or
using `dvbstream' in my example.  Generally, they are
all similar, in that the end result is the Partial
Transport Stream.

Which leads me to mention that the particular script
I provided has the custom flag `-T' not present in
normal `dvbstream' which simply causes it to Terminate
if it can't tune or open the output file or whatever.
But that's trivial.


The next thing to note, is that I then convert the
Partial Transport Stream into an Elementary Stream,
or more simply, just the audio payload, which corresponds
to an mp2 file.  That's essentially an mp3 file.

Again, there are more-than-one ways to do this.  The
example I gave is my own hack, as you won't find
`ts_audio_es_demux' anywhere, save maybe Google in
reference to this and similar threads.  This is based
on the `ts_es_demux', part of a family of DVB/MPEG
utilities, which I've hacked to do no more than search
for the audio stream.

And naturally, you can use any audio player, be it
mpg123, mpg321, madplay, or probably dozens of others.

The idea is that at each step, you know what you have,
and you know how to handle it.  That's the alternative
to the all-inclusive media player, that could be
overkill, or probably uses an interface that is not
compatible with your vision-impaired userland.


Ahhh.  Sorry, I just needed to say all that...


> I'm connecting it to a co-axle point in my home; I lost the original
> antenna.
> I'm reasonably sure that point should work fine.

I will take your word for it; you are welcome to still
have doubts.  However, if others in your home are able
to tune digital TV signals, then that pretty much
points to your device as having problems.

Particularly if, as Antti has said, your device works
poorly with strong signals.

In the mail you sent off-list, all the VHF channels had
problems (status 0x0,4,or 6) while the UHF channel did
once briefly get a lock -- still not enough to actually
tune anything.

In place of the original antenna, you can try a short
length of wire, say, 5cm long for the UHF frequency, to
about half a metre for the other frequencies.  This will,
depending on your distance from the transmitter, give a
weaker signal that may tune.  Or maybe not.

Also noteworthy is whether the signal is horizontally or
vertically polarised; I personally don't know this, as
I'm halfway around the world from you...


> terminal, and recently when I have been using speech on my laptop, so I
> don't have to carry the display around (speech is terrible by itself),
> lynx works very nice as well.

I have worried that what I write might not work when
converted to speech.  Probably I should not worry, but
be certain that I do not attempt any ASCII graphics that
depend on sight, and of a whole screen.  If, by mistake,
I have done this, please give me the slap I deserve...


> > My attitude to sites with javascript is that I don't bother
> > with them, as I'm searching for info in text format (ASCII

> Ah, ok. I kinda do the same :-)

Of course, minutes after I wrote that, I came across a
brewery whose two pages of links were entirely javascript.
Sadly it's a small, non-local brewery that out of principle
I prefer to support, and I don't need javascript to travel
to the somewhat-distant shop where I'd get that beer, but
that was the reminder I needed that the world is not as
friendly as Slashdot, The Register, and Wikipedia for
useful^[citation needed] text-only info...


> > I think the problem is poor QT1010 tuning performance. You cannot do 
> > much for that now. I recommended to get other stick.
> 
> What model/brand tv card would you recommend me to buy?
> (that is reasonably cheap, doesn't have to do anything fancy). An fm
> radio tuner would also be nice...

This will need input from others with experience...

If you want FM radio, you'll be looking at a hybrid
device, which combines DVB-T ability with analogue
tuning.

Availability seems to depend a lot on geographic
region, so you are going to want to hear from someone
also in Australia who can offer suggestions.

Sadly, I bet I've scared off anyone who could help,
as I've written so much...


Anyway, for the one or two readers who have made it
this far, GET A LIFE!!1!  I mean, sorry, here is some
more info that may be useful, based on my experience
in europe with broadcasters that provide additional
services for audience members with aural or visual
difficulties -- or which I take advantage of as a
non-native where dialects cause problems, or simply
if I want to listen at a low volume to not disturb
the neighbours or sleeping girlfriend...


You have asked about options to `scan'.  I've said
that they don't matter for tuning, as first of all
you need to receive a signal you can work with, and
this has so far been a problem.

Eventually you will be able to tune the different
stations available to you.  Then, the default `scan'
output will be lacking -- it only shows the primary
video and audio information, and gives no details
about additional services such as teletext, or a
second audio-commentary channel.  Of course, I don't
know if the broadcasters available to you offer the
latter service, but I'll assume they are as enlightened
as the public service british or german broadcasters
and that generally a second audio track is available.

If it isn't, stop reading now...

Anyway, `scan' offers a few different output formats,
with the non-defaults offering details about any
additional audio streams.  If you are going to write
your own scripts to tune the audio, and the alternative
audio services are available around the clock as they
are in the above-mentioned german/british broadcasts
via satellite, then you will likely want to use the
second audio channel with audiodescription.  So...

Here is the `vdr' output from the BBC as an example:

BSkyB - BBC 1 London:10773:h:S28.2E:22000:5000:5001,5002:5003:0:6301:32:2045:0

The difference for you is that in the audio PID field,
you no longer see the single PID of 5001, but instead,
you see both 5001 and 5002, with the latter being used
for narrative/audiodescription, which presumably will
be of more interest to you.

The other output format is `pids', and here's that from
back in 2006, before the use of the second audio channel
on the german broadcasters became widespread (last year):

ZDF                      (0x6d66) 01: PCR == V   V 0x006e A 0x0078  \
(deu) 0x0079 (2ch) TT 0x0082 AC3 0x007d

Here PID 0x79 is tagged as `2ch' (it's NAR for the Beeb),
and covers both audiodescription and occasional original-
language (mostly english language) broadcasts without
overdubbing.  This was before DVB subtitles were introduced.

Oh, here's an old BBC `pids' output, also including subtitles:

BBC 1 London             (0x189d) 01: PCR == V   V 0x1388 A 0x1389  \
(eng) 0x138a (NAR) TT 0x138b SUB 0x138c


So, when you do get a useful signal, then you can use the
additional options to `scan' to see what PIDs may be
present for additional dedicated audio channels used for
audio commentary.  I suspect these would be your preferred
audio channels.


Hope this is useful,
barry bouwsma
