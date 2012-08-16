Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52962 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2HPN1w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 09:27:52 -0400
Received: by yhmm54 with SMTP id m54so2866904yhm.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 06:27:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201208151314.48007.hverkuil@xs4all.nl>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com>
	<50293B36.4060109@redhat.com>
	<CALzAhNV2A_CWp=dg0S-B2Ts50u+SjuuE-o48OzuaynNw86v-Dw@mail.gmail.com>
	<201208151314.48007.hverkuil@xs4all.nl>
Date: Thu, 16 Aug 2012 09:27:51 -0400
Message-ID: <CALzAhNWre7qB7OeU=rP1SGoBBHtsxXMsAOMbCPNXTQbmhJeYrw@mail.gmail.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> While I don't necessarily agree with Mauro that adoption of subdev is
>> "MANDATORY" (in the larger sense of the kernel driver development -
>> and common practices throughout the entire source base), I do hear and
>> value your comments and concerns from a peer review perspective.
>
> You're awfully polite for someone whose code has been shot down :-)
> Don't worry, I'll buy you a beer in San Diego to soften the pain (or to
> drown your sorrows!).

:)

It benefits everyone when rationale discussion can be had, even when
points of view differ. The alternative is we shout at each other over
email. Shouting gets old very quickly and never accomplishes anything.

>
>> 1) A handful of simple improvements have been suggested, Eg.
>> ioctl_unlocked, double-checking v4l2-compliance, try_fmt, /proc
>> removal, firmware loading etc
>>
>> Ack. I have no objections. Items like this are fairly trivial, easy to
>> address, I can absorb this and provide new patches quickly and easily.
>> I'll go back over the detailed comments this weekend and prepare
>> additional patches (and retest).
>
> Note that the v4l2-compliance tests are generally more strict than the
> spec itself. For example, it assumes that the control framework is used,
> that control events are implemented, and that vb2 is used.

I made some patches to the current tree to fixup some of the earlier
comments, firmware loading via nowait, unlocked_ioctl2, /proc removal.
I also ran the compliance testing tool. After realizing my version of
v4l2-compliance was a little out of date - and building fresh from
v4l2-utils, it turned out some highly useful information about the
driver.

So, I've ran v4l2-compliance and it pointed out a few things that I've
fixed, but it also does a few things that (for some reason) I can't
seem to catch. One particular test is on (iirc) s_fmt. It attempts to
set ATSC but by ioctl callback never receives ATSC in the norm/id arg,
it actually receives 0x0. This feels more like a bug in the test.
Either way, I have some if (std & ATSC) return -EINVAL, but it still
appears to fail the test.

I see some tests which report failure (testing videobuf) but given
that I essentially pass the ioctl directly into the videbug core, very
much like every oher driver I've ever done, it's probably either a
quirk of the tool, or something inside videobuf core itself that needs
some adjustment. (userptr/mmap for capture or output buffers related
test).

In summary, the v4l2-compliance tool has pointed out a few things that
were worth fixing for sure, and thus I've fixed. It it also feels like
the tool itself is still evolving. When I get a moment I'll run the
compliance tool and paste the results here for comment.

I'd welcome your feedback on the compliance feedback.

>
> Take a look at vivi.c: it implements all the latest infrastructure and it
> is now actually a pretty good example of how things should work.

Noted, that's a useful reference point.

>
> It's also one of the few drivers that passes all v4l2-compliance tests.
>
> The only ioctls that aren't covered yet by v4l2-compliance are:
>
>            VIDIOC_CROPCAP, VIDIOC_G/S_CROP, VIDIOC_G/S_SELECTION
>            VIDIOC_S_FBUF/OVERLAY
>            VIDIOC_(TRY_)ENCODER_CMD
>            VIDIOC_(TRY_)DECODER_CMD
>            VIDIOC_G_ENC_INDEX
>            VIDIOC_QBUF/DQBUF/QUERYBUF/PREPARE_BUFS
>            VIDIOC_STREAMON/OFF
>
> So basically cropping, compression encoder/decoder control and actual
> streaming. And the subdev and media API is also not tested, although
> those might be beyond the scope of this utility anyway.
>
> Everything else is now tested fairly exhaustively.
>
>> 2) ... and some larger discussion items have been raised, Eg.
>> Absorbing more of the V4L2 kernel infrastructure into the vc8x0 driver
>> vs a fairly self-contained driver with very limited opportunities for
>> future breakage.
>>
>> Are you really willing to say that all drivers, with unique and new
>> pieces of silicon, need to be split out into independent modules,
>> adopting a subdev type interfaces or mainline merge is refused? It's
>> not that I'm asking you to merge duplicate functionality, duplicate
>> driver code, replicating functionality for new hardware or for an
>> existing modules (tuner/demod/whatever). (Like has already happened in
>> the past - 18271 for example).
>
> Speaking for myself, I would probably NACK it, yes. I would hate to do it,
> but there are IMHO good technical reasons why the ad7441 code should be
> implemented as a subdev driver.

I hear you. In the spirit of co-operation I'll take a shot at turning
ad7441 into a subdev and see what odd problems shake out of the
process. I should be clear that the resulting subdevice will likely be
very 820 specific in terms of configuration, but it's a reasonable
cut-point.

>
>> If the answer is Yes, then my second questions is:
>>
>> Assuming the comments / issues mentioned in #1 are addressed, are you
>> really willing to stand up in front of the world-wide Kernel
>> development community and justify why a driver that passes user-facing
>> v4l2-compliance tests, is fairly clean, passes 99% of the reasonable
>> checkpatch rules, is fully operational, cannot be merged? Really? Is
>> this truly an illegal or inappropriate driver implementation that
>> would prohibit mainline merge?
>
> Yes. Currently nobody else uses the ad7441 but the viewcast driver. So
> splitting it up really shouldn't be too much of a problem: you don't have
> to take care of anyone else, and it only has to support the functionality
> that you need right now. And as long as nobody else uses that driver it
> shouldn't make a difference to you maintenance-wise.

Fair enough.

>
> But *if* someone else comes along then that will help them enormously if
> an ad7441 driver already exists. We definitely do not want to have duplicate
> drivers in the kernel for i2c devices, so either they or you would have to
> split up the ad7441 driver from the ViewCast driver, and what are the chances
> of that ever happening? Slim to none.
>
> You just want to get your driver merged, which is perfectly understandable,
> but I also want to ensure that whatever gets merged can also be reused by
> others, where applicable.
>
> In addition to that I have to say that I have been working with Analog Devices
> i2c receivers and transmitters for the past 4-5 years, and these things are
> complex. I consider it very unlikely that your ad7441 driver covers the full
> functionality of the ad7441. By implementing it as a separate driver it will

Yes.

> be much easier for others to work on it and improve it. Yes, that might
> require you to do the occasional testing, but hopefully that will improve the
> functionality of the ViewCast driver as well by e.g. supporting more formats,
> have better colorspace handling, or whatever.

<snip>

> Also note that the Analog Devices receivers/transmitters are fairly popular,
> particularly within the embedded hardware world. So it wouldn't surprise me
> at all if other products will appear that want to use it.

(7441 commentary removed)

Agreed.

>
> BTW, we are talking about the adv7441a, right?
> See here: http://ez.analog.com/docs/DOC-1546

Yes.

>
> There is also a chip called ad7441, but that seems to be something else.
> AD has the annoying habit of renaming chips, but at least they've started
> making their datasheets freely available, which is very good news for linux.

Force of habit on my part, it's the adv7441a.

>
>> The ViewCast 820 is a (circa) $1800 video capture card. It's not the
>> kind of hardware that everyone has laying around for regression
>> testing purposes. If I 1) split this up and people begin to absorb
>> ad7441 functionality into other designs, and start patching it and 2)
>> adopt the subdev framework for that matter... then nobody is able to
>> regression test the impact to the 820. That puts an incredible amount
>> of burden on me. I'm attempting to mitigate all of this risk, but also
>> provide a GPL driver so everyone can benefit - without creating a
>> future maintenance / regression problem, by relying on subsystems the
>> driver simply doesn't need.
>
> What you are basically saying is that you don't want to split it up because
> if you do, then other people might reuse the code, change it, and might cause
> you a lot of work.

Yes.

>
> What I am saying is that if you split it up, then other people might reuse it,
> improve it and with a relatively small amount of work improve the ViewCast
> 820 support as well.

... and it would require regression testing on every change.

>
> I suspect your view of the amount of work it might cost you to test changes
> from other people is too pessimistic. It's based on your experiences with the
> cx25840, but from my perspective the cx25840 is the exception, not the rule.

My comments are largely influenced by the 25840, and we both agree
we've stretched that driver too far and too thinly, beyond reasonable
use - to the point where we're causing regressions even with small
amounts of rework. In hindsight we all know not to let that happen
again - but these things have a habit of slowly creeping up on you and
they're a problem before you know it.

My goal is/was to head that off right at the outset, but without
limiting anyone else by my actions. I've implemented just enough of
the 7441 for what the 820 needs. A full blown subdev implementation
(for all features) is beyond the 820 needs, out of scope. I'll take a
shot at converting the limited functionality into a subdev as-is,
let's see. If you accept that it's likely to be fairly 820 specific
(not unreasonable to begin with) then that's a reasonable compromise.

>
> And the cx25840 provides a good lesson how it may be counterproductive trying
> to support multiple variants of a device in one driver. It only works if the
> differences are really small, otherwise it is probably better to make separate
> drivers, or make separate drivers, but have them share some common code. It's
> something I'm considering for the adv drivers as I have two more drivers in
> my queue that are similar, but not identical, to the adv7604 and ad9389b.

Agreed.

>
> On the one hand, there is just too much identical code to justify two fully
> independent drivers, but on the other hand there are too many differences as
> well. I think it is possible to refactor out clearly common parts that do not
> directly touch on registers. I don't know for certain yet, though.

It's tough. I air on the side of keeping the code reasonable and
readable, easy to digest and support - even if it means small amounts
of duplication. If the goal of LinuxTV is to welcome less experience
video kernel developers then it's off-putting to have very abstract,
scientific driver creations that can only be maintained by one or two
people.

I don't know the 7604 or the 9389 but I'd suggest simple is better
(for the rest of the group), unless they're 99% identical (unlikely).

>
>> As always, I do welcome and appreciate your comments and thoughts, no
>> flames from me. I do find the 'MANDATORY' comments worthy of
>> discussion, or perhaps I've miss-understood something.
>
> No, you understood it perfectly :-)

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
