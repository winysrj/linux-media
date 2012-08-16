Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50405 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab2HPRjz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 13:39:55 -0400
Received: by qaas11 with SMTP id s11so812548qaa.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 10:39:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201208161649.43284.hverkuil@xs4all.nl>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com>
	<201208151314.48007.hverkuil@xs4all.nl>
	<CALzAhNWre7qB7OeU=rP1SGoBBHtsxXMsAOMbCPNXTQbmhJeYrw@mail.gmail.com>
	<201208161649.43284.hverkuil@xs4all.nl>
Date: Thu, 16 Aug 2012 13:39:51 -0400
Message-ID: <CALzAhNWT3eNUNwNsGG_w+Jbz=ErRxogvv+_3GcKy8xZ+R-uZ=A@mail.gmail.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> So, I've ran v4l2-compliance and it pointed out a few things that I've
>> fixed, but it also does a few things that (for some reason) I can't
>> seem to catch. One particular test is on (iirc) s_fmt. It attempts to
>> set ATSC but by ioctl callback never receives ATSC in the norm/id arg,
>> it actually receives 0x0. This feels more like a bug in the test.
>> Either way, I have some if (std & ATSC) return -EINVAL, but it still
>> appears to fail the test.

Oddly enough. If I set tvnorms to something valid, then compliance
passes but gstreamer
fails to run, looks like some kind of confusion about either the
current established
norm, or a failure to establish a norm.

For the time being I've set tvnorms to 0 (with a comment) and removed
current_norm.

>
> I think it might be because vdev->tvnorms isn't set for the video node.
> It's set for the VBI node, though. If tvnorms is 0, then ENUMSTD will
> probably return an empty list, and that might be the cause of the ATSC
> test. I also see that current_norm is used: don't do that. Instead store
> the current standard yourself and return it in g_std. I'm slowly phasing
> out current_norm because 1) it's ugly and 2) it doesn't work if you have
> both a vbi and a video node.

Done.

>
>> I see some tests which report failure (testing videobuf) but given
>> that I essentially pass the ioctl directly into the videbug core, very
>> much like every oher driver I've ever done, it's probably either a
>> quirk of the tool, or something inside videobuf core itself that needs
>> some adjustment. (userptr/mmap for capture or output buffers related
>> test).
>
> videobuf does not follow the spec in several areas (most notably and extremely
> annoyingly it does not support calling REQBUFS with a count of 0). So any
> driver that uses videobuf will fail a number of tests in v4l2-compliance.

Compliance as of today (with changes), now gives:

"Buffer ioctls:
		fail: v4l2-test-buffers.cpp(76): can_stream && !mmap_valid && !userptr_valid
	test VIDIOC_REQBUFS/CREATE_BUFS: FAIL
	test read/write: OK"


>
> These problems are fixed in vb2, which is why I strongly recommend its use in
> new drivers. In addition, work on the new DMABUF mechanism for sharing buffers
> between v4l2 and drm will only be implemented in vb2.
>
>> In summary, the v4l2-compliance tool has pointed out a few things that
>> were worth fixing for sure, and thus I've fixed. It it also feels like
>> the tool itself is still evolving. When I get a moment I'll run the
>> compliance tool and paste the results here for comment.
>
> It is steadily being improved, that's correct.
>
> BTW, don't forget to also run it for the vbi node (option '-V /dev/vbiX').

It's got a couple more failures I need to take care of, nothing huge.

>
> Feedback on the tool is very much appreciated! E.g. how to improve it, whether
> there are missing, confusing or incorrect tests, etc.
>
>> I'd welcome your feedback on the compliance feedback.
>
> No problem. One set of errors that v4l2-compliance produces is that it fails
> if you can change VBI formats using a video node or vice versa. I want to
> address that in the V4L2 core rather than having to fix all drivers. It's one
> of the topics in the V4L2 ambiguities list for the upcoming workshop.
>
>> > Take a look at vivi.c: it implements all the latest infrastructure and it
>> > is now actually a pretty good example of how things should work.
>>
>> Noted, that's a useful reference point.
>>
>> >
>> > It's also one of the few drivers that passes all v4l2-compliance tests.
>> >
>> > The only ioctls that aren't covered yet by v4l2-compliance are:
>> >
>> >            VIDIOC_CROPCAP, VIDIOC_G/S_CROP, VIDIOC_G/S_SELECTION
>> >            VIDIOC_S_FBUF/OVERLAY
>> >            VIDIOC_(TRY_)ENCODER_CMD
>> >            VIDIOC_(TRY_)DECODER_CMD
>> >            VIDIOC_G_ENC_INDEX
>> >            VIDIOC_QBUF/DQBUF/QUERYBUF/PREPARE_BUFS
>> >            VIDIOC_STREAMON/OFF
>> >
>> > So basically cropping, compression encoder/decoder control and actual
>> > streaming. And the subdev and media API is also not tested, although
>> > those might be beyond the scope of this utility anyway.
>> >
>> > Everything else is now tested fairly exhaustively.
>> >
>> >> 2) ... and some larger discussion items have been raised, Eg.
>> >> Absorbing more of the V4L2 kernel infrastructure into the vc8x0 driver
>> >> vs a fairly self-contained driver with very limited opportunities for
>> >> future breakage.
>> >>
>> >> Are you really willing to say that all drivers, with unique and new
>> >> pieces of silicon, need to be split out into independent modules,
>> >> adopting a subdev type interfaces or mainline merge is refused? It's
>> >> not that I'm asking you to merge duplicate functionality, duplicate
>> >> driver code, replicating functionality for new hardware or for an
>> >> existing modules (tuner/demod/whatever). (Like has already happened in
>> >> the past - 18271 for example).
>> >
>> > Speaking for myself, I would probably NACK it, yes. I would hate to do it,
>> > but there are IMHO good technical reasons why the ad7441 code should be
>> > implemented as a subdev driver.
>>
>> I hear you. In the spirit of co-operation I'll take a shot at turning
>> ad7441 into a subdev and see what odd problems shake out of the
>> process. I should be clear that the resulting subdevice will likely be
>> very 820 specific in terms of configuration, but it's a reasonable
>> cut-point.
>
> That's a perfectly valid approach. Frankly, I think it is counter productive
> to try and make a more general implementation. You only end up with code that
> you can't test on your hardware. Such code generally suffers badly from bitrot
> over time.
>
>> >
>> >> If the answer is Yes, then my second questions is:
>> >>
>> >> Assuming the comments / issues mentioned in #1 are addressed, are you
>> >> really willing to stand up in front of the world-wide Kernel
>> >> development community and justify why a driver that passes user-facing
>> >> v4l2-compliance tests, is fairly clean, passes 99% of the reasonable
>> >> checkpatch rules, is fully operational, cannot be merged? Really? Is
>> >> this truly an illegal or inappropriate driver implementation that
>> >> would prohibit mainline merge?
>> >
>> > Yes. Currently nobody else uses the ad7441 but the viewcast driver. So
>> > splitting it up really shouldn't be too much of a problem: you don't have
>> > to take care of anyone else, and it only has to support the functionality
>> > that you need right now. And as long as nobody else uses that driver it
>> > shouldn't make a difference to you maintenance-wise.
>>
>> Fair enough.
>>
>> >
>> > But *if* someone else comes along then that will help them enormously if
>> > an ad7441 driver already exists. We definitely do not want to have duplicate
>> > drivers in the kernel for i2c devices, so either they or you would have to
>> > split up the ad7441 driver from the ViewCast driver, and what are the chances
>> > of that ever happening? Slim to none.
>> >
>> > You just want to get your driver merged, which is perfectly understandable,
>> > but I also want to ensure that whatever gets merged can also be reused by
>> > others, where applicable.
>> >
>> > In addition to that I have to say that I have been working with Analog Devices
>> > i2c receivers and transmitters for the past 4-5 years, and these things are
>> > complex. I consider it very unlikely that your ad7441 driver covers the full
>> > functionality of the ad7441. By implementing it as a separate driver it will
>>
>> Yes.
>>
>> > be much easier for others to work on it and improve it. Yes, that might
>> > require you to do the occasional testing, but hopefully that will improve the
>> > functionality of the ViewCast driver as well by e.g. supporting more formats,
>> > have better colorspace handling, or whatever.
>>
>> <snip>
>>
>> > Also note that the Analog Devices receivers/transmitters are fairly popular,
>> > particularly within the embedded hardware world. So it wouldn't surprise me
>> > at all if other products will appear that want to use it.
>>
>> (7441 commentary removed)
>>
>> Agreed.
>>
>> >
>> > BTW, we are talking about the adv7441a, right?
>> > See here: http://ez.analog.com/docs/DOC-1546
>>
>> Yes.
>>
>> >
>> > There is also a chip called ad7441, but that seems to be something else.
>> > AD has the annoying habit of renaming chips, but at least they've started
>> > making their datasheets freely available, which is very good news for linux.
>>
>> Force of habit on my part, it's the adv7441a.
>
> It would be nice if you can do a search and replace so that the correct name
> is used in the sources.

Yeah, I'll take of that.

>
> And a comment in the source with the URL of the datasheets as I gave above
> is very useful as well. Analog Devices did/are doing a good job when it comes
> to publishing datasheets.
>
>> >
>> >> The ViewCast 820 is a (circa) $1800 video capture card. It's not the
>> >> kind of hardware that everyone has laying around for regression
>> >> testing purposes. If I 1) split this up and people begin to absorb
>> >> ad7441 functionality into other designs, and start patching it and 2)
>> >> adopt the subdev framework for that matter... then nobody is able to
>> >> regression test the impact to the 820. That puts an incredible amount
>> >> of burden on me. I'm attempting to mitigate all of this risk, but also
>> >> provide a GPL driver so everyone can benefit - without creating a
>> >> future maintenance / regression problem, by relying on subsystems the
>> >> driver simply doesn't need.
>> >
>> > What you are basically saying is that you don't want to split it up because
>> > if you do, then other people might reuse the code, change it, and might cause
>> > you a lot of work.
>>
>> Yes.
>>
>> >
>> > What I am saying is that if you split it up, then other people might reuse it,
>> > improve it and with a relatively small amount of work improve the ViewCast
>> > 820 support as well.
>>
>> ... and it would require regression testing on every change.
>>
>> >
>> > I suspect your view of the amount of work it might cost you to test changes
>> > from other people is too pessimistic. It's based on your experiences with the
>> > cx25840, but from my perspective the cx25840 is the exception, not the rule.
>>
>> My comments are largely influenced by the 25840, and we both agree
>> we've stretched that driver too far and too thinly, beyond reasonable
>> use - to the point where we're causing regressions even with small
>> amounts of rework. In hindsight we all know not to let that happen
>> again - but these things have a habit of slowly creeping up on you and
>> they're a problem before you know it.
>>
>> My goal is/was to head that off right at the outset, but without
>> limiting anyone else by my actions. I've implemented just enough of
>> the 7441 for what the 820 needs. A full blown subdev implementation
>> (for all features) is beyond the 820 needs, out of scope. I'll take a
>> shot at converting the limited functionality into a subdev as-is,
>> let's see. If you accept that it's likely to be fairly 820 specific
>> (not unreasonable to begin with) then that's a reasonable compromise.
>
> As I mentioned above, that's a perfectly reasonable approach, and actually
> one that I would recommend regardless.
>
> I have a few remarks with regards to converting the 7441 driver to a subdev
> driver: I recommend doing this last and fixing all other items first. The
> reason is that you probably need two additional pieces of code. The first
> is some additional API support to handle HDMI/DVI/etc. connectors correctly,
> esp. with respect to hotplug support and EDID support. I'll post what is
> hopefully the final pull request for this infrastructure tomorrow. See in the
> meantime my hdmi3 tree:

Noted.

In the meantime, here's the compliance report for the current driver:

http://git.kernellabs.com/?p=stoth/media_tree.git;a=shortlog;h=refs/heads/o820e

I have a couple of questions...

-bash-4.1$ ./v4l2-compliance -d /dev/video0
Driver Info:
	Driver name   : vc8x0
	Card type     : ViewCast 820e
	Bus info      : PCIe:0000:02:00.0
	Driver version: 3.0.1
	Capabilities  : 0x84020001
		Video Capture
		Audio
		Streaming
		Device Capabilities
	Device Caps   : 0x04020001
		Video Capture
		Audio
		Streaming

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
		fail: v4l2-compliance.cpp(323): doioctl(node, VIDIOC_G_PRIORITY, &prio)
	test VIDIOC_G/S_PRIORITY: FAIL

^^^ If I read the compliance test correctly then I think this may be a
bug in the tool. The driver doesn't support g_priority so why mark a
failure?


Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: Not Supported
	test VIDIOC_DBG_G/S_REGISTER: Not Supported
	test VIDIOC_LOG_STATUS: Not Supported


Debuggung was removed as part of removing the /proc support, but
likely this will return in the form of the above
calls when the next major rev of this 820 card ships (and the driver
is subsequently asked to support a variation of the 820 hardware).

Input ioctls:
	test VIDIOC_G/S_TUNER: Not Supported
	test VIDIOC_G/S_FREQUENCY: Not Supported
	test VIDIOC_S_HW_FREQ_SEEK: OK
	test VIDIOC_ENUMAUDIO: OK
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK
	Inputs: 7 Audio Inputs: 1 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: Not Supported
	test VIDIOC_G/S_FREQUENCY: Not Supported
	test VIDIOC_ENUMAUDOUT: Not Supported
	test VIDIOC_G/S/ENUMOUTPUT: Not Supported
	test VIDIOC_G/S_AUDOUT: Not Supported
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
		fail: v4l2-test-controls.cpp(275): does not support V4L2_CTRL_FLAG_NEXT_CTRL
	test VIDIOC_QUERYCTRL/MENU: FAIL
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: Not Supported
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: Not Supported
	test VIDIOC_G/S_JPEGCOMP: Not Supported
	Standard Controls: 0 Private Controls: 0

^^^ I'm not sure how to handle V4L2_CTRL_FLAG_NEXT_CTRL. I've read the
spec a couple of times
and I think I just don't get it. I don't have any ext ctrls and I
think I'm returning EINVAL at the right moment.
If it's not mandatory then why the FAIL?

Input/Output configuration ioctls:
		fail: v4l2-test-io-config.cpp(63): could set standard to ATSC, which
is not supported anymore
		fail: v4l2-test-io-config.cpp(126): STD failed for input 0.
	test VIDIOC_ENUM/G/S/QUERY_STD: FAIL
	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: Not Supported
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: Not Supported
	test VIDIOC_DV_TIMINGS_CAP: Not Supported


^^^ See my comments on gstreamer failing to operate if tvnorms is
non-zero. I have a feeling something in
the core objects to this. I tried NTSC, I also have g_std returning
NTSC, but gstreamer refuses to negotiate
a format/std unless 0 is specified..... And so the test fails. my
s_std is passed 0 for the ID so while the code
exists to EINVAL an attempt on setting ATSC, it's not triggering.

Format ioctls:
		fail: v4l2-test-formats.cpp(252): duplicate format 56595559
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL

^^^ This is don't get. The compliance code implies you should never
have a duplicate pixel format. Perhaps because I have multiple
identical width/height formats with differing framerates and this
confuses things.

	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: Not Supported
	test VIDIOC_G_FMT: OK
		fail: v4l2-test-formats.cpp(549): VBI Capture is valid, but no
TRY_FMT was implemented
	test VIDIOC_TRY_FMT: FAIL
		fail: v4l2-test-formats.cpp(600): Video Capture is valid, but no
S_FMT was implemented
	test VIDIOC_S_FMT: FAIL
	test VIDIOC_G_SLICED_VBI_CAP: Not Supported

^^^ I've looked at the S_FMT many many times and tried a few
workaround. effectively the compliance tool sets the struct to FF,
passed ANY_FIELD and sets set. I refuse the call in the driver, which
I think it's bogus. The Spec is unclear what to do but the compliance
tool still fails. If you have thoughts on this then I'd appreciate it.

Buffer ioctls:
		fail: v4l2-test-buffers.cpp(76): can_stream && !mmap_valid && !userptr_valid
	test VIDIOC_REQBUFS/CREATE_BUFS: FAIL
	test read/write:
	test read/write: OK

The tool shows: fail_on_test(can_stream && !mmap_valid && !userptr_valid);

^^^^ I'm drawing a blank on this failure. I don't deal with either of
these, they're deep in video buf. A bogus error, or something I've
overlooked in videobuf1?

Total: 36, Succeeded: 29, Failed: 7, Warnings: 0

(VBI compliance has a couple more failures I'll take care of this afternoon).

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
