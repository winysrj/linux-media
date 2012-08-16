Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4060 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2HPOve (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 10:51:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Steven Toth <stoth@kernellabs.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
Date: Thu, 16 Aug 2012 16:49:43 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Linux-Media" <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com> <201208151314.48007.hverkuil@xs4all.nl> <CALzAhNWre7qB7OeU=rP1SGoBBHtsxXMsAOMbCPNXTQbmhJeYrw@mail.gmail.com>
In-Reply-To: <CALzAhNWre7qB7OeU=rP1SGoBBHtsxXMsAOMbCPNXTQbmhJeYrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208161649.43284.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu August 16 2012 15:27:51 Steven Toth wrote:
> >> While I don't necessarily agree with Mauro that adoption of subdev is
> >> "MANDATORY" (in the larger sense of the kernel driver development -
> >> and common practices throughout the entire source base), I do hear and
> >> value your comments and concerns from a peer review perspective.
> >
> > You're awfully polite for someone whose code has been shot down :-)
> > Don't worry, I'll buy you a beer in San Diego to soften the pain (or to
> > drown your sorrows!).
> 
> :)
> 
> It benefits everyone when rationale discussion can be had, even when
> points of view differ. The alternative is we shout at each other over
> email. Shouting gets old very quickly and never accomplishes anything.
> 
> >
> >> 1) A handful of simple improvements have been suggested, Eg.
> >> ioctl_unlocked, double-checking v4l2-compliance, try_fmt, /proc
> >> removal, firmware loading etc
> >>
> >> Ack. I have no objections. Items like this are fairly trivial, easy to
> >> address, I can absorb this and provide new patches quickly and easily.
> >> I'll go back over the detailed comments this weekend and prepare
> >> additional patches (and retest).
> >
> > Note that the v4l2-compliance tests are generally more strict than the
> > spec itself. For example, it assumes that the control framework is used,
> > that control events are implemented, and that vb2 is used.
> 
> I made some patches to the current tree to fixup some of the earlier
> comments, firmware loading via nowait, unlocked_ioctl2, /proc removal.
> I also ran the compliance testing tool. After realizing my version of
> v4l2-compliance was a little out of date - and building fresh from
> v4l2-utils, it turned out some highly useful information about the
> driver.
> 
> So, I've ran v4l2-compliance and it pointed out a few things that I've
> fixed, but it also does a few things that (for some reason) I can't
> seem to catch. One particular test is on (iirc) s_fmt. It attempts to
> set ATSC but by ioctl callback never receives ATSC in the norm/id arg,
> it actually receives 0x0. This feels more like a bug in the test.
> Either way, I have some if (std & ATSC) return -EINVAL, but it still
> appears to fail the test.

I think it might be because vdev->tvnorms isn't set for the video node.
It's set for the VBI node, though. If tvnorms is 0, then ENUMSTD will
probably return an empty list, and that might be the cause of the ATSC
test. I also see that current_norm is used: don't do that. Instead store
the current standard yourself and return it in g_std. I'm slowly phasing
out current_norm because 1) it's ugly and 2) it doesn't work if you have
both a vbi and a video node.

> I see some tests which report failure (testing videobuf) but given
> that I essentially pass the ioctl directly into the videbug core, very
> much like every oher driver I've ever done, it's probably either a
> quirk of the tool, or something inside videobuf core itself that needs
> some adjustment. (userptr/mmap for capture or output buffers related
> test).

videobuf does not follow the spec in several areas (most notably and extremely
annoyingly it does not support calling REQBUFS with a count of 0). So any
driver that uses videobuf will fail a number of tests in v4l2-compliance.

These problems are fixed in vb2, which is why I strongly recommend its use in
new drivers. In addition, work on the new DMABUF mechanism for sharing buffers
between v4l2 and drm will only be implemented in vb2.

> In summary, the v4l2-compliance tool has pointed out a few things that
> were worth fixing for sure, and thus I've fixed. It it also feels like
> the tool itself is still evolving. When I get a moment I'll run the
> compliance tool and paste the results here for comment.

It is steadily being improved, that's correct.

BTW, don't forget to also run it for the vbi node (option '-V /dev/vbiX').

Feedback on the tool is very much appreciated! E.g. how to improve it, whether
there are missing, confusing or incorrect tests, etc.

> I'd welcome your feedback on the compliance feedback.

No problem. One set of errors that v4l2-compliance produces is that it fails
if you can change VBI formats using a video node or vice versa. I want to
address that in the V4L2 core rather than having to fix all drivers. It's one
of the topics in the V4L2 ambiguities list for the upcoming workshop.

> > Take a look at vivi.c: it implements all the latest infrastructure and it
> > is now actually a pretty good example of how things should work.
> 
> Noted, that's a useful reference point.
> 
> >
> > It's also one of the few drivers that passes all v4l2-compliance tests.
> >
> > The only ioctls that aren't covered yet by v4l2-compliance are:
> >
> >            VIDIOC_CROPCAP, VIDIOC_G/S_CROP, VIDIOC_G/S_SELECTION
> >            VIDIOC_S_FBUF/OVERLAY
> >            VIDIOC_(TRY_)ENCODER_CMD
> >            VIDIOC_(TRY_)DECODER_CMD
> >            VIDIOC_G_ENC_INDEX
> >            VIDIOC_QBUF/DQBUF/QUERYBUF/PREPARE_BUFS
> >            VIDIOC_STREAMON/OFF
> >
> > So basically cropping, compression encoder/decoder control and actual
> > streaming. And the subdev and media API is also not tested, although
> > those might be beyond the scope of this utility anyway.
> >
> > Everything else is now tested fairly exhaustively.
> >
> >> 2) ... and some larger discussion items have been raised, Eg.
> >> Absorbing more of the V4L2 kernel infrastructure into the vc8x0 driver
> >> vs a fairly self-contained driver with very limited opportunities for
> >> future breakage.
> >>
> >> Are you really willing to say that all drivers, with unique and new
> >> pieces of silicon, need to be split out into independent modules,
> >> adopting a subdev type interfaces or mainline merge is refused? It's
> >> not that I'm asking you to merge duplicate functionality, duplicate
> >> driver code, replicating functionality for new hardware or for an
> >> existing modules (tuner/demod/whatever). (Like has already happened in
> >> the past - 18271 for example).
> >
> > Speaking for myself, I would probably NACK it, yes. I would hate to do it,
> > but there are IMHO good technical reasons why the ad7441 code should be
> > implemented as a subdev driver.
> 
> I hear you. In the spirit of co-operation I'll take a shot at turning
> ad7441 into a subdev and see what odd problems shake out of the
> process. I should be clear that the resulting subdevice will likely be
> very 820 specific in terms of configuration, but it's a reasonable
> cut-point.

That's a perfectly valid approach. Frankly, I think it is counter productive
to try and make a more general implementation. You only end up with code that
you can't test on your hardware. Such code generally suffers badly from bitrot
over time.

> >
> >> If the answer is Yes, then my second questions is:
> >>
> >> Assuming the comments / issues mentioned in #1 are addressed, are you
> >> really willing to stand up in front of the world-wide Kernel
> >> development community and justify why a driver that passes user-facing
> >> v4l2-compliance tests, is fairly clean, passes 99% of the reasonable
> >> checkpatch rules, is fully operational, cannot be merged? Really? Is
> >> this truly an illegal or inappropriate driver implementation that
> >> would prohibit mainline merge?
> >
> > Yes. Currently nobody else uses the ad7441 but the viewcast driver. So
> > splitting it up really shouldn't be too much of a problem: you don't have
> > to take care of anyone else, and it only has to support the functionality
> > that you need right now. And as long as nobody else uses that driver it
> > shouldn't make a difference to you maintenance-wise.
> 
> Fair enough.
> 
> >
> > But *if* someone else comes along then that will help them enormously if
> > an ad7441 driver already exists. We definitely do not want to have duplicate
> > drivers in the kernel for i2c devices, so either they or you would have to
> > split up the ad7441 driver from the ViewCast driver, and what are the chances
> > of that ever happening? Slim to none.
> >
> > You just want to get your driver merged, which is perfectly understandable,
> > but I also want to ensure that whatever gets merged can also be reused by
> > others, where applicable.
> >
> > In addition to that I have to say that I have been working with Analog Devices
> > i2c receivers and transmitters for the past 4-5 years, and these things are
> > complex. I consider it very unlikely that your ad7441 driver covers the full
> > functionality of the ad7441. By implementing it as a separate driver it will
> 
> Yes.
> 
> > be much easier for others to work on it and improve it. Yes, that might
> > require you to do the occasional testing, but hopefully that will improve the
> > functionality of the ViewCast driver as well by e.g. supporting more formats,
> > have better colorspace handling, or whatever.
> 
> <snip>
> 
> > Also note that the Analog Devices receivers/transmitters are fairly popular,
> > particularly within the embedded hardware world. So it wouldn't surprise me
> > at all if other products will appear that want to use it.
> 
> (7441 commentary removed)
> 
> Agreed.
> 
> >
> > BTW, we are talking about the adv7441a, right?
> > See here: http://ez.analog.com/docs/DOC-1546
> 
> Yes.
> 
> >
> > There is also a chip called ad7441, but that seems to be something else.
> > AD has the annoying habit of renaming chips, but at least they've started
> > making their datasheets freely available, which is very good news for linux.
> 
> Force of habit on my part, it's the adv7441a.

It would be nice if you can do a search and replace so that the correct name
is used in the sources.

And a comment in the source with the URL of the datasheets as I gave above
is very useful as well. Analog Devices did/are doing a good job when it comes
to publishing datasheets.

> >
> >> The ViewCast 820 is a (circa) $1800 video capture card. It's not the
> >> kind of hardware that everyone has laying around for regression
> >> testing purposes. If I 1) split this up and people begin to absorb
> >> ad7441 functionality into other designs, and start patching it and 2)
> >> adopt the subdev framework for that matter... then nobody is able to
> >> regression test the impact to the 820. That puts an incredible amount
> >> of burden on me. I'm attempting to mitigate all of this risk, but also
> >> provide a GPL driver so everyone can benefit - without creating a
> >> future maintenance / regression problem, by relying on subsystems the
> >> driver simply doesn't need.
> >
> > What you are basically saying is that you don't want to split it up because
> > if you do, then other people might reuse the code, change it, and might cause
> > you a lot of work.
> 
> Yes.
> 
> >
> > What I am saying is that if you split it up, then other people might reuse it,
> > improve it and with a relatively small amount of work improve the ViewCast
> > 820 support as well.
> 
> ... and it would require regression testing on every change.
> 
> >
> > I suspect your view of the amount of work it might cost you to test changes
> > from other people is too pessimistic. It's based on your experiences with the
> > cx25840, but from my perspective the cx25840 is the exception, not the rule.
> 
> My comments are largely influenced by the 25840, and we both agree
> we've stretched that driver too far and too thinly, beyond reasonable
> use - to the point where we're causing regressions even with small
> amounts of rework. In hindsight we all know not to let that happen
> again - but these things have a habit of slowly creeping up on you and
> they're a problem before you know it.
> 
> My goal is/was to head that off right at the outset, but without
> limiting anyone else by my actions. I've implemented just enough of
> the 7441 for what the 820 needs. A full blown subdev implementation
> (for all features) is beyond the 820 needs, out of scope. I'll take a
> shot at converting the limited functionality into a subdev as-is,
> let's see. If you accept that it's likely to be fairly 820 specific
> (not unreasonable to begin with) then that's a reasonable compromise.

As I mentioned above, that's a perfectly reasonable approach, and actually
one that I would recommend regardless.

I have a few remarks with regards to converting the 7441 driver to a subdev
driver: I recommend doing this last and fixing all other items first. The
reason is that you probably need two additional pieces of code. The first
is some additional API support to handle HDMI/DVI/etc. connectors correctly,
esp. with respect to hotplug support and EDID support. I'll post what is
hopefully the final pull request for this infrastructure tomorrow. See in the
meantime my hdmi3 tree:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/hdmi3

The other part is that there is no easy way at the moment to have a subdev
driver notify the bridge driver when a control changes value. This is relevant
for these adv drivers since the new API adds read-only status controls that
are updated whenever e.g. RX Sense detects power on an input. For embedded systems
you can simply receive a control event whenever those read-only controls change
value, but for a bridge driver there is no simple method to get that event.

It may not be a big deal for your driver since this tends to be more important
for transmitters, but it is something I have to fix regardless.

My plan is that the bridge driver's notify function (part of struct v4l2_device)
is called, but I need to do some refactoring in the event code to make that
possible. I want to work on that in the very near future since others need it
as well. The workaround at the moment would be to add a manual notify call
after updating the control's value.

> > And the cx25840 provides a good lesson how it may be counterproductive trying
> > to support multiple variants of a device in one driver. It only works if the
> > differences are really small, otherwise it is probably better to make separate
> > drivers, or make separate drivers, but have them share some common code. It's
> > something I'm considering for the adv drivers as I have two more drivers in
> > my queue that are similar, but not identical, to the adv7604 and ad9389b.
> 
> Agreed.
> 
> >
> > On the one hand, there is just too much identical code to justify two fully
> > independent drivers, but on the other hand there are too many differences as
> > well. I think it is possible to refactor out clearly common parts that do not
> > directly touch on registers. I don't know for certain yet, though.
> 
> It's tough. I air on the side of keeping the code reasonable and
> readable, easy to digest and support - even if it means small amounts
> of duplication. If the goal of LinuxTV is to welcome less experience
> video kernel developers then it's off-putting to have very abstract,
> scientific driver creations that can only be maintained by one or two
> people.
> 
> I don't know the 7604 or the 9389 but I'd suggest simple is better
> (for the rest of the group), unless they're 99% identical (unlikely).

Regards,

	Hans
