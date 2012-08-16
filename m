Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3129 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2HPSuw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 14:50:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Steven Toth <stoth@kernellabs.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
Date: Thu, 16 Aug 2012 20:49:35 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Linux-Media" <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com> <201208161649.43284.hverkuil@xs4all.nl> <CALzAhNWT3eNUNwNsGG_w+Jbz=ErRxogvv+_3GcKy8xZ+R-uZ=A@mail.gmail.com>
In-Reply-To: <CALzAhNWT3eNUNwNsGG_w+Jbz=ErRxogvv+_3GcKy8xZ+R-uZ=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208162049.35773.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu August 16 2012 19:39:51 Steven Toth wrote:
> >> So, I've ran v4l2-compliance and it pointed out a few things that I've
> >> fixed, but it also does a few things that (for some reason) I can't
> >> seem to catch. One particular test is on (iirc) s_fmt. It attempts to
> >> set ATSC but by ioctl callback never receives ATSC in the norm/id arg,
> >> it actually receives 0x0. This feels more like a bug in the test.
> >> Either way, I have some if (std & ATSC) return -EINVAL, but it still
> >> appears to fail the test.
> 
> Oddly enough. If I set tvnorms to something valid, then compliance
> passes but gstreamer
> fails to run, looks like some kind of confusion about either the
> current established
> norm, or a failure to establish a norm.
> 
> For the time being I've set tvnorms to 0 (with a comment) and removed
> current_norm.

Well, this needs to be sorted, because something is clearly amiss.

> >
> > I think it might be because vdev->tvnorms isn't set for the video node.
> > It's set for the VBI node, though. If tvnorms is 0, then ENUMSTD will
> > probably return an empty list, and that might be the cause of the ATSC
> > test. I also see that current_norm is used: don't do that. Instead store
> > the current standard yourself and return it in g_std. I'm slowly phasing
> > out current_norm because 1) it's ugly and 2) it doesn't work if you have
> > both a vbi and a video node.
> 
> Done.
> 
> >
> >> I see some tests which report failure (testing videobuf) but given
> >> that I essentially pass the ioctl directly into the videbug core, very
> >> much like every oher driver I've ever done, it's probably either a
> >> quirk of the tool, or something inside videobuf core itself that needs
> >> some adjustment. (userptr/mmap for capture or output buffers related
> >> test).
> >
> > videobuf does not follow the spec in several areas (most notably and extremely
> > annoyingly it does not support calling REQBUFS with a count of 0). So any
> > driver that uses videobuf will fail a number of tests in v4l2-compliance.
> 
> Compliance as of today (with changes), now gives:
> 
> "Buffer ioctls:
> 		fail: v4l2-test-buffers.cpp(76): can_stream && !mmap_valid && !userptr_valid
> 	test VIDIOC_REQBUFS/CREATE_BUFS: FAIL
> 	test read/write: OK"

Yeah, that's because videobuf is used instead of vb2.

<snip>

> In the meantime, here's the compliance report for the current driver:
> 
> http://git.kernellabs.com/?p=stoth/media_tree.git;a=shortlog;h=refs/heads/o820e
> 
> I have a couple of questions...
> 
> -bash-4.1$ ./v4l2-compliance -d /dev/video0
> Driver Info:
> 	Driver name   : vc8x0
> 	Card type     : ViewCast 820e
> 	Bus info      : PCIe:0000:02:00.0
> 	Driver version: 3.0.1
> 	Capabilities  : 0x84020001
> 		Video Capture
> 		Audio
> 		Streaming
> 		Device Capabilities
> 	Device Caps   : 0x04020001
> 		Video Capture
> 		Audio
> 		Streaming
> 
> Compliance test for device /dev/video0 (not using libv4l2):
> 
> Required ioctls:
> 	test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
> 	test second video open: OK
> 	test VIDIOC_QUERYCAP: OK
> 		fail: v4l2-compliance.cpp(323): doioctl(node, VIDIOC_G_PRIORITY, &prio)
> 	test VIDIOC_G/S_PRIORITY: FAIL
> 
> ^^^ If I read the compliance test correctly then I think this may be a
> bug in the tool. The driver doesn't support g_priority so why mark a
> failure?

The tool is more strict in some places than the spec is. One of those cases
is that is requires that priority handling is implemented. The reason for that
is 1) if you use the latest framework support (struct v4l2_fh in particular),
then you get priority handling for free by just setting a single bit, so there
is no excuse not to implement it, and 2) the reason few if any applications use
it is that too few drivers implemented it, so apps couldn't rely on it. It's
again a chicken and egg problem and the only way to improve matters is to have
a check that clearly tells you to add support for this.

> 
> 
> Debug ioctls:
> 	test VIDIOC_DBG_G_CHIP_IDENT: Not Supported
> 	test VIDIOC_DBG_G/S_REGISTER: Not Supported
> 	test VIDIOC_LOG_STATUS: Not Supported
> 
> 
> Debuggung was removed as part of removing the /proc support, but
> likely this will return in the form of the above
> calls when the next major rev of this 820 card ships (and the driver
> is subsequently asked to support a variation of the 820 hardware).

OK.

> Input ioctls:
> 	test VIDIOC_G/S_TUNER: Not Supported
> 	test VIDIOC_G/S_FREQUENCY: Not Supported
> 	test VIDIOC_S_HW_FREQ_SEEK: OK
> 	test VIDIOC_ENUMAUDIO: OK
> 	test VIDIOC_G/S/ENUMINPUT: OK
> 	test VIDIOC_G/S_AUDIO: OK
> 	Inputs: 7 Audio Inputs: 1 Tuners: 0
> 
> Output ioctls:
> 	test VIDIOC_G/S_MODULATOR: Not Supported
> 	test VIDIOC_G/S_FREQUENCY: Not Supported
> 	test VIDIOC_ENUMAUDOUT: Not Supported
> 	test VIDIOC_G/S/ENUMOUTPUT: Not Supported
> 	test VIDIOC_G/S_AUDOUT: Not Supported
> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Control ioctls:
> 		fail: v4l2-test-controls.cpp(275): does not support V4L2_CTRL_FLAG_NEXT_CTRL
> 	test VIDIOC_QUERYCTRL/MENU: FAIL
> 	test VIDIOC_G/S_CTRL: OK
> 	test VIDIOC_G/S/TRY_EXT_CTRLS: Not Supported
> 	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: Not Supported
> 	test VIDIOC_G/S_JPEGCOMP: Not Supported
> 	Standard Controls: 0 Private Controls: 0
> 
> ^^^ I'm not sure how to handle V4L2_CTRL_FLAG_NEXT_CTRL. I've read the
> spec a couple of times
> and I think I just don't get it. I don't have any ext ctrls and I
> think I'm returning EINVAL at the right moment.
> If it's not mandatory then why the FAIL?

This is another place where the tool is more strict than the spec: by requiring
that extended controls are also implemented it ensures a more consistent API
towards applications. By using the control framework you get all this for free,
so it is also a nice way of enforcing the use of the proper frameworks.

And you should use the control framework anyway: it's trivial for this driver
to implement.

By using struct v4l2_fh and the control framework you will get automatic support
for priority handling, control events and extended controls without having to
think about it.

> 
> Input/Output configuration ioctls:
> 		fail: v4l2-test-io-config.cpp(63): could set standard to ATSC, which
> is not supported anymore
> 		fail: v4l2-test-io-config.cpp(126): STD failed for input 0.
> 	test VIDIOC_ENUM/G/S/QUERY_STD: FAIL
> 	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: Not Supported
> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: Not Supported
> 	test VIDIOC_DV_TIMINGS_CAP: Not Supported
> 
> 
> ^^^ See my comments on gstreamer failing to operate if tvnorms is
> non-zero. I have a feeling something in
> the core objects to this. I tried NTSC, I also have g_std returning
> NTSC, but gstreamer refuses to negotiate
> a format/std unless 0 is specified..... And so the test fails. my
> s_std is passed 0 for the ID so while the code
> exists to EINVAL an attempt on setting ATSC, it's not triggering.

I would have to see the latest code, I guess.

> 
> Format ioctls:
> 		fail: v4l2-test-formats.cpp(252): duplicate format 56595559
> 	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL
> 
> ^^^ This is don't get. The compliance code implies you should never
> have a duplicate pixel format. Perhaps because I have multiple
> identical width/height formats with differing framerates and this
> confuses things.

ENUM_FMT returns duplicate formats, and it shouldn't do that.

With ENUM_FRAMESIZES you can enumerate the available framesizes for each
format, and with ENUM_FRAMEINTERVALS you enumerate the available framerates
for each format/size combination.

I know the spec doesn't say anything about whether enum_fmt can return duplicate
formats, but it makes no sense IMHO. Enumeration implies that you enumerate over
unique values.

> 
> 	test VIDIOC_G/S_PARM: OK
> 	test VIDIOC_G_FBUF: Not Supported
> 	test VIDIOC_G_FMT: OK
> 		fail: v4l2-test-formats.cpp(549): VBI Capture is valid, but no
> TRY_FMT was implemented
> 	test VIDIOC_TRY_FMT: FAIL
> 		fail: v4l2-test-formats.cpp(600): Video Capture is valid, but no
> S_FMT was implemented
> 	test VIDIOC_S_FMT: FAIL
> 	test VIDIOC_G_SLICED_VBI_CAP: Not Supported
> 
> ^^^ I've looked at the S_FMT many many times and tried a few
> workaround. effectively the compliance tool sets the struct to FF,
> passed ANY_FIELD and sets set. I refuse the call in the driver, which
> I think it's bogus. The Spec is unclear what to do but the compliance
> tool still fails. If you have thoughts on this then I'd appreciate it.

This is an area that will be clarified during the workshop. The question
is: can S_FMT ever return an error if you give it an invalid format. The
spec currently allows it, but it is my believe (and that of others as
well) that that should change. S_FMT (and TRY_FMT) should always return
some valid format and never an error (unless the type is wrong or streaming
is in progress and you can't change the format midstream).

The v4l2-compliance tool is currently assuming that behavior, so it sets
all fields with bogus values (and field to ANY to test whether the driver
can handle that value correctly), and checks whether it can do a S_FMT
without it returning an error.

> 
> Buffer ioctls:
> 		fail: v4l2-test-buffers.cpp(76): can_stream && !mmap_valid && !userptr_valid
> 	test VIDIOC_REQBUFS/CREATE_BUFS: FAIL
> 	test read/write:
> 	test read/write: OK
> 
> The tool shows: fail_on_test(can_stream && !mmap_valid && !userptr_valid);
> 
> ^^^^ I'm drawing a blank on this failure. I don't deal with either of
> these, they're deep in video buf. A bogus error, or something I've
> overlooked in videobuf1?

It's a consequence of using videobuf instead of vb2. This code is testing
REQBUFS with a count of 0, which isn't supported by videobuf. Switch to vb2
and this will work. It's one of the reasons why vb2 was made.

Regards,

	Hans

> 
> Total: 36, Succeeded: 29, Failed: 7, Warnings: 0
> 
> (VBI compliance has a couple more failures I'll take care of this afternoon).
> 
> Regards,
> 
> - Steve
> 
> 
