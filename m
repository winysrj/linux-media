Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932682Ab1BWW3Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 17:29:24 -0500
Message-ID: <4D658A40.9050604@redhat.com>
Date: Wed, 23 Feb 2011 19:29:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Question on V4L2 S_STD call
References: <AANLkTikqDACH2rVd6PBVr3eofnJP-UmD0bNDar9RDUoL@mail.gmail.com>
In-Reply-To: <AANLkTikqDACH2rVd6PBVr3eofnJP-UmD0bNDar9RDUoL@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-02-2011 18:09, Devin Heitmueller escreveu:
> Hello there,
> 
> I was debugging some PAL issues with cx231xx, and noticed some
> unexpected behavior with regards to selecting PAL standards.
> 
> In particular, tvtime has an option for PAL which corresponds to the
> underlying value "0xff".  This basically selects *any* PAL standard.

Not all PAL standards. "Only" the european PAL standards (B/G/D/K/I/H):

#define V4L2_STD_PAL		(V4L2_STD_PAL_BG	|\
				 V4L2_STD_PAL_DK	|\
				 V4L2_STD_PAL_H		|\
				 V4L2_STD_PAL_I)

PAL/M, PAL/N, PAL/Nc and PAL/60 are not part of it. This is the equivalent
of the V4L1 definition for PAL (on V4L1, there was just PAL/NSTC/SECAM, and
a hack, at bttv, for 4 more standards).

In a matter of fact, V4L2_STD_PAL is not a meaningful parameter, as
it doesn't cover all PAL standards, and if user selects it, an unpredictable
result may happen, as almost no driver is capable of auto-detecting all
variants of the PAL standards. The same issue also happens, on some extend, 
with V4L2_STD_SECAM and V4L2_STD_NTSC (the last case generally falls back
to NTSC/M, so people in Asia will likely have problems).

There's even a worse standard: V4L2_STD_ALL (yes, a few drivers handle it
properly, for example, tvp5150 can use it for video).

Basically, there's just one way to make users happy with things like PAL:
enable hardware auto-detection for all standards at the standard mask.
Unfortunately, this is is generally not possible, due to hardware issues.

The drivers should do things like:

if (standard == V4L2_STD_PAL_I) {
	/* Select PAL/I standard */
} else if (standard == V4L2_STD_PAL_N) {
	/* Select PAL/N standard */
} else if ((standard & V4L2_STD_MN) == V4L2_STD_MN) {
	/* enable STD M/N autodetection */
} else if ((standard & V4L2_STD_PAL && !(standard & ~V4L2_STD_PAL)) {
	/* enable PAL autodetection for B/G/D/K/H/I */
...
} else {
	/* enable autodetection for all supported standards */
}

Testing first for restrict standards, then for more generic ones, adding
autodetection code for them.

> However, the cx231xx has code for setting up the DIF which basically
> says:
> 
> if (standard & V4L2_STD_MN) {
>  ...
> } else if ((standard == V4L2_STD_PAL_I) |
>                         (standard & V4L2_STD_PAL_D) |
> 			(standard & V4L2_STD_SECAM)) {
>  ...
> } else {
>   /* default PAL BG */
>   ...
> }

This doesn't soung wrong to me.

> As a result, if you have a PAL-B/G signal and select "PAL" in tvtime,
> the test passes for PAL_I/PAL_D/SECAM since that matches the bitmask.
> The result of course is garbage video.

Garbage on some Countries, good video and audio on others. People where
PAL/D or PAL/I is the standard will be happy with this.

> So here is the question:
> 
> How are we expected to interpret an application asking for "PAL" in
> cases when the driver needs a more specific video standard?
> 
> I can obviously add code to tvtime in the long term to have the user
> provide a more specific standard instead of "PAL", but since it is
> supported in the V4L2 spec, I would like to understand what the
> expected behavior should be in drivers.

Basically, tvtime does the wrong thing with respect to video standards.

The simplest fix is to enumerate the supported standards and to display
them to the userspace, letting userspace to select a standard, allowing
them to tell the driver what standard is needed, and not requiring a restart
if the user changes the video standard, especially if the number of
lines doesn't change.

Another way would be to ask user where he lives and then tell the kernel
driver to use the standards available on that Country only. This won't work
100%, as the user may want to force to a specific standard anyway (for
example, here, most STB's output signals in NTSC/M, but the broadcast and
official standard is PAL/M). People with equipments like VCR/game consoles
and other random stuff may also need to force it to PAL/60, NTSC/443, etc
for the composite/svideo ports.

What most drivers do is to first select the more specific standards,
assuming that, if userspace is requesting a specific standard, this 
should take precedence over the generic ones. If everything fails, go
to the default PAL standards.

Cheers,
Mauro
