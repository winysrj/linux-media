Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:34156 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZAZDY0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 22:24:26 -0500
Received: by ug-out-1314.google.com with SMTP id 39so106066ugf.37
        for <linux-media@vger.kernel.org>; Sun, 25 Jan 2009 19:24:24 -0800 (PST)
Date: Mon, 26 Jan 2009 04:24:14 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: linux-media@vger.kernel.org
cc: DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] How to use scan-s2?
In-Reply-To: <c74595dc0901250856s6b230b8cqc21f8cfa455f676b@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0901260241550.15738@ybpnyubfg.ybpnyqbznva>
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de> <c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com> <20090125144112.86930@gmx.net> <c74595dc0901250654l49b419dcw2327b1cfb0ebe0dc@mail.gmail.com> <20090125162959.86940@gmx.net>
 <c74595dc0901250856s6b230b8cqc21f8cfa455f676b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 25 Jan 2009, Alex Betis wrote:

> On Sun, Jan 25, 2009 at 6:29 PM, Hans Werner <HWerner4@gmx.de> wrote:
> > > On Sun, Jan 25, 2009 at 4:41 PM, Hans Werner <HWerner4@gmx.de> wrote:

> > > > > If you have a stb0899 device, don't forget to add "-k 3".

> > > > Oh. Can someone say what's different about the stb0899 here,
> > > > and how -k 3 helps ?

> > > stb0899 driver (or maybe the chip?) has some buffers inside that are not
> > > reset between tunnings.
> > > In that case messages from *previous* channel will arrive after the
> > > tunning
> > > to new channel is complete.
> > > Those messages will create a big mess in the results, such as channels
> > > without names, duplicate channels on different transponders.
> > > -k option specifies how many messages should be ignored before processing
> > > it. I couldn't think of a more elegant way to ignore messages from
> > > previously tuned channel. I use "-k 3" by myself, but after playing
> > around
> > > with "-k 2" saw that its also working. "-k 1" was still not enough.

> > OK, thanks, I will check if I see that problem. Which card(s)
> > did you see this with?

> I'm aware only about Twinhan 1041 and TT-3200 based stb0899 cards. Both have
> the same problem.

This may be going typically off-topic, but I do experience
similar artifacts with some STV0299 cards (looks superficially
alike; I don't know), which I'll toss out here just for giggles.

It turns out I have three if not four such stv0299 cards, and
I either experience `scan' difficulties or recording issues,
or nothing.

First off, for reference:  a PCI SkyStar2 card that gets
priority for recordings, using a 2.6.14-ish kernel that I'm
in the long slow process of planning to update on that
production machine.

When making two recordings separated by time from the same
transponder, often the second recording will have a few
video frames left over from the previous recording.  This
appears in my quality-control as video frames with differing
timestamps as well as errors when run through `mplayer'
video codec ffmpeg12, but timing data remains intact (I can
`dd' away the first second or more and get a flawless
partial transport stream).

This is not a problem when I switch between transponders
to make the second recording.  And it can be many hours
between recordings from the same transponder, yet the
leftover data still remains.

I've never noticed that this affects `scan' which changes
transponders; that in itself seems to be enough to lose
the buffered data.  This is only a minor concern as the
first few frames of confused data are almost certainly
disposable, as a fraction of a second in the padding
leading up to the content of interest.


As exhibit number two, where I have had problems with
regular `scan' seeing data from the previous transponder
and causing problems getting current data, another
stv0299-based device, the Opera-1 USB-connected tuner.
I have *never* seen any recordings made from this
device contain frames from an earlier tuning session,
though.

As far as `scan' tuning goes, I would regularly see
previous ``phantom'' channels appearing, combined with
zero-value PIDs for channels on the intended current
transponder.  At least until recently; my latest scans
have been flawless, either due to hacks I added to
that `scan' or to kernel updates on that test machine.


Exhibit C, m'lud, will be -- again on the 2.6.14-ish
kernel machine, but this time connected via USB 1.1 --
an early Nova-S device.  Apart from bandwidth issues
due to the usb1 interface, I've never noticed problems
with stale packets when recording from either the same
or a different transponder.  I do have other issues
which may be due to the age of the kernel, but `scan'
also has not had problems.


Now with exhibit IV, again I see problems similar to
those experienced with leftover packets, but which
appear to be compounded by the internal mangling of
the transport stream components into a proprietary-
yet-open delivery stream.  This device is the ttusb-
dec DEC3000-s, of unknown-based-on-kernel-code
heritage, though I may have taken it apart long ago
and written the results on a long-since hidden drive.

This device is connected via USB1, and is incapable
of delivering more than an MPEG2 video and mp2 audio
stream to a recording, making it useless for multiple
audio, teletext, AC3, H.264, or PMT tables to start.

It also internally converts the transport stream
into the PVA format, with side-effects such as that
the timestamps do not match the original transport
stream components, cycling after some 40 000 secs
rather than the 90 000-ish seconds delivered in the
streams from other devices.

Recordings from this device all-too-often would have
timing problems as well as leftover data from a
previous recording.  (Whether from same or different
transponder, I cannot say.  I added a hack-workaround
to my recordings to tune briefly a different txp,
then tune back.  Sometimes it worked.  Often with
high load, nothing could help.)  Sometimes the timing
would be based on the leftover video data and would
increase linearly from that, being well out-of-step
with the audio timing.  Other times the video data
timing would be stuck at a non-increasing value.
Obviously this caused major problems with utilities
like `mplayer' which try to skew the presentation of
the data until the timestamps match; other applications
could better (though not perfectly) handle some data
with botched timestamps and at least display a
watchable video with consistent sub-second audio
offset.

Yet, a few recordings from this device would have
the video data totally corrupt and unrecoverable
without great and pointless effort.  Anyway, the
timing issues even when correctly recorded as
partial transport streams cause problems seeking
with `mplayer' at times, so basically I limit any
use of this device nowadays to audio recordings
where timing doesn't matter after being stripped to
a simple mp2 file, and even then, often this device
can't recover from a temporary loss of a quality signal
(heavy rainstorm, half a metre of snow on the LNB)
so, well, yeah.

Use of `scan' was made using this device in the
distant past; I neither remember blatant problems
nor obvious successes other than issues with one
particular device with the BSkyB Open-dedicated
transponders.  It generally works recording radio
unless it's somehow half-bricked itself needing a
power-off, but due to the timing issues and
occasional botched video recording, I've avoided
using it for anything else for quite a few months
now.

This device is used regularly to record audio, and
due to the nature of its tuning, I generally need
to specify an unused PID as video, lest a previously-
used video PID carry over to a different transponder
(or the same) and add many times over the bulk to
the recording.  Not so much an issue since I've
avoided it for video recordings...

I've had a few cases recently where due to whatever
reason (power failure, use of `kill'), the previous
recording from this device has not been closed
cleanly.  The next recording made, then has several
seconds worth of leftover audio.  Often this will
precede the desired audio at a different bitrate.
In order to skip the stale data, I'll need to `dd'
the file with a `skip=' parameter, else my player
will fail to detect the change.  For audio recordings
the last few which have had this problem have been
coarsely ``fixed'' by a value of `skip=1200', with
transport stream frame blocksize `bs=188'.

Whether this value transfers to video, I cannot
say.  Generally I prefer to lob off the minutes
worth of padding I provide to accommodate programme
over-/under-running and similar last-minute changes,
than to worry about an uninteresting stream.  The
lower bandwidth of audio makes a tweak of 100 TS
frames more meaningful and easier to handle.

As a side note that eventually, as part of my slow
progress in updating the 2.6.14-ish machine to the
requirements of today's Real World (use of flash
storage via USB for the entire OS has successfully
passed the one-month-without-panic mark and is now
poised for widespread adoption), I've also noticed
that at least with the .14-ish kernel, and perhaps
on the test machine with .18-era, I have not been
able to get this plus the other USB1 device to
coëxist and simultaneously function via the same
bus, getting a panic when using both devices
simultaneously.  I intend to verify this with a
far-more-recent kernel before complaining loudly.

Note that in general, shared use of a USB1 port
should not cause me problems, as I've pretty much
limited use of my USB1 devices to lower-bandwidth
radio streams, or to a handful of channels whose
bandwidth never approaches that of DVD-quality;
that is, generally non-german-public-broadcasters.


Wow, I'm able to talk about nothing for minutes on
end.  Too bad I can't type so fast and spend the
remaining time coding something useful...


barry bouwsma
scum
