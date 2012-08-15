Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2381 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2HOLQc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 07:16:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Steven Toth <stoth@kernellabs.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
Date: Wed, 15 Aug 2012 13:14:47 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Linux-Media" <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com> <50293B36.4060109@redhat.com> <CALzAhNV2A_CWp=dg0S-B2Ts50u+SjuuE-o48OzuaynNw86v-Dw@mail.gmail.com>
In-Reply-To: <CALzAhNV2A_CWp=dg0S-B2Ts50u+SjuuE-o48OzuaynNw86v-Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151314.48007.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue August 14 2012 17:07:55 Steven Toth wrote:
> On Mon, Aug 13, 2012 at 1:36 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Em 13-08-2012 12:49, Hans Verkuil escreveu:
> >> On Mon August 13 2012 16:46:45 Steven Toth wrote:
> >>> Hans,
> >>>
> >>> Thanks for your feedback.
> >>>
> >>> Oh dear. I don't think you're going to like my response, but I think
> >>> we know each other well enough to realize that neither of us are
> >>> trying to antagonize or upset either other. We're simply stating our
> >>> positions. Please read on.
> >>
> >> I didn't think you'd like my response either :-)
> >
> > You probably won't like my answer too, yet I'm also simply
> > stating my positions.
> 
> Hans / Mauro, thank you for your comments and review, very good
> feedback and technical discussion. Truly, thank you. :)
> 
> While I don't necessarily agree with Mauro that adoption of subdev is
> "MANDATORY" (in the larger sense of the kernel driver development -
> and common practices throughout the entire source base), I do hear and
> value your comments and concerns from a peer review perspective.

You're awfully polite for someone whose code has been shot down :-)
Don't worry, I'll buy you a beer in San Diego to soften the pain (or to
drown your sorrows!).

> 1) A handful of simple improvements have been suggested, Eg.
> ioctl_unlocked, double-checking v4l2-compliance, try_fmt, /proc
> removal, firmware loading etc
> 
> Ack. I have no objections. Items like this are fairly trivial, easy to
> address, I can absorb this and provide new patches quickly and easily.
> I'll go back over the detailed comments this weekend and prepare
> additional patches (and retest).

Note that the v4l2-compliance tests are generally more strict than the
spec itself. For example, it assumes that the control framework is used,
that control events are implemented, and that vb2 is used.

Take a look at vivi.c: it implements all the latest infrastructure and it
is now actually a pretty good example of how things should work.

It's also one of the few drivers that passes all v4l2-compliance tests.

The only ioctls that aren't covered yet by v4l2-compliance are:

           VIDIOC_CROPCAP, VIDIOC_G/S_CROP, VIDIOC_G/S_SELECTION
           VIDIOC_S_FBUF/OVERLAY
           VIDIOC_(TRY_)ENCODER_CMD
           VIDIOC_(TRY_)DECODER_CMD
           VIDIOC_G_ENC_INDEX
           VIDIOC_QBUF/DQBUF/QUERYBUF/PREPARE_BUFS
           VIDIOC_STREAMON/OFF

So basically cropping, compression encoder/decoder control and actual
streaming. And the subdev and media API is also not tested, although
those might be beyond the scope of this utility anyway.

Everything else is now tested fairly exhaustively.

> 2) ... and some larger discussion items have been raised, Eg.
> Absorbing more of the V4L2 kernel infrastructure into the vc8x0 driver
> vs a fairly self-contained driver with very limited opportunities for
> future breakage.
> 
> Are you really willing to say that all drivers, with unique and new
> pieces of silicon, need to be split out into independent modules,
> adopting a subdev type interfaces or mainline merge is refused? It's
> not that I'm asking you to merge duplicate functionality, duplicate
> driver code, replicating functionality for new hardware or for an
> existing modules (tuner/demod/whatever). (Like has already happened in
> the past - 18271 for example).

Speaking for myself, I would probably NACK it, yes. I would hate to do it,
but there are IMHO good technical reasons why the ad7441 code should be
implemented as a subdev driver.

> If the answer is Yes, then my second questions is:
> 
> Assuming the comments / issues mentioned in #1 are addressed, are you
> really willing to stand up in front of the world-wide Kernel
> development community and justify why a driver that passes user-facing
> v4l2-compliance tests, is fairly clean, passes 99% of the reasonable
> checkpatch rules, is fully operational, cannot be merged? Really? Is
> this truly an illegal or inappropriate driver implementation that
> would prohibit mainline merge?

Yes. Currently nobody else uses the ad7441 but the viewcast driver. So
splitting it up really shouldn't be too much of a problem: you don't have
to take care of anyone else, and it only has to support the functionality
that you need right now. And as long as nobody else uses that driver it
shouldn't make a difference to you maintenance-wise.

But *if* someone else comes along then that will help them enormously if
an ad7441 driver already exists. We definitely do not want to have duplicate
drivers in the kernel for i2c devices, so either they or you would have to
split up the ad7441 driver from the ViewCast driver, and what are the chances
of that ever happening? Slim to none.

You just want to get your driver merged, which is perfectly understandable,
but I also want to ensure that whatever gets merged can also be reused by
others, where applicable.

In addition to that I have to say that I have been working with Analog Devices
i2c receivers and transmitters for the past 4-5 years, and these things are
complex. I consider it very unlikely that your ad7441 driver covers the full
functionality of the ad7441. By implementing it as a separate driver it will
be much easier for others to work on it and improve it. Yes, that might
require you to do the occasional testing, but hopefully that will improve the
functionality of the ViewCast driver as well by e.g. supporting more formats,
have better colorspace handling, or whatever.

Also note that the Analog Devices receivers/transmitters are fairly popular,
particularly within the embedded hardware world. So it wouldn't surprise me
at all if other products will appear that want to use it.

One other difference with such subdev drivers is that they can be in the
kernel, while the actual V4L2 driver for an embedded product isn't.

Typically on embedded systems the platform V4L2 driver is too product-specific
to ever be considered for upstreaming (and it is usually fairly trivial as
well). But being able to reuse an ad7441-like driver saves companies a huge
amount of time. The adv7604 and ad9883b drivers that are in my queue are like
that: the actual V4L2 driver that uses them won't be upstreamed, but we and
other companies will reuse the subdev drivers. Even better, with a bit of
luck Analog Devices themselves might get involved and start making their own
drivers.

The complexity of V4L2 drivers is in the DMA engine (for embedded devices
this is often provided by the SoC vendor) and in the video receivers,
transmitters and/or sensors (usually i2c devices). More advanced SoCs also
have video processing capabilities, but that too is/should be provided by
the SoC vendor. So as an embedded product developer you generally have the
code for the DMA engine/video processing from your SoC vendor (and V4L2 is
making steady progress there), and that leaves the other complex part: the
i2c receiver/transmitter/sensor. So having that available for reuse in the
kernel makes a big difference in development time. Particularly if you also
want to support analog video input or output (analog takes 10 times as much
development effort as digital does).

BTW, we are talking about the adv7441a, right?
See here: http://ez.analog.com/docs/DOC-1546

There is also a chip called ad7441, but that seems to be something else.
AD has the annoying habit of renaming chips, but at least they've started
making their datasheets freely available, which is very good news for linux.

> The ViewCast 820 is a (circa) $1800 video capture card. It's not the
> kind of hardware that everyone has laying around for regression
> testing purposes. If I 1) split this up and people begin to absorb
> ad7441 functionality into other designs, and start patching it and 2)
> adopt the subdev framework for that matter... then nobody is able to
> regression test the impact to the 820. That puts an incredible amount
> of burden on me. I'm attempting to mitigate all of this risk, but also
> provide a GPL driver so everyone can benefit - without creating a
> future maintenance / regression problem, by relying on subsystems the
> driver simply doesn't need.

What you are basically saying is that you don't want to split it up because
if you do, then other people might reuse the code, change it, and might cause
you a lot of work.

What I am saying is that if you split it up, then other people might reuse it,
improve it and with a relatively small amount of work improve the ViewCast
820 support as well.

I suspect your view of the amount of work it might cost you to test changes
from other people is too pessimistic. It's based on your experiences with the
cx25840, but from my perspective the cx25840 is the exception, not the rule.

And the cx25840 provides a good lesson how it may be counterproductive trying
to support multiple variants of a device in one driver. It only works if the
differences are really small, otherwise it is probably better to make separate
drivers, or make separate drivers, but have them share some common code. It's
something I'm considering for the adv drivers as I have two more drivers in
my queue that are similar, but not identical, to the adv7604 and ad9389b.

On the one hand, there is just too much identical code to justify two fully
independent drivers, but on the other hand there are too many differences as
well. I think it is possible to refactor out clearly common parts that do not
directly touch on registers. I don't know for certain yet, though.

> As always, I do welcome and appreciate your comments and thoughts, no
> flames from me. I do find the 'MANDATORY' comments worthy of
> discussion, or perhaps I've miss-understood something.

No, you understood it perfectly :-)

Regards,

	Hans
